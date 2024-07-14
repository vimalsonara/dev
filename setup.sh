#!/bin/bash

# Update package list and upgrade existing packages
echo "Updating package list and upgrading existing packages..."
sudo apt update && sudo apt upgrade -y
echo "Successfully updated package list and upgraded existing packages."

# Install dependencies
echo "Installing dependencies..."
sudo apt install -y software-properties-common 
echo "Successfully installed dependencies."

# Install Git
echo "Installing Git..."
sudo apt install -y git
echo "Successfully installed Git."

# Install latest Neovim (not stable)
echo "Installing Neovim and Tmux..."
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt update
sudo apt install -y neovim
echo "Successfully installed Neovim."

# Ask user if they want to clone a custom Neovim config
read -p "Do you want to clone a custom Neovim config from GitHub? (y/n): " clone_config
if [[ $clone_config == "y" || $clone_config == "Y" ]]; then
    read -p "Please enter the GitHub repo link for your Neovim config: " repo_link
    
    # Check if ~/.config directory exists, create if it doesn't
    if [ ! -d "$HOME/.config" ]; then
        echo "Creating $HOME/.config directory..."
        mkdir "$HOME/.config" 
    fi
    
    # Clone the repository
    if git clone "$repo_link" "$HOME/.config/nvim"; then
        echo "Custom Neovim config cloned successfully to $HOME/.config/nvim"
    else
        echo "Failed to clone the repository. Please check the link and your internet connection."
    fi
else
    echo "Skipping custom Neovim config."
fi

# This is for tree-sitter
# Install build-essential
echo "Installing build-essential..."
sudo apt install -y build-essential
echo "Successfully installed build-essential."

# Install Tmux
sudo apt install -y tmux
echo "Successfully installed Tmux."

# Install Docker
# Remove any old versions
echo "Installing Docker..."
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Install the latest version of docker
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
echo "Successfully installed Docker."

# Add your user to the docker group to run Docker without sudo
sudo usermod -aG docker $USER

# Install NVM (Node Version Manager)
echo "Installing NVM (Node Version Manager)..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

# Load NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Install the latest LTS version of Node.js
nvm install --lts
echo "Successfully installed NVM and the latest LTS version of Node.js."

echo "Installation complete. Please log out and log back in for Docker group changes to take effect."
