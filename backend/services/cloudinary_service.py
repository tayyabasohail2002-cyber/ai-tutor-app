import cloudinary
import cloudinary.uploader
import os

# ✅ CONFIG
cloudinary.config(
    cloud_name=os.getenv("CLOUDINARY_CLOUD_NAME"),
    api_key=os.getenv("CLOUDINARY_API_KEY"),
    api_secret=os.getenv("CLOUDINARY_API_SECRET")
)


# ================= IMAGE UPLOAD =================
def upload_image(file):
    try:
        result = cloudinary.uploader.upload(
            file,
            resource_type="image",

            # 🔥 IMPORTANT FIX FOR D-ID
            format="png"   # forces png instead of avif/webp
        )

        return result["secure_url"]

    except Exception as e:
        print("❌ Cloudinary Image Upload Error:", e)
        return None


# ================= AUDIO UPLOAD =================
def upload_audio(file_path):
    try:
        result = cloudinary.uploader.upload(
            file_path,
            resource_type="video"  # ✅ required for audio files
        )

        return result["secure_url"]

    except Exception as e:
        print("❌ Cloudinary Audio Upload Error:", e)
        return None