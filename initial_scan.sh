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

# Create custom notify config
config_source="~/.config/notify/config.yaml"
project_config="$recon_directory/$project.yaml"
if [ ! -f "$project_config" ]; then
    cp "$config_source" "$project_config"
    echo "File copied to $project_config"
fi

ls ~/.config/notify

Edit new project_config with discord data.
echo "Creating project config file: $project_config"
echo "discord:" >> "$project_config"
echo "  - id: $project" >> "$project_config"
echo "    discord_channel: $project" >> "$project_config"
echo "    discord_username: $project" >> "$project_config"
echo "    discord_format: \"{{data}}\"" >> "$project_config"
read -p "Enter discord_webhook_url: " discord_webhook_url
echo "    discord_webhook_url: \"$discord_webhook_url\" >> "$project_config"

# start enumeration of the project scope.
cat $scope_file | subfinder -all -d | anew | notify -config $project_config
