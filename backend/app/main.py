import os
from dotenv import load_dotenv
from fastapi import FastAPI, UploadFile, File, Form, HTTPException, status
from fastapi.responses import JSONResponse, RedirectResponse
from motor.motor_asyncio import AsyncIOMotorClient
from typing import List, Optional, Union
from app.classes import Profile, InitialInfo, JobListing, LoginInfo, ProfileUpdate, WorkerReviews, JobCircles, WorkerRates, WorkerCertificationInput,WorkerCertificationResponse, JobListingUpdate, UpdateSuspension, ServicePreference, AuditLog, Disputes, DisputesUpdate, DisputeWithChat, DisputeWithChatUpdate
from app.DAO.customer_DAO import CustomerDAO
from app.DAO.job_listing_DAO import JobListingDAO
from app.DAO.worker_DAO import WorkerDAO
from app.DAO.official_DAO import OfficialDAO
from app.DAO.worker_reviews_DAO import WorkerReviewsDAO
from app.DAO.job_circles_DAO import JobCirclesDAO
from app.DAO.worker_rates_DAO import WorkerRatesDAO
from app.DAO.certifications_DAO import WorkerCertificationDAO
from app.DAO.worker_additional_preference_DAO import WorkerAdditionalPreferenceDAO
from app.DAO.audit_logs_DAO import AuditLogDAO
from app.DAO.disputes_DAO import DisputesDAO
from app.DAO.dispute_with_chat import DisputeWithChatDAO
from fastapi.staticfiles import StaticFiles
# .\venv\Scripts\Activate
# uvicorn app.main:app --reload
# pip freeze > requirements.txt


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
worker_reviews_dao = WorkerReviewsDAO(database)
job_circle_dao = JobCirclesDAO(database)
worker_rates_dao = WorkerRatesDAO(database)
cert_dao = WorkerCertificationDAO(database)
preference_dao = WorkerAdditionalPreferenceDAO(database)
audit_logs_dao = AuditLogDAO(database)
disputes_dao = DisputesDAO(database)
chats_dao = DisputeWithChatDAO(database)

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
        return JSONResponse(status_code=201, content={"message": "Customer created successfully", "username": customer.username})

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
        return JSONResponse(status_code=200, content={"message": "Login successful", "username": customer.username})
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
        return JSONResponse(status_code=201, content={"message": "Official created successfully", "username": official.username})

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
        return JSONResponse(status_code=200, content={"message": "Login successful", "username": official.username})
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
        return JSONResponse(status_code=201, content={"message": "worker created successfully", "username": worker.username})

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
        return JSONResponse(status_code=200, content={"message": "Login successful", "username": worker.username})
    else:
        raise HTTPException(status_code=401, detail="Invalid email or password")
    
@app.post("/workers/update", status_code=status.HTTP_200_OK)
async def update_worker(updateDetails: ProfileUpdate):
    update_data = updateDetails.model_dump(exclude_unset=True)
    await worker_dao.update_worker(update_data)
    return JSONResponse(status_code=200, content={"message": "worker updated successfully"})

#The following concerns extra service preference
@app.get("/service_preference", response_model=List[ServicePreference])
async def get_service_preference():
    return await preference_dao.get_all_service_preference()

@app.post("/service_preference/register", status_code=status.HTTP_201_CREATED)
async def create_service_preference(service_preference: ServicePreference):
    #check if contact number is already in use
    if await preference_dao.find_by_contact_number(service_preference.contact_number):
        raise HTTPException(status_code=409, detail="Already have an extra service preference.")
    else:
        await preference_dao.create_service_preference(service_preference)
        return JSONResponse(status_code=201, content={"message": "service_preference created successfully"})
    
@app.post("/service_preference/update", status_code=status.HTTP_200_OK)
async def update_service_preference(updateDetails: ServicePreference):
    await preference_dao.update_service_preference(updateDetails)
    return JSONResponse(status_code=200, content={"message": "service_preference updated successfully"})

@app.get("/service_preference/{email}", response_model=ServicePreference)
async def get_service_preference_by_email(email: str):
    service_preference = await preference_dao.find_by_email(email)
    if service_preference:
        return service_preference
    else:
        raise HTTPException(status_code=404, detail="Service preference not found.")

# @app.get("/service_preference", response_model=List[ServicePreference])
# async def get_service_preference_all():
#     return await preference_dao.get_all_preferences()
# @app.post("/service_preference/create", status_code=status.HTTP_201_CREATED)
# async def create_service_preference(pref: ServicePreference):
#     await preference_dao.create_extra_preference(pref)
#     return JSONResponse(status_code=201, content={"message": "Service preference created successfully"})

