import httpx
import os
from dotenv import load_dotenv

load_dotenv()

BASE_URL = os.getenv("BACKEND_URL")

# Sample customer data
customer_data = {
    "email": "test2@example.com",
    "password": "password123",
    "first_name": "FirstName",
    "last_name": "LastName",
    "middle_initial": "A",
    "username": "testuser2",
    "address": "123 Street St",
    "contact_number": "216"
}

response = httpx.post(f"{BASE_URL}/customers", json=customer_data, verify=False)

print(f"Status Code: {response.status_code}")
print(f"Response: {response.json()}")
