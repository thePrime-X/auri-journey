# 🌌 Auri’s Journey

**Auri’s Journey** is a mobile puzzle-based educational game designed to introduce beginners to foundational programming logic and computational thinking through interactive gameplay.

The application allows users to guide **Auri**, a small robot character, across a grid by arranging visual command blocks. Instead of requiring users to write programming syntax, the game focuses on the underlying logic behind programming, such as sequencing, direction, planning, problem decomposition, and step-by-step execution.

This project was developed as part of a Bachelor of Computer Science diploma project. The current version represents a functional MVP with authentication, Firestore-based level loading, command execution, adaptive hints, progress tracking, achievements, daily challenges, and offline progress synchronization.

---

## 📌 Project Overview

Modern beginner programming environments often introduce learners directly to syntax, which can be intimidating for users with little or no programming background. **Auri’s Journey** addresses this by removing syntax from the first learning experience and replacing it with visual, puzzle-based logic construction.

Users solve missions by selecting commands such as:

- `MOVE_FORWARD`
- `TURN_LEFT`
- `TURN_RIGHT`

These commands are placed into a sequence and executed step by step. The game visually demonstrates how each command changes Auri’s position and direction, helping users understand how command order affects program behavior.

The MVP focuses mainly on **sequencing** and **spatial reasoning**, while the architecture is prepared for future programming concepts such as conditions, loops, debugging, and more advanced adaptive feedback.

---

## 🎯 Main Goal

The goal of this project is to demonstrate how a mobile-first puzzle game can help beginners understand computational thinking concepts without requiring traditional code syntax.

The application is designed to support:

- active problem-solving
- logical sequencing
- command-based reasoning
- reflection after mistakes
- beginner-friendly interaction
- short mobile learning sessions

---

## ✨ Key Features

### 🔐 User Authentication

Auri’s Journey supports account-based access using Firebase Authentication.

Users can:

- sign up with email and password
- log in
- log out
- maintain a persistent session
- have individual progress saved under their own profile

During registration, users must accept the Privacy and Data Policy before account creation.

---

### 🧭 Onboarding Flow

First-time users are introduced to the app through onboarding screens. These screens explain the basic purpose of the game, progression system, and learning experience before users enter the main application.

Onboarding completion is stored locally so returning users do not see the onboarding flow again.

---

### 🎮 Puzzle-Based Gameplay

The core gameplay is based on a fixed grid environment. Users arrange command blocks to guide Auri from a starting position to a target tile.

The MVP supports:

- command block selection
- drag-and-drop command sequence construction
- visual command queue
- 5×5 grid layout
- Auri position and direction rendering
- obstacles and target tiles
- step-by-step command execution

This allows learners to focus on logic and planning rather than programming syntax.

---

### ⚙️ Execution Engine

The execution engine is the core logic component of the game.

When the user presses **Run**, the engine:

1. Reads the command sequence.
2. Resets the level state.
3. Executes each command in order.
4. Updates Auri’s direction or position.
5. Checks boundaries and obstacles.
6. Determines success or failure.
7. Produces a step-by-step execution trace.

The engine supports deterministic execution, meaning the same command sequence always produces the same result. This makes the gameplay predictable and suitable for learning.

---

### 🚧 Collision and Boundary Detection

The engine prevents invalid movement by checking:

- whether the next position is inside the grid
- whether the next cell contains an obstacle
- whether Auri reaches the target tile

If Auri attempts to move outside the grid or into an obstacle, execution stops and the attempt is marked as failed.

---

### 💡 Echo Hint System

The Echo hint system provides learning support when users fail a mission.

The hint system includes:

- first-failure conceptual hints
- repeated-failure targeted hints
- reflection prompts
- exact sequence hints
- sequence comparison with optimal solution

The goal of Echo is not simply to give the answer immediately, but to encourage users to reflect on what happened and improve their reasoning.

---

### 🧠 Reflection-Based Learning

