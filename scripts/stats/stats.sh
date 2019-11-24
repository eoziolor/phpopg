#!/bin/bash -l

#SBATCH -J bam_stats
#SBATCH --array=1-1250
#SBATCH -e bam_stats%A-%a.o
#SBATCH -o bam_stats%A-%a.o
#SBATCH -N 1
#SBATCH -n 4
#SBATCH -t 01-00:00
#SBATCH --mem=8000
#SBATCH -p high

#Assigning number to be able to get into each folder separately

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

echo $sample

#files
my_dir=/home/eoziolor/phpopg/data/align
my_sam=/home/eoziolor/program/samtools-1.9/bin/samtools
my_out=/home/eoziolor/phpopg/data/stats/stats_${sample}.txt

#code
for file in $my_dir/${sample}*.bam; do
	$my_sam flagstat $file >> $my_out
done
