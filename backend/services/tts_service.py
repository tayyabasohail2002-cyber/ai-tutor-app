import edge_tts
import asyncio
import os
from services.cloudinary_service import upload_audio

async def generate_audio(text: str, gender: str):
    try:
        print("🔊 Generating audio with Edge TTS...")

        file_path = "audio.mp3"

        # ✅ Select voice based on gender
        if gender == "male":
            voice = "en-US-GuyNeural"
        else:
            voice = "en-US-JennyNeural"

        communicate = edge_tts.Communicate(text, voice)
        await communicate.save(file_path)

        print("✅ Audio file created")

        # ✅ Upload to cloudinary
        audio_url = upload_audio(file_path)

        print("✅ Uploaded:", audio_url)

        os.remove(file_path)

        return audio_url

    except Exception as e:
        print("🔥 AUDIO ERROR:", e)
        return None