After repeated failure, the app may show a reflection prompt. This encourages users to think about their command sequence and compare their expected result with the actual execution.

This supports active learning and helps users understand mistakes rather than only correcting them.

---

### 🏆 XP and Progression System

The app tracks user progress through XP and mission completion.

The progress system includes:

- total XP
- current mission
- completed missions
- completed level IDs
- replay protection
- mission progress bar
- current level display

XP is awarded only when a mission is completed for the first time. Replaying a completed mission allows practice but does not give duplicate XP.

---

### 👤 User Profile

The profile screen displays the user’s learning progress.

It includes:

- username
- total XP
- current level
- completed missions
- total playtime
- streak days
- skill map
- achievements

The profile helps users track long-term progress and learning activity.

---

### 📊 Skill Map

The skill map visualizes the user’s development across programming-related concepts.

In the MVP:

- sequencing is actively tracked
- conditions are exposure-locked
- loops are exposure-locked
- debugging is exposure-locked

The locked skills represent future concepts that can be introduced through additional levels.

---

### 🥇 Achievements

The app includes an achievement system to motivate users.

Current achievement examples include:

- First Mission
- 100 XP
- Perfect Run
- 3 Day Streak
- No Hint Win

Unlocked achievements are visually highlighted, while locked achievements remain dimmed.

---

### 📅 Daily Challenge

The daily challenge is an optional engagement feature.

Daily challenges:

- provide extra XP
- are separate from main mission progression
- do not affect the mission progress bar
- do not affect the skill map
- do not change the current main mission
- become completed after a successful attempt

This separation ensures that daily challenges support engagement without distorting the structured learning path.

---

### 🔄 Offline Progress Queue

The app includes offline progress handling for main mission completion.

If Firestore saving fails, the app stores progress locally in a queue. When connectivity returns, queued progress is synchronized with Firestore.

The dashboard includes a sync status badge that can display:

- Offline
- Queued
- Syncing
- Synced

This improves reliability and user confidence when network conditions are unstable.

---

### ⚙️ Settings and User Control

The settings screen allows users to:

- view privacy policy status
- edit profile name
- reset progress
- log out
- visually toggle sound effects
- visually toggle haptic feedback

The reset progress feature clears learning progress and returns the user to the initial state.

---

## 🧱 Tech Stack

| Layer | Technology |
|---|---|
| Frontend | Flutter |
| Language | Dart |
| State Management | Riverpod |
| Navigation | go_router |
| Backend | Firebase |
| Authentication | Firebase Authentication |
| Database | Cloud Firestore |
| Local Storage | SharedPreferences |
| Testing | Flutter Test |

---

## 🗂️ Project Structure

The project follows a feature-based structure to keep the codebase organized and maintainable.

