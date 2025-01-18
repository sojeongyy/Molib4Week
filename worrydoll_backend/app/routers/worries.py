# app/routers/worries.py
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from database import SessionLocal
import models, schemas

router = APIRouter(prefix="/worries")

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# 걱정 생성
@router.post("/", response_model=schemas.WorryResponse)
def create_worry(payload: schemas.CreateWorry, db: Session = Depends(get_db)):
    new_worry = models.Worry(content=payload.content)
    db.add(new_worry)
    db.commit()
    db.refresh(new_worry)
    return new_worry

# 모든 걱정 조회
@router.get("/", response_model=List[schemas.WorryResponse])
def get_all_worries(db: Session = Depends(get_db)):
    return db.query(models.Worry).all()

# 걱정 수정
@router.patch("/{worry_id}", response_model=schemas.WorryResponse)
def update_worry(
    worry_id: int,
    payload: schemas.UpdateWorry, 
    db: Session = Depends(get_db)
):
    worry = db.query(models.Worry).filter(models.Worry.id == worry_id).first()
    if not worry:
        raise HTTPException(status_code=404, detail="Worry not found")

    worry.content = payload.content
    db.commit()
    db.refresh(worry)

    return worry

# 걱정 해결
@router.patch("/{worry_id}/resolve", response_model=schemas.WorryResponse)
def resolve_worry(worry_id: int, db: Session = Depends(get_db)):
    worry = db.query(models.Worry).filter(models.Worry.id == worry_id).first()
    if not worry:
        raise HTTPException(status_code=404, detail="Worry not found")

    worry.is_resolved = True
    db.commit()
    db.refresh(worry)

    return worry
