#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <input_folder> <output_folder>"
    exit 1
fi

INPUT_DIR="$1"
OUTPUT_DIR="$2"

clear
make clean
make

mkdir -p "$OUTPUT_DIR"

for file in "$INPUT_DIR"/*.txt; do
    filename=$(basename "$file" .txt)
    output_file="$OUTPUT_DIR/${filename}.json"
    # echo "Processing $file -> $output_file"
    ./parser "$file" "$output_file"
done