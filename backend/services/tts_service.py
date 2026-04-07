import edge_tts
import os
import uuid

async def generate_audio(script_text: str, gender: str):

    voice = "en-US-GuyNeural" if gender == "male" else "en-US-JennyNeural"

    os.makedirs("media/audio", exist_ok=True)

    filename = f"{uuid.uuid4()}.mp3"
    path = os.path.join("media/audio", filename)

    communicate = edge_tts.Communicate(script_text, voice)
    await communicate.save(path)

    return f"/media/audio/{filename}"