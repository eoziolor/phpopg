#!/bin/bash -l

#SBATCH -J combo_trimalign
#SBATCH --array=1-3
#SBATCH -e combo_trimalign%A-%a.o
#SBATCH -o combo_trimalign%A-%a.o
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -t 01-00:00
#SBATCH --mem=8000

module load bio3

#Assigning number to be able to get into each folder separately

if (($SLURM_ARRAY_TASK_ID < 10))
then
	num=00$(echo $SLURM_ARRAY_TASK_ID)
elif (($SLURM_ARRAY_TASK_ID < 100))
then
	num=0$(echo $SLURM_ARRAY_TASK_ID)
else
	num=$(echo $SLURM_ARRAY_TASK_ID)
fi

echo $num

#Assigning new sample numbers with same amount of digits
if (($SLURM_ARRAY_TASK_ID < 10))
then
        sample=000$(echo $SLURM_ARRAY_TASK_ID)
elif (($SLURM_ARRAY_TASK_ID < 100))
then
        sample=00$(echo $SLURM_ARRAY_TASK_ID)
elif (($SLURM_ARRAY_TASK_ID <1000))
then
	sample=0$(echo $SLURM_ARRAY_TASK_ID)
else
        sample=$(echo $SLURM_ARRAY_TASK_ID)
fi


#Directory and file assignment for each file and program
my_dir=/home/eoziolor/phpopg/data/128.120.88.242/raw_data
fq1=$my_dir/AWPH*$num/*1.fq.gz
fq2=$my_dir/AWPH*$num/*2.fq.gz
my_bwa=/home/eoziolor/program/bwa-0.7.17/bwa
my_sam=/home/eoziolor/program/samtools-1.9/samtools
my_out=/home/eoziolor/phpopg/data/align/
my_gen=/home/eoziolor/phpopg/data/genome_chr/c.harengus.fa
my_list=/home/eoziolor/phpopg/data/list/zeros_samples.tsv

#others
pop=$(cat $my_list | grep $sample | cut -f 2)
rg=$(echo \@RG\\tID:$sample\\tPL:Illumina\\tPU:x\\tLB:combined\\tSM:$sample.$pop)
outroot=$sample\_$pop

#Code
paste <(zcat $fq1 | paste - - - -) \
      <(zcat $fq2 | paste - - - -) |\
tr '\t' '\n' |\
cutadapt -j 8 --interleaved -a CTGTCTCTTATA -A CTGTCTCTTATA -u 10 -U 10 -q 30 --trim-n --minimum-length 36 - |\
$my_bwa mem $my_gen -p -R $rg -t 2 - |\
$my_sam view -Shu - | \
$my_sam sort -n - - | \
$my_sam fixmate -m -  - | \
$my_sam sort -p - - | \
$my_sam markdup -l 150 -r -S - $my_out/${outroot}.bam