# @app.get("/service_preference/{username}", response_model=ServicePreference)
# async def get_service_preference(username: str):
#     pref = await preference_dao.get_preference_by_username(username)
#     if not pref:
#         raise HTTPException(status_code=404, detail="Service preference not found")
#     return pref

# @app.put("/service_preference/{username}")
# async def update_service_preference(username: str, pref: ServicePreference):
#     result = await preference_dao.update_preference(username, pref)
#     if result.modified_count == 0:
#         raise HTTPException(status_code=404, detail="Service preference not found or not updated")
#     return JSONResponse(status_code=200, content={"message": "Service preference updated successfully"})

# @app.delete("/service_preference/{username}", status_code=status.HTTP_200_OK)
# async def delete_service_preference(username: str):
#     result = await preference_dao.delete_preference(username)
#     if result.deleted_count == 0:
#         raise HTTPException(status_code=404, detail="Service preference not found")
#     return JSONResponse(status_code=200, content={"message": "Service preference deleted successfully"})

#The following concerns job listings
@app.get("/job-listings", response_model=List[JobListing])
async def get_job_listings():
    return await job_listing_dao.read_job_listings()

@app.get("/job-listings/{username}", response_model=List[JobListing])
async def get_job_listings_by_username(username: str):
    listings = await job_listing_dao.read_job_listings_by_username(username)
    if listings is None or len(listings) == 0:
        raise HTTPException(status_code=404, detail=f"No job listings found for username: {username}")
    return listings

@app.get("/job-listings/worker/{username}", response_model=List[JobListing])
async def get_job_listings_by_worker_username(username: str):
    listings = await job_listing_dao.read_job_listings_by_worker_username(username)
    if listings is None or len(listings) == 0:
        raise HTTPException(status_code=404, detail=f"No job listings found for worker username: {username}")
    return listings

@app.get("/job-listings/job-id/{job_id}", response_model=List[JobListing])
async def get_job_listing_by_id(job_id: int):
    listing = await job_listing_dao.read_job_listing_by_id(job_id)
    if listing is None:
        raise HTTPException(status_code=404, detail=f"Job listing not found for id: {id}")
    return listing

@app.post("/job-listings/post", response_model=JobListing)
async def create_job_listing(job_listing: JobListing):
    if await job_listing_dao.check_if_info_has_content(job_listing):
        created_job = await job_listing_dao.create_job_listing(job_listing)
        return JSONResponse(status_code=201, content=created_job.model_dump())
    else:
        raise HTTPException(status_code=400, detail="Incomplete job listing")
    
@app.put("/job-listings/update", response_model=dict)
async def update_job_listing(update: JobListingUpdate):
    update_data = update.model_dump(exclude_unset=True)
    job_id = update_data.pop("job_id")
    print(f"[Endpoint] Received update for job_id: {job_id}")
    print(f"[Endpoint] Update data: {update_data}")
    success = await job_listing_dao.update_job_listing(job_id, update_data)
    if not success:
        print(f"[Endpoint] No job listing found for job_id: {job_id}")
        raise HTTPException(status_code=404, detail="Job listing not found")
    print(f"[Endpoint] Update successful for job_id: {job_id}")
    return {"message": "Job listing updated successfully"}

@app.delete("/job-listings/delete/{job_id}", response_model=dict)
async def delete_job_listing(job_id: int):
    success = await job_listing_dao.delete_job_listing(job_id)
    if not success:
        raise HTTPException(status_code=404, detail="Job listing not found")
    return {"message": "Job listing deleted successfully"}

#The following concerns worker reviews
@app.get("/reviews", response_model=List[WorkerReviews])
async def get_reviews():
    return await worker_reviews_dao.read_reviews()

@app.get("/reviews/{customer_username}", response_model=List[WorkerReviews])
async def get_reviews_by_customer(customer_username: str):
    return await worker_reviews_dao.read_reviews_by_customer(customer_username)

@app.get("/reviews/worker/{worker_username}", response_model=List[WorkerReviews])
async def get_reviews_of_worker(worker_username: str):
    return await worker_reviews_dao.read_reviews_of_worker(worker_username)

@app.post("/reviews/create", response_model=WorkerReviews)
async def create_review(review: WorkerReviews):
    return await worker_reviews_dao.create_review(review)

@app.put("/reviews/update", response_model=WorkerReviews)
async def update_review(review: WorkerReviews):
    return await worker_reviews_dao.update_review(review)

@app.delete("/reviews/delete/{review_id}", response_model=dict)
async def delete_review(review_id: int):
    await worker_reviews_dao.delete_review(review_id)
    return {"message": "Review deleted successfully"}

#The following concernt JobCircles


@app.get("/job-circles", response_model=List[JobCircles])
async def get_job_circles():
    return await job_circle_dao.read_job_circles()

