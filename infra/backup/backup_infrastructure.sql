--
-- PostgreSQL database dump
--

\restrict VnufiKQbpBNyz7h66FIVhzIGW6DMbMa8d6aQuUBXO7pzLiBBRiRA93BwnD8jDh8

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
-- Name: admin_event_entity; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.admin_event_entity (
    id character varying(36) NOT NULL,
    admin_event_time bigint,
    realm_id character varying(255),
    operation_type character varying(255),
    auth_realm_id character varying(255),
    auth_client_id character varying(255),
    auth_user_id character varying(255),
    ip_address character varying(255),
    resource_path character varying(2550),
    representation text,
    error character varying(255),
    resource_type character varying(64)
);


ALTER TABLE public.admin_event_entity OWNER TO imobflow;

--
-- Name: associated_policy; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.associated_policy (
    policy_id character varying(36) NOT NULL,
    associated_policy_id character varying(36) NOT NULL
);


ALTER TABLE public.associated_policy OWNER TO imobflow;

--
-- Name: authentication_execution; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.authentication_execution (
    id character varying(36) NOT NULL,
    alias character varying(255),
    authenticator character varying(36),
    realm_id character varying(36),
    flow_id character varying(36),
    requirement integer,
    priority integer,
    authenticator_flow boolean DEFAULT false NOT NULL,
    auth_flow_id character varying(36),
    auth_config character varying(36)
);


ALTER TABLE public.authentication_execution OWNER TO imobflow;

--
-- Name: authentication_flow; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.authentication_flow (
    id character varying(36) NOT NULL,
    alias character varying(255),
    description character varying(255),
    realm_id character varying(36),
    provider_id character varying(36) DEFAULT 'basic-flow'::character varying NOT NULL,
    top_level boolean DEFAULT false NOT NULL,
    built_in boolean DEFAULT false NOT NULL
);


ALTER TABLE public.authentication_flow OWNER TO imobflow;

--
-- Name: authenticator_config; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.authenticator_config (
    id character varying(36) NOT NULL,
    alias character varying(255),
    realm_id character varying(36)
);


ALTER TABLE public.authenticator_config OWNER TO imobflow;

--
-- Name: authenticator_config_entry; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.authenticator_config_entry (
    authenticator_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.authenticator_config_entry OWNER TO imobflow;

--
-- Name: broker_link; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.broker_link (
    identity_provider character varying(255) NOT NULL,
    storage_provider_id character varying(255),
    realm_id character varying(36) NOT NULL,
    broker_user_id character varying(255),
    broker_username character varying(255),
    token text,
    user_id character varying(255) NOT NULL
);


ALTER TABLE public.broker_link OWNER TO imobflow;

--
-- Name: client; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.client (
    id character varying(36) NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    full_scope_allowed boolean DEFAULT false NOT NULL,
    client_id character varying(255),
    not_before integer,
    public_client boolean DEFAULT false NOT NULL,
    secret character varying(255),
    base_url character varying(255),
    bearer_only boolean DEFAULT false NOT NULL,
    management_url character varying(255),
    surrogate_auth_required boolean DEFAULT false NOT NULL,
    realm_id character varying(36),
    protocol character varying(255),
    node_rereg_timeout integer DEFAULT 0,
    frontchannel_logout boolean DEFAULT false NOT NULL,
    consent_required boolean DEFAULT false NOT NULL,
    name character varying(255),
    service_accounts_enabled boolean DEFAULT false NOT NULL,
    client_authenticator_type character varying(255),
    root_url character varying(255),
    description character varying(255),
    registration_token character varying(255),
    standard_flow_enabled boolean DEFAULT true NOT NULL,
    implicit_flow_enabled boolean DEFAULT false NOT NULL,
    direct_access_grants_enabled boolean DEFAULT false NOT NULL,
    always_display_in_console boolean DEFAULT false NOT NULL
);


ALTER TABLE public.client OWNER TO imobflow;

--
-- Name: client_attributes; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.client_attributes (
    client_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value text
);


ALTER TABLE public.client_attributes OWNER TO imobflow;

--
-- Name: client_auth_flow_bindings; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.client_auth_flow_bindings (
    client_id character varying(36) NOT NULL,
    flow_id character varying(36),
    binding_name character varying(255) NOT NULL
);


ALTER TABLE public.client_auth_flow_bindings OWNER TO imobflow;

--
-- Name: client_initial_access; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.client_initial_access (
    id character varying(36) NOT NULL,
    realm_id character varying(36) NOT NULL,
    "timestamp" integer,
    expiration integer,
    count integer,
    remaining_count integer
);


ALTER TABLE public.client_initial_access OWNER TO imobflow;

--
-- Name: client_node_registrations; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.client_node_registrations (
    client_id character varying(36) NOT NULL,
    value integer,
    name character varying(255) NOT NULL
);


ALTER TABLE public.client_node_registrations OWNER TO imobflow;

--
-- Name: client_scope; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.client_scope (
    id character varying(36) NOT NULL,
    name character varying(255),
    realm_id character varying(36),
    description character varying(255),
    protocol character varying(255)
);


ALTER TABLE public.client_scope OWNER TO imobflow;

--
-- Name: client_scope_attributes; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.client_scope_attributes (
    scope_id character varying(36) NOT NULL,
    value character varying(2048),
    name character varying(255) NOT NULL
);


ALTER TABLE public.client_scope_attributes OWNER TO imobflow;

--
-- Name: client_scope_client; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.client_scope_client (
    client_id character varying(255) NOT NULL,
    scope_id character varying(255) NOT NULL,
    default_scope boolean DEFAULT false NOT NULL
);


ALTER TABLE public.client_scope_client OWNER TO imobflow;

--
-- Name: client_scope_role_mapping; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.client_scope_role_mapping (
    scope_id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL
);


ALTER TABLE public.client_scope_role_mapping OWNER TO imobflow;

--
-- Name: client_session; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.client_session (
    id character varying(36) NOT NULL,
    client_id character varying(36),
    redirect_uri character varying(255),
    state character varying(255),
    "timestamp" integer,
    session_id character varying(36),
    auth_method character varying(255),
    realm_id character varying(255),
    auth_user_id character varying(36),
    current_action character varying(36)
);


ALTER TABLE public.client_session OWNER TO imobflow;

--
-- Name: client_session_auth_status; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.client_session_auth_status (
    authenticator character varying(36) NOT NULL,
    status integer,
    client_session character varying(36) NOT NULL
);


ALTER TABLE public.client_session_auth_status OWNER TO imobflow;

--
-- Name: client_session_note; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.client_session_note (
    name character varying(255) NOT NULL,
    value character varying(255),
    client_session character varying(36) NOT NULL
);


ALTER TABLE public.client_session_note OWNER TO imobflow;

--
-- Name: client_session_prot_mapper; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.client_session_prot_mapper (
    protocol_mapper_id character varying(36) NOT NULL,
    client_session character varying(36) NOT NULL
);


ALTER TABLE public.client_session_prot_mapper OWNER TO imobflow;

--
-- Name: client_session_role; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.client_session_role (
    role_id character varying(255) NOT NULL,
    client_session character varying(36) NOT NULL
);


ALTER TABLE public.client_session_role OWNER TO imobflow;

--
-- Name: client_user_session_note; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.client_user_session_note (
    name character varying(255) NOT NULL,
    value character varying(2048),
    client_session character varying(36) NOT NULL
);


ALTER TABLE public.client_user_session_note OWNER TO imobflow;

--
-- Name: component; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.component (
    id character varying(36) NOT NULL,
    name character varying(255),
    parent_id character varying(36),
    provider_id character varying(36),
    provider_type character varying(255),
    realm_id character varying(36),
    sub_type character varying(255)
);


ALTER TABLE public.component OWNER TO imobflow;

--
-- Name: component_config; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.component_config (
    id character varying(36) NOT NULL,
    component_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value text
);


ALTER TABLE public.component_config OWNER TO imobflow;

--
-- Name: composite_role; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.composite_role (
    composite character varying(36) NOT NULL,
    child_role character varying(36) NOT NULL
);


ALTER TABLE public.composite_role OWNER TO imobflow;

--
-- Name: credential; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.credential (
    id character varying(36) NOT NULL,
    salt bytea,
    type character varying(255),
    user_id character varying(36),
    created_date bigint,
    user_label character varying(255),
    secret_data text,
    credential_data text,
    priority integer
);


ALTER TABLE public.credential OWNER TO imobflow;

--
-- Name: databasechangelog; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.databasechangelog (
    id character varying(255) NOT NULL,
    author character varying(255) NOT NULL,
    filename character varying(255) NOT NULL,
    dateexecuted timestamp without time zone NOT NULL,
    orderexecuted integer NOT NULL,
    exectype character varying(10) NOT NULL,
    md5sum character varying(35),
    description character varying(255),
    comments character varying(255),
    tag character varying(255),
    liquibase character varying(20),
    contexts character varying(255),
    labels character varying(255),
    deployment_id character varying(10)
);


ALTER TABLE public.databasechangelog OWNER TO imobflow;

--
-- Name: databasechangeloglock; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.databasechangeloglock (
    id integer NOT NULL,
    locked boolean NOT NULL,
    lockgranted timestamp without time zone,
    lockedby character varying(255)
);


ALTER TABLE public.databasechangeloglock OWNER TO imobflow;

--
-- Name: default_client_scope; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.default_client_scope (
    realm_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL,
    default_scope boolean DEFAULT false NOT NULL
);


ALTER TABLE public.default_client_scope OWNER TO imobflow;

--
-- Name: event_entity; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.event_entity (
    id character varying(36) NOT NULL,
    client_id character varying(255),
    details_json character varying(2550),
    error character varying(255),
    ip_address character varying(255),
    realm_id character varying(255),
    session_id character varying(255),
    event_time bigint,
    type character varying(255),
    user_id character varying(255),
    details_json_long_value text
);


ALTER TABLE public.event_entity OWNER TO imobflow;

--
-- Name: fed_user_attribute; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.fed_user_attribute (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36),
    value character varying(2024),
    long_value_hash bytea,
    long_value_hash_lower_case bytea,
    long_value text
);


ALTER TABLE public.fed_user_attribute OWNER TO imobflow;

--
-- Name: fed_user_consent; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.fed_user_consent (
    id character varying(36) NOT NULL,
    client_id character varying(255),
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36),
    created_date bigint,
    last_updated_date bigint,
    client_storage_provider character varying(36),
    external_client_id character varying(255)
);


ALTER TABLE public.fed_user_consent OWNER TO imobflow;

--
-- Name: fed_user_consent_cl_scope; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.fed_user_consent_cl_scope (
    user_consent_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL
);


ALTER TABLE public.fed_user_consent_cl_scope OWNER TO imobflow;

--
-- Name: fed_user_credential; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.fed_user_credential (
    id character varying(36) NOT NULL,
    salt bytea,
    type character varying(255),
    created_date bigint,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36),
    user_label character varying(255),
    secret_data text,
    credential_data text,
    priority integer
);


ALTER TABLE public.fed_user_credential OWNER TO imobflow;

--
-- Name: fed_user_group_membership; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.fed_user_group_membership (
    group_id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36)
);


ALTER TABLE public.fed_user_group_membership OWNER TO imobflow;

--
-- Name: fed_user_required_action; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.fed_user_required_action (
    required_action character varying(255) DEFAULT ' '::character varying NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36)
);


ALTER TABLE public.fed_user_required_action OWNER TO imobflow;

--
-- Name: fed_user_role_mapping; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.fed_user_role_mapping (
    role_id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36)
);


ALTER TABLE public.fed_user_role_mapping OWNER TO imobflow;

--
-- Name: federated_identity; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.federated_identity (
    identity_provider character varying(255) NOT NULL,
    realm_id character varying(36),
    federated_user_id character varying(255),
    federated_username character varying(255),
    token text,
    user_id character varying(36) NOT NULL
);


ALTER TABLE public.federated_identity OWNER TO imobflow;

--
-- Name: federated_user; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.federated_user (
    id character varying(255) NOT NULL,
    storage_provider_id character varying(255),
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.federated_user OWNER TO imobflow;

--
-- Name: group_attribute; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.group_attribute (
    id character varying(36) DEFAULT 'sybase-needs-something-here'::character varying NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255),
    group_id character varying(36) NOT NULL
);


ALTER TABLE public.group_attribute OWNER TO imobflow;

--
-- Name: group_role_mapping; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.group_role_mapping (
    role_id character varying(36) NOT NULL,
    group_id character varying(36) NOT NULL
);


ALTER TABLE public.group_role_mapping OWNER TO imobflow;

--
-- Name: identity_provider; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.identity_provider (
    internal_id character varying(36) NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    provider_alias character varying(255),
    provider_id character varying(255),
    store_token boolean DEFAULT false NOT NULL,
    authenticate_by_default boolean DEFAULT false NOT NULL,
    realm_id character varying(36),
    add_token_role boolean DEFAULT true NOT NULL,
    trust_email boolean DEFAULT false NOT NULL,
    first_broker_login_flow_id character varying(36),
    post_broker_login_flow_id character varying(36),
    provider_display_name character varying(255),
    link_only boolean DEFAULT false NOT NULL
);


ALTER TABLE public.identity_provider OWNER TO imobflow;

