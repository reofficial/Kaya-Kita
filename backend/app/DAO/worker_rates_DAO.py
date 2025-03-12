from motor.motor_asyncio import AsyncIOMotorDatabase
from app.classes import WorkerRates
from typing import List, Optional

class WorkerRatesDAO:
    def __init__(self, db: AsyncIOMotorDatabase):
        self.collection = db["WorkerRates"]
    
    #CRUD operations
    async def create_worker_rate(self, worker_rate: WorkerRates):
        rate_data = worker_rate.model_dump()
        await self.collection.insert_one(rate_data)
        return worker_rate
    
    async def read_worker_rates(self):
        rates_cursor = self.collection.find()
        rates = await rates_cursor.to_list(length=None)
        return [WorkerRates(**rate) for rate in rates]
    
    async def read_worker_rate_by_email(self, email: str):
        rate = await self.collection.find_one({"email": email})
        return WorkerRates(**rate) if rate else None
    
    async def update_worker_rate(self, email: str, new_rate: float):
        result = await self.collection.update_one(
            {"email": email},
            {"$set": {"rate": new_rate}}
        )
        return result.modified_count > 0
    
    async def delete_worker_rate(self, email: str):
        result = await self.collection.delete_one({"email": email})
        return result.deleted_count > 0