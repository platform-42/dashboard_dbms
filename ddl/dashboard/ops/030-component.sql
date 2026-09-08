-- ============================================================
-- Operational Monitoring Database
-- Database: dashboard
-- Schema:   ops
-- ============================================================

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
