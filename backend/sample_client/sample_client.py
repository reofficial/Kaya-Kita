import httpx
import os
from dotenv import load_dotenv

load_dotenv()

BASE_URL = os.getenv("BACKEND_URL")

# Sample customer data
customer_data = {
    "email": "test123123@example.com",
    "password": "password123"
}

response = httpx.post(f"{BASE_URL}/workers/email", json=customer_data, verify=False)

print(f"Status Code: {response.status_code}")
print(f"Response: {response.json()}")
