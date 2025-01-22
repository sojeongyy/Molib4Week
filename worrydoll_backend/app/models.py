# app/models.py
from sqlalchemy import Column, Integer, String, Boolean, DateTime
from sqlalchemy.ext.declarative import declarative_base
from datetime import datetime, timezone

Base = declarative_base()

class Worry(Base):
    __tablename__ = "worries"

    id = Column(Integer, primary_key=True, index=True)
    content = Column(String(500), nullable=False)
    comfort_message = Column(String(500), nullable=True)
    date_created = Column(DateTime, default=datetime.now(timezone.utc))
    is_resolved = Column(Boolean, default=False)
    


