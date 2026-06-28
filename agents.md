# AI Agent Configuration & Architecture

This repository is maintained and orchestrated using **Antigravity**, an autonomous AI coding assistant developed by the Google DeepMind team.

---

## 🤖 Agent Profiles & Architecture

The system utilizes specialized subagents configured to manage the lifecycle of the codebase:

### 1. Project Management Agent
* **Task**: Tracks implementation goals, maintains project checklists, and aligns code modifications with user criteria.
* **Outputs**: Manages planning artifacts (`task.md`, `implementation_plan.md`, and `walkthrough.md`).

### 2. Flutter UI & Architecture Specialist
* **Task**: Implements responsive design patterns, modular routing via GoRouter, state management utilizing Provider, and visual elements based on Google Fonts and custom animations.
* **Guidelines**: Adheres strictly to the pixel-perfect styling rules defined in `web_application_development` and Flutter clean architecture.

### 3. CI/CD & Automation Agent
* **Task**: Manages GitHub Actions workflows, validates production web builds locally, and automates deployments to the public hosting target repository.

---

## 🛠️ Automated Operations & Commands

The following commands are utilized by the agentic systems to validate codebase health:

```bash
# Static analysis check
flutter analyze

# Release web build compilation
flutter build web --release --base-href "/"
```
