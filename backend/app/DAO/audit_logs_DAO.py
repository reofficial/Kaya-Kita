from motor.motor_asyncio import AsyncIOMotorDatabase
from app.classes import AuditLog

class AuditLogDAO:
    def __init__(self, db: AsyncIOMotorDatabase):
        self.collection = db["AuditLog"]
    
    #CRUD operations
    async def create_audit_log(self, audit_log: AuditLog):
        log_data = audit_log.model_dump()
        await self.collection.insert_one(log_data)
        return audit_log
    
    async def read_audit_logs(self):
        logs_cursor = self.collection.find()
        logs = await logs_cursor.to_list(length=None)
        return [AuditLog(**log) for log in logs]
    
    async def read_audit_log_by_username(self, official_username: str):
        log = await self.collection.find_one({"official_username": official_username})
        return AuditLog(**log) if log else None

