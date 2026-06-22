-- V7__create_finance_notifications_audit.sql
CREATE TABLE financing_simulations (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id       UUID NOT NULL REFERENCES tenants(id),
    customer_id     UUID NOT NULL REFERENCES customers(id),
    property_id     UUID REFERENCES properties(id),
    property_value  NUMERIC(14,2) NOT NULL,
    down_payment    NUMERIC(14,2),
    annual_rate     NUMERIC(6,4),
    months          INTEGER,
    system          VARCHAR(10) NOT NULL,
    result          JSONB NOT NULL,
    created_at      TIMESTAMPTZ DEFAULT now()
);

ALTER TABLE financing_simulations ENABLE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation_simulations ON financing_simulations
    USING (tenant_id = current_setting('app.current_tenant')::UUID);

CREATE TABLE notifications (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id   UUID NOT NULL REFERENCES tenants(id),
    user_id     UUID REFERENCES users(id),
    customer_id UUID REFERENCES customers(id),
    channel     VARCHAR(20) NOT NULL,
    type        VARCHAR(50) NOT NULL,
    title       VARCHAR(255),
    body        TEXT,
    status      VARCHAR(20) DEFAULT 'PENDING',
    sent_at     TIMESTAMPTZ,
    read_at     TIMESTAMPTZ,
    created_at  TIMESTAMPTZ DEFAULT now()
);

ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation_notifications ON notifications
    USING (tenant_id = current_setting('app.current_tenant')::UUID);

CREATE TABLE audit_logs (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id   UUID NOT NULL REFERENCES tenants(id),
    user_id     UUID REFERENCES users(id),
    action      VARCHAR(50) NOT NULL,
    entity_type VARCHAR(50) NOT NULL,
    entity_id   UUID,
    old_data    JSONB,
    new_data    JSONB,
    ip_address  VARCHAR(45),
    user_agent  TEXT,
    created_at  TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX idx_audit_logs_tenant_id ON audit_logs(tenant_id);
CREATE INDEX idx_audit_logs_entity ON audit_logs(entity_type, entity_id);
CREATE INDEX idx_audit_logs_created_at ON audit_logs(created_at);

ALTER TABLE audit_logs ENABLE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation_audit ON audit_logs
    USING (tenant_id = current_setting('app.current_tenant')::UUID);

-- Plan definitions (global, no RLS)
CREATE TABLE plan_definitions (
    id                  VARCHAR(50) PRIMARY KEY,
    name                VARCHAR(100) NOT NULL,
    stripe_price_id     VARCHAR(255),
    price_cents         INTEGER DEFAULT 0,
    currency            VARCHAR(3) DEFAULT 'BRL',
    max_customers       INTEGER DEFAULT 5,
    max_brokers         INTEGER DEFAULT 1,
    max_ai_credits      INTEGER DEFAULT 10,
    features            JSONB DEFAULT '{}',
    is_active           BOOLEAN DEFAULT true
);

INSERT INTO plan_definitions (id, name, price_cents, max_customers, max_brokers, max_ai_credits) VALUES
    ('free',         'Gratuito',      0,     5,    1,   10),
    ('starter',      'Starter',       9700,  50,   3,   100),
    ('professional', 'Professional',  29700, 200,  10,  500),
    ('enterprise',   'Enterprise',    79700, -1,   -1,  -1),
    ('white-label',  'White-Label',   149700,-1,   -1,  -1);

CREATE TABLE subscriptions (
    id                       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id                UUID NOT NULL REFERENCES tenants(id),
    stripe_subscription_id   VARCHAR(255) UNIQUE,
    stripe_customer_id       VARCHAR(255),
    plan_id                  VARCHAR(50) NOT NULL,
    status                   VARCHAR(30) DEFAULT 'active',
    current_period_start     TIMESTAMPTZ,
    current_period_end       TIMESTAMPTZ,
    created_at               TIMESTAMPTZ DEFAULT now(),
    updated_at               TIMESTAMPTZ DEFAULT now()
);

ALTER TABLE subscriptions ENABLE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation_subscriptions ON subscriptions
    USING (tenant_id = current_setting('app.current_tenant')::UUID);
