# Project Roadmap & Implementation Plan

> [!IMPORTANT]
> **Overall Goal:** Deliver a stable, testable Minimum Viable Product (MVP) demonstrating educational effectiveness and value through playable levels, an execution engine with visual feedback, an adaptive rule-based hint system, and Firebase-backed progress tracking.

## Table of Contents
1. [Phase 1: Architecture, Diagrams & Setup (Week 1)](#phase-1-architecture-diagrams--setup-week-1)
2. [Phase 2: UI Foundation, Auth & Level Design (Week 2)](#phase-2-ui-foundation-auth--level-design-week-2)
3. [Phase 3: Game Grid & Interaction Mechanics (Weeks 3–4)](#phase-3-game-grid--interaction-mechanics-weeks-34)
4. [Phase 4: Execution Engine, Hints & Error Handling (Weeks 5–6)](#phase-4-execution-engine-hints--error-handling-weeks-56)
5. [Phase 5: Cloud Integration, Offline Sync & Polish (Weeks 7–8)](#phase-5-cloud-integration-offline-sync--polish-weeks-78)
6. [Phase 6: UAT, Metrics & Defense Preparation (Weeks 9–10)](#phase-6-uat-metrics--defense-preparation-weeks-910)
7. [Project Standards & Requirements](#project-standards--requirements)

---

## Phase 1: Architecture, Diagrams & Setup (Week 1)
**🎯 Goal:** Establish technical, academic, and collaborative foundations.

### Team Responsibilities
* **👤 Member 1 (UI/UX Lead)**
    * Finalize Figma wireframes (Login, Dashboard, Game Grid, Echo Hint popup/UI).
    * Ensure UI follows low cognitive load principles with a clean, distraction-free design.
    * Export all necessary SVG assets.
    * Implement global Flutter theme (Dark mode + typography).
* **👤 Member 2 (Logic Lead)**
    * Define Riverpod structure (`LevelStateNotifier` for static data, `ExecutionStateNotifier` for dynamic states).
    * Implement domain models (`Coordinate`, `CommandBlock`, `CommandType` enum).
* **👤 Member 3 (Backend/QA Lead)**
    * Initialize GitHub repository with branch protection and rules.
    * Set up CI/CD pipeline (analyze + test on Pull Requests).
    * Configure Firebase (Authentication + Firestore).
    * Finalize system diagrams (Context, Use Case, Sequence, Class).
    * Create, distribute, and begin collecting responses for the initial survey.

**✅ Deliverables:**
- [x] Working project skeleton.
- [x] CI/CD pipeline active.
- [x] Firebase connected.
- [x] Survey deployed.
- [x] All diagrams ready for the thesis.

---

## Phase 2: UI Foundation, Auth & Level Design (Week 2)
**🎯 Goal:** Enable user authentication and define foundational educational content.

### Team Responsibilities
* **👤 Member 1 (UI/UX Lead)**
    * Build Login and Signup UI.
    * Build Dashboard UI (XP tracking, sector selection).
    * Implement navigation using `go_router` with appropriate route guards.
* **👤 Member 2 (Logic Lead)**
    * Scaffold execution engine (draft `runSequence()`, basic movement logic, and `checkCollision()`).
    * Write initial unit tests for coordinate math and logic.
* **👤 Member 3 (Backend/QA Lead)**
    * Integrate Firebase Authentication.
    * Create Firestore user document generation on registration.
    * Design 5 MVP levels (grid layout + expected logic), focusing on sequencing and direction.

**✅ Deliverables:**
- [x] User can log in and access the dashboard.
- [x] Level data defined (local + Firestore-ready format).
- [x] Basic unit tests running successfully.

---

## Phase 3: Game Grid & Interaction Mechanics (Weeks 3–4)
**🎯 Goal:** Build the core gameplay interaction layer (visuals and input).

### Team Responsibilities
* **👤 Member 1 (UI/UX Lead)**
    * Implement 5x5 GridView.
    * Render the character (Auri), obstacles, and the goal state.
    * Build draggable command blocks and Drop Zone UI.
* **👤 Member 2 (Logic Lead)**
    * Connect drag-and-drop functionality to Riverpod state.
    * Maintain the List sequence in state.
    * Connect grid rendering to `LevelState` (sync visual grid with logical state).
* **👤 Member 3 (Backend/QA Lead)**
    * Implement offline fallback mechanisms (local JSON level loading).
    * Upload finalized levels to Firestore.
    * Write widget tests covering drag-and-drop behavior.

**✅ Deliverables:**
- [x] Fully interactive grid environment.
- [x] Command blocks can be successfully added, rearranged, and removed.
- [x] Levels load dynamically from Firestore or local fallback.

---

## Phase 4: Execution Engine, Hints & Error Handling (Weeks 5–6)
**🎯 Goal:** Implement core logic systems and ensure algorithmic correctness.

### Team Responsibilities
* **👤 Member 1 (UI/UX Lead)**
    * Build state-based UI for the Run button (Idle / Running / Stopped).
    * Implement Reflection Modal UI (Prompting the user: *"What did you expect Auri to do here?"* before showing hints).
    * Implement Echo Hint popup and success/failure overlays.
* **👤 Member 2 (Logic Lead)**
    * **Execution Engine:** Implement step-by-step execution $\mathcal{O}(n)$, add 500ms delay between steps, and implement constant-time $\mathcal{O}(1)$ collision detection.
    * **Trajectory-Aware Logic:** Add attempt tracking per level and store `attemptCount` in `ExecutionState`.
    * **Adaptive Hint System:** Map attempts to hints (Attempt 1 = General hint; Attempt 2+ = Specific hint).
    * **Structural Evaluation (Safe Scope):** Compare user command sequence to the expected logic pattern, detect incorrect steps before collision occurs, and provide targeted feedback.
* **👤 Member 3 (Backend/QA Lead)**
    * Write robust unit tests for the execution engine, collision logic, and hint system.
    * Write error-handling tests (empty sequences, Firestore fallback behavior, invalid game states).

> [!CAUTION]
> **🛑 MILESTONE: MVP FREEZE (End of Week 6)**
> No new features allowed past this point. The sole focus shifts to stability, bug fixing, and performance optimization.

**✅ Deliverables:**
- [x] Fully playable levels.
- [x] Execution engine stable and accurate.
- [x] Reflection-based and adaptive hint systems working as intended.
- [x] ≥70% test coverage on core logic.

---

## Phase 5: Cloud Integration, Offline Sync & Polish (Weeks 7–8)
**🎯 Goal:** Connect gameplay to persistent data and refine the user experience.

### Team Responsibilities
* **👤 Member 1 (UI/UX Lead)**
    * Add animations (e.g., smooth character movement).
    * Ensure responsive UI behavior across target device sizes.
* **👤 Member 2 (Logic Lead)**
    * Implement local storage for onboarding states.
    * Implement offline progress queue (cache XP updates locally, sync automatically upon network reconnection).
* **👤 Member 3 (Backend/QA Lead)**
    * Implement Firestore progression logic (updating XP, unlocking subsequent levels).
    * Enable real-time dashboard updates utilizing Firestore streams.

**✅ Deliverables:**
- [x] Player progress reliably saved and synced.
- [x] Offline play fully supported without data loss.
- [x] UI polished, smooth, and fully responsive.

---

## Phase 6: UAT, Metrics & Defense Preparation (Weeks 9–10)
**🎯 Goal:** Validate educational value, measure performance, and finalize the thesis document.

### Team Responsibilities
* **👤 Member 1 (UI/UX Lead)**
    * Finalize UI polish (contrast checks, layout alignment, asset optimization).
    * Document all UI/UX design decisions and rationales.
* **👤 Member 2 (Logic Lead)**
    * Fix edge-case bugs discovered during testing.
    * Document the execution engine architecture and algorithm complexity.
* **👤 Member 3 (Backend/QA Lead)**
    * Conduct User Acceptance Testing (UAT) with target demographic (≥5 beginner users).
    * Collect and synthesize metrics: completion rate, attempts per level, and hint effectiveness.
    * Perform security audit on Firestore database rules.
    * Compile the final thesis document.

**✅ Deliverables:**
- [x] Stable, working demo ready for presentation.
- [x] Educational results and metrics successfully measured and formatted.
- [x] Final thesis document ready for submission and defense.

---

## Project Standards & Requirements

### 🔷 Definition of Done (Global)
A feature, task, or module is considered complete *only* if it meets the following criteria:
- [ ] Functionally working as intended.
- [ ] Reviewed and approved via Pull Request.
- [ ] Covered by appropriate automated tests (Unit, Widget, or Integration).
- [ ] Free of critical or blocking bugs.
- [ ] Accompanied by updated documentation (if architectural changes were made).

### 🔷 Final MVP Requirements (For Defense)
To be considered ready for defense, the project must successfully demonstrate:
1. Secure login and authentication.
2. A minimum of 3 to 5 fully playable levels.
3. A functional, step-by-step execution engine.
4. A rule-based, adaptive hint system.
5. Persistent progress saving via Firebase.
6. Functional offline fallback capabilities.
7. Basic, smooth animations for gameplay clarity.

> [!WARNING]
> ### 🛡️ Risk Control (Strictly Enforced)
> * **No feature creep** is permitted after Week 6.
> * **Machine Learning (ML) hint systems** are strictly relegated to "Future Work".
> * **Stability > Complexity:** A simple, flawlessly working feature is always prioritized over a complex, buggy one.