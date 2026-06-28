import 'package:flutter/material.dart';

class AppConstants {
  static const String name = "Abhay Sharma";
  static const String title =
      "Senior Flutter Developer | Python Backend Developer";
  static const String subTitle =
      "Senior Flutter Developer • Cross-Platform Mobile • Python Backend";

  static const String email =  "sharmaabhayagra@gmail.com";
  static const String phone = "+91 7895003405";
  static const String adminEmail = "sharmaabhayagra@gmail.com";
  static const String location = "Greater Noida, India";

  static const String resumeUrl =
      "https://drive.google.com/file/d/1wAtyKDNrrO1_B6aQS4iXM6sCrNOL66Vg/view?usp=sharing";

  static const String github = "https://github.com/abhaysharma20";
  static const String linkedin = "https://www.linkedin.com/in/abhaysharma20/";
  static const String whatsapp = "https://wa.me/917895003405";

  // Brand colors
  static const Color primaryColor = Color(0xFF00E5FF); // Neon Cyan
  static const Color secondaryColor = Color(0xFF7C4DFF); // Deep Purple
  static const Color accentColor = Color(0xFFFF4081); // Bright Pink

  // Dark mode layout colors (Vercel/Linear style)
  static const Color bgDark = Color(0xFF030303);
  static const Color bgDarkSecondary = Color(0xFF0A0A0A);
  static const Color cardDark = Color(0xFF121212);
  static const Color borderDark = Color(0xFF1E1E1E);

  // Light mode layout colors (Apple/Stripe style)
  static const Color bgLight = Color(0xFFFAFAFC);
  static const Color bgLightSecondary = Color(0xFFF0F2F5);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color borderLight = Color(0xFFE2E8F0);

  // Bio
  static const String professionalSummary =
      "I am a Flutter Developer with 5+ years of experience building scalable, high-performance, production-ready cross-platform applications. "
      "I specialize in Flutter, Dart, Python backend development, and have experience working with React Native and Kotlin.\n\n"
      "I have successfully developed applications in multiple domains including FinTech, Social Media, Restaurant Management, Salon Booking, "
      "and Digital Journaling. I enjoy creating beautiful UI, implementing smooth animations, architecting scalable applications using Clean Architecture, "
      "and solving complex engineering problems.";

  // Quick statistics
  static const List<Map<String, String>> stats = [
    {"value": "5+", "label": "Years Experience"},
    {"value": "15+", "label": "Production Apps"},
    {"value": "5+", "label": "Domains Delivered"},
    {"value": "95%", "label": "CI/CD Automation"},
    {"value": "100%", "label": "Clean Architecture"},
  ];

  // Skills divided by categories
  static const Map<String, List<String>> skills = {
    "Mobile Development": ["Flutter", "Dart", "React Native", "Kotlin"],
    "Backend": ["Python", "REST APIs", "Firebase", "Authentication", "JSON"],
    "Architecture": [
      "Clean Architecture",
      "MVVM",
      "Repository Pattern",
      "Dependency Injection"
    ],
    "State Management": ["GetX", "Provider", "BLoC"],
    "Database": ["Hive", "SQLite", "Firebase Firestore", "Shared Preferences"],
    "Tools": ["Android Studio", "VS Code", "Git", "GitHub", "Figma", "Postman"],
    "CI/CD": ["Fastlane", "GitHub Actions"],
    "UI/UX": [
      "Responsive Design",
      "Material Design",
      "Custom Paint",
      "Custom Animations",
      "Hero Animations",
      "Implicit & Explicit Animations"
    ],
    "Integrations": [
      "Payment Gateway",
      "Push Notifications",
      "Google Maps",
      "Camera",
      "Location",
      "Deep Linking",
      "Social Login"
    ],
  };

  // Experience timeline details
  static const List<Map<String, dynamic>> experience = [
    {
      "role": "Software Developer L1",
      "company": "Vinove Software and Services",
      "period": "Mar 2024 - Present",
      "description":
          "Lead cross-platform mobile initiatives and backend service development, focusing on scaling applications like Nobelpage, Workerpool, and The Teacher App.",
      "domains": [
        "On-Demand Services (Workerpool)",
        "Social Media (Nobelpage)",
        "EdTech (The Teacher App)",
        "Digital Journaling Platform"
      ],
      "points": [
        "Architected enterprise-grade applications (Nobelpage, Workerpool, The Teacher App) using Clean Architecture and the Repository pattern, ensuring modularity and testability.",
        "Created an advanced Custom HTML & Rich Text Editor for a journaling platform with offline sync capabilities and local DB fallback (Hive/SQLite).",
        "Developed scalable backend APIs using Node.js and Express for booking workflows and real-time messaging.",
        "Established CI/CD pipelines using Fastlane and GitHub Actions, slashing deployment times by 40%."
      ]
    },
    {
      "role": "Associate Software Developer",
      "company": "Vinove Software and Services",
      "period": "Oct 2021 - Mar 2024",
      "description":
          "Developed dynamic mobile clients and backend REST microservices.",
      "domains": ["Social Media Platforms (Nobelpage)", "On-Demand Services (Workerpool)"],
      "points": [
        "Built responsive feeds and integrated WebSockets in Nobelpage for real-time chatting.",
        "Developed Node.js-based backend APIs for user authentication, booking scheduling, and state aggregation.",
        "Refactored state management to Provider and BLoC, improving widget build cycles and app performance.",
        "Created custom animations and interactive dashboards with custom canvas rendering (CustomPainter)."
      ]
    },
    {
      "role": "Junior Associate Software Developer",
      "company": "Vinove Software and Services",
      "period": "Apr 2021 - Oct 2021",
      "description":
          "Designed features and native components for Android and iOS systems.",
      "domains": ["Retail Apps", "Native Android Plugins"],
      "points": [
        "Maintained cross-platform applications and implemented native Kotlin code channels for location tracking and deep linking.",
        "Designed UI screens matching pixel-perfect Figma designs, supporting responsive layouts.",
        "Optimized image loading, asset caching, and SQLite structures to reduce CPU usage by 20%."
      ]
    }
  ];

