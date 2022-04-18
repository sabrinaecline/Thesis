#!/bin/bash
#SBATCH --job-name=project_final                                              # job name
#SBATCH --partition=batch		                                            # Partition (queue) name
#SBATCH --ntasks=1			                                                # Single task job
#SBATCH --cpus-per-task=6		                                            # Number of cores per task - match this to the num_threads used by BLAST
#SBATCH --mem=24gb			                                                # Total memory for job
#SBATCH --time=8:00:00  		                                            # Time limit hrs:min:sec
#SBATCH --output=/work/gene8940/sec84829/project/log.%j                 # Standard output and error log
#SBATCH --mail-user=sec84829@uga.edu                                    # Where to send mail
#SBATCH --mail-type=ALL                                                 # Mail events (BEGIN, END, FAIL, ALL)

#set output directory variable for project
OUTDIR="/work/gene8940/sec84829/project"

#if output directory doesn't exist, create it
if [[ ! -d $OUTDIR ]]
then
    mkdir -p $OUTDIR
fi

#make sure everything is going to the right place
cd ${OUTDIR}

#load modules
module load SRA-Toolkit/2.9.6-1-centos_linux64
module load kallisto/0.46.1-foss-2019b

#create directory for all SRA files
SRA="/work/gene8940/sec84829/project/SRA"

if [[ ! -d $SRA ]]
then
    mkdir -p $SRA
fi

#download the Trypanosoma cruzi strain CL Brener Non-Esmeraldo CDS fasta file from TriTrypDB (version 55)
curl -s https://tritrypdb.org/common/downloads/Current_Release/TcruziCLBrenerNon-Esmeraldo-like/fasta/data/TriTrypDB-55_TcruziCLBrenerNon-Esmeraldo-like_AnnotatedCDSs.fasta > ${OUTDIR}/TcCLBRefSeq.fna

#make kallisto index files of Trypanosoma cruzi strain CL Brener RefSeq CDS fasta file
kallisto index -i ${OUTDIR}/TcCLBRefSeq_CDSRefSeq.idx ${OUTDIR}/TcCLBRefSeq.fna

#download all SRA files for project into ${OUTDIR}/SRA
cd ${OUTDIR}/SRA

#RNA-seq of T. cruzi epimastigotes - CONTROL
prefetch -O ${OUTDIR}/SRA SRX7822256
fastq-dump --split-files --gzip SRX7822256.sra

prefetch -O ${OUTDIR}/SRA SRX7822257
fastq-dump --split-files --gzip SRX7822257.sra

prefetch -O ${OUTDIR}/SRA SRX7822258
fastq-dump --split-files --gzip SRX7822258.sra

##RNA-seq of T. cruzi epimastigotes - Pd-dppf-mpo treated
prefetch -O ${OUTDIR}/SRA SRX7822259
fastq-dump --split-files --gzip SRX7822259.sra

prefetch -O ${OUTDIR}/SRA SRX7822260
fastq-dump --split-files --gzip SRX7822260.sra

prefetch -O ${OUTDIR}/SRA SRX7822261
fastq-dump --split-files --gzip SRX7822261.sra

#RNA-seq of T. cruzi epimastigotes - Pt-dppf-mpo treated
prefetch -O ${OUTDIR}/SRA SRX7822262
fastq-dump --split-files --gzip SRX7822262.sra

prefetch -O ${OUTDIR}/SRA SRX7822263
fastq-dump --split-files --gzip SRX7822263.sra

prefetch -O ${OUTDIR}/SRA SRX7822264
fastq-dump --split-files --gzip SRX7822264.sra

cd ..

#make kallisto directory and run kallisto quant on all 9 samples using fastq data located in /work/gene8940/sec84829/project/SRA
KALLISTODIR="/work/gene8940/sec84829/project/kallisto"

if [[ ! -d $KALLISTODIR ]]
then
    mkdir -p $KALLISTODIR
fi

kallisto quant -b 100 -i ${OUTDIR}/TcCLBRefSeq_CDSRefSeq.idx -o ${KALLISTODIR}/SRX7822256 -t 6 /work/gene8940/sec84829/project/SRA/SRX7822256_1.fastq.gz /work/gene8940/sec84829/project/SRA/SRX7822256_2.fastq.gz
kallisto quant -b 100 -i ${OUTDIR}/TcCLBRefSeq_CDSRefSeq.idx -o ${KALLISTODIR}/SRX7822257 -t 6 /work/gene8940/sec84829/project/SRA/SRX7822257_1.fastq.gz /work/gene8940/sec84829/project/SRA/SRX7822257_2.fastq.gz
kallisto quant -b 100 -i ${OUTDIR}/TcCLBRefSeq_CDSRefSeq.idx -o ${KALLISTODIR}/SRX7822258 -t 6 /work/gene8940/sec84829/project/SRA/SRX7822258_1.fastq.gz /work/gene8940/sec84829/project/SRA/SRX7822258_2.fastq.gz
kallisto quant -b 100 -i ${OUTDIR}/TcCLBRefSeq_CDSRefSeq.idx -o ${KALLISTODIR}/SRX7822259 -t 6 /work/gene8940/sec84829/project/SRA/SRX7822259_1.fastq.gz /work/gene8940/sec84829/project/SRA/SRX7822259_2.fastq.gz
kallisto quant -b 100 -i ${OUTDIR}/TcCLBRefSeq_CDSRefSeq.idx -o ${KALLISTODIR}/SRX7822260 -t 6 /work/gene8940/sec84829/project/SRA/SRX7822260_1.fastq.gz /work/gene8940/sec84829/project/SRA/SRX7822260_2.fastq.gz
kallisto quant -b 100 -i ${OUTDIR}/TcCLBRefSeq_CDSRefSeq.idx -o ${KALLISTODIR}/SRX7822261 -t 6 /work/gene8940/sec84829/project/SRA/SRX7822261_1.fastq.gz /work/gene8940/sec84829/project/SRA/SRX7822261_2.fastq.gz
kallisto quant -b 100 -i ${OUTDIR}/TcCLBRefSeq_CDSRefSeq.idx -o ${KALLISTODIR}/SRX7822262 -t 6 /work/gene8940/sec84829/project/SRA/SRX7822262_1.fastq.gz /work/gene8940/sec84829/project/SRA/SRX7822262_2.fastq.gz
kallisto quant -b 100 -i ${OUTDIR}/TcCLBRefSeq_CDSRefSeq.idx -o ${KALLISTODIR}/SRX7822263 -t 6 /work/gene8940/sec84829/project/SRA/SRX7822263_1.fastq.gz /work/gene8940/sec84829/project/SRA/SRX7822263_2.fastq.gz
kallisto quant -b 100 -i ${OUTDIR}/TcCLBRefSeq_CDSRefSeq.idx -o ${KALLISTODIR}/SRX7822264 -t 6 /work/gene8940/sec84829/project/SRA/SRX7822264_1.fastq.gz /work/gene8940/sec84829/project/SRA/SRX7822264_2.fastq.gz

source activate R
R --no-save < $HOME/BINF8940/projectRscript.r
