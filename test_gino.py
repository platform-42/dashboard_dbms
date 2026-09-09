from ops_stats import (
    update_stats,
    update_state
)
update_stats("Platform42", "CHANNEL", "WhatsApp", 1000, 25, 312.450)
update_stats("Platform42", "CHANNEL", "Instagram", 4, 1, 12.450)
update_state("Platform42", "ORCHESTRATOR", "orchestrator", True)