@app.get("/job-circles/{username}", response_model=List[JobCircles])
async def get_job_circles_by_username(username: str):
    circles = await job_circle_dao.read_job_circles_by_username(username)
    if circles is None or len(circles) == 0:
        raise HTTPException(status_code=404, detail=f"No job found for username: {username}")
    return circles

@app.get("/job-circles/worker/{username}", response_model=List[JobCircles])
async def get_job_circles_by_worker_username(username: str):
    circles = await job_circle_dao.read_job_circles_by_worker_username(username)
    if circles is None or len(circles) == 0:
        raise HTTPException(status_code=404, detail=f"No job found for worker username: {username}")
    return circles

@app.get("/job-circles/job-id/{job_id}", response_model=List[JobCircles])
async def get_job_circle_by_id(job_id: int):
    circle = await job_circle_dao.read_job_circle_by_id(job_id)
    if circle is None:
        raise HTTPException(status_code=404, detail=f"Job not found for id: {id}")
    return circle

@app.post("/job-circles/post", response_model=JobCircles)
async def create_job_circle(job_circle: JobCircles):
    return await job_circle_dao.create_job_circle(job_circle)
    
@app.put("/job-circles/update", response_model=dict)
async def update_job_circle(job_circle: JobCircles):
    success = await job_circle_dao.update_job_circle(job_circle)
    if not success:
        raise HTTPException(status_code=404, detail="Job not found")
    return {"message": "Job circle updated successfully"}

@app.delete("/job-circles/delete/{job_id}", response_model=dict)
async def delete_job_circle(job_id: int):
    success = await job_circle_dao.delete_job_circle(job_id)
    if not success:
        raise HTTPException(status_code=404, detail="Job not found")
    return {"message": "Job circle deleted successfully"}

# The following concerns worker rates
@app.get("/rates", response_model=List[WorkerRates])
async def get_rates():
    return await worker_rates_dao.read_worker_rates()

@app.get("/rates/{email}", response_model=WorkerRates | None)
async def get_rate_by_email(email: str):
    return await worker_rates_dao.read_worker_rate_by_email(email)

@app.post("/rates/create", response_model=WorkerRates)
async def create_rate(rate: WorkerRates):
    return await worker_rates_dao.create_worker_rate(rate)

@app.put("/rates/update", response_model=bool)
async def update_rate(email: str, new_rate: float):
    return await worker_rates_dao.update_worker_rate(email, new_rate)

@app.delete("/rates/delete/{email}", response_model=dict)
async def delete_rate(email: str):
    success = await worker_rates_dao.delete_worker_rate(email)
    return {"message": "Rate deleted successfully"} if success else {"message": "Rate not found"}

#The following concerns certificates
app.mount("/static", StaticFiles(directory="static"), name="static")
@app.post("/certifications/create", response_model=WorkerCertificationResponse, status_code=status.HTTP_201_CREATED)
async def create_certification(
    worker_username: str = Form(...),
    date_of_application: str = Form(...),
    licensing_certificate_given: str = Form(...),
    is_senior: bool = Form(...),
    is_pwd: bool = Form(...),
    licensing_certificate_photo: UploadFile = File(...),
    barangay_certificate: UploadFile = File(...)
):
    input_data = WorkerCertificationInput(
        worker_username=worker_username,
        date_of_application=date_of_application,
        licensing_certificate_given=licensing_certificate_given,
        is_senior=is_senior,
        is_pwd=is_pwd
    )
    cert = await cert_dao.create_certification(input_data, licensing_certificate_photo, barangay_certificate)
    return cert

# GET: List all Certifications.
@app.get("/certifications", response_model=List[WorkerCertificationResponse])
async def get_certifications():
    return await cert_dao.read_certifications()

# GET: Retrieve a Certification by Username.
@app.get("/certifications/{worker_username}", response_model=Union[WorkerCertificationResponse, None])
async def get_certification_by_username(worker_username: str):
    cert = await cert_dao.read_certification_by_username(worker_username)
    if not cert:
        raise HTTPException(status_code=404, detail="Certification not found")
    return cert

