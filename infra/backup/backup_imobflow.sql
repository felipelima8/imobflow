--
-- PostgreSQL database dump
--

\restrict KRscOPSgGcAwBh1DjleWOLHxQErotAd2IeK0cvy2fatzfWZ9rSiZjFmzEJ5cCQt

-- Dumped from database version 16.13
-- Dumped by pg_dump version 16.13

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: imobflow
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO imobflow;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: imobflow
--

COMMENT ON SCHEMA public IS '';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: audit_logs; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.audit_logs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    tenant_id uuid NOT NULL,
    user_id uuid,
    action character varying(50) NOT NULL,
    entity_type character varying(50) NOT NULL,
    entity_id uuid,
    old_data jsonb,
    new_data jsonb,
    ip_address character varying(45),
    user_agent text,
    created_at timestamp with time zone DEFAULT now()
);

ALTER TABLE ONLY public.audit_logs FORCE ROW LEVEL SECURITY;


ALTER TABLE public.audit_logs OWNER TO imobflow;

--
-- Name: customers; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.customers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    tenant_id uuid NOT NULL,
    name character varying(255) NOT NULL,
    email character varying(255),
    phone character varying(20),
    cpf character varying(14),
    rg character varying(20),
    marital_status character varying(30),
    monthly_income numeric(12,2),
    fgts_balance numeric(12,2),
    profile jsonb DEFAULT '{}'::jsonb,
    status character varying(30) DEFAULT 'LEAD'::character varying,
    source character varying(50),
    assigned_broker uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);

ALTER TABLE ONLY public.customers FORCE ROW LEVEL SECURITY;


ALTER TABLE public.customers OWNER TO imobflow;

--
-- Name: documents; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.documents (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    tenant_id uuid NOT NULL,
    journey_id uuid,
    customer_id uuid,
    property_id uuid,
    type character varying(50) NOT NULL,
    name character varying(255) NOT NULL,
    s3_key character varying(500) NOT NULL,
    file_size_bytes bigint,
    mime_type character varying(100),
    status character varying(30) DEFAULT 'PENDING'::character varying,
    ocr_data jsonb,
    rejection_reason text,
    uploaded_by uuid,
    reviewed_by uuid,
    reviewed_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.documents OWNER TO imobflow;

--
-- Name: financing_simulations; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.financing_simulations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    tenant_id uuid NOT NULL,
    customer_id uuid NOT NULL,
    property_id uuid,
    property_value numeric(14,2) NOT NULL,
    down_payment numeric(14,2),
    annual_rate numeric(6,4),
    months integer,
    system character varying(10) NOT NULL,
    result jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);

ALTER TABLE ONLY public.financing_simulations FORCE ROW LEVEL SECURITY;


ALTER TABLE public.financing_simulations OWNER TO imobflow;

--
-- Name: flyway_schema_history; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.flyway_schema_history (
    installed_rank integer NOT NULL,
    version character varying(50),
    description character varying(200) NOT NULL,
    type character varying(20) NOT NULL,
    script character varying(1000) NOT NULL,
    checksum integer,
    installed_by character varying(100) NOT NULL,
    installed_on timestamp without time zone DEFAULT now() NOT NULL,
    execution_time integer NOT NULL,
    success boolean NOT NULL
);


ALTER TABLE public.flyway_schema_history OWNER TO imobflow;

--
-- Name: journeys; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.journeys (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    tenant_id uuid NOT NULL,
    customer_id uuid NOT NULL,
    property_id uuid,
    broker_id uuid NOT NULL,
    status character varying(30) DEFAULT 'STARTED'::character varying,
    started_at timestamp with time zone DEFAULT now(),
    closed_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);

ALTER TABLE ONLY public.journeys FORCE ROW LEVEL SECURITY;


ALTER TABLE public.journeys OWNER TO imobflow;

--
-- Name: notifications; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.notifications (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    tenant_id uuid NOT NULL,
    user_id uuid,
    customer_id uuid,
    channel character varying(20) NOT NULL,
    type character varying(50) NOT NULL,
    title character varying(255),
    body text,
    status character varying(20) DEFAULT 'PENDING'::character varying,
    sent_at timestamp with time zone,
    read_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now()
);

ALTER TABLE ONLY public.notifications FORCE ROW LEVEL SECURITY;


