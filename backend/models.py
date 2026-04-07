from sqlmodel import SQLModel, Field, Relationship
from typing import Optional, List
from datetime import datetime

class Video(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    user_id: int = Field(foreign_key="user.id")
    prompt: str
    tutor_gender: Optional[str] = None
    tutor_image: Optional[str] = None  # uploaded image path
    script_text: Optional[str] = None
    audio_path: Optional[str] = None
    video_path: Optional[str] = None
    status: str = Field(default="processing")
    created_at: datetime = Field(default_factory=datetime.utcnow)

    user: Optional["User"] = Relationship(back_populates="videos")


class User(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    email: str
    password: str
    videos: List[Video] = Relationship(back_populates="user")