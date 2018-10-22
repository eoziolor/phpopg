#!/bin/bash -l

#SBATCH -J make_hicov
#SBATCH -e make_hicov-%j.o
#SBATCH -o make_hicov-%j.o
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -t 03-00:00
#SBATCH --mem=60000
#SBATCH -p high

module load bio3
source ~/.bashrc

#files
my_cov=/home/eoziolor/phpopg/data/depth/coverage_allbases.txt.gz
my_out=/home/eoziolor/phpopg/data/depth/hicov.bed

zcat $my_cov | \
awk '{OFS="\t"}{s=$2-1}{print $1,s,$2,$3}' | \
awk '{OFS="\t"}{if($4>5000){print}}' | \
bedtools merge -i - -d 10 -c 4 -o count > $my_out