ALTER TABLE public.notifications OWNER TO imobflow;

--
-- Name: plan_definitions; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.plan_definitions (
    id character varying(50) NOT NULL,
    name character varying(100) NOT NULL,
    stripe_price_id character varying(255),
    price_cents integer DEFAULT 0,
    currency character varying(3) DEFAULT 'BRL'::character varying,
    max_customers integer DEFAULT 5,
    max_brokers integer DEFAULT 1,
    max_ai_credits integer DEFAULT 10,
    features jsonb DEFAULT '{}'::jsonb,
    is_active boolean DEFAULT true
);


ALTER TABLE public.plan_definitions OWNER TO imobflow;

--
-- Name: properties; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.properties (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    tenant_id uuid NOT NULL,
    title character varying(255) NOT NULL,
    type character varying(50) NOT NULL,
    status character varying(30) DEFAULT 'AVAILABLE'::character varying,
    address_street character varying(255),
    address_number character varying(20),
    address_complement character varying(100),
    address_neighborhood character varying(100),
    address_city character varying(100),
    address_state character varying(2),
    address_zip character varying(10),
    latitude numeric(10,7),
    longitude numeric(10,7),
    area_total_m2 numeric(10,2),
    area_built_m2 numeric(10,2),
    bedrooms integer,
    bathrooms integer,
    parking_spots integer,
    price numeric(14,2),
    condo_fee numeric(10,2),
    iptu_annual numeric(10,2),
    description text,
    features jsonb DEFAULT '[]'::jsonb,
    registration_number character varying(50),
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);

ALTER TABLE ONLY public.properties FORCE ROW LEVEL SECURITY;


ALTER TABLE public.properties OWNER TO imobflow;

--
-- Name: proposals; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.proposals (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    tenant_id uuid NOT NULL,
    journey_id uuid NOT NULL,
    property_id uuid NOT NULL,
    customer_id uuid NOT NULL,
    offer_amount numeric(14,2) NOT NULL,
    conditions jsonb DEFAULT '{}'::jsonb,
    status character varying(30) DEFAULT 'DRAFT'::character varying,
    valid_until timestamp with time zone,
    created_by uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.proposals OWNER TO imobflow;

--
-- Name: subscriptions; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.subscriptions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    tenant_id uuid NOT NULL,
    stripe_subscription_id character varying(255),
    stripe_customer_id character varying(255),
    plan_id character varying(50) NOT NULL,
    status character varying(30) DEFAULT 'active'::character varying,
    current_period_start timestamp with time zone,
    current_period_end timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);

ALTER TABLE ONLY public.subscriptions FORCE ROW LEVEL SECURITY;


ALTER TABLE public.subscriptions OWNER TO imobflow;