```txt
lib/
├── app/
│   ├── app.dart
│   └── router.dart
│
├── core/
|   ├── config/
│   ├── services/
│   ├── theme/
│   └── utils/
│
├── features/
│   ├── auth/
│   │   ├── application/
│   │   ├── data/
│   │   └── presentation/
│   │
│   ├── dashboard/
|   |   ├── domain/
│   │   └── presentation/
│   │
│   ├── gameplay/
│   │   ├── application/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── onboarding/
│   │   ├── application/
│   │   └── presentation/
│   │
│   └── profile/
│       ├── application/
│       ├── data/
│       └── domain/
│
└── shared/
    └── widgets/


## 🧩 Core Domain Models

The gameplay system is built around a small set of domain models that represent the level configuration, command logic, and runtime execution state.

| Model | Purpose |
|---|---|
| `Coordinate` | Represents a grid cell using `row` and `col` values. |
| `Direction` | Represents Auri’s current facing direction: `up`, `right`, `down`, or `left`. |
| `CommandType` | Represents available command blocks, including movement and turning commands. |
| `LevelState` | Stores the full configuration of a playable level, including grid size, start position, target position, obstacles, available commands, hints, reward XP, and optimal solution. |
| `ExecutionState` | Stores the runtime state during command execution, including Auri’s current position, direction, command queue, execution status, step index, and attempt count. |
| `ExecutionStatus` | Represents the current execution result: `idle`, `running`, `success`, or `failure`. |

---

## 🔥 Firestore Collections

The application uses Cloud Firestore to store user data, level data, daily challenge data, and per-level progress records.

### `users`

The `users` collection stores user profile and progress data. Each document ID matches the authenticated Firebase user ID.

| Field | Type | Description |
|---|---|---|
| `displayName` | string | User display name shown in the dashboard and profile. |
| `email` | string | User email address from Firebase Authentication. |
| `createdAt` | timestamp | Date and time when the user profile was created. |
| `lastLoginAt` | timestamp | Date and time of the user’s latest login. |
| `lastActiveDate` | timestamp | Date and time of the user’s latest tracked activity. |
| `currentLevel` | string | ID of the current main mission level. |
| `totalXP` | integer | Total XP earned by the user. |
| `puzzlesCompleted` | integer | Number of completed main missions. |
| `streakDays` | integer | User’s current activity streak count. |
| `totalPlayTimeSeconds` | integer | Total time spent in gameplay sessions, stored in seconds. |
| `completedLevelIds` | array of strings | List of completed main mission level IDs. |
| `skillStats` | map | Stores skill values for `sequences`, `conditions`, `loops`, and `debugging`. |
| `achievements` | map | Stores achievement unlock states such as `firstMission`, `fiveMissions`, `earned100Xp`, `perfectSolution`, `threeDayStreak`, and `noHintWin`. |
| `policyAccepted` | boolean | Indicates whether the user accepted the Privacy and Data Policy. |
| `policyAcceptedAt` | timestamp | Date and time when the policy was accepted. |

#### `skillStats` map

| Field | Type | Description |
|---|---|---|
| `sequences` | integer | User’s sequencing skill progress. |
| `conditions` | integer | Exposure-locked condition skill value. |
| `loops` | integer | Exposure-locked loop skill value. |
| `debugging` | integer | Exposure-locked debugging skill value. |

#### `achievements` map

| Field | Type | Description |
|---|---|---|
| `firstMission` | boolean | Unlocks when the first mission is completed. |
| `fiveMissions` | boolean | Unlocks when five missions are completed. |
| `earned100Xp` | boolean | Unlocks when the user reaches 100 XP. |
| `perfectSolution` | boolean | Unlocks when the user completes a mission using the optimal solution. |
| `threeDayStreak` | boolean | Unlocks when the user reaches a three-day streak. |
| `noHintWin` | boolean | Unlocks when the user completes a mission without using hints. |

---

### `levels`

The `levels` collection stores playable mission configurations. These documents are read by the application to load main missions and daily challenge levels.

| Field | Type | Description |
|---|---|---|
| `id` | string | Unique level ID, such as `level_1` or `daily_1`. |
| `title` | string | Level title shown in the UI. |
| `order` | integer | Level order used for mission sequencing. |
| `gridSize` | integer | Size of the square grid. The MVP uses a 5×5 grid. |
| `startPosition` | map | Starting position of Auri using `row` and `col`. |
| `startDirection` | string | Initial direction Auri faces, such as `UP`, `RIGHT`, `DOWN`, or `LEFT`. |
| `targetPosition` | map | Target position that Auri must reach, using `row` and `col`. |
| `obstacles` | array of maps | List of obstacle positions. Each obstacle contains `row` and `col`. |
| `availableCommands` | array of strings | Commands available in the level, such as `MOVE_FORWARD`, `TURN_LEFT`, and `TURN_RIGHT`. |
| `optimalSolution` | array of strings | Expected optimal command sequence for the level. |
| `rewardXp` | integer | XP awarded for completing the level for the first time. |
| `learningObjective` | string | Learning goal of the level. |
| `reflectionPrompt` | string | Reflection question shown after repeated failure. |
| `hints` | map | Contains hint messages for first and repeated failures. |
| `isPublished` | boolean | Determines whether the level can be read by signed-in users. |
| `isUnlockedByDefault` | boolean | Indicates whether the level is initially unlocked. |

#### `startPosition`, `targetPosition`, and `obstacles` map structure

| Field | Type | Description |
|---|---|---|
| `row` | integer | Grid row index. |
| `col` | integer | Grid column index. |

#### `hints` map

| Field | Type | Description |
|---|---|---|
| `first` | string | Hint shown after the first failed attempt. |
| `repeat` | string | Hint shown after repeated failed attempts. |

---

### `dailyChallenges`

The `dailyChallenges` collection stores metadata for optional daily challenge content.

| Field | Type | Description |
|---|---|---|
| `dayNumber` | integer | Challenge day number relative to the user’s starting day. |
| `title` | string | Daily challenge title shown on the dashboard. |
| `description` | string | Short description of the daily challenge. |
| `levelIds` | array of strings | IDs of levels included in the daily challenge. |
| `rewardXp` | integer | XP reward for completing the daily challenge. |
| `isActive` | boolean | Determines whether the challenge can be read by signed-in users. |

Daily challenges are separate from the main mission path. They reward XP but do not update main mission progress, current mission, completed mission IDs, or skill map values.

---

### `users/{uid}/progress`

The `progress` subcollection stores per-level progress records under each user document.

| Field | Type | Description |
|---|---|---|
| `levelId` | string | ID of the completed level. |
| `status` | string | Completion status of the level. |
| `movesUsed` | integer | Number of commands used by the user. |
| `hintsUsed` | integer | Number of hints used during the attempt. |
| `optimalMoves` | integer | Number of commands in the optimal solution. |
| `usedExactHint` | boolean | Indicates whether the exact solution hint was used. |
| `sequenceSkillAwarded` | integer | Amount of sequencing skill awarded for the level. |
| `updatedAt` | timestamp | Date and time when the progress record was last updated. |

---

## 🔐 Firestore Security Rules

The Firestore security rules protect user data and restrict direct modification of system-controlled content.

The rules enforce the following access behavior:

| Rule Area | Behavior |
|---|---|
| User profile access | A signed-in user can read and update only their own `users/{uid}` document. |
| User profile creation | A signed-in user can create only their own profile document, and the document must match the required schema. |
| User profile update | A signed-in user can update only their own profile document. Immutable fields such as `createdAt` and `email` cannot be changed. |
| User progress access | A signed-in user can read and update only their own `users/{uid}/progress` records. |
| User deletion | User documents cannot be deleted from the client application. |
| Level access | Signed-in users can read only published levels where `isPublished` is `true`. |
| Level writes | Level documents are read-only from the client application. |
| Daily challenge access | Signed-in users can read only active daily challenges where `isActive` is `true`. |
| Daily challenge writes | Daily challenge documents are read-only from the client application. |
| Fallback rule | Any unmatched document path denies both read and write access. |

These rules ensure that users cannot access other users’ profiles, cannot modify level content, and cannot directly edit daily challenge definitions.

---

## 🧪 Testing

The project was tested using both automated checks and manual QA.

### Automated checks

```bash
flutter analyze
flutter test

