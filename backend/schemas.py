# schemas.py
from pydantic import BaseModel
from typing import Optional
from sqlmodel import SQLModel
class VideoCreate(BaseModel):
    prompt: str
    gender: str

class VideoResponse(SQLModel):
    id: int
    user_id: int
    prompt: str
    tutor_gender: str

    script_text: Optional[str] = None
    audio_path: Optional[str] = None
    tutor_image: Optional[str] = None

    video_path: Optional[str] = None   # ✅ ADD THIS

    status: str

    class Config:
        from_attributes = True