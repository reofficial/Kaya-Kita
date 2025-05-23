from motor.motor_asyncio import AsyncIOMotorDatabase
from app.classes import Profile, ProfileUpdate, UpdateSuspension
from typing import List, Optional

class CustomerDAO:
    def __init__(self, db: AsyncIOMotorDatabase):
        self.collection = db["Customer"]
    
    #CRUD operations
    async def create_customer(self, customer: Profile) -> None:
        customer.username = await self.build_username(customer.first_name, customer.last_name)
        await self.collection.insert_one(customer.model_dump())
    
    async def read_customers(self) -> List[Profile]:
        customers_cursor = self.collection.find()
        customers = await customers_cursor.to_list(length=None)
        return [Profile(**customer) for customer in customers]
    
    async def update_customer(self, updateDetails: ProfileUpdate) -> None:
        #update the customer associated with the email
        print(updateDetails.model_dump())
        await self.collection.update_one({"email": updateDetails.current_email}, {"$set": updateDetails.model_dump(exclude={"current_email"})})
    
    async def update_suspension(self, updateDetails: UpdateSuspension) -> None:
        print(updateDetails.model_dump())
        await self.collection.update_one({"username": updateDetails.username}, {"$set": updateDetails.model_dump(exclude={"username"})})
    
    async def delete_customer(self, username: str) -> None:
        await self.collection.delete_one({"username": username})
    
    #Helper functions
    async def get_all_customers(self) -> List[Profile]:
        customers_cursor = self.collection.find()
        customers = await customers_cursor.to_list(length=None)
        return [Profile(**customer) for customer in customers]

    async def find_by_username(self, username: str) -> Optional[Profile]:
        customer_data = await self.collection.find_one({"username": username})
        return Profile(**customer_data) if customer_data else None

    async def find_by_email(self, email: str) -> Optional[Profile]:
        customer_data = await self.collection.find_one({"email": email})
        return Profile(**customer_data) if customer_data else None
    
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
        customer_data = await self.collection.find_one({"contact_number": contact_number})        
        return Profile(**customer_data) if customer_data else None