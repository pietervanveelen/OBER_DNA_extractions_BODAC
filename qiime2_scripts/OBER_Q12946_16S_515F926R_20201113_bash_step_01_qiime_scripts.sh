#!/bin/bash
#SBATCH --job-name=OBER_Q12946_16S_515F926R_20201113
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=16

source activate ~/miniconda3/envs/qiime2-2019.10

cd /export2/home/microlab/microlab/qiime/illumina_data

mkdir -p /export2/home/microlab/microlab/qiime/illumina_data/temp
export TMPDIR=/export2/home/microlab/microlab/qiime/illumina_data/temp

mkdir -p OBER_Q12946_16S_515F926R_20201113

mkdir -p OBER_Q12946_16S_515F926R_20201113/raw_data

qiime

cp -u OBER_Q12946_16S_515F926R_20201113*_bash_step_*.sh /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/
cd /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113

qiime tools import \
--type MultiplexedPairedEndBarcodeInSequence \
--input-path /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/raw_data \
--output-path /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/OBER_Q12946_16S_515F926R_20201113_paired_end_sequences.qza

qiime cutadapt demux-paired \
--i-seqs /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/OBER_Q12946_16S_515F926R_20201113_paired_end_sequences.qza \
--m-forward-barcodes-file /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/OBER_Q12946_16S_515F926R_20201113@metadata.txt \
--m-forward-barcodes-column BarcodeSequence \
--p-error-rate 0 \
--o-per-sample-sequences /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/OBER_Q12946_16S_515F926R_20201113_demux.qza \
--o-untrimmed-sequences /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/OBER_Q12946_16S_515F926R_20201113_untrimmed.qza \
--verbose

qiime demux summarize \
--i-data /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/OBER_Q12946_16S_515F926R_20201113_demux.qza \
--o-visualization /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/OBER_Q12946_16S_515F926R_20201113_demux.qzv 

qiime cutadapt trim-paired \
--i-demultiplexed-sequences /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/OBER_Q12946_16S_515F926R_20201113_demux.qza \
--p-front-f GTGYCAGCMGCCGCGGTAA \
--p-front-r CCGYCAATTYMTTTRAGTTT \
--p-discard-untrimmed \
--o-trimmed-sequences /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/OBER_Q12946_16S_515F926R_20201113_trimmed-demux-seqs.qza

qiime demux summarize \
--i-data /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/OBER_Q12946_16S_515F926R_20201113_trimmed-demux-seqs.qza \
--o-visualization /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/OBER_Q12946_16S_515F926R_20201113_trimmed-demux-seqs.qzv 

qiime dada2 denoise-paired \
--i-demultiplexed-seqs /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/OBER_Q12946_16S_515F926R_20201113_trimmed-demux-seqs.qza \
--p-trim-left-f 5 \
--p-trim-left-r 5 \
--p-trunc-len-f 240 \
--p-trunc-len-r 200 \
--o-table /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/OBER_Q12946_16S_515F926R_20201113_table.qza \
--o-representative-sequences /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/OBER_Q12946_16S_515F926R_20201113_representative_sequences.qza \
--o-denoising-stats /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/OBER_Q12946_16S_515F926R_20201113_denoising_stats.qza \
--p-n-threads 16 

qiime metadata tabulate \
--m-input-file /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/OBER_Q12946_16S_515F926R_20201113_denoising_stats.qza \
--o-visualization /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/OBER_Q12946_16S_515F926R_20201113_denoising_stats.qzv

qiime feature-table summarize \
--i-table /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/OBER_Q12946_16S_515F926R_20201113_table.qza \
--m-sample-metadata-file /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/OBER_Q12946_16S_515F926R_20201113@metadata.txt \
--o-visualization /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/OBER_Q12946_16S_515F926R_20201113_table.qzv

qiime feature-table tabulate-seqs \
--i-data /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/OBER_Q12946_16S_515F926R_20201113_representative_sequences.qza \
--o-visualization /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/OBER_Q12946_16S_515F926R_20201113_representative_sequences.qzv

