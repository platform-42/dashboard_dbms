-- ============================================================
-- Operational Monitoring Database
-- Database: dashboard
-- Schema:   ops
-- ============================================================

-- ============================================================
-- CUSTOMER
-- ============================================================

CREATE TABLE ops.customer (
    customer_id BIGINT GENERATED ALWAYS AS IDENTITY,
    name        VARCHAR(100) NOT NULL,
    created_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_customer
        PRIMARY KEY (customer_id),

    CONSTRAINT uq_customer_name
        UNIQUE (name)
);


