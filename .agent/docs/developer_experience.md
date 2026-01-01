# Developer Experience Optimization

> Reference document for Flutter Clean Architecture. See also: [Core Prompt](../rules.md)
>
> Goal: Maximize development efficiency without violating architecture principles.

## Related API Documentation

| Package | Documentation | Usage |
|---------|---------------|-------|
| **build_runner** | [pub.dev/documentation/build_runner](https://pub.dev/documentation/build_runner/latest/) | Code generation runner |
| **riverpod_generator** | [pub.dev/documentation/riverpod_generator](https://pub.dev/documentation/riverpod_generator/latest/) | Provider code generation |
| **mason_cli** | [pub.dev/packages/mason_cli](https://pub.dev/packages/mason_cli) | Template code generation |
| **mocktail** | [pub.dev/documentation/mocktail](https://pub.dev/documentation/mocktail/latest/) | Mock testing tool |

---

## 1. Pragmatic Layering Strategy

| Scenario | Recommendation | Rationale |
|----------|----------------|-----------|
| **Simple CRUD** | Omit Use Case, call Repository from Notifier | Avoid shell Use Cases that just pass through calls |
| **Complex Logic** | Must use Use Case | Ensures business rules are testable and reusable |
| **Single Impl** | Omit Interface, rely on concrete class | Add interface only when multiple implementations or mocking is needed |
| **Shared Code** | Extract to `core/` or `shared/` | Avoid duplication across features |

**Principle**: Interfaces and abstractions should be **introduced on demand**, not mechanically applied.

> See [common_scenarios.md](common_scenarios.md) Section 2 for detailed decision flowcharts.

---

## 2. Code Generation Tools

~~~yaml
# Recommended Tool Set (Versions for reference only, check pub.dev for latest)
dev_dependencies:
  build_runner: ^2.4.0
  freezed: ^2.5.0
  json_serializable: ^6.8.0
  riverpod_generator: ^2.6.0
  auto_route_generator: ^9.0.0
  retrofit_generator: ^9.0.0
  drift_dev: ^2.22.0
~~~

### Build Commands

~~~bash
# Watch mode (during development)
dart run build_runner watch --delete-conflicting-outputs

# Single build (CI/CD)
dart run build_runner build --delete-conflicting-outputs
~~~

---

## 3. Mason Brick Templates

~~~bash
# Install Mason
dart pub global activate mason_cli

# Initialize
mason init

# Add feature brick
mason add feature_brick --git-url https://github.com/example/feature_brick

# Generate new feature
mason make feature_brick --name user_profile
~~~

---

## 4. Boilerplate Reduction

| Technique | Description |
|-----------|-------------|
| **Barrel exports** | Use `index.dart` for unified exports per directory |
| **Extension methods** | Use extensions for Mappers instead of separate classes |
| **Generic Repository** | Define `BaseRepository<T>` to reduce repetitive interfaces |
| **Provider family** | Use parametrized Providers to avoid duplication |
| **Sealed class** | Use sealed classes for auto-exhaustive Failure/State handling |

### Generic Repository Example

~~~dart
abstract interface class BaseRepository<T, ID> {
  Future<Either<Failure, T>> findById(ID id);
  Future<Either<Failure, List<T>>> findAll();
  Future<Either<Failure, Unit>> save(T entity);
  Future<Either<Failure, Unit>> delete(ID id);
}

abstract interface class UserRepository implements BaseRepository<User, UserId> {
  Future<Either<Failure, User>> findByEmail(Email email);
}
~~~

---

## 5. Debugging

| Scenario | Recommended Method |
|----------|--------------------|
| **Data Flow Tracking** | Riverpod `ProviderObserver` |
| **Network Debugging** | Dio `LogInterceptor` + Charles/Proxyman |
| **Layer Locating** | Add logs per layer, identifying the current layer |

### ProviderObserver Example

~~~dart
class AppProviderObserver extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase<dynamic> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    debugPrint('[${provider.name ?? provider.runtimeType}] $previousValue -> $newValue');
  }
}

runApp(ProviderScope(
  observers: [if (kDebugMode) AppProviderObserver()],
  child: const App(),
));
~~~

---

## 6. Testing Efficiency

| Technique | Description |
|-----------|-------------|
| **Fake First** | Use Fake instead of Mock for simple scenarios |
| **Test Grouping** | Use `@Tags` to group tests |
| **Parallel Execution** | `flutter test --concurrency=4` |

### Fake Repository Example

~~~dart
class FakeUserRepository implements UserRepository {
  final List<User> _users = [];

  @override
  Future<Either<Failure, User>> findById(UserId id) async {
    final user = _users.firstWhereOrNull((u) => u.id == id);
    return user != null ? right(user) : left(const Failure.notFound(resource: 'User'));
  }
}
~~~

---

## 7. Dependency Injection

~~~dart
@riverpod
UserRepository userRepository(Ref ref) {
  return UserRepositoryImpl(
    ref.read(userRemoteDataSourceProvider),
    ref.read(userLocalDataSourceProvider),
  );
}

// Override for testing
final container = ProviderContainer(
  overrides: [
    userRepositoryProvider.overrideWithValue(FakeUserRepository()),
  ],
);
~~~
