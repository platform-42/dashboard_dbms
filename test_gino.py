from ops_stats import (
    update_stats,
    update_state
)

#
# prerequisite: 
#   make sure the ops_stats extension is installed in your database
#   make sure that ops.customers is populated (e.g. BlueFez, Platform42, etc.) 
#   make sure that osps.components is populated (e.g. WhatsApp, Orchestrator, etc.)
#

# report that 1 item was processed for BlueFez, with 1 error and an average response time of 100ms
update_stats("BlueFez", "CHANNEL", "WhatsApp", 1, 1, 100.0)

# report that orchestrator is down for BlueFez
update_state("BlueFez", "ORCHESTRATOR", "Orchestrator", False)

update_state("Platform42", "ORCHESTRATOR", "Orchestrator", True)
