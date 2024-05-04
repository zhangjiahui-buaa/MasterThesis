import os
import shutil

# Source directory containing the files
source_dir = 'v8Compare2/corpus'

# Destination directory to copy the files
destination_dir = 'tmpCompare'

# Get a list of files in the source directory ending with "js"
files = [os.path.join(source_dir, filename) for filename in os.listdir(source_dir) if filename.endswith('.js')]
print(len(files))
# Sort files based on creation time in descending order (most recent first)
files.sort(key=os.path.getctime, reverse=True)

def is_string_in_file(file_path, search_string):
    try:
        # Open the file in read mode
        with open(file_path, 'r') as file:
            # Iterate through each line in the file
            for line in file:
                # Check if the search string is in the line
                if search_string in line:
                    return True
        # If the search string is not found in any line
        return False
    except FileNotFoundError:
        print("File not found.")
        return False
# Copy the 100 most recently created files to the destination directory
counter = 0
total = 1000
for file_path in files:
    if not is_string_in_file(file_path, "%OptimizeFunctionOnNextCall") and not is_string_in_file(file_path, "%OptimizeMaglevOnNextCall"):
        shutil.copy(file_path, destination_dir)
        counter += 1
        if counter == total:
            break