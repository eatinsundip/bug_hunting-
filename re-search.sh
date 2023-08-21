#/bin/bash

export PATH=$PATH:~/go/bin

root=~/recon
project=$1

cat $root/$project/scope | subfinder -all -d | anew | notify -config ~/.config/notify/$project.yaml