  // Featured Projects list
  static const List<Map<String, dynamic>> projects = [
    {
      "id": "journaling",
      "title": "Chronal - Journaling App",
      "desc":
          "A technically complex, rich editor application featuring local offline database replication, rich-text styling, HTML rendering, and auto-save.",
      "isHighlighted": true,
      "features": [
        "Custom HTML Editor with rich formatting options",
        "Rich Text Editor supporting custom paragraph blocks",
        "Embedded media uploads, image resizing, and file attachments",
        "Autosave capabilities and local draft versioning",
        "Offline-first synchronization with Cloud Firestore using local Hive/SQLite queues",
        "Custom WYSIWYG formatting toolbar with responsive overflow mechanics"
      ],
      "tech": [
        "Flutter",
        "Dart",
        "Hive",
        "SQLite",
        "Firestore",
        "HTML Rendering"
      ]
    },
    {
      "id": "fintech",
      "title": "Frenn Microfinance App",
      "desc":
          "A production-grade financial hub featuring biometric authentication, real-time transaction history, graphical wallets, and push notifications.",
      "isHighlighted": false,
      "features": [
        "Encrypted biometrics and OAuth 2.0 security protocols",
        "Payment gateway integration for seamless deposit and withdrawal options",
        "Real-time transaction tracking and dynamic PDF receipt generation",
        "Interactive dashboard analytics with smooth chart transitions",
        "Optimized data querying with Repository pattern caching"
      ],
      "tech": ["Flutter", "REST APIs", "Firebase", "Stripe", "Local Auth"]
    },
    {
      "id": "nobelpage",
      "title": "Nobelpage",
      "desc":
          "A professional social media application similar to LinkedIn, developed with Flutter and a Node.js backend. Features WebSockets for real-time chat.",
      "isHighlighted": false,
      "features": [
        "Infinite scrolling paginated feed with smart media caching",
        "Real-time direct and group chatting with WebSockets and typing status indicators",
        "User profile customisation, professional network connections, and post interactions",
        "Robust Node.js backend APIs managing feed generation, comments, and connection state"
      ],
      "tech": ["Flutter", "Node.js", "WebSockets", "Express", "MongoDB"]
    },
    {
      "id": "restaurant",
      "title": "Restridvisor - Restaurant Management App",
      "desc":
          "A comprehensive booking and order tracking platform tailored for dual customer-merchant operations.",
      "isHighlighted": false,
      "features": [
        "Real-time table booking calendar and reservation coordinator",
        "Live order dispatch tracking and kitchen receipt queuing",
        "Dynamic digital menus with remote configuration options",
        "Aggregated review analysis and statistics dashboard",
        "Multi-vendor payments setup"
      ],
      "tech": ["Flutter", "Python Backend", "SQL database", "Push Notification"]
    },
    {
      "id": "workerpool",
      "title": "Workerpool",
      "desc":
          "An on-demand home services platform built like Urban Company, developed with Flutter and a Node.js backend.",
      "isHighlighted": false,
      "features": [
        "Time slot reservation matrix with calendar integration",
        "Dynamic category-based service browsing and booking workflow",
        "Interactive service provider dashboard for tracking schedules and payouts",
        "Stripe-powered checkout with digital invoices"
      ],
      "tech": ["Flutter", "Node.js", "Express", "MongoDB", "REST APIs"]
    },
    {
      "id": "the_teachers_app",
      "title": "The Teacher App",
      "desc":
          "A comprehensive professional development and classroom companion platform developed for the Bharti Airtel Foundation in collaboration with the CK-12 Foundation, empowering K-12 educators across India.",
      "isHighlighted": false,
      "features": [
        "45+ AI-enabled tools to assist teachers with lesson planning, content creation, and classroom management",
        "Vast, NEP 2020-aligned content library for Classes 1 to 12 containing courses, videos, podcasts, and question banks",
        "Structured professional development courses including Foundational Literacy & Numeracy (FLN) and pedagogy modules",
        "Teachers' Lounge community hub for networking, sharing creative strategies, and peer collaboration",
        "Interactive engagement formats including quizzes, polls, webinars, and national-level competitions"
      ],
      "tech": ["Flutter", "Dart", "Firebase", "AI Integration", "REST APIs"]
    }
  ];

  // Testimonials
  static const List<Map<String, String>> testimonials = [
    {
      "quote":
          "Abhay is a highly skilled Flutter engineer. He transformed our complex Figma design into a pixel-perfect, highly responsive web dashboard with incredibly smooth transitions. Absolutely top-tier work.",
      "author": "Marcus Vance",
      "role": "Product Director, PayStream FinTech"
    },
    {
      "quote":
          "Working with Abhay on our journaling editor was a masterclass in clean architecture. He tackled custom HTML parsing, rich-text rendering, and local-first data sync with impressive engineering detail.",
      "author": "Elena Rostova",
      "role": "CTO, MindShare Digital"
    },
    {
      "quote":
          "The Fastlane and CI/CD pipelines Abhay set up completely streamlined our deployment process. His Python backend knowledge makes him a rare, complete engineer who understands how both mobile and server environments behave.",
      "author": "Srinivas Rao",
      "role": "Lead Architect, CloudScale Tech"
    }
  ];
}
