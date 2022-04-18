#!/bin/bash
#SBATCH --job-name=alphafold_TcITPK1
#SBATCH --partition=gpu_p
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --gres=gpu:P100:1
#SBATCH --mem=40gb
#SBATCH --time=8:00:00
#SBATCH --output=/scratch/sec84829/DocampoLaboratory/AlphaFoldTcITPK1/log.%j                 # Standard output and error log
#SBATCH --mail-user=sec84829@uga.edu                                    # Where to send mail
#SBATCH --mail-type=ALL                                                 # Mail events (BEGIN, END, FAIL, ALL)

#set output directory variable for project
OUTDIR="/scratch/sec84829/DocampoLaboratory/AlphaFoldTcITPK1"

#if output directory doesn't exist, create it
if [[ ! -d $OUTDIR ]]
then
    mkdir -p $OUTDIR
fi

#make sure everything is going to the right place
cd ${OUTDIR}

#load AlphaFold and associated information
module load AlphaFold/2.1.1-fosscuda-2020b

export ALPHAFOLD_DATA_DIR=/apps/db/AlphaFold/2.1

#control script test on CPUs
python /scratch/sec84829/DocampoLaboratory/run_AlphaFold2.1.1.py --data_dir /apps/db/AlphaFold/2.1 --output_dir /scratch/sec84829/DocampoLaboratory/AlphaFoldTcITPK1 --model_preset=monomer_casp14 --fasta_paths /scratch/sec84829/DocampoLaboratory/TcITPK1.fasta --max_template_date 2021-11-01
