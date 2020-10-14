Install:

```
# copy latest vcfanno binary from github releases
conda install bedtools
```

After dx login:
```
dx download cleanSV:/repeats -r # all these are from USCS mapping and sequencing and repeats tracks
dx download cleanSV:/COLO829/evaluate.R-output -r # all vcfs
mkdir -p COLO829
mv evaluate.R-output COLO829
dx download cleanSV:/HG002/evaluate.R-output -r # all vcfs
mkdir -p HG002
mv evaluate.R-output HG002
wget https://hgdownload.soe.ucsc.edu//gbdb/hg19/bbi/wgEncodeCrgMapabilityAlign24mer.bw
wget https://hgdownload.soe.ucsc.edu/goldenPath/hg19/gc5Base/hg19.gc5Base.txt.gz
```

Convert/format files:

```
convert2bed --input=wig --output=bed < hg19.gc5Base.txt > hg19.gc5Base.bed
bash formatting/formatrepeats.sh
```

VCFanno run:
```
vcfanno config.toml HG002/evaluate.R-output/HG002.gridss.truthset.vcf.gz > hg002.gridss.anno.vcf
vcfanno config.toml COLO829/evaluate.R-output/gridss/colo829.gridss.truthset.vcf.gz > colo829.gridss.anno.vcf
vcfanno config.toml COLO829/evaluate.R-output/manta/colo829_1_manta_somaticSV.sort.vcf.gz > colo829.manta.1.anno.vcf
vcfanno config.toml COLO829/evaluate.R-output/manta/colo829_2_manta_somaticSV.sort.vcf.gz > colo829.manta.2.anno.vcf
vcfanno config.toml COLO829/evaluate.R-output/manta/colo829_3_manta_somaticSV.sort.vcf.gz > colo829.manta.3.anno.vcf
```

Upload to DNAnexus:

```
dx upload --path CleanSV:annotatedSVs/ *anno.vcf
```

Description:

```
gc content is there (gc) simple repeats (simple), microsatellites (microsat), repeatmasker (rmsk), selfchains, segmental duplications (segdups), nuclear mitochondrial dna (nuMT), interrupted repeats (interrputed), windowmasker + dustmasker (WmaskDmask)
##INFO=<ID=WmaskDmask,Number=1,Type=String,Description="calculated by self of overlapping values in column 4 from repeats/wmaskdmask.bed.gz">
##INFO=<ID=gc,Number=1,Type=Float,Description="calculated by mean of overlapping values in column 5 from repeats/hg19.gc5Base.bed.gz">
##INFO=<ID=interrupted,Number=1,Type=String,Description="calculated by self of overlapping values in column 4 from repeats/interrupted.bed.gz">
##INFO=<ID=nuMT,Number=1,Type=String,Description="calculated by self of overlapping values in column 4 from repeats/numt.bed.gz">
##INFO=<ID=rmsk,Number=1,Type=String,Description="calculated by self of overlapping values in column 4 from repeats/rmsk.bed.gz">
##INFO=<ID=segdups,Number=1,Type=String,Description="calculated by self of overlapping values in column 4 from repeats/segdups.bed.gz">
##INFO=<ID=selfchain,Number=1,Type=String,Description="calculated by self of overlapping values in column 4 from repeats/selfchain.bed.gz">
##INFO=<ID=simple,Number=1,Type=String,Description="calculated by self of overlapping values in column 4 from repeats/simple.bed.gz"
```