## 🧪 Manual QA Coverage

| Test Area | Validation |
|---|---|
| Onboarding flow | Verified that first-time users see onboarding and returning users do not. |
| Signup and login | Verified account creation, login, logout, and session restoration. |
| Dashboard loading | Verified XP, progress, current mission, daily challenge, and sync status display. |
| Mission completion | Verified successful command execution, XP reward, and mission completion screen. |
| Mission replay | Verified that replaying completed missions does not grant duplicate XP. |
| Failure and hints | Verified first-failure hints, repeated-failure reflection, and exact hint behavior. |
| Daily challenge | Verified XP-only reward, completed daily state, and separation from main mission progress. |
| Profile updates | Verified XP, missions, playtime, skill map, and achievements display. |
| Reset progress | Verified that XP, missions, skills, achievements, and daily state reset correctly. |
| Offline synchronization | Verified offline progress queueing and synchronization on reconnect. |
| Firestore rules | Verified user-owned access, read-only levels, and read-only daily challenges. |
| UI responsiveness | Verified screen layout, button visibility, scrolling behavior, and absence of major overflow issues. |

---

## ✅ MVP Scope

The current MVP supports the following functionality:

| Area | MVP Capability |
|---|---|
| Authentication | Signup, login, logout, and persistent user sessions. |
| Onboarding | First-time user onboarding stored locally. |
| Level loading | Firestore-based level loading with local fallback support. |
| Gameplay | Grid-based puzzle missions using visual command blocks. |
| Execution | Step-by-step execution of command sequences. |
| Validation | Boundary detection, obstacle collision detection, success detection, and failure detection. |
| Feedback | Echo hints, reflection prompts, repeated-failure guidance, and exact hint support. |
| Progression | XP, completed missions, current level, replay protection, streak, and playtime tracking. |
| Profile | User profile, skill map, achievements, and progress summary. |
| Daily challenge | Optional XP-based challenge separate from main progression. |
| Settings | Edit profile name, reset progress, privacy policy access, logout, and visual preference toggles. |
| Offline support | Local progress queue and synchronization when connectivity returns. |
| Security | Firestore rules for user-owned data and read-only system content. |

