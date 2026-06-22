# ADR-001: Modular Monolith over Microservices

**Status:** Accepted
**Date:** 2026-06-22

## Context
We need to decide ImobFlow's architecture considering a small team (1-5 devs), MVP stage, and the need for delivery speed. The project is inspired by PlantaAI which successfully uses this same pattern.

## Decision
Adopt Spring Modulith (modular monolith) with clear boundaries between domain modules. The AI Engine remains a separate Python service communicating via RabbitMQ.

## Rationale
- A single deploy unit simplifies DevOps
- Debugging without distributed tracing
- Spring Modulith allows future extraction of modules to microservices
- Significantly lower infrastructure cost
- Proven pattern in PlantaAI project

## Consequences
- **Positive:** Simple deployment, easy debugging, fast CI/CD, lower cost
- **Negative:** Limited vertical scalability; extraction needed if modules require independent scaling
