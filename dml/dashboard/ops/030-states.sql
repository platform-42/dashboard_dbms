INSERT INTO ops.state
    (component_id, state, reported_at)
SELECT
    co.component_id,
    'UP',
    now()
FROM ops.component AS co
JOIN ops.customer AS cu
    ON cu.customer_id = co.customer_id
WHERE co.type = 'ORCHESTRATOR'
  AND cu.name IN ('Platform42', 'BlueFez')
  ;