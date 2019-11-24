#!/bin/bash -l

#SBATCH -J bigbayes
#SBATCH --array=1-6000
#SBATCH -e bigbayes%A-%a.o
#SBATCH -o bigbayes%A-%a.o
#SBATCH -t 06-00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=8G
#SBATCH -p med
#SBATCH --no-requeue

cd /home/eoziolor/phpopg/data/varcall/scaffold/

#files
genome=/home/eoziolor/phgenome/data/genome/CAADHV01.fasta
my_fai=/home/eoziolor/phgenome/data/genome/CAADHV01.fasta.fai
mergebam=/home/eoziolor/phpopg/data/align/allmerge.bam
popsfile=/home/eoziolor/phpopg/data/list/zeros_samples.tsv
hicov=/home/eoziolor/phpopg/data/depth/hicov.bed
reg_file=/home/eoziolor/phgenome/data/genome/CAADHV01.fasta.genome

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
iter=$((crap-((line-1)*20)))
chunk=$((short*iter))
portion=$((1+chunk-short))-$chunk
region=$scaf:$portion

echo "This is array number" $crap 
echo "I am picking line" $line "from genome file"
echo "It is iteration" $iter "for scaffold" $scaf
echo "The chunk size I am picking is" $short "and this is ending at" $chunk
echo "The region this defines is" $portion "from scaffold with length" $end
echo "\n\n"

#directories and files

outdir=/home/eoziolor/phpopg/data/varcall/scaffold
outfile=$scaf\_$iter\.vcf.bgz

$my_samtools view -q 30 -f 2 -h -b  $mergebam $region | \
$my_bedtools intersect -v -a stdin -b $hicov | \
$my_freebayes -f $genome --populations $popsfile --stdin | \
$my_bgz > $outdir/$outfile

echo "The file created is" $outfile
echo "I place it in directory" $outdir
