# Abhay Sharma - Senior Flutter & Python Developer Portfolio

A premium, interactive, and responsive cross-platform developer portfolio website built using **Flutter Web** and styled with modern design patterns (neon gradients, orbit visualizers, dark modes, and micro-animations).

Live Demo: **[https://abhaysharma.github.io](https://abhaysharma.github.io)**

---

## 🚀 Key Features

* **Interactive Home Page**: Features typing animations, rotating orbital visualizer (neon canvas drawing), and clear call-to-actions.
* **Experience Timeline**: An animated vertical timeline showcasing career milestones, focus domains, and key responsibilities.
* **Project Showcase**: A grid of production-grade systems (such as *Nobelpage*, *Workerpool*, *The Teacher App*, *Chronal*, and *Frenn*) with dynamic tag filtering and interactive dialogs.
* **Achievements & Recommendations**: Real-time counter metrics and client recommendations/testimonials.
* **Responsive Layout**: Designed to adapt seamlessly from mobile devices to 4K displays.
* **Dark/Light Mode**: Smooth transitions between linear dark mode and premium light mode.

---

## 🛠️ Technology Stack

* **Core**: Flutter Web, Dart
* **Architecture**: Clean Architecture, Repository Pattern
* **State Management**: Provider
* **Animations**: `flutter_animate`, CustomPainter (Canvas rendering)
* **Routing**: `go_router` (Hash routing strategy)
* **CI/CD**: GitHub Actions (auto-deploying to GitHub Pages)

---

## 📦 Local Setup & Development

To run the project locally, ensure you have the Flutter SDK installed.

1. **Clone the repository**:
   ```bash
   git clone https://github.com/abhaysharma/abhaysharma.github.io.git
   cd abhaysharma.github.io
   ```

2. **Get dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run local dev server**:
   ```bash
   flutter run -d chrome
   ```

4. **Build production release**:
   ```bash
   flutter build web --release --base-href "/"
   ```

---

## 🚀 GitHub Pages Deployment

This project includes a **GitHub Actions workflow** to automate builds and deployments to GitHub Pages.

For detailed instructions and the exact Git commands to initialize the repository and push to GitHub, see **[DEPLOYMENT.md](DEPLOYMENT.md)**.
