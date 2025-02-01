from dotenv import load_dotenv
from fastapi import FastAPI

load_dotenv()       #Loads some constants from the .env file
app = FastAPI()

@app.get("/main")
def main():
    return {"message": "main test successful"}