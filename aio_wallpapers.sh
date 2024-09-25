#!/bin/bash

# Create base directories for images
base_folder="images"
hd_folder="hd_images"
sd_folder="sd_images"

# Create the output directories if they do not exist
mkdir -p "$base_folder" "$hd_folder" "$sd_folder"

# Download images and save them into structured directories
curl -s https://storage.googleapis.com/panels-api/data/20240916/media-1a-i-p~s | jq -r '.data | to_entries[] | "\(.key) \(.value)"' | while read -r id data; do
  mkdir -p "$base_folder/$id"
  echo "$data" | jq -r 'to_entries[] | "\(.key) \(.value)"' | while read -r key url; do
    if [[ "$url" =~ ^https?:// ]]; then
      curl -s -o "$base_folder/$id/$key.jpg" "$url" &
    fi
  done
done

# Wait for all background downloads to finish
wait

# Move and rename images to their respective folders
for dir in "$base_folder"/*; do
  # Check if the directory exists and is a directory
  if [[ -d "$dir" ]]; then
    folder_name=$(basename "$dir")

    for file in "$dir"/*; do
      # Check if the file exists
      if [[ -f "$file" ]]; then
        filename=$(basename "$file")
        
        # Check for HD and SD image files
        if [[ "$filename" == "dhd.jpg" ]]; then
          # Construct the new filename for HD images
          new_filename="${folder_name}_hd.jpg"
          mv "$file" "$hd_folder/$new_filename"
          echo "Moved HD image: $file to $hd_folder/$new_filename"
        
        elif [[ "$filename" == "dsd.jpg" ]]; then
          # Construct the new filename for SD images
          new_filename="${folder_name}_sd.jpg"
          mv "$file" "$sd_folder/$new_filename"
          echo "Moved SD image: $file to $sd_folder/$new_filename"
        fi
      fi
    done
  fi
done

# Delete the base_folder and everything inside it
rm -rf "$base_folder"

echo 'Image separation complete and temporary files deleted.'
