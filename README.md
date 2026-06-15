# Tadreeby - Mobile Application 📱

## Team Information 

- **Team Name**: **NEXUS**
- **Team Leader:** [Shahd Abu Sharif](https://github.com/shahd-abu-sharif)
- **Team Members:**
  - [Deema Abd Alhady](https://github.com/Deemaabdalhady) UX/UI Designer
  - [Shahd Al Mobayed](https://github.com/shahedeyadalmobayed2004) Mobile Developer
  - [Afnan Kullab](https://github.com/afnankullab-dev) FrontEnd Developer
  - [Shahd Abu Sharif](https://github.com/shahd-abu-sharif) BackEnd Developer
  - [Maryam Thabet](https://github.com/Mariam-Adnan-5) QA Engineer
  - [Marah Abu Abdo](https://github.com/MarahAboAbdo) AI Engineer

---

## Project Overview

Tadreeby Mobile Application is the cross-platform mobile client for the **Tadreeby Field Training Management System**. It brings the entire internship lifecycle directly to the smartphones of students, supervisors, and trainers, ensuring seamless connectivity, real-time tracking, and role-based experiences on both Android and iOS devices.

The application allows students to easily discover and apply for internships, enables university supervisors to monitor academic progress on the go, and assists company trainers in logging attendance and managing daily training tasks dynamically.

---

## Problem Statement

Traditional internship management is plagued by manual reporting, delayed communication, and fragmented workflows:
- Students lack an intuitive, responsive interface to browse and track application statuses.
- Academic supervisors face difficulties monitoring real-time field progress and verifying attendance.
- Enterprise trainers manage daily tasks and evaluate trainees through unstructured or offline methods.
- Cross-platform visual communication remains disconnected from the core system state.

---

## Solution Overview

Tadreeby Mobile App acts as the comprehensive frontend gateway that delivers a standardized, intuitive mobile experience matching the robustness of our modular backend.

It provides:
- A fully responsive and dynamic cross-platform user experience (Android & iOS).
- Strict client-side route guards synchronized with backend verification states (`PENDING`, `APPROVED`, `REJECTED`).
- Live progress tracking, document scanning/upload capabilities for university authorization.
- Dynamic theme and menu rendering adapted natively for each distinct user role.

---

## Key Mobile Features

- **Role-Based Dynamic UI:** Seamless transformation of navigation bars, dashboards, and features based on the authenticated role.
- **Secure Token Lifecycle:** Encrypted local token storage with fully automated refresh interceptors to guarantee seamless login sessions.
- **Onboarding Verification Wizard:** Step-by-step registration with native file picking and multi-part upload for academic credentials.
- **Strict Route Guards:** Complete restriction of unauthorized views, explicitly confining unverified student profiles to restricted validation layouts.
- **Password Restoration Wizard:** Integrated multi-step OTP validation flow with built-in countdown timers.

---

## Architecture & Mobile Design

The mobile application follows a **Feature-First Clean Architecture** utilizing robust State Management principles to ensure decoupled, highly testable, and maintainable layers:
- **Presentation Layer:** Declarative UI layouts, dynamic widgets, and reactive state representation.
- **Domain Layer:** Business logic entities, use cases, and repository interfaces.
- **Data Layer:** Local database secure storage, data models, and remote API data sources.

---

## Mobile Tech Stack

- **Framework:** Flutter (Cross-Platform Android & iOS)
- **Language:** Dart
- **State Management:** BLoC / Riverpod
- **Routing Engine:** GoRouter / AutoRoute
- **Networking & API Client:** Dio (with custom Refresh Interceptors)
- **Local Storage:** `flutter_secure_storage` (Keychain/Keystore Encryption)
- **Utilities:** `jwt_decoder`, `file_picker`

---

## Getting Started (Local Development)

### Prerequisites
Ensure you have the following installed on your machine:
- Flutter SDK (Latest Stable Version)
- Android Studio / VS Code
- Xcode (For iOS development on macOS)

### Installation
1. Clone the repository:
   ```bash
   git clone <https://github.com/Nexus-Tadreeby/tadreeby-mobile-app>