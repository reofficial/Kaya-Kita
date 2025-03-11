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
    datetime: datetime
    customer: str
    handyman: str
    job_status: Optional[str] = "Ongoing"
    payment_status: Optional[str] = "Not Paid"
    

class WorkerReviews(BaseModel):
    review_id: Optional[int] = None
    worker_username: str
    customer_username: str
    rating: int
    review: str
    created_at: datetime