#!/bin/bash -l

#SBATCH -J freebayes_free
#SBATCH --array=2-3
#SBATCH -e freebayes_free_%A-%a.o
#SBATCH -o freebayes_free_%A-%a.o
#SBATCH -t 06-00:00
#SBATCH -n 4
#SBATCH --mem=8G
#SBATCH -p high
#SBATCH --no-requeue

source ~/.bashrc

cd /home/eoziolor/program/freebayes/

#files
genome=/home/eoziolor/phgenome/data/genome/phgenome_masked.fasta
my_fai=/home/eoziolor/phgenome/data/genome/phgenome_masked.fasta.fai
mergebam=/home/eoziolor/phpopg/data/align/allmerge.bam
popsfile=/home/eoziolor/phpopg/data/list/zeros_samples.tsv
hicov=/home/eoziolor/phpopg/data/depth/hicov.bed
reg_file=/home/eoziolor/phgenome/data/genome/phgenome_masked.fasta.genome

#programs
my_freebayes=/home/eoziolor/program/freebayes/bin/freebayes
my_parallel=/home/eoziolor/program/freebayes/scripts/freebayes-parallel
my_generate=/home/eoziolor/program/freebayes/scripts/fasta_generate_regions.py
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

#code to run
start=`date +%s`

#$my_samtools view -q 30 -f 2 -h -b  $mergebam $region > $outdir/$scaf.bed
#$my_bedtools intersect -v -b $hicov -a $outdir/$scaf.bed >  $outdir/$scaf\_low.bam
$my_freebayes -f $genome --populations $popsfile $outdir/$scaf\_low.bam | \
$my_bgz > $outdir/$outfile\_2

end=`date +%s`
runtime=$((end-start))
echo "line took $((end-start)) seconds"

echo $outdir
echo $region
echo $outfile
echo $crap
echo $end
