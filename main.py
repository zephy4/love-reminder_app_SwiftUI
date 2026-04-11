from fastapi import FastAPI
import random

app = FastAPI()

quotes = [
    "You are loved more than you know.",
    "Someone out there is grateful you exist.",
    "Your heart is stronger than your doubts.",
    "Even on hard days, you matter.",
    "You deserve love exactly as you are."
]

@app.get("/")
def home():
    return {"message": "Quotes API is running ❤️"}

@app.get("/quote")
def get_quote():
    return {"quote": random.choice(quotes)}