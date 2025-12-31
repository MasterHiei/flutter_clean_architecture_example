# Architecture Principles

> Reference document for Flutter Clean Architecture. See also: [Core Prompt](../rules.md)

## Authoritative Sources

| Resource | Link |
|----------|------|
| **Flutter Architecture Guide** | [docs.flutter.dev/app-architecture](https://docs.flutter.dev/app-architecture/guide) |
| **Clean Architecture (Uncle Bob)** | [blog.cleancoder.com](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html) |
| **Domain-Driven Design (Eric Evans)** | Book: "Domain-Driven Design: Tackling Complexity" |

---

## 1. Clean Architecture Layer Design

Based on Robert C. Martin's (Uncle Bob) Clean Architecture, the project uses the following layered structure, **dependencies always point inward**:

~~~
┌─────────────────────────────────────────────────────────────┐
│                    Presentation Layer                        │
│     (Widgets, Pages, Controllers, State Management)          │
├─────────────────────────────────────────────────────────────┤
│                    Application Layer                         │
│     (Use Cases / Interactors, State Notifiers)               │
├─────────────────────────────────────────────────────────────┤
│                      Domain Layer                            │
│     (Entities, Value Objects, Repository Interfaces)         │
├─────────────────────────────────────────────────────────────┤
│                   Infrastructure Layer                       │
│     (Repository Implementations, Data Sources, DTOs)         │
└─────────────────────────────────────────────────────────────┘
~~~

> 💡 **Pragmatic Layering**: For simple CRUD scenarios, the Presentation layer is allowed to call the Repository directly, omitting the Use Case. See [Developer Experience > Pragmatic Layering Strategy](../docs/developer_experience.md) for details.

### Key Rules

- **Domain Layer Purity**:
  - ✅ Allowed: Pure Dart packages (`fpdart`, `freezed_annotation`, `meta`)
  - ❌ Prohibited: Flutter SDK (`package:flutter/*`)
  - ❌ Prohibited: Infrastructure packages (Network, DB, File System)
- **Dependency Rule**: Inner layers must not know about outer layers. Outer layers depend on inner layers via interfaces.
- **Repository Pattern**: Domain layer defines interfaces, Infrastructure layer provides implementations.

---

## 2. Directory Structure Design

Uses **Feature-First** + **Layer-Second** hybrid structure:

~~~
lib/
├── main.dart                          # Application entry point
├── bootstrap.dart                     # App initialization logic
├── app.dart                           # Root MaterialApp/CupertinoApp
│
├── core/                              # ═══ Cross-Feature Core ═══
│   ├── domain/                        # Domain layer shared definitions
│   │   ├── failures/                  # Failure types (Business errors)
│   │   │   └── failure.dart
│   │   └── value_objects/             # Shared Value Objects
│   │       └── index.dart
│   │
│   └── infrastructure/                # Infrastructure layer shared
│       ├── constants/
│       │   ├── env.dart               # Environment configs (envied)
│       │   └── db_settings.dart
│       ├── databases/                 # Local Storage (Drift/Isar)
│       │   ├── app_database.dart
│       │   ├── daos/
│       │   └── tables/
│       ├── network/                   # Network Layer (Dio/Retrofit)
│       │   ├── dio_client.dart
│       │   └── interceptors/
│       ├── storage/                   # File & Media Storage
│       ├── device/                    # ═══ Device Services (Platform) ═══
│       │   ├── location_service.dart  # GPS / Location
│       │   ├── camera_service.dart    # Camera / Gallery
│       │   ├── biometric_service.dart # Biometrics
│       │   └── connectivity_service.dart # Network Status
│       ├── exceptions/                # Exception types (Technical errors)
│       │   ├── app_exception.dart
│       │   └── network_exception.dart
│       └── providers/                 # Global providers
│
├── features/
│   └── [feature_name]/                # ═══ Feature Module ═══
│       ├── domain/                    # Domain Layer (innermost)
│       │   ├── entities/              # Business entities
│       │   │   └── user.dart
│       │   ├── value_objects/         # Feature-specific Value Objects
│       │   │   └── email.dart
│       │   └── repositories/          # Repository INTERFACES
│       │       └── user_repository.dart
│       │
│       ├── application/               # Application Layer (Use Cases)
│       │   ├── usecases/              # <- Meets Uncle Bob's spec
│       │   │   ├── get_user_by_id.dart
│       │   │   └── index.dart
│       │   ├── providers/             # Feature-specific providers
│       │   └── notifiers/             # Riverpod Notifiers / BLoC
│       │       └── user_notifier.dart
│       │
│       ├── infrastructure/            # Infrastructure Layer (outermost)
│       │   ├── dtos/                  # Data Transfer Objects
│       │   ├── datasources/           # Remote/Local data sources
│       │   ├── mappers/               # DTO <-> Entity mappers
│       │   └── repositories/          # Repository IMPLEMENTATIONS
│       │       └── user_repository_impl.dart
│       │
│       └── presentation/              # Presentation Layer
│           ├── pages/
│           ├── widgets/
│           └── controllers/
│
├── shared/                            # Cross-Feature UI Shared Code
│   ├── widgets/
│   ├── extensions/
│   └── utils/
│
├── router/                            # Navigation (auto_route/go_router)
│   ├── app_router.dart
│   └── guards/
│
└── l10n/                              # Localization
    ├── app_en.arb
    └── app_zh.arb
~~~

---

## 3. Key Design Decisions

| Decision | Rationale |
|----------|-----------|
| `usecases/` in `application/` | Uncle Bob: "Use Cases contain **application-specific** business rules" |
| `failures/` in `core/domain/` | Failures are business errors, belong in Domain |
| `exceptions/` in `core/infrastructure/` | Exceptions are technical errors, belong in Infrastructure |
| `device/` in `core/infrastructure/` | Device capabilities (GPS, Camera) are platform-specific, belong in Infrastructure |
| `router/` outside features | Routing is an app-level concern, not feature-specific |

---

## 4. Device Services Design

Device Services encapsulate platform-specific logic, independent of data fetching.

| Service | Responsibility | Typical Impl |
|---------|----------------|--------------|
| `LocationService` | Get device location | geolocator, location |
| `CameraService` | Take photo, access gallery | image_picker, camera |
| `BiometricService` | Fingerprint/Face ID | local_auth |
| `ConnectivityService` | Listen to network status | connectivity_plus |

### Design Principles

- **Interface in Domain**: `abstract interface class LocationService`
- **Implementation in Infrastructure**: `class GeolocatorLocationService implements LocationService`
- **Injected via DI**: Allows mocking for tests

~~~dart
// domain/services/location_service.dart
abstract interface class LocationService {
  Future<Either<Failure, Position>> getCurrentPosition();
  Stream<Position> watchPosition();
}

// infrastructure/device/geolocator_location_service.dart
class GeolocatorLocationService implements LocationService {
  @override
  Future<Either<Failure, Position>> getCurrentPosition() async {
    try {
      final position = await Geolocator.getCurrentPosition();
      return right(position);
    } on LocationServiceDisabledException {
      return left(const Failure.device(reason: 'Location service disabled'));
    }
  }
}
~~~
