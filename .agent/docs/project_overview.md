# Project Overview

> This document provides high-level context for the Flutter Clean Architecture example project.

## Project Mission

This is a **comprehensive Flutter Clean Architecture template project** designed to:

- Provide a **plug-and-play architectural foundation** for new Flutter projects
- Generate boilerplate code, system architecture, logic design, and test cases
- Follow **official documentation**, **authoritative architectural principles**, and **mature Flutter ecosystem practices**

## Target Audience

| Audience | Usage |
|----------|-------|
| **New Projects** | Clone and customize as starting point |
| **Learning** | Study Clean Architecture implementation patterns |
| **Reference** | Consult for specific pattern implementations |

## Core Design Philosophy

This project follows these foundational principles:

| Principle | Source | Implementation |
|-----------|--------|----------------|
| **Clean Architecture** | Robert C. Martin | 4-layer separation with dependency inversion |
| **Domain-Driven Design** | Eric Evans | Entity, Value Object, Repository patterns |
| **Functional Error Handling** | fpdart | `Either<Failure, T>` for type-safe error handling |
| **Declarative State Management** | Riverpod | Notifier-based reactive state |

> [!NOTE]
> This architecture does **NOT** use the `flutter_clean_architecture` package. Instead, it implements the same principles using **Riverpod + Freezed + fpdart** ecosystem.

---

## Document Navigation

| Document | Purpose | When to Read |
|----------|---------|--------------|
| [rules.md](../rules.md) | Core rules and AI behavior constraints | **Always read first** |
| [architecture_principles.md](architecture_principles.md) | Layer design and directory structure | Creating new features, architecture review |
| [ddd_patterns.md](ddd_patterns.md) | Entity, Value Object, Repository patterns | Designing domain models |
| [technology_stack.md](technology_stack.md) | Tech stack options and code examples | Choosing implementation approach |
| [error_handling.md](error_handling.md) | Exception and Failure handling strategy | Implementing error flows |
| [developer_experience.md](developer_experience.md) | DX optimization and code generation | Improving development efficiency |
| [testing_and_audit.md](testing_and_audit.md) | Testing pyramid and code standards | Writing tests, code review |
| [common_scenarios.md](common_scenarios.md) | FAQ for common implementation decisions | Deciding between patterns |
| [quick_reference.md](quick_reference.md) | Copy-paste code templates | Quick boilerplate generation |

### Workflow Reference

| Workflow | Purpose |
|----------|---------|
| [create-feature.md](../workflows/create-feature.md) | Step-by-step guide to create a new feature module |

---

## Technology Stack

> For detailed technology choices, comparisons, and code examples, see [technology_stack.md](technology_stack.md).

**Core Stack**: Riverpod + Freezed + fpdart + Dio/Retrofit + Drift

---

## Version Compatibility

This template targets the **latest stable versions** of Flutter and key packages:

| Dependency | Version Reference |
|------------|------------------|
| **Flutter SDK** | [flutter.dev/docs/release](https://docs.flutter.dev/release/archive) |
| **Riverpod** | [pub.dev/packages/riverpod](https://pub.dev/packages/riverpod) |
| **Freezed** | [pub.dev/packages/freezed](https://pub.dev/packages/freezed) |
| **fpdart** | [pub.dev/packages/fpdart](https://pub.dev/packages/fpdart) |

> [!IMPORTANT]
> Always verify package versions in project `pubspec.yaml` or pub.dev. This documentation does not specify exact version numbers to avoid outdating.
