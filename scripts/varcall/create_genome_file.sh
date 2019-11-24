my_fai=/home/eoziolor/phpopg/data/genome/CAADHV01.fasta.fai
my_genome=/home/eoziolor/phpopg/data/genome/CAADHV01.fasta.genome

awk -v OFS='\t' {'print $1,$2'} $my_fai > $my_genome
