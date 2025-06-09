# ⚡ Kawach – EV Telemetry & Chatbot App

Welcome to **Kawach**, an advanced Flutter-based mobile application designed to provide **real-time electric vehicle (EV) telemetry**, including battery data, GPS tracking, and a smart AI-powered chatbot assistant. This repo contains the complete source code, structure, and guidelines for contributors.

### ✅ Goals:
- Add a chatbot UI page (chat bubbles, input field, send button)
- Use any AI API (OpenAI preferred, Firebase optional)
- Handle user messages and show bot responses
- Keep all chatbot code inside: `lib/chatbot/`
- Ensure no breaking changes to the rest of the app

### ❌ Don’ts:
- Don’t modify the `main` branch
- Don’t push any Firebase keys, API keys, or secrets
- Don’t touch existing app flows unless told

---

## 🚗 Project Overview

Kawach is an IoT-powered mobile application that communicates with an EV’s onboard hardware system to provide:

- 📍 Real-time GPS location tracking  
- 🔋 Battery Management System (BMS) data (Voltage, SOC, Temp, etc.)  
- 🧠 Chatbot assistant for smart queries  
- 🌐 Firebase Realtime Database for data storage  
- ☁️ Optional AWS IoT Core + DynamoDB integration  
- 💬 Place search via Google Maps & Google Places APIs

---

## 🧱 Tech Stack

| Platform | Tech |
|---------|------|
| 📱 Frontend | Flutter |
| 🔌 Backend | Firebase Realtime Database (HTTPS), AWS IoT Core |
| 🌍 APIs | Google Maps, Google Places, Geocoding |
| 🧠 AI Assistant | OpenAI or Dialogflow (planned) |

---

## 📂 Folder Structure

```bash
lib/
├── main.dart
├── pages/             # All app pages (Navigation, Stats, Map, etc.)
├── chatbot/           # Chatbot integration (WIP)
├── models/            # Data models
├── services/          # Firebase & API services
├── widgets/           # Custom UI widgets
