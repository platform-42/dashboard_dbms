DROP FUNCTION IF EXISTS ops.update_state(VARCHAR, VARCHAR, VARCHAR, BOOLEAN)
;

CREATE FUNCTION ops.update_state(
    p_customer_name       VARCHAR,
    p_component_type      VARCHAR,
    p_component_name      VARCHAR,
    p_available           BOOLEAN,
    p_planned_shutdown    BOOLEAN DEFAULT FALSE
)
RETURNS VOID
LANGUAGE plpgsql
AS $$
BEGIN

    IF p_available AND p_planned_shutdown THEN
        RAISE EXCEPTION
            'planned_shutdown = true requires available = false (customer=%, type=%, name=%)',
            p_customer_name, p_component_type, p_component_name;
    END IF;

    INSERT INTO ops.state (
        component_id,
        state,
        reported_at
    )
    SELECT
        c.component_id,
        CASE
            WHEN p_available        THEN 'UP'
            WHEN p_planned_shutdown THEN 'MAINTENANCE'
            ELSE                         'DOWN'
        END,
        now()
    FROM ops.component AS c
    JOIN ops.customer AS cu
        ON cu.customer_id = c.customer_id
    WHERE cu.name = p_customer_name
      AND c.type  = p_component_type
      AND c.name  = p_component_name

    ON CONFLICT (component_id)
    DO UPDATE SET
        state       = EXCLUDED.state,
        reported_at = EXCLUDED.reported_at;

END;
$$;