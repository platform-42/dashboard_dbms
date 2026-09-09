-- ============================================================
-- Operational Monitoring Database
-- Database: dashboard
-- Schema:   ops
-- ============================================================

-- ============================================================
-- STATS
--
-- One current operational snapshot per component.
-- Updated by the application when the reporting threshold
-- is reached.
-- ============================================================

CREATE TABLE ops.stats (
    component_id             BIGINT NOT NULL,

    total_events             BIGINT NOT NULL DEFAULT 0,
    total_errors             BIGINT NOT NULL DEFAULT 0,

    average_response_time_ms NUMERIC(12,3) NOT NULL DEFAULT 0,

    reported_at              TIMESTAMPTZ NOT NULL,

    CONSTRAINT pk_stats
        PRIMARY KEY (component_id),

    CONSTRAINT fk_stats_component
        FOREIGN KEY (component_id)
        REFERENCES ops.component (component_id)
        ON DELETE CASCADE,

    CONSTRAINT ck_stats_events
        CHECK (total_events >= 0),

    CONSTRAINT ck_stats_errors
        CHECK (total_errors >= 0),

    CONSTRAINT ck_stats_avg_response
        CHECK (average_response_time_ms >= 0),
);