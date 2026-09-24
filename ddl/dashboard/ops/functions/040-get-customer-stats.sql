-- Returns the most recent stats window, but ONLY for components that
-- actually have at least one stats row (INNER LATERAL join -- a
-- component with no stats row ever simply doesn't participate in
-- stats; see ops.get_customer_state for the same rule on the state
-- side).
--
-- avg_response_time_ms and success_rate remain plain arithmetic
-- derivations of stored raw totals -- not judgements.
--
-- success_rate_rag and response_time_rag ARE the judgement, and it now
-- lives here rather than in the dashboard's template: each is
-- computed by looking up the effective objective for that metric
-- (component-specific override, else the global default, else no
-- objective at all) and evaluating it with ops.evaluate_rag(). If no
-- objective exists for a metric, the *_rag column is NULL --
-- deliberately neutral, not a guess.

DROP FUNCTION IF EXISTS ops.get_customer_stats(BIGINT);

CREATE FUNCTION ops.get_customer_stats(p_customer_id BIGINT)
RETURNS TABLE (
    component_id            BIGINT,
    component_name          TEXT,
    component_type          TEXT,
    window_start            TIMESTAMPTZ,
    sample_count            BIGINT,
    total_events            BIGINT,
    total_errors            BIGINT,
    total_response_time_ms  NUMERIC,
    avg_response_time_ms    NUMERIC,
    response_time_rag       TEXT,
    success_rate            NUMERIC,
    success_rate_rag        TEXT,
    reported_at             TIMESTAMPTZ
) AS $$
    SELECT
        c.component_id,
        c.name AS component_name,
        c.type AS component_type,
        st.window_start,
        st.sample_count,
        st.total_events,
        st.total_errors,
        st.total_response_time_ms,
        rt.value AS avg_response_time_ms,
        ops.evaluate_rag(rt.value, rt_obj.operator, rt_obj.green_threshold, rt_obj.amber_threshold) AS response_time_rag,
        sr.value AS success_rate,
        ops.evaluate_rag(sr.value, sr_obj.operator, sr_obj.green_threshold, sr_obj.amber_threshold) AS success_rate_rag,
        st.reported_at
    FROM ops.component c

    JOIN LATERAL (
        SELECT s.*
        FROM ops.stats s
        WHERE s.component_id = c.component_id
        ORDER BY s.window_start DESC
        LIMIT 1
    ) st ON true

    CROSS JOIN LATERAL (
        SELECT CASE WHEN st.total_events > 0
                    THEN round(st.total_response_time_ms / st.total_events, 3)
                    ELSE NULL END AS value
    ) rt

    CROSS JOIN LATERAL (
        SELECT CASE WHEN st.total_events > 0
                    THEN round(100 - (st.total_errors::numeric / st.total_events) * 100, 2)
                    ELSE NULL END AS value
    ) sr

    -- Effective objective for avg_response_time_ms: component-specific
    -- row wins (component_id NOT NULL sorts first), else the global
    -- default (component_id IS NULL), else no row at all.
    LEFT JOIN LATERAL (
        SELECT o.operator, o.green_threshold, o.amber_threshold
        FROM ops.objective o
        WHERE o.metric_name = 'avg_response_time_ms'
          AND (o.component_id = c.component_id OR o.component_id IS NULL)
        ORDER BY o.component_id NULLS LAST
        LIMIT 1
    ) rt_obj ON true

    -- Same cascading lookup for success_rate.
    LEFT JOIN LATERAL (
        SELECT o.operator, o.green_threshold, o.amber_threshold
        FROM ops.objective o
        WHERE o.metric_name = 'success_rate'
          AND (o.component_id = c.component_id OR o.component_id IS NULL)
        ORDER BY o.component_id NULLS LAST
        LIMIT 1
    ) sr_obj ON true

    WHERE c.customer_id = p_customer_id
    ORDER BY c.name;
$$ LANGUAGE sql STABLE;
