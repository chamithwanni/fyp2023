import shutil
from typing import Optional
from fastapi import FastAPI, File, UploadFile
from TestImageEmotion import emotion_test
from SpotifyGenerator import get_create_playlist
from fastapi.middleware.cors import CORSMiddleware


app = FastAPI()

origins = ["*"]
app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/about")
def about():
    return {"Data": "about"}

@app.post("/uploadfile")
#async def create_upload_file(file: UploadFile = File(...)):
#    emotion_test(file)
#    return {"filename": file.filename}
async def create_upload_file(file: UploadFile = File(...)):
    file_path = f"./test/{file.filename}"
    with open(file_path, "wb") as buffer:
        shutil.copyfileobj(file.file, buffer)
    result = emotion_test(file_path)
    return {"emotion": result}

@app.post("/playlist")
async def create_playlist(name: str,genres: str,mood: str):
    final_playlist = get_create_playlist(name,genres,mood)
    return final_playlist




