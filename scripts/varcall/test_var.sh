reg_file=/home/eoziolor/phgenome/data/genome/phgenome_masked.fasta.genome

for i in {1..60}; do
        crap=$(echo $i)
        line=$(echo $(((crap+19)/20)))
        scaf=$(sed "$line q;d" $reg_file | cut -f1)
        end=$(sed "$line q;d" $reg_file | cut -f2)

#chunking a region to investigate

        short=$((end/20))
campus-113-109:~ eoziolor$ 
campus-113-109:~ eoziolor$ ))
        region=$((1+chunk-short)):$chunk

        echo "This is array number" $crap 
        echo "I am picking line" $line "from genome file"
        echo "It is iteration" $iter "for scaffold" $scaf
        echo "The chunk size I am picking is" $short "and this is ending at" $chunk
        echo "The region this defines is" $region "from scaffold with length" $end
        echo "\n\n"
done
