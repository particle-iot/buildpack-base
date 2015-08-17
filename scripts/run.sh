#!/bin/bash
TIME_START=`date +%s.%N`

# Load helper functions
for file in lib/*.bash ; do source "$file"; done

# Copy input files to workspace
cp -r $INPUT_DIR $WORKSPACE_DIR

# Setup constants
run-hook /hooks/env
run-hook /hooks/post-env

# Start logging to file
exec > >(tee $OUTPUT_DIR/run.log)
exec 2> >(tee $OUTPUT_DIR/stderr.log)

# Run the hooks
run-hook /hooks/pre-build
run-hook /hooks/build
run-hook /hooks/post-build

TIME_END=`date +%s.%N`
RUNTIME=`echo "$TIME_END $TIME_START" | awk '{print $1-$2}'`
echo "Finished in: $RUNTIME seconds"
