# Creating a metafile from TCGA raw clinical data
A step-by-step workflow for generating meta files for TCGA omic data analysis. It will run only in R (tested on v4.1).

# Summary:
The clinical information of samples in TCGA is required to process the omics data for training machine learning models, performing differential expression analysis, survival rate analysis by integrated with genomic alterations, studying biological entities in multi-dimensions (multi-layer omics studies or multi-omics), and many more.

# Demonstration:
* Obtain a clinical file of head and neck cancer from TCGA using this link (http://gdac.broadinstitute.org/runs/stddata__2016_01_28/data/HNSC/20160128/gdac.broadinstitute.org_HNSC.Clinical_Pick_Tier1.Level_4.2016012800.0.0.tar.gz). 
* After downloading, unzip the file, go to the extracted directory, and look at "All_CDEs.txt" by opening it in a text editor (The data looks like stars in the sky).
* Open the script file (Preparing_meta_data_file.R) in R software (> v4.1). 
* Import the "All_CDEs.txt" file into R by setting the file path.
* Run!   

### Contact for any feedback
Email: salam.nurzai@gmail.com
