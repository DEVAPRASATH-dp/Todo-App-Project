# Katomaran Todo App

A modern, cross-platform Todo app built with Flutter, featuring persistent Google login, beautiful UI/UX, and local task management.

## Features
- **Google Sign-In Only:** Secure login using Google. No other login methods are available.
- **Persistent Login:** Users stay logged in until they explicitly log out.
- **Modern UI/UX:** Clean, responsive design with filter chips for All, Active, and Completed tasks.
- **Task Management:** Add, complete, and delete tasks. Tasks are stored locally (Hive).
- **Instant Feedback:** Task list and filters update instantly after any action.
- **Logout Confirmation:** Prevents accidental logouts with a confirmation dialog.
- **Profile Editing:** Update your display name from the home screen.

## App Workflow
1. **Login:**
   - On launch, the app checks if the user is logged in.
   - If not, the user is shown a Google Sign-In button.
   - After login, the user is routed to the main task list screen.

2. **Task List:**
   - The home screen displays all tasks, with filter chips for All, Active, and Completed.
   - Tasks can be marked as completed (checkbox), deleted (trash icon), or added (FAB).
   - The UI updates instantly after any change.

3. **Add Task:**
   - Tap the "+ Add Task" button to open the add task screen.
   - Enter title, description, priority, and due date.
   - Save to return to the main screen and see the new task immediately.

4. **Edit Profile:**
   - Tap the edit icon next to your avatar to update your display name.

5. **Logout:**
   - Tap the logout icon for a confirmation dialog.
   - On confirmation, the user is logged out and returned to the login screen.

## Video Demo and APK File
See the full workflow and features in action:
[Google Drive Demo Folder](https://drive.google.com/drive/folders/1hPkNO2O6HnMPuX_UOJ-Yy3WHZ6Nl1tB5?usp=sharing)

## Tech Stack
- **Flutter** (cross-platform mobile/web/desktop)
- **Firebase Auth** (Google sign-in)
- **Hive** (local NoSQL storage)
- **Provider** (state management)

## How to Run
1. Clone the repo.
2. Run `flutter pub get`.
3. Set up Firebase for your app (add your `google-services.json` and `GoogleService-Info.plist`).
4. Run on your device or emulator: `flutter run`

## Notes
- Tasks are stored locally. If you want cloud sync, migrate to Firestore.
- The app is ready for production and device testing.


## Architecture Diagram
+-------------------+
|   User Launches   |
|     the App       |
+---------+---------+
          |
          v
+-------------------+
|  Auth Service     |<-------------------+
| (Firebase Auth,   |                    |
|  Google Sign-In)  |                    |
+---------+---------+                    |
          |                              |
   [Is user logged in?]                  |
    /             \                      |
   /               \                     |
No/                 \Yes                 |
 /                   \                   |
v                     v                  |
+-------------------+   +----------------+------------------+
|  Login Screen     |   |   Main Task List Screen           |
| (Google Sign-In)  |   | (with Filter Chips: All/Active/   |
+-------------------+   |  Completed)                       |
          |             +----------------+------------------+
          |                              |
          v                              v
+-------------------+         +-----------------------------+
| On Success:       |         | Task Provider (State Mgmt)  |
| Route to Main     |         |  - Loads tasks from Hive    |
| Task List Screen  |         |  - Provides tasks to UI     |
+-------------------+         +-----------------------------+
                                         |
                                         v
                          +-------------------------------+
                          | Task List UI                  |
                          | - Shows tasks (filtered)      |
                          | - Add, Complete, Delete       |
                          +-------------------------------+
                                         |
                                         v
                          +-------------------------------+
                          | Task Service                  |
                          | - Add/Update/Delete in Hive   |
                          +-------------------------------+
                                         |
                                         v
                          +-------------------------------+
                          | Hive (Local Storage)          |
                          +-------------------------------+

Other Flows:
- Edit Profile: Main Task List Screen → Edit Profile Screen → Auth Service (update display name)
- Logout: Main Task List Screen → Logout Dialog → Auth Service (sign out) → Login Screen



**Enjoy your productivity!**

## Screenshots
![image](https://github.com/user-attachments/assets/148787cf-f84c-4c9c-959d-72ea92cb29f1)
![WhatsApp Image 2025-07-06 at 22 18 24_86dea88e](https://github.com/user-attachments/assets/e66a5d30-f350-47c7-aaf9-3b5308d1c846)
![WhatsApp Image 2025-07-06 at 22 18 23_824fcb0a](https://github.com/user-attachments/assets/fdbecbc8-4ad0-4858-adf0-cf76d97a57d5)
![WhatsApp Image 2025-07-06 at 22 18 23_f9d64b5f](https://github.com/user-attachments/assets/b5400b43-32c1-45e8-851b-9113d1e290f4)

**This Project is a part of hackathon run by https://www.katomaran.com**




