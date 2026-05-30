from google import genai
import os
from dotenv import load_dotenv

load_dotenv()

client = genai.Client(api_key=os.getenv("GEMINI_API_KEY"))

def list_models():
    try:
        models = client.models.list()

        print("\n🔥 AVAILABLE MODELS:\n")
        for m in models:
            print("➡", m.name)

    except Exception as e:
        print("❌ ERROR:", e)


if __name__ == "__main__":
    list_models()