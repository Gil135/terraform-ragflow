#!/bin/bash
sudo apt-get -y update

# INSTALANDO DOCKER
sudo apt-get install -y ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --batch --yes --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get -y update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Startando e habilitando docker para já iniciar ativo
sudo systemctl enable docker.service
sudo systemctl enable containerd.service

# Instalando docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose


# Instalando AWS CLI
  # Pre-requisito (unzip)

  sudo apt-get install unzip -y

  # AWS CLI (Install)
  sudo curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  sudo unzip awscliv2.zip
  sudo ./aws/install


# Instalando pip pipx uv para Python 3

sudo apt install python3-pip -y
udo snap install astral-uv --classic
# sudo apt install pipx -y
# pipx install uv




# Configurando permissão no docker para não ter que ficar usando root
sudo usermod -aG docker ubuntu
newgrp docker


git clone https://github.com/infiniflow/ragflow.git
cd ragflow/
uv run python3 download_deps.py
docker build -f Dockerfile.deps -t infiniflow/ragflow_deps .
docker build -f Dockerfile -t infiniflow/ragflow:nightly .