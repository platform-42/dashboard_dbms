-- ============================================================
-- Operational Monitoring Database
-- Database: dashboard
-- Schema:   ops
-- ============================================================


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