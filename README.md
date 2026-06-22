# 🏢 ImobFlow

> SaaS Open-Source para Gestão Inteligente do Mercado Imobiliário

[![CI](https://github.com/imobflow/imobflow/actions/workflows/ci.yml/badge.svg)](https://github.com/imobflow/imobflow/actions/workflows/ci.yml)
[![License: AGPL-3.0](https://img.shields.io/badge/License-AGPL--3.0-blue.svg)](LICENSE)

## 🚀 Overview

ImobFlow é uma plataforma SaaS que inverte o paradigma dos CRMs imobiliários tradicionais: em vez de focar apenas no controle interno da imobiliária, ela **coloca o comprador no centro da experiência**, oferecendo um painel de acompanhamento em tempo real da jornada de compra — enquanto o corretor ganha ferramentas de IA para automatizar tarefas operacionais.

### Key Differentiators

- 🏠 **Client-Facing Portal** — Comprador acompanha sua jornada em tempo real
- 🤖 **AI-Powered** — Match inteligente, OCR de documentos, chatbot, análise de risco
- 🏷️ **White-label** — Imobiliárias usam com sua própria marca
- 📱 **Multi-platform** — Web + Mobile (React Native)
- 🔒 **Multi-tenant** — Isolamento por RLS (Row-Level Security)
- 💰 **SaaS Ready** — Planos, billing, feature flags desde o dia 1
- 🌍 **Open Source** — AGPL-3.0, comunidade ativa

## 🏗️ Technology Stack

| Layer | Technology |
|---|---|
| **Backend** | Java 21 + Spring Boot 3.3 + Spring Modulith |
| **AI Engine** | Python 3.12 + FastAPI |
| **Frontend Web** | Next.js 15 (React 19) |
| **Mobile** | React Native (Expo) |
| **Database** | PostgreSQL 16 + RLS (Row Level Security) |
| **Cache** | Redis 7 |
| **Queue** | RabbitMQ 3.13 |
| **Auth** | Keycloak (OIDC) |
| **Billing** | Stripe |
| **Feature Flags** | Unleash |
| **Storage** | S3 / MinIO |
| **Search** | OpenSearch |
| **Observability** | Sentry + Prometheus + Grafana |
| **Quality** | SonarQube + Jacoco (80%) + Vitest (80%) |

## 📁 Project Structure

```
imobflow/
├── backend/          # Java Spring Boot API (modular monolith)
├── ai-engine/        # Python FastAPI (AI: match, OCR, chatbot)
├── frontend/         # Next.js 15 Web App
├── mobile/           # React Native (Expo) App
├── infra/            # Docker, Terraform, Nginx
├── ai/               # AI governance (agents, rules, skills)
├── docs/             # Technical and functional documentation
└── .github/          # CI/CD workflows
```

## ⚡ Quick Start

### Prerequisites

- Docker & Docker Compose v2+
- Java 21+ (for backend dev)
- Node.js 20+ (for frontend dev)
- Python 3.12+ (for AI engine dev)

### Run with Docker (recommended)

```bash
cp .env.example .env
make up
make status
```

### Individual Development

```bash
make backend      # Runs backend in dev mode
make frontend     # Runs frontend in dev mode
make ai-engine    # Runs AI engine in dev mode
make test         # Runs all tests
make lint         # Runs linters
```

### Local URLs & Credentials

| Service | URL | Credentials |
|---|---|---|
| Frontend | http://localhost:3000 | — |
| Backend API | http://localhost:8080 | — |
| Swagger UI | http://localhost:8080/swagger-ui.html | — |
| Keycloak | http://localhost:8180 | `admin` / `admin` |
| RabbitMQ | http://localhost:15672 | `imobflow` / `imobflow_dev_2026` |
| MinIO Console | http://localhost:9001 | `minioadmin` / `minioadmin` |

## 📖 Documentation

- [Architecture](docs/architecture.md)
- [Database Schema](docs/technical/database-schema.md)
- [API Reference](docs/api/rest-endpoints.md)
- [ADRs](docs/adr/)
- [Business Rules](docs/functional/business-rules.md)

## 🤝 Contributing

1. Read `ai/rules/coding-standards.md`
2. Create a branch: `feature/my-feature`
3. Make commits following [Conventional Commits](https://www.conventionalcommits.org/)
4. Open a PR to `develop`

## 📝 License

AGPL-3.0 License — see [LICENSE](LICENSE) for details.
