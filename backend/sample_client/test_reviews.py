import httpx
import os
from dotenv import load_dotenv
import datetime

load_dotenv()
BASE_URL = os.getenv("BACKEND_URL")

worker_review_data = {
    "worker_username": "worker1",
    "customer_username": "customer1",
    "rating": 5,
    "review": "Excellent service!",
    "created_at": datetime.datetime.now().isoformat()
}

# 1. Create a worker review (POST)
print("Creating worker review...")
create_response = httpx.post(f"{BASE_URL}/reviews/create", json=worker_review_data, verify=False)
print(f"POST Status: {create_response.status_code}")
print(f"Response: {create_response.json()}")

# Extract review_id from response. If not directly returned, fetch it using GET.
created_review = create_response.json()
review_id = created_review.get("review_id")
if review_id is None:
    # Try to retrieve the review_id from the GET /reviews endpoint
    get_response = httpx.get(f"{BASE_URL}/reviews", verify=False)
    reviews = get_response.json()
    if reviews:
        review_id = reviews[0].get("review_id")
        print(f"Worker review created with review_id: {review_id}")
    else:
        print("Failed to retrieve created worker review. Exiting...")
        exit()
else:
    print(f"Worker review created with review_id: {review_id}")

# 2. Read all worker reviews (GET)
print("\nFetching all worker reviews...")
all_reviews_response = httpx.get(f"{BASE_URL}/reviews", verify=False)
print(f"GET Status: {all_reviews_response.status_code}")
print(f"Response: {all_reviews_response.json()}")

# 3. Update worker review (PUT)
# Modify some data: update rating and review text.
updated_data = worker_review_data.copy()
updated_data["review_id"] = review_id
updated_data["rating"] = 4
updated_data["review"] = "Good service, but room for improvement."

print("\nUpdating worker review...")
update_response = httpx.put(f"{BASE_URL}/reviews/update", json=updated_data, verify=False)
print(f"PUT Status: {update_response.status_code}")
print(f"Response: {update_response.json()}")

# 4. Get worker reviews by customer (GET)
print("\nFetching worker reviews by customer...")
customer_response = httpx.get(f"{BASE_URL}/reviews/{worker_review_data['customer_username']}", verify=False)
print(f"GET Status: {customer_response.status_code}")
print(f"Response: {customer_response.json()}")

# 5. Get worker reviews by worker (GET)
print("\nFetching worker reviews by worker...")
worker_response = httpx.get(f"{BASE_URL}/reviews/worker/{worker_review_data['worker_username']}", verify=False)
print(f"GET Status: {worker_response.status_code}")
print(f"Response: {worker_response.json()}")

# 6. Delete worker review (DELETE)
print("\nDeleting worker review...")
delete_response = httpx.delete(f"{BASE_URL}/reviews/delete/{review_id}", verify=False)
print(f"DELETE Status: {delete_response.status_code}")
print(f"Response: {delete_response.json()}")

# 7. Verify deletion by fetching all worker reviews again
print("\nVerifying deletion by fetching all worker reviews...")
final_response = httpx.get(f"{BASE_URL}/reviews", verify=False)
print(f"GET Status: {final_response.status_code}")
print(f"Response: {final_response.json()}")

print("All tests completed.")