-- V5__create_journeys_and_timeline.sql
CREATE TABLE journeys (
    id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id     UUID NOT NULL REFERENCES tenants(id),
    customer_id   UUID NOT NULL REFERENCES customers(id),
    property_id   UUID REFERENCES properties(id),
    broker_id     UUID NOT NULL REFERENCES users(id),
    status        VARCHAR(30) DEFAULT 'STARTED',
    started_at    TIMESTAMPTZ DEFAULT now(),
    closed_at     TIMESTAMPTZ,
    created_at    TIMESTAMPTZ DEFAULT now(),
    updated_at    TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX idx_journeys_tenant_id ON journeys(tenant_id);
CREATE INDEX idx_journeys_customer_id ON journeys(customer_id);
CREATE INDEX idx_journeys_broker_id ON journeys(broker_id);
CREATE INDEX idx_journeys_status ON journeys(status);

ALTER TABLE journeys ENABLE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation_journeys ON journeys
    USING (tenant_id = current_setting('app.current_tenant')::UUID);

CREATE TABLE timeline_events (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id   UUID NOT NULL REFERENCES tenants(id),
    journey_id  UUID NOT NULL REFERENCES journeys(id) ON DELETE CASCADE,
    type        VARCHAR(50) NOT NULL,
    title       VARCHAR(255) NOT NULL,
    description TEXT,
    metadata    JSONB DEFAULT '{}',
    created_by  UUID REFERENCES users(id),
    created_at  TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX idx_timeline_events_journey_id ON timeline_events(journey_id);
CREATE INDEX idx_timeline_events_type ON timeline_events(type);

ALTER TABLE timeline_events ENABLE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation_timeline ON timeline_events
    USING (tenant_id = current_setting('app.current_tenant')::UUID);
