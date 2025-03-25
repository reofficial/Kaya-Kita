import requests
import json

BASE_URL = "http://localhost:8000"

def create_job_listing():
    url = f"{BASE_URL}/job-listings/post"
    # Create a job listing payload; adjust fields as needed
    job_data = {
        "username": "testuser",
        "job_title": "Test Job",
        "description": "This is a test job listing.",
        "location": "Test Location",
        "salary": 10.0,
        "salary_frequency": "hourly",
        "duration": "temporary",
        "tag": ["test", "job"],
        "job_status": "pending"
    }
    response = requests.post(url, json=job_data)
    if response.status_code != 201:
        print("Error creating job listing:", response.text)
        return None
    job = response.json()
    print("Job created:", json.dumps(job, indent=2))
    return job

def update_job_listing(job_id, update_payload):
    url = f"{BASE_URL}/job-listings/update/"
    # Include job_id in the update payload
    update_payload["job_id"] = job_id
    response = requests.put(url, json=update_payload)
    if response.status_code != 200:
        print("Error updating job listing:", response.text)
    else:
        print("Job updated:", json.dumps(response.json(), indent=2))

if __name__ == "__main__":
    # Create a job listing
    job = create_job_listing()
    if not job:
        exit(1)
    
    # Use the created job's id for updates
    job_id = job.get("job_id")
    if job_id is None:
        print("Job ID not returned.")
        exit(1)
    
    # Update scenario 1: job_status "ongoing" appends to worker_username list
    update_payload = {
        "job_status": "ongoing",
        "worker_username": ["worker1"]
    }
    print("\n--- Updating with job_status 'ongoing' (append) ---")
    update_job_listing(job_id, update_payload)
    
    # Update scenario 2: job_status "accepted" replaces the worker_username list
    update_payload = {
        "job_status": "accepted",
        "worker_username": ["worker2"]
    }
    print("\n--- Updating with job_status 'accepted' (replace) ---")
    update_job_listing(job_id, update_payload)
