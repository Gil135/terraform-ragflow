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


# Instalando  Python 3 e uv

 sudo apt install python3-pip -y
 sudo snap install astral-uv --classic


set -e
BASE=/home/ubuntu/setup/ragflow/docker
RDS_HOST="ragflow-mysql.cctwsq2oijjs.us-east-1.rds.amazonaws.com"

# Aguarda o setup do RAGFlow estar disponível (AMI pode demorar para montar)
for i in $(seq 1 30); do
  [ -f "$BASE" ] && break
  sleep 10
done

# Configurando permissão no docker para não ter que ficar usando root
sudo usermod -aG docker ubuntu
newgrp docker


set -e
BASE=/home/ubuntu
cd "$BASE"

git clone https://github.com/infiniflow/ragflow.git
cd ragflow/
uv run python3 download_deps.py
docker build -f Dockerfile.deps -t infiniflow/ragflow_deps .
docker build -f Dockerfile -t infiniflow/ragflow:nightly .