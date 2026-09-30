import sys
import time
import random

from ops_stats import (
    update_stats,
    update_state
)

#
#   catch all exceptions before exit - mark object as down in the dashboard
#
def handle_uncaught_exception(exc_type, exc_value, exc_traceback):
    if issubclass(exc_type, KeyboardInterrupt):
        sys.__excepthook__(exc_type, exc_value, exc_traceback)
        return
    update_state("Platform42", "ORCHESTRATOR", "Platform42", False)

sys.excepthook = handle_uncaught_exception

if __name__ == "__main__":
    # update states
    update_state("Platform42", "ORCHESTRATOR", "Platform42", True)
    update_state("Platform42", "CHANNEL", "WhatsApp", True)
    update_state("Platform42", "CHANNEL", "Instagram", True)
    # bump first round of stats
    update_stats("Platform42", "CHANNEL", "WhatsApp", random.randint(10, 20), 0, 180.0)
    update_stats("Platform42", "CHANNEL", "Instagram", random.randint(20, 40), 0, 55.0)
    time.sleep(20)
    # bump second round of stats
    update_stats("Platform42", "CHANNEL", "Instagram", random.randint(3, 9), 2, 55.0)
    update_stats("Platform42", "CHANNEL", "WhatsApp", random.randint(11, 20), 3, 180.0)
    time.sleep(20)
    # bump second round of stats
    update_stats("Platform42", "CHANNEL", "Instagram", random.randint(21, 41), 6, 55.0)
    update_stats("Platform42", "CHANNEL", "WhatsApp", random.randint(100, 200), 3, 180.0)
    time.sleep(20)
    # force an exception to test the uncaught exception handler
    # a = 10/0
    update_state("Platform42", "ORCHESTRATOR", "Platform42", False, planned_shutdown=True)
    update_state("BlueFez", "ORCHESTRATOR", "BlueFez", False) #testing unplanned shutdown for BlueFez orchestrator
