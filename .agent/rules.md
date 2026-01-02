# Flutter Clean Architecture Engineering Prompt

> This Prompt guides the entire engineering process for Flutter Clean Architecture projects, including design, development, auditing, and testing.

## Scope

| Project Size | Recommended Architecture |
|--------------|--------------------------|
| **Small**    | Simplified: UI + Data layers, Application layer optional |
| **Medium**   | Standard: Complete 4 layers, Use Cases can be simplified |
| **Large**    | Complete: Strict 4 layers + Full DDD patterns |

> **Criteria**: Judge based on actual project complexity, team size, and maintenance cycle.

> [!NOTE]
> This architecture does **NOT** use the `flutter_clean_architecture` package. Instead, it implements the same principles using **Riverpod + Freezed + fpdart**. Both follow Uncle Bob's Clean Architecture but differ in API style:
> - This Architecture: Declarative State Management + Functional Error Handling
> - flutter_clean_architecture: Imperative Controller/Presenter + Observer Callbacks

---

## Architecture Principles Summary

### Four-Layer Structure (Dependency Direction: Outside → In)

~~~
Presentation → Application → Domain ← Infrastructure
~~~

### Key Rules

- **Domain Layer Purity**:
  - ✅ Allowed: Pure Dart packages (`fpdart`, `freezed_annotation`, `meta`)
  - ❌ Prohibited: Flutter SDK, infrastructure-related packages
- **Dependency Rule**: Inner layers must not know about outer layers.
- **Repository Pattern**: Domain defines interfaces, Infrastructure provides implementations.

### Directory Structure

~~~
lib/
├── core/domain/          # Shared Domain (Failures, Value Objects)
├── core/infrastructure/  # Shared Infrastructure (Network, Database)
├── features/[name]/      # Feature Modules (domain/application/infrastructure/presentation)
├── shared/               # Shared UI Components
├── router/               # Router Configuration
└── l10n/                 # Localization
~~~

> 📖 See [architecture_principles.md](docs/architecture_principles.md) for detailed principles.

---

## Documentation Index

### Core Documentation

| Document | Content | Usage Scenario |
|----------|---------|----------------|
| [project_overview.md](docs/project_overview.md) | Project Overview & Navigation | **Read First**, understand goals |
| [architecture_principles.md](docs/architecture_principles.md) | Architecture Principles & Structure | New features, Architecture review |
| [ddd_patterns.md](docs/ddd_patterns.md) | DDD Tactical Patterns | Entity/VO design, Repository implementation |
| [error_handling.md](docs/error_handling.md) | Error Handling Strategy | Exception/Failure design |

### Implementation Guides

| Document | Content | Usage Scenario |
|----------|---------|----------------|
| [technology_stack.md](docs/technology_stack.md) | Tech Stack & Scenarios | Choosing solutions, Implementing features |
| [common_scenarios.md](docs/common_scenarios.md) | Common Scenarios FAQ | Decision making, Reference steps |
| [quick_reference.md](docs/quick_reference.md) | Code Templates | Copy-paste templates |

### Quality Assurance

| Document | Content | Usage Scenario |
|----------|---------|----------------|
| [developer_experience.md](docs/developer_experience.md) | Developer Experience | Code generation, Debugging, Testing |
| [testing_and_audit.md](docs/testing_and_audit.md) | Testing Strategy & Audit | TDD, Code review |

---

## Authoritative Sources

