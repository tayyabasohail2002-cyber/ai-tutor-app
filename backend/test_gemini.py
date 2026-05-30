from google import genai
import os
from dotenv import load_dotenv

load_dotenv(dotenv_path="../.env")

client = genai.Client(api_key=os.getenv("GEMINI_API_KEY"))

response = client.models.generate_content(
    model="gemini-2.0-flash",
    contents="Explain what is AI in simple words"
)

print(response.text)