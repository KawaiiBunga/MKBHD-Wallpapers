import os
import shutil

# Define the paths
base_folder = 'images'  # Path to the images folder
hd_folder = 'hd_images'       # Path to the folder for HD images
sd_folder = 'sd_images'       # Path to the folder for SD images

# Create the output directories if they do not exist
os.makedirs(hd_folder, exist_ok=True)
os.makedirs(sd_folder, exist_ok=True)

# Walk through the base folder
for root, dirs, files in os.walk(base_folder):
    # Get the folder name (the ID of the photo)
    folder_name = os.path.basename(root)

    for file in files:
        # Check for HD and SD image files
        if file == 'dhd.jpg':
            # Construct the full file path
            src_path = os.path.join(root, file)
            # Create a new filename with the folder name appended
            new_filename = f"{folder_name}_hd.jpg"
            # Move HD images to the hd_images folder
            shutil.move(src_path, os.path.join(hd_folder, new_filename))
            print(f'Moved HD image: {src_path} to {hd_folder}/{new_filename}')
        
        elif file == 'dsd.jpg':
            # Construct the full file path
            src_path = os.path.join(root, file)
            # Create a new filename with the folder name appended
            new_filename = f"{folder_name}_sd.jpg"
            # Move SD images to the sd_images folder
            shutil.move(src_path, os.path.join(sd_folder, new_filename))
            print(f'Moved SD image: {src_path} to {sd_folder}/{new_filename}')

print('Image separation complete.')
