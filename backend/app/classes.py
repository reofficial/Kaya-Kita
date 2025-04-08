from pydantic import BaseModel, field_validator
from typing import List, Optional, Any
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
    is_certified: Optional[str] = "Pending"
    is_suspended: Optional[str] = "No"
    deny_reason: Optional[str] = ""

class UpdateSuspension(BaseModel):
    username: str
    is_suspended: str
    

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
    is_certified: str
    deny_reason: Optional[str] = None

# The following are classes that concerns job listings

class JobListing(BaseModel):
    job_id: Optional[int] = None
    username: Optional[str] = None
    is_hidden: Optional[bool] = False
    tag: Optional[list[str]] = []          #list of tags for the job (e.g. catering, housework, construction, etc.)
    job_title: Optional[str] = ""          
    description: Optional[str] = ""
    location: Optional[str] = ""
    salary: Optional[float] = 0.0           
    salary_frequency: Optional[str] = ""   #sample: salary = 10. salary_frequency = "hourly". therefore 10/hour is the salary
    duration: Optional[str] = ""           #extra job information
    worker_username: Optional[List[str]] = [] 
    job_status: Optional[str] = "Pending"

    @field_validator("worker_username", mode="before")
    def ensure_list_for_worker_username(cls, v: Any) -> List[str]:
        if v is None:
            return []
        if isinstance(v, str):
            return [v]
        if isinstance(v, list):
            return v
        raise ValueError("worker_username must be a list of strings")

class JobListingUpdate(BaseModel):
    job_id: int                             #Required field
    username: Optional[str] = None
    is_hidden: Optional[bool] = None
    tag: Optional[list[str]] = None      
    job_title: Optional[str] = None        
    description: Optional[str] = None
    location: Optional[str] = None
    salary: Optional[float] = None          
    salary_frequency: Optional[str] = None  
    duration: Optional[str] = None
    worker_username: Optional[list[str]] = None 
    job_status: Optional[str] = None

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

class WorkerDetails(BaseModel):
    nationality: str
    date_of_birth: str
    age: int
    emergency_contact: str
    contact_number: str
    relationship: str

class ServicePreference(BaseModel):
    current_email:str
    first_name: str
    middle_initial: str
    last_name: str
    email: str
    contact_number: str
    address: str
    service_preference:str
    is_certified: str

class AuditLog(BaseModel):
    official_username: str
    log: str

class Disputes(BaseModel):
    dispute_id: Optional[int] = None
    ticket_number: Optional[int] = None
    worker_username: Optional[str] = None
    customer_username: Optional[str] = None
    reason: Optional[str] = None
    solution: Optional[str] = None
    description: Optional[str] = None
    dispute_status: Optional[str] = "Under Review"
    created_at: datetime | Optional[str] = None