import os
from dotenv import load_dotenv
from fastapi import FastAPI, HTTPException, status
from fastapi.responses import JSONResponse
from motor.motor_asyncio import AsyncIOMotorClient
from typing import List
from app.classes import Customer

# .\venv\Scripts\Activate
# uvicorn app.main:app --reload

load_dotenv()
app = FastAPI()
MONGO_URI = os.getenv("MONGO_URI")

client = AsyncIOMotorClient(MONGO_URI)
database = client["Kaya_Kita"]
    
@app.get("/customers", response_model=List[Customer])
async def get_customers():
    """
    Retrieves all customers from the database.

    Returns:
        List[Customer]: A list of Customer objects
    """
    collection = database["Customer"]
    customers_cursor = collection.find()
    customers = await customers_cursor.to_list(length=None)
    return [Customer(**customer) for customer in customers]

@app.post("/customers", status_code=status.HTTP_201_CREATED)
async def create_customer(customer: Customer):
    """
    Creates a new customer in the database.

    Args:
        customer (Customer): The customer information to be inserted.

    Raises:
        HTTPException: If the email or username already exists in the database.
        Error code 422: Username already exists -- duplicate account.
        Error code 409: Email already exists -- invalid data given.

    Returns:
        Response: A response indicating successful creation of the customer.
    """
    collection = database["Customer"]
    
    existing_username = await collection.find_one({"username": customer.username})
    if existing_username:
        raise HTTPException(
            status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
            detail="Profile already registered."
        )
    
    existing_email = await collection.find_one({"email": customer.email})
    if existing_email:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="Invalid data given. Please check your registration."
        )

    await collection.insert_one(customer.model_dump())
    return JSONResponse(status_code=status.HTTP_201_CREATED, content={"message": "Customer created successfully"})


@app.get("/hello")
async def hello():
    return {"message": "hello"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
