# Common Scenarios

> FAQ-style guide for common implementation decisions. For detailed patterns, see the corresponding reference documents.

## 1. Entity vs Value Object

> Detailed definitions in [ddd_patterns.md](ddd_patterns.md)

### Decision Flowchart

~~~
Question: Does this object need a unique identity?
│
├─ YES → Does the same data represent different things in business context?
│         ├─ YES → **Entity** (needs unique ID)
│         └─ NO  → **Value Object**
│
└─ NO  → Is the object defined entirely by its attribute values?
          ├─ YES → **Value Object**
          └─ NO  → Re-examine business requirements
~~~

### Quick Decision Table

| Scenario | Type | Reason |
|----------|------|--------|
| User with profile | **Entity** | Same user can change email, still same user |
| Email address | **Value Object** | `a@b.com` is always equal to `a@b.com` |
| Order | **Entity** | Two orders with same items are different orders |
| Money (amount + currency) | **Value Object** | $10 USD is always equal to $10 USD |
| Product in catalog | **Entity** | Has lifecycle, can be updated |
| Address | **Value Object** | Same street + city = same address |

---

## 2. When to Use Use Case vs Direct Repository

> See [developer_experience.md](developer_experience.md) for pragmatic layering

### Decision Table

| Scenario | Recommendation | Reason |
|----------|----------------|--------|
| Simple CRUD with no business logic | Direct Repository | Avoid empty pass-through Use Case |
| Single Repository call with validation | Use Case | Encapsulates validation logic |
| Multiple Repository calls in sequence | Use Case | Coordinates transaction/flow |
| Business rule enforcement | Use Case | Keeps domain rules testable |
| Cross-feature data aggregation | Use Case | Manages dependencies |

### Examples

~~~dart
// ✅ SKIP Use Case: Simple fetch with no business logic
class UserNotifier extends _$UserNotifier {
  Future<void> loadUser(UserId id) async {
    final result = await ref.read(userRepositoryProvider).findById(id);
    // ...
  }
}

// ✅ USE Use Case: Has business logic (validation, rules)
class CreateOrderUseCase {
  Future<Either<Failure, Order>> call(CreateOrderRequest request) async {
    // 1. Validate request
    // 2. Check inventory
    // 3. Calculate pricing
    // 4. Save order
    return _orderRepository.save(order);
  }
}
~~~

---

## 3. Adding a New API Endpoint

### Step-by-Step

1. **Define DTO** in `infrastructure/dtos/`
   ~~~dart
   @freezed
   abstract class NewFeatureDto with _$NewFeatureDto {
     // ...
     factory NewFeatureDto.fromJson(Map<String, dynamic> json) =>
         _$NewFeatureDtoFromJson(json);
   }
   ~~~

2. **Add Retrofit method** in DataSource
   ~~~dart
   @GET('/api/new-feature/{id}')
   Future<NewFeatureDto> getNewFeature(@Path('id') String id);
   ~~~

3. **Add Mapper** in `infrastructure/mappers/`
   ~~~dart
   extension NewFeatureDtoMapper on NewFeatureDto {
     NewFeature toDomain() => // ...
   }
   ~~~

4. **Implement Repository method**
   ~~~dart
   @override
   Future<Either<Failure, NewFeature>> findById(String id) async {
     try {
       final dto = await _remoteDataSource.getNewFeature(id);
       return right(dto.toDomain());
     } on NetworkException catch (e) {
       return left(Failure.network(message: e.message));
     }
   }
   ~~~

5. **Run code generation**
   ~~~bash
   dart run build_runner build --delete-conflicting-outputs
   ~~~

---

## 4. Adding a New Database Table

### Step-by-Step (Drift)

1. **Define Table** in `core/infrastructure/databases/tables/`
   ~~~dart
   class NewItems extends Table {
     late final id = text()();
     late final name = text()();
     late final createdAt = dateTime()();

     @override
     Set<Column> get primaryKey => {id};
   }
   ~~~

2. **Register in AppDatabase**
   ~~~dart
   @DriftDatabase(tables: [Users, NewItems, ...])
   class AppDatabase extends _$AppDatabase {
     // ...
   }
   ~~~

3. **Create DAO** in `core/infrastructure/databases/daos/`
   ~~~dart
   @DriftAccessor(tables: [NewItems])
   class NewItemsDao extends DatabaseAccessor<AppDatabase>
       with _$NewItemsDaoMixin {
     NewItemsDao(super.db);

     Stream<List<NewItem>> watchAll() => select(newItems).watch();
   }
   ~~~

4. **Run code generation**
   ~~~bash
   dart run build_runner build --delete-conflicting-outputs
   ~~~

---

## 5. Handling Nullable vs Required Fields

### Decision Table

| Scenario | Dart Type | Freezed Annotation |
|----------|-----------|-------------------|
| Always required from API | `required String` | None |
| Optional from API, has default | `String` | `@Default('value')` |
| Optional from API, no default | `String?` | None |
| Required in domain, optional in DTO | DTO: `String?`, Entity: `required String` | Mapper handles conversion |

### Example

~~~dart
// DTO: API may not return avatar
@freezed
abstract class UserDto with _$UserDto {
  const factory UserDto({
    required String id,
    required String email,
    String? avatar,  // Optional from API
  }) = _UserDto;
}

// Entity: Avatar has default in domain
@freezed
abstract class User with _$User {
  const factory User({
    required UserId id,
    required Email email,
    @Default('') String avatarUrl,  // Default in domain
  }) = _User;
}

// Mapper handles conversion
extension UserDtoMapper on UserDto {
  User toDomain() => User(
    id: UserId.fromTrustedSource(id),
    email: Email.fromTrustedSource(email),
    avatarUrl: avatar ?? '',  // Convert null to default
  );
}
~~~

---

## 6. State Provider Selection

> See [technology_stack.md](technology_stack.md) for detailed API examples

### Decision Table

| Scenario | Riverpod Provider Type |
|----------|----------------------|
| Sync value, no rebuild needed | `Provider` |
| Async value, auto-fetch on build | `FutureProvider` / `AsyncNotifierProvider` |
| Stream subscription | `StreamProvider` |
| Mutable state with methods | `NotifierProvider` |
| Async mutable state with methods | `AsyncNotifierProvider` |
| Parameterized provider | `.family` modifier |
| Singleton (never dispose) | `@Riverpod(keepAlive: true)` |
