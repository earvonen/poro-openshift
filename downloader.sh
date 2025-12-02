#!/usr/bin/env bash
set -euo pipefail

# Base URL for raw file downloads
# NOTE! Change LumioOpen/Llama-Poro-2-70B-Instruct to match with your chosen model.
BASE_URL="https://huggingface.co/LumiOpen/Llama-Poro-2-70B-Instruct/resolve/main"

# List of files to download
declare -a FILES=(
  # Model shards
)

# Add model shard filenames
# NOTE! Change the number 30 on the following 2 rows to the number of safetensors files the model has
for i in $(seq -f "%05g" 1 30); do
  FILES+=( "model-$(printf "%05g" "${i}")-of-00030.safetensors" )
done

# Index file
FILES+=( "model.safetensors.index.json" )

# Other metadata/configuration files
FILES+=( ".gitattributes" "all_results.json" "config.json" "generation_config.json" "special_tokens_map.json" "tokenizer.json" "tokenizer_config.json" )

# Download loop
echo "Starting download of ${#FILES[@]} files to $(pwd)..."

for fname in "${FILES[@]}"; do
  url="$BASE_URL/$fname"
  echo "Downloading $fname ..."
  curl --fail --location --progress-bar --output "$fname" "$url"
done

echo "All files downloaded successfully."
