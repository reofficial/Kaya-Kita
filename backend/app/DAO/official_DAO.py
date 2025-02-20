from motor.motor_asyncio import AsyncIOMotorDatabase
from app.classes import Profile, ProfileUpdate
from typing import List, Optional

class OfficialDAO:
    def __init__(self, db: AsyncIOMotorDatabase):
        self.collection = db["Official"]
    
    #CRUD operations
    async def create_official(self, official: Profile) -> None:
        official.username = await self.build_username(official.first_name, official.last_name)
        await self.collection.insert_one(official.model_dump())
    
    async def read_officials(self) -> List[Profile]:
        officials_cursor = self.collection.find()
        officials = await officials_cursor.to_list(length=None)
        return [Profile(**official) for official in officials]
    
    async def update_official(self, updateDetails: ProfileUpdate) -> None:
        #update the official associated with the email
        print(updateDetails.model_dump())
        await self.collection.update_one({"email": updateDetails.current_email}, {"$set": updateDetails.model_dump(exclude={"current_email"})})
    
    async def delete_official(self, username: str) -> None:
        await self.collection.delete_one({"username": username})
    
    #Helper functions
    async def get_all_officials(self) -> List[Profile]:
        officials_cursor = self.collection.find()
        officials = await officials_cursor.to_list(length=None)
        return [Profile(**official) for official in officials]

    async def find_by_username(self, username: str) -> Optional[Profile]:
        official_data = await self.collection.find_one({"username": username})
        return Profile(**official_data) if official_data else None

    async def find_by_email(self, email: str) -> Optional[Profile]:
        official_data = await self.collection.find_one({"email": email})
        return Profile(**official_data) if official_data else None
    
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
        official_data = await self.collection.find_one({"contact_number": contact_number})        
        return Profile(**official_data) if official_data else None