-- ============================================================
-- Operational Monitoring Database
-- Database: dashboard
-- Schema:   ops
-- ============================================================


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
