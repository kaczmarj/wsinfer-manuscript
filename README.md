# WSInfer Manuscript

We use the first 10 DX1 slides from TCGA-COAD. To reproduce our results, 
please download these 10 SVS files and place them in the `slides` directory.

```
slides/
├── TCGA-3L-AA1B-01Z-00-DX1.svs
├── TCGA-4N-A93T-01Z-00-DX1.svs
├── TCGA-4T-AA8H-01Z-00-DX1.svs
├── TCGA-5M-AAT4-01Z-00-DX1.svs
├── TCGA-5M-AAT5-01Z-00-DX1.svs
├── TCGA-5M-AAT6-01Z-00-DX1.svs
├── TCGA-5M-AATE-01Z-00-DX1.svs
├── TCGA-A6-2671-01Z-00-DX1.svs
├── TCGA-A6-2672-01Z-00-DX1.svs
└── TCGA-A6-2674-01Z-00-DX1.svs
```

Then run the following to run both TIL detection pipelines. The time and GPU
statistics are recorded automatically.

```bash
# Download containers.
bash setup.sh

# Run wsinfer pipeline.
OMP_NUM_THREADS=16 CUDA_VISIBLE_DEVICES=2 screen -S wsinfer bash run-wsinfer.sh

# Run frontiers pipeline.
OMP_NUM_THREADS=16 CUDA_VISIBLE_DEVICES=2 screen -S frontiers bash run-frontiers.sh
```
