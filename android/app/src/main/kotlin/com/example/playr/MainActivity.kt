package com.example.playr

import io.flutter.embedding.android.FlutterActivity
import com.ryanheise.audioservice.AudioServiceActivity

class MainActivity: AudioServiceActivity() {
    // This class now handles the FlutterEngine specifically 
    // for background audio tasks automatically.
}