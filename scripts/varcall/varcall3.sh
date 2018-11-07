#!/bin/bash -l

#SBATCH -J freebayes
#SBATCH --array=20001-30000
#SBATCH -e freebayes%A-%a.o
#SBATCH -o freebayes%A-%a.o
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -t 01-00:00
#SBATCH --mem=8000
#SBATCH -p low

cd /home/eoziolor/phpopg/data/varcall/scaffold/


#files
genome=/home/eoziolor/phgenome/data/genome/phgenome_masked.fasta
my_fai=/home/eoziolor/phgenome/data/genome/phgenome_masked.fasta.fai
mergebam=/home/eoziolor/phpopg/data/align/allmerge.bam
popsfile=/home/eoziolor/phpopg/data/list/zeros_samples.tsv
hicov=/home/eoziolor/phpopg/data/depth/hicov.bed
reg_file=/home/eoziolor/phgenome/data/genome/phgenome_masked.fasta.genome

#programs
my_freebayes=/home/eoziolor/program/freebayes/bin/freebayes
my_samtools=/home/eoziolor/program/samtools-1.9/samtools
my_bgz=/home/eoziolor/program/htslib/bgzip
my_bedtools=/home/eoziolor/program/bedtools2/bin/bedtools

#region to investigate

crap=$(echo $SLURM_ARRAY_TASK_ID)
scaf=$(sed "$crap q;d" $reg_file | cut -f1)
end=$(sed "$crap q;d" $reg_file | cut -f2)
region=$scaf:1-$end 

#directories and files

outdir=/home/eoziolor/phpopg/data/varcall/scaffold
outfile=$scaf.vcf.bgz

$my_samtools view -q 30 -f 2 -h -b  $mergebam $region | \
$my_bedtools intersect -v -a stdin -b $hicov | \
$my_freebayes -f $genome --populations $popsfile --stdin | \
$my_bgz > $outdir/$outfile

echo $outdir
echo $region
echo $outfile
echo $crap
