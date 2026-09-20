-- Returns the most recent stats window, but ONLY for components that
-- actually have at least one stats row. Components that never report
-- stats (e.g. state-only orchestrators) are structurally absent here --
-- this is an INNER (non-LEFT) LATERAL join on purpose: "no stats row
-- ever" means "this component doesn't participate in stats," not
-- "zero activity."
--
-- avg_response_time_ms and success_rate are plain arithmetic
-- derivations of stored raw totals (sum / count) -- not thresholds or
-- "good/bad" judgements -- so computing them here keeps the
-- visualization layer free of that interpretation, per the "zero
-- logic in the presentation layer" rule. Colour-coding success_rate
-- against thresholds (95% / 75%) is a separate, explicitly hardcoded
-- decision made in the template for this POC -- see dashboard.html.

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
    success_rate            NUMERIC,
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
        CASE
            WHEN st.total_events > 0
            THEN round(st.total_response_time_ms / st.total_events, 3)
            ELSE NULL
        END AS avg_response_time_ms,
        CASE
            WHEN st.total_events > 0
            THEN round(100 - (st.total_errors::numeric / st.total_events) * 100, 2)
            ELSE NULL
        END AS success_rate,
        st.reported_at
    FROM ops.component c
    JOIN LATERAL (
        SELECT s.*
        FROM ops.stats s
        WHERE s.component_id = c.component_id
        ORDER BY s.window_start DESC
        LIMIT 1
    ) st ON true
    WHERE c.customer_id = p_customer_id
    ORDER BY c.name;
$$ LANGUAGE sql STABLE;
