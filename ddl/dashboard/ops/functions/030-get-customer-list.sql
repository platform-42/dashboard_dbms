-- Returns every customer, for the dashboard's customer-selection dropdown.
-- No filtering/logic here on purpose: the picker shows everything, the
-- operator decides which one to look at.

DROP FUNCTION IF EXISTS ops.get_customer_list();

CREATE FUNCTION ops.get_customer_list()
RETURNS TABLE (
    customer_id   BIGINT,
    customer_name TEXT
) AS $$
    SELECT
        cu.customer_id,
        cu.name AS customer_name
    FROM ops.customer cu
    ORDER BY cu.name;
$$ LANGUAGE sql STABLE;
