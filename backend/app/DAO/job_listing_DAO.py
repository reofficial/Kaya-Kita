from motor.motor_asyncio import AsyncIOMotorDatabase
from app.classes import JobListing
from typing import List, Optional

class JobListingDAO:
    def __init__(self, db: AsyncIOMotorDatabase):
        self.collection = db["JobListing"]
        
    #CRUD Operations
    async def create_job_listing(self, job_listing: JobListing):
        # Automatically assigns job id
        last_job = await self.collection.find_one(
            {}, sort=[("job_id", -1)]
        )
        new_id = (last_job["id"] + 1) if last_job else 0

        job_data = job_listing.model_dump()
        job_data["job_id"] = new_id

        await self.collection.insert_one(job_data)
    
    async def read_job_listings(self):
        job_listings_cursor = self.collection.find()
        job_listings = await job_listings_cursor.to_list(length=None)
        return [JobListing(**job_listing) for job_listing in job_listings]
    
    async def check_if_info_has_content(self, job_listing: JobListing):
        return bool(job_listing.job_title or job_listing.description or job_listing.location or job_listing.salary)
    
    async def update_job_listing(self, job_listing: JobListing):
        job_data = job_listing.model_dump()
        job_id = job_data.pop("job_id")

        result = await self.collection.update_one(
            {"id": job_id},
            {"$set": job_data}
        )

        return result.modified_count > 0 #returns true if we updated something
    
    async def delete_job_listing(self, job_listing: JobListing):
        result = await self.collection.delete_one({"id": job_listing.job_id})
        return result.deleted_count > 0