#!/bin/bash -l

#SBATCH -J bigbayes
#SBATCH --array=1-40
#SBATCH -e bigbayes%A-%a.o
#SBATCH -o bigbayes%A-%a.o
#SBATCH -t 06-00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=8G
#SBATCH -p high
#SBATCH --no-requeue

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

#selecting scaffold to investigate from the genome file

crap=$(echo $SLURM_ARRAY_TASK_ID)
line=$(echo $(((crap+19)/20)))
scaf=$(sed "$line q;d" $reg_file | cut -f1)
end=$(sed "$line q;d" $reg_file | cut -f2)

#chunking a region to investigate

short=$((end/20))
iter=$((crap/line))
chunk=$((iter*short))
if [$chunk<$end]; then
	region=$((1+chunk-short)):$chunk
else
	region=$((1+chunk-short)):$end
fi

echo $region

#region=$scaf:1-$end 

#directories and files

#outdir=/home/eoziolor/phpopg/data/varcall/scaffold
#outfile=$scaf.vcf.bgz

#$my_samtools view -q 30 -f 2 -h -b  $mergebam $region | \
#$my_bedtools intersect -v -a stdin -b $hicov | \
#$my_freebayes -f $genome --populations $popsfile --stdin | \
#$my_bgz > $outdir/$outfile

echo $line
echo $outdir
echo $scaf
