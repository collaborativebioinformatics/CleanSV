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
```

Run GRIDSS:

```
sudo docker run -exec -it gridss/gridss --reference Homo_sapiens.GRCh37.dna_sm.primary_assembly.fa --assembly phased_possorted_bamCOLO829R.bam --threads 32
```
