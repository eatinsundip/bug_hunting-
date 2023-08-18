#/bin/bash

export PATH=$PATH:~/go/bin

#check if arguement was provided
if [ $# -eq 0 ]; then
  echo "Usage: $0 <Project Name> <scope file>"
  exit 1
fi

# send domains to initial query
project="$1"
domain="$2"

mkdir -p ~/recon/"$project"
working_dir="~/recon/$Project"

# Gather all subdomains related to the scope
cat "$domain" | subfinder | anew > ~/recon/$project/domains

#gather all known IPs related to domains
input_file="~/recon/"$project"/domains"   # Replace with your input file name
output_file="~/recon/"$project"/hosts" # Replace with your output file name

while IFS= read -r domain; do
    ip=$(host -t A "$domain")
    if [ -n "$ip" ]; then
        echo "$ip" >> "$output_file"
    fi
done < "$input_file"
