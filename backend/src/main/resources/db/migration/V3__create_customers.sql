-- V3__create_customers.sql
CREATE TABLE customers (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id       UUID NOT NULL REFERENCES tenants(id),
    name            VARCHAR(255) NOT NULL,
    email           VARCHAR(255),
    phone           VARCHAR(20),
    cpf             VARCHAR(14),
    rg              VARCHAR(20),
    marital_status  VARCHAR(30),
    monthly_income  NUMERIC(12,2),
    fgts_balance    NUMERIC(12,2),
    profile         JSONB DEFAULT '{}',
    status          VARCHAR(30) DEFAULT 'LEAD',
    source          VARCHAR(50),
    assigned_broker UUID REFERENCES users(id),
    created_at      TIMESTAMPTZ DEFAULT now(),
    updated_at      TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX idx_customers_tenant_id ON customers(tenant_id);
CREATE INDEX idx_customers_status ON customers(status);
CREATE INDEX idx_customers_assigned_broker ON customers(assigned_broker);

ALTER TABLE customers ENABLE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation_customers ON customers
    USING (tenant_id = current_setting('app.current_tenant')::UUID);
