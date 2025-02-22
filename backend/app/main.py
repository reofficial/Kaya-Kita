import os
from dotenv import load_dotenv
from fastapi import FastAPI, HTTPException, status
from fastapi.responses import JSONResponse
from motor.motor_asyncio import AsyncIOMotorClient
from typing import List
from app.classes import Profile, InitialInfo, JobListing, LoginInfo, ProfileUpdate
from app.DAO.customer_DAO import CustomerDAO
from app.DAO.job_listing_DAO import JobListingDAO
from app.DAO.worker_DAO import WorkerDAO
from app.DAO.official_DAO import OfficialDAO

# .\venv\Scripts\Activate
# uvicorn app.main:app --reload


load_dotenv()
app = FastAPI()
MONGO_URI = os.getenv("MONGO_URI")

client = AsyncIOMotorClient(MONGO_URI)
database = client["Kaya_Kita"]

#Instantiate DAOs
customer_dao = CustomerDAO(database)
official_dao = OfficialDAO(database)
worker_dao = WorkerDAO(database)
job_listing_dao = JobListingDAO(database)

# The following concerns customers
@app.get("/customers", response_model=List[Profile])
async def get_customers():
    return await customer_dao.get_all_customers()

@app.post("/customers/register", status_code=status.HTTP_201_CREATED)
async def create_customer(customer: Profile):
    #check if contact number is already in use
    if await customer_dao.find_by_contact_number(customer.contact_number):
        raise HTTPException(status_code=409, detail="Contact number is already in use.")
    else:
        await customer_dao.create_customer(customer)
        return JSONResponse(status_code=201, content={"message": "Customer created successfully"})

@app.post("/customers/email", status_code=status.HTTP_201_CREATED)
async def customer_check_email(info: InitialInfo):
    if await customer_dao.find_by_email(info.email):
        raise HTTPException(status_code=409, detail="Email already registered.")
    else:
        return JSONResponse(status_code=201, content={"message": "Email available"})

@app.post("/customers/login", status_code=status.HTTP_200_OK)
async def customer_login(info: LoginInfo):
    customer = await customer_dao.find_by_email(info.email)
    if customer and customer.password == info.password:
        return JSONResponse(status_code=200, content={"message": "Login successful"})
    else:
        raise HTTPException(status_code=401, detail="Invalid email or password")
    
@app.post("/customers/update", status_code=status.HTTP_200_OK)
async def update_customer(updateDetails: ProfileUpdate):
    await customer_dao.update_customer(updateDetails)
    return JSONResponse(status_code=200, content={"message": "Customer updated successfully"})

#The following concerns officials
@app.get("/officials", response_model=List[Profile])
async def get_officials():
    return await official_dao.get_all_officials()

@app.post("/officials/register", status_code=status.HTTP_201_CREATED)
async def create_official(official: Profile):
    #check if contact number is already in use
    if await official_dao.find_by_contact_number(official.contact_number):
        raise HTTPException(status_code=409, detail="Contact number is already in use.")
    else:
        await official_dao.create_official(official)
        return JSONResponse(status_code=201, content={"message": "Official created successfully"})

@app.post("/officials/email", status_code=status.HTTP_201_CREATED)
async def official_check_email(info: InitialInfo):
    if await official_dao.find_by_email(info.email):
        raise HTTPException(status_code=409, detail="Email already registered.")
    else:
        return JSONResponse(status_code=201, content={"message": "Email available"})

@app.post("/officials/login", status_code=status.HTTP_200_OK)
async def official_login(info: LoginInfo):
    official = await official_dao.find_by_email(info.email)
    if official and official.password == info.password:
        return JSONResponse(status_code=200, content={"message": "Login successful"})
    else:
        raise HTTPException(status_code=401, detail="Invalid email or password")
    
@app.post("/officials/update", status_code=status.HTTP_200_OK)
async def update_official(updateDetails: ProfileUpdate):
    await official_dao.update_official(updateDetails)
    return JSONResponse(status_code=200, content={"message": "Official updated successfully"})

#The following concerns workers
@app.get("/workers", response_model=List[Profile])
async def get_workers():
    return await worker_dao.get_all_workers()

@app.post("/workers/register", status_code=status.HTTP_201_CREATED)
async def create_worker(worker: Profile):
    #check if contact number is already in use
    if await worker_dao.find_by_contact_number(worker.contact_number):
        raise HTTPException(status_code=409, detail="Contact number is already in use.")
    else:
        await worker_dao.create_worker(worker)
        return JSONResponse(status_code=201, content={"message": "worker created successfully"})

@app.post("/workers/email", status_code=status.HTTP_201_CREATED)
async def worker_check_email(info: InitialInfo):
    if await worker_dao.find_by_email(info.email):
        raise HTTPException(status_code=409, detail="Email already registered.")
    else:
        return JSONResponse(status_code=201, content={"message": "Email available"})

@app.post("/workers/login", status_code=status.HTTP_200_OK)
async def worker_login(info: LoginInfo):
    worker = await worker_dao.find_by_email(info.email)
    if worker and worker.password == info.password:
        return JSONResponse(status_code=200, content={"message": "Login successful"})
    else:
        raise HTTPException(status_code=401, detail="Invalid email or password")
    
@app.post("/workers/update", status_code=status.HTTP_200_OK)
async def update_worker(updateDetails: ProfileUpdate):
    await worker_dao.update_worker(updateDetails)
    return JSONResponse(status_code=200, content={"message": "worker updated successfully"})

#The following concerns job listings
@app.get("/job-listings", response_model=List[JobListing])
async def get_job_listings():
    return await job_listing_dao.read_job_listings()

@app.post("/job-listings/post", response_model=JobListing)
async def create_job_listing(job_listing: JobListing):
    if await job_listing_dao.check_if_info_has_content(job_listing):
        await job_listing_dao.create_job_listing(job_listing)
        return JSONResponse(status_code=201, content={"message": "Job listing created successfully"})
    else:
        raise HTTPException(status_code=400, detail="Incomplete job listing")

#Test function
@app.get("/hello")
async def hello():
    return {"message": "hello"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
