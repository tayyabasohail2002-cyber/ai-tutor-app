![License](https://img.shields.io/badge/license-MIT-blue.svg)
📌 Overview

AI Tutor App is an intelligent learning platform that converts any topic into a complete learning experience  including script, voice explanation, and video tutor output.

Built using modern technologies like FastAPI, Flutter, and AI APIs, this app simulates a real teacher explaining concepts in simple, human-friendly language.

✨ Key Features

🧠 AI Script Generation

Converts any topic into a simple, easy-to-understand explanation.

🎧 Text-to-Speech Audio

Generates natural voice explanations using TTS.

🎥 AI Tutor Video Generation

Combines image + audio to simulate a teaching assistant.

🧑‍🏫 Male & Female Tutor Selection

Personalized learning experience.

📱 Modern Flutter UI

Clean, responsive, and user-friendly interface.

☁️ Cloud Storage Integration

Uses Cloudinary for managing media files.

🏗️ Tech Stack

🔹 Frontend

Flutter

Dart

🔹 Backend

FastAPI (Python)

SQLModel / SQLite

🔹 AI & Services

Google Gemini API (Script generation)

Edge TTS / gTTS (Audio)

Cloudinary (Media storage)

⚙️ System Architecture

User Input (Topic)

        ↓
Gemini AI → Script Generation

        ↓
TTS → Audio Generation

        ↓
Cloudinary → Store Audio/Image

        ↓
Video Service → Combine into Tutor Video

        ↓
Flutter App → Display Video

📸 Screenshots


<img width="495" height="715" alt="Screenshot 2026-05-29 224856" src="https://github.com/user-attachments/assets/1c24472e-8800-47fa-a45e-bb1e0726a4b0" />
<img width="496" height="712" alt="Screenshot 2026-05-29 224920" src="https://github.com/user-attachments/assets/b5ed6f30-47f4-495d-b50e-498e5cf65201" />
<img width="497" height="715" alt="Screenshot 2026-05-29 224954" src="https://github.com/user-attachments/assets/e46e03f3-eefb-4a45-8874-b034c3427d33" />
<img width="498" height="714" alt="Screenshot 2026-05-29 225009" src="https://github.com/user-attachments/assets/edc87f69-c2f0-452d-b0c4-68a35bae37b9" />
<img width="500" height="712" alt="Screenshot 2026-05-29 225055" src="https://github.com/user-attachments/assets/73f8421f-d0f8-4afb-8215-9861e7c3889a" />
<img width="493" height="713" alt="Screenshot 2026-05-29 225041" src="https://github.com/user-attachments/assets/e7f72f14-f27c-4bd6-b274-15f8935cd1bd" />
<img width="496" height="712" alt="Screenshot 2026-05-29 225127" src="https://github.com/user-attachments/assets/47a2686e-7ec7-4115-ba00-b9b3f08117e5" />
<img width="497" height="712" alt="Screenshot 2026-05-29 224521" src="https://github.com/user-attachments/assets/9dcceba7-9fc3-44f3-ad37-775bd9b04560" />

Demo video


https://github.com/user-attachments/assets/898f1d7d-3627-48f3-8e70-eae74bf00437



🚀 Getting Started

1️⃣ Clone Repository

git clone  https://github.com/tayyabasohail2002-cyber/ai-tutor-app.git

cd ai-tutor-app

2️⃣ Backend Setup

cd backend

python -m venv venv

venv\Scripts\activate

pip install -r requirements.txt

uvicorn main:app --reload

3️⃣ Frontend Setup

cd flutter_frontend

flutter pub get

flutter run

🔐 Environment Variables

Create a .env file in the backend:

GEMINI_API_KEY=your_key_here

CLOUDINARY_CLOUD_NAME=your_name

CLOUDINARY_API_KEY=your_key

CLOUDINARY_API_SECRET=your_secret

⚠️ Never push .env to GitHub (already ignored via .gitignore)

🧪 Challenges & Solutions

Challenge	Solution

Gemini model errors	Switched to supported models (gemini-2.5-flash)

Audio API failures	Implemented fallback (gTTS / Edge TTS)

Video API limitations	Added alternative flow without D-ID

File format issues	Forced image format (PNG/JPG)

📈 Future Improvements

🎙️ Real-time voice interaction

🧠 Smarter AI explanations (context-aware)

🎬 Full AI avatar video (when API credits available)

🌍 Multi-language support

👩‍💻 Author

Tayyaba sohail

Software Developer | AI Enthusiast

🤝 Collaboration

This project was built independently, with collaborative support during development and testing.

⭐ Support

If you like this project:

⭐ Star the repo

🍴 Fork it

📢 Share it

📄 License

This project is licensed under the MIT License.
