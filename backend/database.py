# database.py
from sqlmodel import SQLModel, create_engine, Session
from typing import Generator
from models import User, Video

DATABASE_URL = "sqlite:///./ai_tutor.db"

engine = create_engine(DATABASE_URL, echo=True, connect_args={"check_same_thread": False})

def create_db():
    SQLModel.metadata.create_all(engine)

def get_session() -> Generator:
    with Session(engine) as session:
        yield session
