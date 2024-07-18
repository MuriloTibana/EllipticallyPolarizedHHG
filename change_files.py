import os
import glob
import shutil

base_path = 'results/*'

directories = [d for d in glob.glob(base_path) if os.path.isdir(d)]

for directory in directories:
    print(f"Directory: {directory}")
    
    directory_name_parts = directory.split("_")
    if len(directory_name_parts) > 1:
        directory_suffix = directory_name_parts[1]
        directory_suffix = directory_suffix.split(".")[0]
    else:
        directory_suffix = ''

    files_path = os.path.join(directory, '*')
    files = [f for f in glob.glob(files_path) if os.path.isfile(f)]
    
    for file in files:
        file_name = os.path.basename(file)
        if file_name.endswith('.txt'):
            new_file_name = file_name.replace('.txt', f'_{directory_suffix}.txt')
        else:
            file_name_part, file_extension = os.path.splitext(file_name)
            new_file_name = f"{file_name_part}_{directory_suffix}{file_extension}"
        
        new_file_path = os.path.join(directory, new_file_name)
        
        os.rename(file, new_file_path)
        print(f"Renamed {file} to {new_file_path}")

        subdirectories = [d for d in glob.glob(os.path.join(base_path, '*')) if os.path.isdir(d)]

for directory in subdirectories:
    files_path = os.path.join(directory, '*')
    files = glob.glob(files_path)
    
    for file in files:
        file_name = os.path.basename(file)
        target_file_path = os.path.join(target_path, file_name)
        shutil.move(file, target_file_path)
        print(f"Moved {file} to {target_file_path}")

for directory in subdirectories:
    os.rmdir(directory)
    print(f"Removed empty directory: {directory}")
