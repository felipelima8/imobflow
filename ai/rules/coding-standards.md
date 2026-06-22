# Coding Standards — ImobFlow

> All code in the repository MUST follow these rules.

## Language
- All code, comments, commits, PRs, and documentation MUST be in **English**.
- User-facing UI strings are multilingual (pt-BR primary, en-US secondary).

## Java (Backend)
- Java 21 features encouraged (records, sealed classes, pattern matching).
- Follow Google Java Style Guide.
- Use `record` for DTOs and value objects.
- Use `Optional` for nullable returns — never return `null`.
- All REST endpoints must have OpenAPI annotations.
- Minimum 80% line coverage (Jacoco).

## Python (AI Engine)
- Python 3.12+, type hints mandatory.
- Follow PEP 8 via Ruff.
- Use Pydantic for all data models.
- Use `structlog` for structured logging.
- Minimum 80% coverage (pytest-cov).

## TypeScript (Frontend)
- Strict mode enabled.
- Use functional components with hooks.
- Use server components where possible (Next.js App Router).
- Minimum 80% coverage (Vitest).

## SQL
- Table names: `snake_case`, plural (`customers`, `properties`).
- Column names: `snake_case`.
- All tables with tenant data must have `tenant_id` column + RLS policy.
- Use Flyway for migrations — never alter DB manually.

## Commits
- Follow [Conventional Commits](https://www.conventionalcommits.org/).
- Format: `type(scope): description`
- Types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`, `ci`
- Example: `feat(journey): add timeline event creation endpoint`
