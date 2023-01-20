
#!/bin/bash

COMMAND="${1:-}"

source /entrypoint/hive-wait_for_it.sh

source /entrypoint/hadoop-configure.sh

source /entrypoint/hive-configure.sh

source /entrypoint/hive-initialization.sh $COMMAND