--
-- Name: identity_provider_config; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.identity_provider_config (
    identity_provider_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.identity_provider_config OWNER TO imobflow;

--
-- Name: identity_provider_mapper; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.identity_provider_mapper (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    idp_alias character varying(255) NOT NULL,
    idp_mapper_name character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.identity_provider_mapper OWNER TO imobflow;

--
-- Name: idp_mapper_config; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.idp_mapper_config (
    idp_mapper_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.idp_mapper_config OWNER TO imobflow;

--
-- Name: keycloak_group; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.keycloak_group (
    id character varying(36) NOT NULL,
    name character varying(255),
    parent_group character varying(36) NOT NULL,
    realm_id character varying(36)
);


ALTER TABLE public.keycloak_group OWNER TO imobflow;

--
-- Name: keycloak_role; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.keycloak_role (
    id character varying(36) NOT NULL,
    client_realm_constraint character varying(255),
    client_role boolean DEFAULT false NOT NULL,
    description character varying(255),
    name character varying(255),
    realm_id character varying(255),
    client character varying(36),
    realm character varying(36)
);


ALTER TABLE public.keycloak_role OWNER TO imobflow;

--
-- Name: migration_model; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.migration_model (
    id character varying(36) NOT NULL,
    version character varying(36),
    update_time bigint DEFAULT 0 NOT NULL
);


ALTER TABLE public.migration_model OWNER TO imobflow;

--
-- Name: offline_client_session; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.offline_client_session (
    user_session_id character varying(36) NOT NULL,
    client_id character varying(255) NOT NULL,
    offline_flag character varying(4) NOT NULL,
    "timestamp" integer,
    data text,
    client_storage_provider character varying(36) DEFAULT 'local'::character varying NOT NULL,
    external_client_id character varying(255) DEFAULT 'local'::character varying NOT NULL,
    version integer DEFAULT 0
);


ALTER TABLE public.offline_client_session OWNER TO imobflow;

--
-- Name: offline_user_session; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.offline_user_session (
    user_session_id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    created_on integer NOT NULL,
    offline_flag character varying(4) NOT NULL,
    data text,
    last_session_refresh integer DEFAULT 0 NOT NULL,
    broker_session_id character varying(1024),
    version integer DEFAULT 0
);


ALTER TABLE public.offline_user_session OWNER TO imobflow;

--
-- Name: org; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.org (
    id character varying(255) NOT NULL,
    enabled boolean NOT NULL,
    realm_id character varying(255) NOT NULL,
    group_id character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(4000)
);


ALTER TABLE public.org OWNER TO imobflow;

--
-- Name: org_domain; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.org_domain (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    verified boolean NOT NULL,
    org_id character varying(255) NOT NULL
);


ALTER TABLE public.org_domain OWNER TO imobflow;

--
-- Name: policy_config; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.policy_config (
    policy_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value text
);


ALTER TABLE public.policy_config OWNER TO imobflow;

--
-- Name: protocol_mapper; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.protocol_mapper (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    protocol character varying(255) NOT NULL,
    protocol_mapper_name character varying(255) NOT NULL,
    client_id character varying(36),
    client_scope_id character varying(36)
);


ALTER TABLE public.protocol_mapper OWNER TO imobflow;

--
-- Name: protocol_mapper_config; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.protocol_mapper_config (
    protocol_mapper_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.protocol_mapper_config OWNER TO imobflow;

--
-- Name: realm; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.realm (
    id character varying(36) NOT NULL,
    access_code_lifespan integer,
    user_action_lifespan integer,
    access_token_lifespan integer,
    account_theme character varying(255),
    admin_theme character varying(255),
    email_theme character varying(255),
    enabled boolean DEFAULT false NOT NULL,
    events_enabled boolean DEFAULT false NOT NULL,
    events_expiration bigint,
    login_theme character varying(255),
    name character varying(255),
    not_before integer,
    password_policy character varying(2550),
    registration_allowed boolean DEFAULT false NOT NULL,
    remember_me boolean DEFAULT false NOT NULL,
    reset_password_allowed boolean DEFAULT false NOT NULL,
    social boolean DEFAULT false NOT NULL,
    ssl_required character varying(255),
    sso_idle_timeout integer,
    sso_max_lifespan integer,
    update_profile_on_soc_login boolean DEFAULT false NOT NULL,
    verify_email boolean DEFAULT false NOT NULL,
    master_admin_client character varying(36),
    login_lifespan integer,
    internationalization_enabled boolean DEFAULT false NOT NULL,
    default_locale character varying(255),
    reg_email_as_username boolean DEFAULT false NOT NULL,
    admin_events_enabled boolean DEFAULT false NOT NULL,
    admin_events_details_enabled boolean DEFAULT false NOT NULL,
    edit_username_allowed boolean DEFAULT false NOT NULL,
    otp_policy_counter integer DEFAULT 0,
    otp_policy_window integer DEFAULT 1,
    otp_policy_period integer DEFAULT 30,
    otp_policy_digits integer DEFAULT 6,
    otp_policy_alg character varying(36) DEFAULT 'HmacSHA1'::character varying,
    otp_policy_type character varying(36) DEFAULT 'totp'::character varying,
    browser_flow character varying(36),
    registration_flow character varying(36),
    direct_grant_flow character varying(36),
    reset_credentials_flow character varying(36),
    client_auth_flow character varying(36),
    offline_session_idle_timeout integer DEFAULT 0,
    revoke_refresh_token boolean DEFAULT false NOT NULL,
    access_token_life_implicit integer DEFAULT 0,
    login_with_email_allowed boolean DEFAULT true NOT NULL,
    duplicate_emails_allowed boolean DEFAULT false NOT NULL,
    docker_auth_flow character varying(36),
    refresh_token_max_reuse integer DEFAULT 0,
    allow_user_managed_access boolean DEFAULT false NOT NULL,
    sso_max_lifespan_remember_me integer DEFAULT 0 NOT NULL,
    sso_idle_timeout_remember_me integer DEFAULT 0 NOT NULL,
    default_role character varying(255)
);


ALTER TABLE public.realm OWNER TO imobflow;

--
-- Name: realm_attribute; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.realm_attribute (
    name character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    value text
);


ALTER TABLE public.realm_attribute OWNER TO imobflow;

--
-- Name: realm_default_groups; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.realm_default_groups (
    realm_id character varying(36) NOT NULL,
    group_id character varying(36) NOT NULL
);


ALTER TABLE public.realm_default_groups OWNER TO imobflow;

--
-- Name: realm_enabled_event_types; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.realm_enabled_event_types (
    realm_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.realm_enabled_event_types OWNER TO imobflow;

--
-- Name: realm_events_listeners; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.realm_events_listeners (
    realm_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.realm_events_listeners OWNER TO imobflow;

--
-- Name: realm_localizations; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.realm_localizations (
    realm_id character varying(255) NOT NULL,
    locale character varying(255) NOT NULL,
    texts text NOT NULL
);


ALTER TABLE public.realm_localizations OWNER TO imobflow;

--
-- Name: realm_required_credential; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.realm_required_credential (
    type character varying(255) NOT NULL,
    form_label character varying(255),
    input boolean DEFAULT false NOT NULL,
    secret boolean DEFAULT false NOT NULL,
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.realm_required_credential OWNER TO imobflow;

--
-- Name: realm_smtp_config; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.realm_smtp_config (
    realm_id character varying(36) NOT NULL,
    value character varying(255),
    name character varying(255) NOT NULL
);


ALTER TABLE public.realm_smtp_config OWNER TO imobflow;

--
-- Name: realm_supported_locales; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.realm_supported_locales (
    realm_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.realm_supported_locales OWNER TO imobflow;

--
-- Name: redirect_uris; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.redirect_uris (
    client_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.redirect_uris OWNER TO imobflow;

--
-- Name: required_action_config; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.required_action_config (
    required_action_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.required_action_config OWNER TO imobflow;

--
-- Name: required_action_provider; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.required_action_provider (
    id character varying(36) NOT NULL,
    alias character varying(255),
    name character varying(255),
    realm_id character varying(36),
    enabled boolean DEFAULT false NOT NULL,
    default_action boolean DEFAULT false NOT NULL,
    provider_id character varying(255),
    priority integer
);


ALTER TABLE public.required_action_provider OWNER TO imobflow;

--
-- Name: resource_attribute; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.resource_attribute (
    id character varying(36) DEFAULT 'sybase-needs-something-here'::character varying NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255),
    resource_id character varying(36) NOT NULL
);


ALTER TABLE public.resource_attribute OWNER TO imobflow;

--
-- Name: resource_policy; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.resource_policy (
    resource_id character varying(36) NOT NULL,
    policy_id character varying(36) NOT NULL
);


ALTER TABLE public.resource_policy OWNER TO imobflow;

--
-- Name: resource_scope; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.resource_scope (
    resource_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL
);


ALTER TABLE public.resource_scope OWNER TO imobflow;

--
-- Name: resource_server; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.resource_server (
    id character varying(36) NOT NULL,
    allow_rs_remote_mgmt boolean DEFAULT false NOT NULL,
    policy_enforce_mode smallint NOT NULL,
    decision_strategy smallint DEFAULT 1 NOT NULL
);


ALTER TABLE public.resource_server OWNER TO imobflow;

--
-- Name: resource_server_perm_ticket; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.resource_server_perm_ticket (
    id character varying(36) NOT NULL,
    owner character varying(255) NOT NULL,
    requester character varying(255) NOT NULL,
    created_timestamp bigint NOT NULL,
    granted_timestamp bigint,
    resource_id character varying(36) NOT NULL,
    scope_id character varying(36),
    resource_server_id character varying(36) NOT NULL,
    policy_id character varying(36)
);


ALTER TABLE public.resource_server_perm_ticket OWNER TO imobflow;

--
-- Name: resource_server_policy; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.resource_server_policy (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(255),
    type character varying(255) NOT NULL,
    decision_strategy smallint,
    logic smallint,
    resource_server_id character varying(36) NOT NULL,
    owner character varying(255)
);


ALTER TABLE public.resource_server_policy OWNER TO imobflow;

--
-- Name: resource_server_resource; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.resource_server_resource (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    type character varying(255),
    icon_uri character varying(255),
    owner character varying(255) NOT NULL,
    resource_server_id character varying(36) NOT NULL,
    owner_managed_access boolean DEFAULT false NOT NULL,
    display_name character varying(255)
);


ALTER TABLE public.resource_server_resource OWNER TO imobflow;

--
-- Name: resource_server_scope; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.resource_server_scope (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    icon_uri character varying(255),
    resource_server_id character varying(36) NOT NULL,
    display_name character varying(255)
);


ALTER TABLE public.resource_server_scope OWNER TO imobflow;

--
-- Name: resource_uris; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.resource_uris (
    resource_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.resource_uris OWNER TO imobflow;

--
-- Name: role_attribute; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.role_attribute (
    id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255)
);


ALTER TABLE public.role_attribute OWNER TO imobflow;

--
-- Name: scope_mapping; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.scope_mapping (
    client_id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL
);


ALTER TABLE public.scope_mapping OWNER TO imobflow;

--
-- Name: scope_policy; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.scope_policy (
    scope_id character varying(36) NOT NULL,
    policy_id character varying(36) NOT NULL
);


ALTER TABLE public.scope_policy OWNER TO imobflow;

--
-- Name: user_attribute; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.user_attribute (
    name character varying(255) NOT NULL,
    value character varying(255),
    user_id character varying(36) NOT NULL,
    id character varying(36) DEFAULT 'sybase-needs-something-here'::character varying NOT NULL,
    long_value_hash bytea,
    long_value_hash_lower_case bytea,
    long_value text
);


ALTER TABLE public.user_attribute OWNER TO imobflow;

--
-- Name: user_consent; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.user_consent (
    id character varying(36) NOT NULL,
    client_id character varying(255),
    user_id character varying(36) NOT NULL,
    created_date bigint,
    last_updated_date bigint,
    client_storage_provider character varying(36),
    external_client_id character varying(255)
);


ALTER TABLE public.user_consent OWNER TO imobflow;

--
-- Name: user_consent_client_scope; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.user_consent_client_scope (
    user_consent_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL
);


ALTER TABLE public.user_consent_client_scope OWNER TO imobflow;

--
-- Name: user_entity; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.user_entity (
    id character varying(36) NOT NULL,
    email character varying(255),
    email_constraint character varying(255),
    email_verified boolean DEFAULT false NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    federation_link character varying(255),
    first_name character varying(255),
    last_name character varying(255),
    realm_id character varying(255),
    username character varying(255),
    created_timestamp bigint,
    service_account_client_link character varying(255),
    not_before integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.user_entity OWNER TO imobflow;

--
-- Name: user_federation_config; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.user_federation_config (
    user_federation_provider_id character varying(36) NOT NULL,
    value character varying(255),
    name character varying(255) NOT NULL
);


ALTER TABLE public.user_federation_config OWNER TO imobflow;

--
-- Name: user_federation_mapper; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.user_federation_mapper (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    federation_provider_id character varying(36) NOT NULL,
    federation_mapper_type character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.user_federation_mapper OWNER TO imobflow;

--
-- Name: user_federation_mapper_config; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.user_federation_mapper_config (
    user_federation_mapper_id character varying(36) NOT NULL,
    value character varying(255),
    name character varying(255) NOT NULL
);


ALTER TABLE public.user_federation_mapper_config OWNER TO imobflow;

--
-- Name: user_federation_provider; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.user_federation_provider (
    id character varying(36) NOT NULL,
    changed_sync_period integer,
    display_name character varying(255),
    full_sync_period integer,
    last_sync integer,
    priority integer,
    provider_name character varying(255),
    realm_id character varying(36)
);


ALTER TABLE public.user_federation_provider OWNER TO imobflow;

--
-- Name: user_group_membership; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.user_group_membership (
    group_id character varying(36) NOT NULL,
    user_id character varying(36) NOT NULL
);


ALTER TABLE public.user_group_membership OWNER TO imobflow;

--
-- Name: user_required_action; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.user_required_action (
    user_id character varying(36) NOT NULL,
    required_action character varying(255) DEFAULT ' '::character varying NOT NULL
);


ALTER TABLE public.user_required_action OWNER TO imobflow;

--
-- Name: user_role_mapping; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.user_role_mapping (
    role_id character varying(255) NOT NULL,
    user_id character varying(36) NOT NULL
);


ALTER TABLE public.user_role_mapping OWNER TO imobflow;

--
-- Name: user_session; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.user_session (
    id character varying(36) NOT NULL,
    auth_method character varying(255),
    ip_address character varying(255),
    last_session_refresh integer,
    login_username character varying(255),
    realm_id character varying(255),
    remember_me boolean DEFAULT false NOT NULL,
    started integer,
    user_id character varying(255),
    user_session_state integer,
    broker_session_id character varying(255),
    broker_user_id character varying(255)
);


ALTER TABLE public.user_session OWNER TO imobflow;

--
-- Name: user_session_note; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.user_session_note (
    user_session character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(2048)
);


ALTER TABLE public.user_session_note OWNER TO imobflow;

--
-- Name: username_login_failure; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.username_login_failure (
    realm_id character varying(36) NOT NULL,
    username character varying(255) NOT NULL,
    failed_login_not_before integer,
    last_failure bigint,
    last_ip_failure character varying(255),
    num_failures integer
);


ALTER TABLE public.username_login_failure OWNER TO imobflow;

--
-- Name: web_origins; Type: TABLE; Schema: public; Owner: imobflow
--

CREATE TABLE public.web_origins (
    client_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.web_origins OWNER TO imobflow;

--
-- Data for Name: admin_event_entity; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.admin_event_entity (id, admin_event_time, realm_id, operation_type, auth_realm_id, auth_client_id, auth_user_id, ip_address, resource_path, representation, error, resource_type) FROM stdin;
\.


--
-- Data for Name: associated_policy; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.associated_policy (policy_id, associated_policy_id) FROM stdin;
\.


--
-- Data for Name: authentication_execution; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.authentication_execution (id, alias, authenticator, realm_id, flow_id, requirement, priority, authenticator_flow, auth_flow_id, auth_config) FROM stdin;
251adc2a-b8ce-4531-827a-a238bfd48277	\N	auth-cookie	a26b60a1-fefa-4c54-839e-6fb85147388e	7c9c4ba2-9597-436a-be58-54ba336a33cd	2	10	f	\N	\N
f4b6047a-207c-43fe-9127-d339292be079	\N	auth-spnego	a26b60a1-fefa-4c54-839e-6fb85147388e	7c9c4ba2-9597-436a-be58-54ba336a33cd	3	20	f	\N	\N
de7109b2-5c7a-4807-b9f1-a3527de440ef	\N	identity-provider-redirector	a26b60a1-fefa-4c54-839e-6fb85147388e	7c9c4ba2-9597-436a-be58-54ba336a33cd	2	25	f	\N	\N
f8d7388b-ac1b-453c-9455-aa8218d54952	\N	\N	a26b60a1-fefa-4c54-839e-6fb85147388e	7c9c4ba2-9597-436a-be58-54ba336a33cd	2	30	t	73bd9a8e-299f-4692-b941-af507265e903	\N
bab02284-0eb3-4f90-89e7-366a2fde3878	\N	auth-username-password-form	a26b60a1-fefa-4c54-839e-6fb85147388e	73bd9a8e-299f-4692-b941-af507265e903	0	10	f	\N	\N
d1281a5e-04b9-43cc-b5f0-03fe6a6ea25d	\N	\N	a26b60a1-fefa-4c54-839e-6fb85147388e	73bd9a8e-299f-4692-b941-af507265e903	1	20	t	f676fcff-1bb2-4c2f-a0ad-0c3839c075e1	\N
57f17c12-c255-465b-b40c-0f7c04d28894	\N	conditional-user-configured	a26b60a1-fefa-4c54-839e-6fb85147388e	f676fcff-1bb2-4c2f-a0ad-0c3839c075e1	0	10	f	\N	\N
dc1a1391-b0ee-4494-a717-c349a5d5d795	\N	auth-otp-form	a26b60a1-fefa-4c54-839e-6fb85147388e	f676fcff-1bb2-4c2f-a0ad-0c3839c075e1	0	20	f	\N	\N
29c98131-ebf6-4483-9a9b-9d0c2e2eee65	\N	direct-grant-validate-username	a26b60a1-fefa-4c54-839e-6fb85147388e	81973622-46a6-4695-8ff3-553bfaa815d0	0	10	f	\N	\N
98d754d8-f2a5-4ef8-ad72-00221434df8e	\N	direct-grant-validate-password	a26b60a1-fefa-4c54-839e-6fb85147388e	81973622-46a6-4695-8ff3-553bfaa815d0	0	20	f	\N	\N
cecd520a-41eb-4d2e-a04c-98bb63567671	\N	\N	a26b60a1-fefa-4c54-839e-6fb85147388e	81973622-46a6-4695-8ff3-553bfaa815d0	1	30	t	d325ecca-d9be-46bf-8269-100404307bde	\N
a54c5535-cf0f-4f3f-8270-5135af9fe073	\N	conditional-user-configured	a26b60a1-fefa-4c54-839e-6fb85147388e	d325ecca-d9be-46bf-8269-100404307bde	0	10	f	\N	\N
6d3bbfb9-39aa-4d0f-ae45-a72b63ad0303	\N	direct-grant-validate-otp	a26b60a1-fefa-4c54-839e-6fb85147388e	d325ecca-d9be-46bf-8269-100404307bde	0	20	f	\N	\N
1681eac2-068a-47df-a3db-5e858f98dbba	\N	registration-page-form	a26b60a1-fefa-4c54-839e-6fb85147388e	2e52b7f8-8fde-48b5-95ed-66a27118eb84	0	10	t	4022b5ba-19ca-4c0f-ab46-3f7625f97a16	\N
566860d8-f313-4cf4-8f38-878f73849936	\N	registration-user-creation	a26b60a1-fefa-4c54-839e-6fb85147388e	4022b5ba-19ca-4c0f-ab46-3f7625f97a16	0	20	f	\N	\N
0243aeb8-9f04-41fa-8051-c21d7aeb37a4	\N	registration-password-action	a26b60a1-fefa-4c54-839e-6fb85147388e	4022b5ba-19ca-4c0f-ab46-3f7625f97a16	0	50	f	\N	\N
f87a30f9-dbce-41a0-a486-7107669ae755	\N	registration-recaptcha-action	a26b60a1-fefa-4c54-839e-6fb85147388e	4022b5ba-19ca-4c0f-ab46-3f7625f97a16	3	60	f	\N	\N
895160ed-af8f-457f-8e6b-2a602a96b7d3	\N	registration-terms-and-conditions	a26b60a1-fefa-4c54-839e-6fb85147388e	4022b5ba-19ca-4c0f-ab46-3f7625f97a16	3	70	f	\N	\N
e2db5b1b-23ba-43b4-a9c5-5f89a498c4d0	\N	reset-credentials-choose-user	a26b60a1-fefa-4c54-839e-6fb85147388e	0224aa28-973f-4393-85e7-bf4f3629b1c3	0	10	f	\N	\N
b0c5a6ba-07da-4b36-a1d3-7689f05bc909	\N	reset-credential-email	a26b60a1-fefa-4c54-839e-6fb85147388e	0224aa28-973f-4393-85e7-bf4f3629b1c3	0	20	f	\N	\N
70f0bb9a-36df-400c-a1d1-bce96d333917	\N	reset-password	a26b60a1-fefa-4c54-839e-6fb85147388e	0224aa28-973f-4393-85e7-bf4f3629b1c3	0	30	f	\N	\N
ed772f18-7141-4845-be5f-9e1b8e9cc861	\N	\N	a26b60a1-fefa-4c54-839e-6fb85147388e	0224aa28-973f-4393-85e7-bf4f3629b1c3	1	40	t	0487780d-de1f-4bab-8c0a-65515c403368	\N
2c34732e-b0b6-40f6-be63-4d61a1a2918b	\N	conditional-user-configured	a26b60a1-fefa-4c54-839e-6fb85147388e	0487780d-de1f-4bab-8c0a-65515c403368	0	10	f	\N	\N
4c3e0c78-7806-42c7-bfb7-57cb2f5601f5	\N	reset-otp	a26b60a1-fefa-4c54-839e-6fb85147388e	0487780d-de1f-4bab-8c0a-65515c403368	0	20	f	\N	\N
88770a16-f7c7-48b0-b1f0-dde92b05cbd8	\N	client-secret	a26b60a1-fefa-4c54-839e-6fb85147388e	088837fe-a84b-462e-8710-986328748965	2	10	f	\N	\N
14430308-f685-4d9d-8cb5-e944a278da2a	\N	client-jwt	a26b60a1-fefa-4c54-839e-6fb85147388e	088837fe-a84b-462e-8710-986328748965	2	20	f	\N	\N
ef914a59-83a2-4a81-842a-3370a368390c	\N	client-secret-jwt	a26b60a1-fefa-4c54-839e-6fb85147388e	088837fe-a84b-462e-8710-986328748965	2	30	f	\N	\N
74a18440-bb92-4847-81b0-faa611fad95e	\N	client-x509	a26b60a1-fefa-4c54-839e-6fb85147388e	088837fe-a84b-462e-8710-986328748965	2	40	f	\N	\N
7bf04e96-8e75-423a-be68-d83f67c3467c	\N	idp-review-profile	a26b60a1-fefa-4c54-839e-6fb85147388e	ac698d31-c116-4eb8-ba2d-4bb25764238f	0	10	f	\N	26778c3a-f6b1-493d-9301-53fbddaef773
4ccb7144-7640-4655-bfe4-f5902427331b	\N	\N	a26b60a1-fefa-4c54-839e-6fb85147388e	ac698d31-c116-4eb8-ba2d-4bb25764238f	0	20	t	f08f0ff4-1ee3-411c-a14c-d3b755a90abe	\N
cf25dff7-7d53-446e-92ce-1bbc9333d99a	\N	idp-create-user-if-unique	a26b60a1-fefa-4c54-839e-6fb85147388e	f08f0ff4-1ee3-411c-a14c-d3b755a90abe	2	10	f	\N	3766832e-263f-4bda-8ccd-0a83a50192c6
57048a56-c5a5-4883-b1ca-13909cb4bd1f	\N	\N	a26b60a1-fefa-4c54-839e-6fb85147388e	f08f0ff4-1ee3-411c-a14c-d3b755a90abe	2	20	t	77135c12-1fad-4d77-8c2e-b65897e519e6	\N
3a427147-ca54-4f6b-967e-d5dbf0dfed55	\N	idp-confirm-link	a26b60a1-fefa-4c54-839e-6fb85147388e	77135c12-1fad-4d77-8c2e-b65897e519e6	0	10	f	\N	\N
8c6efd5d-4b44-495e-ae92-a6d950dd0091	\N	\N	a26b60a1-fefa-4c54-839e-6fb85147388e	77135c12-1fad-4d77-8c2e-b65897e519e6	0	20	t	267cf329-d988-46e4-823f-7b656f16781b	\N
bdd76bc4-3be3-4573-923f-7faa90b4bdb5	\N	idp-email-verification	a26b60a1-fefa-4c54-839e-6fb85147388e	267cf329-d988-46e4-823f-7b656f16781b	2	10	f	\N	\N
5e2c5c9c-17d4-49c3-b9d3-160813927d59	\N	\N	a26b60a1-fefa-4c54-839e-6fb85147388e	267cf329-d988-46e4-823f-7b656f16781b	2	20	t	d8fb9b76-6353-4cc2-bf04-453512315cee	\N
cfd828ea-3297-4665-adf3-6b365b2b5079	\N	idp-username-password-form	a26b60a1-fefa-4c54-839e-6fb85147388e	d8fb9b76-6353-4cc2-bf04-453512315cee	0	10	f	\N	\N
209981a0-b2b6-49e7-8ab9-62fd0411ae7c	\N	\N	a26b60a1-fefa-4c54-839e-6fb85147388e	d8fb9b76-6353-4cc2-bf04-453512315cee	1	20	t	f5a07197-7e43-4ecd-94b1-6fdc2b611a28	\N
784bc18f-5e03-4591-985c-d50518a97d5b	\N	conditional-user-configured	a26b60a1-fefa-4c54-839e-6fb85147388e	f5a07197-7e43-4ecd-94b1-6fdc2b611a28	0	10	f	\N	\N
52be9142-3289-405f-be30-d3660e4d0690	\N	auth-otp-form	a26b60a1-fefa-4c54-839e-6fb85147388e	f5a07197-7e43-4ecd-94b1-6fdc2b611a28	0	20	f	\N	\N
6eb61824-b95b-4bc8-a117-893bc5f5dfd2	\N	http-basic-authenticator	a26b60a1-fefa-4c54-839e-6fb85147388e	c2267751-ae70-497d-b92b-e3300c5e3d73	0	10	f	\N	\N
bcb1fffe-0c40-4602-ba53-4bef482386c7	\N	docker-http-basic-authenticator	a26b60a1-fefa-4c54-839e-6fb85147388e	e59550fd-f448-4f7e-a12a-bc42e2bbb5c4	0	10	f	\N	\N
\.


--
-- Data for Name: authentication_flow; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.authentication_flow (id, alias, description, realm_id, provider_id, top_level, built_in) FROM stdin;
7c9c4ba2-9597-436a-be58-54ba336a33cd	browser	browser based authentication	a26b60a1-fefa-4c54-839e-6fb85147388e	basic-flow	t	t
73bd9a8e-299f-4692-b941-af507265e903	forms	Username, password, otp and other auth forms.	a26b60a1-fefa-4c54-839e-6fb85147388e	basic-flow	f	t
f676fcff-1bb2-4c2f-a0ad-0c3839c075e1	Browser - Conditional OTP	Flow to determine if the OTP is required for the authentication	a26b60a1-fefa-4c54-839e-6fb85147388e	basic-flow	f	t
81973622-46a6-4695-8ff3-553bfaa815d0	direct grant	OpenID Connect Resource Owner Grant	a26b60a1-fefa-4c54-839e-6fb85147388e	basic-flow	t	t
d325ecca-d9be-46bf-8269-100404307bde	Direct Grant - Conditional OTP	Flow to determine if the OTP is required for the authentication	a26b60a1-fefa-4c54-839e-6fb85147388e	basic-flow	f	t
2e52b7f8-8fde-48b5-95ed-66a27118eb84	registration	registration flow	a26b60a1-fefa-4c54-839e-6fb85147388e	basic-flow	t	t
4022b5ba-19ca-4c0f-ab46-3f7625f97a16	registration form	registration form	a26b60a1-fefa-4c54-839e-6fb85147388e	form-flow	f	t
0224aa28-973f-4393-85e7-bf4f3629b1c3	reset credentials	Reset credentials for a user if they forgot their password or something	a26b60a1-fefa-4c54-839e-6fb85147388e	basic-flow	t	t
0487780d-de1f-4bab-8c0a-65515c403368	Reset - Conditional OTP	Flow to determine if the OTP should be reset or not. Set to REQUIRED to force.	a26b60a1-fefa-4c54-839e-6fb85147388e	basic-flow	f	t
088837fe-a84b-462e-8710-986328748965	clients	Base authentication for clients	a26b60a1-fefa-4c54-839e-6fb85147388e	client-flow	t	t
ac698d31-c116-4eb8-ba2d-4bb25764238f	first broker login	Actions taken after first broker login with identity provider account, which is not yet linked to any Keycloak account	a26b60a1-fefa-4c54-839e-6fb85147388e	basic-flow	t	t
f08f0ff4-1ee3-411c-a14c-d3b755a90abe	User creation or linking	Flow for the existing/non-existing user alternatives	a26b60a1-fefa-4c54-839e-6fb85147388e	basic-flow	f	t
77135c12-1fad-4d77-8c2e-b65897e519e6	Handle Existing Account	Handle what to do if there is existing account with same email/username like authenticated identity provider	a26b60a1-fefa-4c54-839e-6fb85147388e	basic-flow	f	t
267cf329-d988-46e4-823f-7b656f16781b	Account verification options	Method with which to verity the existing account	a26b60a1-fefa-4c54-839e-6fb85147388e	basic-flow	f	t
d8fb9b76-6353-4cc2-bf04-453512315cee	Verify Existing Account by Re-authentication	Reauthentication of existing account	a26b60a1-fefa-4c54-839e-6fb85147388e	basic-flow	f	t
f5a07197-7e43-4ecd-94b1-6fdc2b611a28	First broker login - Conditional OTP	Flow to determine if the OTP is required for the authentication	a26b60a1-fefa-4c54-839e-6fb85147388e	basic-flow	f	t
c2267751-ae70-497d-b92b-e3300c5e3d73	saml ecp	SAML ECP Profile Authentication Flow	a26b60a1-fefa-4c54-839e-6fb85147388e	basic-flow	t	t
e59550fd-f448-4f7e-a12a-bc42e2bbb5c4	docker auth	Used by Docker clients to authenticate against the IDP	a26b60a1-fefa-4c54-839e-6fb85147388e	basic-flow	t	t
\.


--
-- Data for Name: authenticator_config; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.authenticator_config (id, alias, realm_id) FROM stdin;
26778c3a-f6b1-493d-9301-53fbddaef773	review profile config	a26b60a1-fefa-4c54-839e-6fb85147388e
3766832e-263f-4bda-8ccd-0a83a50192c6	create unique user config	a26b60a1-fefa-4c54-839e-6fb85147388e
\.


--
-- Data for Name: authenticator_config_entry; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.authenticator_config_entry (authenticator_id, value, name) FROM stdin;
26778c3a-f6b1-493d-9301-53fbddaef773	missing	update.profile.on.first.login
3766832e-263f-4bda-8ccd-0a83a50192c6	false	require.password.update.after.registration
\.


--
-- Data for Name: broker_link; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.broker_link (identity_provider, storage_provider_id, realm_id, broker_user_id, broker_username, token, user_id) FROM stdin;
\.


--
-- Data for Name: client; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.client (id, enabled, full_scope_allowed, client_id, not_before, public_client, secret, base_url, bearer_only, management_url, surrogate_auth_required, realm_id, protocol, node_rereg_timeout, frontchannel_logout, consent_required, name, service_accounts_enabled, client_authenticator_type, root_url, description, registration_token, standard_flow_enabled, implicit_flow_enabled, direct_access_grants_enabled, always_display_in_console) FROM stdin;
c419fb54-e4aa-4ed2-ac6f-9fcd190ed931	t	f	master-realm	0	f	\N	\N	t	\N	f	a26b60a1-fefa-4c54-839e-6fb85147388e	\N	0	f	f	master Realm	f	client-secret	\N	\N	\N	t	f	f	f
67d81828-c34f-4dda-98c0-a530e3c34d9a	t	f	account	0	t	\N	/realms/master/account/	f	\N	f	a26b60a1-fefa-4c54-839e-6fb85147388e	openid-connect	0	f	f	${client_account}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
f41e8256-0ee9-460a-a545-2667e84afdf0	t	f	account-console	0	t	\N	/realms/master/account/	f	\N	f	a26b60a1-fefa-4c54-839e-6fb85147388e	openid-connect	0	f	f	${client_account-console}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
cff128cb-8afa-46fb-bf72-ae3bc64a3d19	t	f	broker	0	f	\N	\N	t	\N	f	a26b60a1-fefa-4c54-839e-6fb85147388e	openid-connect	0	f	f	${client_broker}	f	client-secret	\N	\N	\N	t	f	f	f
3706d3ff-4038-409b-83c6-eb36c273dc4a	t	f	security-admin-console	0	t	\N	/admin/master/console/	f	\N	f	a26b60a1-fefa-4c54-839e-6fb85147388e	openid-connect	0	f	f	${client_security-admin-console}	f	client-secret	${authAdminUrl}	\N	\N	t	f	f	f
6e3503ab-30ea-4646-b1db-4fa7c9622da6	t	f	admin-cli	0	t	\N	\N	f	\N	f	a26b60a1-fefa-4c54-839e-6fb85147388e	openid-connect	0	f	f	${client_admin-cli}	f	client-secret	\N	\N	\N	f	f	t	f
\.


--
-- Data for Name: client_attributes; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.client_attributes (client_id, name, value) FROM stdin;
67d81828-c34f-4dda-98c0-a530e3c34d9a	post.logout.redirect.uris	+
f41e8256-0ee9-460a-a545-2667e84afdf0	post.logout.redirect.uris	+
f41e8256-0ee9-460a-a545-2667e84afdf0	pkce.code.challenge.method	S256
3706d3ff-4038-409b-83c6-eb36c273dc4a	post.logout.redirect.uris	+
3706d3ff-4038-409b-83c6-eb36c273dc4a	pkce.code.challenge.method	S256
\.


--
-- Data for Name: client_auth_flow_bindings; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.client_auth_flow_bindings (client_id, flow_id, binding_name) FROM stdin;
\.


--
-- Data for Name: client_initial_access; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.client_initial_access (id, realm_id, "timestamp", expiration, count, remaining_count) FROM stdin;
\.


--
-- Data for Name: client_node_registrations; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.client_node_registrations (client_id, value, name) FROM stdin;
\.


--
-- Data for Name: client_scope; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.client_scope (id, name, realm_id, description, protocol) FROM stdin;
1b91ac1f-0c24-4c66-add7-3083de2b1fab	offline_access	a26b60a1-fefa-4c54-839e-6fb85147388e	OpenID Connect built-in scope: offline_access	openid-connect
283acb3d-e607-4a0c-97d1-ae1b7102146f	role_list	a26b60a1-fefa-4c54-839e-6fb85147388e	SAML role list	saml
a66e1e63-0c41-43ab-a557-d42a1e0e9179	profile	a26b60a1-fefa-4c54-839e-6fb85147388e	OpenID Connect built-in scope: profile	openid-connect
fc1ddff4-6764-418f-b4d4-1047530b5443	email	a26b60a1-fefa-4c54-839e-6fb85147388e	OpenID Connect built-in scope: email	openid-connect
8193e8cb-ecfb-47c1-966c-cd7bf7d1a7c9	address	a26b60a1-fefa-4c54-839e-6fb85147388e	OpenID Connect built-in scope: address	openid-connect
37c48668-3df6-4fb9-8009-d1867372a4ca	phone	a26b60a1-fefa-4c54-839e-6fb85147388e	OpenID Connect built-in scope: phone	openid-connect
e037c9df-53a8-40a6-990b-420805196ca4	roles	a26b60a1-fefa-4c54-839e-6fb85147388e	OpenID Connect scope for add user roles to the access token	openid-connect
9bcf133d-25e0-421a-9b53-3702f24b9da4	web-origins	a26b60a1-fefa-4c54-839e-6fb85147388e	OpenID Connect scope for add allowed web origins to the access token	openid-connect
0915860d-fbbf-4e07-9de4-2eb4a8540de4	microprofile-jwt	a26b60a1-fefa-4c54-839e-6fb85147388e	Microprofile - JWT built-in scope	openid-connect
6d9433c3-e6f5-4bf9-849f-105e354fe7af	acr	a26b60a1-fefa-4c54-839e-6fb85147388e	OpenID Connect scope for add acr (authentication context class reference) to the token	openid-connect
7174b2a2-695c-4d32-b84b-b702c0fa3b00	basic	a26b60a1-fefa-4c54-839e-6fb85147388e	OpenID Connect scope for add all basic claims to the token	openid-connect
\.


--
-- Data for Name: client_scope_attributes; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.client_scope_attributes (scope_id, value, name) FROM stdin;
1b91ac1f-0c24-4c66-add7-3083de2b1fab	true	display.on.consent.screen
1b91ac1f-0c24-4c66-add7-3083de2b1fab	${offlineAccessScopeConsentText}	consent.screen.text
283acb3d-e607-4a0c-97d1-ae1b7102146f	true	display.on.consent.screen
283acb3d-e607-4a0c-97d1-ae1b7102146f	${samlRoleListScopeConsentText}	consent.screen.text
a66e1e63-0c41-43ab-a557-d42a1e0e9179	true	display.on.consent.screen
a66e1e63-0c41-43ab-a557-d42a1e0e9179	${profileScopeConsentText}	consent.screen.text
a66e1e63-0c41-43ab-a557-d42a1e0e9179	true	include.in.token.scope
fc1ddff4-6764-418f-b4d4-1047530b5443	true	display.on.consent.screen
fc1ddff4-6764-418f-b4d4-1047530b5443	${emailScopeConsentText}	consent.screen.text
fc1ddff4-6764-418f-b4d4-1047530b5443	true	include.in.token.scope
8193e8cb-ecfb-47c1-966c-cd7bf7d1a7c9	true	display.on.consent.screen
8193e8cb-ecfb-47c1-966c-cd7bf7d1a7c9	${addressScopeConsentText}	consent.screen.text
8193e8cb-ecfb-47c1-966c-cd7bf7d1a7c9	true	include.in.token.scope
37c48668-3df6-4fb9-8009-d1867372a4ca	true	display.on.consent.screen
37c48668-3df6-4fb9-8009-d1867372a4ca	${phoneScopeConsentText}	consent.screen.text
37c48668-3df6-4fb9-8009-d1867372a4ca	true	include.in.token.scope
e037c9df-53a8-40a6-990b-420805196ca4	true	display.on.consent.screen
e037c9df-53a8-40a6-990b-420805196ca4	${rolesScopeConsentText}	consent.screen.text
e037c9df-53a8-40a6-990b-420805196ca4	false	include.in.token.scope
9bcf133d-25e0-421a-9b53-3702f24b9da4	false	display.on.consent.screen
9bcf133d-25e0-421a-9b53-3702f24b9da4		consent.screen.text
9bcf133d-25e0-421a-9b53-3702f24b9da4	false	include.in.token.scope
0915860d-fbbf-4e07-9de4-2eb4a8540de4	false	display.on.consent.screen
0915860d-fbbf-4e07-9de4-2eb4a8540de4	true	include.in.token.scope
6d9433c3-e6f5-4bf9-849f-105e354fe7af	false	display.on.consent.screen
6d9433c3-e6f5-4bf9-849f-105e354fe7af	false	include.in.token.scope
7174b2a2-695c-4d32-b84b-b702c0fa3b00	false	display.on.consent.screen
7174b2a2-695c-4d32-b84b-b702c0fa3b00	false	include.in.token.scope
\.


--
-- Data for Name: client_scope_client; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.client_scope_client (client_id, scope_id, default_scope) FROM stdin;
67d81828-c34f-4dda-98c0-a530e3c34d9a	7174b2a2-695c-4d32-b84b-b702c0fa3b00	t
67d81828-c34f-4dda-98c0-a530e3c34d9a	e037c9df-53a8-40a6-990b-420805196ca4	t
67d81828-c34f-4dda-98c0-a530e3c34d9a	a66e1e63-0c41-43ab-a557-d42a1e0e9179	t
67d81828-c34f-4dda-98c0-a530e3c34d9a	fc1ddff4-6764-418f-b4d4-1047530b5443	t
67d81828-c34f-4dda-98c0-a530e3c34d9a	9bcf133d-25e0-421a-9b53-3702f24b9da4	t
67d81828-c34f-4dda-98c0-a530e3c34d9a	6d9433c3-e6f5-4bf9-849f-105e354fe7af	t
67d81828-c34f-4dda-98c0-a530e3c34d9a	37c48668-3df6-4fb9-8009-d1867372a4ca	f
67d81828-c34f-4dda-98c0-a530e3c34d9a	0915860d-fbbf-4e07-9de4-2eb4a8540de4	f
67d81828-c34f-4dda-98c0-a530e3c34d9a	8193e8cb-ecfb-47c1-966c-cd7bf7d1a7c9	f
67d81828-c34f-4dda-98c0-a530e3c34d9a	1b91ac1f-0c24-4c66-add7-3083de2b1fab	f
f41e8256-0ee9-460a-a545-2667e84afdf0	7174b2a2-695c-4d32-b84b-b702c0fa3b00	t
f41e8256-0ee9-460a-a545-2667e84afdf0	e037c9df-53a8-40a6-990b-420805196ca4	t
f41e8256-0ee9-460a-a545-2667e84afdf0	a66e1e63-0c41-43ab-a557-d42a1e0e9179	t
f41e8256-0ee9-460a-a545-2667e84afdf0	fc1ddff4-6764-418f-b4d4-1047530b5443	t
f41e8256-0ee9-460a-a545-2667e84afdf0	9bcf133d-25e0-421a-9b53-3702f24b9da4	t
f41e8256-0ee9-460a-a545-2667e84afdf0	6d9433c3-e6f5-4bf9-849f-105e354fe7af	t
f41e8256-0ee9-460a-a545-2667e84afdf0	37c48668-3df6-4fb9-8009-d1867372a4ca	f
f41e8256-0ee9-460a-a545-2667e84afdf0	0915860d-fbbf-4e07-9de4-2eb4a8540de4	f
f41e8256-0ee9-460a-a545-2667e84afdf0	8193e8cb-ecfb-47c1-966c-cd7bf7d1a7c9	f
f41e8256-0ee9-460a-a545-2667e84afdf0	1b91ac1f-0c24-4c66-add7-3083de2b1fab	f
6e3503ab-30ea-4646-b1db-4fa7c9622da6	7174b2a2-695c-4d32-b84b-b702c0fa3b00	t
6e3503ab-30ea-4646-b1db-4fa7c9622da6	e037c9df-53a8-40a6-990b-420805196ca4	t
6e3503ab-30ea-4646-b1db-4fa7c9622da6	a66e1e63-0c41-43ab-a557-d42a1e0e9179	t
6e3503ab-30ea-4646-b1db-4fa7c9622da6	fc1ddff4-6764-418f-b4d4-1047530b5443	t
6e3503ab-30ea-4646-b1db-4fa7c9622da6	9bcf133d-25e0-421a-9b53-3702f24b9da4	t
6e3503ab-30ea-4646-b1db-4fa7c9622da6	6d9433c3-e6f5-4bf9-849f-105e354fe7af	t
6e3503ab-30ea-4646-b1db-4fa7c9622da6	37c48668-3df6-4fb9-8009-d1867372a4ca	f
6e3503ab-30ea-4646-b1db-4fa7c9622da6	0915860d-fbbf-4e07-9de4-2eb4a8540de4	f
6e3503ab-30ea-4646-b1db-4fa7c9622da6	8193e8cb-ecfb-47c1-966c-cd7bf7d1a7c9	f
6e3503ab-30ea-4646-b1db-4fa7c9622da6	1b91ac1f-0c24-4c66-add7-3083de2b1fab	f
cff128cb-8afa-46fb-bf72-ae3bc64a3d19	7174b2a2-695c-4d32-b84b-b702c0fa3b00	t
cff128cb-8afa-46fb-bf72-ae3bc64a3d19	e037c9df-53a8-40a6-990b-420805196ca4	t
cff128cb-8afa-46fb-bf72-ae3bc64a3d19	a66e1e63-0c41-43ab-a557-d42a1e0e9179	t
cff128cb-8afa-46fb-bf72-ae3bc64a3d19	fc1ddff4-6764-418f-b4d4-1047530b5443	t
cff128cb-8afa-46fb-bf72-ae3bc64a3d19	9bcf133d-25e0-421a-9b53-3702f24b9da4	t
cff128cb-8afa-46fb-bf72-ae3bc64a3d19	6d9433c3-e6f5-4bf9-849f-105e354fe7af	t
cff128cb-8afa-46fb-bf72-ae3bc64a3d19	37c48668-3df6-4fb9-8009-d1867372a4ca	f
cff128cb-8afa-46fb-bf72-ae3bc64a3d19	0915860d-fbbf-4e07-9de4-2eb4a8540de4	f
cff128cb-8afa-46fb-bf72-ae3bc64a3d19	8193e8cb-ecfb-47c1-966c-cd7bf7d1a7c9	f
cff128cb-8afa-46fb-bf72-ae3bc64a3d19	1b91ac1f-0c24-4c66-add7-3083de2b1fab	f
c419fb54-e4aa-4ed2-ac6f-9fcd190ed931	7174b2a2-695c-4d32-b84b-b702c0fa3b00	t
c419fb54-e4aa-4ed2-ac6f-9fcd190ed931	e037c9df-53a8-40a6-990b-420805196ca4	t
c419fb54-e4aa-4ed2-ac6f-9fcd190ed931	a66e1e63-0c41-43ab-a557-d42a1e0e9179	t
c419fb54-e4aa-4ed2-ac6f-9fcd190ed931	fc1ddff4-6764-418f-b4d4-1047530b5443	t
c419fb54-e4aa-4ed2-ac6f-9fcd190ed931	9bcf133d-25e0-421a-9b53-3702f24b9da4	t
c419fb54-e4aa-4ed2-ac6f-9fcd190ed931	6d9433c3-e6f5-4bf9-849f-105e354fe7af	t
c419fb54-e4aa-4ed2-ac6f-9fcd190ed931	37c48668-3df6-4fb9-8009-d1867372a4ca	f
c419fb54-e4aa-4ed2-ac6f-9fcd190ed931	0915860d-fbbf-4e07-9de4-2eb4a8540de4	f
c419fb54-e4aa-4ed2-ac6f-9fcd190ed931	8193e8cb-ecfb-47c1-966c-cd7bf7d1a7c9	f
c419fb54-e4aa-4ed2-ac6f-9fcd190ed931	1b91ac1f-0c24-4c66-add7-3083de2b1fab	f
3706d3ff-4038-409b-83c6-eb36c273dc4a	7174b2a2-695c-4d32-b84b-b702c0fa3b00	t
3706d3ff-4038-409b-83c6-eb36c273dc4a	e037c9df-53a8-40a6-990b-420805196ca4	t
3706d3ff-4038-409b-83c6-eb36c273dc4a	a66e1e63-0c41-43ab-a557-d42a1e0e9179	t
3706d3ff-4038-409b-83c6-eb36c273dc4a	fc1ddff4-6764-418f-b4d4-1047530b5443	t
3706d3ff-4038-409b-83c6-eb36c273dc4a	9bcf133d-25e0-421a-9b53-3702f24b9da4	t
3706d3ff-4038-409b-83c6-eb36c273dc4a	6d9433c3-e6f5-4bf9-849f-105e354fe7af	t
3706d3ff-4038-409b-83c6-eb36c273dc4a	37c48668-3df6-4fb9-8009-d1867372a4ca	f
3706d3ff-4038-409b-83c6-eb36c273dc4a	0915860d-fbbf-4e07-9de4-2eb4a8540de4	f
3706d3ff-4038-409b-83c6-eb36c273dc4a	8193e8cb-ecfb-47c1-966c-cd7bf7d1a7c9	f
3706d3ff-4038-409b-83c6-eb36c273dc4a	1b91ac1f-0c24-4c66-add7-3083de2b1fab	f
\.


--
-- Data for Name: client_scope_role_mapping; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.client_scope_role_mapping (scope_id, role_id) FROM stdin;
1b91ac1f-0c24-4c66-add7-3083de2b1fab	f8595bbd-76f7-4c6a-878b-cdad5ce11527
\.


--
-- Data for Name: client_session; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.client_session (id, client_id, redirect_uri, state, "timestamp", session_id, auth_method, realm_id, auth_user_id, current_action) FROM stdin;
\.


--
-- Data for Name: client_session_auth_status; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.client_session_auth_status (authenticator, status, client_session) FROM stdin;
\.


--
-- Data for Name: client_session_note; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.client_session_note (name, value, client_session) FROM stdin;
\.


--
-- Data for Name: client_session_prot_mapper; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.client_session_prot_mapper (protocol_mapper_id, client_session) FROM stdin;
\.


--
-- Data for Name: client_session_role; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.client_session_role (role_id, client_session) FROM stdin;
\.


--
-- Data for Name: client_user_session_note; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.client_user_session_note (name, value, client_session) FROM stdin;
\.


--
-- Data for Name: component; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.component (id, name, parent_id, provider_id, provider_type, realm_id, sub_type) FROM stdin;
b9109e86-43b5-483c-9d38-db8a847763df	Trusted Hosts	a26b60a1-fefa-4c54-839e-6fb85147388e	trusted-hosts	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	a26b60a1-fefa-4c54-839e-6fb85147388e	anonymous
92dab921-a76d-44be-8332-c95b95220244	Consent Required	a26b60a1-fefa-4c54-839e-6fb85147388e	consent-required	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	a26b60a1-fefa-4c54-839e-6fb85147388e	anonymous
92e0c38d-418f-4c1f-9724-e2e3c61704a7	Full Scope Disabled	a26b60a1-fefa-4c54-839e-6fb85147388e	scope	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	a26b60a1-fefa-4c54-839e-6fb85147388e	anonymous
67356dec-b6db-4486-bdc3-756c14f876c4	Max Clients Limit	a26b60a1-fefa-4c54-839e-6fb85147388e	max-clients	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	a26b60a1-fefa-4c54-839e-6fb85147388e	anonymous
7b9ffa22-f2e4-4d5f-a9fc-44a1d6208a91	Allowed Protocol Mapper Types	a26b60a1-fefa-4c54-839e-6fb85147388e	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	a26b60a1-fefa-4c54-839e-6fb85147388e	anonymous
27fde29b-fb46-45ae-abde-cdb9b6b8d0bc	Allowed Client Scopes	a26b60a1-fefa-4c54-839e-6fb85147388e	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	a26b60a1-fefa-4c54-839e-6fb85147388e	anonymous
c87d5a4a-3a2b-42f8-9f49-27c5c57da795	Allowed Protocol Mapper Types	a26b60a1-fefa-4c54-839e-6fb85147388e	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	a26b60a1-fefa-4c54-839e-6fb85147388e	authenticated
6a977cb6-ec91-4cb0-aa6e-b58b8c7b6879	Allowed Client Scopes	a26b60a1-fefa-4c54-839e-6fb85147388e	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	a26b60a1-fefa-4c54-839e-6fb85147388e	authenticated
4c09c3ac-952d-4e10-8cd0-3705553c449e	rsa-generated	a26b60a1-fefa-4c54-839e-6fb85147388e	rsa-generated	org.keycloak.keys.KeyProvider	a26b60a1-fefa-4c54-839e-6fb85147388e	\N
749ced46-401d-4eae-bf6d-84f6c25f84d2	rsa-enc-generated	a26b60a1-fefa-4c54-839e-6fb85147388e	rsa-enc-generated	org.keycloak.keys.KeyProvider	a26b60a1-fefa-4c54-839e-6fb85147388e	\N
f1ae9529-9097-484a-b82f-3ccfcd1ed261	hmac-generated-hs512	a26b60a1-fefa-4c54-839e-6fb85147388e	hmac-generated	org.keycloak.keys.KeyProvider	a26b60a1-fefa-4c54-839e-6fb85147388e	\N
e6eda420-6ef0-4873-8cec-bebe9f9808ac	aes-generated	a26b60a1-fefa-4c54-839e-6fb85147388e	aes-generated	org.keycloak.keys.KeyProvider	a26b60a1-fefa-4c54-839e-6fb85147388e	\N
2ad56ff0-32c1-495d-84ef-b8d0d66e1e85	\N	a26b60a1-fefa-4c54-839e-6fb85147388e	declarative-user-profile	org.keycloak.userprofile.UserProfileProvider	a26b60a1-fefa-4c54-839e-6fb85147388e	\N
\.


--
-- Data for Name: component_config; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.component_config (id, component_id, name, value) FROM stdin;
d50dfbec-a7e9-4548-ba7b-93e85fc866ab	b9109e86-43b5-483c-9d38-db8a847763df	client-uris-must-match	true
ae65e5f9-ed4b-4b8d-841f-b5b2b636c507	b9109e86-43b5-483c-9d38-db8a847763df	host-sending-registration-request-must-match	true
4c42837e-7244-48d6-bfad-3886cac66787	c87d5a4a-3a2b-42f8-9f49-27c5c57da795	allowed-protocol-mapper-types	saml-user-property-mapper
556aff0c-913d-4a96-9c8f-d2e01d4609e3	c87d5a4a-3a2b-42f8-9f49-27c5c57da795	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
413e2ef3-0bed-4be9-94fd-9e6410890e9e	c87d5a4a-3a2b-42f8-9f49-27c5c57da795	allowed-protocol-mapper-types	oidc-address-mapper
952c1fe5-f949-4750-bf20-12bf15b6a582	c87d5a4a-3a2b-42f8-9f49-27c5c57da795	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
b1c23a5b-db38-4f76-afb9-379f220db737	c87d5a4a-3a2b-42f8-9f49-27c5c57da795	allowed-protocol-mapper-types	saml-role-list-mapper
565db2ba-219c-4cd0-9bda-5dc45a18a08b	c87d5a4a-3a2b-42f8-9f49-27c5c57da795	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
8794dab3-b7af-48a4-9052-6995b74cc56a	c87d5a4a-3a2b-42f8-9f49-27c5c57da795	allowed-protocol-mapper-types	oidc-full-name-mapper
14ebceb5-b7b2-4b10-a250-4c488d2280f9	c87d5a4a-3a2b-42f8-9f49-27c5c57da795	allowed-protocol-mapper-types	saml-user-attribute-mapper
f266e2df-6f04-4475-919f-70baa3f6341e	67356dec-b6db-4486-bdc3-756c14f876c4	max-clients	200
66545b22-c4bf-4f4c-bf34-0f3abcb5f222	7b9ffa22-f2e4-4d5f-a9fc-44a1d6208a91	allowed-protocol-mapper-types	saml-user-property-mapper
9ad08135-5758-4da3-8e41-42e76f337d3d	7b9ffa22-f2e4-4d5f-a9fc-44a1d6208a91	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
bf9e24de-2e71-46f9-b275-61d780b4230b	7b9ffa22-f2e4-4d5f-a9fc-44a1d6208a91	allowed-protocol-mapper-types	saml-user-attribute-mapper
0ab6b0a1-69d6-441c-aa4b-8020c6223b11	7b9ffa22-f2e4-4d5f-a9fc-44a1d6208a91	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
4337cbe3-b1e5-4be3-84fe-ab807dd71234	7b9ffa22-f2e4-4d5f-a9fc-44a1d6208a91	allowed-protocol-mapper-types	oidc-full-name-mapper
01b48bf7-1396-424e-8f55-ee97587c2401	7b9ffa22-f2e4-4d5f-a9fc-44a1d6208a91	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
a2dd2c7c-8e5f-449a-bba5-6ebdc6f48356	7b9ffa22-f2e4-4d5f-a9fc-44a1d6208a91	allowed-protocol-mapper-types	saml-role-list-mapper
ab6cc496-98e0-4a84-9e20-b413246483c0	7b9ffa22-f2e4-4d5f-a9fc-44a1d6208a91	allowed-protocol-mapper-types	oidc-address-mapper
65d26092-8150-4579-809b-7b859365e288	6a977cb6-ec91-4cb0-aa6e-b58b8c7b6879	allow-default-scopes	true
cfb0cfe7-d8aa-47c3-b415-77f1c786abfe	27fde29b-fb46-45ae-abde-cdb9b6b8d0bc	allow-default-scopes	true
a4d1c2ab-f4ea-4710-a6ab-95d4ad1298d3	4c09c3ac-952d-4e10-8cd0-3705553c449e	privateKey	MIIEpAIBAAKCAQEA1Zv6LOY8A7aqoP+qE0Tz9x2Gr5sdZudZ/icUIGe/t0H+HJPrbvx8qxWZ7GaUoAYJ1CXLBhiNv5TEnKlwOi6IoEA099Yb+Phh1KO2KzL9eFydTjpc1fXNS6nD8QOtFE0SwSi3LrgGCzawNbzDv1aOiLayutSlRijEW6dOxLGl/YYiEo6n1gMRPtx6Dem2NzxpDo48RLI/kt9pu2Qp3yx0NaMV1k1vFfqe4ydyYbjIUNoblV+irlwmxAD/jUBOEd6azF2zeDsGu7s2wa5gIjqMO7XEPbd3G0jz3uaY0ueZHJlx8inYqdN0FEGk24ntWWgskZ14OB4Gi5bvdbZPj1EldQIDAQABAoIBAChv9yvByBGx5lpFG/a64m5g/grHVAkTeeNVlYdO7KmuCgNx8ytXC+i9VZ69ipxCmGC7aNQ2GLtwV8oKf27cOUwQ65YRR8lZh/efqFBEPlynN7ZD8Sgl+J++uxOorP6/WnILmaXz+1zrFO+PVQUnRyNVZr9cmw8Nj6KEKTKuKKy1+4s+XPfowW+KTkgbamYBlZ7ABwj0ltt5SOW7jlv2JMycWzDLJZ8ZwP8xvcEIXsQnTBcQFtv2l1nZ4suGXmvC597gFDuoZa1ur6gF8/s3mJohvXm4k5prw4mRuK2eamcPDY7abxPevMGzhCYOZCD69Hoy5YBIGxyG3cje0uSWrw8CgYEA+XOiExYoaEBP+3htgY6G478rh6/eCJJy6PZN5IoL5O8BXlDhycs8ZrboU3dZGB6N6MzvZJe/LWqINXRxLYFUg3yjvPYaiPtekWVJoNtywgtp5HOL1bRswCXXjv6ZXnVkyKYs7tmHgrnl3nng17Yv5LoD0mifHuhIxnPtb4Sfc1MCgYEA2zd5zFKKAPEu3qtntJKsBBnrP05xUXwKkJNOvsFFj956BT9mtJuckreoWL948EQAJ+Fu6ckfNiZYaUBfP7hDnJp++je02wWs7AofRW/+9Z6HP06R02DTzgJjSyvYSGLF15eHy1H01RCF7xoUQWfaZS5Zfcv++V7SBH1XRHCi8xcCgYEA0ESP8/mTAP95B87TNtEFpA6PTHk0GtoS4JgMDpyHM7us288RxIZPxr49mLpTg4S3HMBFuynK7yM7182BVOne4uzkVDbxjp64pRH4+DlgRcx7u8YQ4PsDtSWjJHtDF49R9whvCXhK4IVO+4GsjM1KjWAVIs5A0/BCGpbdjTcgXYsCgYEAl6mY1XhhS+eQ0rLpa69x3OCFteWyVnqn4IBZoXWbh76W0tybVOa3+3Wevc+yfx+8r9qyXoIr2s3Kqv7DJxV3iXgF010I/eK+UQtruSGT1iCYV38nOoOp5cQXKCGsX+AeGlsWst7/sQzebJ6xVtLf8NKRTYv92k70o/CHmK0Iv38CgYBD2pYxzN+XyfPIUu/xCVwcxw67zucS6BtOUMSwNZU2qg+p+tBEAUlzmUXhTzC51Vrfo2zjMzGak/XUSQ8trAe5UPzE9VPYihe+bpSizs9XBc0l2Yyh4mgQKuazPh9Mut2AJC0xVbyRV/JZDHGaQICKjUQh3psFncPZZGeIjzfiLA==
f9d3a78f-3f2c-4b5a-823d-50abca2779a2	4c09c3ac-952d-4e10-8cd0-3705553c449e	keyUse	SIG
4109cfce-133b-47e2-9c5b-b7ea7f8aadab	4c09c3ac-952d-4e10-8cd0-3705553c449e	certificate	MIICmzCCAYMCBgGe8XvNwzANBgkqhkiG9w0BAQsFADARMQ8wDQYDVQQDDAZtYXN0ZXIwHhcNMjYwNjIyMjIzNjIzWhcNMzYwNjIyMjIzODAzWjARMQ8wDQYDVQQDDAZtYXN0ZXIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDVm/os5jwDtqqg/6oTRPP3HYavmx1m51n+JxQgZ7+3Qf4ck+tu/HyrFZnsZpSgBgnUJcsGGI2/lMScqXA6LoigQDT31hv4+GHUo7YrMv14XJ1OOlzV9c1LqcPxA60UTRLBKLcuuAYLNrA1vMO/Vo6ItrK61KVGKMRbp07EsaX9hiISjqfWAxE+3HoN6bY3PGkOjjxEsj+S32m7ZCnfLHQ1oxXWTW8V+p7jJ3JhuMhQ2huVX6KuXCbEAP+NQE4R3prMXbN4Owa7uzbBrmAiOow7tcQ9t3cbSPPe5pjS55kcmXHyKdip03QUQaTbie1ZaCyRnXg4HgaLlu91tk+PUSV1AgMBAAEwDQYJKoZIhvcNAQELBQADggEBAFskHh31Z8nc/PNzLj02dDMReN0go1YOMVBQy3MUDdJkqUloiGVd0OE85hjRdu7GTA8Rw+oiMQLh4/tNFKnyYZV90aASl6z0rIOYFcJNBbuc9mQ54Q4Q1Xr5ahfNWFjWyxebY4Sp8CoJmriARgXcUM8SFZQLklacbm6CBSQBIeoLTWow7MOSRlqeu9TVwZ92AuQeFszNMlOtbbkkh5o9MfYG9m2HRqiiVPctXEUbV9MDR7fO3SYuvA38z7d6mwoyYG8Bb7wyyXZItExx49E+64FX7H+BySvZQ1Cd59b93bVh6Am0W7OHKKwXISCcAV/XNdEwoGXuvmgjdvgjeu5GgIk=
0b206075-3f99-46e9-8e39-8652950dded6	4c09c3ac-952d-4e10-8cd0-3705553c449e	priority	100
d942d74a-a3f4-4889-8e84-93272e150f75	2ad56ff0-32c1-495d-84ef-b8d0d66e1e85	kc.user.profile.config	{"attributes":[{"name":"username","displayName":"${username}","validations":{"length":{"min":3,"max":255},"username-prohibited-characters":{},"up-username-not-idn-homograph":{}},"permissions":{"view":["admin","user"],"edit":["admin","user"]},"multivalued":false},{"name":"email","displayName":"${email}","validations":{"email":{},"length":{"max":255}},"permissions":{"view":["admin","user"],"edit":["admin","user"]},"multivalued":false},{"name":"firstName","displayName":"${firstName}","validations":{"length":{"max":255},"person-name-prohibited-characters":{}},"permissions":{"view":["admin","user"],"edit":["admin","user"]},"multivalued":false},{"name":"lastName","displayName":"${lastName}","validations":{"length":{"max":255},"person-name-prohibited-characters":{}},"permissions":{"view":["admin","user"],"edit":["admin","user"]},"multivalued":false}],"groups":[{"name":"user-metadata","displayHeader":"User metadata","displayDescription":"Attributes, which refer to user metadata"}]}
55c8b381-af0a-4e1e-ac55-7b7b15bc8cf7	f1ae9529-9097-484a-b82f-3ccfcd1ed261	priority	100
9bce58ac-e254-4bcd-bd8d-800aaff1dcf2	f1ae9529-9097-484a-b82f-3ccfcd1ed261	secret	8oddTZqGPUnO_xRMTtahaOqF0ZDidurWbdaTqJGWqV4t4fmd8NhkomgL7d5mzo0E79g4hGF5L_AeBpPZ6sMalaJD4oZTg8GqcmdzEtu2iHSnO-8Zbs1xBwUPzQIlrqX6m1GOb6l40SzFN6ct7u__txC87nSM3R5WH-g_-mwWgOg
eb4c5350-8cc1-4b67-9887-15a1b30675a6	f1ae9529-9097-484a-b82f-3ccfcd1ed261	algorithm	HS512
c3b8a5ce-7165-48e0-9c29-85f18b4540fd	f1ae9529-9097-484a-b82f-3ccfcd1ed261	kid	3947d16f-729d-4b81-9da5-f4d86c08e124
43a9a459-2d6a-45fb-b3bb-652380779f66	749ced46-401d-4eae-bf6d-84f6c25f84d2	certificate	MIICmzCCAYMCBgGe8XvOQjANBgkqhkiG9w0BAQsFADARMQ8wDQYDVQQDDAZtYXN0ZXIwHhcNMjYwNjIyMjIzNjIzWhcNMzYwNjIyMjIzODAzWjARMQ8wDQYDVQQDDAZtYXN0ZXIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCS58lWc6kU5Ar5X0h52jRtMg924/4Ey//Ewhnce48pBOwnTgU6mNadJMxJR1Fcay+87AYMUNsiXj2PsytZ4Hl41t7lCX/y2EahtnqMajhKuBI+gQhjoKo2v9bgZFifayzCm0qsh32RgyovNesMsS4aBTkpHfxcylkNxOEr49BWDCe9od7lIBw89TY3AF4P0/0zx1pl1l4mRIxBROAb+xb+TFbh/YE5zuTmO7LSzCwG4L57dO2mONB5A4isM+F+arvgCJSXAfSo/8nwWY2kk7pArlxFTNHhf0njX4+bqeqo95ISwWj2zjiMyODpHQV7cB97PnEO3GRqhv5nXdITzK1fAgMBAAEwDQYJKoZIhvcNAQELBQADggEBAA293p71AJll/xl6+Ep5STfNHF+TMLSYHv/Q8OTf5vSYlZgRlNG0iQisNwSjX2bxuC0QY+LMHrD5JaD6eXdHxVfA7VtshQnidrH6W/AUEpfZ/VvmJXRcPJUDTtsNQkh8ZOPIo+LbCryoDTc29aD5JbYx/up49AyWlpLLowmo3jZuPlMOljPrAdSumK4qEFc0CteIon1u1f19deP7OPT+Li0Mz8/XBWPRTxnxnVqPzFNr+WmzcnB4JhDomHwYnGicznQZWV9TIWLTVYhIVqCUA80Xu3UcwimWKex+BkpaVwv/S1VziK0NXxy8zfN3FKeus01neU3NmtKrM9EIDBa67ac=
2151b22c-ac1b-47c7-b711-5c7c94656ee8	749ced46-401d-4eae-bf6d-84f6c25f84d2	priority	100
7752a806-8359-481a-b354-3f7ceb3fb3be	749ced46-401d-4eae-bf6d-84f6c25f84d2	algorithm	RSA-OAEP
2866ba5c-4908-4c3f-9368-70472bf0f9d2	749ced46-401d-4eae-bf6d-84f6c25f84d2	keyUse	ENC
ab5720b2-c4eb-4eb2-92ff-15b8b4c45e8d	749ced46-401d-4eae-bf6d-84f6c25f84d2	privateKey	MIIEogIBAAKCAQEAkufJVnOpFOQK+V9Iedo0bTIPduP+BMv/xMIZ3HuPKQTsJ04FOpjWnSTMSUdRXGsvvOwGDFDbIl49j7MrWeB5eNbe5Ql/8thGobZ6jGo4SrgSPoEIY6CqNr/W4GRYn2sswptKrId9kYMqLzXrDLEuGgU5KR38XMpZDcThK+PQVgwnvaHe5SAcPPU2NwBeD9P9M8daZdZeJkSMQUTgG/sW/kxW4f2BOc7k5juy0swsBuC+e3TtpjjQeQOIrDPhfmq74AiUlwH0qP/J8FmNpJO6QK5cRUzR4X9J41+Pm6nqqPeSEsFo9s44jMjg6R0Fe3Afez5xDtxkaob+Z13SE8ytXwIDAQABAoH/YfFppDN+PL2sbo0rsa6YrLILFvmZrN8KJ4GD7jUcTRyf49bxthkspK66jgbW5AwvElEnKyqGEkV8sYhP9PHaFgbet8ELQMZyFgahOear9Bgv+58wgeGsCOjW1pKgJ2cYsfI+WscSqgSz/PBF67XkUylStST4tgBe55q1GNxMNcIoJAEJ1Ro9gP7gGScK2Lc6rOhxNZyL/ca2ZOywqK+dByE7IzObzH6EdPpbIDpxGbjUhLh8DVRYf/ZkkfUfk1DuPjiPYh4KRz53m9aO3lZEm4VLuQIgrcD870Khip1EJqb7m9+mLF0K7uKAZeBdRccPfwf2NE3Sn+FkqiWyEgY1AoGBAMirV65mToGum7S8Rkfv1KAQWBDdcvMHmKjFuPYoCImEuJRpi2Vfocp6pu5JyG0ORgFELY4qkbXp3l2wIHFk5goPbFtxb/Gtpcscn4+zDuK2X6nwj3EsyQ1XlWaEbtVnY1IL5KHsb39KSihAXcCY+AA1rzDe/6q2qmbr+Vr14ogbAoGBALtpaKAWkKpKesEjPRPdpHguTjG7Fod5Y3K/FX2lrkhTpovR9Qn0nuPOnOB6Xp6TZw3T1SUwK9tGbJWJEXmjO0hpFyyq7GOqQr2OBTMv21QPWRDQlGzxQHd59qzvfPeWw1xHUFAwHNYfOh2uq7TOo6BXkQCk/n83mcWOATf2Z4wNAoGAav+57BtPJyT0j4WIsBj4tjSg0LVT8rSNOQjc3BxymOk1BqXUl0RL38xQsGSVQ1lGCKzS4ahfM7G1SR193xje9GRO8d9lwmdGLSxhBF2ExWxbTCEiS0WHGt8loZliA9ZyBjCjQ5fvx97T9eyEUQr/yhTWCmgNyXhHGkQfHNpZZRsCgYEAgRP+nZQtGzylA3UT0iTr7GJoNNRYlgJDPnrhgGKmgOYsZUy8apjy/pAFeI6PsMRxTBLEURK2ghYlH3ECeja01BCdh4RJv/M6eHfimPizJVhUzcH7GHWpIyD7huyDs7tA3sO3SyN4GPn0+xCc7rEL/ZmSI1GAf3p6DJjbugGaG9kCgYEAj7tPARTqNZxbRoZvi6is1lrLg4o62lrNceODuo4/+uhKyJ+Wjp4SwAre2WpTM4nKodqGEEeAhEZxTEClw3jbB/6GPvTB06miN4lo8fBe87Wm/8vMkeDn11mBSWt53XnRE6MgPzs60Sri6zukfC9oRT9RoL4GZX2RyvZkQtj9bUM=
8fe48fdf-3902-47a4-8d84-b01ea0aeea21	e6eda420-6ef0-4873-8cec-bebe9f9808ac	priority	100
e3a0cd2c-ce1a-4bff-8b88-a62ea0e02c6f	e6eda420-6ef0-4873-8cec-bebe9f9808ac	kid	0553b1b0-3fb0-4718-8f9b-e697877a3c7a
11c6f0f0-88fc-4504-bd8d-42ae499b1244	e6eda420-6ef0-4873-8cec-bebe9f9808ac	secret	Z2jxhgu9ZdAP4aGuFN_OyQ
\.


--
-- Data for Name: composite_role; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.composite_role (composite, child_role) FROM stdin;
5e20b5b3-6602-42ae-9989-b41f67276069	2170a162-6ff7-4849-b5d7-4902543ef539
5e20b5b3-6602-42ae-9989-b41f67276069	b0c2e19a-3c67-465e-86de-f2fe4a43e6a5
5e20b5b3-6602-42ae-9989-b41f67276069	5be9a6f1-b1e0-4e4b-803c-0d61a990ffed
5e20b5b3-6602-42ae-9989-b41f67276069	a90e3c06-b660-41da-b320-ac233810ad1f
5e20b5b3-6602-42ae-9989-b41f67276069	54f92d94-1090-4e3e-9679-7927df44286c
5e20b5b3-6602-42ae-9989-b41f67276069	31819b99-ef09-43aa-ab25-3ae8532cbe44
5e20b5b3-6602-42ae-9989-b41f67276069	a1c9b878-738e-4ae3-b1e4-81191294d552
5e20b5b3-6602-42ae-9989-b41f67276069	d0028538-76ac-4d3b-b0e8-0d6a225dbd15
5e20b5b3-6602-42ae-9989-b41f67276069	d7e85bbb-ee3d-48e6-ba3a-f87f25182cd0
5e20b5b3-6602-42ae-9989-b41f67276069	fe79c667-f9f0-44b7-a819-3e5fcbb24a9e
5e20b5b3-6602-42ae-9989-b41f67276069	403cb92f-e0da-4b92-9cb7-bf9079132b3c
5e20b5b3-6602-42ae-9989-b41f67276069	7f5f5485-b587-49ad-9c43-8c187b48f1a3
5e20b5b3-6602-42ae-9989-b41f67276069	5f55b3d9-19c5-4bb6-b99c-219636f93df5
5e20b5b3-6602-42ae-9989-b41f67276069	4ba38ffb-cb3e-406b-9ba7-851c39420855
5e20b5b3-6602-42ae-9989-b41f67276069	59b598dd-064d-40f0-a19c-962c222be790
5e20b5b3-6602-42ae-9989-b41f67276069	11a0a4ce-a6c2-410e-beb4-4e983787bf74
5e20b5b3-6602-42ae-9989-b41f67276069	60f11f13-63bb-4261-ab03-9608419ca327
5e20b5b3-6602-42ae-9989-b41f67276069	4613c004-9a1a-458f-9db9-f2b5591c5743
2deb75a4-0e6d-4aff-b4a3-a17018b88ac2	3929385f-5f67-4a6b-8f6e-ba1c0db8e2a9
54f92d94-1090-4e3e-9679-7927df44286c	11a0a4ce-a6c2-410e-beb4-4e983787bf74
a90e3c06-b660-41da-b320-ac233810ad1f	4613c004-9a1a-458f-9db9-f2b5591c5743
a90e3c06-b660-41da-b320-ac233810ad1f	59b598dd-064d-40f0-a19c-962c222be790
2deb75a4-0e6d-4aff-b4a3-a17018b88ac2	316c18db-5809-4040-96a9-fd42e7182823
316c18db-5809-4040-96a9-fd42e7182823	ac56fc1e-2ed6-447e-8462-a02425cb86aa
f3102c46-3486-437f-8080-7f07f14c09b5	bdc82e13-a7c2-4862-8e46-30b0a082ee9e
5e20b5b3-6602-42ae-9989-b41f67276069	22d65474-ca0e-43bd-8ddd-fcda9a128235
2deb75a4-0e6d-4aff-b4a3-a17018b88ac2	f8595bbd-76f7-4c6a-878b-cdad5ce11527
2deb75a4-0e6d-4aff-b4a3-a17018b88ac2	4f1f50e3-1e8d-4790-97e4-d9445d98313c
\.


--
-- Data for Name: credential; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.credential (id, salt, type, user_id, created_date, user_label, secret_data, credential_data, priority) FROM stdin;
dca97622-8698-4511-b371-dd7e96372d97	\N	password	803396c1-4e48-461b-a89a-6fc8791941cf	1782167883633	\N	{"value":"UeKuxihqDZor5edm4CldHYau+NRcVPAy/BVAVsC9XGA=","salt":"y9Gm2/DHWhgZNCOo0yGwIg==","additionalParameters":{}}	{"hashIterations":5,"algorithm":"argon2","additionalParameters":{"hashLength":["32"],"memory":["7168"],"type":["id"],"version":["1.3"],"parallelism":["1"]}}	10
\.


--
-- Data for Name: databasechangelog; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.databasechangelog (id, author, filename, dateexecuted, orderexecuted, exectype, md5sum, description, comments, tag, liquibase, contexts, labels, deployment_id) FROM stdin;
1.0.0.Final-KEYCLOAK-5461	sthorger@redhat.com	META-INF/jpa-changelog-1.0.0.Final.xml	2026-06-22 22:37:57.687623	1	EXECUTED	9:6f1016664e21e16d26517a4418f5e3df	createTable tableName=APPLICATION_DEFAULT_ROLES; createTable tableName=CLIENT; createTable tableName=CLIENT_SESSION; createTable tableName=CLIENT_SESSION_ROLE; createTable tableName=COMPOSITE_ROLE; createTable tableName=CREDENTIAL; createTable tab...		\N	4.25.1	\N	\N	2167877090
1.0.0.Final-KEYCLOAK-5461	sthorger@redhat.com	META-INF/db2-jpa-changelog-1.0.0.Final.xml	2026-06-22 22:37:57.701193	2	MARK_RAN	9:828775b1596a07d1200ba1d49e5e3941	createTable tableName=APPLICATION_DEFAULT_ROLES; createTable tableName=CLIENT; createTable tableName=CLIENT_SESSION; createTable tableName=CLIENT_SESSION_ROLE; createTable tableName=COMPOSITE_ROLE; createTable tableName=CREDENTIAL; createTable tab...		\N	4.25.1	\N	\N	2167877090
1.1.0.Beta1	sthorger@redhat.com	META-INF/jpa-changelog-1.1.0.Beta1.xml	2026-06-22 22:37:57.771681	3	EXECUTED	9:5f090e44a7d595883c1fb61f4b41fd38	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=CLIENT_ATTRIBUTES; createTable tableName=CLIENT_SESSION_NOTE; createTable tableName=APP_NODE_REGISTRATIONS; addColumn table...		\N	4.25.1	\N	\N	2167877090
1.1.0.Final	sthorger@redhat.com	META-INF/jpa-changelog-1.1.0.Final.xml	2026-06-22 22:37:57.783066	4	EXECUTED	9:c07e577387a3d2c04d1adc9aaad8730e	renameColumn newColumnName=EVENT_TIME, oldColumnName=TIME, tableName=EVENT_ENTITY		\N	4.25.1	\N	\N	2167877090
1.2.0.Beta1	psilva@redhat.com	META-INF/jpa-changelog-1.2.0.Beta1.xml	2026-06-22 22:37:57.984986	5	EXECUTED	9:b68ce996c655922dbcd2fe6b6ae72686	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=PROTOCOL_MAPPER; createTable tableName=PROTOCOL_MAPPER_CONFIG; createTable tableName=...		\N	4.25.1	\N	\N	2167877090
1.2.0.Beta1	psilva@redhat.com	META-INF/db2-jpa-changelog-1.2.0.Beta1.xml	2026-06-22 22:37:57.993632	6	MARK_RAN	9:543b5c9989f024fe35c6f6c5a97de88e	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=PROTOCOL_MAPPER; createTable tableName=PROTOCOL_MAPPER_CONFIG; createTable tableName=...		\N	4.25.1	\N	\N	2167877090
1.2.0.RC1	bburke@redhat.com	META-INF/jpa-changelog-1.2.0.CR1.xml	2026-06-22 22:37:58.258896	7	EXECUTED	9:765afebbe21cf5bbca048e632df38336	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=MIGRATION_MODEL; createTable tableName=IDENTITY_P...		\N	4.25.1	\N	\N	2167877090
1.2.0.RC1	bburke@redhat.com	META-INF/db2-jpa-changelog-1.2.0.CR1.xml	2026-06-22 22:37:58.276416	8	MARK_RAN	9:db4a145ba11a6fdaefb397f6dbf829a1	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=MIGRATION_MODEL; createTable tableName=IDENTITY_P...		\N	4.25.1	\N	\N	2167877090
1.2.0.Final	keycloak	META-INF/jpa-changelog-1.2.0.Final.xml	2026-06-22 22:37:58.284607	9	EXECUTED	9:9d05c7be10cdb873f8bcb41bc3a8ab23	update tableName=CLIENT; update tableName=CLIENT; update tableName=CLIENT		\N	4.25.1	\N	\N	2167877090
1.3.0	bburke@redhat.com	META-INF/jpa-changelog-1.3.0.xml	2026-06-22 22:37:58.44254	10	EXECUTED	9:18593702353128d53111f9b1ff0b82b8	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=ADMI...		\N	4.25.1	\N	\N	2167877090
1.4.0	bburke@redhat.com	META-INF/jpa-changelog-1.4.0.xml	2026-06-22 22:37:58.536437	11	EXECUTED	9:6122efe5f090e41a85c0f1c9e52cbb62	delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...		\N	4.25.1	\N	\N	2167877090
1.4.0	bburke@redhat.com	META-INF/db2-jpa-changelog-1.4.0.xml	2026-06-22 22:37:58.542953	12	MARK_RAN	9:e1ff28bf7568451453f844c5d54bb0b5	delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...		\N	4.25.1	\N	\N	2167877090
1.5.0	bburke@redhat.com	META-INF/jpa-changelog-1.5.0.xml	2026-06-22 22:37:58.563583	13	EXECUTED	9:7af32cd8957fbc069f796b61217483fd	delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...		\N	4.25.1	\N	\N	2167877090
1.6.1_from15	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2026-06-22 22:37:58.602693	14	EXECUTED	9:6005e15e84714cd83226bf7879f54190	addColumn tableName=REALM; addColumn tableName=KEYCLOAK_ROLE; addColumn tableName=CLIENT; createTable tableName=OFFLINE_USER_SESSION; createTable tableName=OFFLINE_CLIENT_SESSION; addPrimaryKey constraintName=CONSTRAINT_OFFL_US_SES_PK2, tableName=...		\N	4.25.1	\N	\N	2167877090
1.6.1_from16-pre	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2026-06-22 22:37:58.633598	15	MARK_RAN	9:bf656f5a2b055d07f314431cae76f06c	delete tableName=OFFLINE_CLIENT_SESSION; delete tableName=OFFLINE_USER_SESSION		\N	4.25.1	\N	\N	2167877090
1.6.1_from16	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2026-06-22 22:37:58.638273	16	MARK_RAN	9:f8dadc9284440469dcf71e25ca6ab99b	dropPrimaryKey constraintName=CONSTRAINT_OFFLINE_US_SES_PK, tableName=OFFLINE_USER_SESSION; dropPrimaryKey constraintName=CONSTRAINT_OFFLINE_CL_SES_PK, tableName=OFFLINE_CLIENT_SESSION; addColumn tableName=OFFLINE_USER_SESSION; update tableName=OF...		\N	4.25.1	\N	\N	2167877090
1.6.1	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2026-06-22 22:37:58.642695	17	EXECUTED	9:d41d8cd98f00b204e9800998ecf8427e	empty		\N	4.25.1	\N	\N	2167877090
1.7.0	bburke@redhat.com	META-INF/jpa-changelog-1.7.0.xml	2026-06-22 22:37:58.707874	18	EXECUTED	9:3368ff0be4c2855ee2dd9ca813b38d8e	createTable tableName=KEYCLOAK_GROUP; createTable tableName=GROUP_ROLE_MAPPING; createTable tableName=GROUP_ATTRIBUTE; createTable tableName=USER_GROUP_MEMBERSHIP; createTable tableName=REALM_DEFAULT_GROUPS; addColumn tableName=IDENTITY_PROVIDER; ...		\N	4.25.1	\N	\N	2167877090
1.8.0	mposolda@redhat.com	META-INF/jpa-changelog-1.8.0.xml	2026-06-22 22:37:58.800766	19	EXECUTED	9:8ac2fb5dd030b24c0570a763ed75ed20	addColumn tableName=IDENTITY_PROVIDER; createTable tableName=CLIENT_TEMPLATE; createTable tableName=CLIENT_TEMPLATE_ATTRIBUTES; createTable tableName=TEMPLATE_SCOPE_MAPPING; dropNotNullConstraint columnName=CLIENT_ID, tableName=PROTOCOL_MAPPER; ad...		\N	4.25.1	\N	\N	2167877090
1.8.0-2	keycloak	META-INF/jpa-changelog-1.8.0.xml	2026-06-22 22:37:58.809691	20	EXECUTED	9:f91ddca9b19743db60e3057679810e6c	dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; update tableName=CREDENTIAL		\N	4.25.1	\N	\N	2167877090
1.8.0	mposolda@redhat.com	META-INF/db2-jpa-changelog-1.8.0.xml	2026-06-22 22:37:58.815718	21	MARK_RAN	9:831e82914316dc8a57dc09d755f23c51	addColumn tableName=IDENTITY_PROVIDER; createTable tableName=CLIENT_TEMPLATE; createTable tableName=CLIENT_TEMPLATE_ATTRIBUTES; createTable tableName=TEMPLATE_SCOPE_MAPPING; dropNotNullConstraint columnName=CLIENT_ID, tableName=PROTOCOL_MAPPER; ad...		\N	4.25.1	\N	\N	2167877090
1.8.0-2	keycloak	META-INF/db2-jpa-changelog-1.8.0.xml	2026-06-22 22:37:58.81993	22	MARK_RAN	9:f91ddca9b19743db60e3057679810e6c	dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; update tableName=CREDENTIAL		\N	4.25.1	\N	\N	2167877090
1.9.0	mposolda@redhat.com	META-INF/jpa-changelog-1.9.0.xml	2026-06-22 22:37:58.852506	23	EXECUTED	9:bc3d0f9e823a69dc21e23e94c7a94bb1	update tableName=REALM; update tableName=REALM; update tableName=REALM; update tableName=REALM; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=REALM; update tableName=REALM; customChange; dr...		\N	4.25.1	\N	\N	2167877090
1.9.1	keycloak	META-INF/jpa-changelog-1.9.1.xml	2026-06-22 22:37:58.866535	24	EXECUTED	9:c9999da42f543575ab790e76439a2679	modifyDataType columnName=PRIVATE_KEY, tableName=REALM; modifyDataType columnName=PUBLIC_KEY, tableName=REALM; modifyDataType columnName=CERTIFICATE, tableName=REALM		\N	4.25.1	\N	\N	2167877090
1.9.1	keycloak	META-INF/db2-jpa-changelog-1.9.1.xml	2026-06-22 22:37:58.871127	25	MARK_RAN	9:0d6c65c6f58732d81569e77b10ba301d	modifyDataType columnName=PRIVATE_KEY, tableName=REALM; modifyDataType columnName=CERTIFICATE, tableName=REALM		\N	4.25.1	\N	\N	2167877090
1.9.2	keycloak	META-INF/jpa-changelog-1.9.2.xml	2026-06-22 22:37:59.010542	26	EXECUTED	9:fc576660fc016ae53d2d4778d84d86d0	createIndex indexName=IDX_USER_EMAIL, tableName=USER_ENTITY; createIndex indexName=IDX_USER_ROLE_MAPPING, tableName=USER_ROLE_MAPPING; createIndex indexName=IDX_USER_GROUP_MAPPING, tableName=USER_GROUP_MEMBERSHIP; createIndex indexName=IDX_USER_CO...		\N	4.25.1	\N	\N	2167877090
authz-2.0.0	psilva@redhat.com	META-INF/jpa-changelog-authz-2.0.0.xml	2026-06-22 22:37:59.208483	27	EXECUTED	9:43ed6b0da89ff77206289e87eaa9c024	createTable tableName=RESOURCE_SERVER; addPrimaryKey constraintName=CONSTRAINT_FARS, tableName=RESOURCE_SERVER; addUniqueConstraint constraintName=UK_AU8TT6T700S9V50BU18WS5HA6, tableName=RESOURCE_SERVER; createTable tableName=RESOURCE_SERVER_RESOU...		\N	4.25.1	\N	\N	2167877090
authz-2.5.1	psilva@redhat.com	META-INF/jpa-changelog-authz-2.5.1.xml	2026-06-22 22:37:59.214596	28	EXECUTED	9:44bae577f551b3738740281eceb4ea70	update tableName=RESOURCE_SERVER_POLICY		\N	4.25.1	\N	\N	2167877090
2.1.0-KEYCLOAK-5461	bburke@redhat.com	META-INF/jpa-changelog-2.1.0.xml	2026-06-22 22:37:59.429472	29	EXECUTED	9:bd88e1f833df0420b01e114533aee5e8	createTable tableName=BROKER_LINK; createTable tableName=FED_USER_ATTRIBUTE; createTable tableName=FED_USER_CONSENT; createTable tableName=FED_USER_CONSENT_ROLE; createTable tableName=FED_USER_CONSENT_PROT_MAPPER; createTable tableName=FED_USER_CR...		\N	4.25.1	\N	\N	2167877090
2.2.0	bburke@redhat.com	META-INF/jpa-changelog-2.2.0.xml	2026-06-22 22:37:59.461033	30	EXECUTED	9:a7022af5267f019d020edfe316ef4371	addColumn tableName=ADMIN_EVENT_ENTITY; createTable tableName=CREDENTIAL_ATTRIBUTE; createTable tableName=FED_CREDENTIAL_ATTRIBUTE; modifyDataType columnName=VALUE, tableName=CREDENTIAL; addForeignKeyConstraint baseTableName=FED_CREDENTIAL_ATTRIBU...		\N	4.25.1	\N	\N	2167877090
2.3.0	bburke@redhat.com	META-INF/jpa-changelog-2.3.0.xml	2026-06-22 22:37:59.495539	31	EXECUTED	9:fc155c394040654d6a79227e56f5e25a	createTable tableName=FEDERATED_USER; addPrimaryKey constraintName=CONSTR_FEDERATED_USER, tableName=FEDERATED_USER; dropDefaultValue columnName=TOTP, tableName=USER_ENTITY; dropColumn columnName=TOTP, tableName=USER_ENTITY; addColumn tableName=IDE...		\N	4.25.1	\N	\N	2167877090
2.4.0	bburke@redhat.com	META-INF/jpa-changelog-2.4.0.xml	2026-06-22 22:37:59.504588	32	EXECUTED	9:eac4ffb2a14795e5dc7b426063e54d88	customChange		\N	4.25.1	\N	\N	2167877090
2.5.0	bburke@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2026-06-22 22:37:59.514398	33	EXECUTED	9:54937c05672568c4c64fc9524c1e9462	customChange; modifyDataType columnName=USER_ID, tableName=OFFLINE_USER_SESSION		\N	4.25.1	\N	\N	2167877090
2.5.0-unicode-oracle	hmlnarik@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2026-06-22 22:37:59.521213	34	MARK_RAN	9:3a32bace77c84d7678d035a7f5a8084e	modifyDataType columnName=DESCRIPTION, tableName=AUTHENTICATION_FLOW; modifyDataType columnName=DESCRIPTION, tableName=CLIENT_TEMPLATE; modifyDataType columnName=DESCRIPTION, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=DESCRIPTION,...		\N	4.25.1	\N	\N	2167877090
2.5.0-unicode-other-dbs	hmlnarik@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2026-06-22 22:37:59.604693	35	EXECUTED	9:33d72168746f81f98ae3a1e8e0ca3554	modifyDataType columnName=DESCRIPTION, tableName=AUTHENTICATION_FLOW; modifyDataType columnName=DESCRIPTION, tableName=CLIENT_TEMPLATE; modifyDataType columnName=DESCRIPTION, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=DESCRIPTION,...		\N	4.25.1	\N	\N	2167877090
2.5.0-duplicate-email-support	slawomir@dabek.name	META-INF/jpa-changelog-2.5.0.xml	2026-06-22 22:37:59.822935	36	EXECUTED	9:61b6d3d7a4c0e0024b0c839da283da0c	addColumn tableName=REALM		\N	4.25.1	\N	\N	2167877090
2.5.0-unique-group-names	hmlnarik@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2026-06-22 22:37:59.842375	37	EXECUTED	9:8dcac7bdf7378e7d823cdfddebf72fda	addUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP		\N	4.25.1	\N	\N	2167877090
2.5.1	bburke@redhat.com	META-INF/jpa-changelog-2.5.1.xml	2026-06-22 22:37:59.854619	38	EXECUTED	9:a2b870802540cb3faa72098db5388af3	addColumn tableName=FED_USER_CONSENT		\N	4.25.1	\N	\N	2167877090
3.0.0	bburke@redhat.com	META-INF/jpa-changelog-3.0.0.xml	2026-06-22 22:37:59.866759	39	EXECUTED	9:132a67499ba24bcc54fb5cbdcfe7e4c0	addColumn tableName=IDENTITY_PROVIDER		\N	4.25.1	\N	\N	2167877090
3.2.0-fix	keycloak	META-INF/jpa-changelog-3.2.0.xml	2026-06-22 22:37:59.872793	40	MARK_RAN	9:938f894c032f5430f2b0fafb1a243462	addNotNullConstraint columnName=REALM_ID, tableName=CLIENT_INITIAL_ACCESS		\N	4.25.1	\N	\N	2167877090
3.2.0-fix-with-keycloak-5416	keycloak	META-INF/jpa-changelog-3.2.0.xml	2026-06-22 22:37:59.879777	41	MARK_RAN	9:845c332ff1874dc5d35974b0babf3006	dropIndex indexName=IDX_CLIENT_INIT_ACC_REALM, tableName=CLIENT_INITIAL_ACCESS; addNotNullConstraint columnName=REALM_ID, tableName=CLIENT_INITIAL_ACCESS; createIndex indexName=IDX_CLIENT_INIT_ACC_REALM, tableName=CLIENT_INITIAL_ACCESS		\N	4.25.1	\N	\N	2167877090
3.2.0-fix-offline-sessions	hmlnarik	META-INF/jpa-changelog-3.2.0.xml	2026-06-22 22:37:59.888444	42	EXECUTED	9:fc86359c079781adc577c5a217e4d04c	customChange		\N	4.25.1	\N	\N	2167877090
3.2.0-fixed	keycloak	META-INF/jpa-changelog-3.2.0.xml	2026-06-22 22:38:00.331155	43	EXECUTED	9:59a64800e3c0d09b825f8a3b444fa8f4	addColumn tableName=REALM; dropPrimaryKey constraintName=CONSTRAINT_OFFL_CL_SES_PK2, tableName=OFFLINE_CLIENT_SESSION; dropColumn columnName=CLIENT_SESSION_ID, tableName=OFFLINE_CLIENT_SESSION; addPrimaryKey constraintName=CONSTRAINT_OFFL_CL_SES_P...		\N	4.25.1	\N	\N	2167877090
3.3.0	keycloak	META-INF/jpa-changelog-3.3.0.xml	2026-06-22 22:38:00.365148	44	EXECUTED	9:d48d6da5c6ccf667807f633fe489ce88	addColumn tableName=USER_ENTITY		\N	4.25.1	\N	\N	2167877090
authz-3.4.0.CR1-resource-server-pk-change-part1	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2026-06-22 22:38:00.377031	45	EXECUTED	9:dde36f7973e80d71fceee683bc5d2951	addColumn tableName=RESOURCE_SERVER_POLICY; addColumn tableName=RESOURCE_SERVER_RESOURCE; addColumn tableName=RESOURCE_SERVER_SCOPE		\N	4.25.1	\N	\N	2167877090
authz-3.4.0.CR1-resource-server-pk-change-part2-KEYCLOAK-6095	hmlnarik@redhat.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2026-06-22 22:38:00.386863	46	EXECUTED	9:b855e9b0a406b34fa323235a0cf4f640	customChange		\N	4.25.1	\N	\N	2167877090
authz-3.4.0.CR1-resource-server-pk-change-part3-fixed	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2026-06-22 22:38:00.391348	47	MARK_RAN	9:51abbacd7b416c50c4421a8cabf7927e	dropIndex indexName=IDX_RES_SERV_POL_RES_SERV, tableName=RESOURCE_SERVER_POLICY; dropIndex indexName=IDX_RES_SRV_RES_RES_SRV, tableName=RESOURCE_SERVER_RESOURCE; dropIndex indexName=IDX_RES_SRV_SCOPE_RES_SRV, tableName=RESOURCE_SERVER_SCOPE		\N	4.25.1	\N	\N	2167877090
authz-3.4.0.CR1-resource-server-pk-change-part3-fixed-nodropindex	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2026-06-22 22:38:00.47038	48	EXECUTED	9:bdc99e567b3398bac83263d375aad143	addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, tableName=RESOURCE_SERVER_POLICY; addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, tableName=RESOURCE_SERVER_RESOURCE; addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, ...		\N	4.25.1	\N	\N	2167877090
authn-3.4.0.CR1-refresh-token-max-reuse	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2026-06-22 22:38:00.487014	49	EXECUTED	9:d198654156881c46bfba39abd7769e69	addColumn tableName=REALM		\N	4.25.1	\N	\N	2167877090
3.4.0	keycloak	META-INF/jpa-changelog-3.4.0.xml	2026-06-22 22:38:00.618797	50	EXECUTED	9:cfdd8736332ccdd72c5256ccb42335db	addPrimaryKey constraintName=CONSTRAINT_REALM_DEFAULT_ROLES, tableName=REALM_DEFAULT_ROLES; addPrimaryKey constraintName=CONSTRAINT_COMPOSITE_ROLE, tableName=COMPOSITE_ROLE; addPrimaryKey constraintName=CONSTR_REALM_DEFAULT_GROUPS, tableName=REALM...		\N	4.25.1	\N	\N	2167877090
3.4.0-KEYCLOAK-5230	hmlnarik@redhat.com	META-INF/jpa-changelog-3.4.0.xml	2026-06-22 22:38:00.70829	51	EXECUTED	9:7c84de3d9bd84d7f077607c1a4dcb714	createIndex indexName=IDX_FU_ATTRIBUTE, tableName=FED_USER_ATTRIBUTE; createIndex indexName=IDX_FU_CONSENT, tableName=FED_USER_CONSENT; createIndex indexName=IDX_FU_CONSENT_RU, tableName=FED_USER_CONSENT; createIndex indexName=IDX_FU_CREDENTIAL, t...		\N	4.25.1	\N	\N	2167877090
3.4.1	psilva@redhat.com	META-INF/jpa-changelog-3.4.1.xml	2026-06-22 22:38:00.717486	52	EXECUTED	9:5a6bb36cbefb6a9d6928452c0852af2d	modifyDataType columnName=VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.25.1	\N	\N	2167877090
3.4.2	keycloak	META-INF/jpa-changelog-3.4.2.xml	2026-06-22 22:38:00.723158	53	EXECUTED	9:8f23e334dbc59f82e0a328373ca6ced0	update tableName=REALM		\N	4.25.1	\N	\N	2167877090
3.4.2-KEYCLOAK-5172	mkanis@redhat.com	META-INF/jpa-changelog-3.4.2.xml	2026-06-22 22:38:00.727579	54	EXECUTED	9:9156214268f09d970cdf0e1564d866af	update tableName=CLIENT		\N	4.25.1	\N	\N	2167877090
4.0.0-KEYCLOAK-6335	bburke@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2026-06-22 22:38:00.74291	55	EXECUTED	9:db806613b1ed154826c02610b7dbdf74	createTable tableName=CLIENT_AUTH_FLOW_BINDINGS; addPrimaryKey constraintName=C_CLI_FLOW_BIND, tableName=CLIENT_AUTH_FLOW_BINDINGS		\N	4.25.1	\N	\N	2167877090
4.0.0-CLEANUP-UNUSED-TABLE	bburke@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2026-06-22 22:38:00.755099	56	EXECUTED	9:229a041fb72d5beac76bb94a5fa709de	dropTable tableName=CLIENT_IDENTITY_PROV_MAPPING		\N	4.25.1	\N	\N	2167877090
4.0.0-KEYCLOAK-6228	bburke@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2026-06-22 22:38:00.811213	57	EXECUTED	9:079899dade9c1e683f26b2aa9ca6ff04	dropUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHOGM8UEWRT, tableName=USER_CONSENT; dropNotNullConstraint columnName=CLIENT_ID, tableName=USER_CONSENT; addColumn tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHO...		\N	4.25.1	\N	\N	2167877090
4.0.0-KEYCLOAK-5579-fixed	mposolda@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2026-06-22 22:38:00.99203	58	EXECUTED	9:139b79bcbbfe903bb1c2d2a4dbf001d9	dropForeignKeyConstraint baseTableName=CLIENT_TEMPLATE_ATTRIBUTES, constraintName=FK_CL_TEMPL_ATTR_TEMPL; renameTable newTableName=CLIENT_SCOPE_ATTRIBUTES, oldTableName=CLIENT_TEMPLATE_ATTRIBUTES; renameColumn newColumnName=SCOPE_ID, oldColumnName...		\N	4.25.1	\N	\N	2167877090
authz-4.0.0.CR1	psilva@redhat.com	META-INF/jpa-changelog-authz-4.0.0.CR1.xml	2026-06-22 22:38:01.040126	59	EXECUTED	9:b55738ad889860c625ba2bf483495a04	createTable tableName=RESOURCE_SERVER_PERM_TICKET; addPrimaryKey constraintName=CONSTRAINT_FAPMT, tableName=RESOURCE_SERVER_PERM_TICKET; addForeignKeyConstraint baseTableName=RESOURCE_SERVER_PERM_TICKET, constraintName=FK_FRSRHO213XCX4WNKOG82SSPMT...		\N	4.25.1	\N	\N	2167877090
authz-4.0.0.Beta3	psilva@redhat.com	META-INF/jpa-changelog-authz-4.0.0.Beta3.xml	2026-06-22 22:38:01.050295	60	EXECUTED	9:e0057eac39aa8fc8e09ac6cfa4ae15fe	addColumn tableName=RESOURCE_SERVER_POLICY; addColumn tableName=RESOURCE_SERVER_PERM_TICKET; addForeignKeyConstraint baseTableName=RESOURCE_SERVER_PERM_TICKET, constraintName=FK_FRSRPO2128CX4WNKOG82SSRFY, referencedTableName=RESOURCE_SERVER_POLICY		\N	4.25.1	\N	\N	2167877090
authz-4.2.0.Final	mhajas@redhat.com	META-INF/jpa-changelog-authz-4.2.0.Final.xml	2026-06-22 22:38:01.064341	61	EXECUTED	9:42a33806f3a0443fe0e7feeec821326c	createTable tableName=RESOURCE_URIS; addForeignKeyConstraint baseTableName=RESOURCE_URIS, constraintName=FK_RESOURCE_SERVER_URIS, referencedTableName=RESOURCE_SERVER_RESOURCE; customChange; dropColumn columnName=URI, tableName=RESOURCE_SERVER_RESO...		\N	4.25.1	\N	\N	2167877090
authz-4.2.0.Final-KEYCLOAK-9944	hmlnarik@redhat.com	META-INF/jpa-changelog-authz-4.2.0.Final.xml	2026-06-22 22:38:01.079508	62	EXECUTED	9:9968206fca46eecc1f51db9c024bfe56	addPrimaryKey constraintName=CONSTRAINT_RESOUR_URIS_PK, tableName=RESOURCE_URIS		\N	4.25.1	\N	\N	2167877090
4.2.0-KEYCLOAK-6313	wadahiro@gmail.com	META-INF/jpa-changelog-4.2.0.xml	2026-06-22 22:38:01.088763	63	EXECUTED	9:92143a6daea0a3f3b8f598c97ce55c3d	addColumn tableName=REQUIRED_ACTION_PROVIDER		\N	4.25.1	\N	\N	2167877090
4.3.0-KEYCLOAK-7984	wadahiro@gmail.com	META-INF/jpa-changelog-4.3.0.xml	2026-06-22 22:38:01.094412	64	EXECUTED	9:82bab26a27195d889fb0429003b18f40	update tableName=REQUIRED_ACTION_PROVIDER		\N	4.25.1	\N	\N	2167877090
4.6.0-KEYCLOAK-7950	psilva@redhat.com	META-INF/jpa-changelog-4.6.0.xml	2026-06-22 22:38:01.098908	65	EXECUTED	9:e590c88ddc0b38b0ae4249bbfcb5abc3	update tableName=RESOURCE_SERVER_RESOURCE		\N	4.25.1	\N	\N	2167877090
4.6.0-KEYCLOAK-8377	keycloak	META-INF/jpa-changelog-4.6.0.xml	2026-06-22 22:38:01.148846	66	EXECUTED	9:5c1f475536118dbdc38d5d7977950cc0	createTable tableName=ROLE_ATTRIBUTE; addPrimaryKey constraintName=CONSTRAINT_ROLE_ATTRIBUTE_PK, tableName=ROLE_ATTRIBUTE; addForeignKeyConstraint baseTableName=ROLE_ATTRIBUTE, constraintName=FK_ROLE_ATTRIBUTE_ID, referencedTableName=KEYCLOAK_ROLE...		\N	4.25.1	\N	\N	2167877090
4.6.0-KEYCLOAK-8555	gideonray@gmail.com	META-INF/jpa-changelog-4.6.0.xml	2026-06-22 22:38:01.164087	67	EXECUTED	9:e7c9f5f9c4d67ccbbcc215440c718a17	createIndex indexName=IDX_COMPONENT_PROVIDER_TYPE, tableName=COMPONENT		\N	4.25.1	\N	\N	2167877090
4.7.0-KEYCLOAK-1267	sguilhen@redhat.com	META-INF/jpa-changelog-4.7.0.xml	2026-06-22 22:38:01.173813	68	EXECUTED	9:88e0bfdda924690d6f4e430c53447dd5	addColumn tableName=REALM		\N	4.25.1	\N	\N	2167877090
4.7.0-KEYCLOAK-7275	keycloak	META-INF/jpa-changelog-4.7.0.xml	2026-06-22 22:38:01.194866	69	EXECUTED	9:f53177f137e1c46b6a88c59ec1cb5218	renameColumn newColumnName=CREATED_ON, oldColumnName=LAST_SESSION_REFRESH, tableName=OFFLINE_USER_SESSION; addNotNullConstraint columnName=CREATED_ON, tableName=OFFLINE_USER_SESSION; addColumn tableName=OFFLINE_USER_SESSION; customChange; createIn...		\N	4.25.1	\N	\N	2167877090
4.8.0-KEYCLOAK-8835	sguilhen@redhat.com	META-INF/jpa-changelog-4.8.0.xml	2026-06-22 22:38:01.204155	70	EXECUTED	9:a74d33da4dc42a37ec27121580d1459f	addNotNullConstraint columnName=SSO_MAX_LIFESPAN_REMEMBER_ME, tableName=REALM; addNotNullConstraint columnName=SSO_IDLE_TIMEOUT_REMEMBER_ME, tableName=REALM		\N	4.25.1	\N	\N	2167877090
authz-7.0.0-KEYCLOAK-10443	psilva@redhat.com	META-INF/jpa-changelog-authz-7.0.0.xml	2026-06-22 22:38:01.213508	71	EXECUTED	9:fd4ade7b90c3b67fae0bfcfcb42dfb5f	addColumn tableName=RESOURCE_SERVER		\N	4.25.1	\N	\N	2167877090
8.0.0-adding-credential-columns	keycloak	META-INF/jpa-changelog-8.0.0.xml	2026-06-22 22:38:01.224771	72	EXECUTED	9:aa072ad090bbba210d8f18781b8cebf4	addColumn tableName=CREDENTIAL; addColumn tableName=FED_USER_CREDENTIAL		\N	4.25.1	\N	\N	2167877090
8.0.0-updating-credential-data-not-oracle-fixed	keycloak	META-INF/jpa-changelog-8.0.0.xml	2026-06-22 22:38:01.233113	73	EXECUTED	9:1ae6be29bab7c2aa376f6983b932be37	update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL		\N	4.25.1	\N	\N	2167877090
8.0.0-updating-credential-data-oracle-fixed	keycloak	META-INF/jpa-changelog-8.0.0.xml	2026-06-22 22:38:01.236816	74	MARK_RAN	9:14706f286953fc9a25286dbd8fb30d97	update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL		\N	4.25.1	\N	\N	2167877090
8.0.0-credential-cleanup-fixed	keycloak	META-INF/jpa-changelog-8.0.0.xml	2026-06-22 22:38:01.280415	75	EXECUTED	9:2b9cc12779be32c5b40e2e67711a218b	dropDefaultValue columnName=COUNTER, tableName=CREDENTIAL; dropDefaultValue columnName=DIGITS, tableName=CREDENTIAL; dropDefaultValue columnName=PERIOD, tableName=CREDENTIAL; dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; dropColumn ...		\N	4.25.1	\N	\N	2167877090
8.0.0-resource-tag-support	keycloak	META-INF/jpa-changelog-8.0.0.xml	2026-06-22 22:38:01.295886	76	EXECUTED	9:91fa186ce7a5af127a2d7a91ee083cc5	addColumn tableName=MIGRATION_MODEL; createIndex indexName=IDX_UPDATE_TIME, tableName=MIGRATION_MODEL		\N	4.25.1	\N	\N	2167877090
9.0.0-always-display-client	keycloak	META-INF/jpa-changelog-9.0.0.xml	2026-06-22 22:38:01.305903	77	EXECUTED	9:6335e5c94e83a2639ccd68dd24e2e5ad	addColumn tableName=CLIENT		\N	4.25.1	\N	\N	2167877090
9.0.0-drop-constraints-for-column-increase	keycloak	META-INF/jpa-changelog-9.0.0.xml	2026-06-22 22:38:01.311104	78	MARK_RAN	9:6bdb5658951e028bfe16fa0a8228b530	dropUniqueConstraint constraintName=UK_FRSR6T700S9V50BU18WS5PMT, tableName=RESOURCE_SERVER_PERM_TICKET; dropUniqueConstraint constraintName=UK_FRSR6T700S9V50BU18WS5HA6, tableName=RESOURCE_SERVER_RESOURCE; dropPrimaryKey constraintName=CONSTRAINT_O...		\N	4.25.1	\N	\N	2167877090
9.0.0-increase-column-size-federated-fk	keycloak	META-INF/jpa-changelog-9.0.0.xml	2026-06-22 22:38:01.343555	79	EXECUTED	9:d5bc15a64117ccad481ce8792d4c608f	modifyDataType columnName=CLIENT_ID, tableName=FED_USER_CONSENT; modifyDataType columnName=CLIENT_REALM_CONSTRAINT, tableName=KEYCLOAK_ROLE; modifyDataType columnName=OWNER, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=CLIENT_ID, ta...		\N	4.25.1	\N	\N	2167877090
9.0.0-recreate-constraints-after-column-increase	keycloak	META-INF/jpa-changelog-9.0.0.xml	2026-06-22 22:38:01.348809	80	MARK_RAN	9:077cba51999515f4d3e7ad5619ab592c	addNotNullConstraint columnName=CLIENT_ID, tableName=OFFLINE_CLIENT_SESSION; addNotNullConstraint columnName=OWNER, tableName=RESOURCE_SERVER_PERM_TICKET; addNotNullConstraint columnName=REQUESTER, tableName=RESOURCE_SERVER_PERM_TICKET; addNotNull...		\N	4.25.1	\N	\N	2167877090
9.0.1-add-index-to-client.client_id	keycloak	META-INF/jpa-changelog-9.0.1.xml	2026-06-22 22:38:01.363558	81	EXECUTED	9:be969f08a163bf47c6b9e9ead8ac2afb	createIndex indexName=IDX_CLIENT_ID, tableName=CLIENT		\N	4.25.1	\N	\N	2167877090
9.0.1-KEYCLOAK-12579-drop-constraints	keycloak	META-INF/jpa-changelog-9.0.1.xml	2026-06-22 22:38:01.368256	82	MARK_RAN	9:6d3bb4408ba5a72f39bd8a0b301ec6e3	dropUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP		\N	4.25.1	\N	\N	2167877090
9.0.1-KEYCLOAK-12579-add-not-null-constraint	keycloak	META-INF/jpa-changelog-9.0.1.xml	2026-06-22 22:38:01.37771	83	EXECUTED	9:966bda61e46bebf3cc39518fbed52fa7	addNotNullConstraint columnName=PARENT_GROUP, tableName=KEYCLOAK_GROUP		\N	4.25.1	\N	\N	2167877090
9.0.1-KEYCLOAK-12579-recreate-constraints	keycloak	META-INF/jpa-changelog-9.0.1.xml	2026-06-22 22:38:01.382348	84	MARK_RAN	9:8dcac7bdf7378e7d823cdfddebf72fda	addUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP		\N	4.25.1	\N	\N	2167877090
9.0.1-add-index-to-events	keycloak	META-INF/jpa-changelog-9.0.1.xml	2026-06-22 22:38:01.413174	85	EXECUTED	9:7d93d602352a30c0c317e6a609b56599	createIndex indexName=IDX_EVENT_TIME, tableName=EVENT_ENTITY		\N	4.25.1	\N	\N	2167877090
map-remove-ri	keycloak	META-INF/jpa-changelog-11.0.0.xml	2026-06-22 22:38:01.423634	86	EXECUTED	9:71c5969e6cdd8d7b6f47cebc86d37627	dropForeignKeyConstraint baseTableName=REALM, constraintName=FK_TRAF444KK6QRKMS7N56AIWQ5Y; dropForeignKeyConstraint baseTableName=KEYCLOAK_ROLE, constraintName=FK_KJHO5LE2C0RAL09FL8CM9WFW9		\N	4.25.1	\N	\N	2167877090
map-remove-ri	keycloak	META-INF/jpa-changelog-12.0.0.xml	2026-06-22 22:38:01.43771	87	EXECUTED	9:a9ba7d47f065f041b7da856a81762021	dropForeignKeyConstraint baseTableName=REALM_DEFAULT_GROUPS, constraintName=FK_DEF_GROUPS_GROUP; dropForeignKeyConstraint baseTableName=REALM_DEFAULT_ROLES, constraintName=FK_H4WPD7W4HSOOLNI3H0SW7BTJE; dropForeignKeyConstraint baseTableName=CLIENT...		\N	4.25.1	\N	\N	2167877090
12.1.0-add-realm-localization-table	keycloak	META-INF/jpa-changelog-12.0.0.xml	2026-06-22 22:38:01.458916	88	EXECUTED	9:fffabce2bc01e1a8f5110d5278500065	createTable tableName=REALM_LOCALIZATIONS; addPrimaryKey tableName=REALM_LOCALIZATIONS		\N	4.25.1	\N	\N	2167877090
default-roles	keycloak	META-INF/jpa-changelog-13.0.0.xml	2026-06-22 22:38:01.469896	89	EXECUTED	9:fa8a5b5445e3857f4b010bafb5009957	addColumn tableName=REALM; customChange		\N	4.25.1	\N	\N	2167877090
default-roles-cleanup	keycloak	META-INF/jpa-changelog-13.0.0.xml	2026-06-22 22:38:01.483439	90	EXECUTED	9:67ac3241df9a8582d591c5ed87125f39	dropTable tableName=REALM_DEFAULT_ROLES; dropTable tableName=CLIENT_DEFAULT_ROLES		\N	4.25.1	\N	\N	2167877090
13.0.0-KEYCLOAK-16844	keycloak	META-INF/jpa-changelog-13.0.0.xml	2026-06-22 22:38:01.497797	91	EXECUTED	9:ad1194d66c937e3ffc82386c050ba089	createIndex indexName=IDX_OFFLINE_USS_PRELOAD, tableName=OFFLINE_USER_SESSION		\N	4.25.1	\N	\N	2167877090
map-remove-ri-13.0.0	keycloak	META-INF/jpa-changelog-13.0.0.xml	2026-06-22 22:38:01.536306	92	EXECUTED	9:d9be619d94af5a2f5d07b9f003543b91	dropForeignKeyConstraint baseTableName=DEFAULT_CLIENT_SCOPE, constraintName=FK_R_DEF_CLI_SCOPE_SCOPE; dropForeignKeyConstraint baseTableName=CLIENT_SCOPE_CLIENT, constraintName=FK_C_CLI_SCOPE_SCOPE; dropForeignKeyConstraint baseTableName=CLIENT_SC...		\N	4.25.1	\N	\N	2167877090
13.0.0-KEYCLOAK-17992-drop-constraints	keycloak	META-INF/jpa-changelog-13.0.0.xml	2026-06-22 22:38:01.540962	93	MARK_RAN	9:544d201116a0fcc5a5da0925fbbc3bde	dropPrimaryKey constraintName=C_CLI_SCOPE_BIND, tableName=CLIENT_SCOPE_CLIENT; dropIndex indexName=IDX_CLSCOPE_CL, tableName=CLIENT_SCOPE_CLIENT; dropIndex indexName=IDX_CL_CLSCOPE, tableName=CLIENT_SCOPE_CLIENT		\N	4.25.1	\N	\N	2167877090
13.0.0-increase-column-size-federated	keycloak	META-INF/jpa-changelog-13.0.0.xml	2026-06-22 22:38:01.558667	94	EXECUTED	9:43c0c1055b6761b4b3e89de76d612ccf	modifyDataType columnName=CLIENT_ID, tableName=CLIENT_SCOPE_CLIENT; modifyDataType columnName=SCOPE_ID, tableName=CLIENT_SCOPE_CLIENT		\N	4.25.1	\N	\N	2167877090
13.0.0-KEYCLOAK-17992-recreate-constraints	keycloak	META-INF/jpa-changelog-13.0.0.xml	2026-06-22 22:38:01.563449	95	MARK_RAN	9:8bd711fd0330f4fe980494ca43ab1139	addNotNullConstraint columnName=CLIENT_ID, tableName=CLIENT_SCOPE_CLIENT; addNotNullConstraint columnName=SCOPE_ID, tableName=CLIENT_SCOPE_CLIENT; addPrimaryKey constraintName=C_CLI_SCOPE_BIND, tableName=CLIENT_SCOPE_CLIENT; createIndex indexName=...		\N	4.25.1	\N	\N	2167877090
json-string-accomodation-fixed	keycloak	META-INF/jpa-changelog-13.0.0.xml	2026-06-22 22:38:01.572931	96	EXECUTED	9:e07d2bc0970c348bb06fb63b1f82ddbf	addColumn tableName=REALM_ATTRIBUTE; update tableName=REALM_ATTRIBUTE; dropColumn columnName=VALUE, tableName=REALM_ATTRIBUTE; renameColumn newColumnName=VALUE, oldColumnName=VALUE_NEW, tableName=REALM_ATTRIBUTE		\N	4.25.1	\N	\N	2167877090
14.0.0-KEYCLOAK-11019	keycloak	META-INF/jpa-changelog-14.0.0.xml	2026-06-22 22:38:01.600781	97	EXECUTED	9:24fb8611e97f29989bea412aa38d12b7	createIndex indexName=IDX_OFFLINE_CSS_PRELOAD, tableName=OFFLINE_CLIENT_SESSION; createIndex indexName=IDX_OFFLINE_USS_BY_USER, tableName=OFFLINE_USER_SESSION; createIndex indexName=IDX_OFFLINE_USS_BY_USERSESS, tableName=OFFLINE_USER_SESSION		\N	4.25.1	\N	\N	2167877090
14.0.0-KEYCLOAK-18286	keycloak	META-INF/jpa-changelog-14.0.0.xml	2026-06-22 22:38:01.605605	98	MARK_RAN	9:259f89014ce2506ee84740cbf7163aa7	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.25.1	\N	\N	2167877090
14.0.0-KEYCLOAK-18286-revert	keycloak	META-INF/jpa-changelog-14.0.0.xml	2026-06-22 22:38:01.616282	99	MARK_RAN	9:04baaf56c116ed19951cbc2cca584022	dropIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.25.1	\N	\N	2167877090
14.0.0-KEYCLOAK-18286-supported-dbs	keycloak	META-INF/jpa-changelog-14.0.0.xml	2026-06-22 22:38:01.629816	100	EXECUTED	9:60ca84a0f8c94ec8c3504a5a3bc88ee8	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.25.1	\N	\N	2167877090
14.0.0-KEYCLOAK-18286-unsupported-dbs	keycloak	META-INF/jpa-changelog-14.0.0.xml	2026-06-22 22:38:01.634463	101	MARK_RAN	9:d3d977031d431db16e2c181ce49d73e9	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.25.1	\N	\N	2167877090
KEYCLOAK-17267-add-index-to-user-attributes	keycloak	META-INF/jpa-changelog-14.0.0.xml	2026-06-22 22:38:01.673324	102	EXECUTED	9:0b305d8d1277f3a89a0a53a659ad274c	createIndex indexName=IDX_USER_ATTRIBUTE_NAME, tableName=USER_ATTRIBUTE		\N	4.25.1	\N	\N	2167877090
KEYCLOAK-18146-add-saml-art-binding-identifier	keycloak	META-INF/jpa-changelog-14.0.0.xml	2026-06-22 22:38:01.681557	103	EXECUTED	9:2c374ad2cdfe20e2905a84c8fac48460	customChange		\N	4.25.1	\N	\N	2167877090
15.0.0-KEYCLOAK-18467	keycloak	META-INF/jpa-changelog-15.0.0.xml	2026-06-22 22:38:01.689675	104	EXECUTED	9:47a760639ac597360a8219f5b768b4de	addColumn tableName=REALM_LOCALIZATIONS; update tableName=REALM_LOCALIZATIONS; dropColumn columnName=TEXTS, tableName=REALM_LOCALIZATIONS; renameColumn newColumnName=TEXTS, oldColumnName=TEXTS_NEW, tableName=REALM_LOCALIZATIONS; addNotNullConstrai...		\N	4.25.1	\N	\N	2167877090
17.0.0-9562	keycloak	META-INF/jpa-changelog-17.0.0.xml	2026-06-22 22:38:01.704307	105	EXECUTED	9:a6272f0576727dd8cad2522335f5d99e	createIndex indexName=IDX_USER_SERVICE_ACCOUNT, tableName=USER_ENTITY		\N	4.25.1	\N	\N	2167877090
18.0.0-10625-IDX_ADMIN_EVENT_TIME	keycloak	META-INF/jpa-changelog-18.0.0.xml	2026-06-22 22:38:01.718869	106	EXECUTED	9:015479dbd691d9cc8669282f4828c41d	createIndex indexName=IDX_ADMIN_EVENT_TIME, tableName=ADMIN_EVENT_ENTITY		\N	4.25.1	\N	\N	2167877090
18.0.15-30992-index-consent	keycloak	META-INF/jpa-changelog-18.0.15.xml	2026-06-22 22:38:01.7355	107	EXECUTED	9:80071ede7a05604b1f4906f3bf3b00f0	createIndex indexName=IDX_USCONSENT_SCOPE_ID, tableName=USER_CONSENT_CLIENT_SCOPE		\N	4.25.1	\N	\N	2167877090
19.0.0-10135	keycloak	META-INF/jpa-changelog-19.0.0.xml	2026-06-22 22:38:01.743185	108	EXECUTED	9:9518e495fdd22f78ad6425cc30630221	customChange		\N	4.25.1	\N	\N	2167877090
20.0.0-12964-supported-dbs	keycloak	META-INF/jpa-changelog-20.0.0.xml	2026-06-22 22:38:01.75662	109	EXECUTED	9:e5f243877199fd96bcc842f27a1656ac	createIndex indexName=IDX_GROUP_ATT_BY_NAME_VALUE, tableName=GROUP_ATTRIBUTE		\N	4.25.1	\N	\N	2167877090
20.0.0-12964-unsupported-dbs	keycloak	META-INF/jpa-changelog-20.0.0.xml	2026-06-22 22:38:01.776643	110	MARK_RAN	9:1a6fcaa85e20bdeae0a9ce49b41946a5	createIndex indexName=IDX_GROUP_ATT_BY_NAME_VALUE, tableName=GROUP_ATTRIBUTE		\N	4.25.1	\N	\N	2167877090
client-attributes-string-accomodation-fixed	keycloak	META-INF/jpa-changelog-20.0.0.xml	2026-06-22 22:38:01.786315	111	EXECUTED	9:3f332e13e90739ed0c35b0b25b7822ca	addColumn tableName=CLIENT_ATTRIBUTES; update tableName=CLIENT_ATTRIBUTES; dropColumn columnName=VALUE, tableName=CLIENT_ATTRIBUTES; renameColumn newColumnName=VALUE, oldColumnName=VALUE_NEW, tableName=CLIENT_ATTRIBUTES		\N	4.25.1	\N	\N	2167877090
21.0.2-17277	keycloak	META-INF/jpa-changelog-21.0.2.xml	2026-06-22 22:38:01.794254	112	EXECUTED	9:7ee1f7a3fb8f5588f171fb9a6ab623c0	customChange		\N	4.25.1	\N	\N	2167877090
21.1.0-19404	keycloak	META-INF/jpa-changelog-21.1.0.xml	2026-06-22 22:38:01.885369	113	EXECUTED	9:3d7e830b52f33676b9d64f7f2b2ea634	modifyDataType columnName=DECISION_STRATEGY, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=LOGIC, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=POLICY_ENFORCE_MODE, tableName=RESOURCE_SERVER		\N	4.25.1	\N	\N	2167877090
21.1.0-19404-2	keycloak	META-INF/jpa-changelog-21.1.0.xml	2026-06-22 22:38:01.889866	114	MARK_RAN	9:627d032e3ef2c06c0e1f73d2ae25c26c	addColumn tableName=RESOURCE_SERVER_POLICY; update tableName=RESOURCE_SERVER_POLICY; dropColumn columnName=DECISION_STRATEGY, tableName=RESOURCE_SERVER_POLICY; renameColumn newColumnName=DECISION_STRATEGY, oldColumnName=DECISION_STRATEGY_NEW, tabl...		\N	4.25.1	\N	\N	2167877090
22.0.0-17484-updated	keycloak	META-INF/jpa-changelog-22.0.0.xml	2026-06-22 22:38:01.896725	115	EXECUTED	9:90af0bfd30cafc17b9f4d6eccd92b8b3	customChange		\N	4.25.1	\N	\N	2167877090
22.0.5-24031	keycloak	META-INF/jpa-changelog-22.0.0.xml	2026-06-22 22:38:01.900256	116	MARK_RAN	9:a60d2d7b315ec2d3eba9e2f145f9df28	customChange		\N	4.25.1	\N	\N	2167877090
23.0.0-12062	keycloak	META-INF/jpa-changelog-23.0.0.xml	2026-06-22 22:38:01.909764	117	EXECUTED	9:2168fbe728fec46ae9baf15bf80927b8	addColumn tableName=COMPONENT_CONFIG; update tableName=COMPONENT_CONFIG; dropColumn columnName=VALUE, tableName=COMPONENT_CONFIG; renameColumn newColumnName=VALUE, oldColumnName=VALUE_NEW, tableName=COMPONENT_CONFIG		\N	4.25.1	\N	\N	2167877090
23.0.0-17258	keycloak	META-INF/jpa-changelog-23.0.0.xml	2026-06-22 22:38:01.919024	118	EXECUTED	9:36506d679a83bbfda85a27ea1864dca8	addColumn tableName=EVENT_ENTITY		\N	4.25.1	\N	\N	2167877090
24.0.0-9758	keycloak	META-INF/jpa-changelog-24.0.0.xml	2026-06-22 22:38:01.957541	119	EXECUTED	9:502c557a5189f600f0f445a9b49ebbce	addColumn tableName=USER_ATTRIBUTE; addColumn tableName=FED_USER_ATTRIBUTE; createIndex indexName=USER_ATTR_LONG_VALUES, tableName=USER_ATTRIBUTE; createIndex indexName=FED_USER_ATTR_LONG_VALUES, tableName=FED_USER_ATTRIBUTE; createIndex indexName...		\N	4.25.1	\N	\N	2167877090
24.0.0-9758-2	keycloak	META-INF/jpa-changelog-24.0.0.xml	2026-06-22 22:38:01.965133	120	EXECUTED	9:bf0fdee10afdf597a987adbf291db7b2	customChange		\N	4.25.1	\N	\N	2167877090
24.0.0-26618-drop-index-if-present	keycloak	META-INF/jpa-changelog-24.0.0.xml	2026-06-22 22:38:01.970836	121	MARK_RAN	9:04baaf56c116ed19951cbc2cca584022	dropIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.25.1	\N	\N	2167877090
24.0.0-26618-reindex	keycloak	META-INF/jpa-changelog-24.0.0.xml	2026-06-22 22:38:02.006599	122	EXECUTED	9:08707c0f0db1cef6b352db03a60edc7f	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.25.1	\N	\N	2167877090
24.0.2-27228	keycloak	META-INF/jpa-changelog-24.0.2.xml	2026-06-22 22:38:02.014022	123	EXECUTED	9:eaee11f6b8aa25d2cc6a84fb86fc6238	customChange		\N	4.25.1	\N	\N	2167877090
24.0.2-27967-drop-index-if-present	keycloak	META-INF/jpa-changelog-24.0.2.xml	2026-06-22 22:38:02.017283	124	MARK_RAN	9:04baaf56c116ed19951cbc2cca584022	dropIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.25.1	\N	\N	2167877090
24.0.2-27967-reindex	keycloak	META-INF/jpa-changelog-24.0.2.xml	2026-06-22 22:38:02.021869	125	MARK_RAN	9:d3d977031d431db16e2c181ce49d73e9	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.25.1	\N	\N	2167877090
25.0.0-28265-tables	keycloak	META-INF/jpa-changelog-25.0.0.xml	2026-06-22 22:38:02.031099	126	EXECUTED	9:deda2df035df23388af95bbd36c17cef	addColumn tableName=OFFLINE_USER_SESSION; addColumn tableName=OFFLINE_CLIENT_SESSION		\N	4.25.1	\N	\N	2167877090
25.0.0-28265-index-creation	keycloak	META-INF/jpa-changelog-25.0.0.xml	2026-06-22 22:38:02.04574	127	EXECUTED	9:3e96709818458ae49f3c679ae58d263a	createIndex indexName=IDX_OFFLINE_USS_BY_LAST_SESSION_REFRESH, tableName=OFFLINE_USER_SESSION		\N	4.25.1	\N	\N	2167877090
25.0.0-28265-index-cleanup	keycloak	META-INF/jpa-changelog-25.0.0.xml	2026-06-22 22:38:02.055673	128	EXECUTED	9:8c0cfa341a0474385b324f5c4b2dfcc1	dropIndex indexName=IDX_OFFLINE_USS_CREATEDON, tableName=OFFLINE_USER_SESSION; dropIndex indexName=IDX_OFFLINE_USS_PRELOAD, tableName=OFFLINE_USER_SESSION; dropIndex indexName=IDX_OFFLINE_USS_BY_USERSESS, tableName=OFFLINE_USER_SESSION; dropIndex ...		\N	4.25.1	\N	\N	2167877090
25.0.0-28265-index-2-mysql	keycloak	META-INF/jpa-changelog-25.0.0.xml	2026-06-22 22:38:02.060244	129	MARK_RAN	9:b7ef76036d3126bb83c2423bf4d449d6	createIndex indexName=IDX_OFFLINE_USS_BY_BROKER_SESSION_ID, tableName=OFFLINE_USER_SESSION		\N	4.25.1	\N	\N	2167877090
25.0.0-28265-index-2-not-mysql	keycloak	META-INF/jpa-changelog-25.0.0.xml	2026-06-22 22:38:02.074811	130	EXECUTED	9:23396cf51ab8bc1ae6f0cac7f9f6fcf7	createIndex indexName=IDX_OFFLINE_USS_BY_BROKER_SESSION_ID, tableName=OFFLINE_USER_SESSION		\N	4.25.1	\N	\N	2167877090
25.0.0-org	keycloak	META-INF/jpa-changelog-25.0.0.xml	2026-06-22 22:38:02.136822	131	EXECUTED	9:5c859965c2c9b9c72136c360649af157	createTable tableName=ORG; addUniqueConstraint constraintName=UK_ORG_NAME, tableName=ORG; addUniqueConstraint constraintName=UK_ORG_GROUP, tableName=ORG; createTable tableName=ORG_DOMAIN		\N	4.25.1	\N	\N	2167877090
unique-consentuser	keycloak	META-INF/jpa-changelog-25.0.0.xml	2026-06-22 22:38:02.160425	132	EXECUTED	9:5857626a2ea8767e9a6c66bf3a2cb32f	customChange; dropUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHOGM8UEWRT, tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_LOCAL_CONSENT, tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_EXTERNAL_CONSENT, tableName=...		\N	4.25.1	\N	\N	2167877090
unique-consentuser-mysql	keycloak	META-INF/jpa-changelog-25.0.0.xml	2026-06-22 22:38:02.16498	133	MARK_RAN	9:b79478aad5adaa1bc428e31563f55e8e	customChange; dropUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHOGM8UEWRT, tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_LOCAL_CONSENT, tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_EXTERNAL_CONSENT, tableName=...		\N	4.25.1	\N	\N	2167877090
25.0.0-28861-index-creation	keycloak	META-INF/jpa-changelog-25.0.0.xml	2026-06-22 22:38:02.185532	134	EXECUTED	9:b9acb58ac958d9ada0fe12a5d4794ab1	createIndex indexName=IDX_PERM_TICKET_REQUESTER, tableName=RESOURCE_SERVER_PERM_TICKET; createIndex indexName=IDX_PERM_TICKET_OWNER, tableName=RESOURCE_SERVER_PERM_TICKET		\N	4.25.1	\N	\N	2167877090
\.


--
-- Data for Name: databasechangeloglock; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.databasechangeloglock (id, locked, lockgranted, lockedby) FROM stdin;
1	f	\N	\N
1000	f	\N	\N
\.


--
-- Data for Name: default_client_scope; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.default_client_scope (realm_id, scope_id, default_scope) FROM stdin;
a26b60a1-fefa-4c54-839e-6fb85147388e	1b91ac1f-0c24-4c66-add7-3083de2b1fab	f
a26b60a1-fefa-4c54-839e-6fb85147388e	283acb3d-e607-4a0c-97d1-ae1b7102146f	t
a26b60a1-fefa-4c54-839e-6fb85147388e	a66e1e63-0c41-43ab-a557-d42a1e0e9179	t
a26b60a1-fefa-4c54-839e-6fb85147388e	fc1ddff4-6764-418f-b4d4-1047530b5443	t
a26b60a1-fefa-4c54-839e-6fb85147388e	8193e8cb-ecfb-47c1-966c-cd7bf7d1a7c9	f
a26b60a1-fefa-4c54-839e-6fb85147388e	37c48668-3df6-4fb9-8009-d1867372a4ca	f
a26b60a1-fefa-4c54-839e-6fb85147388e	e037c9df-53a8-40a6-990b-420805196ca4	t
a26b60a1-fefa-4c54-839e-6fb85147388e	9bcf133d-25e0-421a-9b53-3702f24b9da4	t
a26b60a1-fefa-4c54-839e-6fb85147388e	0915860d-fbbf-4e07-9de4-2eb4a8540de4	f
a26b60a1-fefa-4c54-839e-6fb85147388e	6d9433c3-e6f5-4bf9-849f-105e354fe7af	t
a26b60a1-fefa-4c54-839e-6fb85147388e	7174b2a2-695c-4d32-b84b-b702c0fa3b00	t
\.


--
-- Data for Name: event_entity; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.event_entity (id, client_id, details_json, error, ip_address, realm_id, session_id, event_time, type, user_id, details_json_long_value) FROM stdin;
\.


--
-- Data for Name: fed_user_attribute; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.fed_user_attribute (id, name, user_id, realm_id, storage_provider_id, value, long_value_hash, long_value_hash_lower_case, long_value) FROM stdin;
\.


--
-- Data for Name: fed_user_consent; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.fed_user_consent (id, client_id, user_id, realm_id, storage_provider_id, created_date, last_updated_date, client_storage_provider, external_client_id) FROM stdin;
\.


--
-- Data for Name: fed_user_consent_cl_scope; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.fed_user_consent_cl_scope (user_consent_id, scope_id) FROM stdin;
\.


--
-- Data for Name: fed_user_credential; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.fed_user_credential (id, salt, type, created_date, user_id, realm_id, storage_provider_id, user_label, secret_data, credential_data, priority) FROM stdin;
\.


--
-- Data for Name: fed_user_group_membership; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.fed_user_group_membership (group_id, user_id, realm_id, storage_provider_id) FROM stdin;
\.


--
-- Data for Name: fed_user_required_action; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.fed_user_required_action (required_action, user_id, realm_id, storage_provider_id) FROM stdin;
\.


--
-- Data for Name: fed_user_role_mapping; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.fed_user_role_mapping (role_id, user_id, realm_id, storage_provider_id) FROM stdin;
\.


--
-- Data for Name: federated_identity; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.federated_identity (identity_provider, realm_id, federated_user_id, federated_username, token, user_id) FROM stdin;
\.


--
-- Data for Name: federated_user; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.federated_user (id, storage_provider_id, realm_id) FROM stdin;
\.


--
-- Data for Name: group_attribute; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.group_attribute (id, name, value, group_id) FROM stdin;
\.


--
-- Data for Name: group_role_mapping; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.group_role_mapping (role_id, group_id) FROM stdin;
\.


--
-- Data for Name: identity_provider; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.identity_provider (internal_id, enabled, provider_alias, provider_id, store_token, authenticate_by_default, realm_id, add_token_role, trust_email, first_broker_login_flow_id, post_broker_login_flow_id, provider_display_name, link_only) FROM stdin;
\.


--
-- Data for Name: identity_provider_config; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.identity_provider_config (identity_provider_id, value, name) FROM stdin;
\.


--
-- Data for Name: identity_provider_mapper; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.identity_provider_mapper (id, name, idp_alias, idp_mapper_name, realm_id) FROM stdin;
\.


--
-- Data for Name: idp_mapper_config; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.idp_mapper_config (idp_mapper_id, value, name) FROM stdin;
\.


--
-- Data for Name: keycloak_group; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.keycloak_group (id, name, parent_group, realm_id) FROM stdin;
\.


--
-- Data for Name: keycloak_role; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.keycloak_role (id, client_realm_constraint, client_role, description, name, realm_id, client, realm) FROM stdin;
2deb75a4-0e6d-4aff-b4a3-a17018b88ac2	a26b60a1-fefa-4c54-839e-6fb85147388e	f	${role_default-roles}	default-roles-master	a26b60a1-fefa-4c54-839e-6fb85147388e	\N	\N
2170a162-6ff7-4849-b5d7-4902543ef539	a26b60a1-fefa-4c54-839e-6fb85147388e	f	${role_create-realm}	create-realm	a26b60a1-fefa-4c54-839e-6fb85147388e	\N	\N
5e20b5b3-6602-42ae-9989-b41f67276069	a26b60a1-fefa-4c54-839e-6fb85147388e	f	${role_admin}	admin	a26b60a1-fefa-4c54-839e-6fb85147388e	\N	\N
b0c2e19a-3c67-465e-86de-f2fe4a43e6a5	c419fb54-e4aa-4ed2-ac6f-9fcd190ed931	t	${role_create-client}	create-client	a26b60a1-fefa-4c54-839e-6fb85147388e	c419fb54-e4aa-4ed2-ac6f-9fcd190ed931	\N
5be9a6f1-b1e0-4e4b-803c-0d61a990ffed	c419fb54-e4aa-4ed2-ac6f-9fcd190ed931	t	${role_view-realm}	view-realm	a26b60a1-fefa-4c54-839e-6fb85147388e	c419fb54-e4aa-4ed2-ac6f-9fcd190ed931	\N
a90e3c06-b660-41da-b320-ac233810ad1f	c419fb54-e4aa-4ed2-ac6f-9fcd190ed931	t	${role_view-users}	view-users	a26b60a1-fefa-4c54-839e-6fb85147388e	c419fb54-e4aa-4ed2-ac6f-9fcd190ed931	\N
54f92d94-1090-4e3e-9679-7927df44286c	c419fb54-e4aa-4ed2-ac6f-9fcd190ed931	t	${role_view-clients}	view-clients	a26b60a1-fefa-4c54-839e-6fb85147388e	c419fb54-e4aa-4ed2-ac6f-9fcd190ed931	\N
31819b99-ef09-43aa-ab25-3ae8532cbe44	c419fb54-e4aa-4ed2-ac6f-9fcd190ed931	t	${role_view-events}	view-events	a26b60a1-fefa-4c54-839e-6fb85147388e	c419fb54-e4aa-4ed2-ac6f-9fcd190ed931	\N
a1c9b878-738e-4ae3-b1e4-81191294d552	c419fb54-e4aa-4ed2-ac6f-9fcd190ed931	t	${role_view-identity-providers}	view-identity-providers	a26b60a1-fefa-4c54-839e-6fb85147388e	c419fb54-e4aa-4ed2-ac6f-9fcd190ed931	\N
d0028538-76ac-4d3b-b0e8-0d6a225dbd15	c419fb54-e4aa-4ed2-ac6f-9fcd190ed931	t	${role_view-authorization}	view-authorization	a26b60a1-fefa-4c54-839e-6fb85147388e	c419fb54-e4aa-4ed2-ac6f-9fcd190ed931	\N
d7e85bbb-ee3d-48e6-ba3a-f87f25182cd0	c419fb54-e4aa-4ed2-ac6f-9fcd190ed931	t	${role_manage-realm}	manage-realm	a26b60a1-fefa-4c54-839e-6fb85147388e	c419fb54-e4aa-4ed2-ac6f-9fcd190ed931	\N
fe79c667-f9f0-44b7-a819-3e5fcbb24a9e	c419fb54-e4aa-4ed2-ac6f-9fcd190ed931	t	${role_manage-users}	manage-users	a26b60a1-fefa-4c54-839e-6fb85147388e	c419fb54-e4aa-4ed2-ac6f-9fcd190ed931	\N
403cb92f-e0da-4b92-9cb7-bf9079132b3c	c419fb54-e4aa-4ed2-ac6f-9fcd190ed931	t	${role_manage-clients}	manage-clients	a26b60a1-fefa-4c54-839e-6fb85147388e	c419fb54-e4aa-4ed2-ac6f-9fcd190ed931	\N
7f5f5485-b587-49ad-9c43-8c187b48f1a3	c419fb54-e4aa-4ed2-ac6f-9fcd190ed931	t	${role_manage-events}	manage-events	a26b60a1-fefa-4c54-839e-6fb85147388e	c419fb54-e4aa-4ed2-ac6f-9fcd190ed931	\N
5f55b3d9-19c5-4bb6-b99c-219636f93df5	c419fb54-e4aa-4ed2-ac6f-9fcd190ed931	t	${role_manage-identity-providers}	manage-identity-providers	a26b60a1-fefa-4c54-839e-6fb85147388e	c419fb54-e4aa-4ed2-ac6f-9fcd190ed931	\N
4ba38ffb-cb3e-406b-9ba7-851c39420855	c419fb54-e4aa-4ed2-ac6f-9fcd190ed931	t	${role_manage-authorization}	manage-authorization	a26b60a1-fefa-4c54-839e-6fb85147388e	c419fb54-e4aa-4ed2-ac6f-9fcd190ed931	\N
59b598dd-064d-40f0-a19c-962c222be790	c419fb54-e4aa-4ed2-ac6f-9fcd190ed931	t	${role_query-users}	query-users	a26b60a1-fefa-4c54-839e-6fb85147388e	c419fb54-e4aa-4ed2-ac6f-9fcd190ed931	\N
11a0a4ce-a6c2-410e-beb4-4e983787bf74	c419fb54-e4aa-4ed2-ac6f-9fcd190ed931	t	${role_query-clients}	query-clients	a26b60a1-fefa-4c54-839e-6fb85147388e	c419fb54-e4aa-4ed2-ac6f-9fcd190ed931	\N
60f11f13-63bb-4261-ab03-9608419ca327	c419fb54-e4aa-4ed2-ac6f-9fcd190ed931	t	${role_query-realms}	query-realms	a26b60a1-fefa-4c54-839e-6fb85147388e	c419fb54-e4aa-4ed2-ac6f-9fcd190ed931	\N
4613c004-9a1a-458f-9db9-f2b5591c5743	c419fb54-e4aa-4ed2-ac6f-9fcd190ed931	t	${role_query-groups}	query-groups	a26b60a1-fefa-4c54-839e-6fb85147388e	c419fb54-e4aa-4ed2-ac6f-9fcd190ed931	\N
3929385f-5f67-4a6b-8f6e-ba1c0db8e2a9	67d81828-c34f-4dda-98c0-a530e3c34d9a	t	${role_view-profile}	view-profile	a26b60a1-fefa-4c54-839e-6fb85147388e	67d81828-c34f-4dda-98c0-a530e3c34d9a	\N
316c18db-5809-4040-96a9-fd42e7182823	67d81828-c34f-4dda-98c0-a530e3c34d9a	t	${role_manage-account}	manage-account	a26b60a1-fefa-4c54-839e-6fb85147388e	67d81828-c34f-4dda-98c0-a530e3c34d9a	\N
ac56fc1e-2ed6-447e-8462-a02425cb86aa	67d81828-c34f-4dda-98c0-a530e3c34d9a	t	${role_manage-account-links}	manage-account-links	a26b60a1-fefa-4c54-839e-6fb85147388e	67d81828-c34f-4dda-98c0-a530e3c34d9a	\N
870f11b7-c0f0-4cf1-9c8a-e0932c59cb5f	67d81828-c34f-4dda-98c0-a530e3c34d9a	t	${role_view-applications}	view-applications	a26b60a1-fefa-4c54-839e-6fb85147388e	67d81828-c34f-4dda-98c0-a530e3c34d9a	\N
bdc82e13-a7c2-4862-8e46-30b0a082ee9e	67d81828-c34f-4dda-98c0-a530e3c34d9a	t	${role_view-consent}	view-consent	a26b60a1-fefa-4c54-839e-6fb85147388e	67d81828-c34f-4dda-98c0-a530e3c34d9a	\N
f3102c46-3486-437f-8080-7f07f14c09b5	67d81828-c34f-4dda-98c0-a530e3c34d9a	t	${role_manage-consent}	manage-consent	a26b60a1-fefa-4c54-839e-6fb85147388e	67d81828-c34f-4dda-98c0-a530e3c34d9a	\N
bd7bd206-2295-41b7-b5fe-1e5ed25f3e23	67d81828-c34f-4dda-98c0-a530e3c34d9a	t	${role_view-groups}	view-groups	a26b60a1-fefa-4c54-839e-6fb85147388e	67d81828-c34f-4dda-98c0-a530e3c34d9a	\N
4c7bc11c-d639-4966-8939-2b83dc127ffa	67d81828-c34f-4dda-98c0-a530e3c34d9a	t	${role_delete-account}	delete-account	a26b60a1-fefa-4c54-839e-6fb85147388e	67d81828-c34f-4dda-98c0-a530e3c34d9a	\N
57233177-4c3d-4ec6-a485-b5a529644cd1	cff128cb-8afa-46fb-bf72-ae3bc64a3d19	t	${role_read-token}	read-token	a26b60a1-fefa-4c54-839e-6fb85147388e	cff128cb-8afa-46fb-bf72-ae3bc64a3d19	\N
22d65474-ca0e-43bd-8ddd-fcda9a128235	c419fb54-e4aa-4ed2-ac6f-9fcd190ed931	t	${role_impersonation}	impersonation	a26b60a1-fefa-4c54-839e-6fb85147388e	c419fb54-e4aa-4ed2-ac6f-9fcd190ed931	\N
f8595bbd-76f7-4c6a-878b-cdad5ce11527	a26b60a1-fefa-4c54-839e-6fb85147388e	f	${role_offline-access}	offline_access	a26b60a1-fefa-4c54-839e-6fb85147388e	\N	\N
4f1f50e3-1e8d-4790-97e4-d9445d98313c	a26b60a1-fefa-4c54-839e-6fb85147388e	f	${role_uma_authorization}	uma_authorization	a26b60a1-fefa-4c54-839e-6fb85147388e	\N	\N
\.


--
-- Data for Name: migration_model; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.migration_model (id, version, update_time) FROM stdin;
8m1c8	25.0.6	1782167882
\.


--
-- Data for Name: offline_client_session; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.offline_client_session (user_session_id, client_id, offline_flag, "timestamp", data, client_storage_provider, external_client_id, version) FROM stdin;
\.


--
-- Data for Name: offline_user_session; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.offline_user_session (user_session_id, user_id, realm_id, created_on, offline_flag, data, last_session_refresh, broker_session_id, version) FROM stdin;
\.


--
-- Data for Name: org; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.org (id, enabled, realm_id, group_id, name, description) FROM stdin;
\.


--
-- Data for Name: org_domain; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.org_domain (id, name, verified, org_id) FROM stdin;
\.


--
-- Data for Name: policy_config; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.policy_config (policy_id, name, value) FROM stdin;
\.


--
-- Data for Name: protocol_mapper; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.protocol_mapper (id, name, protocol, protocol_mapper_name, client_id, client_scope_id) FROM stdin;
3cd3c24a-aba3-4c27-a008-585551c53c1e	audience resolve	openid-connect	oidc-audience-resolve-mapper	f41e8256-0ee9-460a-a545-2667e84afdf0	\N
de882837-d9dd-4627-a181-149eee16aea2	locale	openid-connect	oidc-usermodel-attribute-mapper	3706d3ff-4038-409b-83c6-eb36c273dc4a	\N
b77a34d5-4730-4d7e-91ff-1f09b6aef0d1	role list	saml	saml-role-list-mapper	\N	283acb3d-e607-4a0c-97d1-ae1b7102146f
7733fd31-d98d-43ed-bb45-77304dc76210	full name	openid-connect	oidc-full-name-mapper	\N	a66e1e63-0c41-43ab-a557-d42a1e0e9179
acb11069-6db9-45ad-90c0-4c3667040995	family name	openid-connect	oidc-usermodel-attribute-mapper	\N	a66e1e63-0c41-43ab-a557-d42a1e0e9179
41a6fc82-1ba9-4e70-938f-703ebe046533	given name	openid-connect	oidc-usermodel-attribute-mapper	\N	a66e1e63-0c41-43ab-a557-d42a1e0e9179
d298c605-5838-4ed0-98fb-636df71f182d	middle name	openid-connect	oidc-usermodel-attribute-mapper	\N	a66e1e63-0c41-43ab-a557-d42a1e0e9179
d146cee5-7a1e-43f7-8d7e-146d6ff1ef4c	nickname	openid-connect	oidc-usermodel-attribute-mapper	\N	a66e1e63-0c41-43ab-a557-d42a1e0e9179
b3a47dfc-437c-47e2-8cc3-73ed1d2409cf	username	openid-connect	oidc-usermodel-attribute-mapper	\N	a66e1e63-0c41-43ab-a557-d42a1e0e9179
52fc573c-d493-4b5c-a757-c91d884cc6d0	profile	openid-connect	oidc-usermodel-attribute-mapper	\N	a66e1e63-0c41-43ab-a557-d42a1e0e9179
4708eecd-a1a3-4872-a4d7-87c11a6dcc24	picture	openid-connect	oidc-usermodel-attribute-mapper	\N	a66e1e63-0c41-43ab-a557-d42a1e0e9179
c885a2fc-4c63-470c-b638-fd8b3738ddaa	website	openid-connect	oidc-usermodel-attribute-mapper	\N	a66e1e63-0c41-43ab-a557-d42a1e0e9179
e22a125f-4456-4a06-bb92-61f8851ef3be	gender	openid-connect	oidc-usermodel-attribute-mapper	\N	a66e1e63-0c41-43ab-a557-d42a1e0e9179
e5684af6-670a-40c0-a8d6-c5613a6bc42d	birthdate	openid-connect	oidc-usermodel-attribute-mapper	\N	a66e1e63-0c41-43ab-a557-d42a1e0e9179
ad4b97ff-bdde-495a-9426-c2af05bfc0e4	zoneinfo	openid-connect	oidc-usermodel-attribute-mapper	\N	a66e1e63-0c41-43ab-a557-d42a1e0e9179
dd6aa8b9-0088-463c-b164-1afc4af8611f	locale	openid-connect	oidc-usermodel-attribute-mapper	\N	a66e1e63-0c41-43ab-a557-d42a1e0e9179
b593f224-a6c0-4971-b172-0e86e85775cd	updated at	openid-connect	oidc-usermodel-attribute-mapper	\N	a66e1e63-0c41-43ab-a557-d42a1e0e9179
d0399173-a23e-445c-a0f1-9c1264b0b043	email	openid-connect	oidc-usermodel-attribute-mapper	\N	fc1ddff4-6764-418f-b4d4-1047530b5443
dc7cb8ba-218c-4afe-899f-290126b9c466	email verified	openid-connect	oidc-usermodel-property-mapper	\N	fc1ddff4-6764-418f-b4d4-1047530b5443
9b648450-d1a1-4de3-a4c1-e77dd86c7dbe	address	openid-connect	oidc-address-mapper	\N	8193e8cb-ecfb-47c1-966c-cd7bf7d1a7c9
4d861ef6-b6a8-4d09-b088-05790182cb6a	phone number	openid-connect	oidc-usermodel-attribute-mapper	\N	37c48668-3df6-4fb9-8009-d1867372a4ca
580a938f-0bd9-40e2-bd20-79f5fee4122c	phone number verified	openid-connect	oidc-usermodel-attribute-mapper	\N	37c48668-3df6-4fb9-8009-d1867372a4ca
edc4bc66-c3e5-488c-8e43-1372df2b689c	realm roles	openid-connect	oidc-usermodel-realm-role-mapper	\N	e037c9df-53a8-40a6-990b-420805196ca4
1526bb3f-2f5b-4f3c-a41f-98bc089428b7	client roles	openid-connect	oidc-usermodel-client-role-mapper	\N	e037c9df-53a8-40a6-990b-420805196ca4
19f34f38-7b5f-435a-97af-843061030a42	audience resolve	openid-connect	oidc-audience-resolve-mapper	\N	e037c9df-53a8-40a6-990b-420805196ca4
5f117327-100a-4d22-a536-066ba3b26576	allowed web origins	openid-connect	oidc-allowed-origins-mapper	\N	9bcf133d-25e0-421a-9b53-3702f24b9da4
4027b08c-312a-4105-82c0-4d35f5e34073	upn	openid-connect	oidc-usermodel-attribute-mapper	\N	0915860d-fbbf-4e07-9de4-2eb4a8540de4
6afd8b20-8c20-424a-bda4-e815f7d6c270	groups	openid-connect	oidc-usermodel-realm-role-mapper	\N	0915860d-fbbf-4e07-9de4-2eb4a8540de4
74a40224-8fd0-41c9-9ccf-fde061e7b7f0	acr loa level	openid-connect	oidc-acr-mapper	\N	6d9433c3-e6f5-4bf9-849f-105e354fe7af
0e404ce2-436a-4ce9-bf3f-bcfccda8c4db	auth_time	openid-connect	oidc-usersessionmodel-note-mapper	\N	7174b2a2-695c-4d32-b84b-b702c0fa3b00
7898a6bb-1097-44c7-b21c-7befee67c8f8	sub	openid-connect	oidc-sub-mapper	\N	7174b2a2-695c-4d32-b84b-b702c0fa3b00
\.


--
-- Data for Name: protocol_mapper_config; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.protocol_mapper_config (protocol_mapper_id, value, name) FROM stdin;
de882837-d9dd-4627-a181-149eee16aea2	true	introspection.token.claim
de882837-d9dd-4627-a181-149eee16aea2	true	userinfo.token.claim
de882837-d9dd-4627-a181-149eee16aea2	locale	user.attribute
de882837-d9dd-4627-a181-149eee16aea2	true	id.token.claim
de882837-d9dd-4627-a181-149eee16aea2	true	access.token.claim
de882837-d9dd-4627-a181-149eee16aea2	locale	claim.name
de882837-d9dd-4627-a181-149eee16aea2	String	jsonType.label
b77a34d5-4730-4d7e-91ff-1f09b6aef0d1	false	single
b77a34d5-4730-4d7e-91ff-1f09b6aef0d1	Basic	attribute.nameformat
b77a34d5-4730-4d7e-91ff-1f09b6aef0d1	Role	attribute.name
41a6fc82-1ba9-4e70-938f-703ebe046533	true	introspection.token.claim
41a6fc82-1ba9-4e70-938f-703ebe046533	true	userinfo.token.claim
41a6fc82-1ba9-4e70-938f-703ebe046533	firstName	user.attribute
41a6fc82-1ba9-4e70-938f-703ebe046533	true	id.token.claim
41a6fc82-1ba9-4e70-938f-703ebe046533	true	access.token.claim
41a6fc82-1ba9-4e70-938f-703ebe046533	given_name	claim.name
41a6fc82-1ba9-4e70-938f-703ebe046533	String	jsonType.label
4708eecd-a1a3-4872-a4d7-87c11a6dcc24	true	introspection.token.claim
4708eecd-a1a3-4872-a4d7-87c11a6dcc24	true	userinfo.token.claim
4708eecd-a1a3-4872-a4d7-87c11a6dcc24	picture	user.attribute
4708eecd-a1a3-4872-a4d7-87c11a6dcc24	true	id.token.claim
4708eecd-a1a3-4872-a4d7-87c11a6dcc24	true	access.token.claim
4708eecd-a1a3-4872-a4d7-87c11a6dcc24	picture	claim.name
4708eecd-a1a3-4872-a4d7-87c11a6dcc24	String	jsonType.label
52fc573c-d493-4b5c-a757-c91d884cc6d0	true	introspection.token.claim
52fc573c-d493-4b5c-a757-c91d884cc6d0	true	userinfo.token.claim
52fc573c-d493-4b5c-a757-c91d884cc6d0	profile	user.attribute
52fc573c-d493-4b5c-a757-c91d884cc6d0	true	id.token.claim
52fc573c-d493-4b5c-a757-c91d884cc6d0	true	access.token.claim
52fc573c-d493-4b5c-a757-c91d884cc6d0	profile	claim.name
52fc573c-d493-4b5c-a757-c91d884cc6d0	String	jsonType.label
7733fd31-d98d-43ed-bb45-77304dc76210	true	introspection.token.claim
7733fd31-d98d-43ed-bb45-77304dc76210	true	userinfo.token.claim
7733fd31-d98d-43ed-bb45-77304dc76210	true	id.token.claim
7733fd31-d98d-43ed-bb45-77304dc76210	true	access.token.claim
acb11069-6db9-45ad-90c0-4c3667040995	true	introspection.token.claim
acb11069-6db9-45ad-90c0-4c3667040995	true	userinfo.token.claim
acb11069-6db9-45ad-90c0-4c3667040995	lastName	user.attribute
acb11069-6db9-45ad-90c0-4c3667040995	true	id.token.claim
acb11069-6db9-45ad-90c0-4c3667040995	true	access.token.claim
acb11069-6db9-45ad-90c0-4c3667040995	family_name	claim.name
acb11069-6db9-45ad-90c0-4c3667040995	String	jsonType.label
ad4b97ff-bdde-495a-9426-c2af05bfc0e4	true	introspection.token.claim
ad4b97ff-bdde-495a-9426-c2af05bfc0e4	true	userinfo.token.claim
ad4b97ff-bdde-495a-9426-c2af05bfc0e4	zoneinfo	user.attribute
ad4b97ff-bdde-495a-9426-c2af05bfc0e4	true	id.token.claim
ad4b97ff-bdde-495a-9426-c2af05bfc0e4	true	access.token.claim
ad4b97ff-bdde-495a-9426-c2af05bfc0e4	zoneinfo	claim.name
ad4b97ff-bdde-495a-9426-c2af05bfc0e4	String	jsonType.label
b3a47dfc-437c-47e2-8cc3-73ed1d2409cf	true	introspection.token.claim
b3a47dfc-437c-47e2-8cc3-73ed1d2409cf	true	userinfo.token.claim
b3a47dfc-437c-47e2-8cc3-73ed1d2409cf	username	user.attribute
b3a47dfc-437c-47e2-8cc3-73ed1d2409cf	true	id.token.claim
b3a47dfc-437c-47e2-8cc3-73ed1d2409cf	true	access.token.claim
b3a47dfc-437c-47e2-8cc3-73ed1d2409cf	preferred_username	claim.name
b3a47dfc-437c-47e2-8cc3-73ed1d2409cf	String	jsonType.label
b593f224-a6c0-4971-b172-0e86e85775cd	true	introspection.token.claim
b593f224-a6c0-4971-b172-0e86e85775cd	true	userinfo.token.claim
b593f224-a6c0-4971-b172-0e86e85775cd	updatedAt	user.attribute
b593f224-a6c0-4971-b172-0e86e85775cd	true	id.token.claim
b593f224-a6c0-4971-b172-0e86e85775cd	true	access.token.claim
b593f224-a6c0-4971-b172-0e86e85775cd	updated_at	claim.name
b593f224-a6c0-4971-b172-0e86e85775cd	long	jsonType.label
c885a2fc-4c63-470c-b638-fd8b3738ddaa	true	introspection.token.claim
c885a2fc-4c63-470c-b638-fd8b3738ddaa	true	userinfo.token.claim
c885a2fc-4c63-470c-b638-fd8b3738ddaa	website	user.attribute
c885a2fc-4c63-470c-b638-fd8b3738ddaa	true	id.token.claim
c885a2fc-4c63-470c-b638-fd8b3738ddaa	true	access.token.claim
c885a2fc-4c63-470c-b638-fd8b3738ddaa	website	claim.name
c885a2fc-4c63-470c-b638-fd8b3738ddaa	String	jsonType.label
d146cee5-7a1e-43f7-8d7e-146d6ff1ef4c	true	introspection.token.claim
d146cee5-7a1e-43f7-8d7e-146d6ff1ef4c	true	userinfo.token.claim
d146cee5-7a1e-43f7-8d7e-146d6ff1ef4c	nickname	user.attribute
d146cee5-7a1e-43f7-8d7e-146d6ff1ef4c	true	id.token.claim
d146cee5-7a1e-43f7-8d7e-146d6ff1ef4c	true	access.token.claim
d146cee5-7a1e-43f7-8d7e-146d6ff1ef4c	nickname	claim.name
d146cee5-7a1e-43f7-8d7e-146d6ff1ef4c	String	jsonType.label
d298c605-5838-4ed0-98fb-636df71f182d	true	introspection.token.claim
d298c605-5838-4ed0-98fb-636df71f182d	true	userinfo.token.claim
d298c605-5838-4ed0-98fb-636df71f182d	middleName	user.attribute
d298c605-5838-4ed0-98fb-636df71f182d	true	id.token.claim
d298c605-5838-4ed0-98fb-636df71f182d	true	access.token.claim
d298c605-5838-4ed0-98fb-636df71f182d	middle_name	claim.name
d298c605-5838-4ed0-98fb-636df71f182d	String	jsonType.label
dd6aa8b9-0088-463c-b164-1afc4af8611f	true	introspection.token.claim
dd6aa8b9-0088-463c-b164-1afc4af8611f	true	userinfo.token.claim
dd6aa8b9-0088-463c-b164-1afc4af8611f	locale	user.attribute
dd6aa8b9-0088-463c-b164-1afc4af8611f	true	id.token.claim
dd6aa8b9-0088-463c-b164-1afc4af8611f	true	access.token.claim
dd6aa8b9-0088-463c-b164-1afc4af8611f	locale	claim.name
dd6aa8b9-0088-463c-b164-1afc4af8611f	String	jsonType.label
e22a125f-4456-4a06-bb92-61f8851ef3be	true	introspection.token.claim
e22a125f-4456-4a06-bb92-61f8851ef3be	true	userinfo.token.claim
e22a125f-4456-4a06-bb92-61f8851ef3be	gender	user.attribute
e22a125f-4456-4a06-bb92-61f8851ef3be	true	id.token.claim
e22a125f-4456-4a06-bb92-61f8851ef3be	true	access.token.claim
e22a125f-4456-4a06-bb92-61f8851ef3be	gender	claim.name
e22a125f-4456-4a06-bb92-61f8851ef3be	String	jsonType.label
e5684af6-670a-40c0-a8d6-c5613a6bc42d	true	introspection.token.claim
e5684af6-670a-40c0-a8d6-c5613a6bc42d	true	userinfo.token.claim
e5684af6-670a-40c0-a8d6-c5613a6bc42d	birthdate	user.attribute
e5684af6-670a-40c0-a8d6-c5613a6bc42d	true	id.token.claim
e5684af6-670a-40c0-a8d6-c5613a6bc42d	true	access.token.claim
e5684af6-670a-40c0-a8d6-c5613a6bc42d	birthdate	claim.name
e5684af6-670a-40c0-a8d6-c5613a6bc42d	String	jsonType.label
d0399173-a23e-445c-a0f1-9c1264b0b043	true	introspection.token.claim
d0399173-a23e-445c-a0f1-9c1264b0b043	true	userinfo.token.claim
d0399173-a23e-445c-a0f1-9c1264b0b043	email	user.attribute
d0399173-a23e-445c-a0f1-9c1264b0b043	true	id.token.claim
d0399173-a23e-445c-a0f1-9c1264b0b043	true	access.token.claim
d0399173-a23e-445c-a0f1-9c1264b0b043	email	claim.name
d0399173-a23e-445c-a0f1-9c1264b0b043	String	jsonType.label
dc7cb8ba-218c-4afe-899f-290126b9c466	true	introspection.token.claim
dc7cb8ba-218c-4afe-899f-290126b9c466	true	userinfo.token.claim
dc7cb8ba-218c-4afe-899f-290126b9c466	emailVerified	user.attribute
dc7cb8ba-218c-4afe-899f-290126b9c466	true	id.token.claim
dc7cb8ba-218c-4afe-899f-290126b9c466	true	access.token.claim
dc7cb8ba-218c-4afe-899f-290126b9c466	email_verified	claim.name
dc7cb8ba-218c-4afe-899f-290126b9c466	boolean	jsonType.label
9b648450-d1a1-4de3-a4c1-e77dd86c7dbe	formatted	user.attribute.formatted
9b648450-d1a1-4de3-a4c1-e77dd86c7dbe	country	user.attribute.country
9b648450-d1a1-4de3-a4c1-e77dd86c7dbe	true	introspection.token.claim
9b648450-d1a1-4de3-a4c1-e77dd86c7dbe	postal_code	user.attribute.postal_code
9b648450-d1a1-4de3-a4c1-e77dd86c7dbe	true	userinfo.token.claim
9b648450-d1a1-4de3-a4c1-e77dd86c7dbe	street	user.attribute.street
9b648450-d1a1-4de3-a4c1-e77dd86c7dbe	true	id.token.claim
9b648450-d1a1-4de3-a4c1-e77dd86c7dbe	region	user.attribute.region
9b648450-d1a1-4de3-a4c1-e77dd86c7dbe	true	access.token.claim
9b648450-d1a1-4de3-a4c1-e77dd86c7dbe	locality	user.attribute.locality
4d861ef6-b6a8-4d09-b088-05790182cb6a	true	introspection.token.claim
4d861ef6-b6a8-4d09-b088-05790182cb6a	true	userinfo.token.claim
4d861ef6-b6a8-4d09-b088-05790182cb6a	phoneNumber	user.attribute
4d861ef6-b6a8-4d09-b088-05790182cb6a	true	id.token.claim
4d861ef6-b6a8-4d09-b088-05790182cb6a	true	access.token.claim
4d861ef6-b6a8-4d09-b088-05790182cb6a	phone_number	claim.name
4d861ef6-b6a8-4d09-b088-05790182cb6a	String	jsonType.label
580a938f-0bd9-40e2-bd20-79f5fee4122c	true	introspection.token.claim
580a938f-0bd9-40e2-bd20-79f5fee4122c	true	userinfo.token.claim
580a938f-0bd9-40e2-bd20-79f5fee4122c	phoneNumberVerified	user.attribute
580a938f-0bd9-40e2-bd20-79f5fee4122c	true	id.token.claim
580a938f-0bd9-40e2-bd20-79f5fee4122c	true	access.token.claim
580a938f-0bd9-40e2-bd20-79f5fee4122c	phone_number_verified	claim.name
580a938f-0bd9-40e2-bd20-79f5fee4122c	boolean	jsonType.label
1526bb3f-2f5b-4f3c-a41f-98bc089428b7	true	introspection.token.claim
1526bb3f-2f5b-4f3c-a41f-98bc089428b7	true	multivalued
1526bb3f-2f5b-4f3c-a41f-98bc089428b7	foo	user.attribute
1526bb3f-2f5b-4f3c-a41f-98bc089428b7	true	access.token.claim
1526bb3f-2f5b-4f3c-a41f-98bc089428b7	resource_access.${client_id}.roles	claim.name
1526bb3f-2f5b-4f3c-a41f-98bc089428b7	String	jsonType.label
19f34f38-7b5f-435a-97af-843061030a42	true	introspection.token.claim
19f34f38-7b5f-435a-97af-843061030a42	true	access.token.claim
edc4bc66-c3e5-488c-8e43-1372df2b689c	true	introspection.token.claim
edc4bc66-c3e5-488c-8e43-1372df2b689c	true	multivalued
edc4bc66-c3e5-488c-8e43-1372df2b689c	foo	user.attribute
edc4bc66-c3e5-488c-8e43-1372df2b689c	true	access.token.claim
edc4bc66-c3e5-488c-8e43-1372df2b689c	realm_access.roles	claim.name
edc4bc66-c3e5-488c-8e43-1372df2b689c	String	jsonType.label
5f117327-100a-4d22-a536-066ba3b26576	true	introspection.token.claim
5f117327-100a-4d22-a536-066ba3b26576	true	access.token.claim
4027b08c-312a-4105-82c0-4d35f5e34073	true	introspection.token.claim
4027b08c-312a-4105-82c0-4d35f5e34073	true	userinfo.token.claim
4027b08c-312a-4105-82c0-4d35f5e34073	username	user.attribute
4027b08c-312a-4105-82c0-4d35f5e34073	true	id.token.claim
4027b08c-312a-4105-82c0-4d35f5e34073	true	access.token.claim
4027b08c-312a-4105-82c0-4d35f5e34073	upn	claim.name
4027b08c-312a-4105-82c0-4d35f5e34073	String	jsonType.label
6afd8b20-8c20-424a-bda4-e815f7d6c270	true	introspection.token.claim
6afd8b20-8c20-424a-bda4-e815f7d6c270	true	multivalued
6afd8b20-8c20-424a-bda4-e815f7d6c270	foo	user.attribute
6afd8b20-8c20-424a-bda4-e815f7d6c270	true	id.token.claim
6afd8b20-8c20-424a-bda4-e815f7d6c270	true	access.token.claim
6afd8b20-8c20-424a-bda4-e815f7d6c270	groups	claim.name
6afd8b20-8c20-424a-bda4-e815f7d6c270	String	jsonType.label
74a40224-8fd0-41c9-9ccf-fde061e7b7f0	true	introspection.token.claim
74a40224-8fd0-41c9-9ccf-fde061e7b7f0	true	id.token.claim
74a40224-8fd0-41c9-9ccf-fde061e7b7f0	true	access.token.claim
0e404ce2-436a-4ce9-bf3f-bcfccda8c4db	AUTH_TIME	user.session.note
0e404ce2-436a-4ce9-bf3f-bcfccda8c4db	true	introspection.token.claim
0e404ce2-436a-4ce9-bf3f-bcfccda8c4db	true	id.token.claim
0e404ce2-436a-4ce9-bf3f-bcfccda8c4db	true	access.token.claim
0e404ce2-436a-4ce9-bf3f-bcfccda8c4db	auth_time	claim.name
0e404ce2-436a-4ce9-bf3f-bcfccda8c4db	long	jsonType.label
7898a6bb-1097-44c7-b21c-7befee67c8f8	true	introspection.token.claim
7898a6bb-1097-44c7-b21c-7befee67c8f8	true	access.token.claim
\.


--
-- Data for Name: realm; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.realm (id, access_code_lifespan, user_action_lifespan, access_token_lifespan, account_theme, admin_theme, email_theme, enabled, events_enabled, events_expiration, login_theme, name, not_before, password_policy, registration_allowed, remember_me, reset_password_allowed, social, ssl_required, sso_idle_timeout, sso_max_lifespan, update_profile_on_soc_login, verify_email, master_admin_client, login_lifespan, internationalization_enabled, default_locale, reg_email_as_username, admin_events_enabled, admin_events_details_enabled, edit_username_allowed, otp_policy_counter, otp_policy_window, otp_policy_period, otp_policy_digits, otp_policy_alg, otp_policy_type, browser_flow, registration_flow, direct_grant_flow, reset_credentials_flow, client_auth_flow, offline_session_idle_timeout, revoke_refresh_token, access_token_life_implicit, login_with_email_allowed, duplicate_emails_allowed, docker_auth_flow, refresh_token_max_reuse, allow_user_managed_access, sso_max_lifespan_remember_me, sso_idle_timeout_remember_me, default_role) FROM stdin;
a26b60a1-fefa-4c54-839e-6fb85147388e	60	300	60	\N	\N	\N	t	f	0	\N	master	0	\N	f	f	f	f	EXTERNAL	1800	36000	f	f	c419fb54-e4aa-4ed2-ac6f-9fcd190ed931	1800	f	\N	f	f	f	f	0	1	30	6	HmacSHA1	totp	7c9c4ba2-9597-436a-be58-54ba336a33cd	2e52b7f8-8fde-48b5-95ed-66a27118eb84	81973622-46a6-4695-8ff3-553bfaa815d0	0224aa28-973f-4393-85e7-bf4f3629b1c3	088837fe-a84b-462e-8710-986328748965	2592000	f	900	t	f	e59550fd-f448-4f7e-a12a-bc42e2bbb5c4	0	f	0	0	2deb75a4-0e6d-4aff-b4a3-a17018b88ac2
\.


--
-- Data for Name: realm_attribute; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.realm_attribute (name, realm_id, value) FROM stdin;
_browser_header.contentSecurityPolicyReportOnly	a26b60a1-fefa-4c54-839e-6fb85147388e	
_browser_header.xContentTypeOptions	a26b60a1-fefa-4c54-839e-6fb85147388e	nosniff
_browser_header.referrerPolicy	a26b60a1-fefa-4c54-839e-6fb85147388e	no-referrer
_browser_header.xRobotsTag	a26b60a1-fefa-4c54-839e-6fb85147388e	none
_browser_header.xFrameOptions	a26b60a1-fefa-4c54-839e-6fb85147388e	SAMEORIGIN
_browser_header.contentSecurityPolicy	a26b60a1-fefa-4c54-839e-6fb85147388e	frame-src 'self'; frame-ancestors 'self'; object-src 'none';
_browser_header.xXSSProtection	a26b60a1-fefa-4c54-839e-6fb85147388e	1; mode=block
_browser_header.strictTransportSecurity	a26b60a1-fefa-4c54-839e-6fb85147388e	max-age=31536000; includeSubDomains
bruteForceProtected	a26b60a1-fefa-4c54-839e-6fb85147388e	false
permanentLockout	a26b60a1-fefa-4c54-839e-6fb85147388e	false
maxTemporaryLockouts	a26b60a1-fefa-4c54-839e-6fb85147388e	0
maxFailureWaitSeconds	a26b60a1-fefa-4c54-839e-6fb85147388e	900
minimumQuickLoginWaitSeconds	a26b60a1-fefa-4c54-839e-6fb85147388e	60
waitIncrementSeconds	a26b60a1-fefa-4c54-839e-6fb85147388e	60
quickLoginCheckMilliSeconds	a26b60a1-fefa-4c54-839e-6fb85147388e	1000
maxDeltaTimeSeconds	a26b60a1-fefa-4c54-839e-6fb85147388e	43200
failureFactor	a26b60a1-fefa-4c54-839e-6fb85147388e	30
realmReusableOtpCode	a26b60a1-fefa-4c54-839e-6fb85147388e	false
firstBrokerLoginFlowId	a26b60a1-fefa-4c54-839e-6fb85147388e	ac698d31-c116-4eb8-ba2d-4bb25764238f
displayName	a26b60a1-fefa-4c54-839e-6fb85147388e	Keycloak
displayNameHtml	a26b60a1-fefa-4c54-839e-6fb85147388e	<div class="kc-logo-text"><span>Keycloak</span></div>
defaultSignatureAlgorithm	a26b60a1-fefa-4c54-839e-6fb85147388e	RS256
offlineSessionMaxLifespanEnabled	a26b60a1-fefa-4c54-839e-6fb85147388e	false
offlineSessionMaxLifespan	a26b60a1-fefa-4c54-839e-6fb85147388e	5184000
\.


--
-- Data for Name: realm_default_groups; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.realm_default_groups (realm_id, group_id) FROM stdin;
\.


--
-- Data for Name: realm_enabled_event_types; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.realm_enabled_event_types (realm_id, value) FROM stdin;
\.


--
-- Data for Name: realm_events_listeners; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.realm_events_listeners (realm_id, value) FROM stdin;
a26b60a1-fefa-4c54-839e-6fb85147388e	jboss-logging
\.


--
-- Data for Name: realm_localizations; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.realm_localizations (realm_id, locale, texts) FROM stdin;
\.


--
-- Data for Name: realm_required_credential; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.realm_required_credential (type, form_label, input, secret, realm_id) FROM stdin;
password	password	t	t	a26b60a1-fefa-4c54-839e-6fb85147388e
\.


--
-- Data for Name: realm_smtp_config; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.realm_smtp_config (realm_id, value, name) FROM stdin;
\.


--
-- Data for Name: realm_supported_locales; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.realm_supported_locales (realm_id, value) FROM stdin;
\.


--
-- Data for Name: redirect_uris; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.redirect_uris (client_id, value) FROM stdin;
67d81828-c34f-4dda-98c0-a530e3c34d9a	/realms/master/account/*
f41e8256-0ee9-460a-a545-2667e84afdf0	/realms/master/account/*
3706d3ff-4038-409b-83c6-eb36c273dc4a	/admin/master/console/*
\.


--
-- Data for Name: required_action_config; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.required_action_config (required_action_id, value, name) FROM stdin;
\.


--
-- Data for Name: required_action_provider; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.required_action_provider (id, alias, name, realm_id, enabled, default_action, provider_id, priority) FROM stdin;
fb307677-58a9-421b-b33d-7f198470c556	VERIFY_EMAIL	Verify Email	a26b60a1-fefa-4c54-839e-6fb85147388e	t	f	VERIFY_EMAIL	50
71dec7c4-dba7-4dfd-91ab-b5b32d1b89b6	UPDATE_PROFILE	Update Profile	a26b60a1-fefa-4c54-839e-6fb85147388e	t	f	UPDATE_PROFILE	40
5de20537-0e4f-4b4d-a0c0-087fe0e68baa	CONFIGURE_TOTP	Configure OTP	a26b60a1-fefa-4c54-839e-6fb85147388e	t	f	CONFIGURE_TOTP	10
4487a018-fb16-4a1a-bd39-77dca22967c6	UPDATE_PASSWORD	Update Password	a26b60a1-fefa-4c54-839e-6fb85147388e	t	f	UPDATE_PASSWORD	30
88edf2b4-bb3b-46db-83b1-f3a927e0368f	TERMS_AND_CONDITIONS	Terms and Conditions	a26b60a1-fefa-4c54-839e-6fb85147388e	f	f	TERMS_AND_CONDITIONS	20
11f32748-9e7d-4727-9ee9-331810fa6e5c	delete_account	Delete Account	a26b60a1-fefa-4c54-839e-6fb85147388e	f	f	delete_account	60
3bd0058f-601a-4c7a-8755-fd76d1b5a246	delete_credential	Delete Credential	a26b60a1-fefa-4c54-839e-6fb85147388e	t	f	delete_credential	100
991fbc19-db8a-4fc4-8375-28bc5ca71bda	update_user_locale	Update User Locale	a26b60a1-fefa-4c54-839e-6fb85147388e	t	f	update_user_locale	1000
5833f786-1a17-4e22-b623-87c8861437b5	webauthn-register	Webauthn Register	a26b60a1-fefa-4c54-839e-6fb85147388e	t	f	webauthn-register	70
082fbbc1-249f-4e02-97d3-a108c1e41056	webauthn-register-passwordless	Webauthn Register Passwordless	a26b60a1-fefa-4c54-839e-6fb85147388e	t	f	webauthn-register-passwordless	80
028f3f3f-a736-4c68-b5d2-8b787fcdf8a9	VERIFY_PROFILE	Verify Profile	a26b60a1-fefa-4c54-839e-6fb85147388e	t	f	VERIFY_PROFILE	90
\.


--
-- Data for Name: resource_attribute; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.resource_attribute (id, name, value, resource_id) FROM stdin;
\.


--
-- Data for Name: resource_policy; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.resource_policy (resource_id, policy_id) FROM stdin;
\.


--
-- Data for Name: resource_scope; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.resource_scope (resource_id, scope_id) FROM stdin;
\.


--
-- Data for Name: resource_server; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.resource_server (id, allow_rs_remote_mgmt, policy_enforce_mode, decision_strategy) FROM stdin;
\.


--
-- Data for Name: resource_server_perm_ticket; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.resource_server_perm_ticket (id, owner, requester, created_timestamp, granted_timestamp, resource_id, scope_id, resource_server_id, policy_id) FROM stdin;
\.


--
-- Data for Name: resource_server_policy; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.resource_server_policy (id, name, description, type, decision_strategy, logic, resource_server_id, owner) FROM stdin;
\.


--
-- Data for Name: resource_server_resource; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.resource_server_resource (id, name, type, icon_uri, owner, resource_server_id, owner_managed_access, display_name) FROM stdin;
\.


--
-- Data for Name: resource_server_scope; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.resource_server_scope (id, name, icon_uri, resource_server_id, display_name) FROM stdin;
\.


--
-- Data for Name: resource_uris; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.resource_uris (resource_id, value) FROM stdin;
\.


--
-- Data for Name: role_attribute; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.role_attribute (id, role_id, name, value) FROM stdin;
\.


--
-- Data for Name: scope_mapping; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.scope_mapping (client_id, role_id) FROM stdin;
f41e8256-0ee9-460a-a545-2667e84afdf0	bd7bd206-2295-41b7-b5fe-1e5ed25f3e23
f41e8256-0ee9-460a-a545-2667e84afdf0	316c18db-5809-4040-96a9-fd42e7182823
\.


--
-- Data for Name: scope_policy; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.scope_policy (scope_id, policy_id) FROM stdin;
\.


--
-- Data for Name: user_attribute; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.user_attribute (name, value, user_id, id, long_value_hash, long_value_hash_lower_case, long_value) FROM stdin;
\.


--
-- Data for Name: user_consent; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.user_consent (id, client_id, user_id, created_date, last_updated_date, client_storage_provider, external_client_id) FROM stdin;
\.


--
-- Data for Name: user_consent_client_scope; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.user_consent_client_scope (user_consent_id, scope_id) FROM stdin;
\.


--
-- Data for Name: user_entity; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.user_entity (id, email, email_constraint, email_verified, enabled, federation_link, first_name, last_name, realm_id, username, created_timestamp, service_account_client_link, not_before) FROM stdin;
803396c1-4e48-461b-a89a-6fc8791941cf	\N	88ec1067-fd74-4801-af4c-a8e5607d69f2	f	t	\N	\N	\N	a26b60a1-fefa-4c54-839e-6fb85147388e	admin	1782167883549	\N	0
\.


--
-- Data for Name: user_federation_config; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.user_federation_config (user_federation_provider_id, value, name) FROM stdin;
\.


--
-- Data for Name: user_federation_mapper; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.user_federation_mapper (id, name, federation_provider_id, federation_mapper_type, realm_id) FROM stdin;
\.


--
-- Data for Name: user_federation_mapper_config; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.user_federation_mapper_config (user_federation_mapper_id, value, name) FROM stdin;
\.


--
-- Data for Name: user_federation_provider; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.user_federation_provider (id, changed_sync_period, display_name, full_sync_period, last_sync, priority, provider_name, realm_id) FROM stdin;
\.


--
-- Data for Name: user_group_membership; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.user_group_membership (group_id, user_id) FROM stdin;
\.


--
-- Data for Name: user_required_action; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.user_required_action (user_id, required_action) FROM stdin;
\.


--
-- Data for Name: user_role_mapping; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.user_role_mapping (role_id, user_id) FROM stdin;
2deb75a4-0e6d-4aff-b4a3-a17018b88ac2	803396c1-4e48-461b-a89a-6fc8791941cf
5e20b5b3-6602-42ae-9989-b41f67276069	803396c1-4e48-461b-a89a-6fc8791941cf
\.


--
-- Data for Name: user_session; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.user_session (id, auth_method, ip_address, last_session_refresh, login_username, realm_id, remember_me, started, user_id, user_session_state, broker_session_id, broker_user_id) FROM stdin;
\.


--
-- Data for Name: user_session_note; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.user_session_note (user_session, name, value) FROM stdin;
\.


--
-- Data for Name: username_login_failure; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.username_login_failure (realm_id, username, failed_login_not_before, last_failure, last_ip_failure, num_failures) FROM stdin;
\.


--
-- Data for Name: web_origins; Type: TABLE DATA; Schema: public; Owner: imobflow
--

COPY public.web_origins (client_id, value) FROM stdin;
3706d3ff-4038-409b-83c6-eb36c273dc4a	+
\.


--
-- Name: username_login_failure CONSTRAINT_17-2; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.username_login_failure
    ADD CONSTRAINT "CONSTRAINT_17-2" PRIMARY KEY (realm_id, username);


--
-- Name: org_domain ORG_DOMAIN_pkey; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.org_domain
    ADD CONSTRAINT "ORG_DOMAIN_pkey" PRIMARY KEY (id, name);


--
-- Name: org ORG_pkey; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.org
    ADD CONSTRAINT "ORG_pkey" PRIMARY KEY (id);


--
-- Name: keycloak_role UK_J3RWUVD56ONTGSUHOGM184WW2-2; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.keycloak_role
    ADD CONSTRAINT "UK_J3RWUVD56ONTGSUHOGM184WW2-2" UNIQUE (name, client_realm_constraint);


--
-- Name: client_auth_flow_bindings c_cli_flow_bind; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.client_auth_flow_bindings
    ADD CONSTRAINT c_cli_flow_bind PRIMARY KEY (client_id, binding_name);


--
-- Name: client_scope_client c_cli_scope_bind; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.client_scope_client
    ADD CONSTRAINT c_cli_scope_bind PRIMARY KEY (client_id, scope_id);


--
-- Name: client_initial_access cnstr_client_init_acc_pk; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.client_initial_access
    ADD CONSTRAINT cnstr_client_init_acc_pk PRIMARY KEY (id);


--
-- Name: realm_default_groups con_group_id_def_groups; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.realm_default_groups
    ADD CONSTRAINT con_group_id_def_groups UNIQUE (group_id);


--
-- Name: broker_link constr_broker_link_pk; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.broker_link
    ADD CONSTRAINT constr_broker_link_pk PRIMARY KEY (identity_provider, user_id);


--
-- Name: client_user_session_note constr_cl_usr_ses_note; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.client_user_session_note
    ADD CONSTRAINT constr_cl_usr_ses_note PRIMARY KEY (client_session, name);


--
-- Name: component_config constr_component_config_pk; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.component_config
    ADD CONSTRAINT constr_component_config_pk PRIMARY KEY (id);


--
-- Name: component constr_component_pk; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.component
    ADD CONSTRAINT constr_component_pk PRIMARY KEY (id);


--
-- Name: fed_user_required_action constr_fed_required_action; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.fed_user_required_action
    ADD CONSTRAINT constr_fed_required_action PRIMARY KEY (required_action, user_id);


--
-- Name: fed_user_attribute constr_fed_user_attr_pk; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.fed_user_attribute
    ADD CONSTRAINT constr_fed_user_attr_pk PRIMARY KEY (id);


--
-- Name: fed_user_consent constr_fed_user_consent_pk; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.fed_user_consent
    ADD CONSTRAINT constr_fed_user_consent_pk PRIMARY KEY (id);


--
-- Name: fed_user_credential constr_fed_user_cred_pk; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.fed_user_credential
    ADD CONSTRAINT constr_fed_user_cred_pk PRIMARY KEY (id);


--
-- Name: fed_user_group_membership constr_fed_user_group; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.fed_user_group_membership
    ADD CONSTRAINT constr_fed_user_group PRIMARY KEY (group_id, user_id);


--
-- Name: fed_user_role_mapping constr_fed_user_role; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.fed_user_role_mapping
    ADD CONSTRAINT constr_fed_user_role PRIMARY KEY (role_id, user_id);


--
-- Name: federated_user constr_federated_user; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.federated_user
    ADD CONSTRAINT constr_federated_user PRIMARY KEY (id);


--
-- Name: realm_default_groups constr_realm_default_groups; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.realm_default_groups
    ADD CONSTRAINT constr_realm_default_groups PRIMARY KEY (realm_id, group_id);


--
-- Name: realm_enabled_event_types constr_realm_enabl_event_types; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.realm_enabled_event_types
    ADD CONSTRAINT constr_realm_enabl_event_types PRIMARY KEY (realm_id, value);


--
-- Name: realm_events_listeners constr_realm_events_listeners; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.realm_events_listeners
    ADD CONSTRAINT constr_realm_events_listeners PRIMARY KEY (realm_id, value);


--
-- Name: realm_supported_locales constr_realm_supported_locales; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.realm_supported_locales
    ADD CONSTRAINT constr_realm_supported_locales PRIMARY KEY (realm_id, value);


--
-- Name: identity_provider constraint_2b; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.identity_provider
    ADD CONSTRAINT constraint_2b PRIMARY KEY (internal_id);


--
-- Name: client_attributes constraint_3c; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.client_attributes
    ADD CONSTRAINT constraint_3c PRIMARY KEY (client_id, name);


--
-- Name: event_entity constraint_4; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.event_entity
    ADD CONSTRAINT constraint_4 PRIMARY KEY (id);


--
-- Name: federated_identity constraint_40; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.federated_identity
    ADD CONSTRAINT constraint_40 PRIMARY KEY (identity_provider, user_id);


--
-- Name: realm constraint_4a; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.realm
    ADD CONSTRAINT constraint_4a PRIMARY KEY (id);


--
-- Name: client_session_role constraint_5; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.client_session_role
    ADD CONSTRAINT constraint_5 PRIMARY KEY (client_session, role_id);


--
-- Name: user_session constraint_57; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.user_session
    ADD CONSTRAINT constraint_57 PRIMARY KEY (id);


--
-- Name: user_federation_provider constraint_5c; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.user_federation_provider
    ADD CONSTRAINT constraint_5c PRIMARY KEY (id);


--
-- Name: client_session_note constraint_5e; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.client_session_note
    ADD CONSTRAINT constraint_5e PRIMARY KEY (client_session, name);


--
-- Name: client constraint_7; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT constraint_7 PRIMARY KEY (id);


--
-- Name: client_session constraint_8; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.client_session
    ADD CONSTRAINT constraint_8 PRIMARY KEY (id);


--
-- Name: scope_mapping constraint_81; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.scope_mapping
    ADD CONSTRAINT constraint_81 PRIMARY KEY (client_id, role_id);


--
-- Name: client_node_registrations constraint_84; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.client_node_registrations
    ADD CONSTRAINT constraint_84 PRIMARY KEY (client_id, name);


--
-- Name: realm_attribute constraint_9; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.realm_attribute
    ADD CONSTRAINT constraint_9 PRIMARY KEY (name, realm_id);


--
-- Name: realm_required_credential constraint_92; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.realm_required_credential
    ADD CONSTRAINT constraint_92 PRIMARY KEY (realm_id, type);


--
-- Name: keycloak_role constraint_a; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.keycloak_role
    ADD CONSTRAINT constraint_a PRIMARY KEY (id);


--
-- Name: admin_event_entity constraint_admin_event_entity; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.admin_event_entity
    ADD CONSTRAINT constraint_admin_event_entity PRIMARY KEY (id);


--
-- Name: authenticator_config_entry constraint_auth_cfg_pk; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.authenticator_config_entry
    ADD CONSTRAINT constraint_auth_cfg_pk PRIMARY KEY (authenticator_id, name);


--
-- Name: authentication_execution constraint_auth_exec_pk; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.authentication_execution
    ADD CONSTRAINT constraint_auth_exec_pk PRIMARY KEY (id);


--
-- Name: authentication_flow constraint_auth_flow_pk; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.authentication_flow
    ADD CONSTRAINT constraint_auth_flow_pk PRIMARY KEY (id);


--
-- Name: authenticator_config constraint_auth_pk; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.authenticator_config
    ADD CONSTRAINT constraint_auth_pk PRIMARY KEY (id);


--
-- Name: client_session_auth_status constraint_auth_status_pk; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.client_session_auth_status
    ADD CONSTRAINT constraint_auth_status_pk PRIMARY KEY (client_session, authenticator);


--
-- Name: user_role_mapping constraint_c; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.user_role_mapping
    ADD CONSTRAINT constraint_c PRIMARY KEY (role_id, user_id);


--
-- Name: composite_role constraint_composite_role; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.composite_role
    ADD CONSTRAINT constraint_composite_role PRIMARY KEY (composite, child_role);


--
-- Name: client_session_prot_mapper constraint_cs_pmp_pk; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.client_session_prot_mapper
    ADD CONSTRAINT constraint_cs_pmp_pk PRIMARY KEY (client_session, protocol_mapper_id);


--
-- Name: identity_provider_config constraint_d; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.identity_provider_config
    ADD CONSTRAINT constraint_d PRIMARY KEY (identity_provider_id, name);


--
-- Name: policy_config constraint_dpc; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.policy_config
    ADD CONSTRAINT constraint_dpc PRIMARY KEY (policy_id, name);


--
-- Name: realm_smtp_config constraint_e; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.realm_smtp_config
    ADD CONSTRAINT constraint_e PRIMARY KEY (realm_id, name);


--
-- Name: credential constraint_f; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.credential
    ADD CONSTRAINT constraint_f PRIMARY KEY (id);


--
-- Name: user_federation_config constraint_f9; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.user_federation_config
    ADD CONSTRAINT constraint_f9 PRIMARY KEY (user_federation_provider_id, name);


--
-- Name: resource_server_perm_ticket constraint_fapmt; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT constraint_fapmt PRIMARY KEY (id);


--
-- Name: resource_server_resource constraint_farsr; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.resource_server_resource
    ADD CONSTRAINT constraint_farsr PRIMARY KEY (id);


--
-- Name: resource_server_policy constraint_farsrp; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.resource_server_policy
    ADD CONSTRAINT constraint_farsrp PRIMARY KEY (id);


--
-- Name: associated_policy constraint_farsrpap; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.associated_policy
    ADD CONSTRAINT constraint_farsrpap PRIMARY KEY (policy_id, associated_policy_id);


--
-- Name: resource_policy constraint_farsrpp; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.resource_policy
    ADD CONSTRAINT constraint_farsrpp PRIMARY KEY (resource_id, policy_id);


--
-- Name: resource_server_scope constraint_farsrs; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.resource_server_scope
    ADD CONSTRAINT constraint_farsrs PRIMARY KEY (id);


--
-- Name: resource_scope constraint_farsrsp; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.resource_scope
    ADD CONSTRAINT constraint_farsrsp PRIMARY KEY (resource_id, scope_id);


--
-- Name: scope_policy constraint_farsrsps; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.scope_policy
    ADD CONSTRAINT constraint_farsrsps PRIMARY KEY (scope_id, policy_id);


--
-- Name: user_entity constraint_fb; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT constraint_fb PRIMARY KEY (id);


--
-- Name: user_federation_mapper_config constraint_fedmapper_cfg_pm; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.user_federation_mapper_config
    ADD CONSTRAINT constraint_fedmapper_cfg_pm PRIMARY KEY (user_federation_mapper_id, name);


--
-- Name: user_federation_mapper constraint_fedmapperpm; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.user_federation_mapper
    ADD CONSTRAINT constraint_fedmapperpm PRIMARY KEY (id);


--
-- Name: fed_user_consent_cl_scope constraint_fgrntcsnt_clsc_pm; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.fed_user_consent_cl_scope
    ADD CONSTRAINT constraint_fgrntcsnt_clsc_pm PRIMARY KEY (user_consent_id, scope_id);


--
-- Name: user_consent_client_scope constraint_grntcsnt_clsc_pm; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.user_consent_client_scope
    ADD CONSTRAINT constraint_grntcsnt_clsc_pm PRIMARY KEY (user_consent_id, scope_id);


--
-- Name: user_consent constraint_grntcsnt_pm; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT constraint_grntcsnt_pm PRIMARY KEY (id);


--
-- Name: keycloak_group constraint_group; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.keycloak_group
    ADD CONSTRAINT constraint_group PRIMARY KEY (id);


--
-- Name: group_attribute constraint_group_attribute_pk; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.group_attribute
    ADD CONSTRAINT constraint_group_attribute_pk PRIMARY KEY (id);


--
-- Name: group_role_mapping constraint_group_role; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.group_role_mapping
    ADD CONSTRAINT constraint_group_role PRIMARY KEY (role_id, group_id);


--
-- Name: identity_provider_mapper constraint_idpm; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.identity_provider_mapper
    ADD CONSTRAINT constraint_idpm PRIMARY KEY (id);


--
-- Name: idp_mapper_config constraint_idpmconfig; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.idp_mapper_config
    ADD CONSTRAINT constraint_idpmconfig PRIMARY KEY (idp_mapper_id, name);


--
-- Name: migration_model constraint_migmod; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.migration_model
    ADD CONSTRAINT constraint_migmod PRIMARY KEY (id);


--
-- Name: offline_client_session constraint_offl_cl_ses_pk3; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.offline_client_session
    ADD CONSTRAINT constraint_offl_cl_ses_pk3 PRIMARY KEY (user_session_id, client_id, client_storage_provider, external_client_id, offline_flag);


--
-- Name: offline_user_session constraint_offl_us_ses_pk2; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.offline_user_session
    ADD CONSTRAINT constraint_offl_us_ses_pk2 PRIMARY KEY (user_session_id, offline_flag);


--
-- Name: protocol_mapper constraint_pcm; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.protocol_mapper
    ADD CONSTRAINT constraint_pcm PRIMARY KEY (id);


--
-- Name: protocol_mapper_config constraint_pmconfig; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.protocol_mapper_config
    ADD CONSTRAINT constraint_pmconfig PRIMARY KEY (protocol_mapper_id, name);


--
-- Name: redirect_uris constraint_redirect_uris; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.redirect_uris
    ADD CONSTRAINT constraint_redirect_uris PRIMARY KEY (client_id, value);


--
-- Name: required_action_config constraint_req_act_cfg_pk; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.required_action_config
    ADD CONSTRAINT constraint_req_act_cfg_pk PRIMARY KEY (required_action_id, name);


--
-- Name: required_action_provider constraint_req_act_prv_pk; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.required_action_provider
    ADD CONSTRAINT constraint_req_act_prv_pk PRIMARY KEY (id);


--
-- Name: user_required_action constraint_required_action; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.user_required_action
    ADD CONSTRAINT constraint_required_action PRIMARY KEY (required_action, user_id);


--
-- Name: resource_uris constraint_resour_uris_pk; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.resource_uris
    ADD CONSTRAINT constraint_resour_uris_pk PRIMARY KEY (resource_id, value);


--
-- Name: role_attribute constraint_role_attribute_pk; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.role_attribute
    ADD CONSTRAINT constraint_role_attribute_pk PRIMARY KEY (id);


--
-- Name: user_attribute constraint_user_attribute_pk; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.user_attribute
    ADD CONSTRAINT constraint_user_attribute_pk PRIMARY KEY (id);


--
-- Name: user_group_membership constraint_user_group; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.user_group_membership
    ADD CONSTRAINT constraint_user_group PRIMARY KEY (group_id, user_id);


--
-- Name: user_session_note constraint_usn_pk; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.user_session_note
    ADD CONSTRAINT constraint_usn_pk PRIMARY KEY (user_session, name);


--
-- Name: web_origins constraint_web_origins; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.web_origins
    ADD CONSTRAINT constraint_web_origins PRIMARY KEY (client_id, value);


--
-- Name: databasechangeloglock databasechangeloglock_pkey; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.databasechangeloglock
    ADD CONSTRAINT databasechangeloglock_pkey PRIMARY KEY (id);


--
-- Name: client_scope_attributes pk_cl_tmpl_attr; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.client_scope_attributes
    ADD CONSTRAINT pk_cl_tmpl_attr PRIMARY KEY (scope_id, name);


--
-- Name: client_scope pk_cli_template; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.client_scope
    ADD CONSTRAINT pk_cli_template PRIMARY KEY (id);


--
-- Name: resource_server pk_resource_server; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.resource_server
    ADD CONSTRAINT pk_resource_server PRIMARY KEY (id);


--
-- Name: client_scope_role_mapping pk_template_scope; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.client_scope_role_mapping
    ADD CONSTRAINT pk_template_scope PRIMARY KEY (scope_id, role_id);


--
-- Name: default_client_scope r_def_cli_scope_bind; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.default_client_scope
    ADD CONSTRAINT r_def_cli_scope_bind PRIMARY KEY (realm_id, scope_id);


--
-- Name: realm_localizations realm_localizations_pkey; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.realm_localizations
    ADD CONSTRAINT realm_localizations_pkey PRIMARY KEY (realm_id, locale);


--
-- Name: resource_attribute res_attr_pk; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.resource_attribute
    ADD CONSTRAINT res_attr_pk PRIMARY KEY (id);


--
-- Name: keycloak_group sibling_names; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.keycloak_group
    ADD CONSTRAINT sibling_names UNIQUE (realm_id, parent_group, name);


--
-- Name: identity_provider uk_2daelwnibji49avxsrtuf6xj33; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.identity_provider
    ADD CONSTRAINT uk_2daelwnibji49avxsrtuf6xj33 UNIQUE (provider_alias, realm_id);


--
-- Name: client uk_b71cjlbenv945rb6gcon438at; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT uk_b71cjlbenv945rb6gcon438at UNIQUE (realm_id, client_id);


--
-- Name: client_scope uk_cli_scope; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.client_scope
    ADD CONSTRAINT uk_cli_scope UNIQUE (realm_id, name);


--
-- Name: user_entity uk_dykn684sl8up1crfei6eckhd7; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT uk_dykn684sl8up1crfei6eckhd7 UNIQUE (realm_id, email_constraint);


--
-- Name: user_consent uk_external_consent; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT uk_external_consent UNIQUE (client_storage_provider, external_client_id, user_id);


--
-- Name: resource_server_resource uk_frsr6t700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.resource_server_resource
    ADD CONSTRAINT uk_frsr6t700s9v50bu18ws5ha6 UNIQUE (name, owner, resource_server_id);


--
-- Name: resource_server_perm_ticket uk_frsr6t700s9v50bu18ws5pmt; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT uk_frsr6t700s9v50bu18ws5pmt UNIQUE (owner, requester, resource_server_id, resource_id, scope_id);


--
-- Name: resource_server_policy uk_frsrpt700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.resource_server_policy
    ADD CONSTRAINT uk_frsrpt700s9v50bu18ws5ha6 UNIQUE (name, resource_server_id);


--
-- Name: resource_server_scope uk_frsrst700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.resource_server_scope
    ADD CONSTRAINT uk_frsrst700s9v50bu18ws5ha6 UNIQUE (name, resource_server_id);


--
-- Name: user_consent uk_local_consent; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT uk_local_consent UNIQUE (client_id, user_id);


--
-- Name: org uk_org_group; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.org
    ADD CONSTRAINT uk_org_group UNIQUE (group_id);


--
-- Name: org uk_org_name; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.org
    ADD CONSTRAINT uk_org_name UNIQUE (realm_id, name);


--
-- Name: realm uk_orvsdmla56612eaefiq6wl5oi; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.realm
    ADD CONSTRAINT uk_orvsdmla56612eaefiq6wl5oi UNIQUE (name);


--
-- Name: user_entity uk_ru8tt6t700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT uk_ru8tt6t700s9v50bu18ws5ha6 UNIQUE (realm_id, username);


--
-- Name: fed_user_attr_long_values; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX fed_user_attr_long_values ON public.fed_user_attribute USING btree (long_value_hash, name);


--
-- Name: fed_user_attr_long_values_lower_case; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX fed_user_attr_long_values_lower_case ON public.fed_user_attribute USING btree (long_value_hash_lower_case, name);


--
-- Name: idx_admin_event_time; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_admin_event_time ON public.admin_event_entity USING btree (realm_id, admin_event_time);


--
-- Name: idx_assoc_pol_assoc_pol_id; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_assoc_pol_assoc_pol_id ON public.associated_policy USING btree (associated_policy_id);


--
-- Name: idx_auth_config_realm; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_auth_config_realm ON public.authenticator_config USING btree (realm_id);


--
-- Name: idx_auth_exec_flow; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_auth_exec_flow ON public.authentication_execution USING btree (flow_id);


--
-- Name: idx_auth_exec_realm_flow; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_auth_exec_realm_flow ON public.authentication_execution USING btree (realm_id, flow_id);


--
-- Name: idx_auth_flow_realm; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_auth_flow_realm ON public.authentication_flow USING btree (realm_id);


--
-- Name: idx_cl_clscope; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_cl_clscope ON public.client_scope_client USING btree (scope_id);


--
-- Name: idx_client_att_by_name_value; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_client_att_by_name_value ON public.client_attributes USING btree (name, substr(value, 1, 255));


--
-- Name: idx_client_id; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_client_id ON public.client USING btree (client_id);


--
-- Name: idx_client_init_acc_realm; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_client_init_acc_realm ON public.client_initial_access USING btree (realm_id);


--
-- Name: idx_client_session_session; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_client_session_session ON public.client_session USING btree (session_id);


--
-- Name: idx_clscope_attrs; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_clscope_attrs ON public.client_scope_attributes USING btree (scope_id);


--
-- Name: idx_clscope_cl; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_clscope_cl ON public.client_scope_client USING btree (client_id);


--
-- Name: idx_clscope_protmap; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_clscope_protmap ON public.protocol_mapper USING btree (client_scope_id);


--
-- Name: idx_clscope_role; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_clscope_role ON public.client_scope_role_mapping USING btree (scope_id);


--
-- Name: idx_compo_config_compo; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_compo_config_compo ON public.component_config USING btree (component_id);


--
-- Name: idx_component_provider_type; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_component_provider_type ON public.component USING btree (provider_type);


--
-- Name: idx_component_realm; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_component_realm ON public.component USING btree (realm_id);


--
-- Name: idx_composite; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_composite ON public.composite_role USING btree (composite);


--
-- Name: idx_composite_child; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_composite_child ON public.composite_role USING btree (child_role);


--
-- Name: idx_defcls_realm; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_defcls_realm ON public.default_client_scope USING btree (realm_id);


--
-- Name: idx_defcls_scope; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_defcls_scope ON public.default_client_scope USING btree (scope_id);


--
-- Name: idx_event_time; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_event_time ON public.event_entity USING btree (realm_id, event_time);


--
-- Name: idx_fedidentity_feduser; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_fedidentity_feduser ON public.federated_identity USING btree (federated_user_id);


--
-- Name: idx_fedidentity_user; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_fedidentity_user ON public.federated_identity USING btree (user_id);


--
-- Name: idx_fu_attribute; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_fu_attribute ON public.fed_user_attribute USING btree (user_id, realm_id, name);


--
-- Name: idx_fu_cnsnt_ext; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_fu_cnsnt_ext ON public.fed_user_consent USING btree (user_id, client_storage_provider, external_client_id);


--
-- Name: idx_fu_consent; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_fu_consent ON public.fed_user_consent USING btree (user_id, client_id);


--
-- Name: idx_fu_consent_ru; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_fu_consent_ru ON public.fed_user_consent USING btree (realm_id, user_id);


--
-- Name: idx_fu_credential; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_fu_credential ON public.fed_user_credential USING btree (user_id, type);


--
-- Name: idx_fu_credential_ru; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_fu_credential_ru ON public.fed_user_credential USING btree (realm_id, user_id);


--
-- Name: idx_fu_group_membership; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_fu_group_membership ON public.fed_user_group_membership USING btree (user_id, group_id);


--
-- Name: idx_fu_group_membership_ru; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_fu_group_membership_ru ON public.fed_user_group_membership USING btree (realm_id, user_id);


--
-- Name: idx_fu_required_action; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_fu_required_action ON public.fed_user_required_action USING btree (user_id, required_action);


--
-- Name: idx_fu_required_action_ru; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_fu_required_action_ru ON public.fed_user_required_action USING btree (realm_id, user_id);


--
-- Name: idx_fu_role_mapping; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_fu_role_mapping ON public.fed_user_role_mapping USING btree (user_id, role_id);


--
-- Name: idx_fu_role_mapping_ru; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_fu_role_mapping_ru ON public.fed_user_role_mapping USING btree (realm_id, user_id);


--
-- Name: idx_group_att_by_name_value; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_group_att_by_name_value ON public.group_attribute USING btree (name, ((value)::character varying(250)));


--
-- Name: idx_group_attr_group; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_group_attr_group ON public.group_attribute USING btree (group_id);


--
-- Name: idx_group_role_mapp_group; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_group_role_mapp_group ON public.group_role_mapping USING btree (group_id);


--
-- Name: idx_id_prov_mapp_realm; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_id_prov_mapp_realm ON public.identity_provider_mapper USING btree (realm_id);


--
-- Name: idx_ident_prov_realm; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_ident_prov_realm ON public.identity_provider USING btree (realm_id);


--
-- Name: idx_keycloak_role_client; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_keycloak_role_client ON public.keycloak_role USING btree (client);


--
-- Name: idx_keycloak_role_realm; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_keycloak_role_realm ON public.keycloak_role USING btree (realm);


--
-- Name: idx_offline_uss_by_broker_session_id; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_offline_uss_by_broker_session_id ON public.offline_user_session USING btree (broker_session_id, realm_id);


--
-- Name: idx_offline_uss_by_last_session_refresh; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_offline_uss_by_last_session_refresh ON public.offline_user_session USING btree (realm_id, offline_flag, last_session_refresh);


--
-- Name: idx_offline_uss_by_user; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_offline_uss_by_user ON public.offline_user_session USING btree (user_id, realm_id, offline_flag);


--
-- Name: idx_perm_ticket_owner; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_perm_ticket_owner ON public.resource_server_perm_ticket USING btree (owner);


--
-- Name: idx_perm_ticket_requester; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_perm_ticket_requester ON public.resource_server_perm_ticket USING btree (requester);


--
-- Name: idx_protocol_mapper_client; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_protocol_mapper_client ON public.protocol_mapper USING btree (client_id);


--
-- Name: idx_realm_attr_realm; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_realm_attr_realm ON public.realm_attribute USING btree (realm_id);


--
-- Name: idx_realm_clscope; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_realm_clscope ON public.client_scope USING btree (realm_id);


--
-- Name: idx_realm_def_grp_realm; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_realm_def_grp_realm ON public.realm_default_groups USING btree (realm_id);


--
-- Name: idx_realm_evt_list_realm; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_realm_evt_list_realm ON public.realm_events_listeners USING btree (realm_id);


--
-- Name: idx_realm_evt_types_realm; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_realm_evt_types_realm ON public.realm_enabled_event_types USING btree (realm_id);


--
-- Name: idx_realm_master_adm_cli; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_realm_master_adm_cli ON public.realm USING btree (master_admin_client);


--
-- Name: idx_realm_supp_local_realm; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_realm_supp_local_realm ON public.realm_supported_locales USING btree (realm_id);


--
-- Name: idx_redir_uri_client; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_redir_uri_client ON public.redirect_uris USING btree (client_id);


--
-- Name: idx_req_act_prov_realm; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_req_act_prov_realm ON public.required_action_provider USING btree (realm_id);


--
-- Name: idx_res_policy_policy; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_res_policy_policy ON public.resource_policy USING btree (policy_id);


--
-- Name: idx_res_scope_scope; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_res_scope_scope ON public.resource_scope USING btree (scope_id);


--
-- Name: idx_res_serv_pol_res_serv; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_res_serv_pol_res_serv ON public.resource_server_policy USING btree (resource_server_id);


--
-- Name: idx_res_srv_res_res_srv; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_res_srv_res_res_srv ON public.resource_server_resource USING btree (resource_server_id);


--
-- Name: idx_res_srv_scope_res_srv; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_res_srv_scope_res_srv ON public.resource_server_scope USING btree (resource_server_id);


--
-- Name: idx_role_attribute; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_role_attribute ON public.role_attribute USING btree (role_id);


--
-- Name: idx_role_clscope; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_role_clscope ON public.client_scope_role_mapping USING btree (role_id);


--
-- Name: idx_scope_mapping_role; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_scope_mapping_role ON public.scope_mapping USING btree (role_id);


--
-- Name: idx_scope_policy_policy; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_scope_policy_policy ON public.scope_policy USING btree (policy_id);


--
-- Name: idx_update_time; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_update_time ON public.migration_model USING btree (update_time);


--
-- Name: idx_us_sess_id_on_cl_sess; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_us_sess_id_on_cl_sess ON public.offline_client_session USING btree (user_session_id);


--
-- Name: idx_usconsent_clscope; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_usconsent_clscope ON public.user_consent_client_scope USING btree (user_consent_id);


--
-- Name: idx_usconsent_scope_id; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_usconsent_scope_id ON public.user_consent_client_scope USING btree (scope_id);


--
-- Name: idx_user_attribute; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_user_attribute ON public.user_attribute USING btree (user_id);


--
-- Name: idx_user_attribute_name; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_user_attribute_name ON public.user_attribute USING btree (name, value);


--
-- Name: idx_user_consent; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_user_consent ON public.user_consent USING btree (user_id);


--
-- Name: idx_user_credential; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_user_credential ON public.credential USING btree (user_id);


--
-- Name: idx_user_email; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_user_email ON public.user_entity USING btree (email);


--
-- Name: idx_user_group_mapping; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_user_group_mapping ON public.user_group_membership USING btree (user_id);


--
-- Name: idx_user_reqactions; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_user_reqactions ON public.user_required_action USING btree (user_id);


--
-- Name: idx_user_role_mapping; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_user_role_mapping ON public.user_role_mapping USING btree (user_id);


--
-- Name: idx_user_service_account; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_user_service_account ON public.user_entity USING btree (realm_id, service_account_client_link);


--
-- Name: idx_usr_fed_map_fed_prv; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_usr_fed_map_fed_prv ON public.user_federation_mapper USING btree (federation_provider_id);


--
-- Name: idx_usr_fed_map_realm; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_usr_fed_map_realm ON public.user_federation_mapper USING btree (realm_id);


--
-- Name: idx_usr_fed_prv_realm; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_usr_fed_prv_realm ON public.user_federation_provider USING btree (realm_id);


--
-- Name: idx_web_orig_client; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX idx_web_orig_client ON public.web_origins USING btree (client_id);


--
-- Name: user_attr_long_values; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX user_attr_long_values ON public.user_attribute USING btree (long_value_hash, name);


--
-- Name: user_attr_long_values_lower_case; Type: INDEX; Schema: public; Owner: imobflow
--

CREATE INDEX user_attr_long_values_lower_case ON public.user_attribute USING btree (long_value_hash_lower_case, name);


--
-- Name: client_session_auth_status auth_status_constraint; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.client_session_auth_status
    ADD CONSTRAINT auth_status_constraint FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- Name: identity_provider fk2b4ebc52ae5c3b34; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.identity_provider
    ADD CONSTRAINT fk2b4ebc52ae5c3b34 FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: client_attributes fk3c47c64beacca966; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.client_attributes
    ADD CONSTRAINT fk3c47c64beacca966 FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: federated_identity fk404288b92ef007a6; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.federated_identity
    ADD CONSTRAINT fk404288b92ef007a6 FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: client_node_registrations fk4129723ba992f594; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.client_node_registrations
    ADD CONSTRAINT fk4129723ba992f594 FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: client_session_note fk5edfb00ff51c2736; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.client_session_note
    ADD CONSTRAINT fk5edfb00ff51c2736 FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- Name: user_session_note fk5edfb00ff51d3472; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.user_session_note
    ADD CONSTRAINT fk5edfb00ff51d3472 FOREIGN KEY (user_session) REFERENCES public.user_session(id);


--
-- Name: client_session_role fk_11b7sgqw18i532811v7o2dv76; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.client_session_role
    ADD CONSTRAINT fk_11b7sgqw18i532811v7o2dv76 FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- Name: redirect_uris fk_1burs8pb4ouj97h5wuppahv9f; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.redirect_uris
    ADD CONSTRAINT fk_1burs8pb4ouj97h5wuppahv9f FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: user_federation_provider fk_1fj32f6ptolw2qy60cd8n01e8; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.user_federation_provider
    ADD CONSTRAINT fk_1fj32f6ptolw2qy60cd8n01e8 FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: client_session_prot_mapper fk_33a8sgqw18i532811v7o2dk89; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.client_session_prot_mapper
    ADD CONSTRAINT fk_33a8sgqw18i532811v7o2dk89 FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- Name: realm_required_credential fk_5hg65lybevavkqfki3kponh9v; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.realm_required_credential
    ADD CONSTRAINT fk_5hg65lybevavkqfki3kponh9v FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: resource_attribute fk_5hrm2vlf9ql5fu022kqepovbr; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.resource_attribute
    ADD CONSTRAINT fk_5hrm2vlf9ql5fu022kqepovbr FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: user_attribute fk_5hrm2vlf9ql5fu043kqepovbr; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.user_attribute
    ADD CONSTRAINT fk_5hrm2vlf9ql5fu043kqepovbr FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: user_required_action fk_6qj3w1jw9cvafhe19bwsiuvmd; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.user_required_action
    ADD CONSTRAINT fk_6qj3w1jw9cvafhe19bwsiuvmd FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: keycloak_role fk_6vyqfe4cn4wlq8r6kt5vdsj5c; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.keycloak_role
    ADD CONSTRAINT fk_6vyqfe4cn4wlq8r6kt5vdsj5c FOREIGN KEY (realm) REFERENCES public.realm(id);


--
-- Name: realm_smtp_config fk_70ej8xdxgxd0b9hh6180irr0o; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.realm_smtp_config
    ADD CONSTRAINT fk_70ej8xdxgxd0b9hh6180irr0o FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_attribute fk_8shxd6l3e9atqukacxgpffptw; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.realm_attribute
    ADD CONSTRAINT fk_8shxd6l3e9atqukacxgpffptw FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: composite_role fk_a63wvekftu8jo1pnj81e7mce2; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.composite_role
    ADD CONSTRAINT fk_a63wvekftu8jo1pnj81e7mce2 FOREIGN KEY (composite) REFERENCES public.keycloak_role(id);


--
-- Name: authentication_execution fk_auth_exec_flow; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.authentication_execution
    ADD CONSTRAINT fk_auth_exec_flow FOREIGN KEY (flow_id) REFERENCES public.authentication_flow(id);


--
-- Name: authentication_execution fk_auth_exec_realm; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.authentication_execution
    ADD CONSTRAINT fk_auth_exec_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: authentication_flow fk_auth_flow_realm; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.authentication_flow
    ADD CONSTRAINT fk_auth_flow_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: authenticator_config fk_auth_realm; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.authenticator_config
    ADD CONSTRAINT fk_auth_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: client_session fk_b4ao2vcvat6ukau74wbwtfqo1; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.client_session
    ADD CONSTRAINT fk_b4ao2vcvat6ukau74wbwtfqo1 FOREIGN KEY (session_id) REFERENCES public.user_session(id);


--
-- Name: user_role_mapping fk_c4fqv34p1mbylloxang7b1q3l; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.user_role_mapping
    ADD CONSTRAINT fk_c4fqv34p1mbylloxang7b1q3l FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: client_scope_attributes fk_cl_scope_attr_scope; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.client_scope_attributes
    ADD CONSTRAINT fk_cl_scope_attr_scope FOREIGN KEY (scope_id) REFERENCES public.client_scope(id);


--
-- Name: client_scope_role_mapping fk_cl_scope_rm_scope; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.client_scope_role_mapping
    ADD CONSTRAINT fk_cl_scope_rm_scope FOREIGN KEY (scope_id) REFERENCES public.client_scope(id);


--
-- Name: client_user_session_note fk_cl_usr_ses_note; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.client_user_session_note
    ADD CONSTRAINT fk_cl_usr_ses_note FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- Name: protocol_mapper fk_cli_scope_mapper; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.protocol_mapper
    ADD CONSTRAINT fk_cli_scope_mapper FOREIGN KEY (client_scope_id) REFERENCES public.client_scope(id);


--
-- Name: client_initial_access fk_client_init_acc_realm; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.client_initial_access
    ADD CONSTRAINT fk_client_init_acc_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: component_config fk_component_config; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.component_config
    ADD CONSTRAINT fk_component_config FOREIGN KEY (component_id) REFERENCES public.component(id);


--
-- Name: component fk_component_realm; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.component
    ADD CONSTRAINT fk_component_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_default_groups fk_def_groups_realm; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.realm_default_groups
    ADD CONSTRAINT fk_def_groups_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: user_federation_mapper_config fk_fedmapper_cfg; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.user_federation_mapper_config
    ADD CONSTRAINT fk_fedmapper_cfg FOREIGN KEY (user_federation_mapper_id) REFERENCES public.user_federation_mapper(id);


--
-- Name: user_federation_mapper fk_fedmapperpm_fedprv; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.user_federation_mapper
    ADD CONSTRAINT fk_fedmapperpm_fedprv FOREIGN KEY (federation_provider_id) REFERENCES public.user_federation_provider(id);


--
-- Name: user_federation_mapper fk_fedmapperpm_realm; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.user_federation_mapper
    ADD CONSTRAINT fk_fedmapperpm_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: associated_policy fk_frsr5s213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.associated_policy
    ADD CONSTRAINT fk_frsr5s213xcx4wnkog82ssrfy FOREIGN KEY (associated_policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: scope_policy fk_frsrasp13xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.scope_policy
    ADD CONSTRAINT fk_frsrasp13xcx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: resource_server_perm_ticket fk_frsrho213xcx4wnkog82sspmt; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrho213xcx4wnkog82sspmt FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: resource_server_resource fk_frsrho213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.resource_server_resource
    ADD CONSTRAINT fk_frsrho213xcx4wnkog82ssrfy FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: resource_server_perm_ticket fk_frsrho213xcx4wnkog83sspmt; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrho213xcx4wnkog83sspmt FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: resource_server_perm_ticket fk_frsrho213xcx4wnkog84sspmt; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrho213xcx4wnkog84sspmt FOREIGN KEY (scope_id) REFERENCES public.resource_server_scope(id);


--
-- Name: associated_policy fk_frsrpas14xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.associated_policy
    ADD CONSTRAINT fk_frsrpas14xcx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: scope_policy fk_frsrpass3xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.scope_policy
    ADD CONSTRAINT fk_frsrpass3xcx4wnkog82ssrfy FOREIGN KEY (scope_id) REFERENCES public.resource_server_scope(id);


--
-- Name: resource_server_perm_ticket fk_frsrpo2128cx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrpo2128cx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: resource_server_policy fk_frsrpo213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.resource_server_policy
    ADD CONSTRAINT fk_frsrpo213xcx4wnkog82ssrfy FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: resource_scope fk_frsrpos13xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.resource_scope
    ADD CONSTRAINT fk_frsrpos13xcx4wnkog82ssrfy FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: resource_policy fk_frsrpos53xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.resource_policy
    ADD CONSTRAINT fk_frsrpos53xcx4wnkog82ssrfy FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: resource_policy fk_frsrpp213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.resource_policy
    ADD CONSTRAINT fk_frsrpp213xcx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: resource_scope fk_frsrps213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.resource_scope
    ADD CONSTRAINT fk_frsrps213xcx4wnkog82ssrfy FOREIGN KEY (scope_id) REFERENCES public.resource_server_scope(id);


--
-- Name: resource_server_scope fk_frsrso213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.resource_server_scope
    ADD CONSTRAINT fk_frsrso213xcx4wnkog82ssrfy FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: composite_role fk_gr7thllb9lu8q4vqa4524jjy8; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.composite_role
    ADD CONSTRAINT fk_gr7thllb9lu8q4vqa4524jjy8 FOREIGN KEY (child_role) REFERENCES public.keycloak_role(id);


--
-- Name: user_consent_client_scope fk_grntcsnt_clsc_usc; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.user_consent_client_scope
    ADD CONSTRAINT fk_grntcsnt_clsc_usc FOREIGN KEY (user_consent_id) REFERENCES public.user_consent(id);


--
-- Name: user_consent fk_grntcsnt_user; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT fk_grntcsnt_user FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: group_attribute fk_group_attribute_group; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.group_attribute
    ADD CONSTRAINT fk_group_attribute_group FOREIGN KEY (group_id) REFERENCES public.keycloak_group(id);


--
-- Name: group_role_mapping fk_group_role_group; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.group_role_mapping
    ADD CONSTRAINT fk_group_role_group FOREIGN KEY (group_id) REFERENCES public.keycloak_group(id);


--
-- Name: realm_enabled_event_types fk_h846o4h0w8epx5nwedrf5y69j; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.realm_enabled_event_types
    ADD CONSTRAINT fk_h846o4h0w8epx5nwedrf5y69j FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_events_listeners fk_h846o4h0w8epx5nxev9f5y69j; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.realm_events_listeners
    ADD CONSTRAINT fk_h846o4h0w8epx5nxev9f5y69j FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: identity_provider_mapper fk_idpm_realm; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.identity_provider_mapper
    ADD CONSTRAINT fk_idpm_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: idp_mapper_config fk_idpmconfig; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.idp_mapper_config
    ADD CONSTRAINT fk_idpmconfig FOREIGN KEY (idp_mapper_id) REFERENCES public.identity_provider_mapper(id);


--
-- Name: web_origins fk_lojpho213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.web_origins
    ADD CONSTRAINT fk_lojpho213xcx4wnkog82ssrfy FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: scope_mapping fk_ouse064plmlr732lxjcn1q5f1; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.scope_mapping
    ADD CONSTRAINT fk_ouse064plmlr732lxjcn1q5f1 FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: protocol_mapper fk_pcm_realm; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.protocol_mapper
    ADD CONSTRAINT fk_pcm_realm FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: credential fk_pfyr0glasqyl0dei3kl69r6v0; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.credential
    ADD CONSTRAINT fk_pfyr0glasqyl0dei3kl69r6v0 FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: protocol_mapper_config fk_pmconfig; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.protocol_mapper_config
    ADD CONSTRAINT fk_pmconfig FOREIGN KEY (protocol_mapper_id) REFERENCES public.protocol_mapper(id);


--
-- Name: default_client_scope fk_r_def_cli_scope_realm; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.default_client_scope
    ADD CONSTRAINT fk_r_def_cli_scope_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: required_action_provider fk_req_act_realm; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.required_action_provider
    ADD CONSTRAINT fk_req_act_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: resource_uris fk_resource_server_uris; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.resource_uris
    ADD CONSTRAINT fk_resource_server_uris FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: role_attribute fk_role_attribute_id; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.role_attribute
    ADD CONSTRAINT fk_role_attribute_id FOREIGN KEY (role_id) REFERENCES public.keycloak_role(id);


--
-- Name: realm_supported_locales fk_supported_locales_realm; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.realm_supported_locales
    ADD CONSTRAINT fk_supported_locales_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: user_federation_config fk_t13hpu1j94r2ebpekr39x5eu5; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.user_federation_config
    ADD CONSTRAINT fk_t13hpu1j94r2ebpekr39x5eu5 FOREIGN KEY (user_federation_provider_id) REFERENCES public.user_federation_provider(id);


--
-- Name: user_group_membership fk_user_group_user; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.user_group_membership
    ADD CONSTRAINT fk_user_group_user FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: policy_config fkdc34197cf864c4e43; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.policy_config
    ADD CONSTRAINT fkdc34197cf864c4e43 FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: identity_provider_config fkdc4897cf864c4e43; Type: FK CONSTRAINT; Schema: public; Owner: imobflow
--

ALTER TABLE ONLY public.identity_provider_config
    ADD CONSTRAINT fkdc4897cf864c4e43 FOREIGN KEY (identity_provider_id) REFERENCES public.identity_provider(internal_id);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: imobflow
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;


--
-- PostgreSQL database dump complete
--

\unrestrict VnufiKQbpBNyz7h66FIVhzIGW6DMbMa8d6aQuUBXO7pzLiBBRiRA93BwnD8jDh8

