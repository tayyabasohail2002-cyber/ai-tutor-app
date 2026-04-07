# services/gemini_service.py

import os
import requests
from dotenv import load_dotenv

load_dotenv()

API_KEY = os.getenv("GEMINI_API_KEY")

def generate_script(prompt: str):

    if not API_KEY:
        return "AI explanation could not be generated (missing API key)."

    url = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key={API_KEY}"

    payload = {
        "contents": [
            {
                "parts": [
                    {
                       "text": f"""
You are an expert teacher creating a short lesson for students.

Explain the following topic clearly and simply.

Topic: {prompt}

Rules:
1. Use simple language.
2. Explain step by step.
3. Give a real-life example if possible.
4. Keep explanation around 120-150 words.
5. End with a short summary.

Start the explanation now.
"""
                    }
                ]
            }
        ]
    }

    headers = {"Content-Type": "application/json"}

    try:
        response = requests.post(url, headers=headers, json=payload)

        if response.status_code != 200:
            print("Gemini Error:", response.text)
            return "AI explanation could not be generated."

        data = response.json()

        if "candidates" not in data:
            return "AI explanation could not be generated."

        return data["candidates"][0]["content"]["parts"][0]["text"]

    except Exception as e:
        print("Gemini Exception:", e)
        return "AI explanation failed."