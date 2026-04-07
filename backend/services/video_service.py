import subprocess
import uuid
import os

def generate_video(image_path, audio_path):
    filename = f"{uuid.uuid4()}.mp4"
    output_path = os.path.join("media/videos", filename)

    command = [
        "ffmpeg",
        "-y",
        "-loop", "1",
        "-i", image_path,
        "-i", audio_path,
        "-vf", "scale=trunc(iw/2)*2:trunc(ih/2)*2",
        "-c:v", "libx264",
        "-tune", "stillimage",
        "-pix_fmt", "yuv420p",
        "-r", "30",
        "-c:a", "aac",
        "-b:a", "192k",
        "-shortest",
        output_path
    ]

    subprocess.run(command, check=True)

    return filename   # ✅ RETURN ONLY FILENAME