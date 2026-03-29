# Thesis Objectives: Auri's Journey

**Project Title:** Development of an Intellectual Game for Teaching Programming Logic and Computational Thinking  
**Platform:** iOS / Mobile  
**Tech Stack:** Flutter, Dart, Firebase, Riverpod, GitHub Actions (CI/CD)  

---

## 🎯 Primary Objective
To design, develop, and evaluate an adaptive iOS educational game that mitigates passive digital consumption by teaching computational thinking and programming logic. The system aims to shift users from reflexive, passive habits (System 1) to active, analytical problem-solving (System 2) through a syntax-free, visually engaging environment.

---

## 📌 Specific Tasks & Project Milestones

The project is divided into six core tasks, categorized into Research, Design, and Implementation phases:

### Phase 1: Research & Gap Analysis
- [x] **1. Analyze Literature:** Synthesize current research on passive digital consumption, cognitive flow in gaming, and the impact of adaptive AI feedback (e.g., the *Reflection-Satisfaction Tradeoff*).
- [x] **2. Identify Research Gaps:** Define the current lack of mobile-first, narrative-driven computational thinking tools that utilize reflection-based feedback rather than simple syntax memorization.

### Phase 2: System Design & Engineering
- [x] **3. Design System Architecture:** Define the UML use case, class diagrams, and infrastructure integrating the Flutter frontend with the Firebase backend (Auth, Firestore).
- [x] **4. Develop Algorithms & Models:** - Engineer a deterministic state machine for the **Execution Engine** (O(n) time complexity).
  - Define the rule-based logic for the **Echo Hint System**, prioritizing trajectory-aware feedback and structural evaluation over immediate answers.
- [x] **5. Design UI/UX:** Create high-fidelity Figma wireframes emphasizing high playability and low cognitive load.

### Phase 3: Implementation & Validation (Current Phase)
- [ ] **6. Implement the MVP:** Develop a fully functional Minimum Viable Product containing the core game grid, drag-and-drop mechanics, execution engine, and cloud synchronization.
- [ ] **7. Evaluate Effectiveness:** Conduct User Acceptance Testing (UAT) against baseline survey data to validate the pedagogical impact of the system.

---

## 📦 MVP Scope & Deliverables
By the final thesis defense, the system will deliver:
1. **Interactive Game Grid:** 3 to 5 fully playable levels on a 5x5 coordinate system.
2. **Visual Command Interface:** Drag-and-drop logic blocks (Move, Turn, Conditionals) requiring zero prior coding syntax knowledge.
3. **Execution Engine:** Step-by-step asynchronous visual execution of user logic.
4. **The Echo System:** An adaptive, rule-based AI assistant that prompts user reflection before providing targeted structural hints.
5. **Backend Integration:** Cloud-synced user progression and offline-play queuing via Firebase.

---

## 📈 Evaluation Metrics
The final success of the educational intervention will be measured using the following quantitative metrics during the UAT phase:
* **Task Completion Rate:** Percentage of users successfully solving the MVP levels.
* **Attempt Efficiency:** The average number of attempts required per level (tracking the learning curve).
* **Hint Effectiveness:** The success rate of users *after* interacting with the Echo reflection prompts and targeted hints.