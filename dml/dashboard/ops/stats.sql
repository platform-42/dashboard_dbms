INSERT INTO ops.channel_statistics
    (component_id,
     total_events,
     total_errors,
     average_response_time_ms,
     p95_response_time_ms,
     reported_at)
VALUES
    (2, 48300, 734, 342.000, 610.000, now()),
    (4, 21200, 310, 280.000, 490.000, now());