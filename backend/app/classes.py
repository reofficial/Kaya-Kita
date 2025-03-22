from pydantic import BaseModel
from typing import List, Optional
from datetime import datetime

# .updateMany({}, { $set: { new_field: "" } });

class Profile(BaseModel):
    email: str
    password: str
    first_name: str
    last_name: str
    middle_initial: str
    username: str
    address: str
    contact_number: str
    service_preference: Optional[str] = "N/A"
    is_certified: Optional[bool] = False
    

class InitialInfo(BaseModel):
    email: str
    password: str

class LoginInfo(BaseModel):
    email:str
    password:str

class ProfileUpdate(BaseModel):
    current_email:str
    first_name: str
    middle_initial: str
    last_name: str
    email: str
    contact_number: str
    address: str

# The following are classes that concerns job listings

class JobListing(BaseModel):
    job_id: Optional[int] = None
    username: Optional[str] = None
    is_hidden: Optional[bool] = False
    tag: list[str]          #list of tags for the job (e.g. catering, housework, construction, etc.)
    job_title: str          
    description: str
    location: str
    salary: float           
    salary_frequency: str   #sample: salary = 10. salary_frequency = "hourly". therefore 10/hour is the salary
    duration: str           #extra job information
    worker_username: Optional[str] = None   #the username of the worker assigned to the job

class JobCircles(BaseModel):
    ticket_number: Optional[int] = None
    datetime: str
    customer: str
    handyman: Optional[str] = "N/A"
    job_status: Optional[str] = "Ongoing"
    payment_status: Optional[str] = "Not Paid"
    rating_status: Optional[str] = "Unrated"
    

class WorkerReviews(BaseModel):
    review_id: Optional[int] = None
    worker_username: str
    customer_username: str
    rating: int
    review: str
    created_at: datetime

class WorkerRates(BaseModel):
    email: str
    rate: float

class WorkerCertificationInput(BaseModel):
    worker_username: str
    date_of_application: str
    licensing_certificate_given: str
    is_senior: bool
    is_pwd: bool
    
class WorkerCertificationDB(WorkerCertificationInput):      #Database specific schema. Not meant to be exposed
    licensing_certificate_photo: str                        #Internal path to the licensing certificate photo
    barangay_certificate: str                               #Internal path to the barangay certificate file

WorkerCertificationResponse = WorkerCertificationDB