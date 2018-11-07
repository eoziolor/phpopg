#!/bin/bash -l

#SBATCH -J bam_index
#SBATCH -e bam_index-%j.o
#SBATCH -o bam_index-%j.o
#SBATCH -N 1
#SBATCH -n 16
#SBATCH -t 06-00:00
#SBATCH --mem=60000
#SBATCH -p high

my_stools=/home/eoziolor/program/samtools-1.9/samtools
my_bam=/home/eoziolor/phpopg/data/align/allmerge.bam
my_out=/home/eoziolor/phpopg/data/align/allmerge.bai

$my_stools index -@16 $my_bam $my_out
