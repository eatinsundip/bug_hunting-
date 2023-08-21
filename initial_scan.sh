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
    read -p "Enter the content for the scope file: " scope_content
    echo "$scope_content" > "$scope_file"
    echo "Scope file created with content:"
    cat "$scope_file"
else
    echo "Scope file already exists with the following content:"
    cat "$scope_file"
fi
