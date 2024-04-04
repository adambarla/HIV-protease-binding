#!/bin/bash

# Usage: ./script.sh receptor ligand_folder output_folder config 

RECEPTOR="$1"
INPUT_DIR="$2"
OUTPUT_DIR="$3"
CONFIG_FILE="$4"

# Check if input, output directories and config file were provided
if [ -z "$RECEPTOR" ] || [ -z "$INPUT_DIR" ] || [ -z "$OUTPUT_DIR" ] || [ -z "$CONFIG_FILE" ]; then
  echo "Usage: $0 receptor /input/folder /output/folder config"
  exit 1
fi

# Create output directory if it does not exist
mkdir -p "$OUTPUT_DIR"

# Loop through all .pdbqt files in the input directory
for FILE in "$INPUT_DIR"/*.pdbqt; do
  FILENAME=$(basename "$FILE")
  qvina2 --config "$CONFIG_FILE" --receptor "$RECEPTOR" --ligand "$FILE" --out "$OUTPUT_DIR/${FILENAME%.pdbqt}_out.pdbqt"
done
