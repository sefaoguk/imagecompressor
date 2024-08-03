#!/bin/bash

# Default quality value
QUALITY=65

# Function to convert sizes to a human-readable format
format_size() {
  local SIZE=$1
  if [ "$SIZE" -ge 1073741824 ]; then
    echo "$(echo "scale=2; $SIZE/1073741824" | bc) GB"
  elif [ "$SIZE" -ge 1048576 ]; then
    echo "$(echo "scale=2; $SIZE/1048576" | bc) MB"
  elif [ "$SIZE" -ge 1024 ]; then
    echo "$(echo "scale=2; $SIZE/1024" | bc) KB"
  else
    echo "${SIZE} B"
  fi
}

# Function to calculate savings percentage
calculate_savings() {
  local BEFORE_SIZE=$1
  local AFTER_SIZE=$2
  if [ "$BEFORE_SIZE" -eq 0 ]; then
    echo "0.00"
  else
    echo "$(echo "scale=2; (1 - $AFTER_SIZE / $BEFORE_SIZE) * 100" | bc)"
  fi
}

# Parse command line options
while getopts ":q:" opt; do
  case ${opt} in
    q )
      QUALITY=$OPTARG
      ;;
    \? )
      echo "Invalid option: -$OPTARG" 1>&2
      exit 1
      ;;
    : )
      echo "Invalid option: -$OPTARG requires an argument" 1>&2
      exit 1
      ;;
  esac
done
shift $((OPTIND -1))

# Check for at least one directory argument
if [ "$#" -lt 1 ]; then
  echo "Usage: $0 [-q quality] <directory1> [<directory2> ... <directoryN>]"
  exit 1
fi

# Check if 'bc' is installed
if ! command -v bc &> /dev/null; then
  echo "Error: 'bc' command not found. Please install 'bc'."
  exit 1
fi

# Process each directory
for DIRECTORY in "$@"; do
  if [ ! -d "$DIRECTORY" ]; then
    echo "Error: '$DIRECTORY' is not a directory."
    continue
  fi

  echo -e "\nProcessing Directory: $DIRECTORY"

  # Temporary file
  TEMP_FILE=$(mktemp)

  # Total file count
  TOTAL_FILES=$(find "$DIRECTORY" -type f \( -name "*.png" -o -name "*.jpeg" -o -name "*.jpg" -o -name "*.webp" \) | wc -l)

  # Directory size before processing
  if [ "$(uname)" == "Darwin" ]; then
    # macOS
    BEFORE_SIZE_BYTES=$(find "$DIRECTORY" -type f -exec stat -f%z {} + | awk '{s+=$1} END {print s}')
  else
    # Linux
    BEFORE_SIZE_BYTES=$(find "$DIRECTORY" -type f -exec stat -c%s {} + | awk '{s+=$1} END {print s}')
  fi
  BEFORE_SIZE=$(format_size "$BEFORE_SIZE_BYTES")

  # Print headers
  printf "%-30s %-15s %-15s %-10s\n" "File Name" "Before Size" "After Size" "Savings"

  # Process files and print sizes
  find "$DIRECTORY" -type f \( -name "*.png" -o -name "*.jpeg" -o -name "*.jpg" -o -name "*.webp" \) | while read -r FILE; do
    # File size before
    if [ "$(uname)" == "Darwin" ]; then
      # macOS
      BEFORE_SIZE_BYTES=$(stat -f%z "$FILE")
    else
      # Linux
      BEFORE_SIZE_BYTES=$(stat -c%s "$FILE")
    fi
    BEFORE_SIZE_FORMATTED=$(format_size "$BEFORE_SIZE_BYTES")
    
    # Compress file
    magick "$FILE" -quality $QUALITY "$FILE"
    
    # File size after
    if [ "$(uname)" == "Darwin" ]; then
      # macOS
      AFTER_SIZE_BYTES=$(stat -f%z "$FILE")
    else
      # Linux
      AFTER_SIZE_BYTES=$(stat -c%s "$FILE")
    fi
    AFTER_SIZE_FORMATTED=$(format_size "$AFTER_SIZE_BYTES")
    
    # Calculate savings percentage
    SAVINGS_PERCENT=$(calculate_savings "$BEFORE_SIZE_BYTES" "$AFTER_SIZE_BYTES")
    
    # Print results
    printf "%-30s %-15s %-15s %-10s\n" "$(basename "$FILE")" "$BEFORE_SIZE_FORMATTED" "$AFTER_SIZE_FORMATTED" "$SAVINGS_PERCENT%"
  done > "$TEMP_FILE"

  # Directory size after processing
  if [ "$(uname)" == "Darwin" ]; then
    # macOS
    AFTER_SIZE_BYTES=$(find "$DIRECTORY" -type f -exec stat -f%z {} + | awk '{s+=$1} END {print s}')
  else
    # Linux
    AFTER_SIZE_BYTES=$(find "$DIRECTORY" -type f -exec stat -c%s {} + | awk '{s+=$1} END {print s}')
  fi
  AFTER_SIZE=$(format_size "$AFTER_SIZE_BYTES")

  # Print results
  cat "$TEMP_FILE"
  rm "$TEMP_FILE"

  echo -e "\n**********************************************"
  echo -e "Total file count: $TOTAL_FILES"
  echo -e "Directory size before: $BEFORE_SIZE"
  echo -e "Directory size after: $AFTER_SIZE"
  echo -e "Total savings: $(calculate_savings "$BEFORE_SIZE_BYTES" "$AFTER_SIZE_BYTES")%"
  echo -e "Quality used: $QUALITY"
  echo "**********************************************"
done