qiime alignment mafft \
--i-sequences /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/OBER_Q12946_16S_515F926R_20201113_representative_sequences.qza \
--o-alignment /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/OBER_Q12946_16S_515F926R_20201113_aligned-rep-seqs.qza \
--p-n-threads 16 

qiime alignment mask \
--i-alignment /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/OBER_Q12946_16S_515F926R_20201113_aligned-rep-seqs.qza \
--o-masked-alignment /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/OBER_Q12946_16S_515F926R_20201113_masked_aligned-rep-seqs.qza

qiime phylogeny fasttree \
--i-alignment /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/OBER_Q12946_16S_515F926R_20201113_masked_aligned-rep-seqs.qza \
--o-tree /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/OBER_Q12946_16S_515F926R_20201113_unrooted-tree.qza \
--p-n-threads 16

qiime phylogeny midpoint-root \
--i-tree /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/OBER_Q12946_16S_515F926R_20201113_unrooted-tree.qza \
--o-rooted-tree /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/OBER_Q12946_16S_515F926R_20201113_rooted-tree.qza

qiime feature-classifier classify-sklearn \
--i-classifier /export2/home/microlab/microlab/qiime_classifiers/NB_classifier_SILVA_132_99_16S_515F-926R_QIIME2-2019.10.qza \
--i-reads /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/OBER_Q12946_16S_515F926R_20201113_representative_sequences.qza \
--o-classification /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/OBER_Q12946_16S_515F926R_20201113_taxonomy_NB_classifier_SILVA_132_99_16S_515F-926R_QIIME2-2019.10.qza \
--p-n-jobs 16

qiime metadata tabulate \
--m-input-file /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/OBER_Q12946_16S_515F926R_20201113_taxonomy_NB_classifier_SILVA_132_99_16S_515F-926R_QIIME2-2019.10.qza \
--o-visualization /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/OBER_Q12946_16S_515F926R_20201113_taxonomy_NB_classifier_SILVA_132_99_16S_515F-926R_QIIME2-2019.10.qzv

qiime tools export \
--input-path /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/OBER_Q12946_16S_515F926R_20201113_representative_sequences.qza \
--output-path /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113

qiime tools export \
--input-path /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/OBER_Q12946_16S_515F926R_20201113_table.qza \
--output-path /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113

qiime tools export \
--input-path /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/OBER_Q12946_16S_515F926R_20201113_rooted-tree.qza \
--output-path /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113

qiime tools export \
--input-path /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/OBER_Q12946_16S_515F926R_20201113_taxonomy_NB_classifier_SILVA_132_99_16S_515F-926R_QIIME2-2019.10.qza \
--output-path /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/

mv /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/dna-sequences.fasta /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/OBER_Q12946_16S_515F926R_20201113_dna-sequences.fasta
mv /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/feature-table.biom /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/OBER_Q12946_16S_515F926R_20201113_feature-table.biom
mv /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/tree.nwk /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/OBER_Q12946_16S_515F926R_20201113_tree.nwk
mv /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/taxonomy.tsv /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/OBER_Q12946_16S_515F926R_20201113_taxonomy.tsv

unzip /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/OBER_Q12946_16S_515F926R_20201113_demux.qzv -d /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113
find /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113 -type f -name 'forward-seven-number-summaries.csv' -exec sh -c 'for arg do cp -- "$arg" "/export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/OBER_Q12946_16S_515F926R_20201113_forward-seven-number-summaries.csv"; done' _ {} +
find /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113 -type f -name 'reverse-seven-number-summaries.csv' -exec sh -c 'for arg do cp -- "$arg" "/export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/OBER_Q12946_16S_515F926R_20201113_reverse-seven-number-summaries.csv"; done' _ {} +
unzip /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/OBER_Q12946_16S_515F926R_20201113_denoising_stats.qza -d /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113
find /export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113 -type f -name 'stats.tsv' -exec sh -c 'for arg do cp -- "$arg" "/export2/home/microlab/microlab/qiime/illumina_data/OBER_Q12946_16S_515F926R_20201113/CHECK_OBER_Q12946_16S_515F926R_20201113_stats.tsv"; done' _ {} +

source deactivate