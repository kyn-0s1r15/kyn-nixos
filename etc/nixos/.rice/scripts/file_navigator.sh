#!/bin/bash

# A simple file navigator using fzf

# Function to navigate and select a file
navigate() {
    selected=$(find . -type f | fzf --height 40% --reverse --preview 'cat {}')
    if [[ -n "$selected" ]]; then
        echo "You selected: $selected"
        # You can add any action you want to perform with the selected file here
        # For example, open the file with a default editor
        xdg-open "$selected" 2>/dev/null || open "$selected" 2>/dev/null
    else
        echo "No file selected."
    fi
}

navigate

