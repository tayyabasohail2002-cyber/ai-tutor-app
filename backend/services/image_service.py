import os
import uuid
import shutil

def save_image(upload_file):
    os.makedirs("media/images", exist_ok=True)

    # Remove spaces from original filename
    original_name = upload_file.filename.replace(" ", "_")

    file_ext = os.path.splitext(original_name)[1]

    filename = f"{uuid.uuid4()}{file_ext}"
    file_path = os.path.join("media/images", filename)

    with open(file_path, "wb") as buffer:
        shutil.copyfileobj(upload_file.file, buffer)

    return file_path