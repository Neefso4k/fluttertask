Check-In App

A Flutter-based check-in application for recording locations with photos, GPS coordinates, and notes.

---

Features

- **Photo Capture** - Take photos using camera (Android/iOS) or select from gallery
- **GPS Location** - Get current latitude, longitude, and accuracy
- **Persistent Storage** - All check-ins saved locally using Hive database
- **Permission Management** - Handles runtime permissions gracefully
- **Dark Theme** - Modern gradient UI with glassmorphism effects

---

️Architecture

The app follows a clean separation of concerns:

lib/
├── main.dart               
├── models/
│   └── check_in.dart         
├── services/
│   ├── storage_service.dart     
│   └── location_service.dart    
├── screens/
│   ├── home_screen.dart         
│   ├── new_check_in_screen.dart 
│   └── detail_screen.dart       
└── widgets/
    ├── check_in_card.dart       
    ├── empty_state.dart         
    └── location_widget.dart     


Why this structure?
- Separation of UI and logic for maintainability
- Reusable widgets reduce code duplication
- Services can be easily swapped or mocked for testing

---

How to Run

Steps

1. **Clone the repository:**
   ```bash
   git clone https://github.com/Neefso4k/fluttertask.git
   cd fluttertask
2. flutter pub get
3. flutter pub run build_runner build
4. flutter run

Plugins Used

Plugin	        Purpose
image_picker    Camera and gallery access
geolocator	    location services
hive	        Local NoSQL database
hive_flutter	Flutter integration for Hive
intl	        Date and time formatting
uuid	        Unique ID generation

UI Layouts
✅ Three screens: Home, New Check-In, Detail

✅ Navigation between screens

✅ Home shows list with thumbnail + note + timestamp

✅ Empty state when no data

✅ Note field with validation

✅ Photo button with preview

✅ Location button with loading state

✅ Save button

✅ Detail screen (read-only)

✅ Reusable UI components

TestingVideos

1. Windows
   h[ttps://youtu.be/mWmz_GvKpmI](https://github.com/user-attachments/assets/196da8c5-dd5d-4917-823b-7b25d525632c)

2. Android
  [ https://youtube.com/shorts/SVSIVG3Sf_8?feature=share](https://github.com/user-attachments/assets/b4577f2a-993e-4fc5-a002-f1aae19815cd)
