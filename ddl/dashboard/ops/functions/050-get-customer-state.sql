-- Returns the current up/down state, but ONLY for components that
-- actually have a state row. Components that never report state (e.g.
-- stats-only channels) are structurally absent here -- this is an
-- INNER join on purpose: "no state row" means "this component doesn't
-- participate in state tracking," not "unknown/down." A component that
-- IS expected to report state but simply hasn't yet will also be
-- absent until its first report -- see the note in the dashboard app
-- about that trade-off.

DROP FUNCTION IF EXISTS ops.get_customer_state(BIGINT);

CREATE FUNCTION ops.get_customer_state(p_customer_id BIGINT)
RETURNS TABLE (
    component_id   BIGINT,
    component_name TEXT,
    component_type TEXT,
    state          VARCHAR(20),
    reported_at    TIMESTAMPTZ
) AS $$
    SELECT
        c.component_id,
        c.name AS component_name,
        c.type AS component_type,
        s.state,
        s.reported_at
    FROM ops.component c
    JOIN ops.state s ON s.component_id = c.component_id
    WHERE c.customer_id = p_customer_id
    ORDER BY c.name;
$$ LANGUAGE sql STABLE;
