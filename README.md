# 🎵 Playr — A Modern Flutter Music Player

Playr is a **modern, offline-first music player** built with **Flutter**, focused on smooth playback, clean UI, and reliable background audio. It leverages industry-standard audio libraries to provide a stable and intuitive local music listening experience.

> Designed as a real-world Flutter project with production-style architecture and best practices.

---

## ✨ Features

* **High-Quality Audio Playback**
  Powered by `just_audio` for reliable and efficient local audio playback.

* **Background & Lock-Screen Playback**
  Uses `audio_service` to keep music playing when the app is backgrounded or the screen is locked.

* **Queue Management**
  Dynamically manage the playback queue with next/previous controls.

* **Shuffle & Repeat Modes**
  Shuffle your library or loop a single track seamlessly.

* **Seek Controls**
  Jump to any position within a track.

* **Local Media Browsing**
  Automatically scans and loads music from device storage.

* **Album & Song Organization**
  Browse music by albums or individual tracks.

* **Album Art Support**
  Displays embedded album artwork for an enhanced visual experience.

* **Minimal, Clean UI**
  Simple and distraction-free interface focused on usability.

---

## 🛠 Tech Stack

* **Flutter** — Cross-platform UI framework
* **audio_service** — Background audio & system controls
* **just_audio** — Feature-rich audio playback engine
* **on_audio_query** — Local media querying
* **provider** — Lightweight and scalable state management

---

## 🚀 Getting Started

### Prerequisites

* **Flutter SDK**
  Install from the official guide: [https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install)

* **Code-OSs** (for Android builds)

---

### Installation

1. **Clone the repository**

   ```bash
   git clone <repository_url>
   cd playr
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

---

## 🔐 Platform Permissions

### Android

Add the following permissions in `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
<uses-permission android:name="android.permission.WAKE_LOCK" />

<!-- Android 13+ -->
<uses-permission android:name="android.permission.READ_MEDIA_AUDIO" />
```

For Android 10+ (API 29):

```xml
<application
    android:requestLegacyExternalStorage="true"
    ...>
```

---

## ▶️ Running the App

1. Connect a physical device or start an emulator
2. Run:

   ```bash
   flutter run
   ```

The app will scan local storage and display available albums and songs.

---

## 🗂 Project Structure

```
lib/
├── logic/
│   ├── providers/     # State management (Provider)
│   └── services/      # Audio & file handling services
│
├── ui/
│   ├── home/           # Home screen & album views
│   └── widgets/        # Reusable UI components
│
└── main.dart
```

---

## 🔮 Planned Enhancements

* 🔍 Global search (songs & albums)
* 🎨 Theme customization
* 📂 Playlist creation & persistence
* 🎚 Equalizer & audio effects
* 🔔 Rich media notifications
* 🌐 Optional online streaming support

---

## 📌 Notes

* This project is focused on **local/offline playback**
* Built to demonstrate **real-world Flutter architecture**
* Suitable for learning audio handling, state management, and media permissions

---

🎧 **Enjoy your music with Playr!**
