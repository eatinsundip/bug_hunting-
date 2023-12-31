#/bin/bash

# This line below was only needed before I made some updates to how GO is installed. I used this resource.
# https://tecadmin.net/how-to-install-go-on-ubuntu-20-04/
# export PATH=$PATH:~/go/bin

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

# Check and/or create scope file for the project
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
config_source=~/.config/notify/config.yaml
project_config=~/.config/notify/$project.yaml
if [ ! -f "$project_config" ]; then
    cp $config_source $project_config
    echo "File copied to $project_config"
    # Edit new project_config with discord data.
    echo "Creating project config file: $project_config"
    echo "discord: " >> $project_config
    echo "  - id: $project" >> $project_config
    echo "    discord_channel: $project" >> $project_config
    echo "    discord_username: $project" >> $project_config
    echo "    discord_format: \"{{data}}\"" >> $project_config
    read -p "Enter discord_webhook_url: " discord_webhook_url
    echo "    discord_webhook_url: \"$discord_webhook_url\"" >> $project_config
fi

# Subdomain Enumeration
discord_notify="notify -pc $project_config"
domains=$new_directory_path/domains.txt
if [ ! -f "$domains" ]; then
    cat $scope_file | subfinder -all | anew > $domains
else
    echo "the file already exists"
    cat $scope_file | subfinder -all | anew $domains | notify -pc $project_config
fi

# IP enumeration
ip_file=$new_directory_path/ips.txt
if [ ! -f "$ip_file" ]; then
    cat $domains | xargs -l host -t A | awk '/has address/ {print $NF}' | anew > $ip_file
else
    cat $domains | xargs -l host -t A | awk '/has address/ {print $NF}' | anew $ip_file
fi

# Check for active websites
web_file=$new_directory_path/websites.txt
if [ ! -f "$web_file" ]; then
    cat $domains | httprobe -c 80 | anew > $web_file
else
    cat $domains | httprobe -c 80 | anew > $web_file | notify -pc $project_config
fi

# Pull Website Header Information
roots_dir=$new_directory_path/roots
if [ ! -d "$roots_dir" ]; then
    cat $web_file | fff -d 1 -S -o $roots_dir
else
    cat $web_file | fff -d 1 -S -o $roots_dir | anew
fi

# nmap scan first 1000 ports of all seen IPs
nmap_file=$new_directory_path/nmap_full.txt
if [ ! -f "$nmap_file" ]; then
    nmap $(xargs -a $ip_file) >> $nmap_file
else
    nmap $(xargs -a $ip_file) | anew > $nmap_file | notify -pc $project_config
fi
