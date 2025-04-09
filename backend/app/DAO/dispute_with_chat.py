from motor.motor_asyncio import AsyncIOMotorDatabase
from app.classes import DisputeWithChat, DisputeWithChatUpdate
from typing import List, Optional

class DisputeWithChatDAO:
    def __init__(self, db: AsyncIOMotorDatabase):
        self.collection = db["DisputeWithChat"]
    
    #CRUD operations
    
    async def create_dispute(self, dispute: DisputeWithChat):
        dispute_data = dispute.model_dump()

        await self.collection.insert_one(dispute_data)
        return DisputeWithChat(**dispute_data)
    
    async def read_dispute_with_chat(self):
        dispute_with_chat_cursor = self.collection.find()
        chat_with_chat = await dispute_with_chat_cursor.to_list(length=None)
        return [DisputeWithChat(**dispute) for dispute in chat_with_chat]
    
    async def read_dispute_by_worker_username(self, worker_username: str):
        dispute = await self.collection.find_one({"worker_username": worker_username})
        return DisputeWithChat(**dispute) if dispute else None
    
    async def read_dispute_by_customer_username(self, customer_username: str):
        dispute = await self.collection.find_one({"customer_username": customer_username})
        return DisputeWithChat(**dispute) if dispute else None
    
    async def read_dispute_by_official_username(self, official_username: str):
        dispute = await self.collection.find_one({"official_username": official_username})
        return DisputeWithChat(**dispute) if dispute else None
    
    async def update_dispute(self, updateDetails: DisputeWithChatUpdate) -> None:
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


