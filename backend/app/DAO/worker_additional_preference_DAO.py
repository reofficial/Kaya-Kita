from motor.motor_asyncio import AsyncIOMotorDatabase
from app.classes import ServicePreference
from typing import List, Optional

class WorkerAdditionalPreferenceDAO:
    def __init__(self, db: AsyncIOMotorDatabase):
        self.collection = db["AdditionalServicePreferences"]
    
    #CRUD operations
    async def create_service_preference(self, service_preference: ServicePreference) -> None:
        await self.collection.insert_one(service_preference.model_dump())
    
    async def read_service_preference(self) -> List[ServicePreference]:
        service_preference_cursor = self.collection.find()
        service_preference = await service_preference_cursor.to_list(length=None)
        return [ServicePreference(**service_preference) for service_preference in service_preference]
    
    async def update_service_preference(self, updateDetails: ServicePreference) -> None:
        #update the service_preference associated with the email
        print(updateDetails.model_dump())
        await self.collection.update_one({"email": updateDetails.current_email}, {"$set": updateDetails.model_dump(exclude={"current_email"})})

    #Helper functions
    async def get_all_service_preference(self) -> List[ServicePreference]:
        service_preference_cursor = self.collection.find()
        service_preference = await service_preference_cursor.to_list(length=None)
        return [ServicePreference(**service_preference) for service_preference in service_preference]

    async def find_by_email(self, email: str) -> Optional[ServicePreference]:
        service_preference_data = await self.collection.find_one({"email": email})
        return ServicePreference(**service_preference_data) if service_preference_data else None

    async def find_by_contact_number(self, contact_number: str) -> Optional[ServicePreference]:
        #check if exact contact number is already in use
        worker_data = await self.collection.find_one({"contact_number": contact_number})        
        return ServicePreference(**worker_data) if worker_data else None