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

mkdir ~/recon/"$project"
cd ~/recon/"$project"

cat "$domain" | subfinder > subdomains
