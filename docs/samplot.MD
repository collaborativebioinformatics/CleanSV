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
`conda install -c bioconda samtools`

Now, to run `samplot`:

