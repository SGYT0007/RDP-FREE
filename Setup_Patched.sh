
# Add user & setup ngrok v3
sudo useradd -m $(jq -r '.inputs.username' $GITHUB_EVENT_PATH)
sudo adduser $(jq -r '.inputs.username' $GITHUB_EVENT_PATH) sudo
echo $(jq -r '.inputs.username' $GITHUB_EVENT_PATH):$(jq -r '.inputs.password' $GITHUB_EVENT_PATH) | sudo chpasswd
sudo sed -i 's/\/bin\/sh/\/bin\/bash/g' /etc/passwd
sudo hostname $(jq -r '.inputs.computername' $GITHUB_EVENT_PATH)

# Download & install ngrok v3 (64-bit)
wget -q https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz
tar -xzf ngrok-v3-stable-linux-amd64.tgz
sudo mv ngrok /usr/local/bin/
chmod +x /usr/local/bin/ngrok

# Setup authtoken
ngrok config add-authtoken $(jq -r '.inputs.authtoken' $GITHUB_EVENT_PATH)

# Start TCP tunnel on port 22
rm -f .ngrok.log
ngrok tcp 22 --log ".ngrok.log" &
sleep 10

echo "Ngrok Setup Completed ✅"