# PUT: Update a Certification.
# This endpoint accepts optional new text fields and/or new file uploads (which replace the old files).
@app.put("/certifications/update", response_model=bool)
async def update_certification(
    worker_username: str = Form(...),
    # Optional text fields
    date_of_application: Optional[str] = Form(None),
    licensing_certificate_given: Optional[str] = Form(None),
    is_senior: Optional[bool] = Form(None),
    is_pwd: Optional[bool] = Form(None),
    # Optional new files
    licensing_certificate_photo: Optional[UploadFile] = File(None),
    barangay_certificate: Optional[UploadFile] = File(None)
):
    update_data = {}
    if date_of_application is not None:
        update_data["date_of_application"] = date_of_application
    if licensing_certificate_given is not None:
        update_data["licensing_certificate_given"] = licensing_certificate_given
    if is_senior is not None:
        update_data["is_senior"] = is_senior
    if is_pwd is not None:
        update_data["is_pwd"] = is_pwd

    updated = await cert_dao.update_certification(
        worker_username,
        update_data,
        licensing_certificate_photo,
        barangay_certificate
    )
    if not updated:
        raise HTTPException(status_code=404, detail="Certification not found or no changes made")
    return True

#Specific POST for updating is_suspended
@app.post("/update_suspension_customer", status_code=status.HTTP_200_OK)
async def update_suspension_customer(updateDetails: UpdateSuspension):
    await customer_dao.update_suspension(updateDetails)
    return JSONResponse(status_code=200, content={"message": "Customer updated successfully"})

@app.post("/update_suspension_worker", status_code=status.HTTP_200_OK)
async def update_suspension_worker(updateDetails: UpdateSuspension):
    await worker_dao.update_suspension(updateDetails)
    return JSONResponse(status_code=200, content={"message": "Customer updated successfully"})

# DELETE: Delete a Certification by Username.
@app.delete("/certifications/delete/{worker_username}", response_model=dict)
async def delete_certification(worker_username: str):
    success = await cert_dao.delete_certification(worker_username)
    return {"message": "Certification deleted successfully"} if success else {"message": "Certification not found"}

# The following concerns logs:
@app.post("/logs/create", response_model=AuditLog)
async def create_log(log: AuditLog):
    return await audit_logs_dao.create_audit_log(log)

@app.get("/logs", response_model=List[AuditLog])
async def get_logs():
    return await audit_logs_dao.read_audit_logs()

@app.get("/logs/{official_username}", response_model=AuditLog | None)
async def get_log_by_username(official_username: str):
    return await audit_logs_dao.read_audit_log_by_username(official_username)

#The following handles disputes
@app.post("/disputes/create", response_model=Disputes)
async def create_dispute(dispute: Disputes):
    return await disputes_dao.create_dispute(dispute)

@app.get("/disputes", response_model=List[Disputes])
async def get_disputes():
    return await disputes_dao.read_disputes()

@app.get("/disputes/worker/{worker_username}", response_model=Disputes | None)
async def get_dispute_by_worker_username(worker_username: str):
    return await disputes_dao.read_dispute_by_worker_username(worker_username)

@app.get("/disputes/customer/{customer_username}", response_model=Disputes | None)
async def get_dispute_by_customer_username(customer_username: str):
    return await disputes_dao.read_dispute_by_customer_username(customer_username)

@app.post("/disputes/update", response_model=DisputesUpdate)
async def update_dispute(dispute: DisputesUpdate):
    await disputes_dao.update_dispute(dispute)
    
    return JSONResponse(status_code=200, content={"message": "Dispute updated successfully"})

@app.delete("/disputes/delete/{dispute_id}", response_model=dict)
async def delete_dispute(dispute_id: int):
    success = await disputes_dao.delete_dispute(dispute_id)
    return {"message": "Dispute deleted successfully"} if success else {"message": "Dispute not found"}

#The following handles escalated disputes with chat
@app.post("/chat/create", response_model=DisputeWithChat)
async def create_chat(dispute: DisputeWithChat):
    return await chats_dao.create_dispute(dispute)

@app.get("/chat", response_model=List[DisputeWithChat])
async def get_chat():
    return await chats_dao.read_dispute_with_chat()

@app.get("/chat/worker/{worker_username}", response_model=DisputeWithChat | None)
async def get_chat_by_worker_username(worker_username: str):
    return await chats_dao.read_dispute_by_worker_username(worker_username)

@app.get("/chat/customer/{customer_username}", response_model=DisputeWithChat | None)
async def get_chat_by_customer_username(customer_username: str):
    return await chats_dao.read_dispute_by_customer_username(customer_username)

@app.post("/chat/update", response_model=DisputeWithChatUpdate)
async def update_chat(dispute: DisputeWithChatUpdate):
    await chats_dao.update_dispute(dispute)
    
    return JSONResponse(status_code=200, content={"message": "Dispute updated successfully"})

@app.delete("/chat/delete/{dispute_id}", response_model=dict)
async def delete_chat(dispute_id: int):
    success = await chats_dao.delete_dispute(dispute_id)
    return {"message": "Dispute deleted successfully"} if success else {"message": "Dispute not found"}

#Test function
# @app.get("/")
# async def hello():
#     return RedirectResponse(url="https://github.com/reofficial/Kaya-Kita")

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
    