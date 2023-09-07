#/bin/bash

# install for my version of Ubuntu but can add more support if interested.
apt update && apt install golang-go -y
go install github.com/tomnomnom/assetfinder@latest
go install github.com/tomnomnom/httprobe@latest
go install github.com/tomnomnom/anew@latest
go install github.com/tomnomnom/fff@latest
go install github.com/tomnomnom/waybackurls@latest
go install github.com/tomnomnom/gf@latest
git clone https://github.com/tomnomnom/gf
mkdir ~/.gf
mv gf/examples/* ~/.gf
rm -rf gf
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latestgo install -v github.com/projectdiscovery/notify/cmd/notify@latest
go install -v github.com/projectdiscovery/nuclei/cmd/nuclei@latest
wget --content-disposition https://mullvad.net/download/app/deb/latest
sudo apt install -y ./MullvadVPN-*_amd64.deb
sudo rm -rf ./MullvadVPN-*_amd64.deb
mullvad connect && mullvad status

echo "Finished"
