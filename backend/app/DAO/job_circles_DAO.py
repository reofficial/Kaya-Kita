from motor.motor_asyncio import AsyncIOMotorDatabase
from app.classes import JobCircles

class JobCirclesDAO:
    def __init__(self, db: AsyncIOMotorDatabase):
        self.collection = db["JobCircles"]
        
    #CRUD Operations
    async def create_job_circle(self, job_circle: JobCircles):
        # Automatically assigns job id
        last_job = await self.collection.find_one(
            {}, sort=[("job_id", -1)]
        )
        new_id = (last_job["job_id"] + 1) if last_job else 0

        job_data = job_circle.model_dump()
        job_data["job_id"] = new_id

        await self.collection.insert_one(job_data)
        return JobCircles(**job_data)
    
    async def read_job_circles(self):
        job_circles_cursor = self.collection.find()
        job_circles = await job_circles_cursor.to_list(length=None)
        return [JobCircles(**job_circle) for job_circle in job_circles]
    
    async def read_job_circles_by_username(self, username: str):
        # Fetch all job listings that match the provided username.
        job_circles_cursor = self.collection.find({"username": username})
        job_circles = await job_circles_cursor.to_list(length=None)
        return [JobCircles(**job_circle) for job_circle in job_circles]
    
    async def read_job_circles_by_worker_username(self, username: str):
        # Fetch all job listings that match the provided username.
        job_circles_cursor = self.collection.find({"worker_username": username})
        job_circles = await job_circles_cursor.to_list(length=None)
        return [JobCircles(**job_circle) for job_circle in job_circles]
    
    async def read_job_circle_by_id(self, job_id: int):
        job_circles_cursor = self.collection.find({"job_id": job_id})
        job_circles = await job_circles_cursor.to_list(length=None)
        return [JobCircles(**job_circle) for job_circle in job_circles]
    
    async def update_job_circle(self, job_circle: JobCircles):
        job_data = job_circle.model_dump()
        job_id = job_data.pop("job_id")

        result = await self.collection.update_one(
            {"job_id": job_id},
            {"$set": job_data}
        )

        return result.modified_count > 0 #returns true if we updated something
    
    async def delete_job_circle(self, job_id: int):
        result = await self.collection.delete_one({"job_id": job_id})
        return result.deleted_count > 0  # Returns True if a document was deleted