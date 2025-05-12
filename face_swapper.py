import os
import subprocess

# Path to the root folder and virtual environment
base_path = '/Users/viviantian/Documents/GitHub/facefusion'  # Modify this path accordingly
venv_activate = os.path.join(base_path, 'venv/bin/activate')

# Use environment activation and run command through a shell script
def run_command_in_venv(command):
    full_cmd = f'source "{venv_activate}" && cd "{base_path}" && {command}'
    subprocess.run(['/bin/bash', '-c', full_cmd], check=True)

# Folder paths
source_path = os.path.join(base_path, 'source')
target_path = os.path.join(base_path, 'target')
output_path = os.path.join(base_path, 'output')

# List of files in the 'source' folder
source_files = [f for f in os.listdir(source_path) if f.endswith((".png", ".jpg", ".jpeg"))]

# List of files in the 'target' folder
target_files = [f for f in os.listdir(target_path) if f.endswith((".png", ".jpg", ".jpeg"))]

# Check if there are files in both 'source' and 'target'
if source_files and target_files:
    source_file = source_files[0]
    for target_file in target_files:
        command_line = f'python run.py -s "{os.path.join(source_path, source_file)}" -t "{os.path.join(target_path, target_file)}" -o "{output_path}" --headless --frame-processor face_swapper face_enhancer --face-enhancer-model gfpgan_1.4'
        run_command_in_venv(command_line)
else:
    print("There are not enough files in the 'source' or 'target' folders.")
