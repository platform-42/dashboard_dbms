CREATE OR REPLACE FUNCTION ops.update_stats(
    p_customer_name          TEXT,
    p_component_type         TEXT,
    p_component_name         TEXT,
    p_total_events           INTEGER,
    p_total_errors           INTEGER,
    p_total_response_time_ms NUMERIC,
    p_interval               INTERVAL DEFAULT INTERVAL '5 minutes'
) RETURNS VOID AS $$
DECLARE
    v_component_id BIGINT;
    v_window_start TIMESTAMPTZ;
BEGIN
    SELECT c.component_id INTO v_component_id
    FROM ops.component c
    JOIN ops.customer cu ON cu.customer_id = c.customer_id
    WHERE cu.name  = p_customer_name
      AND c.type  = p_component_type
      AND c.name  = p_component_name;

    IF v_component_id IS NULL THEN
        RAISE EXCEPTION 'Unknown component: customer=%, type=%, name=%',
            p_customer_name, p_component_type, p_component_name;
    END IF;

    v_window_start := to_timestamp(
        floor(extract(epoch FROM now()) / extract(epoch FROM p_interval))
        * extract(epoch FROM p_interval)
    );

    INSERT INTO ops.stats (
        component_id, window_start, sample_count,
        total_events, total_errors, total_response_time_ms, reported_at
    )
    VALUES (
        v_component_id, v_window_start, 1,
        p_total_events, p_total_errors, p_total_response_time_ms,
        now()
    )
    ON CONFLICT (component_id, window_start) DO UPDATE
    SET sample_count           = ops.stats.sample_count + 1,
        total_events           = ops.stats.total_events + EXCLUDED.total_events,
        total_errors           = ops.stats.total_errors + EXCLUDED.total_errors,
        total_response_time_ms = ops.stats.total_response_time_ms + EXCLUDED.total_response_time_ms,
        reported_at            = now();
END;
$$ LANGUAGE plpgsql;