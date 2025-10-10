# Study Planner App (Flutter)

A clean and simple **Study Planner App** built with **Flutter**, designed to help students organize their daily study tasks effectively.  
This project demonstrates the use of **multi-screen navigation**, **local storage (SharedPreferences)**, **calendar integration**, and **Material Design UI**.

---

##  Features

### 1. Task Management
- Add, view, and manage tasks with:
  - **Title** (required)
  - **Description** (optional)
  - **Due Date** (required)
  - **Reminder Time** (optional)
- View all tasks for **today** on a dedicated screen.
- **Edit or delete** tasks anytime.

### 2. Calendar View
- Displays a **monthly calendar** using `table_calendar`.
- Days with tasks are **highlighted**.
- Tap a date to view tasks scheduled for that day.

### 3. Reminder System
- Optional reminders for each task.

### 4. Local Storage (Persistence)
- Tasks are stored locally using **SharedPreferences** (as JSON).
- Data persists after closing and reopening the app.
- Reliable and lightweight — no internet connection required.

### 5. Navigation and Screens
- Uses a **BottomNavigationBar** with three main screens:
  1. **Today** – View and manage today's tasks.
  2. **Calendar** – Monthly overview of all tasks.
  3. **Settings** – Manage app preferences and reminder options.

### 6. Settings
- Toggle notifications on or off.
- Display which storage method is used (SharedPreferences).
  
---

## Installation & Setup

###  1. Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) installed
- Android Studio or VS Code
- Emulator or physical Android device

### 2. Clone the repository
```bash
git clone https://github.com/Akhigbesimeon/Individual_Assignment_1.git
cd Individual_Assignment_1
