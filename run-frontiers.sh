#!/usr/bin/env bash

set -eu

datepath="times-frontiers-$(date +%s).txt"

echo "Saving times to $datepath"

# Collect gpu stats in the background.
bash get-gpu-stats.sh gpu-stats-frontiers.csv &

# Kill gpu stats monitor when this script exits.
gpu_stats_pid=$!
trap "kill $gpu_stats_pid; exit" SIGHUP SIGINT SIGTERM
echo "GPU being monitored by pid $gpu_stats_pid"

date > $datepath

apptainer run --nv \
	--containall \
	--pwd /quip_app/til_classification/u24_lymphocyte/scripts/ \
	--env CUDA_VISIBLE_DEVICES=2 \
	--env MODEL_CONFIG_FILENAME="config_incep-mix-new3_test_ext.ini" \
	--env HEATMAP_VERSION_NAME="lym_incep-mix_probability" \
	--env BINARY_HEATMAP_VERSION_NAME='lym_incep-mix_binary' \
	--env LYM_PREDICTION_BATCH_SIZE=128 \
	--env CUDA_VISIBLE_DEVICES=$CUDA_VISIBLE_DEVICES \
	--bind $PWD/frontiers-output:/quip_app/til_classification/u24_lymphocyte/data \
	--bind $PWD/slides:/quip_app/til_classification/u24_lymphocyte/data/svs \
	frontiers-til_cede545.sif bash svs_2_heatmap.sh

wait
date >> $datepath
