#/bin/bash

command=$1
countries=("us" "fr" "ca" "au" "dk" "fi" "de" "jp" "nz")
index=0

while true; do
        current_item=${countries[index]}
        index=$((index + 1))
        command="mullvad relay set location ${countries[index]}"
        echo $command
        index=$(( (index + 1) % ${#countries[@]} ))
        $command
        sleep 2
        timeout 10 $command
done
