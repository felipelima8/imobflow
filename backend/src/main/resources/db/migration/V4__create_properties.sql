-- V4__create_properties.sql
CREATE TABLE properties (
    id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id             UUID NOT NULL REFERENCES tenants(id),
    title                 VARCHAR(255) NOT NULL,
    type                  VARCHAR(50) NOT NULL,
    status                VARCHAR(30) DEFAULT 'AVAILABLE',
    address_street        VARCHAR(255),
    address_number        VARCHAR(20),
    address_complement    VARCHAR(100),
    address_neighborhood  VARCHAR(100),
    address_city          VARCHAR(100),
    address_state         VARCHAR(2),
    address_zip           VARCHAR(10),
    latitude              NUMERIC(10,7),
    longitude             NUMERIC(10,7),
    area_total_m2         NUMERIC(10,2),
    area_built_m2         NUMERIC(10,2),
    bedrooms              INTEGER,
    bathrooms             INTEGER,
    parking_spots         INTEGER,
    price                 NUMERIC(14,2),
    condo_fee             NUMERIC(10,2),
    iptu_annual           NUMERIC(10,2),
    description           TEXT,
    features              JSONB DEFAULT '[]',
    registration_number   VARCHAR(50),
    created_at            TIMESTAMPTZ DEFAULT now(),
    updated_at            TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX idx_properties_tenant_id ON properties(tenant_id);
CREATE INDEX idx_properties_type ON properties(type);
CREATE INDEX idx_properties_status ON properties(status);
CREATE INDEX idx_properties_price ON properties(price);

ALTER TABLE properties ENABLE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation_properties ON properties
    USING (tenant_id = current_setting('app.current_tenant')::UUID);
