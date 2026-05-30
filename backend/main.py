from dotenv import load_dotenv
load_dotenv()
import os
import logging
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from database import create_db
from auth import router as auth_router
from tutor import router as tutor_router

# Setup logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Initialize FastAPI app
app = FastAPI(title="AI Tutor Backend")

# Enable CORS for Flutter frontend
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # development only
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Create media folders
os.makedirs("media/audio", exist_ok=True)
os.makedirs("media/videos", exist_ok=True)
os.makedirs("media/images", exist_ok=True)

# Mount static files
app.mount("/media", StaticFiles(directory="media"), name="media")

# Include routers
app.include_router(auth_router, prefix="/auth")
app.include_router(tutor_router, prefix="/tutor")

# Root endpoint
@app.get("/")
def root():
    return {"message": "AI Tutor Backend Running"}

# Startup event
@app.on_event("startup")
def startup_event():
    try:
        create_db()
        logger.info("Database initialized successfully")
    except Exception as e:
        logger.error(f"Database startup error: {e}")
        raise e