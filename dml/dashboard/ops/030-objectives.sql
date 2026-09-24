DELETE FROM ops.objective
    ;
INSERT INTO ops.objective (
    component_id, 
    metric_name, 
    operator, 
    green_threshold, 
    amber_threshold
    )
VALUES (
    NULL, 
    'success_rate', 
    'GTE', 
    82, 
    70
    );

INSERT INTO ops.objective (
    component_id, 
    metric_name, 
    operator, 
    green_threshold, 
    amber_threshold
    )
VALUES (
    NULL, 
    'avg_response_time_ms', 
    'LTE', 
    50, 
    100
    );