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
    while True:
        # bump first round of stats
        update_stats("Platform42", "CHANNEL", "WhatsApp", random.randint(10, 20), random.randint(0, 5), 180.0)
        update_stats("Platform42", "CHANNEL", "Instagram", random.randint(20, 40), random.randint(2, 7), 55.0)
        time.sleep(20)
        a = 10 / random.randint(0, 40)
