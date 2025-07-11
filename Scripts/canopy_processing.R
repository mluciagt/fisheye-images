#!/usr/bin/env Rscript

library("pacman")

pacman::p_load(hemispheR, # For canopy fish-eye images processing
               dplyr, # For grammar, data manipulation
               terra, # For geographic (spatial) data manipulation
               magick, # For image manipulation
               exifr) # For extracting metadata

require(hemispheR)

# image_folder <- "FisheyeJPEG"

# if this script is runed with a bash command, it should be used as fallow
# Rscript canopy_processing.R /NameofImageFolder/ /NameofOutputFolder/
args <- commandArgs(trailingOnly = TRUE)
image_folder <- args[1]
output_file <- args[2]

# create a list object with name of paths to all images to process
image_files <- list.files(image_folder, pattern = "\\.jpg$", full.names = TRUE)

#create an empty table before entering the loop
combined_report <- tibble()

# Loop across all images and append the outpout to the combined_report
for (file in image_files) {
  #### One command ####
  canopy_report <- file %>%
    import_fisheye(
      channel = 3,
      circ.mask = list(xc = 1890, yc = 1512, rc = 1510),
      circular = TRUE,
      gamma = 2.2,
      stretch = FALSE,
      display = FALSE,
      message = TRUE
    ) %>%
    binarize_fisheye(
      method = 'Otsu',
      zonal = FALSE,
      manual = NULL,
      display = FALSE,
      export = FALSE
    ) %>%
    gapfrac_fisheye(
      maxVZA = 90,
      lens = "equidistant",
      startVZA = 0,
      endVZA = 90,
      nrings = 5,
      nseg = 8,
      display = FALSE,
      message = TRUE
    ) %>%
    canopy_fisheye() 
       # %>% rename(PhotoID = id) # if id variable name is different in your data
  # uptade the master report with new row
  combined_report <- bind_rows(combined_report, canopy_report)
  print(paste(file, "finished processing"))
}

#### save output report as a csv or text table ####
library(readr)
write_csv(combined_report, paste0(output_file, ".csv"))
write_tsv(combined_report, paste0(output_file, ".tsv"))






  