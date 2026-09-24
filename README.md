# Boarding Bridge 🏫

A modern Flutter-based school and boarding management portal designed for students, parents, teachers, and administrators.

## ✨ Overview

Boarding Bridge helps schools manage:

- 👩‍🎓 student registration
- 👨‍👩‍👧‍👦 parent and guardian records
- 🏠 boarding/room tracking
- 📊 academic result uploads
- 🧾 announcements and notices
- 👤 role-based app access

This project is designed to be clean, simple, and portal-like so users can move through the application quickly and confidently.

---

## 🌟 Features

- 🧑‍💼 Admin dashboard for registration and bulk CSV uploads
- 👨‍🏫 Teacher view for academic monitoring
- 👨‍👩‍👧 Parent access for child records and results
- 🎓 Student profile and result summaries
- 📣 School notices panel managed by admins
- 🎨 polished portal-inspired UI with light/dark themes
- 🔐 role-based entry flow and local persistence

---

## 🧩 Role-based Access

- Admin 🛠️
- Teacher 👩‍🏫
- Parent 👨‍👩‍👧
- Student 🎓

Each role gets a tailored dashboard and a focused set of actions.

---

## 📦 Project Structure

```text
Boarding-Bridge/
├─ .github/
│  └─ workflows/
├─ android/
├─ ios/
├─ lib/
│  ├─ core/
│  │  ├─ app_roles.dart
│  │  ├─ constants.dart
│  │  └─ theme.dart
│  |
│  ├─ models/
│  │  ├─ announcement.dart
│  │  ├─ parent.dart
│  │  ├─ result.dart
│  │  └─ student.dart
│  |
│  ├─ providers/
│  │  └─ app_provider.dart
│  |
│  ├─ screens/
│  │  ├─ admin_upload_results_screen.dart
│  │  ├─ browser_mockup_screen.dart
│  │  ├─ entry_screen.dart
│  │  ├─ home_screen.dart
│  │  ├─ main_scaffold.dart
│  │  ├─ registration_screen.dart
│  │  ├─ role_selection_screen.dart
│  │  ├─ splash_screen.dart
│  │  ├─ student_results_screen.dart
│  │  └─ students_list_screen.dart
│  |
│  ├─ services/
│  │  ├─ storage_service.dart
│  │  └─ supabase_service.dart
│  |
│  ├─ widgets/
│  │  ├─ announcements_panel.dart
│  │  ├─ photo_picker_field.dart
│  │  └─ ...
│  |
│  ├─ main.dart
│  └─
│
├─ supabase/
│  └─ announcements.sql
├─ test/
├─ .gitignore
├─ pubspec.yaml
├─ README.md
└─ pubspec.lock
```

---

## 🚀 Getting Started

### 1) Install Flutter

Make sure Flutter is installed and configured on your machine.

### 2) Install dependencies

```bash
flutter pub get
```

### 3) Run the app

```bash
flutter run
```

---

## 🛠️ Tech Stack

- Flutter 💙
- Dart 🧠
- Provider 📦
- Supabase ☁️
- Image Picker 📷
- File Picker 📁
- CSV parsing 📊
- Shared Preferences 💾

---

## 🧠 Notes

- Supabase connection values should be configured in `lib/core/constants.dart`.
- App announcements are stored in the `announcements` table.
- The project is structured so it can be expanded into a full school management system.

---

## 📌 App Flow

```text
Start 🚀
  ↓
Entry Screen 🏠
  ↓
Role Selection 👤
  ↓
Dashboard 🧭
  ├─ Admin 🛠️
  ├─ Teacher 👩‍🏫
  ├─ Parent 👨‍👩‍👧
  └─ Student 🎓
```

---

## ✅ Summary

Boarding Bridge is a portal-style school management app that brings together student data, parent communication, results, and admin workflows in one place.

Built with care for a modern, simple, and expressive user experience. ✨

