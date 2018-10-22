#!/bin/bash -l

#SBATCH -J rand10Mb10k
#SBATCH -e rand10Mb10k-%j.o
#SBATCH -o rand10Mb10k-%j.o
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -t 03-00:00
#SBATCH --mem=60000
#SBATCH -p high

module load bio3

#files
dir=/home/eoziolor/phpopg/data/depth

zcat $dir/coverage_allbases.txt.gz | \
head -n 529827386| \
sort -R | \
head -n 10000000 | \
gzip > $dir/cov_10Mb10k.txt.gz
