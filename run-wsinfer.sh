#!/usr/bin/env bash

set -eu

datepath="times-wsinfer-$(date +%s).txt"

# Kill all background process when the script exits.
# https://stackoverflow.com/a/2173421/5666087
trap "trap - SIGTERM && kill -- -$$" SIGINT SIGTERM EXIT

echo "Saving times to $datepath"

# Collect gpu stats in the background.
bash get-gpu-stats.sh gpu-stats-wsinfer.csv &

date > $datepath

singularity run \
	--nv \
	--pwd $PWD \
	--env CUDA_VISIBLE_DEVICES=$CUDA_VISIBLE_DEVICES \
	--containall \
	--bind $PWD wsinfer_0.3.6-tils.sif run \
		--wsi-dir slides/ \
		--results-dir results-wsinfer/ \
		--batch-size 64 \
		--num-workers 8 &

pipeline_pid=$!
echo "Running pipeline in PID $pipeline_pid"

# Wait for the pipeline to finish.
wait $pipeline_pid

date >> $datepath
