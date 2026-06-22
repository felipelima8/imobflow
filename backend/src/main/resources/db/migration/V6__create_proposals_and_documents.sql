-- V6__create_proposals_and_documents.sql
CREATE TABLE proposals (
    id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id     UUID NOT NULL REFERENCES tenants(id),
    journey_id    UUID NOT NULL REFERENCES journeys(id),
    property_id   UUID NOT NULL REFERENCES properties(id),
    customer_id   UUID NOT NULL REFERENCES customers(id),
    offer_amount  NUMERIC(14,2) NOT NULL,
    conditions    JSONB DEFAULT '{}',
    status        VARCHAR(30) DEFAULT 'DRAFT',
    valid_until   TIMESTAMPTZ,
    created_by    UUID REFERENCES users(id),
    created_at    TIMESTAMPTZ DEFAULT now(),
    updated_at    TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX idx_proposals_tenant_id ON proposals(tenant_id);
CREATE INDEX idx_proposals_journey_id ON proposals(journey_id);

ALTER TABLE proposals ENABLE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation_proposals ON proposals
    USING (tenant_id = current_setting('app.current_tenant')::UUID);

CREATE TABLE documents (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id       UUID NOT NULL REFERENCES tenants(id),
    journey_id      UUID REFERENCES journeys(id),
    customer_id     UUID REFERENCES customers(id),
    property_id     UUID REFERENCES properties(id),
    type            VARCHAR(50) NOT NULL,
    name            VARCHAR(255) NOT NULL,
    s3_key          VARCHAR(500) NOT NULL,
    file_size_bytes BIGINT,
    mime_type       VARCHAR(100),
    status          VARCHAR(30) DEFAULT 'PENDING',
    ocr_data        JSONB,
    rejection_reason TEXT,
    uploaded_by     UUID REFERENCES users(id),
    reviewed_by     UUID REFERENCES users(id),
    reviewed_at     TIMESTAMPTZ,
    created_at      TIMESTAMPTZ DEFAULT now(),
    updated_at      TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX idx_documents_tenant_id ON documents(tenant_id);
CREATE INDEX idx_documents_journey_id ON documents(journey_id);
CREATE INDEX idx_documents_status ON documents(status);

ALTER TABLE documents ENABLE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation_documents ON documents
    USING (tenant_id = current_setting('app.current_tenant')::UUID);
