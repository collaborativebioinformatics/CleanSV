# CleanSV

## Please cite our work -- here is the ICMJE Standard Citation:

### ...and a link to the DOI:

## Awesome Logo

### You can make a free DOI with zenodo <link>

## Website (if applicable)

## Intro statement

## What's the problem?

Within clinical genomics, short-read sequencing is performed in order to inform/direct patient care. This has been immensely successful. 

For various Mendelian disorders, patients have their genomes sequenced to look for high-quality germline SNPs. 

Within precision oncology, tumors are sequenced for somatic variants in oncogenes/tumor suppressor genes. Based upon these variants, specific chemotherapies could be prescribed in order to target those malignant cells (e.g. inhibit them from growing further.)

Bioinformaticians will look at the calls within IGV in order to validate how accurate they are, and then send these reports to clinicians. 

Short-read calling of SVs is marred by high false positive call rates. There are few scalable methods to filter FPs. 

## Why should we solve it?

Access to SV calls from short-read sequencing with a lower false positive call rate would benefit both research and clinical analysis of Mendelian disorders or tumors. 

Having a higher quality SV call set would help reduce the time required to follow up candidate genes and help identify therapeutic targets in the research setting, and would help identify true pathogenic variants in the clinical diagnostic setting. 

Moreover, it would enhance the ability to detect somatic variation using subtraction methods which rely on germline and somatic sequencing data as input. With a lower false positive call rate, presumably fewer somatic variants would be called and a higher proportion would be true positive calls. 

# What is <this software>?

The major goals of this software are to: 

1: Provide researchers with empirically determined guidelines for SV filtering

2: Provide a visualization of false positive rates of current SV callers using 60 samples from the PCAWG dataset

3: Perform germline variant call filtering within the HG002 and HG003 datasets using filter criteria based on systematic issues identified in false positive call analysis. 

4: Provide a simple program to filter out obvious false positives using the identified criteria

# How to use <this software>

# Software Workflow Diagram

# File structure diagram 
#### _Define paths, variable names, etc_

# Installation options:

We provide two options for installing <this software>: Docker or directly from Github.

### Docker

The Docker image contains <this software> as well as a webserver and FTP server in case you want to deploy the FTP server. It does also contain a web server for testing the <this software> main website (but should only be used for debug purposes).

1. `docker pull ncbihackathons/<this software>` command to pull the image from the DockerHub
2. `docker run ncbihackathons/<this software>` Run the docker image from the master shell script
3. Edit the configuration files as below

### Installing <this software> from Github

1. `git clone https://github.com/NCBI-Hackathons/<this software>.git`
2. Edit the configuration files as below
3. `sh server/<this software>.sh` to test
4. Add cron job as required (to execute <this software>.sh script)

### Configuration

```Examples here```

# Testing

We tested four different tools with <this software>. They can be found in [server/tools/](server/tools/) . 

# Additional Functionality

### DockerFile

<this software> comes with a Dockerfile which can be used to build the Docker image.

  1. `git clone https://github.com/NCBI-Hackathons/<this software>.git`
  2. `cd server`
  3. `docker build --rm -t <this software>/<this software> .`
  4. `docker run -t -i <this software>/<this software>`
  
### Website

There is also a Docker image for hosting the main website. This should only be used for debug purposes.

  1. `git clone https://github.com/NCBI-Hackathons/<this software>.git`
  2. `cd Website`
  3. `docker build --rm -t <this software>/website .`
  4. `docker run -t -i <this software>/website`
  
