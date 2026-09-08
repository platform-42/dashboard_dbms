-- ============================================================
-- Operational Monitoring Database
-- Database: dashboard
-- Schema:   ops
-- ============================================================

CREATE SCHEMA IF NOT EXISTS ops;


-- ============================================================
-- CUSTOMER
-- ============================================================

CREATE TABLE ops.customer (
    customer_id BIGINT GENERATED ALWAYS AS IDENTITY,
    name        VARCHAR(100) NOT NULL,

    CONSTRAINT pk_customer
        PRIMARY KEY (customer_id),

    CONSTRAINT uq_customer_name
        UNIQUE (name)
);


-- ============================================================
-- COMPONENT
-- ============================================================

CREATE TABLE ops.component (
    component_id BIGINT GENERATED ALWAYS AS IDENTITY,
    customer_id  BIGINT NOT NULL,

    type         VARCHAR(20) NOT NULL,
    name         VARCHAR(100) NOT NULL,
    status       VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',

    CONSTRAINT pk_component
        PRIMARY KEY (component_id),

    CONSTRAINT fk_component_customer
        FOREIGN KEY (customer_id)
        REFERENCES ops.customer (customer_id)
        ON DELETE CASCADE,

    CONSTRAINT ck_component_type
        CHECK (type IN ('ORCHESTRATOR', 'CHANNEL')),

    CONSTRAINT ck_component_status
        CHECK (status IN ('ACTIVE', 'INACTIVE')),

    CONSTRAINT uq_component_customer_name
        UNIQUE (customer_id, name)
);


-- ============================================================
-- ORCHESTRATOR STATE
--
-- One current state per orchestrator.
-- The row is updated when the state changes.
-- ============================================================

CREATE TABLE ops.orchestrator_state (
    component_id BIGINT NOT NULL,

    state        VARCHAR(20) NOT NULL,
    reported_at  TIMESTAMPTZ NOT NULL,

    CONSTRAINT pk_orchestrator_state
        PRIMARY KEY (component_id),

    CONSTRAINT fk_orchestrator_state_component
        FOREIGN KEY (component_id)
        REFERENCES ops.component (component_id)
        ON DELETE CASCADE,

    CONSTRAINT ck_orchestrator_state
        CHECK (state IN ('UP', 'DOWN'))
);


-- ============================================================
-- CHANNEL STATISTICS
--
-- One current operational snapshot per channel.
-- Updated by the application when the reporting threshold
-- is reached.
-- ============================================================

CREATE TABLE ops.channel_statistics (
    component_id             BIGINT NOT NULL,

    total_events             BIGINT NOT NULL DEFAULT 0,
    total_errors             BIGINT NOT NULL DEFAULT 0,

    average_response_time_ms NUMERIC(12,3) NOT NULL DEFAULT 0,
    p95_response_time_ms     NUMERIC(12,3) NOT NULL DEFAULT 0,

    reported_at              TIMESTAMPTZ NOT NULL,

    CONSTRAINT pk_channel_statistics
        PRIMARY KEY (component_id),

    CONSTRAINT fk_channel_statistics_component
        FOREIGN KEY (component_id)
        REFERENCES ops.component (component_id)
        ON DELETE CASCADE,

    CONSTRAINT ck_channel_statistics_events
        CHECK (total_events >= 0),

    CONSTRAINT ck_channel_statistics_errors
        CHECK (total_errors >= 0),

    CONSTRAINT ck_channel_statistics_avg_response
        CHECK (average_response_time_ms >= 0),

    CONSTRAINT ck_channel_statistics_p95_response
        CHECK (p95_response_time_ms >= 0)
);