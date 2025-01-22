# app/routers/worries.py
from fastapi import APIRouter, Depends, HTTPException
from fastapi.responses import StreamingResponse
from sqlalchemy.orm import Session
from typing import List
from database import SessionLocal
import models, schemas
from openai_utils import generate_comfort_message, generate_comfort_message_stream
import asyncio
from openai import AsyncOpenAI

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

    comfort = generate_comfort_message(payload.content)
    new_worry.comfort_message = comfort
    db.commit()
    db.refresh(new_worry)

    return new_worry

@router.post("/stream", response_model=schemas.WorryResponse)
def create_worry_stream(payload: schemas.CreateWorry):
    # 1) 직접 세션 열기
    db = SessionLocal()

    # 2) Worry 레코드 생성
    new_worry = models.Worry(content=payload.content)
    db.add(new_worry)
    db.commit()
    db.refresh(new_worry)

    def event_generator():
        # 스트리밍 도중 누적 메시지를 합칠 변수
        comfort_accumulated = ""

        try:
            # 3) OpenAI 스트리밍
            print(">>> Start streaming from OpenAI ...")
            for chunk in generate_comfort_message_stream(payload.content):
                print(">>> GOT CHUNK:", repr(chunk)) 
                yield chunk  
                comfort_accumulated += chunk

            # 4) 스트리밍 정상 종료 → DB에 전체 메시지 저장
            print(">>> Final comfort_accumulated:", repr(comfort_accumulated))  
            new_worry.comfort_message = comfort_accumulated
            db.commit()

        except Exception as e:
            # 중간에 에러 시 rollback
            db.rollback()
            raise e
        finally:
            # 세션 닫기
            db.close()

    # 5) StreamingResponse로 SSE 반환
    return StreamingResponse(event_generator(), media_type="text/event-stream")

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
