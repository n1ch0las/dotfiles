#!/bin/bash

files=(
    "$HOME/.config/i3/02-keybindings.conf"
    "$HOME/.config/i3/03-workspaces.conf"
)

tmp_json=$(mktemp)
echo '[]' > "$tmp_json"

current_section=""
bindings=()

flush_section() {
    if [[ -n "$current_section" ]]; then
        section_json=$(jq -n \
            --arg section "$current_section" \
            --argjson bindings "$(printf '%s\n' "${bindings[@]}" | jq -s .)" \
            '{section: $section, bindings: $bindings}')
        jq --argjson section "$section_json" '. += [$section]' "$tmp_json" > "$tmp_json.tmp" && mv "$tmp_json.tmp" "$tmp_json"
    fi
    bindings=()
}

for file in "${files[@]}"; do
    while IFS= read -r line || [[ -n "$line" ]]; do
        # Trim whitespace
        line="${line#"${line%%[![:space:]]*}"}"
        line="${line%"${line##*[![:space:]]}"}"

        [[ -z "$line" ]] && continue  # skip empty
        [[ "$line" =~ ^#\ ---\ (.+)\ --- ]] && { flush_section; current_section="${BASH_REMATCH[1]}"; continue; }
        [[ "$line" =~ ^# ]] && continue  # skip other comments

        if [[ "$line" =~ ^bindsym[[:space:]]+([^[:space:]]+)[[:space:]]+(.+) ]]; then
            key="${BASH_REMATCH[1]}"
            command="${BASH_REMATCH[2]}"
            bindings+=("$(jq -n --arg key "$key" --arg command "$command" '{key: $key, command: $command}')")
        fi
    done < "$file"
done

# Flush last section
flush_section

# Output
output_file="bindings.json"
cp "$tmp_json" "$output_file"
rm "$tmp_json"

echo "Structured JSON saved to $output_file"
echo
cat "$output_file"
