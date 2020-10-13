First, download the BAMs and VCFs (we used DNAnexus download):

```
dx download cleanSV:COLO829/phased_possorted_bamCOLO829R.bam* -f
dx download cleanSV:COLO829/phased_possorted_bamCOLO829T.bam* -f
dx download cleanSV:COLO829/truthset_somaticSVs_COLO829.vcf -f
dx download cleanSV:HG002/HG002* -f
```

Next, download reference fasta for GRIDSS:

```
wget ftp://ftp.ensembl.org/pub/grch37/current/fasta/homo_sapiens/dna/Homo_sapiens.GRCh37.dna_sm.primary_assembly.fa.gz
gunzip Homo_sapiens.GRCh37.dna_sm.primary_assembly.fa.gz
samtools faidx Homo_sapiens.GRCh37.dna_sm.primary_assembly.fa
dx download cleanSV:/Homo_sapiens.GRCh37.GATK.illumina.fasta*
```

Run GRIDSS:

```
sudo docker run -d --memory 32g --cpu-shares=8 -v /home/dnanexus/:/data/ gridss/gridss --reference /data/hs37d5.fa --output /data/HG002.gridds.vcf --assembly /data/HG0002.gridss.assembly.bam --jvmheap 30gb --threads 8 /data/HG002.hs37d5.2x250.bam
sudo docker run -d --memory 32g --cpu-shares=8 -v /home/dnanexus/:/data/ gridss/gridss --reference /data/Homo_sapiens.GRCh37.GATK.illumina.fasta --output /data/COLO829R.gridss.vcf --assembly /data/COLO829R.gridss.assembly.bam --jvmheap 30g --threads 8 /data/COLO829R_dedup.realigned.bam /data/COLO829T_dedup.realigned.bam
```
