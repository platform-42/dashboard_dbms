INSERT INTO ops.stats
    (component_id,
     total_events,
     total_errors,
     average_response_time_ms,
     reported_at)
SELECT
    c.component_id,
    v.total_events,
    ROUND(v.total_events * v.error_pct / 100.0)::BIGINT,
    v.average_response_time_ms,
    now()
FROM ops.component AS c

CROSS JOIN LATERAL (
    SELECT
        FLOOR(10000 + random() * 30001)::BIGINT AS total_events,
        3.0 + random() * 3.0 AS error_pct,
        ROUND((200 + random() * 250)::numeric, 3) AS average_response_time_ms,
) AS v

WHERE c.type = 'CHANNEL';