--
-- Name: tenants; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.tenants (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    slug character varying(100) NOT NULL,
    name character varying(255) NOT NULL,
    custom_domain character varying(255),
    branding_config jsonb DEFAULT '{}'::jsonb,
    plan_id character varying(50) DEFAULT 'free'::character varying,
    email_sender character varying(255),
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.tenants OWNER TO imobflow;

--
-- Name: timeline_events; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.timeline_events (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    tenant_id uuid NOT NULL,
    journey_id uuid NOT NULL,
    type character varying(50) NOT NULL,
    title character varying(255) NOT NULL,
    description text,
    metadata jsonb DEFAULT '{}'::jsonb,
    created_by uuid,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.timeline_events OWNER TO imobflow;

--
-- Name: users; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.users (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    tenant_id uuid NOT NULL,
    keycloak_id character varying(255),
    email character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    role character varying(30) DEFAULT 'BROKER'::character varying NOT NULL,
    phone character varying(20),
    avatar_url character varying(500),
    creci character varying(20),
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);

ALTER TABLE ONLY public.users FORCE ROW LEVEL SECURITY;


ALTER TABLE public.users OWNER TO imobflow;

--
-- Data for Name: audit_logs; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.audit_logs (id, tenant_id, user_id, action, entity_type, entity_id, old_data, new_data, ip_address, user_agent, created_at) FROM stdin;
\.


--
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.customers (id, tenant_id, name, email, phone, cpf, rg, marital_status, monthly_income, fgts_balance, profile, status, source, assigned_broker, created_at, updated_at) FROM stdin;
034fb7e7-a875-4f97-ba35-acedaa8cbdb5	00000000-0000-0000-0000-000000000001	Carlos Silva	carlos@example.com			\N	\N	8500.00	20000.00	{}	LEAD	\N	\N	2026-06-22 22:38:48.44487+00	2026-06-22 22:38:48.444871+00
0987273a-4eeb-4b88-b0ef-d3c2ba60b53d	00000000-0000-0000-0000-000000000001	Mariana Souza	mariana@example.com			\N	\N	6000.00	20000.00	{}	LEAD	\N	\N	2026-06-22 22:50:07.042008+00	2026-06-22 22:50:07.042009+00
a7c12042-cbba-4aba-b152-f40595367b11	00000000-0000-0000-0000-000000000001	Carlos Silva	carlos.silva.new@example.com			\N	\N	8500.00	20000.00	{}	LEAD	\N	\N	2026-06-22 23:01:06.747091+00	2026-06-22 23:01:06.747092+00
\.


--
-- Data for Name: documents; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.documents (id, tenant_id, journey_id, customer_id, property_id, type, name, s3_key, file_size_bytes, mime_type, status, ocr_data, rejection_reason, uploaded_by, reviewed_by, reviewed_at, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: financing_simulations; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.financing_simulations (id, tenant_id, customer_id, property_id, property_value, down_payment, annual_rate, months, system, result, created_at) FROM stdin;
\.


--
-- Data for Name: flyway_schema_history; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.flyway_schema_history (installed_rank, version, description, type, script, checksum, installed_by, installed_on, execution_time, success) FROM stdin;
1	1	create tenants	SQL	V1__create_tenants.sql	-1239830744	imobflow	2026-06-22 22:37:49.38967	69	t
2	2	create users	SQL	V2__create_users.sql	12492559	imobflow	2026-06-22 22:37:49.484056	93	t
3	3	create customers	SQL	V3__create_customers.sql	776585081	imobflow	2026-06-22 22:37:49.59643	69	t
4	4	create properties	SQL	V4__create_properties.sql	-238245460	imobflow	2026-06-22 22:37:49.682707	83	t
5	5	create journeys and timeline	SQL	V5__create_journeys_and_timeline.sql	347859116	imobflow	2026-06-22 22:37:49.784108	119	t
6	6	create proposals and documents	SQL	V6__create_proposals_and_documents.sql	-320157649	imobflow	2026-06-22 22:37:49.92037	144	t
7	7	create finance notifications audit	SQL	V7__create_finance_notifications_audit.sql	252046850	imobflow	2026-06-22 22:37:50.084194	212	t
8	8	seed tenants and brokers	SQL	V8__seed_tenants_and_brokers.sql	-439187599	imobflow	2026-06-22 22:37:50.310659	3	t
9	9	force rls all tables	SQL	V9__force_rls_all_tables.sql	-985882474	imobflow	2026-06-22 22:37:50.327627	3	t
\.


--
-- Data for Name: journeys; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.journeys (id, tenant_id, customer_id, property_id, broker_id, status, started_at, closed_at, created_at, updated_at) FROM stdin;
ecda27c3-a714-40e1-afff-d9704ceb2d4e	00000000-0000-0000-0000-000000000001	034fb7e7-a875-4f97-ba35-acedaa8cbdb5	c84b3ad3-fb15-4bc0-8e62-123b0ab50c4c	00000000-0000-0000-0000-000000000009	FINANCING_APPROVED	2026-06-22 22:42:21.518478+00	\N	2026-06-22 22:42:21.519643+00	2026-06-22 22:42:54.264731+00
6062c768-2142-4b8d-a65b-04c37a044862	00000000-0000-0000-0000-000000000001	a7c12042-cbba-4aba-b152-f40595367b11	ec6883a4-2ae6-4437-8d28-a1c288f3043b	00000000-0000-0000-0000-000000000009	FINANCING_APPROVED	2026-06-22 23:07:11.233591+00	\N	2026-06-22 23:07:11.234306+00	2026-06-22 23:08:20.472287+00
\.


--
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.notifications (id, tenant_id, user_id, customer_id, channel, type, title, body, status, sent_at, read_at, created_at) FROM stdin;
\.


--
-- Data for Name: plan_definitions; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.plan_definitions (id, name, stripe_price_id, price_cents, currency, max_customers, max_brokers, max_ai_credits, features, is_active) FROM stdin;
free	Gratuito	\N	0	BRL	5	1	10	{}	t
starter	Starter	\N	9700	BRL	50	3	100	{}	t
professional	Professional	\N	29700	BRL	200	10	500	{}	t
enterprise	Enterprise	\N	79700	BRL	-1	-1	-1	{}	t
white-label	White-Label	\N	149700	BRL	-1	-1	-1	{}	t
\.


--
-- Data for Name: properties; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.properties (id, tenant_id, title, type, status, address_street, address_number, address_complement, address_neighborhood, address_city, address_state, address_zip, latitude, longitude, area_total_m2, area_built_m2, bedrooms, bathrooms, parking_spots, price, condo_fee, iptu_annual, description, features, registration_number, created_at, updated_at) FROM stdin;
c84b3ad3-fb15-4bc0-8e62-123b0ab50c4c	00000000-0000-0000-0000-000000000001	Apartamento Jardins	APARTMENT	AVAILABLE	\N	\N	\N	\N	São Paulo	\N	\N	\N	\N	\N	\N	2	\N	\N	650000.00	\N	\N	\N	[]	\N	2026-06-22 22:39:53.38453+00	2026-06-22 22:39:53.38453+00
ec6883a4-2ae6-4437-8d28-a1c288f3043b	00000000-0000-0000-0000-000000000001	Apartamento Jardins	APARTMENT	AVAILABLE	\N	\N	\N	\N	São Paulo	\N	\N	\N	\N	\N	\N	2	\N	\N	650000.00	\N	\N	\N	[]	\N	2026-06-22 23:03:12.923502+00	2026-06-22 23:03:12.923503+00
\.


--
-- Data for Name: proposals; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.proposals (id, tenant_id, journey_id, property_id, customer_id, offer_amount, conditions, status, valid_until, created_by, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: subscriptions; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.subscriptions (id, tenant_id, stripe_subscription_id, stripe_customer_id, plan_id, status, current_period_start, current_period_end, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: tenants; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.tenants (id, slug, name, custom_domain, branding_config, plan_id, email_sender, is_active, created_at, updated_at) FROM stdin;
00000000-0000-0000-0000-000000000001	acme	Acme Real Estate	\N	{}	starter	\N	t	2026-06-22 22:37:50.312944+00	2026-06-22 22:37:50.312944+00
00000000-0000-0000-0000-000000000002	imobcorp	ImobCorp SaaS	\N	{}	professional	\N	t	2026-06-22 22:37:50.312944+00	2026-06-22 22:37:50.312944+00
\.


--
-- Data for Name: timeline_events; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.timeline_events (id, tenant_id, journey_id, type, title, description, metadata, created_by, created_at) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.users (id, tenant_id, keycloak_id, email, name, role, phone, avatar_url, creci, is_active, created_at, updated_at) FROM stdin;
00000000-0000-0000-0000-000000000009	00000000-0000-0000-0000-000000000001	\N	broker1@acme.com	Broker Acme	BROKER	\N	\N	\N	t	2026-06-22 22:37:50.312944+00	2026-06-22 22:37:50.312944+00
00000000-0000-0000-0000-000000000008	00000000-0000-0000-0000-000000000002	\N	broker2@imobcorp.com	Broker ImobCorp	BROKER	\N	\N	\N	t	2026-06-22 22:37:50.312944+00	2026-06-22 22:37:50.312944+00
\.


--
-- Name: audit_logs audit_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_pkey PRIMARY KEY (id);


--
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (id);


--
-- Name: documents documents_pkey; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.documents
    ADD CONSTRAINT documents_pkey PRIMARY KEY (id);


--
-- Name: financing_simulations financing_simulations_pkey; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.financing_simulations
    ADD CONSTRAINT financing_simulations_pkey PRIMARY KEY (id);


--
-- Name: flyway_schema_history flyway_schema_history_pk; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.flyway_schema_history
    ADD CONSTRAINT flyway_schema_history_pk PRIMARY KEY (installed_rank);


--
-- Name: journeys journeys_pkey; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.journeys
    ADD CONSTRAINT journeys_pkey PRIMARY KEY (id);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: plan_definitions plan_definitions_pkey; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.plan_definitions
    ADD CONSTRAINT plan_definitions_pkey PRIMARY KEY (id);


--
-- Name: properties properties_pkey; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.properties
    ADD CONSTRAINT properties_pkey PRIMARY KEY (id);


--
-- Name: proposals proposals_pkey; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.proposals
    ADD CONSTRAINT proposals_pkey PRIMARY KEY (id);


--
-- Name: subscriptions subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_pkey PRIMARY KEY (id);


--
-- Name: subscriptions subscriptions_stripe_subscription_id_key; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_stripe_subscription_id_key UNIQUE (stripe_subscription_id);


--
-- Name: tenants tenants_pkey; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.tenants
    ADD CONSTRAINT tenants_pkey PRIMARY KEY (id);


--
-- Name: tenants tenants_slug_key; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.tenants
    ADD CONSTRAINT tenants_slug_key UNIQUE (slug);


--
-- Name: timeline_events timeline_events_pkey; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.timeline_events
    ADD CONSTRAINT timeline_events_pkey PRIMARY KEY (id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_keycloak_id_key; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_keycloak_id_key UNIQUE (keycloak_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: flyway_schema_history_s_idx; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX flyway_schema_history_s_idx ON public.flyway_schema_history USING btree (success);


--
-- Name: idx_audit_logs_created_at; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_audit_logs_created_at ON public.audit_logs USING btree (created_at);


--
-- Name: idx_audit_logs_entity; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_audit_logs_entity ON public.audit_logs USING btree (entity_type, entity_id);


--
-- Name: idx_audit_logs_tenant_id; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_audit_logs_tenant_id ON public.audit_logs USING btree (tenant_id);


--
-- Name: idx_customers_assigned_broker; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_customers_assigned_broker ON public.customers USING btree (assigned_broker);


--
-- Name: idx_customers_status; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_customers_status ON public.customers USING btree (status);


--
-- Name: idx_customers_tenant_id; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_customers_tenant_id ON public.customers USING btree (tenant_id);


--
-- Name: idx_documents_journey_id; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_documents_journey_id ON public.documents USING btree (journey_id);


--
-- Name: idx_documents_status; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_documents_status ON public.documents USING btree (status);


--
-- Name: idx_documents_tenant_id; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_documents_tenant_id ON public.documents USING btree (tenant_id);


--
-- Name: idx_journeys_broker_id; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_journeys_broker_id ON public.journeys USING btree (broker_id);


--
-- Name: idx_journeys_customer_id; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_journeys_customer_id ON public.journeys USING btree (customer_id);


--
-- Name: idx_journeys_status; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_journeys_status ON public.journeys USING btree (status);


--
-- Name: idx_journeys_tenant_id; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_journeys_tenant_id ON public.journeys USING btree (tenant_id);


--
-- Name: idx_properties_price; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_properties_price ON public.properties USING btree (price);


--
-- Name: idx_properties_status; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_properties_status ON public.properties USING btree (status);


--
-- Name: idx_properties_tenant_id; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_properties_tenant_id ON public.properties USING btree (tenant_id);


--
-- Name: idx_properties_type; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_properties_type ON public.properties USING btree (type);


--
-- Name: idx_proposals_journey_id; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_proposals_journey_id ON public.proposals USING btree (journey_id);


--
-- Name: idx_proposals_tenant_id; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_proposals_tenant_id ON public.proposals USING btree (tenant_id);


--
-- Name: idx_tenants_custom_domain; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_tenants_custom_domain ON public.tenants USING btree (custom_domain);


--
-- Name: idx_tenants_slug; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE UNIQUE INDEX idx_tenants_slug ON public.tenants USING btree (slug);


--
-- Name: idx_timeline_events_journey_id; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_timeline_events_journey_id ON public.timeline_events USING btree (journey_id);


--
-- Name: idx_timeline_events_type; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_timeline_events_type ON public.timeline_events USING btree (type);


--
-- Name: idx_users_email; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE UNIQUE INDEX idx_users_email ON public.users USING btree (email);


--
-- Name: idx_users_keycloak_id; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE UNIQUE INDEX idx_users_keycloak_id ON public.users USING btree (keycloak_id);


--
-- Name: idx_users_tenant_id; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_users_tenant_id ON public.users USING btree (tenant_id);


--
-- Name: audit_logs audit_logs_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id);


--
-- Name: audit_logs audit_logs_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: customers customers_assigned_broker_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_assigned_broker_fkey FOREIGN KEY (assigned_broker) REFERENCES public.users(id);


--
-- Name: customers customers_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id);


--
-- Name: documents documents_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.documents
    ADD CONSTRAINT documents_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(id);


--
-- Name: documents documents_journey_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.documents
    ADD CONSTRAINT documents_journey_id_fkey FOREIGN KEY (journey_id) REFERENCES public.journeys(id);


--
-- Name: documents documents_property_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.documents
    ADD CONSTRAINT documents_property_id_fkey FOREIGN KEY (property_id) REFERENCES public.properties(id);


--
-- Name: documents documents_reviewed_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.documents
    ADD CONSTRAINT documents_reviewed_by_fkey FOREIGN KEY (reviewed_by) REFERENCES public.users(id);


--
-- Name: documents documents_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.documents
    ADD CONSTRAINT documents_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id);


--
-- Name: documents documents_uploaded_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.documents
    ADD CONSTRAINT documents_uploaded_by_fkey FOREIGN KEY (uploaded_by) REFERENCES public.users(id);


--
-- Name: financing_simulations financing_simulations_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.financing_simulations
    ADD CONSTRAINT financing_simulations_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(id);


--
-- Name: financing_simulations financing_simulations_property_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.financing_simulations
    ADD CONSTRAINT financing_simulations_property_id_fkey FOREIGN KEY (property_id) REFERENCES public.properties(id);


--
-- Name: financing_simulations financing_simulations_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.financing_simulations
    ADD CONSTRAINT financing_simulations_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id);


--
-- Name: journeys journeys_broker_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.journeys
    ADD CONSTRAINT journeys_broker_id_fkey FOREIGN KEY (broker_id) REFERENCES public.users(id);


--
-- Name: journeys journeys_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.journeys
    ADD CONSTRAINT journeys_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(id);


--
-- Name: journeys journeys_property_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.journeys
    ADD CONSTRAINT journeys_property_id_fkey FOREIGN KEY (property_id) REFERENCES public.properties(id);


--
-- Name: journeys journeys_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.journeys
    ADD CONSTRAINT journeys_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id);


--
-- Name: notifications notifications_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(id);


--
-- Name: notifications notifications_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id);


--
-- Name: notifications notifications_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: properties properties_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.properties
    ADD CONSTRAINT properties_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id);


