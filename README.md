# 📍 Check-In App

A Flutter application for recording check-ins with photos, GPS location, and notes.

---

## 🚀 How to Run

### Prerequisites
- Flutter SDK (latest stable)
- Android Studio / VS Code
- Android emulator or physical device

*Steps*

1. **Clone the repository:**
   git clone https://github.com/Neefso4k/fluttertask.git
   cd fluttertask

2. **Install dependencies:**
flutter pub get

3. **Generate Hive adapter:**
flutter pub run build_runner build

4. **Run the app:**
flutter run

5. **Choose a device:**
For Android: Select Android emulator or USB Debugging
For Windows: Type 1 and press Enter
For Chrome: Type 2 and press Enter


*Plugins Used*

Plugin	        Version	    Purpose
image_picker	^1.0.7	    Camera and gallery access
geolocator	    ^10.1.0	    GPS location services
hive	        ^2.2.3	    Local NoSQL database
hive_flutter	^1.1.0	    Flutter integration for Hive
intl	        ^0.19.0	    Date and time formatting
uuid	        ^4.3.3	    Unique ID generation

*Project Structure*

lib/
├── main.dart                    # App entry point
├── models/
│   └── check_in.dart            # CheckIn data model
├── services/
│   ├── storage_service.dart     # Hive storage operations
│   └── location_service.dart    # GPS location services
├── screens/
│   ├── home_screen.dart         # Home/History screen
│   ├── new_check_in_screen.dart # New Check-In screen
│   └── detail_screen.dart       # Detail view screen
└── widgets/
    ├── check_in_card.dart       # Reusable check-in card
    ├── empty_state.dart         # Empty state widget
    └── location_widget.dart     # Location display widget