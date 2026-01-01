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
       ├── widgets/
       └── notifiers/  # UI-specific state notifiers (e.g., form visibility)
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

## Performance Guidelines (CRITICAL)

9. **Riverpod State Management**:
   - **NEVER** use `setState()` in any widget
   - All state MUST be managed via Riverpod providers
   - Use `@riverpod` annotation with code generation
   - Place notifiers in dedicated files (e.g., `notifiers/xxx_notifier.dart`)
   - **Minimize rebuild scope**: Use `select()` for granular subscriptions
   - Prefer `autoDispose` for ephemeral UI state

10. **Widget Optimization**:
    - Use `const` constructors wherever possible
    - Extract child widgets to separate classes to limit rebuild scope
    - **Reduce nesting**: Extract deeply nested widgets to private methods or separate widgets
    - Add `Key` only when necessary (e.g., lists, form fields for testing)
    - Prefer `ConsumerWidget` over `ConsumerStatefulWidget` when no lifecycle needed

---

## Code Generation

// turbo
11. Run code generation if using Freezed/Riverpod/Retrofit:
    ~~~bash
    dart run build_runner build --delete-conflicting-outputs
    ~~~

---

## Verification (MANDATORY)

// turbo
12. Run static analysis to verify no errors:
    ~~~bash
    dart analyze lib/features/{feature_name}
    ~~~

13. **Post-Action Verification**:
    - After EVERY implementation step, verify the result meets requirements
    - Check `dart analyze` for zero warnings/errors
    - Manually confirm UI behavior if applicable
    - Do NOT proceed to next step if verification fails

---

## Test Case Design Principles

14. **Requirements-First Approach**:
    - Design test cases based on REAL user requirements
    - NEVER reverse-engineer tests from existing implementation
    - Start with "What should this feature do?" not "What does this code do?"

15. **Test Structure**:
    ~~~dart
    /// Format: should_[expected behavior]_when_[condition]
    test('should return token when credentials are valid', () { ... });
    test('should show error when password is empty', () { ... });
    ~~~

16. **Description Guidelines**:
    - Use semantic, action-oriented language
    - Keep descriptions concise and precise
    - Ensure logical flow from condition to expectation
    - Avoid implementation details in test names

---

## Completion Checklist

Before marking complete, verify:

- [ ] Directory structure follows architecture principles
- [ ] Entity uses unique ID for equality (if applicable)
- [ ] Value Objects are immutable with validation (if applicable)
- [ ] Repository interface defined in `domain/`, implementation in `infrastructure/`
- [ ] All `Either<Failure, T>` return types properly handled
- [ ] No Flutter SDK imports in Domain layer
- [ ] **No `setState()` usage anywhere**
- [ ] **All providers use code generation (`@riverpod`)**
- [ ] **`dart analyze` passes with zero issues**
- [ ] **Test cases designed from requirements, not implementation**
