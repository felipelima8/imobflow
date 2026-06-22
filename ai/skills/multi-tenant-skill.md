# Multi-Tenant Skill — ImobFlow

> How to properly implement multi-tenant data isolation.

## Rules

1. **Every tenant-scoped entity** MUST extend `BaseEntity` which includes `tenantId` and the Hibernate `@Filter`.
2. **Every new table** with tenant data MUST have:
   - `tenant_id UUID NOT NULL REFERENCES tenants(id)` column
   - Index on `tenant_id`
   - RLS policy: `tenant_id = current_setting('app.current_tenant')::UUID`
3. **TenantContext** (ThreadLocal) is set by `TenantFilter` at the servlet level.
4. **TenantInterceptor** (AOP) enables Hibernate filter + sets PostgreSQL session variable before every repository call.
5. **Global tables** (`tenants`, `plan_definitions`) do NOT have RLS.
6. **Never bypass** the tenant filter. If you need cross-tenant access, use a dedicated admin service with explicit tenant switching.
7. **Tests** must set `TenantContext.setCurrentTenantId(testTenantId)` in `@BeforeEach`.

## Tenant Resolution Priority

1. `X-Tenant-ID` header (dev/API)
2. Subdomain extraction (`acme.imobflow.com.br` → `acme`)
3. Custom domain lookup (`imobacme.com.br` → tenant with that domain)
