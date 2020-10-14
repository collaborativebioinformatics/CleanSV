Install:

```
# copy latest vcfanno binary from github releases
conda install bedtools
```

After dx login:
```
dx download cleanSV:/repeats -r # all these are from USCS mapping and sequencing and repeats tracks
dx download cleanSV:/COLO829/evaluate.R-output -r # all vcfs
dx download cleanSV:/HG002/evaluate.R-output -r # all vcfs
wget https://hgdownload.soe.ucsc.edu//gbdb/hg19/bbi/wgEncodeCrgMapabilityAlign24mer.bw
wget https://hgdownload.soe.ucsc.edu/goldenPath/hg19/gc5Base/hg19.gc5Base.txt.gz
```

Convert files:

```
convert2bed --input=wig --output=bed < hg19.gc5Base.txt > hg19.gc5Base.bed
```
