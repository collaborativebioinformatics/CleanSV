After following the steps in [DNAnexuslogin.MD](DNAnexuslogin.MD):
```
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh
```

This installs miniconda3 to install samplot and necessary Python packages.  While we can use docker by default, miniconda is pretty easy for this.

Then:

```
conda config --add channels defaults
conda config --add channels bioconda
conda config --add channels conda-forge
```

Install `samplot` and `tabix`:

`conda install -c bioconda samplot`
`conda install -c bioconda samtools=1.11`

Download the sample `.bam` I uploaded:

```
dx download cleanSV:samplottest/HG002.hs37d5.300x_chr20.bam
dx download samplottest/HG002_SVs_Tier1_v0.6.vcf.gz*
```

Index the `.bam`:

`samtools index HG002.hs37d5.300x_chr20.bam`

Now, to run `samplot`:

```
samplot plot \
    -n HG002 \
    -b HG002.hs37d5.300x_chr20.bam \
    -o 20_622510-6230640.png \
    -c chr20 \
    -s 622510 \
    -e 623064 \
    -t DEL
```

Upload the result with:

`dx upload 20_622510-6230640.png`

To investigate the reads on the command line (http://oliverelliott.org/article/bioinformatics/wik_bioinform/10/):

```
samtools view -b HG002.hs37d5.300x_chr20.bam 20:622510-623064 > test.bam
samtools index test.bam
samtools tview test.bam
/ 20:622510
```

Samplot image looks like:
![image](https://user-images.githubusercontent.com/6568964/95706384-b8941300-0c24-11eb-89ec-e583ac04b312.png)

