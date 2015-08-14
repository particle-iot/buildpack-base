#!/bin/bash
TIME_START=`date +%s.%N`

# Setup constants
run_hook /hooks/env
run_hook /hooks/post-env

# Load helper functions
for file in lib/*.bash ; do source "$file"; done

# Start logging to file
exec > >(tee $OUTPUT_DIR/run.log)
exec 2> >(tee $OUTPUT_DIR/stderr.log)

# Run the hooks
run_hook /hooks/pre-build
run_hook /hooks/build
run_hook /hooks/post-build

TIME_END=`date +%s.%N`
RUNTIME=`echo "$TIME_END $TIME_START" | awk '{print $1-$2}'`
echo "Finished in: $RUNTIME seconds"
