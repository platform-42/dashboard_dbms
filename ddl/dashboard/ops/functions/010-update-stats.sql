CREATE OR REPLACE FUNCTION ops.update_stats(
    p_customer_name       VARCHAR,
    p_component_type      VARCHAR,
    p_component_name      VARCHAR,
    p_total_events        BIGINT,
    p_total_errors        BIGINT,
    p_average_response_ms NUMERIC(12,3)
)
RETURNS VOID
LANGUAGE plpgsql
AS $$
BEGIN

    INSERT INTO ops.stats (
        component_id,
        total_events,
        total_errors,
        average_response_time_ms,
        reported_at
    )
    SELECT
        c.component_id,
        p_total_events,
        p_total_errors,
        p_average_response_ms,
        now()
    FROM ops.component AS c
    JOIN ops.customer AS cu
        ON cu.customer_id = c.customer_id
    WHERE cu.name = p_customer_name
      AND c.type = p_component_type
      AND c.name = p_component_name

    ON CONFLICT (component_id)
    DO UPDATE SET
        total_events =
            ops.stats.total_events + EXCLUDED.total_events,

        total_errors =
            ops.stats.total_errors + EXCLUDED.total_errors,

        average_response_time_ms =
            CASE
                WHEN ops.stats.total_events + EXCLUDED.total_events = 0
                THEN 0
                ELSE
                    (
                        ops.stats.average_response_time_ms
                        * ops.stats.total_events
                        +
                        EXCLUDED.average_response_time_ms
                        * EXCLUDED.total_events
                    )
                    /
                    (
                        ops.stats.total_events
                        + EXCLUDED.total_events
                    )
            END,

        reported_at = EXCLUDED.reported_at;

END;
$$;