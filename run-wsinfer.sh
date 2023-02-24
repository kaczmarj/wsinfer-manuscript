#!/usr/bin/env bash

set -eu

datepath="times-wsinfer-$(date +%s).txt"

echo "Saving times to $datepath"

# Collect gpu stats in the background.
bash get-gpu-stats.sh gpu-stats-wsinfer.csv &

# Kill gpu stats monitor when this script exits.
gpu_stats_pid=$!
trap "kill $gpu_stats_pid; exit" SIGHUP SIGINT SIGTERM
echo "GPU being monitored by pid $gpu_stats_pid"

date > $datepath

apptainer run \
	--nv \
	--pwd $PWD \
	--env CUDA_VISIBLE_DEVICES=$CUDA_VISIBLE_DEVICES \
	--containall \
	--bind $PWD wsinfer_0.3.6-tils.sif run \
		--wsi-dir slides/ \
		--results-dir results-wsinfer/ \
		--batch-size 128 \
		--num-workers 8 &

wait

date >> $datepath

