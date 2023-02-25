#!/usr/bin/env bash

set -eu

datepath="times-wsinfer-$(date +%s).txt"

# Kill all background process when the script exits.
# https://stackoverflow.com/a/2173421/5666087
trap "trap - SIGTERM && kill -- -$$" SIGINT SIGTERM EXIT

echo "Saving times to $datepath"

# Collect gpu stats in the background.
bash get-gpu-stats.sh gpu-stats-frontiers.csv &

date > $datepath

singularity run --nv \
	--containall \
	--pwd /quip_app/til_classification/u24_lymphocyte/scripts/ \
	--env MODEL_CONFIG_FILENAME="config_incep-mix-new3_test_ext.ini" \
	--env HEATMAP_VERSION_NAME="lym_incep-mix_probability" \
	--env BINARY_HEATMAP_VERSION_NAME='lym_incep-mix_binary' \
	--env LYM_PREDICTION_BATCH_SIZE=64 \
	--env CUDA_VISIBLE_DEVICES=$CUDA_VISIBLE_DEVICES \
	--bind $PWD/frontiers-output:/quip_app/til_classification/u24_lymphocyte/data \
	--bind $PWD/slides:/quip_app/til_classification/u24_lymphocyte/data/svs \
	frontiers-til_cede545.sif bash svs_2_heatmap.sh

pipeline_pid=$!
echo "Running pipeline in PID $pipeline_pid"

# Wait for the pipeline to finish.
wait $pipeline_pid

date >> $datepath
