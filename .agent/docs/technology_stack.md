# Technology Stack & Development Scenarios

> Reference document for Flutter Clean Architecture. See also: [Core Prompt](../rules.md)

## Official API Documentation

| Package | Documentation |
|---------|---------------|
| **Riverpod** | [pub.dev/documentation/riverpod](https://pub.dev/documentation/riverpod/latest/) |
| **flutter_bloc** | [pub.dev/documentation/flutter_bloc](https://pub.dev/documentation/flutter_bloc/latest/) |
| **Freezed** | [pub.dev/documentation/freezed](https://pub.dev/documentation/freezed/latest/) |
| **fpdart** | [pub.dev/documentation/fpdart](https://pub.dev/documentation/fpdart/latest/) |
| **Drift** | [drift.simonbinder.eu](https://drift.simonbinder.eu/docs/) |
| **Dio** | [pub.dev/documentation/dio](https://pub.dev/documentation/dio/latest/) |
| **Retrofit** | [pub.dev/documentation/retrofit](https://pub.dev/documentation/retrofit/latest/) |
| **auto_route** | [pub.dev/documentation/auto_route](https://pub.dev/documentation/auto_route/latest/) |
| **go_router** | [pub.dev/documentation/go_router](https://pub.dev/documentation/go_router/latest/) |
| **json_serializable** | [pub.dev/documentation/json_serializable](https://pub.dev/documentation/json_serializable/latest/) |
| **flutter_secure_storage** | [pub.dev/documentation/flutter_secure_storage](https://pub.dev/documentation/flutter_secure_storage/latest/) |
| **shared_preferences** | [pub.dev/documentation/shared_preferences](https://pub.dev/documentation/shared_preferences/latest/) |

---

## 1. State Management

The architecture is compatible with mainstream state management solutions. Choose based on project needs.

| Dimension | Riverpod | BLoC |
|-----------|----------|------|
| **Recommended Scenario** | Medium-Large apps, Modularity, Flexible DI | Enterprise apps, Strict architecture, Large teams |
| **Core API** | `Notifier`, `AsyncNotifier` | `Bloc`, `Cubit`, Events/States |
| **Dependency Injection** | Compile-time safe, Context-free | Requires BlocProvider, BuildContext |
| **Code Generation** | Annotation support | None |

> **Selection Principle**: Refer to official documentation recommendations, considering team tech stack and project requirements.

### Notifier Responsibility Boundary

In this architecture, Riverpod Notifier assumes the role of Controller + Presenter in MVP:

| MVP Concept | Notifier Implementation |
|-------------|-------------------------|
| **Controller** (Event Handling) | Notifier methods (e.g., `loadUser()`, `submit()`) |
| **Presenter** (State Transformation) | `state = AsyncData(...)` state updates |
| **View Refresh** | Riverpod `ref.watch()` reactive rebuilds |

### Riverpod Example

~~~dart
@riverpod
class UserDetailNotifier extends _$UserDetailNotifier {
  @override
  FutureOr<User?> build() => null;

  Future<void> loadUser(UserId id) async {
    state = const AsyncLoading();
    final result = await ref.read(getUserByIdProvider).call(id);
    state = result.fold(
      (failure) => AsyncError(failure, StackTrace.current),
      (user) => AsyncData(user),
    );
  }
}

// Use ref.watch() for reactive rebuilds
// Use ref.read() for one-time access or triggering actions
// Use ref.listen() for side effects (navigation, snackbar) without rebuild
// Use ref.invalidate() / ref.refresh() for cache invalidation
// Use ref.onDispose() for resource cleanup
~~~

### BLoC Example

~~~dart
class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc(this._getUserById) : super(UserInitial()) {
    on<LoadUserRequested>(_onLoadUser);
  }

  final GetUserById _getUserById;

  Future<void> _onLoadUser(LoadUserRequested event, Emitter<UserState> emit) async {
    emit(UserLoading());
    final result = await _getUserById(event.userId);
    result.fold(
      (failure) => emit(UserError(failure)),
      (user) => emit(UserLoaded(user)),
    );
  }
}

// Use BlocBuilder for UI, BlocListener for side effects
// Use BlocSelector for fine-grained rebuilds
~~~

---

## 2. Local Database

| Dimension | Drift | Isar | ObjectBox |
|-----------|-------|------|-----------|
| **Data Model** | Relational SQL | Object NoSQL | Object NoSQL |
| **Web Support** | ✅ Complete | ⚠️ Limited | ❌ Not supported |
| **Performance** | Excellent for SQL optimization | Extending fast (Large datasets) | Extremely fast (CRUD + Sync) |
| **Maintenance** | ✅ Active | ⚠️ Community maintained | ✅ Commercial support |
| **Recommended Scenario** | Complex relational data, Web | Mobile high performance | Offline-first enterprise apps |

### Drift Example

~~~dart
class Users extends Table with IdMixin, TimestampsMixin {
  late final name = text()();
  late final email = text()();
  late final avatar = text().nullable()();

  @override
  List<Set<Column>> get uniqueKeys => [{email}];
}

@DriftAccessor(tables: [Users])
class UsersDao extends DatabaseAccessor<AppDatabase> with _$UsersDaoMixin {
  UsersDao(super.db);

  Stream<List<User>> watchAll() => select(users).watch();
  Future<User?> findById(String id) =>
      (select(users)..where((t) => t.id.equals(id))).getSingleOrNull();
}
~~~

---

## 3. Routing

| Dimension | auto_route | go_router |
|-----------|------------|-----------|
| **Code Generation** | ✅ Required | ❌ Optional |
| **Type Safety** | Compile-time check | Runtime |
| **Deep Linking** | ✅ Supported | ✅ Strength |
| **Recommended Scenario** | Type safety first | Simple API, Web first |

### auto_route Example

~~~dart
@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: HomeRoute.page, initial: true),
    AutoRoute(page: UserDetailRoute.page, path: '/users/:id'),
  ];

  @override
  List<AutoRouteGuard> get guards => [AuthGuard()];
}
~~~

### go_router Example

~~~dart
final goRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (_, __) => const HomePage()),
    GoRoute(
      path: '/users/:id',
      builder: (_, state) => UserDetailPage(
        userId: state.pathParameters['id']!,
      ),
    ),
  ],
);
~~~

---

## 4. Latest Tech Features

### Freezed Pattern Matching

~~~dart
// Union types with native Dart 3 pattern matching
@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState.initial() = AuthInitial;
  const factory AuthState.loading() = AuthLoading;
  const factory AuthState.authenticated(User user) = AuthAuthenticated;
  const factory AuthState.error(Failure failure) = AuthError;
}

// Using Dart 3 native pattern matching
Widget build(BuildContext context) {
  return switch (authState) {
    AuthInitial() || AuthLoading() => const LoadingWidget(),
    AuthAuthenticated(:final user) => UserProfile(user: user),
    AuthError(:final failure) => ErrorWidget(failure.message),
  };
}
~~~

### Freezed JSON Serialization

~~~dart
// JSON serialization with json_serializable
@freezed
abstract class UserDto with _$UserDto {
  const factory UserDto({
    required String id,
    required String email,
    @Default('anonymous') String name,  // Default value annotation
    @JsonKey(name: 'created_at') required String createdAt,
  }) = _UserDto;

  // Generate fromJson factory constructor
  factory UserDto.fromJson(Map<String, dynamic> json) => _$UserDtoFromJson(json);
}

// Generated methods:
// - fromJson() / toJson()
// - copyWith()
// - toString()
// - == / hashCode
~~~

### Riverpod AsyncNotifier

~~~dart
@riverpod
class UserListNotifier extends _$UserListNotifier {
  @override
  Future<List<User>> build() async {
    return await ref.read(userRepositoryProvider).findAll().then(
          (result) => result.getOrElse(() => []),
        );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final result = await ref.read(userRepositoryProvider).findAll();
      return result.getOrElse(() => []);
    });
  }
}
~~~

### Resource Cleanup

~~~dart
// Resource cleanup with ref.onDispose
@riverpod
StreamController<Event> eventController(Ref ref) {
  final controller = StreamController<Event>.broadcast();
  ref.onDispose(controller.close); // Prevent memory leaks
  return controller;
}
~~~

### Provider Lifecycle (keepAlive)

~~~dart
// By default, @riverpod generated Providers are autoDispose (disposed when no listeners)
// Use keepAlive: true to maintain Provider state

@Riverpod(keepAlive: true)  // Will not auto dispose
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() => const AuthState.initial();
}

// Dynamically control lifecycle
@riverpod
class UserCache extends _$UserCache {
  @override
  User? build() {
    // Keep alive under specific conditions
    ref.keepAlive();  // Prevent auto dispose
    return null;
  }
}
~~~

### Side Effects with ref.listen

~~~dart
// Use ref.listen for side effects without triggering rebuild
class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen for auth state changes and navigate
    ref.listen<AuthState>(authStateProvider, (previous, next) {
      if (next is AuthUnauthenticated) {
        context.router.replaceAll([const LoginRoute()]);
      }
      if (next is AuthError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.failure.message ?? 'Error')),
        );
      }
    });

    return // ... widget tree
  }
}
~~~

