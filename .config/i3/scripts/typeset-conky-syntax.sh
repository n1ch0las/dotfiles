#!/bin/bash

# Configuration
INPUT_JSON="./cleaned_bindings.json"
OUTPUT_FILE="test.txt"
KEY_WIDTH=25
COMMAND_WIDTH=30
COLUMN_SPACING=4

# Total width without arrow
COLUMN_WIDTH=$((KEY_WIDTH + COMMAND_WIDTH))
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
  local array_name="$1"
  local title="$2"
  local -n lines_ref="${array_name}" 2>/dev/null || eval "lines_ref=(\"\${$array_name[@]}\")"

  echo -e "\n\${color white}${title}" >> "$OUTPUT_FILE"
  echo '${hr}' >> "$OUTPUT_FILE"

  local total=${#lines_ref[@]}
  local half=$(( (total + 1) / 2 ))

  for ((i = 0; i < half; i++)); do
    IFS=$'\t' read -r key1 cmd1 <<< "${lines_ref[i]}"
    IFS=$'\t' read -r key2 cmd2 <<< "${lines_ref[i + half]:-	}"

    col1="\${color grey}$(printf "%-${KEY_WIDTH}s" "$key1")\${color white} $(printf "%-${COMMAND_WIDTH}s" "$cmd1")"
    col2="\${color grey}$(printf "%-${KEY_WIDTH}s" "$key2")\${color white} $(printf "%-${COMMAND_WIDTH}s" "$cmd2")"
    printf "%s%*s%s\n" "$col1" "$COLUMN_SPACING" "" "$col2" >> "$OUTPUT_FILE"
  done

 # echo >> "$OUTPUT_FILE"
}

# Loop through each section
for section in $(echo "$json" | jq -r '.[] | @base64'); do
  section_decoded=$(echo "$section" | base64 --decode)
  section_name=$(echo "$section_decoded" | jq -r '.section')
  bindings=$(echo "$section_decoded" | jq -c '.bindings')

  mapfile -t formatted_lines < <(
    echo "$bindings" | jq -r '.[] | "\(.key)\t\(.command)"'
  )

  print_two_column_layout formatted_lines "$section_name"
done

echo "Formatted keybindings written to '$OUTPUT_FILE'."
