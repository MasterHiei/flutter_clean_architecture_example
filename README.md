# Flutter Clean Architecture Example

A production-ready Flutter template implementing strict **Clean Architecture** with **Domain-Driven Design (DDD)**.

> Designed for scalability, testability, and maintainability using the `Riverpod + Freezed + fpdart` stack.

## 🚀 Quick Start

~~~bash
# 1. Install dependencies
flutter pub get

# 2. Generate code
dart run build_runner build --delete-conflicting-outputs

# 3. Run (Dev environment)
flutter run --flavor dev -t lib/main_dev.dart
~~~

## 🛠 Technology Stack

| Core | Library | Purpose |
|------|---------|---------|
| **State** | [Riverpod](https://pub.dev/packages/flutter_riverpod) | Reactive state & DI (No `setState`) |
| **Data** | [Freezed](https://pub.dev/packages/freezed) | Immutable Data Classes & Unions |
| **Logic** | [fpdart](https://pub.dev/packages/fpdart) | Functional Error Handling (`Either<L, R>`) |
| **Network**| [Dio](https://pub.dev/packages/dio) + [Retrofit](https://pub.dev/packages/retrofit) | Type-safe REST Client |
| **Local** | [Drift](https://pub.dev/packages/drift) | SQLite Database |

## 📐 Architecture & Structure

This project follows a strict 4-layer architecture enforcing the **Dependency Rule** (Inner layers allow no external dependencies).

~~~text
lib/
├── core/                   # Shared kernel (Failures, ValueObjects, Services)
├── features/               # Feature modules (DDD: Presentation, Application, Domain, Infra)
│   ├── auth/               # Example: Authentication feature
│   └── ...
├── shared/                 # Shared UI Design System
└── router/                 # AutoRoute configuration
~~~

## 📚 Documentation

Detailed documentation is maintained in `.agent/`:
- [**Architecture Principles**](.agent/docs/architecture_principles.md)
- [**Agent Rules & Git Flow**](.agent/rules.md)
- [**Tech Stack details**](.agent/docs/technology_stack.md)

## 🧪 Testing

We use **Requirements-Driven Testing** (mocking via `mocktail`).

~~~bash
flutter test
~~~
