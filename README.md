Leveler – Fitness Gamification Application

Human-Computer Interaction – Semester Project 2025–2026
Phase 3: Functional Flutter Demo
Group 4 (Erasmus)

a) Application Files

GitHub Repository (source code – ZIP):
https://github.com/p0bodin/projet_flutter

Release APK:
[PASTE HERE A CLOUD LINK – GitHub Release / Google Drive]

The application source code and the release APK are publicly accessible via the links above.

b) Installation Instructions (APK)

These instructions are intended for non-specialist users.

Requirements

Android smartphone or tablet

Android 12 or higher (API 31+)

Bluetooth enabled (for optional features)

Installation Steps

Download the APK file using the provided link.

On the Android device:

Open Settings → Security

Enable Install unknown apps (or Allow from this source).

Open the downloaded app-release.apk.

Confirm installation.

Launch the application from the app drawer.

No additional configuration, database setup, or external services are required.

c) Usage Instructions

Launch the application.

Log in using the predefined user.

Navigate through the application using the bottom navigation bar.

Available features:

Dashboard with player statistics

Training and exercise management

Quest tracking and completion

Inventory management

Bluetooth device detection (e.g. smartwatch)

Gamified fight mode based on player stats

User progress and actions are saved automatically.

d) Data Persistence

The application uses local data persistence (shared_preferences) to store:

Player statistics

Completed activities

Quest progress

Stored data remains available:

When navigating between screens

After closing and reopening the application

e) System Requirements

Flutter SDK: 3.10.4

Dart SDK: 3.10.4

Target Android Version: Android 12+ (API 31+)

Tested on: Physical Android device

Android image: With Google Play services

Note: Bluetooth functionality requires a real Android device. Android emulators do not fully support Bluetooth connections.

f) Differences from Phase 2 Prototype (Optional)

Compared to the Phase 2 prototype, the inventory system has been extended to support Bluetooth-connected objects (e.g. smartwatch integration).