### App Lifecycle Management

Flutter 3.13+ provides `AppLifecycleListener` for handling app lifecycle events:

~~~dart
class MyPage extends ConsumerStatefulWidget {
  const MyPage({super.key});

  @override
  ConsumerState<MyPage> createState() => _MyPageState();
}

class _MyPageState extends ConsumerState<MyPage> {
  late final AppLifecycleListener _lifecycleListener;

  @override
  void initState() {
    super.initState();
    _lifecycleListener = AppLifecycleListener(
      onPause: _onAppPaused,
      onResume: _onAppResumed,
      onDetach: _onAppDetached,
    );
  }

  void _onAppPaused() {
    // App enters background: pause location, stop animation, save draft
    ref.read(locationServiceProvider).stopTracking();
  }

  void _onAppResumed() {
    // App resumes foreground: refresh data, resume location
    ref.read(userNotifierProvider.notifier).refresh();
  }

  void _onAppDetached() {
    // App terminates: save critical state
  }

  @override
  void dispose() {
    _lifecycleListener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ...
  }
}
~~~

> **Note**: Riverpod `ref.onDispose()` manages Provider lifecycle, `AppLifecycleListener` manages App-level lifecycle.

---

## 5. Network Layer

~~~dart
@riverpod
Dio dio(Ref ref) {
  return Dio(BaseOptions(
    baseUrl: Env.instance.apiBaseUrl,
    connectTimeout: Env.instance.connectTimeout,
    receiveTimeout: Env.instance.receiveTimeout,
  ))..interceptors.addAll([
    AuthInterceptor(ref.read(authTokenProvider)),
    LogInterceptor(requestBody: true, responseBody: true),
    ErrorInterceptor(),
  ]);
}

