import 'package:flutter/material.dart';

class AppConstants {
  static const String name = "Abhay Sharma";
  static const String title =
      "Senior Flutter Developer | Python Backend Developer";
  static const String subTitle =
      "Senior Flutter Developer • Cross-Platform Mobile • Python Backend";

  static const String email = "sharmaabhayagra@gmail.com";
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
    "Payments & Billing": [
      "Stripe",
      "Paymob",
      "Razorpay",
      "In-App Purchases (IAP)"
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
      "domains": [
        "Social Media Platforms (Nobelpage)",
        "On-Demand Services (Workerpool)"
      ],
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

  static const List<Map<String, dynamic>> projects = [
    {
      "id": "journaling",
      "title": "Chronal - Journaling App",
      "desc":
          "A highly advanced, technically complex digital journaling platform featuring rich-text HTML rendering, responsive formatting, and a custom WYSIWYG editor. Chronal supports secure local draft versioning and offline-first database synchronization using Hive and SQLite queues. Users can seamlessly embed media, upload and resize images, apply custom paragraph styling block layouts, and auto-save drafts locally, ensuring data integrity even during offline sessions.",
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
          "A production-grade microfinance and mobile banking hub designed to deliver secure, real-time financial services. Features high-grade biometric authentication (FaceID/TouchID), instant cash graphical wallets, and integration with Stripe for transaction processing. The app enables comprehensive Buy Now Pay Later (BNPL) options, mobile airtime recharges, and real-time transaction tracking with PDF receipt generation, all built on a robust caching repository architecture.",
      "isHighlighted": false,
      "features": [
        "Encrypted biometrics and OAuth 2.0 security protocols",
        "Payment gateway integration for seamless deposit and withdrawal options",
        "Real-time transaction tracking and dynamic PDF receipt generation",
        "Interactive dashboard analytics with smooth chart transitions",
        "Optimized data querying with Repository pattern caching"
      ],
      "tech": [
        "Flutter",
        "REST APIs",
        "Firebase",
        "Paymob",
        "Local Auth",
        "In-App Purchases"
      ]
    },
    {
      "id": "nobelpage",
      "title": "Nobelpage",
      "desc":
          "A production-grade, highly engaging professional networking and social media ecosystem reminiscent of LinkedIn. Designed with a robust Node.js backend and modular Flutter architecture, Nobelpage empowers users to build professional networks, create dedicated organization pages for institutions and companies, and access exclusive premium tiers. The ecosystem is fully equipped with secure App Store and Play Store in-app purchases (IAP) for subscriptions, membership paywalls, gated content access, and real-time WebSocket communication.",
      "isHighlighted": false,
      "features": [
        "In-App Purchases (IAP) integration via Google Play Billing & Apple StoreKit for premium tier subscriptions",
        "Membership ecosystem featuring paywalled premium feeds, gated connection requests, and exclusive job postings",
        "User-created custom business, company, and educational institution organization pages",
        "Real-time direct and group chatting with WebSockets and dynamic typing status indicators",
        "Infinite scrolling paginated content feed with smart client-side media caching",
        "Robust Node.js backend API architecture managing real-time feed curation, comments, and security states"
      ],
      "tech": ["Flutter", "Node.js", "WebSockets", "Express", "MongoDB"]
    },
    {
      "id": "restaurant",
      "title": "Restridvisor - Restaurant Management App",
      "desc":
          "A feature-rich, dual-sided restaurant booking and live order management ecosystem designed to coordinate customer-to-merchant operations. Equipped with a real-time reservation coordinator calendar, interactive digital menu configurations, and multi-vendor checkout setups. Merchants benefit from instant kitchen order ticket queue tracking and analytics dashboards, while customers enjoy live dispatch updates and reviews submission flows.",
      "isHighlighted": false,
      "features": [
        "Real-time table booking calendar and reservation coordinator",
        "Live order dispatch tracking and kitchen receipt queuing",
        "Dynamic digital menus with remote configuration options",
        "Aggregated review analysis and statistics dashboard",
        "Multi-vendor payments setup"
      ],
      "tech": ["Flutter", "SQL database", "Push Notification"]
    },
    {
      "id": "workerpool",
      "title": "Workerpool",
      "desc":
          "An on-demand home services marketplace and coordinator dashboard built like Urban Company. Powered by a Node.js backend and MongoDB database, the platform features a responsive time-slot reservation calendar, dynamic category browsing, and an interactive service provider cockpit to track bookings and payouts. Seamlessly integrates Stripe checkout for secure payments, alongside automated invoice generation for completed tasks.",
      "isHighlighted": false,
      "features": [
        "Time slot reservation matrix with calendar integration",
        "Dynamic category-based service browsing and booking workflow",
        "Interactive service provider dashboard for tracking schedules and payouts",
        "Stripe-powered checkout with digital invoices"
      ],
      "tech": ["Flutter", "Node.js", "Express", "MongoDB", "REST APIs"]
    },
    // {
    //   "id": "the_teachers_app",
    //   "title": "The Teacher App",
    //   "desc":
    //       "A comprehensive digital ecosystem developed for the Bharti Airtel Foundation in collaboration with the CK-12 Foundation to empower K-12 educators across India. The app integrates over 45 AI-enabled productivity tools to assist teachers with automatic lesson planning, dynamic classroom content creation, and pedagogy support. Educators have access to NEP 2020-aligned training modules, digital course catalogs, a Teachers' Lounge community hub for peer networking, and live webinars.",
    //   "isHighlighted": false,
    //   "features": [
    //     "45+ AI-enabled tools to assist teachers with lesson planning, content creation, and classroom management",
    //     "Vast, NEP 2020-aligned content library for Classes 1 to 12 containing courses, videos, podcasts, and question banks",
    //     "Structured professional development courses including Foundational Literacy & Numeracy (FLN) and pedagogy modules",
    //     "Teachers' Lounge community hub for networking, sharing creative strategies, and peer collaboration",
    //     "Interactive engagement formats including quizzes, polls, webinars, and national-level competitions"
    //   ],
    //   "tech": ["Flutter", "Dart", "Firebase", "AI Integration", "REST APIs"]
    // },
    {
      "id": "trimly",
      "title": "Trimly - Salon & Stylist Booking App",
      "desc":
          "A feature-rich, dual-sided salon onboarding and client booking ecosystem consisting of dedicated Salon Management and Customer apps. Trimly streamlines operations by allowing salons to onboard staff, configure service catalogs, and assign custom stylist tiers (including Super Stylists and Stylists). Salons can launch dynamic time- or service-based promotional offers, while configuring flexible loyalty program rules. On the customer side, users can browse services, apply active offers, pick their preferred stylist, schedule time slots, and earn loyalty points redeemable as partial payment for future bookings.",
      "isHighlighted": false,
      "features": [
        "Dual-app architecture separating Merchant Salon operations from the Consumer client booking flows",
        "Advanced staff management enabling salons to onboard stylists, assign tiers (Stylist vs. Super Stylist), and manage schedules",
        "Flexible promotional engine supporting time-constrained and service-specific discount offers",
        "Interactive client booking interface for custom stylist selection, service bundling, and date/time scheduling",
        "Customizable Loyalty Program allowing salons to define earning rules and enabling clients to redeem points as partial payment",
        "Stripe-powered checkout with real-time appointment reminders and digital receipts"
      ],
      "tech": [
        "Flutter",
        "Node.js",
        "Express",
        "MongoDB",
        "REST APIs",
        "Stripe"
      ]
    }
  ];

  // Testimonials
  static const List<Map<String, String>> testimonials = [
    {
      "quote":
          "It was a pleasure collaborating closely on difficult assignments with Abhay. He epitomizes what it means to be a very great and helpful senior who goes above and beyond to mentor and assist peers. Abhay is a superb worker who pays close attention to detail and has a thorough understanding of Flutter. His commitment and knowledge made a big difference in our team's accomplishments.",
      "author": "Yash Dubey",
      "role": "Software Developer"
    },
    {
      "quote":
          "Abhay is the kind of colleague every team wishes for—skilled, supportive, and always bringing a positive vibe to the workspace. I’ve seen him tackle challenges head-on and come up with smart, scalable solutions time and again. It’s been a blast working alongside him, and I’ve learned a lot from his approach to both tech and teamwork.",
      "author": "Rishabh Tripathi",
      "role": "Software Developer"
    },
    {
      "quote":
          "We have worked on a mobile application project  Abhay was the lead mobile developer in that project he was leading the mobile development .....his calmness is something to admire his sincerity towards his work is commendable , wish you best of luck for your future endeavour.",
      "author": "Sunny Jha",
      "role": "Product Manager"
    }
  ];
}
