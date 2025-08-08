# 🎬 Movie App – Functional Context & Feature Flow

This document outlines the complete structure and feature flow of a functional Movie App. It is intended to guide app developers in building a smooth and intuitive movie discovery and streaming experience.

---

Tech Stack:
Frontend: Flutter
Backend/Database: Firebase
UI Framework: Flutter
API: TMDB
State Management: GetX

## 1. 🚀 App Launch

### Splash Screen

- Animated logo or studio intro
- Smooth transition to the Welcome screen

### Welcome Screen

- App branding and tagline
- Action options:
  - **Sign Up**
  - **Log In**
  - **Continue as Guest**

---

## 2. 🔐 Authentication Flow

Users choose between:

- **Sign Up / Log In**
  - Via Email & Password
- **Continue as Guest**
  - Limited access:
    - No watchlist
    - No reviews
    - Cannot save preferences

---

## 3. 🏠 Home Screen

### Key Sections:

- **Featured Movies Carousel**

  - Auto-play banners with top picks or exclusive content

- **Categories**:
  - Trending Now
  - New Releases
  - Top Rated
  - Genres:
    - Action
    - Comedy
    - Horror
    - Drama, Sci-Fi, etc.

### Interactions:

- Scroll vertically for more sections
- Tap on any movie poster → navigates to **Movie Details Page**

---

## 4. 🔍 Search & Discover

### Search Interface:

- Tap 🔍 icon in header
- Search by:
  - Movie Title
  - Actor/Director Name
  - Genre

### Features:

- Auto-complete suggestions
- Recent search history
- Display search results in grid/list view

---

## 5. 📄 Movie Details Page

Shows rich details about the selected movie.

### Components:

- Movie Poster
- Title, Release Year
- Short Description
- Trailer Preview 🎞️ (embedded or modal)
- Genre Tags
- IMDb or App Ratings ⭐
- Cast & Crew List
- **Add to Watchlist** ➕
- Option to start playback (if streaming is available)

---

## 6. ▶️ Watch / Play Movie

_Applicable only if the app supports streaming (like Netflix or Prime Video)._

### Player Features:

- Tap **Play** ▶️ on Movie Details page
- Choose Video Quality:
  - Auto
  - 480p / 720p / 1080p
- Video Player Controls:
  - Play / Pause
  - Rewind / Forward
  - Subtitles (On/Off)
  - Fullscreen toggle
  - Playback speed (optional)

---

## 7. 📝 Watchlist Management

### Watchlist Screen:

- Displays all saved movies
- Actions per item:
  - ✅ Mark as Watched
  - ❤️ Mark as Favorite
  - ❌ Remove from Watchlist

---

## 8. ⭐ Rate & Review

Prompt shown after movie completion or accessible from Movie Details.

### Features:

- Star rating (1–5)
- Text box for short review ✍️
- Option to:
  - Edit or delete your review
  - Share your review to social media

---

## 9. 👤 User Profile

Accessible from bottom nav bar or side drawer.

### Profile Info:

- Avatar and Username
- My Watchlist
- My Reviews
- Watch History
- App Preferences:
  - Language
  - Theme (Light / Dark)
  - Account Settings (Email, Password, etc.)

---

## 10. 🚪 Logout / Exit

- **Logout button** in Profile or Settings
- Optional feedback form on exit
- On next launch, return to Splash → Welcome flow

---

## 🧩 Additional Developer Notes

- **Authentication & Role Management**:

  - Guests vs Registered Users
  - Auth token/session handling

- **Data Storage**:

  - Movie data via TMDB API
  - Watchlist and reviews saved per user
  - Cache watchlist or movie details

- **Theming**:

  - Persistent light/dark mode
  - Theme toggle in Settings

- **Responsiveness**:
  - Mobile-first layout
  - Tablet & large screen adaptations

---

## 📄 Key Screens Summary

| Screen        | Purpose                               |
| ------------- | ------------------------------------- |
| Splash        | App branding intro                    |
| Welcome       | Entry point for sign-in or guest mode |
| Home          | Movie browsing and category display   |
| Search        | Find movies by keyword or genre       |
| Movie Details | View detailed movie info              |
| Watchlist     | Saved and tracked movies              |
| Player        | Watch movie with full controls        |
| Review        | Submit ratings and feedback           |
| Profile       | Manage account, preferences           |
| Settings      | Theme, notifications,                 |

---

---

## 💾 Database Schema (Firebase/Firestore)

This schema is designed for scalability and efficiency, organizing data by collections.

- **`users`**

  - `{userId}`
    - `uid`: String (unique user ID from Firebase Auth)
    - `email`: String
    - `displayName`: String
    - `photoUrl`: String (URL to profile picture)
    - `createdAt`: Timestamp
    - `preferences`: Map
      - `theme`: String (`"light"` or `"dark"`)
      - `language`: String (e.g., `"en"`)

- **`watchlists`**

  - `{userId}`
    - `movies`: Array of movie IDs (e.g., `[76341, 82341]`)
    - `updatedAt`: Timestamp

- **`reviews`**

  - `{reviewId}`
    - `userId`: String (links to a user)
    - `movieId`: Number (TMDB movie ID)
    - `rating`: Number (1-5)
    - `reviewText`: String
    - `createdAt`: Timestamp

- **`favorites`**
  - `{userId}`
    - `movies`: Array of movie IDs
    - `updatedAt`: Timestamp

---

## 📁 Optimal Folder Structure (Flutter)

This feature-first structure promotes scalability and code organization.

```
lib/
├── main.dart                 # App entry point
│
├── app/
│   ├── core/                 # Core utilities, services, and constants
│   │   ├── constants/
│   │   ├── services/         # (e.g., api_service.dart, auth_service.dart)
│   │   ├── theme/
│   │   └── widgets/          # Shared widgets (e.g., CustomButton)
│   │
│   ├── data/
│   │   ├── models/           # Data models (e.g., movie.dart, user.dart)
│   │   └── repositories/     # Data handling logic
│   │
│   ├── modules/              # Feature-based modules
│   │   ├── auth/
│   │   │   ├── controllers/  # GetX controllers
│   │   │   ├── views/        # UI screens
│   │   │   └── widgets/      # Feature-specific widgets
│   │   │
│   │   ├── home/
│   │   │   ├── controllers/
│   │   │   ├── views/
│   │   │   └── widgets/
│   │   │
│   │   ├── movie_details/
│   │   │   └── ...
│   │   │
│   │   └── profile/
│   │       └── ...
│   │
│   └── navigation/
│       ├── app_pages.dart    # Route definitions
│       └── app_routes.dart   # Route names
│
└── generated/                # Auto-generated files (e.g., localization)
```

**End of Movie App Context File**
