CREATE OR REPLACE FUNCTION ops.update_state(
    p_customer_name       VARCHAR,
    p_component_type      VARCHAR,
    p_component_name      VARCHAR,
    p_available           BOOLEAN
)
RETURNS VOID
LANGUAGE plpgsql
AS $$
BEGIN

    INSERT INTO ops.state (
        component_id,
        state,
        reported_at
    )
    SELECT
        c.component_id,
        CASE WHEN p_available THEN 'UP' ELSE 'DOWN' END,
        now()
    FROM ops.component AS c
    JOIN ops.customer AS cu
    ON cu.customer_id = c.customer_id
    WHERE cu.name = p_customer_name
    AND c.type = p_component_type
    AND c.name = p_component_name

    ON CONFLICT (component_id)
        DO UPDATE SET
            state = EXCLUDED.state,
            reported_at = EXCLUDED.reported_at;

END;
$$;