#/bin/bash

export PATH=$PATH:~/go/bin

#check if arguement was provided.
if [ $# -eq 0 ]; then
  echo "Usage: $0 <Project Name>"
  exit 1
fi

# Check and create ~/recon if it doesn't already exist.
directory=~/recon
if [ ! -d "$directory" ]; then
    mkdir "$directory"
fi

# Check and create project folder
project="$1"
new_directory_path="$directory/$project"
if [ ! -d "$new_directory_path" ]; then
    mkdir "$new_directory_path"
fi

Check and/or create scope file for the project
scope_file="$new_directory_path/scope.txt"
if [ ! -f "$scope_file" ]; then
    echo "Scope file does not exist. Creating it..."
    echo "Enter scope entries. Press Ctrl+D when done:"
    while true; do
        read -p "Enter scope entry: " scope_entry
        echo "$scope_entry" >> "$scope_file"
        read -p "Add another entry? (y/n): " choice
        if [[ "$choice" != "y" ]]; then
            break
        fi
    done
    echo "Scope file created with the following content:"
    cat "$scope_file"
else
    echo "Scope file already exists with the following content:"
    cat "$scope_file"
fi
