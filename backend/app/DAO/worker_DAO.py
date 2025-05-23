from motor.motor_asyncio import AsyncIOMotorDatabase
from app.classes import Profile, ProfileUpdate, UpdateSuspension
from typing import List, Optional

class WorkerDAO:
    def __init__(self, db: AsyncIOMotorDatabase):
        self.collection = db["Worker"]
    
    #CRUD operations
    async def create_worker(self, worker: Profile) -> None:
        worker.username = await self.build_username(worker.first_name, worker.last_name)
        await self.collection.insert_one(worker.model_dump())
    
    async def read_workers(self) -> List[Profile]:
        workers_cursor = self.collection.find()
        workers = await workers_cursor.to_list(length=None)
        return [Profile(**worker) for worker in workers]
    
    async def update_worker(self, updateDetails: dict) -> None:
        # Extract the current email from the dictionary
        current_email = updateDetails.get("current_email")
        if not current_email:
            raise ValueError("current_email is required for updating the worker.")
        
        # Exclude the current_email field from the update data
        update_fields = {key: value for key, value in updateDetails.items() if key != "current_email"}
        
        print(update_fields)
        await self.collection.update_one({"email": current_email}, {"$set": update_fields})
    
    async def update_suspension(self, updateDetails: UpdateSuspension) -> None:
        print(updateDetails.model_dump())
        await self.collection.update_one({"username": updateDetails.username}, {"$set": updateDetails.model_dump(exclude={"username"})})
    
    async def delete_worker(self, username: str) -> None:
        await self.collection.delete_one({"username": username})
    
    #Helper functions
    async def get_all_workers(self) -> List[Profile]:
        workers_cursor = self.collection.find()
        workers = await workers_cursor.to_list(length=None)
        return [Profile(**worker) for worker in workers]

    async def find_by_username(self, username: str) -> Optional[Profile]:
        worker_data = await self.collection.find_one({"username": username})
        return Profile(**worker_data) if worker_data else None

    async def find_by_email(self, email: str) -> Optional[Profile]:
        worker_data = await self.collection.find_one({"email": email})
        return Profile(**worker_data) if worker_data else None
    
    async def build_username(self, first_name: str, last_name: str) -> str:
        #build initial username, and then test if it already exists. if it exists, then append a number incrementally until a unique username is found
        username = f"{first_name[0].lower()}{last_name.lower()}"
        counter = 1
        while await self.find_by_username(username):
            username = f"{username}{counter}"
            counter += 1
        #remove spaces
        username = username.replace(" ", "")
        return username
    
    async def find_by_contact_number(self, contact_number: str) -> Optional[Profile]:
        #check if exact contact number is already in use
        worker_data = await self.collection.find_one({"contact_number": contact_number})        
        return Profile(**worker_data) if worker_data else None