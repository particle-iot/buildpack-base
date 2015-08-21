#!/bin/bash
TIME_START=`date +%s.%N`

# Load helper functions
for file in lib/*.bash ; do source "$file"; done

# Setup constants
run-hook /hooks/env

# Start logging to file
exec > >(tee $RUN_LOG)
exec 2> >(tee $STDERR_LOG)

# Run env hook
run-hook /hooks/post-env

# Copy input files to workspace
cp -r $INPUT_DIR/. $WORKSPACE_DIR

# Copy SSH keys
cp -r /ssh/. /root/.ssh

# Run the hooks
run-hook /hooks/pre-build
run-hook /hooks/build
run-hook /hooks/post-build

# Normalize stderr paths (remove all parent dirs)
find-and-replace-in "$WORKSPACE_DIR/" "" $STDERR_LOG

TIME_END=`date +%s.%N`
RUNTIME=`echo "$TIME_END $TIME_START" | awk '{print $1-$2}'`
echo "Finished in: $RUNTIME seconds"
echo $RUNTIME > $ELAPSED_LOG
