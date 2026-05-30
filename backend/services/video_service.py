import requests
import time
import os

DID_API_KEY = os.getenv("DID_API_KEY")

def generate_video(image_url, audio_url):

    url = "https://api.d-id.com/talks"

    headers = {
        "Authorization": f"Basic {DID_API_KEY}",
        "Content-Type": "application/json"
    }

    payload = {
        "source_url": image_url,
        "script": {
            "type": "audio",
            "audio_url": audio_url
        }
    }

    response = requests.post(url, json=payload, headers=headers)

    print("D-ID RESPONSE:", response.text)

    if response.status_code != 201:
        raise Exception(response.text)

    talk_id = response.json()["id"]

    # ⏳ Wait until video ready
    while True:
        status_res = requests.get(
            f"https://api.d-id.com/talks/{talk_id}",
            headers=headers
        )

        data = status_res.json()

        if data["status"] == "done":
            return data["result_url"]

        elif data["status"] == "error":
            raise Exception(data)

        time.sleep(3)