- **Clean Architecture**: Robert C. Martin
- **Domain-Driven Design**: Eric Evans
- **Flutter Architecture Guide**: [docs.flutter.dev/app-architecture](https://docs.flutter.dev/app-architecture/guide)

---

## AI Behavior Guidelines

> [!CAUTION]
> The following rules constrain AI behavior to minimize hallucinations and bad decisions.

### Information Priority

| Priority | Source | Description |
|----------|--------|-------------|
| **1** | Prompt Principles | Inviolable design boundaries (Dependency Rule, Layer Separation) |
| **2** | Official Docs | Flutter, Dart, Package official recommendations |
| **3** | Existing Code | **Only if compliant with principles**, follow existing patterns |
| **4** | Authoritative Lit. | Uncle Bob, Eric Evans (for understanding context) |
| **5** | Auxiliary Docs | `quick_reference.md`, `common_scenarios.md` (Reference only, explicitly subordinate to principles) |

> [!WARNING]
> If existing code violates architecture principles, **REPORT THE ISSUE** instead of copying the wrong pattern.

### Mandatory Rules

- **No Hallucinations**:
  - API/Class/Method: Must check official docs or project code if unsure.
  - Business Logic: Must not assume unspecified business rules.
  - Functional Requirements: Must not add unrequested features.
  - Data Structures: Must not assume unverified fields or types.
- **No Fabricated Versions**: Use versions from `pubspec.yaml` or pub.dev.
- **No Assumed Structure**: Check actual directory structure first.
- **No Skipping Verification**: Must run `dart analyze` after changes.

### Decision Boundaries

| Scenario | AI Authority | Action |
|----------|--------------|--------|
| **Applying Principles** | ✅ Autonomous | Apply layer separation, dependency rules |
| **Official Recommendations** | ✅ Autonomous | Choose suitable Notifier/AsyncNotifier |
| **Adding Dependencies** | ⚠️ Confirm | Explain reason and ask user |
| **Modifying Architecture** | ❌ Prohibited | Must discuss with user first |
| **Deleting Code** | ⚠️ Confirm | Explain reason and wait for confirmation |
| **Deviating from Prompt** | ❌ Prohibited | Explain reason and request permission if necessary |
| **Adding Unrequested Features** | ❌ Prohibited | Only execute explicit requests |

### Handling Uncertainty

~~~
Q: Am I sure this information is accurate?
│
├─ YES → Proceed
│
└─ NO → Q: Is this a critical decision?
          │
          ├─ YES → Stop and ask user
          │
          └─ NO → Use conservative approach, flag uncertainty in response
~~~

**Critical Decisions**:
- Business Logic
- Adding/Removing Features
- Architecture Structure
- External Dependencies

**Conservative Approach** (Non-critical technical details only):
- Use **existing compliant** patterns
- Use standard practices from official docs
- Do not introduce unused new patterns or dependencies

> [!NOTE]
> Conservative approach applies only to technical details like naming/file org. Business logic must be confirmed with the user.

### Code Generation Standards

| Rule | Description |
|------|-------------|
| **Read First** | View file content before modifying |
| **Incremental** | Modify only necessary parts, preserve style |
| **Type Safety** | Generated code must pass static analysis |
| **Consistency** | Follow naming/org conventions (**if compliant**) |
| **Verifiable** | Provide verification steps (e.g., test commands) |

### Error Handling

Stop and report if:

- `dart analyze` reports errors
- Imported package/class does not exist
- Project structure does not match **Prompt Structure**
- User instructions are ambiguous or conflicting

---

## Performance Constraints (CRITICAL)

> [!CAUTION]
> Violating these rules will result in rejected code.

### State Management

| Rule | Description |
|------|-------------|
| **NO setState** | `setState()` is PROHIBITED in all widgets |
| **Riverpod Only** | All state must use Riverpod providers |
| **Code Generation** | Use `@riverpod` annotation, never manual providers |
| **Minimal Scope** | Provider scope must be as narrow as possible |
| **UI State Separation** | Ephemeral UI state (e.g., visibility toggle) goes in `presentation/notifiers/` |

### Widget Optimization

| Rule | Description |
|------|-------------|
| **const Constructors** | Use `const` wherever possible |
| **Extract Widgets** | Split large widgets to minimize rebuild scope |
| **Reduce Nesting** | Avoid deep widget nesting; extract to private methods or widgets |
| **ConsumerWidget First** | Prefer `ConsumerWidget` over `ConsumerStatefulWidget` |
| **Keys** | Add `Key` only for lists, form fields, or testing |
| **select()** | Use `ref.watch(provider.select(...))` for granular subscriptions |

---

## Post-Action Verification (MANDATORY)

> [!WARNING]
> Every action MUST be followed by verification. Do NOT proceed if verification fails.

### Verification Protocol (STRICT)

~~~
After EVERY implementation action:
│
├── 1. Run `dart analyze` → Must show **ZERO** issues (info/warning/error)
│     └── ⛔ IF ANY ISSUE EXISTS: FIX IMMEDIATELY. DO NOT PROCEED.
│
├── 2. Design Compliance Audit (Critical)
│     ├── Re-read `architecture_principles.md` & `rules.md`
│     ├── Verify layer separation & dependency rules (Domain independent?)
│     ├── Check prohibited behaviors (e.g., setState, manual providers)
│     └── Ensure ALL user requirements are met without omission
│
├── 3. Verify test results (if tests exist) → Must pass
│
└── 4. Confirm changes match requirements → Re-read task before proceeding
~~~

### Zero Tolerance Policy
- **NO Unresolved Issues**: It is strictly prohibited to leave *any* `dart analyze` info, warning, or error unresolved.
- **NO Design Violations**: Code that violates architecture principles must be rolled back or fixed immediately.
- **NO Partial Implementations**: Do not mark a task as done if it generates new warnings or fails to meet the full design scope.

### Verification Commands

| Action Type | Verification Command |
|-------------|---------------------|
| Code changes | `dart analyze --fatal-infos` |
| Feature implementation | `flutter test` (if tests exist) |
| Build configuration | `flutter build` (dry run) |

---

## Test Case Design Principles

### Requirements-First Approach

- Design tests from **user requirements**, NOT from existing code
- Ask: "What should this feature do?" not "What does this code do?"
- Tests must be written **before or independently** of implementation

### Naming Convention

~~~dart
/// Format: should_[expected behavior]_when_[condition]
test('should return token when credentials are valid', () { ... });
test('should show error message when password is empty', () { ... });
~~~

### Description Guidelines

| Principle | Example |
|-----------|---------|
| **Semantic** | "should validate email format" ✅ not "test email" ❌ |
| **Precise** | "when password is empty" ✅ not "when bad input" ❌ |
| **Action-Oriented** | Use verbs: return, show, navigate, throw |
| **Logical Flow** | Condition → Action → Expected Result |

---

> [!IMPORTANT]
> **Core AI Guidelines**:
> 1. **Principles First**: Never violate architecture principles.
> 2. **Verify First**: Verify all uncertain information.
> 3. **Ask First**: Ask user about business logic/scope decisions.
> 4. **Minimal Change**: Execute only what is requested.
> 5. **Performance First**: No setState, minimize Riverpod scope.

---

## Git Execution Flow

> [!IMPORTANT]
> The Agent must follow these Git standard practices to ensure codebase history quality.

### 1. Atomic Commits
- **Clear Boundaries**: Each commit must represent a single, complete logical change.
- **No Mixing**: Do not mix refactoring with feature implementation in the same commit.
- **Verification**: Ensure `dart analyze` passes before committing (no logic errors).

### 2. Commit Messages
- **Format**: `type(scope): description` (Conventional Commits)
  - Types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`
- **Content**:
  - **Technical Focus**: Describe *what* changed (e.g., "add token refresh interceptor"). Avoid marketing language like "production-grade", "robust", "cutting-edge".
  - **Concise**: Keep the first line under 50 chars, detailed description wrapped at 72 chars.
  - **No Ambiguity**: Avoid vague messages like "fixed bug" or "update code".

### 3. Gitflow Branching Standards
- **Feature Branches**: `feat/feature-name` (e.g., `feat/login-screen`)
- **Bug Fixes**: `fix/bug-issue` (e.g., `fix/token-refresh-loop`)
- **Documentation**: `docs/topic` (e.g., `docs/api-guide`)
- **Refactoring**: `refactor/scope` (e.g., `refactor/auth-provider`)

### 4. Workflow Rules
1. **Pull Latest**: Always pull `develop`/`main` before starting.
2. **Create Branch**: Create a focused branch for the task: `git checkout -b [type]/[name]`.
3. **Work & Commit**: Make atomic commits as you progress.
4. **Push & PR**: Push to origin and create a Pull Request.
5. **Clean Up**: Delete local branch after merge.

### 5. Agent Commit Policy
- **Explicit Instruction Required**: Agent must NOT auto-commit without explicit user instruction (e.g., "commit", "push", "提交").
- **Staging Only**: Agent may stage changes (`git add`) but must wait for user approval before committing.
- **Exception**: If user explicitly grants blanket permission (e.g., "auto-commit after each task"), Agent may commit autonomously.
