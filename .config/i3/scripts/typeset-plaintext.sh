#!/bin/bash

# Configuration
INPUT_JSON="./cleaned_bindings.json"
OUTPUT_FILE="typeset_bindings.txt"
KEY_WIDTH=25            # Width for key within each column
COMMAND_WIDTH=30        # Width for command within each column
COLUMN_SPACING=4        # Space between columns

# Derived total width
COLUMN_WIDTH=$((KEY_WIDTH + 2 + COMMAND_WIDTH))  # ' → ' is 2 chars
TOTAL_WIDTH=$((COLUMN_WIDTH * 2 + COLUMN_SPACING))

# Check if input file exists
if [[ ! -f "$INPUT_JSON" ]]; then
  echo "Error: $INPUT_JSON not found!"
  exit 1
fi

# Read JSON
json=$(cat "$INPUT_JSON")

# Start with an empty output file
> "$OUTPUT_FILE"

# Function to pad and print two-column layout
print_two_column_layout() {
  local -n _array=$1  # Pass array by name
  local title="$2"

  echo "$title" >> "$OUTPUT_FILE"
  printf "%0.s-" $(seq 1 $TOTAL_WIDTH) >> "$OUTPUT_FILE"
  echo >> "$OUTPUT_FILE"

  local total=${#_array[@]}
  local half=$(( (total + 1) / 2 ))

  for ((i = 0; i < half; i++)); do
    IFS=$'\t' read -r key1 cmd1 <<< "${_array[i]}"
    IFS=$'\t' read -r key2 cmd2 <<< "${_array[i + half]:-	}"  # Tab fallback for blank

    # Format both columns
    col1=$(printf "%-${KEY_WIDTH}s %-${COMMAND_WIDTH}s" "$key1" "$cmd1")
    col2=$(printf "%-${KEY_WIDTH}s %-${COMMAND_WIDTH}s" "$key2" "$cmd2")
    printf "%s%s%s\n" "$col1" "$(printf '%*s' "$COLUMN_SPACING")" "$col2" >> "$OUTPUT_FILE"
  done

  echo >> "$OUTPUT_FILE"
}

# Loop through each section
for section in $(echo "$json" | jq -r '.[] | @base64'); do
  section_decoded=$(echo "$section" | base64 --decode)
  section_name=$(echo "$section_decoded" | jq -r '.section')
  bindings=$(echo "$section_decoded" | jq -c '.bindings')

  # Create formatted lines with tab-separated key + command
  mapfile -t formatted_lines < <(
    echo "$bindings" | jq -r '.[] | "\(.key)\t\(.command)"'
  )

  print_two_column_layout formatted_lines "$section_name"
done

echo "Formatted keybindings written to '$OUTPUT_FILE'."
