import os
import uuid
import shutil

from services.cloudinary_service import upload_image

def save_image(file):
    contents = file.file.read()

    image_url = upload_image(contents)

    return image_url  # ✅ PUBLIC URL