@RestApi()
abstract class UserApiClient {
  factory UserApiClient(Dio dio) = _UserApiClient;

  @GET('/users/{id}')
  Future<UserDto> getUser(@Path('id') String id);

  @POST('/users')
  @MultiPart()
  Future<UserDto> createUser(
    @Part() String name,
    @Part() String email,
    @Part() File? avatar,
  );
}
~~~

---

## 6. File & Image Handling

~~~dart
// File download with progress
class DownloadManager {
  Future<File> download(
    String url,
    String savePath, {
    void Function(int received, int total)? onProgress,
    CancelToken? cancelToken,
  }) async {
    await _dio.download(
      url,
      savePath,
      onReceiveProgress: onProgress,
      cancelToken: cancelToken,
    );
    return File(savePath);
  }
}

// Image upload with compression
class ImageUploader {
  Future<String> uploadImage(File file, {int quality = 85}) async {
    final compressed = await compressImage(file, quality: quality);
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        compressed.path,
        filename: path.basename(compressed.path),
      ),
    });
    final response = await _dio.post('/upload', data: formData);
    return response.data['url'];
  }
}
~~~

---

## 7. Local Storage

~~~dart
// SharedPreferences for simple key-value
@riverpod
SharedPreferences sharedPreferences(Ref ref) {
  throw UnimplementedError(); // Override in ProviderScope
}

// Secure storage for sensitive data
@riverpod
FlutterSecureStorage secureStorage(Ref ref) {
  return const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
}

// File storage for documents/media
class FileStorage {
  Future<Directory> get documentsDir async =>
      await getApplicationDocumentsDirectory();

  Future<File> saveFile(String name, Uint8List data) async {
    final dir = await documentsDir;
    final file = File('${dir.path}/$name');
    return file.writeAsBytes(data);
  }
}
~~~
