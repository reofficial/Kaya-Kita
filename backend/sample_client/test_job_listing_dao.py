import httpx
import os
from dotenv import load_dotenv

load_dotenv()
BASE_URL = os.getenv("BACKEND_URL")

job_listing_data = {
    "tag": ["construction", "manual labor"],
    "job_title": "Construction Worker",
    "description": "tagahalo ng semento. rereport kay foreman",
    "location": "Diliman, QC",
    "salary": 20.0,
    "salary_frequency": "hourly",
    "duration": "3 months",
    "username": "juandelacruz"
}

# 1. Create a job listing (POST)
print("Creating job listing...")
response = httpx.post(f"{BASE_URL}/job-listings/post", json=job_listing_data, verify=False)
print(f"POST Status: {response.status_code}")
print(f"Response: {response.json()}")

# Extract job_id from response
job_id = response.json().get("job_id")
if job_id is None:
    print("Failed to create job listing. Exiting...")
    exit()
else:
    print(f"Job listing created with ID: {job_id}")

# 2️. Read all job listings (GET)
print("\nFetching all job listings...")
response = httpx.get(f"{BASE_URL}/job-listings", verify=False)
print(f"GET Status: {response.status_code}")
print(f"Response: {response.json()}")

# 3️. Update job listing (PUT)
updated_data = job_listing_data.copy()
updated_data["job_id"] = job_id
updated_data["salary"] = 25.0

print("\nUpdating job listing...")
response = httpx.put(f"{BASE_URL}/job-listings/update", json=updated_data, verify=False)
print(f"PUT Status: {response.status_code}")
print(f"Response: {response.json()}")

# 4. Get job listings by a certain username(GET)
response = httpx.get(f"{BASE_URL}/job-listings/juandelacruz", verify=False)
print("\nFetching job listings by username...")
print(f"GET Status: {response.status_code}")
print(f"Response: {response.json()}")

# 5. Delete job listing (DELETE)
print("\nDeleting job listing...")
response = httpx.delete(f"{BASE_URL}/job-listings/delete/{job_id}", verify=False)
print(f"DELETE Status: {response.status_code}")
print(f"Response: {response.json()}")
