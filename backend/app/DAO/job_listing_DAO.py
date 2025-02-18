from motor.motor_asyncio import AsyncIOMotorDatabase
from app.classes import JobListing
from typing import List, Optional

class JobListingDAO:
    def __init__(self, db: AsyncIOMotorDatabase):
        self.collection = db["JobListing"]
        
    #CRUD Operations
    async def create_job_listing(self, job_listing: JobListing):
        await self.collection.insert_one(job_listing.model_dump())
    
    async def read_job_listings(self):
        job_listings_cursor = self.collection.find()
        job_listings = await job_listings_cursor.to_list(length=None)
        return [JobListing(**job_listing) for job_listing in job_listings]
    
    async def update_job_listing(self, updateDetails: JobListing):
        ...
    
    async def delete_job_listing(self, job_title: str):
        ...