First, download the BAMs and VCFs (we used DNAnexus download):

```
dx download cleanSV:COLO829/COLO829R_dedup.realigned.bam* -f
dx download cleanSV:COLO829/COLO829T_dedup.realigned.bam* -f
dx download cleanSV:COLO829/truthset_somaticSVs_COLO829.vcf -f
dx download cleanSV:HG002/HG002* -f
```

Next, download reference fasta for GRIDSS for COLO829:

```
wget ftp://ftp.ensembl.org/pub/grch37/current/fasta/homo_sapiens/dna/Homo_sapiens.GRCh37.dna_sm.primary_assembly.fa.gz
dx download cleanSV:/Homo_sapiens.GRCh37.GATK.illumina.fasta*
gunzip Homo_sapiens.GRCh37.dna_sm.primary_assembly.fa.gz
samtools faidx Homo_sapiens.GRCh37.dna_sm.primary_assembly.fa
```

Next, download reference fasta for GRIDSS for HG002:

```
wget ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/technical/reference/phase2_reference_assembly_sequence/hs37d5.fa.gz
dx download cleanSV:hs37d5.fa.gz
gunzip hs37d5.fa.gz
samtools faidx hs37d5.fa.gz

```

Run GRIDSS:

```
sudo docker run -d --memory 32g --cpu-shares=8 -v /home/dnanexus/:/data/ gridss/gridss --reference /data/hs37d5.fa --output /data/HG002.gridds.vcf --assembly /data/HG0002.gridss.assembly.bam --jvmheap 30gb --threads 8 /data/HG002.hs37d5.2x250.bam
sudo docker run -d --memory 32g --cpu-shares=8 -v /home/dnanexus/:/data/ gridss/gridss --reference /data/Homo_sapiens.GRCh37.GATK.illumina.fasta --output /data/COLO829R.gridss.vcf --assembly /data/COLO829R.gridss.assembly.bam --jvmheap 30g --threads 8 /data/COLO829R_dedup.realigned.bam /data/COLO829T_dedup.realigned.bam
```
