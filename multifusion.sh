#!/bin/bash

# Activate virtual environment
cd /Users/viviantian/Documents/GitHub/facefusion || exit
source venv/bin/activate

# Delete temporary files and directories
FACEFUSION_DIR="/tmp/facefusion"
if [ -d "$FACEFUSION_DIR" ]; then
  rm -rf "$FACEFUSION_DIR"/*
  echo "Deleted contents of $FACEFUSION_DIR"
  rm -rf /tmp/gradio/*
  echo "Deleted contents of gradio"
fi

[ -f run_log.txt ] && rm run_log.txt
SOURCE_TEMP_FILE="source_paths.txt"
[ -f "$SOURCE_TEMP_FILE" ] && rm "$SOURCE_TEMP_FILE"
TARGET_TEMP_FILE="target_paths.txt"
[ -f "$TARGET_TEMP_FILE" ] && rm "$TARGET_TEMP_FILE"

# Create new log file
echo "Log file created on $(date)" > run_log.txt
echo "" >> run_log.txt

# Define directories
batchDir="$(pwd)/"
source="${batchDir}source"
target="${batchDir}target"
OUTPUT_FOLDER="${batchDir}output"

# Write source file paths
for file in "$source"/*; do
  [ -f "$file" ] && echo "$file" >> "$SOURCE_TEMP_FILE"
done

# Write target file paths
for file in "$target"/*; do
  [ -f "$file" ] && echo "$file" >> "$TARGET_TEMP_FILE"
done

# Process combinations
while IFS= read -r source_path; do
  source_filename=$(basename "$source_path" | cut -d. -f1)
  while IFS= read -r target_path; do
    target_filename=$(basename "$target_path" | cut -d. -f1)
    output_file="${OUTPUT_FOLDER}/${source_filename}_${target_filename}.png"

    command="python3 facefusion.py headless-run -s \"$source_path\" -t \"$target_path\" -o \"$output_file\""
    echo "$command" >> run_log.txt
    echo "$command"
    eval "$command"
  done < "$TARGET_TEMP_FILE"
done < "$SOURCE_TEMP_FILE"


echo "Facefusion has ended. Commands logged to run_log.txt"
read -p "Press [Enter] to continue..."
