# DASHBOARD

## Installation

1. setup DDL operations (database structure)
2. register Stored Functions (database primitives)
3. setup DML operations (populate database with customers, orchestrator and channels)

### DDL operations - database
1. create database
2. create schema -> ddl/dashboard/ops/010-schema.sql
3. create customer table -> ddl/dashboard/ops/020-customer.sql
4. create component table -> ddl/dashboard/ops/030-component.sql
5. create state table -> ddl/dashboard/ops/040-state.sql
6. create stats table -> ddl/dashboard/ops/050-stats.sql

### DDL operations - functions
7. register functions for update_state -> ddl/dashboard/ops/functions/010-update-state.sql
8. register functions for update_stats -> ddl/dashboard/ops/functions/020-update-stats.sql

### DML operations
1. load customers -> dml/dashboard/ops/010-customers.sql
2. load components -> dml/dashboard/ops/020-components.sql

## Usage
Stats update: update_stats("BlueFez", "CHANNEL", "WhatsApp", 1, 1, 100.0)

    customer_name = "BlueFez" (pre-defined in customer-table)
    component_type = "CHANNEL" (pre-defined in component-table)
    component_name = "WhatsApp" (pre-defined in component-table)
    total_events = 1
    error_events = 1
    response_time = 100.0 msec

State update: update_state("BlueFez", "ORCHESTRATOR", "Orchestrator", False)

    customer_name = "BlueFez" (pre-defined in customer-table)
    component_type = "ORCHESTRATOR" (pre-defined in component-table)
    component_name = "Orchestrator" (pre-defined in component-table)
    available = False -> DOWN