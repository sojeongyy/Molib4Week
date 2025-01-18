# app/schemas.py
from pydantic import BaseModel
from datetime import datetime

class CreateWorry(BaseModel):
    content: str

class WorryResponse(BaseModel):
    id: int
    content: str
    date_created: datetime
    is_resolved: bool

    class Config:
        from_attributes = True

class UpdateWorry(BaseModel):
    content: str

