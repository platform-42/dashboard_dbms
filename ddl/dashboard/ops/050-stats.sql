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

    window_start             TIMESTAMPTZ NOT NULL,   -- floor(reported time, interval) — this IS the reset unit
    sample_count             BIGINT NOT NULL DEFAULT 0,

    total_events             BIGINT NOT NULL DEFAULT 0,
    total_errors             BIGINT NOT NULL DEFAULT 0,

    total_response_time_ms   NUMERIC(18,3) NOT NULL DEFAULT 0,  -- sum, not average — see note below

    reported_at              TIMESTAMPTZ NOT NULL,   -- last update timestamp within this window

CONSTRAINT pk_stats
PRIMARY KEY (component_id, window_start),

CONSTRAINT fk_stats_component
FOREIGN KEY (component_id)
REFERENCES ops.component (component_id)
ON DELETE CASCADE,

CONSTRAINT ck_stats_events
CHECK (total_events >= 0),

CONSTRAINT ck_stats_errors
CHECK (total_errors >= 0),

CONSTRAINT ck_stats_sample_count
CHECK (sample_count >= 0),

CONSTRAINT ck_stats_total_response
CHECK (total_response_time_ms >= 0)
);

-- last-completed-window lookups will be frequent from the dashboard function
CREATE INDEX ix_stats_component_window
ON ops.stats (component_id, window_start DESC);