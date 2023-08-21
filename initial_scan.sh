#/bin/bash

export PATH=$PATH:~/go/bin

#check if arguement was provided
if [ $# -eq 0 ]; then
  echo "Usage: $0 <Project Name> <scope file>"
  exit 1
fi

# send domains to initial query
project=$1
domain=$2

mkdir -p ~/recon/$project
working_dir=~/recon/$Project

# Gather all subdomains related to the scope
cat $domain | subfinder | anew > ~/recon/$project/domains

#gather all known IPs related to domains
input_file=/home/frank/recon/$project/domains
output_file=/home/frank/recon/$project/hosts

while IFS= read -r domain; do
    ip=$(host -t A $domain)
    if [ -n "$ip" ]; then
        echo $ip >> $output_file
    fi
done < $input_file

# Build list of non 400 error websites
cat $input_file | httprobe -c 80 > ~/recon/$project/websites

# gather header and body daya of main pages on sites
cat ~/recon/$project/websites | fff -d 1 -S -o ~/recon/$project/roots

# nmap all known IPs for all 65535 tcp ports
