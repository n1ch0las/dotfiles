#!/usr/bin/env bash

INPUT_FILE="raw-bindings.json"         # original input
OUTPUT_FILE="cleaned-bindings.json"
TEMP_FILE=$(mktemp)

echo "[" > "$TEMP_FILE"
NUM_SECTIONS=$(jq length "$INPUT_FILE")

for (( i=0; i<NUM_SECTIONS; i++ )); do
  SECTION_NAME=$(jq -r ".[$i].section" "$INPUT_FILE")
  echo "Section: $SECTION_NAME"
  read -p "Keep section? [y/n/e=edit] " sec_choice

  if [[ "$sec_choice" == "n" ]]; then
    continue
  elif [[ "$sec_choice" == "e" ]]; then
    read -p "Enter new section name: " SECTION_NAME
  fi

  echo "  { \"section\": \"${SECTION_NAME}\", \"bindings\": [" >> "$TEMP_FILE"

  NUM_BINDINGS=$(jq ".[$i].bindings | length" "$INPUT_FILE")
  first_binding=true
  for (( j=0; j<NUM_BINDINGS; j++ )); do
    KEY=$(jq -r ".[$i].bindings[$j].key" "$INPUT_FILE")
    CMD=$(jq -r ".[$i].bindings[$j].command" "$INPUT_FILE")

    echo "  Binding: \"$KEY\" -> \"$CMD\""
    read -p "    Keep binding? [y/n/e=edit] " bind_choice

    if [[ "$bind_choice" == "n" ]]; then
      continue
    elif [[ "$bind_choice" == "e" ]]; then
      # Ask if the user wants to edit the key and/or command
      read -p "    Edit key? [y/n]: " edit_key
      if [[ "$edit_key" == "y" ]]; then
        read -p "    New key: " KEY
      fi

      read -p "    Edit command? [y/n]: " edit_cmd
      if [[ "$edit_cmd" == "y" ]]; then
        read -p "    New command: " CMD
      fi
    fi

    # Add binding to the temporary file
    if [ "$first_binding" = false ]; then
      echo "," >> "$TEMP_FILE"
    fi
    first_binding=false

    echo -n "    { \"key\": \"$KEY\", \"command\": \"$CMD\" }" >> "$TEMP_FILE"
  done

  echo -e "\n  ]}," >> "$TEMP_FILE"
done

# Clean up trailing comma and close the JSON array
sed '$ s/},/}/' "$TEMP_FILE" > "$OUTPUT_FILE"
echo "]" >> "$OUTPUT_FILE"

rm "$TEMP_FILE"
echo "Cleaned JSON written to $OUTPUT_FILE"
echo
cat "$OUTPUT_FILE"
