INSERT INTO ops.orchestrator_state
    (component_id, state, reported_at)
SELECT
    c.component_id,
    'UP',
    now()
FROM ops.component AS c
JOIN ops.customer AS cu
    ON cu.customer_id = c.customer_id
WHERE c.type = 'ORCHESTRATOR'
  AND cu.name IN ('Platform42', 'BlueFez')
  ;