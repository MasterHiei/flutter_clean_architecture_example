# Flutter Clean Architecture Example

A comprehensive Flutter template project implementing Clean Architecture with Domain-Driven Design patterns.

## Tech Stack

| Layer | Technology |
|-------|------------|
| State Management | Riverpod |
| Immutability | Freezed |
| Error Handling | fpdart (Either) |
| Local Database | Drift |
| Networking | Dio + Retrofit |
| Routing | auto_route |

## Project Structure

~~~
lib/
├── core/                    # Cross-feature shared code
│   ├── domain/             # Failures, Value Objects
│   └── infrastructure/     # Database, Network, Constants
├── features/               # Feature modules
├── shared/                 # Shared UI components
├── router/                 # Navigation
└── l10n/                   # Localization
~~~

## Getting Started

~~~bash
# Install dependencies
flutter pub get

# Generate code
dart run build_runner build --delete-conflicting-outputs

# Run dev flavor
flutter run --flavor dev --dart-define=FLUTTER_APP_FLAVOR=dev

# Run prod flavor
flutter run --flavor prod --dart-define=FLUTTER_APP_FLAVOR=prod
~~~

## Documentation

See `.agent/` directory for architecture documentation.
