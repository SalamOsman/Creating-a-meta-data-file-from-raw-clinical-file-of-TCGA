# Loading the required library
library(tidyverse)

# Importing the clinical file for the directory. 
Clinical_file <- read.table("C:/Users/User_name/Desktop/GitHub/HNSCC_DEGs/All_CDEs.txt",
                            row.names = 1, sep = "\t", quote = "\'", header = F,
                            fill = TRUE)

# Viewing the diminesion of the dataframe.
dim(Clinical_file)

# Transposing the data frame of Clinical_file.
Clinical_file <- t(Clinical_file)
Clinical_file <- as.data.frame(Clinical_file)
dim(Clinical_file)

# Selection of column numbers that you are interested to study i.e. ids, age, gender, staging and antomic site columns form the dataframe.
meta_data <- Clinical_file %>% select(1, 10, 13, 47, 83)
head(meta_data)

# Replacing the column names with the short names
meta_data <- meta_data %>% rename(IDs = bcr_patient_barcode, 
                                  Age = age_at_initial_pathologic_diagnosis,
                                  Anatomic_site = anatomic_neoplasm_subdivision,
                                  Gender = gender, Stage = pathologic_stage)

# Conversion of IDs column to from factor to characters  
meta_data <- as.tibble(meta_data)
meta_data$IDs <- as.character(meta_data$IDs)
names(meta_data)

# Preparing IDs column of meta_data dataframe.
meta_data$IDs = toupper(meta_data$IDs)

# Now import the raw count file and extract information form the meta_data dataframe. 
rawCounts <- read.table("C:/Users/User_name/Desktop/GitHub/HNSCC_DEGs/HNSC.mRNAseq_raw_counts.txt", 
                        row.names = 1, sep = "\t", quote = "\'", header = F)
dim(rawCounts)

# Extracting column names data from the meta_data dataframe
screen_list <- rawCounts[1, ]
screen_list <- t(screen_list)
screen_list <- as.tibble(screen_list)
screen_list <- screen_list %>% rename(IDs = `HYBRIDIZATION R`)

# Preparing the IDs column names to match against the meta_data dataframe.
screen_list$Sample_type <- gsub('([0-9])([0-9])(.01)', 'HNSCC', screen_list$IDs)
screen_list$Sample_type <- gsub('(([A-Z][A-Z])([A-Z][A-Z])(.)([A-Z][A-Z])(.)([0-9])([0-9]))HNSCC', 'HNSCC', screen_list$Sample_type)
screen_list$Sample_type <- gsub('(([A-Z][A-Z])([A-Z][A-Z])(.)([A-Z][0-9])(.)([0-9])([0-9]))HNSCC', 'HNSCC', screen_list$Sample_type)
screen_list$Sample_type <- gsub('(([0-9])([0-9])(.)(.11))', 'Normal', screen_list$Sample_type)
screen_list$Sample_type <- gsub('(([A-Z][A-Z])([A-Z][A-Z])(.)([A-Z][A-Z])(.)([0-9]))Normal', 'Normal', screen_list$Sample_type)
screen_list$Sample_type <- gsub('(([A-Z][A-Z])([A-Z][A-Z])(.)([A-Z][0-9])(.)([0-9]))Normal', 'Normal', screen_list$Sample_type)

# Now screening and joining the two dataframes together.
screen_list$IDs <- gsub('([0-9])(.01)', '\\1', screen_list$IDs)
screen_list$IDs <- gsub('([0-9])(.11)', '\\1', screen_list$IDs)
meta_data <- dplyr::inner_join(meta_data, screen_list, by="IDs")
meta_data$Stage[which(meta_data$Sample_type == "Normal")] <- NA

# Editing the IDs column to match the corresponding raw reads in the file.
meta_data <- meta_data %>% 
  mutate(IDs_code = case_when(endsWith(Sample_type, "C") ~ 
                                "-01", endsWith(Sample_type, "l") ~ "-11"))
meta_data <- unite(meta_data, IDs, c(IDs, IDs_code), remove=FALSE, sep = "")

# Writing the dataframe as a table in a local repository.
write.table(meta_data[1:6], "C:/Users/User_name/Desktop/GitHub/HNSCC_DEGs/meta_data.txt",
            sep = "\t", row.names = F, quote = F)





