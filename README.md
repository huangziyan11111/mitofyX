## mitofyX
mitofyX is a fork of mitofy (Alverson et al. 2010), a plant mitochondrial annotation tool written in perl. 
The purpose of this fork is to simplify the installation of mitofy and maybe add some functionalities.

## [Original mitofy](http://dogma.ccbb.utexas.edu/mitofy/)

The original source code and documentation of mitofy can be found here ==> http://dogma.ccbb.utexas.edu/mitofy/. [The original documentation](http://dogma.ccbb.utexas.edu/mitofy/README.pdf) is still relevant and all changes in the software usage are listed here. 

If you use mitofy/mitofyX, please remember to cite the original publication: 

    @article{doi:10.1093/molbev/msq029,
    author = {Alverson, Andrew J. and Wei, XiaoXin and Rice, Danny W. and Stern, David B. and Barry, Kerrie and Palmer, Jeffrey D.},
    title = {Insights into the Evolution of Mitochondrial Genome Size from Complete Sequences of Citrullus lanatus and Cucurbita pepo (Cucurbitaceae)},
    journal = {Molecular Biology and Evolution},
    volume = {27},
    number = {6},
    pages = {1436-1448},
    year = {2010},
    doi = {10.1093/molbev/msq029},
    URL = { + http://dx.doi.org/10.1093/molbev/msq029},
    eprint = {/oup/backfile/content_public/journal/mbe/27/6/10.1093_molbev_msq029/2/msq029.pdf}
    }

## Usage 
```
usage:./mitofyX.pl [options] genome.fasta projectID
      projectID = unique project name; all output files with have this prefix

options
      --prot_emax - maximum BLAST expect value for protein genes (default: 1e-3)
      --prot_pmin - minimum percent identity for protein genes (default: 60)
      --rna_emax  - maximum BLAST expect value for RNA genes (default: 1e-3)
      --rna_pmin  - minimum percent identity for RNA genes (default: 70)
      --rna_mlen  - minimum length for RNA BLASTN matches (default: 30)
      --outdir    - output directory in which results should be saved (default: blast_output)
      --gene_db   - Path to the folder with the mitochondrial gene database (amino acid sequences). (default: blast_dbs/mt_genes)
      --rna_db    - Path to the folder with the mitochondrial ncRNA database. (default: blast_dbs/mt_rna)
      --build_db  - Flag to add if the database should be rebuild. This will be automatically set to True if the 'formatdb.log' file is missing in the gene sub-directory
      --port      - Port to listen to for manual annotation in browser using a cgi-server. Only set it if it really necessary (default: 8000)
```

## List of changes
  - It is now possible to use your own sequence database (built with formatdb) with mitofyX. Please see the new options `--rna_db` and `--gene_db`. This was added since several genes were missed during annotation of some green algae mitochondrial genomes.
  - You can now specify the output directory. See `--outdir`
  - The __blast__ and __tRNAscan-SE__ binaries provided with mitofy were removed, as they were not always compatible with the os. They should be installed before __mitofy__ now.
  - Link to the gene summary and rna summary file were added in each summary file
  - Manual annotation in browser does not require to set up a webserver with apache anymore. Instead a simple server using CGIHTTPServer is python is used know.  To start the server, please run the script `start_server.py` in the main folder. You should use the same port you used when running __mitofyX__. By default the port is set to 8000
  - Manual annotations are saved in the "annotated/$project"

## To do
  - Remove all unused argument in mitofy 
  - Either Dump blast for tRNA search and use it only for other ncRNA search + maybe another tool Or make tRNAScan-SE and blast output more consistent (put all possible tRNA sequence for a specific amino acid in the same folder, with a consistent seqID)
  
  
