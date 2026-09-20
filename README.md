# DASHBOARD

## Installation

1. setup DDL operations (database structure)
2. register Stored Functions (database primitives)
3. setup DML operations (populate database with customers, orchestrator and channels)

### DDL operations - database
0. create .pgpass file in ~/
1. create database called dashboard
2. create schema -> ddl/dashboard/ops/010-schema.sql
3. create customer table -> ddl/dashboard/ops/020-customer.sql
4. create component table -> ddl/dashboard/ops/030-component.sql
5. create state table -> ddl/dashboard/ops/040-state.sql
6. create stats table -> ddl/dashboard/ops/050-stats.sql

### DDL operations - functions
1. register function for update_state -> ddl/dashboard/ops/functions/010-update-state.sql
2. register function for update_stats -> ddl/dashboard/ops/functions/020-update-stats.sql
3. register function for listing customers -> ddl/dashboard/ops/functions/030-get-customer-list.sql
4. register function for retrieving stats objects for customer -> ddl/dashboard/ops/functions/040-get-customer-stats.sql
5. register function for retrieving state objects for customer -> ddl/dashboard/ops/functions/050-get-customer-state.sql

### DML operations - customize yourself
1. populate customers table -> dml/dashboard/ops/010-customers.sql
2. populate components table -> dml/dashboard/ops/020-components.sql

## Usage in Application
Stats update: 

    update_stats( 
        customer_name="BlueFez", 
        component_type="CHANNEL", 
        component_name="WhatsApp", 
        total_events=1, 
        total_errors=1, 
        total_response_time_ms=100.0
        )

State update: 

    update_state(
        customer_name="BlueFez", 
        component_type="ORCHESTRATOR", 
        component_name="Orchestrator", 
        available=False
        )

Where:
    customer_name -> "BlueFez" (pre-defined in customer-table)
    component_type -> "ORCHESTRATOR" (pre-defined in component-table)
    component_name -> "Orchestrator" (pre-defined in component-table)
