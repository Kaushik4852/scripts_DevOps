#!/bin/bash
User_name="Kavi"
User_Password="Kavi"

# Update package list
sudo apt update -y

# Install necessary packages
sudo apt install -y openjdk-11-jdk curl git

#install jenkins
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update -y
sudo apt-get install -y jenkins


# Start Jenkins service
sudo systemctl start jenkins

# Enable Jenkins service to start on system boot
sudo systemctl enable jenkins

# Wait for Jenkins to start
# until sudo cat /var/log/jenkins/jenkins.log | grep "Jenkins is fully up and running"; do sleep 1; done
while ! curl -s http://localhost:8080/login >/dev/null; do sleep 1; done

# Retrieve initial admin password
INITIAL_ADMIN_PASSWORD=$(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)

# Output initial admin password to console
echo "Initial admin password: $INITIAL_ADMIN_PASSWORD"

# Install suggested plugins
sudo /usr/local/bin/install-plugins.sh \
    git \
    workflow-aggregator \
    build-timeout \
    credentials-binding \
    timestamper \
    ws-cleanup \
    ant \
    gradle \
    pipeline-utility-steps \
    cloudbees-folder \
    durable-task \
    junit \
    matrix-project \
    ssh-slaves \
    scm-api \
    workflow-api \
    workflow-basic-steps \
    workflow-cps-global-lib \
    workflow-durable-task-step \
    workflow-job \
    workflow-multibranch \
    workflow-scm-step \
    workflow-step-api \
    workflow-support \
    email-ext \
    mailer

# Create admin user
java -jar /path/to/jenkins-cli.jar -s http://localhost:8080/ createUser $User_name $INITIAL_ADMIN_PASSWORD

# Change admin password
java -jar /path/to/jenkins-cli.jar -s http://localhost:8080/ change-password $User_name $User_Password

# Restart Jenkins
sudo systemctl restart jenkins
