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
    first_name: str
    middle_initial: str
    last_name: str
    email: str
    contact_number: str
    address: str