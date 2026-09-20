import sys

from ops_stats import (
    update_stats,
    update_state
)

#
#   catch all exceptions before exit
#
def handle_uncaught_exception(exc_type, exc_value, exc_traceback):
    print("*** FUCK ")
    if issubclass(exc_type, KeyboardInterrupt):
        sys.__excepthook__(exc_type, exc_value, exc_traceback)
        return
    update_state("Platform42", "ORCHESTRATOR", "Orchestrator", False)
    exit(1)


sys.excepthook = handle_uncaught_exception

if __name__ == "__main__":
    update_stats("Platform42", "CHANNEL", "WhatsApp", 3, 1, 180.0)
    update_stats("Platform42", "CHANNEL", "Instagram", 4, 0, 55.0)
    update_state("Platform42", "ORCHESTRATOR", "Orchestrator", True)

    a = 10/0

