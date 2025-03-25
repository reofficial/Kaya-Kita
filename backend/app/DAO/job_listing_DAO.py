from motor.motor_asyncio import AsyncIOMotorDatabase
from app.classes import JobListing

class JobListingDAO:
    def __init__(self, db: AsyncIOMotorDatabase):
        self.collection = db["JobListing"]
        
    #CRUD Operations
    async def create_job_listing(self, job_listing: JobListing):
        # Automatically assigns job id
        last_job = await self.collection.find_one(
            {}, sort=[("job_id", -1)]
        )
        new_id = (last_job["job_id"] + 1) if last_job else 0

        job_data = job_listing.model_dump()
        job_data["job_id"] = new_id

        await self.collection.insert_one(job_data)
        return JobListing(**job_data)
    
    async def read_job_listings(self):
        job_listings_cursor = self.collection.find()
        job_listings = await job_listings_cursor.to_list(length=None)
        return [JobListing(**job_listing) for job_listing in job_listings]
    
    async def read_job_listings_by_username(self, username: str):
        # Fetch all job listings that match the provided username.
        job_listings_cursor = self.collection.find({"username": username})
        job_listings = await job_listings_cursor.to_list(length=None)
        return [JobListing(**job_listing) for job_listing in job_listings]
    
    async def read_job_listings_by_worker_username(self, username: str):
        # Fetch all job listings that match the provided username.
        job_listings_cursor = self.collection.find({"worker_username": username})
        job_listings = await job_listings_cursor.to_list(length=None)
        return [JobListing(**job_listing) for job_listing in job_listings]
    
    async def read_job_listing_by_id(self, job_id: int):
        job_listings_cursor = self.collection.find({"job_id": job_id})
        job_listings = await job_listings_cursor.to_list(length=None)
        return [JobListing(**job_listing) for job_listing in job_listings]
    
    async def check_if_info_has_content(self, job_listing: JobListing):
        return bool(job_listing.job_title or job_listing.description or job_listing.location or job_listing.salary)
    
    async def update_job_listing(self, job_id: int, update_data: dict):
        print(f"[DAO] Starting update for job_id: {job_id}")
        job_status = update_data.get("job_status")
        if "worker_username" in update_data and update_data["worker_username"] is not None:
            new_workers = update_data["worker_username"]
            print(f"[DAO] New worker_username value: {new_workers}")

            # Retrieve the existing job listing from the database
            existing_listing = await self.collection.find_one({"job_id": job_id})
            print(f"[DAO] Existing listing: {existing_listing}")
            if existing_listing is None:
                print(f"[DAO] Job listing not found for job_id: {job_id}")
                return False  # job listing not found

            # Use the model to parse the existing data, ensuring proper types
            existing_job = JobListing(**existing_listing)
            print(f"[DAO] Parsed existing job: {existing_job}")

            if job_status == "ongoing":
                # For accepted, replace the list with the new worker(s)
                print(f"[DAO] Job status accepted, replacing worker_username with {new_workers}")
                update_data["worker_username"] = new_workers
            elif job_status == "pending":
                # For ongoing, merge new workers with the existing list
                existing_workers = existing_job.worker_username or []
                print(f"[DAO] Existing workers: {existing_workers}")
                merged_workers = existing_workers.copy()
                for worker in new_workers:
                    if worker not in merged_workers:
                        merged_workers.append(worker)
                print(f"[DAO] Merged workers list: {merged_workers}")
                update_data["worker_username"] = merged_workers
            else:
                # For any other job_status, simply update with the new list
                print(f"[DAO] Job status not recognized, updating worker_username with {new_workers}")
                update_data["worker_username"] = new_workers

        print(f"[DAO] Final update_data to be set: {update_data}")
        result = await self.collection.update_one(
            {"job_id": job_id},
            {"$set": update_data}
        )
        print(f"[DAO] Update result - modified_count: {result.modified_count}, matched_count: {result.matched_count}")
        
        # Consider the update successful if the document was matched,
        # even if modified_count is 0 (because the data didn't actually change).
        if result.matched_count > 0:
            return True
        return False
    
    async def delete_job_listing(self, job_id: int):
        result = await self.collection.delete_one({"job_id": job_id})
        return result.deleted_count > 0  # Returns True if a document was deleted