---

## 🚧 Current Limitations

The MVP intentionally keeps the scope focused on beginner-friendly sequencing and puzzle-based logic.

| Limitation | Description |
|---|---|
| Limited main levels | The MVP includes a small number of main missions to demonstrate the core learning flow. |
| Sequencing-focused gameplay | The current playable mechanics focus mainly on movement sequencing. |
| Loops and conditions are future mechanics | Loop and conditional commands are represented as future concepts but are not yet playable in the MVP. |
| Daily challenges are predefined | Daily challenge content is prepared in advance rather than generated automatically. |
| No ML-based personalization | The Echo hint system is rule-based rather than machine-learning based. |
| No educator dashboard | The MVP does not include a teacher or administrator analytics dashboard. |
| Authentication requires internet | New login attempts require internet access through Firebase Authentication. |

---

## 🚀 Future Work

Future versions of the application can extend the MVP in the following ways:

| Future Improvement | Description |
|---|---|
| More missions and sectors | Expand the number of levels and introduce additional learning stages. |
| Playable loop commands | Add loop-based command blocks and levels focused on repetition. |
| Playable condition commands | Add conditional logic such as `IF_PATH_CLEAR`. |
| Debugging-focused levels | Add levels where users identify and correct flawed command sequences. |
| Educator dashboard | Provide teachers with class progress, completion rates, and learning analytics. |
| Advanced daily challenges | Add rotating daily content, streak rewards, and more varied challenge types. |
| ML-based adaptive hints | Use learner behavior patterns to provide more personalized feedback. |
| Richer achievements | Add more milestone-based and concept-based achievements. |
| Detailed learning analytics | Track attempts, hint effectiveness, average solve time, and improvement over time. |
| Cloud-based level editor | Allow educators or administrators to create and publish new levels through a web interface. |

---

## 👥 Team Contribution

This project was developed by a team of three Bachelor of Computer Science students. Responsibilities were divided across UI/UX design, gameplay logic, backend integration, testing, documentation, and project management. Major decisions were reviewed collaboratively throughout development.

### Mohammad Shahid

Primary responsibilities:

- Literature review contribution
- UI/UX design
- Figma mockups
- Visual theme design
- Color and typography selection
- Command block visual design
- 5×5 grid interface design
- Main screen layout design
- Mission grid layout design
- UI visibility testing
- Interface polish