--
-- Name: proposals proposals_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.proposals
    ADD CONSTRAINT proposals_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: proposals proposals_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.proposals
    ADD CONSTRAINT proposals_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(id);


--
-- Name: proposals proposals_journey_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.proposals
    ADD CONSTRAINT proposals_journey_id_fkey FOREIGN KEY (journey_id) REFERENCES public.journeys(id);


--
-- Name: proposals proposals_property_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.proposals
    ADD CONSTRAINT proposals_property_id_fkey FOREIGN KEY (property_id) REFERENCES public.properties(id);


--
-- Name: proposals proposals_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.proposals
    ADD CONSTRAINT proposals_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id);


--
-- Name: subscriptions subscriptions_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id);


--
-- Name: timeline_events timeline_events_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.timeline_events
    ADD CONSTRAINT timeline_events_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: timeline_events timeline_events_journey_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.timeline_events
    ADD CONSTRAINT timeline_events_journey_id_fkey FOREIGN KEY (journey_id) REFERENCES public.journeys(id) ON DELETE CASCADE;


--
-- Name: timeline_events timeline_events_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.timeline_events
    ADD CONSTRAINT timeline_events_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id);


--
-- Name: users users_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id);


--
-- Name: audit_logs; Type: ROW SECURITY; Schema: public; Owner: imobflow
--

