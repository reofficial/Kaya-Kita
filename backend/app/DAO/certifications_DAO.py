from motor.motor_asyncio import AsyncIOMotorDatabase
from app.classes import WorkerCertificationDB, WorkerCertificationInput
from typing import List, Optional, Dict, Any
import os
from fastapi import UploadFile

class WorkerCertificationDAO:
    def __init__(self, db: AsyncIOMotorDatabase, upload_dir: str = os.path.join("static", "uploads")):
        self.collection = db["WorkerCertifications"]
        self.upload_dir = upload_dir
        os.makedirs(self.upload_dir, exist_ok=True)

    async def save_file(self, file: UploadFile, worker_username: str, suffix: str) -> str:
        new_filename = f"{worker_username}_{suffix}_{file.filename}"
        file_path = os.path.join(self.upload_dir, new_filename)
        with open(file_path, "wb") as f:
            f.write(await file.read())
        return f"/static/uploads/{new_filename}"

    async def create_certification(
        self,
        input_data: WorkerCertificationInput,
        licensing_certificate_photo: UploadFile,
        barangay_certificate: UploadFile
    ) -> WorkerCertificationDB:
        lic_url = await self.save_file(licensing_certificate_photo, input_data.worker_username, "photo")
        barangay_url = await self.save_file(barangay_certificate, input_data.worker_username, "document")
        db_data = WorkerCertificationDB(
            **input_data.dict(),
            licensing_certificate_photo=lic_url,
            barangay_certificate=barangay_url
        )
        await self.collection.insert_one(db_data.dict())
        return db_data

    async def read_certification_by_username(self, worker_username: str) -> Optional[WorkerCertificationDB]:
        doc = await self.collection.find_one({"worker_username": worker_username})
        if not doc:
            return None
        return WorkerCertificationDB(**doc)

    async def read_certifications(self) -> List[WorkerCertificationDB]:
        cursor = self.collection.find()
        docs = await cursor.to_list(length=None)
        return [WorkerCertificationDB(**doc) for doc in docs]

    async def update_certification(
        self,
        worker_username: str,
        update_fields: dict,
        licensing_certificate_photo: Optional[UploadFile] = None,
        barangay_certificate: Optional[UploadFile] = None
    ) -> bool:
        if licensing_certificate_photo:
            lic_url = await self.save_file(licensing_certificate_photo, worker_username, "photo")
            update_fields["licensing_certificate_photo"] = lic_url
        if barangay_certificate:
            barangay_url = await self.save_file(barangay_certificate, worker_username, "document")
            update_fields["barangay_certificate"] = barangay_url

        result = await self.collection.update_one(
            {"worker_username": worker_username},
            {"$set": update_fields}
        )
        return result.modified_count > 0

    async def delete_certification(self, worker_username: str) -> bool:
        result = await self.collection.delete_one({"worker_username": worker_username})
        return result.deleted_count > 0