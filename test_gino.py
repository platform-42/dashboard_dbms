import sys
import time
import random

from ops_stats import (
    update_stats,
    update_state
)

#
#   catch all exceptions before exit
#
def handle_uncaught_exception(exc_type, exc_value, exc_traceback):
    if issubclass(exc_type, KeyboardInterrupt):
        sys.__excepthook__(exc_type, exc_value, exc_traceback)
        return
    update_state("Platform42", "ORCHESTRATOR", "Orchestrator", False)

sys.excepthook = handle_uncaught_exception

if __name__ == "__main__":
    # update states
    update_state("Platform42", "ORCHESTRATOR", "Orchestrator", True)
    update_state("Platform42", "CHANNEL", "WhatsApp", True)
    update_state("Platform42", "CHANNEL", "Instagram", True)
    # bump first round of stats
    update_stats("Platform42", "CHANNEL", "WhatsApp", 3, 1, 180.0)
    update_stats("Platform42", "CHANNEL", "Instagram", 4, 0, 55.0)
    time.sleep(20)
    # bump second round of stats
    update_stats("Platform42", "CHANNEL", "Instagram", random.randint(3, 9), 2, 55.0)
    update_stats("Platform42", "CHANNEL", "WhatsApp", random.randint(11, 20), 3, 180.0)
    time.sleep(20)
    # bump second round of stats
    update_stats("Platform42", "CHANNEL", "Instagram", random.randint(21, 41), 6, 55.0)
    update_stats("Platform42", "CHANNEL", "WhatsApp", random.randint(100, 20), 3, 180.0)
    time.sleep(20)
    # force an exception to test the uncaught exception handler
    a = 10/0

