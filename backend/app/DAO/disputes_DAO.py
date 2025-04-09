from motor.motor_asyncio import AsyncIOMotorDatabase
from app.classes import Disputes, DisputesUpdate
from typing import List, Optional

class DisputesDAO:
    def __init__(self, db: AsyncIOMotorDatabase):
        self.collection = db["Disputes"]
    
    #CRUD operations
    
    async def create_dispute(self, dispute: Disputes):
    # Automatically assigns dispute id
        last_dispute = await self.collection.find_one(
            {}, sort=[("dispute_id", -1)]
        )
        new_id = (last_dispute["dispute_id"] + 1) if last_dispute else 0
        
        dispute_data = dispute.model_dump()
        dispute_data["dispute_id"] = new_id
        
        await self.collection.insert_one(dispute_data)
        return Disputes(**dispute_data)
    
    async def read_disputes(self):
        disputes_cursor = self.collection.find()
        disputes = await disputes_cursor.to_list(length=None)
        return [Disputes(**dispute) for dispute in disputes]
    
    async def read_dispute_by_worker_username(self, worker_username: str):
        dispute = await self.collection.find_one({"worker_username": worker_username})
        return Disputes(**dispute) if dispute else None
    
    async def read_dispute_by_customer_username(self, customer_username: str):
        dispute = await self.collection.find_one({"customer_username": customer_username})
        return Disputes(**dispute) if dispute else None
    
    async def update_dispute(self, updateDetails: DisputesUpdate) -> None:
        update_data = updateDetails.model_dump(
            exclude={"dispute_id"},
            exclude_none=True,
            exclude_unset=True
        )
        await self.collection.update_one(
            {"dispute_id": updateDetails.dispute_id},
            {"$set": update_data}
        )
    
    async def delete_dispute(self, dispute_id: int):
        result = await self.collection.delete_one({"dispute_id": dispute_id})
        return result.deleted_count > 0