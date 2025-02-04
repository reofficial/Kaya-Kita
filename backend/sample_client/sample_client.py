import httpx

BASE_URL = "http://127.0.0.1:8000"

# Sample customer data
customer_data = {
    "email": "test@example.com",
    "password": "password123",
    "first_name": "FirstName",
    "last_name": "LastName",
    "middle_initial": "A",
    "username": "testuser",
    "address": "123 Street St",
    "contact_number": "216"
}


response = httpx.post(f"{BASE_URL}/customers", json=customer_data)


print(f"Status Code: {response.status_code}")
print(f"Response: {response.json()}")
