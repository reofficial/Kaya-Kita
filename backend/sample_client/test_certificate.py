import httpx

BASE_URL = "http://127.0.0.1:8000"  # Adjust if your FastAPI is running elsewhere

# Sample Data
worker_username = "john_doe"
date_of_application = "2025-03-21"
licensing_certificate_given = "Yes"
is_senior = "false"
is_pwd = "true"

# Paths to sample files (Use actual image/document paths from your machine)
licensing_certificate_photo = ("licensing.png", open("licensing.png", "rb"), "image/png")
barangay_certificate = ("barangay.pdf", open("barangay.pdf", "rb"), "application/pdf")

# 1️⃣ Create a Certification
def test_create_certification():
    with httpx.Client() as client:
        files = {
            "licensing_certificate_photo": licensing_certificate_photo,
            "barangay_certificate": barangay_certificate
        }
        data = {
            "worker_username": worker_username,
            "date_of_application": date_of_application,
            "licensing_certificate_given": licensing_certificate_given,
            "is_senior": is_senior,
            "is_pwd": is_pwd
        }
        response = client.post(f"{BASE_URL}/certifications/create", data=data, files=files)
        print("CREATE RESPONSE:", response.json())

# 2️⃣ Get All Certifications
def test_get_all_certifications():
    response = httpx.get(f"{BASE_URL}/certifications")
    print("ALL CERTIFICATIONS:", response.json())

# 3️⃣ Get Certification by Username
def test_get_certification_by_username():
    response = httpx.get(f"{BASE_URL}/certifications/{worker_username}")
    print(f"GET {worker_username}:", response.json())

# 4️⃣ Update Certification (Upload New File)
def test_update_certification():
    new_date_of_application = "2025-03-25"
    new_photo = ("new_licensing.jpg", open("new_licensing.png", "rb"), "image/png")

    with httpx.Client() as client:
        files = {"licensing_certificate_photo": new_photo}
        data = {
            "worker_username": worker_username,
            "date_of_application": new_date_of_application,
        }
        response = client.put(f"{BASE_URL}/certifications/update", data=data, files=files)
        print("UPDATE RESPONSE:", response.json())

# 5️⃣ Delete Certification
def test_delete_certification():
    response = httpx.delete(f"{BASE_URL}/certifications/delete/{worker_username}")
    print("DELETE RESPONSE:", response.json())

# Run tests
if __name__ == "__main__":
    test_create_certification()
    test_get_all_certifications()
    test_get_certification_by_username()
    test_update_certification()
    test_get_certification_by_username()  # Verify update
    # test_delete_certification()
    # test_get_all_certifications()  # Verify deletion
