# app/database.py
import os
import time
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.exc import OperationalError


DATABASE_URL = os.getenv("DATABASE_URL")

# MySQL 연결 대기 로직
connected = False
while not connected:
    try:
        engine = create_engine(DATABASE_URL, echo=True)
        with engine.connect() as connection:
            print("✅ Connected to the database successfully!")
            connected = True
    except OperationalError:
        print("❌ Database not ready, retrying in 5 seconds...")
        time.sleep(5)

# 세션 생성
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