ALTER TABLE public.audit_logs ENABLE ROW LEVEL SECURITY;

--
-- Name: customers; Type: ROW SECURITY; Schema: public; Owner: imobflow
--

ALTER TABLE public.customers ENABLE ROW LEVEL SECURITY;

--
-- Name: documents; Type: ROW SECURITY; Schema: public; Owner: imobflow
--

ALTER TABLE public.documents ENABLE ROW LEVEL SECURITY;

--
-- Name: financing_simulations; Type: ROW SECURITY; Schema: public; Owner: imobflow
--

ALTER TABLE public.financing_simulations ENABLE ROW LEVEL SECURITY;

--
-- Name: journeys; Type: ROW SECURITY; Schema: public; Owner: imobflow
--

ALTER TABLE public.journeys ENABLE ROW LEVEL SECURITY;

--
-- Name: notifications; Type: ROW SECURITY; Schema: public; Owner: imobflow
--

ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;

--
-- Name: properties; Type: ROW SECURITY; Schema: public; Owner: imobflow
--

ALTER TABLE public.properties ENABLE ROW LEVEL SECURITY;

--
-- Name: proposals; Type: ROW SECURITY; Schema: public; Owner: imobflow
--

ALTER TABLE public.proposals ENABLE ROW LEVEL SECURITY;

