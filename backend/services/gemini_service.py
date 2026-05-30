from google import genai
import os
from dotenv import load_dotenv

load_dotenv()

client = genai.Client(
    api_key=os.getenv("GEMINI_API_KEY")
)

def generate_script(prompt: str):
    try:
        full_prompt = f"""
You are a friendly teacher.

Explain this topic clearly:
{prompt}

Rules:
- Use simple English
- Keep it under 120 words
- Give one real-life example
- Make it sound natural (not robotic)
"""

        response = client.models.generate_content(
            model="gemini-2.5-flash",   # ✅ CORRECT NAME
            contents=full_prompt
        )

        # Debug (optional)
        print("✅ Gemini response received")

        if response and hasattr(response, "text") and response.text:
            return response.text.strip()

        # fallback if empty response
        return f"{prompt} is an important concept. It is used in real life applications to make systems smarter."

    except Exception as e:
        print("🔥 GEMINI ERROR:", e)

        return f"{prompt} is a basic concept. Please try again."