from fastapi import APIRouter, Depends, HTTPException, Query, UploadFile, File
from sqlmodel import Session
from database import get_session
from models import Video
from schemas import VideoCreate, VideoResponse

# Services
from services.gemini_service import generate_script
from services.tts_service import generate_audio
from services.video_service import generate_video
from services.image_service import save_image

router = APIRouter()

# ---------------- SCRIPT ----------------
@router.post("/generate/script", response_model=VideoResponse)
def create_script(
    video_data: VideoCreate,
    user_id: int = Query(...),
    session: Session = Depends(get_session),
):
    video = Video(
        user_id=user_id,
        prompt=video_data.prompt,
        tutor_gender=video_data.gender,
        status="processing",
    )
    session.add(video)
    session.commit()
    session.refresh(video)

    # Generate script
    script = generate_script(video_data.prompt)
    video.script_text = script
    video.status = "script_ready"

    session.commit()
    session.refresh(video)
    return video

# ---------------- AUDIO ----------------
@router.post("/generate/audio", response_model=VideoResponse)
async def create_audio(video_id: int, session: Session = Depends(get_session)):
    video = session.get(Video, video_id)
    if not video or not video.script_text:
        raise HTTPException(status_code=400, detail="Script not ready")

    audio_url = await generate_audio(video.script_text, video.tutor_gender)
    video.audio_path = audio_url
    video.status = "audio_ready"

    session.commit()
    session.refresh(video)
    return video

# ---------------- IMAGE UPLOAD ----------------
@router.post("/upload-image", response_model=VideoResponse)
async def upload_image(
    video_id: int,
    file: UploadFile = File(...),
    session: Session = Depends(get_session),
):
    video = session.get(Video, video_id)
    if not video:
        raise HTTPException(status_code=404, detail="Video not found")

    image_path = save_image(file)
    video.tutor_image = image_path

    session.commit()
    session.refresh(video)
    return video

# ---------------- VIDEO ----------------
@router.post("/generate/video", response_model=VideoResponse)
def create_video(video_id: int, session: Session = Depends(get_session)):
    video = session.get(Video, video_id)
    if not video or not video.audio_path or not video.tutor_image:
        raise HTTPException(status_code=400, detail="Missing audio or image")

    image_file = video.tutor_image.lstrip("/")
    audio_file = video.audio_path.lstrip("/")

    video_filename = generate_video(image_file, audio_file)
    video.video_path = f"/media/videos/{video_filename}"
    video.status = "ready"

    session.commit()
    session.refresh(video)
    return video

# ---------------- REGENERATE SCRIPT ----------------
@router.post("/regenerate/script", response_model=VideoResponse)
def regenerate_script(
    video_id: int = Query(...),
    session: Session = Depends(get_session),
):
    video = session.get(Video, video_id)
    if not video:
        raise HTTPException(status_code=404, detail="Video not found")

    script = generate_script(video.prompt)
    video.script_text = script
    video.status = "script_ready"

    session.commit()
    session.refresh(video)
    return video