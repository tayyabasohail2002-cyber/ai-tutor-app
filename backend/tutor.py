from fastapi import APIRouter, Depends, HTTPException, Query, UploadFile, File
from sqlmodel import Session
import os
import traceback
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

    try:
        script = generate_script(video_data.prompt)
    except Exception as e:
        print("SCRIPT ERROR:", e)
        video.script_text = "Failed to generate explanation."
        video.status = "failed"
        session.commit()
        return video

    video.script_text = script

    # fallback detection
    if "AI is busy" in script or "fallback" in script:
        video.status = "fallback_used"
    else:
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

    try:
        # ✅ FIXED (no await, only 1 argument)
        #audio_url = generate_audio(video.script_text)
        audio_url = await generate_audio(video.script_text, video.tutor_gender)

        if not audio_url:
            raise Exception("Audio generation failed")

    except Exception as e:
        print("AUDIO ERROR:", e)
        raise HTTPException(status_code=503, detail="Audio generation failed")

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
# ---------------- VIDEO ----------------
@router.post("/generate/video", response_model=VideoResponse)
def create_video(video_id: int, session: Session = Depends(get_session)):

    video = session.get(Video, video_id)

    if not video or not video.audio_path or not video.tutor_image:
        raise HTTPException(status_code=400, detail="Missing audio or image")

    image_url = video.tutor_image
    audio_url = video.audio_path

    print("IMAGE URL:", image_url)
    print("AUDIO URL:", audio_url)

    try:
        video_url = generate_video(image_url, audio_url)

        # 🔥 IMPORTANT FIX: NEVER prefix localhost
        if video_url.startswith("http"):
            final_url = video_url
        else:
            final_url = f"http://localhost:8000{video_url}"

        print("FINAL VIDEO URL:", final_url)

    except Exception as e:
        print("VIDEO ERROR FULL:")
        traceback.print_exc()
        raise HTTPException(status_code=500, detail=str(e))

    video.video_path = final_url
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

    try:
        script = generate_script(video.prompt)
    except Exception as e:
        print("REGENERATE ERROR:", e)
        video.script_text = "Retry failed. Try again later."
        video.status = "failed"
        session.commit()
        return video

    video.script_text = script
    video.status = "script_ready"

    session.commit()
    session.refresh(video)

    return video