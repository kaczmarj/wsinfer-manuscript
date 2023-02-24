#!/usr/bin/env bash

# Frontier TILs container
singularity pull docker://kaczmarj/frontiers-til:cede545

# Wsinfer container
singularity pull docker://kaczmarj/wsinfer:0.3.6-tils
