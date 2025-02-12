import os
from dotenv import load_dotenv
from fastapi import FastAPI, HTTPException, status
from fastapi.responses import JSONResponse
from motor.motor_asyncio import AsyncIOMotorClient
from typing import List
from app.classes import Customer, InitialInfo, LoginInfo
from app.DAO.customer_DAO import CustomerDAO

# .\venv\Scripts\Activate
# uvicorn app.main:app --reload


load_dotenv()
app = FastAPI()
MONGO_URI = os.getenv("MONGO_URI")

client = AsyncIOMotorClient(MONGO_URI)
database = client["Kaya_Kita"]


customer_dao = CustomerDAO(database)
    
@app.get("/customers", response_model=List[Customer])
async def get_customers():
    return await customer_dao.get_all_customers()

@app.post("/customers/register", status_code=status.HTTP_201_CREATED)
async def create_customer(customer: Customer):
    #check if contact number is already in use
    if await customer_dao.find_by_contact_number(customer.contact_number):
        raise HTTPException(status_code=409, detail="Contact number is already in use.")
    else:
        await customer_dao.create_customer(customer)
        return JSONResponse(status_code=201, content={"message": "Customer created successfully"})

@app.post("/customers/email", status_code=status.HTTP_201_CREATED)
async def check_email(info: InitialInfo):
    if await customer_dao.find_by_email(info.email):
        raise HTTPException(status_code=409, detail="Email already registered.")
    else:
        return JSONResponse(status_code=201, content={"message": "Email available"})

@app.post("/customers/login", status_code=status.HTTP_200_OK)
async def login(info: LoginInfo):
    customer = await customer_dao.find_by_email(info.email)
    if customer and customer.password == info.password:
        return JSONResponse(status_code=200, content={"message": "Login successful"})
    else:
        raise HTTPException(status_code=401, detail="Invalid email or password")


@app.get("/hello")
async def hello():
    return {"message": "hello"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
