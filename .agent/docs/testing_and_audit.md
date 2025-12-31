# Testing Strategy & Audit Checklist

> Reference document for Flutter Clean Architecture. See also: [Core Prompt](../rules.md)

## Related API Documentation

| Resource | Documentation |
|----------|---------------|
| **Effective Dart** | [dart.dev/effective-dart](https://dart.dev/effective-dart) |
| **Flutter Testing** | [docs.flutter.dev/testing](https://docs.flutter.dev/testing) |
| **mocktail** | [pub.dev/documentation/mocktail](https://pub.dev/documentation/mocktail/latest/) |
| **flutter_test** | [api.flutter.dev/flutter_test](https://api.flutter.dev/flutter/flutter_test/flutter_test-library.html) |

---

## 1. TDD Testing Pyramid

| Type | Proportion | Coverage Target |
|------|------------|-----------------|
| Unit Tests | Largest | Domain logic, Use Cases, Repository implementation |
| Widget Tests | Medium | UI component behavior, State rendering |
| Integration Tests | Smallest | Complete user flows |

> **Principle**: Unit tests generally form the base. Integration tests focus on critical user flows. Proportions vary by project specifics.

### Coverage Priority

| Layer | Priority |
|-------|----------|
| Domain | Highest (Core business logic) |
| Application | High (Use Case flows) |
| Infrastructure | Medium (Key integration points) |
| Presentation | Conditional (Complex interaction logic) |

> **Principle**: Coverage targets should be based on code criticality and change frequency, not mechanical numbers.

---

## 2. Architecture Compliance Checklist

- [ ] Domain layer has NO Flutter SDK / Infrastructure package dependencies
- [ ] Dependency Direction: Presentation → Application → Domain ← Infrastructure
- [ ] Repository interfaces defined in Domain layer
- [ ] Use Cases return `Either<Failure, T>`
- [ ] Value Objects include validation logic and are immutable
- [ ] Entity equality is based on ID

---

## 3. Naming Conventions

| Type | Convention | Example |
|------|------------|---------|
| Entity | Noun PascalCase | `User`, `Order` |
| Value Object | Noun PascalCase | `Email`, `UserId` |
| Repository | Noun + Repository | `UserRepository` |
| Use Case | Verb + Noun | `GetUserById` |
| DTO | Entity + Dto | `UserDto` |
| Provider | Feature + Provider | `userRepositoryProvider` |

---

## 4. File Organization

- [ ] Each feature module contains complete 4-layer structure
- [ ] Uses `index.dart` as barrel export
- [ ] Related functional files placed in same directory

---

## 5. Dart Code Standards

> Based on [Effective Dart](https://dart.dev/effective-dart)

### ✅ Must Follow

| Rule | Description |
|------|-------------|
| `final` Preferred | Use `final` instead of `var` whenever possible |
| `const` Construction | Must use `const` for Widgets whenever possible |
| Type Inference | Infer local variables, Explicitly type public APIs |
| Null Safety | Correctly use `?`, `!`, `??`, `?.`. Avoid abusing `!` |
| Single Expression | Use `=>` for single line functions |

### ❌ Prohibited

~~~dart
// ❌ Using dynamic
dynamic data = fetchData();

// ❌ Abusing !
final user = nullableUser!;

// ❌ Empty catch block
try { ... } catch (e) { }

// ❌ print() in production code
print('debug'); // Use logger

// ❌ Hardcoded strings
Text('Username'); // Use context.l10n.username
~~~

### ✅ Recommended

~~~dart
// ✅ Null safety handling
final user = nullableUser;
if (user != null) {
  // user promoted to non-nullable
}

// ✅ Switch pattern matching
return switch (result) {
  Success(:final data) => DataWidget(data: data),
  Error(:final failure) => ErrorWidget(failure: failure),
};
~~~

---

## 6. Flutter Widget Standards

| Rule | Description |
|------|-------------|
| Split Widgets | Single Widget under 200 lines |
| const Constructor | Use const when params are final/none |
| Key Usage | List items, Animated widgets must have Key |
| BuildContext | Prohibit cross-frame usage (async gap) |
| setState | Only for local UI state |

### Async Gap Handling

~~~dart
// ❌ Prohibited
onPressed: () async {
  await someAsyncOperation();
  Navigator.of(context).pop(); // context might be invalid
}

// ✅ Correct
onPressed: () async {
  await someAsyncOperation();
  if (!context.mounted) return;
  Navigator.of(context).pop();
}
~~~
