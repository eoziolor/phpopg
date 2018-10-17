#!/bin/bash -l

#SBATCH -J mergebam
#SBATCH -e mergebam-%j.o
#SBATCH -o mergebam-%j.o
#SBATCH -N 1
#SBATCH -n 16
#SBATCH -t 06-00:00
#SBATCH --mem=60000
#SBATCH -p high

#files
my_bam=/home/eoziolor/program/bamtools/build/src/toolkit/bamtools
my_merge=/home/eoziolor/phpopg/data/align/allmerge.bam
my_list=/home/eoziolor/phpopg/data/list/bam_list.txt

#code
$my_bam merge -list $my_list -out $my_merge
