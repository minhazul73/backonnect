# Backonnect

A production-ready Flutter mobile app for managing inventory items, built with **GetX** and **Clean Architecture**. Connects to a FastAPI backend hosted on Render.com.

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

### Prerequisites

- Flutter SDK `>=3.0.0`
- Android Studio / VS Code with Flutter extension
- A connected device or emulator

### Setup

```bash
# Clone the repo
git clone <repo-url>
cd backonnect

# Install dependencies
flutter pub get

# Run on a connected device
flutter run
```

### Analyse

```bash
flutter analyze
```

---

## Configuration

All network settings are in `lib/core/constants/api_constants.dart`:

```dart
static const String baseUrl        = 'https://myapp-7z5l.onrender.com';
static const String apiPrefix      = '/api/v1';
static const int connectTimeoutMs  = 90000; // 90s — accommodates Render cold start
static const int receiveTimeoutMs  = 90000;
static const int sendTimeoutMs     = 90000;
```

Pagination defaults are in `lib/core/constants/app_constants.dart`:

```dart
static const int    defaultPerPage           = 10;
static const double infiniteScrollThreshold  = 500.0; // px from list bottom
```

---

## App Flow

```
App Launch
    │
    ▼
SplashScreen (1.8s animated)
    │
    ├─ token exists? ──YES──▶ /items (ItemsListPage)
    │
    └─ NO ──▶ /login (LoginPage)
                  │
                  ├─ Sign In ──▶ POST /auth/login ──▶ /items
                  │
                  └─ Register ──▶ POST /auth/register ──▶ /items
```

All routes under `/items`, `/items/detail`, `/items/create`, `/items/edit`, and `/profile` are protected by `AuthMiddleware`, which synchronously reads the stored token and redirects unauthenticated users to `/login`.

---

## Key Implementation Details

### Token Refresh
`AuthInterceptor` handles 401 responses transparently:
1. Pauses all concurrent requests in a `Completer` queue
2. Calls `POST /auth/refresh` with a dedicated Dio instance (avoids recursion)
3. Saves the new token pair and retries all queued requests
4. On refresh failure — clears tokens and routes to `/login`

### Render Cold-Start Banner
`ColdStartInterceptor` monitors in-flight requests:
- An 8-second timer starts when the *first* request is sent
- If no response arrives within 8s, a persistent floating snackbar appears: *"Server is waking up ☁️ — The backend is starting after being idle."*
- The banner is dismissed automatically once any response arrives
- Requests that complete in under 8s (warm server) never show the banner

### Infinite Scroll
`ItemsController` attaches a `ScrollController` listener. When `maxScrollExtent - pixels ≤ 500.0` and no load is in progress, `loadMore()` fetches the next page and appends results to the reactive list.

### Offline Cache
`ItemsRepositoryImpl` serialises page 1 to `LocalStorageService` after every successful fetch. On a network failure it deserialises the cache and returns it as a fallback, so the user always sees something.

### Dual-Mode Form Controller
`CreateItemController` serves both **create** and **edit** flows. It reads `Get.arguments` in `onInit()` — if the argument is an `ItemEntity`, it switches to edit mode and prefills the form fields. Both `CreateItemPage` and `EditItemPage` use the same controller and `ItemInputForm` widget.

### Dependency Lifetime

| Singleton | Scope |
|---|---|
| `LocalStorageService`, `TokenStorageService`, `ApiClient` | Permanent (full app lifetime) |
| `AuthRemoteDatasource`, `AuthRepository`, `AuthController` | Permanent (full app lifetime) |
| `LoginController` | Auth routes only — disposed on navigation away |
| `ItemsController`, `ItemDetailController`, `CreateItemController` | Items route group |
| `ProfileController` | Profile route only |

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
