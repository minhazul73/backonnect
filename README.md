# Backonnect

A Flutter mobile app for learning and tweaking — built with **GetX** and **Clean Architecture**. Connects to a FastAPI backend hosted on Render.com.

> **Backend repo:** [minhazul73/learn-fastapi](https://github.com/minhazul73/learn-fastapi)

---

## Table of Contents

- [Features](#features)
- [Tech Stack](#tech-stack)
- [Architecture](#architecture)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Configuration](#configuration)
- [App Flow](#app-flow)
- [Key Implementation Details](#key-implementation-details)

---

## Features

- **Smart Auth** — splash screen checks for a stored token; users with an active session skip login entirely
- **JWT Auth** — login & register with automatic silent token refresh on 401 responses
- **Items CRUD** — create, view, edit, and delete items with name, price, tax, and description
- **Infinite Scroll** — automatically loads the next page when the user scrolls within 500px of the list bottom
- **Offline Cache** — page 1 of items is cached locally and shown as a fallback when the network is unavailable
- **Shimmer Loading** — skeleton placeholders while data is fetching
- **Render Cold-Start Banner** — after 8 seconds of waiting, a friendly snackbar notifies the user that the server is waking up (Render.com free tier spins down after inactivity)
- **Profile** — view account info and sign out
- **Minimal Flat Design** — Material 3, monochrome palette, single `#2563EB` accent

---

## Tech Stack

| Concern | Library |
|---|---|
| State management & navigation | `get ^4.6.6` |
| HTTP client | `dio ^5.4.0` |
| HTTP logging | `pretty_dio_logger ^1.3.1` |
| Persistent local storage | `get_storage ^2.1.1` |
| Date formatting | `intl ^0.19.0` |
| Logging | `logger ^2.1.0` |
| Shimmer effect | `shimmer ^3.0.0` |

---

## Architecture

Feature-based **Clean Architecture** with three layers per feature:

```
Domain  ──▶  Data  ──▶  Presentation
```

| Layer | Contents |
|---|---|
| **Domain** | Entities (plain Dart classes), abstract repository interfaces |
| **Data** | Models (JSON serialisation), remote datasources, repository implementations |
| **Presentation** | GetX controllers, pages, widgets |

Shared infrastructure lives in `lib/core/` and is independent of any feature.

---

## Project Structure

```
lib/
├── main.dart                          # App entry point
│
├── app/
│   ├── bindings/app_binding.dart      # Permanent global singletons
│   ├── middleware/auth_middleware.dart # Route guard (sync token check)
│   ├── routes/
│   │   ├── app_routes.dart            # Route name constants
│   │   └── app_pages.dart             # Route → page + binding mapping
│   └── theme/
│       ├── app_colors.dart
│       ├── app_text_styles.dart
│       └── app_theme.dart
│
├── core/
│   ├── constants/
│   │   ├── api_constants.dart         # Base URL, timeouts
│   │   └── app_constants.dart         # Per-page count, scroll threshold
│   ├── exceptions/app_exceptions.dart # Typed exception hierarchy
│   ├── extensions/                    # Context, String, Date, Num helpers
│   ├── network/
│   │   ├── api_client.dart            # Dio wrapper, exception mapping
│   │   ├── api_endpoint.dart          # Endpoint path constants
│   │   ├── interceptors/
│   │   │   ├── auth_interceptor.dart  # Bearer token + 401 refresh + retry queue
│   │   │   ├── cold_start_interceptor.dart  # Render cold-start banner (8s)
│   │   │   └── logging_interceptor.dart
│   │   └── models/
│   │       ├── api_response_model.dart
│   │       └── pagination_model.dart
│   ├── storage/
│   │   ├── token_storage_service.dart # Access + refresh tokens (sync & async)
│   │   └── local_storage_service.dart # Generic key-value store
│   └── utils/
│       ├── dialogs/                   # Snackbars, confirm dialogs
│       ├── formatters/date_formatters.dart
│       ├── logger/app_logger.dart
│       └── validators/input_validators.dart
│
└── features/
    ├── auth/
    │   ├── bindings/auth_binding.dart
    │   ├── controllers/
    │   │   ├── auth_controller.dart   # Session state, /auth/me, logout
    │   │   └── login_controller.dart  # Form fields, login(), register()
    │   ├── data/                      # Models, remote datasource, repo impl
    │   ├── domain/                    # UserEntity, TokenEntity, abstract repo
    │   └── presentation/
    │       ├── pages/                 # SplashScreen, LoginPage, RegisterPage
    │       └── widgets/               # AuthTextField, AuthButton, LoadingOverlay
    │
    ├── items/
    │   ├── bindings/items_binding.dart
    │   ├── controllers/
    │   │   ├── items_controller.dart       # List, infinite scroll, delete
    │   │   ├── item_detail_controller.dart # Single item view
    │   │   └── create_item_controller.dart # Create + edit (dual mode)
    │   ├── data/                           # Models, datasource, repo impl + cache
    │   ├── domain/                         # ItemEntity, abstract repo, create/update entities
    │   └── presentation/
    │       ├── pages/  # ItemsListPage, ItemDetailPage, CreateItemPage, EditItemPage
    │       └── widgets/ # ItemCard, ItemInputForm, ShimmerItemList
    │
    └── profile/
        ├── bindings/profile_binding.dart
        ├── controllers/profile_controller.dart
        └── presentation/
            ├── pages/profile_page.dart
            └── widgets/ # ProfileHeader, UserInfoTile
```

---

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
