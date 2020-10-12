First things first, on your Mac/Linux box (or docker/WSL for Windows):

```
pip install dxpy
dx upgrade
dx login
```

Then on `dx login`:

`dx ssh-config`

Give the creator of the instance the ssh key and place into `~/.ssh/authorized_keys` file.

To create an instance with 30 GB ram (per) 320 GB storage, 16 cores:

`dx run app-cloud_workstation --ssh --instance-type │mem1_ssd1_x16`

Type `0`, and write `24h` for 24hr job run.

Type Enter and choose the other defaults, worked for me.

Then:

`dx select cleanSV`

To get access to the files we uploaded to the DNAnexus platform:

```
unset DX_WORKSPACE_ID
dx cd $DX_PROJECT_CONTEXT_ID:
```

Run `dx ls` and you'll see the sample `.bam` data I downloaded from the Platinum Genomes data for HG002 chr20 earlier in the `samplottest` folder.
