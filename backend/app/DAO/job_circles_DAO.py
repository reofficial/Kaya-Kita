from motor.motor_asyncio import AsyncIOMotorDatabase
from app.classes import JobCircles
from fastapi.encoders import jsonable_encoder
from fastapi.responses import JSONResponse
class JobCirclesDAO:
    def __init__(self, db: AsyncIOMotorDatabase):
        self.collection = db["JobCircles"]
        
    #CRUD Operations
    async def create_job_circle(self, job_circle: JobCircles):
        # Automatically assigns job id
        last_job = await self.collection.find_one(
            {}, sort=[("ticket_number", -1)]
        )
        new_id = (last_job["ticket_number"] + 1) if last_job else 0

        job_data = job_circle.model_dump()
        job_data["ticket_number"] = new_id

        await self.collection.insert_one(job_data)
        return JSONResponse(status_code=201, content=jsonable_encoder(JobCircles(**job_data)))
    
    async def read_job_circles(self):
        job_circles_cursor = self.collection.find()
        job_circles = await job_circles_cursor.to_list(length=None)
        return jsonable_encoder([JobCircles(**job_circle) for job_circle in job_circles])
    
    async def read_job_circles_by_username(self, username: str):
        # Fetch all job listings that match the provided username.
        job_circles_cursor = self.collection.find({"username": username})
        job_circles = await job_circles_cursor.to_list(length=None)
        return jsonable_encoder([JobCircles(**job_circle) for job_circle in job_circles])
    
    async def read_job_circles_by_worker_username(self, username: str):
        # Fetch all job listings that match the provided username.
        job_circles_cursor = self.collection.find({"worker_username": username})
        job_circles = await job_circles_cursor.to_list(length=None)
        return jsonable_encoder([JobCircles(**job_circle) for job_circle in job_circles])
    
    async def read_job_circle_by_id(self, ticket_number: int):
        job_circles_cursor = self.collection.find({"ticket_number": ticket_number})
        job_circles = await job_circles_cursor.to_list(length=None)
        return jsonable_encoder([JobCircles(**job_circle) for job_circle in job_circles])
    
    async def update_job_circle(self, job_circle: JobCircles):
        job_data = job_circle.model_dump()
        ticket_number = job_data.pop("ticket_number")

        result = await self.collection.update_one(
            {"ticket_number": ticket_number},
            {"$set": job_data}
        )

        return result.modified_count > 0 #returns true if we updated something
    
    async def delete_job_circle(self, ticket_number: int):
        result = await self.collection.delete_one({"ticket_number": ticket_number})
        return result.deleted_count > 0  # Returns True if a document was deleted