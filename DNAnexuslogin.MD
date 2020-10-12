First things first, on your Mac/Linux box (or docker/WSL for Windows):

```
pip install dxpy
dx upgrade
dx login
```

Then on `dx login`:

`dx ssh-config`

Click Enter and choose the defaults, worked for me.

Then:

`dx select cleanSV`
`dx run app-cloud_workstation --ssh`

To get access to the files we uploaded to the DNAnexus platform:

```
unset DX_WORKSPACE_ID
dx cd $DX_PROJECT_CONTEXT_ID:
```

Run `dx ls` and you'll see the sample `.bam` data I downloaded from the Platinum Genomes data for HG002 chr20 earlier in the `samplottest` folder.

