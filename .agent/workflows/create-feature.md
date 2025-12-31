---
description: create a new feature module following clean architecture
---

# Create Feature Workflow

## Prerequisites

1. Read the core rules at `.agent/rules.md`

2. Read the architecture principles at `.agent/docs/architecture_principles.md`

3. Confirm feature name with user (use `snake_case`, e.g., `user_profile`, `order_management`)

---

## Create Directory Structure

4. Create the feature directory structure:
   ~~~
   lib/features/{feature_name}/
   ├── domain/
   │   ├── entities/
   │   ├── value_objects/
   │   └── repositories/
   ├── application/
   │   ├── usecases/
   │   ├── providers/
   │   └── notifiers/
   ├── infrastructure/
   │   ├── dtos/
   │   ├── datasources/
   │   ├── mappers/
   │   └── repositories/
   └── presentation/
       ├── pages/
       └── widgets/
   ~~~

---

## Implement Components (Conditional)

5. **If creating Entity or Value Object**:
   - Reference `.agent/docs/ddd_patterns.md`
   - Use templates from `.agent/docs/quick_reference.md`

6. **If implementing error handling**:
   - Reference `.agent/docs/error_handling.md`

7. **If adding API integration**:
   - Create DTO in `infrastructure/dtos/`
   - Create DataSource in `infrastructure/datasources/`
   - Create Mapper in `infrastructure/mappers/`
   - Reference `.agent/docs/common_scenarios.md` Section 3

8. **If adding database table**:
   - Create Table in `core/infrastructure/databases/tables/`
   - Create DAO in `core/infrastructure/databases/daos/`
   - Reference `.agent/docs/common_scenarios.md` Section 4

---

## Code Generation

// turbo
9. Run code generation if using Freezed/Riverpod/Retrofit:
   ~~~bash
   dart run build_runner build --delete-conflicting-outputs
   ~~~

---

## Verification

// turbo
10. Run static analysis to verify no errors:
    ~~~bash
    dart analyze lib/features/{feature_name}
    ~~~

---

## Completion Checklist

Before marking complete, verify:

- [ ] Directory structure follows architecture principles
- [ ] Entity uses unique ID for equality (if applicable)
- [ ] Value Objects are immutable with validation (if applicable)
- [ ] Repository interface defined in `domain/`, implementation in `infrastructure/`
- [ ] All `Either<Failure, T>` return types properly handled
- [ ] No Flutter SDK imports in Domain layer
- [ ] `dart analyze` passes with no errors
