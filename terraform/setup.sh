
#!/bin/bash

echo "Updating Ubuntu"
sudo apt update -y

echo "Installing Java"
sudo apt install openjdk-21-jre -y

echo "Installing Jenkins"
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key

echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list

sudo apt update -y
sudo apt install jenkins -y
sudo systemctl enable --now jenkins

echo "Installing Docker"
sudo apt install docker.io -y
sudo systemctl enable --now docker

echo "Adding Jenkins to Docker group"
sudo usermod -aG docker jenkins

echo "Downloading SonarQube Image"
sudo docker pull sonarqube:community

echo "Running SonarQube Container"
sudo docker run -d --name sonarqube -p 9000:9000 sonarqube:community

echo "Installation Completed"

echo "Jenkins URL: http://EC2-PUBLIC-IP:8080"
echo "SonarQube URL: http://EC2-PUBLIC-IP:9000"

echo "Jenkins Password:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

sudo docker ps
