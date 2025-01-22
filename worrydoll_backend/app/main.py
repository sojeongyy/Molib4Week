# app/main.py
from fastapi import FastAPI
from database import SessionLocal, engine
from models import Base
from routers import worries

app = FastAPI()

# 앱 시작 시, 자동으로 DB 테이블 생성 (개발용)
@app.on_event("startup")
def on_startup():
    Base.metadata.create_all(bind=engine)

@app.get("/")
def read_root():
    return {"message": "Hello, MySQL with FastAPI!"}

app.include_router(worries.router)
