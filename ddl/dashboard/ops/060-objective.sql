-- Defines coloring objectives (targets) per metric, optionally scoped
-- to a specific component. A row with component_id = NULL is the
-- GLOBAL DEFAULT for that metric; a row with a component_id set
-- OVERRIDES the global default for that one component.
--
-- Lookup rule (see ops.get_customer_stats): prefer the component-
-- specific row; fall back to the global row; if neither exists, the
-- metric is NEUTRAL (no color judgement is made) -- absence of an
-- objective is not the same as "good."
--
-- Operators are directional on purpose:
--   GT / GTE -> higher is better  (e.g. success_rate)
--   LT / LTE -> lower is better   (e.g. avg_response_time_ms)
-- EQ is deliberately not supported here -- equality-based alerting
-- (e.g. "fraudulent orders must equal 0") is a different shape of
-- rule (binary pass/fail, no amber tier) and isn't needed by this
-- dashboard yet.

CREATE TABLE ops.objective (
    objective_id     BIGSERIAL NOT NULL,
    component_id     BIGINT NULL,
    metric_name      VARCHAR(50) NOT NULL,
    operator         VARCHAR(3)  NOT NULL,
    green_threshold  NUMERIC(12,3) NOT NULL,
    amber_threshold  NUMERIC(12,3) NULL,

    CONSTRAINT pk_objective
        PRIMARY KEY (objective_id),

    CONSTRAINT fk_objective_component
        FOREIGN KEY (component_id)
        REFERENCES ops.component (component_id)
        ON DELETE CASCADE,

    CONSTRAINT ck_objective_operator
        CHECK (operator IN ('LT', 'LTE', 'GT', 'GTE'))
);

-- Exactly one global default per metric (component_id IS NULL).
-- Plain UNIQUE(component_id, metric_name) would NOT enforce this,
-- since Postgres treats NULL <> NULL -- hence the partial index.
CREATE UNIQUE INDEX uq_objective_global
    ON ops.objective (metric_name)
    WHERE component_id IS NULL;

-- At most one override per component per metric.
CREATE UNIQUE INDEX uq_objective_component
    ON ops.objective (component_id, metric_name)
    WHERE component_id IS NOT NULL;
