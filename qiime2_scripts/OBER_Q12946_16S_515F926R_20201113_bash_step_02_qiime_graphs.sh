#!/bin/bash
#SBATCH --job-name=OBER_Q12946_16S_515F926R_20201113
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=16

source activate ~/miniconda3/envs/qiime2-2019.10

qiime

cd /export2/home/microlab/microlab/qiime/illumina_data

cp /export2/home/microlab/microlab/python_scripts/qiime/qiime_settings.ini /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/qiime_settings.txt
cp -u /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113*_bash_step_*.sh /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/

qiime diversity alpha-rarefaction \
--i-table /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/OBER_Q12946_16S_515F926R_20201113_table.qza \
--m-metadata-file /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/OBER_Q12946_16S_515F926R_20201113@metadata.txt \
--o-visualization /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/OBER_Q12946_16S_515F926R_20201113_alpha_rarefaction_curves.qzv \
--p-min-depth 100 \
--p-max-depth 10000


qiime diversity core-metrics-phylogenetic \
--i-table /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/OBER_Q12946_16S_515F926R_20201113_table.qza \
--i-phylogeny /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/OBER_Q12946_16S_515F926R_20201113_rooted-tree.qza \
--m-metadata-file /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/OBER_Q12946_16S_515F926R_20201113@metadata.txt \
--p-sampling-depth 29207 \
--output-dir /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/OBER_Q12946_16S_515F926R_20201113_microbial-diversity-results


qiime taxa barplot \
--i-table /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/OBER_Q12946_16S_515F926R_20201113_table.qza \
--i-taxonomy /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/OBER_Q12946_16S_515F926R_20201113_taxonomy_NB_classifier_SILVA_132_99_16S_515F-926R_QIIME2-2019.10.qza \
--m-metadata-file /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/OBER_Q12946_16S_515F926R_20201113@metadata.txt \
--o-visualization /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/OBER_Q12946_16S_515F926R_20201113_taxa_barplot.qzv


source deactivate