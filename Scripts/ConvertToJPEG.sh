#!/bin/bash

# Description: from a folder containing .heic images
# - convert the images to jpeg format in a sister folder
# Usage ConvertToJPEG <input_folder>

# Assign variable name to argument position
input_folder="$1" 
output_folder="${input_folder}JPEG" 

# Create output folder if not already existing
mkdir -p "$output_folder"

# Loop through all .heic files
for file in "$input_folder"/*.heic; do
  # Get filename without extension
  filename=$(basename "${file%.*}")

  # Convert to jpeg
  sips -s format jpeg "$file" --out "${output_folder}/${filename}.jpg"

  echo "Converted $file to ${output_folder}/${filename}.jpg"
done
