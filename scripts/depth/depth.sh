#!/bin/bash -l

#SBATCH -J bamdepth
#SBATCH -e bamdepth-%j.o
#SBATCH -o bamdepth-%j.o
#SBATCH -N 1
#SBATCH -n 16
#SBATCH -t 06-00:00
#SBATCH --mem=60000
#SBATCH -p high

module load bio3

#files
my_bam=/home/eoziolor/phpopg/data/align/allmerge.bam
#my_stools=/home/eoziolor/program/samtools-1.9/bin/samtools
my_out=/home/eoziolor/phpopg/data/depth/coverage_allbases.txt.gz

#code
samtools depth \
-d 10000 \
$my_bam | gzip > $my_out
