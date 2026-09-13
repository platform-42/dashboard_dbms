CREATE OR REPLACE FUNCTION ops.update_stats(
    p_component_id BIGINT,
    p_events       BIGINT,
    p_errors       BIGINT,
    p_response_ms  NUMERIC,
    p_interval     INTERVAL DEFAULT INTERVAL '5 minutes'
) RETURNS VOID AS $$
DECLARE
    v_window_start TIMESTAMPTZ;
BEGIN
    v_window_start := to_timestamp(
        floor(extract(epoch FROM now()) / extract(epoch FROM p_interval))
        * extract(epoch FROM p_interval)
    );

    INSERT INTO ops.stats (
        component_id, window_start, sample_count,
        total_events, total_errors, total_response_time_ms, reported_at
    )
    VALUES (
        p_component_id, v_window_start, 1,
        p_events, p_errors, p_response_ms, now()
    )
    ON CONFLICT (component_id, window_start) DO UPDATE
    SET sample_count           = ops.stats.sample_count + 1,
        total_events           = ops.stats.total_events + EXCLUDED.total_events,
        total_errors           = ops.stats.total_errors + EXCLUDED.total_errors,
        total_response_time_ms = ops.stats.total_response_time_ms + EXCLUDED.total_response_time_ms,
        reported_at            = now();
END;
$$ LANGUAGE plpgsql;