### Chingis

Primary responsibilities:

- Literature review contribution
- Gameplay logic
- Execution flow design
- Execution engine behavior
- Movement and collision logic
- Drag-and-drop interaction
- Route configuration and route guards
- Echo hint behavior
- System diagrams
- Gameplay interaction testing
- Button clickability testing
- Documentation contribution

### Dinsu Bakhyt

Primary responsibilities:

- Literature review contribution
- Firebase project configuration
- Firebase Authentication integration
- Firestore database design
- Firestore security rules
- User profile creation
- Riverpod architecture
- Level loading
- Local level fallback
- Offline progress queue
- Synchronization on reconnect
- Automated testing
- Documentation contribution

All team members contributed to level design, survey distribution, manual testing, feedback review, and iterative improvement of the final MVP.

---

## 📷 Screenshots

The following screenshots demonstrate the main user journey and core system functionality of *Auri’s Journey*. Each screenshot should be inserted below its corresponding figure caption.

### Figure 1. Onboarding Progression Screen

This screen introduces users to the progression system of *Auri’s Journey*. It explains how XP, programming concepts, and sector unlocking are used to motivate continued learning and skill development.

![Figure 1. Onboarding Progression Screen](path/to/onboarding_progression_screen.png)

---

### Figure 2. User Sign-In Interface

The sign-in screen allows returning users to authenticate with an email and password. This interface connects the application to Firebase Authentication and provides access to personalized learning progress.

![Figure 2. User Sign-In Interface](path/to/user_sign_in_interface.png)

---

### Figure 3. User Registration and Policy Agreement Screen

The registration screen allows new users to create an account and requires acceptance of the Privacy and Data Policy before account creation. This supports ethical data handling and user consent.

![Figure 3. User Registration and Policy Agreement Screen](path/to/user_registration_policy_screen.png)

---

### Figure 4. Main Dashboard Interface

The dashboard provides an overview of the user’s current progress, including total XP, synchronization status, daily challenge state, current mission, and mission completion progress.

![Figure 4. Main Dashboard Interface](path/to/main_dashboard_interface.png)

---

### Figure 5. Gameplay Execution Interface

The gameplay screen presents the core puzzle interaction. Users construct command sequences using visual command blocks, execute them on a 5×5 grid, and receive feedback through the Echo hint system.

![Figure 5. Gameplay Execution Interface](path/to/gameplay_execution_interface.png)

---

### Figure 6. Mission Completion and Performance Summary Screen

The mission completion screen summarizes the result of a successful level attempt. It displays earned XP, execution efficiency, completion time, mastered concept, and progression toward the next mission.

![Figure 6. Mission Completion and Performance Summary Screen](path/to/mission_completion_summary_screen.png)

---

### Figure 7(a). User Profile and Learning Progress Overview

The profile screen displays accumulated learning progress, including total XP, current level, completed missions, playtime, and learning insights. This view helps users track their development over time.

![Figure 7(a). User Profile and Learning Progress Overview](path/to/user_profile_overview.png)

---

### Figure 7(b). Skill Map and Achievement Tracking Interface

The skill map visualizes the user’s development across programming-related concepts. Achievements provide additional motivation by rewarding milestones such as first mission completion, optimal solutions, and no-hint wins.

![Figure 7(b). Skill Map and Achievement Tracking Interface](path/to/skill_map_achievement_tracking.png)

---

### Figure 8. Settings and User Preferences Screen

The settings screen provides access to user preferences, privacy policy information, profile editing, progress reset, and logout functionality. This supports user control and basic account management.

![Figure 8. Settings and User Preferences Screen](path/to/settings_user_preferences_screen.png)

---

## 📄 License

This project was developed for academic purposes as part of a diploma project. Usage, modification, and distribution should follow the guidelines agreed upon by the project team and university requirements.

