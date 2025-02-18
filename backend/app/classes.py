from re import L
from pydantic import BaseModel

class Customer(BaseModel):
    email: str
    password: str
    first_name: str
    last_name: str
    middle_initial: str
    username: str
    address: str
    contact_number: str

class InitialInfo(BaseModel):
    email: str
    password: str

class LoginInfo(BaseModel):
    email:str
    password:str

class CustomerUpdate(BaseModel):
    current_email:str
    first_name: str
    middle_initial: str
    last_name: str
    email: str
    contact_number: str
    address: str

# The following are classes that concerns job listings

class JobListing(BaseModel):
    job_title: str
    description: str
    location: str
    salary: float