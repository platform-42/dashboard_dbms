-- Components
DELETE FROM ops.component
;

INSERT INTO ops.component AS co
    (customer_id, type, name)
SELECT 
    cu.customer_id,
    v.type,
    v.component_name
FROM ops.customer AS cu
JOIN (
    VALUES
        ('Platform42',                  'CHANNEL',      'StockAlert'),
        ('InnovativeAISolutions',       'ORCHESTRATOR', 'BlueFez'),
        ('InnovativeAISolutions',       'CHANNEL',      'WhatsApp'),
        ('InnovativeAISolutions',       'CHANNEL',      'Instagram'),
        ('InnovativeAISolutions',       'CHANNEL',      'Email')

) AS v(customer_name, type, component_name)
    ON cu.name = v.customer_name
;