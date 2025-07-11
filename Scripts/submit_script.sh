#!/bin/bash

# This script sets up the environment, installs R packages, and runs the canopy_processing.R script
# Usage: ./run_canopy_processing.sh /path/to/input_folder /path/to/output_file.csv

#####################
# Load Modules
#####################
module load StdEnv/2023
module load gcc/12.3 r/4.4.0
module load udunits
module load gdal

#####################
# Set up personal R library
#####################
mkdir -p ~/.local/R/
export R_LIBS=~/.local/R/

#####################
# Install required R package if not already installed
#####################
Rscript -e 'if (!require("hemispheR")) install.packages("hemispheR", lib = "~/.local/R/", repos = "https://cloud.r-project.org")'

#####################
# Run the R script with input and output arguments
#####################
INPUT_FOLDER=$1
OUTPUT_FILE=$2

if [[ -z "$INPUT_FOLDER" || -z "$OUTPUT_FILE" ]]; then
  echo "Usage: $0 /path/to/input_folder /path/to/output_file.csv"
  exit 1
fi

Rscript canopy_processing.R "$INPUT_FOLDER" "$OUTPUT_FILE"

#####################
# Output message
#####################
echo "*** End of the script canopy_processing.R with images from folder '$INPUT_FOLDER' ***"