--
-- Name: subscriptions; Type: ROW SECURITY; Schema: public; Owner: imobflow
--

ALTER TABLE public.subscriptions ENABLE ROW LEVEL SECURITY;

--
-- Name: audit_logs tenant_isolation_audit; Type: POLICY; Schema: public; Owner: imobflow
--

CREATE POLICY tenant_isolation_audit ON public.audit_logs USING ((tenant_id = (current_setting('app.current_tenant'::text))::uuid));


--
-- Name: customers tenant_isolation_customers; Type: POLICY; Schema: public; Owner: imobflow
--

CREATE POLICY tenant_isolation_customers ON public.customers USING ((tenant_id = (current_setting('app.current_tenant'::text))::uuid));


--
-- Name: documents tenant_isolation_documents; Type: POLICY; Schema: public; Owner: imobflow
--

CREATE POLICY tenant_isolation_documents ON public.documents USING ((tenant_id = (current_setting('app.current_tenant'::text))::uuid));


--
-- Name: journeys tenant_isolation_journeys; Type: POLICY; Schema: public; Owner: imobflow
--

CREATE POLICY tenant_isolation_journeys ON public.journeys USING ((tenant_id = (current_setting('app.current_tenant'::text))::uuid));


--
-- Name: notifications tenant_isolation_notifications; Type: POLICY; Schema: public; Owner: imobflow
--

