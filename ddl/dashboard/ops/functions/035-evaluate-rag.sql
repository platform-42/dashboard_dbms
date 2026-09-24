-- Pure function: given a metric's value and its objective (operator +
-- thresholds), returns 'GREEN' / 'AMBER' / 'RED', or NULL if there's
-- nothing to judge (no value, or no objective defined -- neutral, not
-- a guess).
--
-- One function serves every metric regardless of direction: GT/GTE
-- treats a HIGHER value as better (e.g. success_rate); LT/LTE treats
-- a LOWER value as better (e.g. avg_response_time_ms). The caller
-- doesn't special-case metrics -- the direction lives entirely in the
-- objective's operator.
--
-- amber_threshold is optional: if NULL, the metric is binary
-- (GREEN/RED only, no amber tier).

DROP FUNCTION IF EXISTS ops.evaluate_rag(NUMERIC, VARCHAR, NUMERIC, NUMERIC);

CREATE FUNCTION ops.evaluate_rag(
    p_value           NUMERIC,
    p_operator        VARCHAR(3),
    p_green_threshold NUMERIC,
    p_amber_threshold NUMERIC
) RETURNS TEXT AS $$
    SELECT CASE
        WHEN p_value IS NULL OR p_operator IS NULL OR p_green_threshold IS NULL
            THEN NULL  -- no value, or no objective defined -> neutral

        WHEN p_operator IN ('GT', 'GTE') THEN  -- higher is better
            CASE
                WHEN (p_operator = 'GT'  AND p_value > p_green_threshold)
                  OR (p_operator = 'GTE' AND p_value >= p_green_threshold)
                    THEN 'GREEN'
                WHEN p_amber_threshold IS NOT NULL AND (
                        (p_operator = 'GT'  AND p_value > p_amber_threshold)
                     OR (p_operator = 'GTE' AND p_value >= p_amber_threshold)
                     )
                    THEN 'AMBER'
                ELSE 'RED'
            END

        WHEN p_operator IN ('LT', 'LTE') THEN  -- lower is better
            CASE
                WHEN (p_operator = 'LT'  AND p_value < p_green_threshold)
                  OR (p_operator = 'LTE' AND p_value <= p_green_threshold)
                    THEN 'GREEN'
                WHEN p_amber_threshold IS NOT NULL AND (
                        (p_operator = 'LT'  AND p_value < p_amber_threshold)
                     OR (p_operator = 'LTE' AND p_value <= p_amber_threshold)
                     )
                    THEN 'AMBER'
                ELSE 'RED'
            END

        ELSE NULL
    END;
$$ LANGUAGE sql IMMUTABLE;
