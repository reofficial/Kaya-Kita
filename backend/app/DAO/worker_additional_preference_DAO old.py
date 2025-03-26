from motor.motor_asyncio import AsyncIOMotorDatabase
from app.classes import ServicePreference
from typing import Optional

class WorkerAdditionalPreferenceDAO:
    def __init__(self, db: AsyncIOMotorDatabase):
        self.collection = db["AdditionalServicePreferences"]
    
    #CRUD operations
    async def create_extra_preference(self, worker: ServicePreference) -> None:
        await self.collection.insert_one(worker.model_dump())
    
    # Read: get a service preference by username
    async def get_preference_by_username(self, username: str) -> Optional[dict]:
        return await self.collection.find_one({"username": username})
    
    #Read: get all preferences
    async def get_all_preferences(self):
        preference_cursor = self.collection.find()
        preferences = await preference_cursor.to_list(length=None)
        return [ServicePreference(**p) for p in preferences]
    
    # Update: update the service preference for a given username
    async def update_preference(self, username: str, pref: ServicePreference):
        return await self.collection.update_one(
            {"username": username},
            {"$set": pref.model_dump(exclude={"username"})}
        )
    
    # Delete: delete the service preference for a given username
    async def delete_preference(self, username: str):
        return await self.collection.delete_one({"username": username})