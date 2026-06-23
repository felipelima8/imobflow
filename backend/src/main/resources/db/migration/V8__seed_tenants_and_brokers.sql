-- V8__seed_tenants_and_brokers.sql
-- Seed initial tenants for the dashboard demo
INSERT INTO tenants (id, slug, name, plan_id, is_active) VALUES
    ('00000000-0000-0000-0000-000000000001', 'acme', 'Acme Real Estate', 'starter', true),
    ('00000000-0000-0000-0000-000000000002', 'imobcorp', 'ImobCorp SaaS', 'professional', true)
ON CONFLICT (id) DO NOTHING;

-- Seed initial users/brokers associated with their respective tenants
INSERT INTO users (id, tenant_id, email, name, role, is_active) VALUES
    ('00000000-0000-0000-0000-000000000009', '00000000-0000-0000-0000-000000000001', 'broker1@acme.com', 'Broker Acme', 'BROKER', true),
    ('00000000-0000-0000-0000-000000000008', '00000000-0000-0000-0000-000000000002', 'broker2@imobcorp.com', 'Broker ImobCorp', 'BROKER', true)
ON CONFLICT (id) DO NOTHING;
