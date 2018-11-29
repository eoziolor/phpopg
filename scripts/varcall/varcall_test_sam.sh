#!/bin/bash -l

#SBATCH -J freebayes
#SBATCH --array=1-10
#SBATCH -e freebayes%A-%a.o
#SBATCH -o freebayes%A-%a.o
#SBATCH -t 06-00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=8G
#SBATCH -p med
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

$my_samtools view -q 30 -f 2 -h -b  $mergebam $region > $outdir/$scaf.bed
#$my_bedtools intersect -v -a stdin -b $hicov | \
#$my_freebayes -f $genome --populations $popsfile --stdin | \
#$my_bgz > $outdir/$outfile

end=`date +%s`
runtime=$((end-start))
echo "line took $((end-start)) seconds"

echo $outdir
echo $region
echo $outfile
echo $crap
echo $end
