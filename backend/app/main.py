import os
from dotenv import load_dotenv
from fastapi import FastAPI
from motor.motor_asyncio import AsyncIOMotorClient
from pydantic import BaseModel
from typing import List

# uvicorn app.main:app --reload

load_dotenv()
app = FastAPI()
MONGO_URI = os.getenv("MONGO_URI")

client = AsyncIOMotorClient(MONGO_URI)
database = client["Kaya_Kita"]
collection = database["Customer"]

class Customer(BaseModel):
    _id: str
    email: str
    password: str
    first_name: str
    last_name: str
    middle_initial: str
    username: str
    address: str
    contact_number: str
    
@app.get("/customers", response_model=List[Customer])
async def get_customers():
    customers_cursor = collection.find()
    customers = await customers_cursor.to_list(length=None)
    return [Customer(**customer) for customer in customers]

@app.get("/hello")
async def hello():
    return {"message": "hello"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
