#! /urs/bin/env bash 

#Q1: Use BEDtools intersect to identify the size of thelargest overlap between CTCF and H3K4me3 locations.

tfbs=~/projects/data-sets/bed/encode.tfbs.chr22.bed.gz
h3k4=~/projects/data-sets/bed/encode.h3k4me3.hela.chr22.bed.gz

answer_1=$(gzcat $tfbs \
    | awk '($4 == "CTCF")' \
    | bedtools intersect -a - -b $h3k4 -wo \
    | cut -f15 \
    | sort -n \
    | tail -n1
    ) 

echo "answer-1: $answer_1" 

#Q2: Use BEDtools to calculate the GC content of nucleotides 19,000,000 to
#19,000,500 on chr22 of hg19 genome build. Report the GC content as a
#fraction (e.g., 0.50).

chr22=~/projects/data-sets/fasta/hg19.chr22.fa

answer_2=$(echo -e "chr22\t19000000\t19000500" > region.bed \
    | bedtools nuc -fi $chr22 -bed region.bed \
    | cut -f5 \
    | tail -n1) 

echo "answer-2: $answer_2" 

#Q3:Use BEDtools to identify the length of the CTCF ChIP-seq peak (i.e.,
#interval) that has the largest mean signal in ctcf.hela.chr22.bg.gz.

signal=~/projects/data-sets/bedtools/ctcf.hela.chr22.bg.gz

answer_3=$(gzcat $tfbs \
    | awk '($4 == "CTCF")' \
    | bedtools map -a - -b $signal -c 4 -o mean \
    | sort -k5n \
    | tail -n1 \
    | awk '{print $3 - $2}') 

echo "answer-3: $answer_3"

#Use BEDtools to identify the gene promoter (defined as 1000 bp upstream of
#a TSS) with the highest median signal in ctcf.hela.chr22.bg.gz. Report the
#gene name (e.g., 'ABC123')

tss=~/projects/data-sets/bed/tss.hg19.chr22.bed.gz
genome=~/projects/data-sets/genome/hg19.genome

answer_4=$(bedtools flank -i $tss -g $genome -s -l 1000 -r 1000 \
    | bedtools sort -i - \
    | bedtools map -a - -b $signal -c 4 -o mean \
    | sort -k7n \
    | tail -n1 \
    | awk '{print $4}') 

echo "answer-4:$answer_4" 

#Use BEDtools to identify the longest interval on chr22 that is not
#covered by genes.hg19.bed.gz. Report the interval like chr1:100-500.

genes=~/projects/data-sets/bed/genes.hg19.bed.gz

answer_5=$(bedtools complement -i $genes -g $genome \
    | awk 'BEGIN {OFS="\t"} ($1 == "chr22") {print $1, $2, $3, $3-$2}' \
    | sort -k4n \
    | tail -n1 \
    | awk '{print $1":"$2"-"$3}')

echo "answer-5:$answer_5"







