#!/bin/bash
#SBATCH --job-name=OBER_Q12946_16S_515F926R_20201113
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=16

source activate ~/miniconda3/envs/qiime2-2019.10

cd /export2/home/microlab/microlab/qiime/illumina_data

ls [A-Z]*.fastq.gz > list_fastq_gz_files.txt

mkdir -p /export2/home/microlab/microlab/qiime/illumina_data/temp
export TMPDIR=/export2/home/microlab/microlab/qiime/illumina_data/temp

mkdir -p OBER_Q12946_16S_515F926R_20201113

mkdir -p OBER_Q12946_16S_515F926R_20201113/raw_data

qiime

cp -u OBER_Q12946_16S_515F926R_20201113@*_R1_*.fastq.gz /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/
cp -u OBER_Q12946_16S_515F926R_20201113@*_R2_*.fastq.gz /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/
cp -u OBER_Q12946_16S_515F926R_20201113*_bash_step_*.sh /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/
gunzip -k /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/OBER_Q12946_16S_515F926R_20201113@*_R1_*.fastq.gz
gunzip -k /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/OBER_Q12946_16S_515F926R_20201113@*_R2_*.fastq.gz
cp /export2/home/microlab/microlab/python_scripts/qiime/qiime_pre_demux.py /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/
cp /export2/home/microlab/microlab/python_scripts/qiime/qiime2_subsampling_quality_check.py /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/
cp OBER_Q12946_16S_515F926R_20201113@metadata.txt /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/
cd /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113
python3.6 qiime_pre_demux.py
cd /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/raw_data/
chmod -R 777 *.fastq
head -40000 /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/raw_data/forward.fastq > /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/10kseq-OBER_Q12946_16S_515F926R_20201113@sub_R1_sample.fastq
head -40000 /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/raw_data/reverse.fastq > /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/10kseq-OBER_Q12946_16S_515F926R_20201113@sub_R2_sample.fastq
gzip -k /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/10kseq-OBER_Q12946_16S_515F926R_20201113@sub_R1_sample.fastq
gzip -k /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/10kseq-OBER_Q12946_16S_515F926R_20201113@sub_R2_sample.fastq
cp -u /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/OBER_Q12946_16S_515F926R_20201113@metadata.txt /export2/home/microlab/microlab/qiime/illumina_data/10kseq-OBER_Q12946_16S_515F926R_20201113@metadata.txt
cp -u /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/*kseq-OBER_Q12946_16S_515F926R_20201113@* /export2/home/microlab/microlab/qiime/illumina_data/
gzip *.fastq
cp -u /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/raw_data/forward.fastq.gz /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/OBER_Q12946_16S_515F926R_20201113@clean_R1_seq.fastq.gz
cp -u /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/raw_data/reverse.fastq.gz /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/OBER_Q12946_16S_515F926R_20201113@clean_R2_seq.fastq.gz
cd /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113
chmod -R 777 *.fastq.gz
python3.6 qiime2_subsampling_quality_check.py
cd /export2/home/microlab/microlab/qiime/illumina_data


source deactivate