#!/bin/bash -l

#SBATCH -J rand10Mb
#SBATCH -e rand10Mb-%j.o
#SBATCH -o rand10Mb-%j.o
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -t 03-00:00
#SBATCH --mem=60000
#SBATCH -p high

module load bio3

#files
dir=/home/eoziolor/phpopg/data/depth

zcat $dir/coverage_allbases.txt.gz | \
sort -R | \
head -n 10000000 | \
gzip > $dir/cov_10Mbrand.txt.gz
