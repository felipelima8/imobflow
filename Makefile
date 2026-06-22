.PHONY: up down status backend frontend ai-engine test lint clean

# ===========================
# Docker Compose
# ===========================

up:
	docker compose -f infra/docker-compose.dev.yml up -d
	@echo "✅ All services started. Run 'make status' to check."

down:
	docker compose -f infra/docker-compose.dev.yml down

down-clean:
	docker compose -f infra/docker-compose.dev.yml down -v --remove-orphans

status:
	docker compose -f infra/docker-compose.dev.yml ps

logs:
	docker compose -f infra/docker-compose.dev.yml logs -f

logs-backend:
	docker compose -f infra/docker-compose.dev.yml logs -f backend

logs-ai:
	docker compose -f infra/docker-compose.dev.yml logs -f ai-engine

# ===========================
# Development
# ===========================

backend:
	cd backend && ./mvnw spring-boot:run -Dspring-boot.run.profiles=dev

frontend:
	cd frontend && npm run dev

ai-engine:
	cd ai-engine && poetry run uvicorn src.main:app --reload --port 8000

# ===========================
# Testing
# ===========================

test: test-backend test-ai test-frontend

test-backend:
	cd backend && ./mvnw clean test jacoco:report jacoco:check

test-ai:
	cd ai-engine && poetry run pytest --cov=src --cov-report=term-missing

test-frontend:
	cd frontend && npm test -- --coverage --run

# ===========================
# Linting
# ===========================

lint: lint-backend lint-ai lint-frontend

lint-backend:
	cd backend && ./mvnw checkstyle:check

lint-ai:
	cd ai-engine && poetry run ruff check src/ tests/

lint-frontend:
	cd frontend && npm run lint

# ===========================
# Build
# ===========================

build-backend:
	cd backend && ./mvnw clean package -DskipTests

build-ai:
	cd ai-engine && docker build -t imobflow-ai-engine .

build-frontend:
	cd frontend && npm run build

build-all: build-backend build-ai build-frontend

# ===========================
# Database
# ===========================

db-migrate:
	cd backend && ./mvnw flyway:migrate

db-reset:
	cd backend && ./mvnw flyway:clean flyway:migrate

# ===========================
# Cleanup
# ===========================

clean:
	cd backend && ./mvnw clean
	cd ai-engine && rm -rf __pycache__ .ruff_cache .mypy_cache
	cd frontend && rm -rf .next node_modules/.cache