CREATE POLICY tenant_isolation_notifications ON public.notifications USING ((tenant_id = (current_setting('app.current_tenant'::text))::uuid));


--
-- Name: properties tenant_isolation_properties; Type: POLICY; Schema: public; Owner: imobflow
--

CREATE POLICY tenant_isolation_properties ON public.properties USING ((tenant_id = (current_setting('app.current_tenant'::text))::uuid));


--
-- Name: proposals tenant_isolation_proposals; Type: POLICY; Schema: public; Owner: imobflow
--

CREATE POLICY tenant_isolation_proposals ON public.proposals USING ((tenant_id = (current_setting('app.current_tenant'::text))::uuid));


--
-- Name: financing_simulations tenant_isolation_simulations; Type: POLICY; Schema: public; Owner: imobflow
--

CREATE POLICY tenant_isolation_simulations ON public.financing_simulations USING ((tenant_id = (current_setting('app.current_tenant'::text))::uuid));


--
-- Name: subscriptions tenant_isolation_subscriptions; Type: POLICY; Schema: public; Owner: imobflow
--

CREATE POLICY tenant_isolation_subscriptions ON public.subscriptions USING ((tenant_id = (current_setting('app.current_tenant'::text))::uuid));


--
-- Name: timeline_events tenant_isolation_timeline; Type: POLICY; Schema: public; Owner: imobflow
--

CREATE POLICY tenant_isolation_timeline ON public.timeline_events USING ((tenant_id = (current_setting('app.current_tenant'::text))::uuid));


--
-- Name: users tenant_isolation_users; Type: POLICY; Schema: public; Owner: imobflow
--

CREATE POLICY tenant_isolation_users ON public.users USING ((tenant_id = (current_setting('app.current_tenant'::text))::uuid));


--
-- Name: timeline_events; Type: ROW SECURITY; Schema: public; Owner: imobflow
--

ALTER TABLE public.timeline_events ENABLE ROW LEVEL SECURITY;

--
-- Name: users; Type: ROW SECURITY; Schema: public; Owner: imobflow
--

ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: imobflow
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;


--
-- PostgreSQL database dump complete
--

\unrestrict KRscOPSgGcAwBh1DjleWOLHxQErotAd2IeK0cvy2fatzfWZ9rSiZjFmzEJ5cCQt

