from motor.motor_asyncio import AsyncIOMotorDatabase
from app.classes import WorkerReviews
from typing import List, Optional

class WorkerReviewsDAO:
    def __init__(self, db: AsyncIOMotorDatabase):
        self.collection = db["WorkerReviews"]
    
    #CRUD operations
    async def create_review(self, review: WorkerReviews):
        # Automatically assigns review id
        last_review = await self.collection.find_one(
            {}, sort=[("review_id", -1)]
        )
        new_id = (last_review["review_id"] + 1) if last_review else 0

        review_data = review.model_dump()
        review_data["review_id"] = new_id

        await self.collection.insert_one(review_data)
        return WorkerReviews(**review_data)
    
    async def read_reviews(self) -> List[WorkerReviews]:
        reviews_cursor = self.collection.find()
        reviews = await reviews_cursor.to_list(length=None)
        return [WorkerReviews(**review) for review in reviews]
    
    async def read_reviews_by_customer(self, username: str) -> List[WorkerReviews]:
        reviews_cursor = self.collection.find({"customer_username": username})
        reviews = await reviews_cursor.to_list(length=None)
        return [WorkerReviews(**review) for review in reviews]
    
    async def read_reviews_of_worker(self, username: str) -> List[WorkerReviews]:
        reviews_cursor = self.collection.find({"worker_username": username})
        reviews = await reviews_cursor.to_list(length=None)
        return [WorkerReviews(**review) for review in reviews]
    
    async def update_review(self, review: WorkerReviews) -> None:
        await self.collection.update_one({"review_id": review.review_id}, {"$set": review.model_dump(exclude={"review_id"})})
    
    async def delete_review(self, review_id: int) -> None:
        await self.collection.delete_one({"review_id": review_id})