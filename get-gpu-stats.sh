#!/usr/bin/env bash

set -eu

if [ $# -eq 0 ]; then
	echo "usage: script.sh OUTPUT_CSV"
	exit 1
fi

outputcsv="$1"

if [ -f $outputcsv ]; then
	echo "output csv exists: $outputcsv"
	exit 2
fi

write_gpu_data () {
	nvidia-smi --id=$CUDA_VISIBLE_DEVICES --query-gpu=index,uuid,utilization.gpu,memory.total,memory.used,memory.free,utilization.memory,temperature.gpu,pstate \
		--format=csv,noheader,nounits >> "$outputcsv"
}
while true; do
	write_gpu_data
	sleep 5
done
