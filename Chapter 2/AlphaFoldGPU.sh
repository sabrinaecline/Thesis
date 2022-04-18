#!/bin/bash
#SBATCH --job-name=alphafoldattempt
#SBATCH --partition=gpu_p
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --gres=gpu:P100:1
#SBATCH --mem=40gb
#SBATCH --time=120:00:00
#SBATCH --output=%x.%j.out
#SBATCH --error=%x.%j.err
#SBATCH --mail-user=sec84829@uga.edu
#SBATCH --mail-type=ALL

cd $SLURM_SUBMIT_DIR

ml AlphaFold/2.1.0-fosscuda-2020b

export ALPHAFOLD_DATA_DIR=/apps/db/AlphaFold

alphafold -d /apps/db/AlphaFold -o ./test/ -m model_1 -f ./query.fasta -t 2020-05-14 -g FALSE
