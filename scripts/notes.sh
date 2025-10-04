#!/usr/bin/env bash
set -euo pipefail

# Where your notes live
NOTES_DIR="$HOME/Sync/Work Notes"

# Editor + terminal (adjust if you like)
EDITOR_CMD=(hx)
TERMINAL="${TERMINAL:-alacritty}"

rofi_pick() {
  rofi -dmenu -i -p "$1"
}

main_menu() {
  printf '%s\n' "Open TODO.md" "New note" | rofi_pick "Work notes:  "
}

open_todo() {
  if [ ! -d "$NOTES_DIR" ]; then
    echo "Error: Notes directory does not exist: $NOTES_DIR" >&2
    exit 1
  fi

  setsid -f "$TERMINAL" -e "${EDITOR_CMD[@]}" "$NOTES_DIR/TODO.md" >/dev/null 2>&1
}

select_template() {
  printf '%s\n' "Meeting" "Quick Note" "New Idea" | rofi_pick "Template type:  "
}

new_note() {
  if [ ! -d "$NOTES_DIR" ]; then
    echo "Error: Notes directory does not exist: $NOTES_DIR" >&2
    exit 1
  fi

  template="$(select_template)" || exit 0
  [ -z "${template:-}" ] && exit 0

  name="$(echo "" | rofi_pick "Name:  ")" || exit 0
  [ -z "${name:-}" ] && exit 0

  # Map template names to files
  case "$template" in
    "Meeting")    template_file="meeting.md" ;;
    "Quick Note") template_file="quick-note.md" ;;
    "New Idea")   template_file="new-idea.md" ;;
    *)            exit 0 ;;
  esac

  # Sanitize filename a bit
  clean="$(printf '%s' "$name" | sed 's/[\/:*?"<>|]/-/g; s/  */ /g; s/^ *//; s/ *$//')"
  filename="$(date +%F) ${clean}.md"
  filepath="$NOTES_DIR/$filename"

  # Create file with template content
  if [ -f "$NOTES_DIR/.templates/$template_file" ]; then
    sed "s/{{TITLE}}/$name/g; s/{{DATE}}/$(date '+%Y-%m-%d')/g" \
      "$NOTES_DIR/.templates/$template_file" > "$filepath"
  else
    cat > "$filepath" << EOF
# $name

**Date:** $(date '+%Y-%m-%d')
EOF
  fi

  # Store checksum of original template
  original_checksum="$(sha256sum "$filepath" | cut -d' ' -f1)"

  # Open helix directly and handle cleanup after if the file was not edited
  setsid -f "$TERMINAL" -e sh -c "
    '${EDITOR_CMD[@]}' '$filepath'
    # Check if file was modified after editing
    if [ -f '$filepath' ]; then
      current_checksum=\$(sha256sum '$filepath' | cut -d' ' -f1)
      if [ \"\$current_checksum\" = '$original_checksum' ]; then
        rm '$filepath'
      fi
    fi
  " >/dev/null 2>&1
}

case "$(main_menu)" in
  "Open TODO.md") open_todo ;;
  "New note")     new_note ;;
  *)              exit 0 ;;
esac
