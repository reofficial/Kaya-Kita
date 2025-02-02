# Kaya-Kita

This is a course requirement for CS 191/CS192 Software Engineering Courses of the Department of Computer Science, College of Engineering, University of the Philippines, Diliman under the guidance of Prof. Ma. Rowena C. Solamo for the AY 2024-2025.

## Team Members

Calabia, Bastian Nathaniel\
Chan, Krisha Anne\
Limbo, Seth Kiefer\
Lopez, Alec Terence\
Roy, Rodrigo Emmanuel

## Tech Stack
Frontend: Flutter (Android)\
Backend: Python(FastAPI)\
Database: MongoDB

# Project Setup

## Frontend
For members working on frontend:\
Note: Files and folders in the initial commit are made through `flutter create .`\
Install Flutter: https://docs.flutter.dev/get-started/install\
Using the terminal, `cd frontend`\
Launch an emulator:\
`flutter emulators`\
`flutter emulators --launch <emulator id>`\
Launch the app:\
`flutter run`

## Backend
For members working on backend:\
Using the terminal, `cd backend`\
Create a virtual environment: `python -m venv venv`\
Activate virtual environment: Windows: `.\venv\Scripts\Activate`, Mac/Linux: `source venv/bin/activate` \
Run `pip install -r requirements.txt`\
Ask for .env file from RE (for privacy reasons), place it inside backend folder\
To run the server: `uvicorn app.main:app --reload`
