# Jenkins — General Commands

## Install (Debian/Ubuntu, via apt)
```bash
sudo apt update
sudo apt install -y fontconfig openjdk-17-jre
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt update
sudo apt install -y jenkins
```

## Service Management
```bash
sudo systemctl start jenkins
sudo systemctl stop jenkins
sudo systemctl restart jenkins
sudo systemctl status jenkins
sudo systemctl enable jenkins        # start on boot
journalctl -u jenkins -f             # tail logs
```

## Initial Setup
```bash
# Get initial admin password
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

# Default web UI
http://localhost:8080
```

## Run via Docker
```bash
docker run -d --name jenkins \
  -p 8080:8080 -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  jenkins/jenkins:lts

# Get admin password
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

## CLI (jenkins-cli.jar)
```bash
curl -O http://localhost:8080/jnlpJars/jenkins-cli.jar

java -jar jenkins-cli.jar -s http://localhost:8080/ -auth user:token list-jobs
java -jar jenkins-cli.jar -s http://localhost:8080/ -auth user:token build my-job
java -jar jenkins-cli.jar -s http://localhost:8080/ -auth user:token reload-configuration
java -jar jenkins-cli.jar -s http://localhost:8080/ -auth user:token safe-restart
```

## Key Paths
```bash
/var/lib/jenkins/            # JENKINS_HOME
/var/lib/jenkins/jobs/       # job configs + build history
/var/lib/jenkins/plugins/    # installed plugins
/var/lib/jenkins/secrets/    # credentials & encryption keys
/var/log/jenkins/jenkins.log # log file
```

## Backup / Restore
```bash
sudo tar -czf jenkins-backup-$(date +%F).tar.gz -C /var/lib/jenkins .

sudo systemctl stop jenkins
sudo tar -xzf jenkins-backup-2026-08-18.tar.gz -C /var/lib/jenkins
sudo chown -R jenkins:jenkins /var/lib/jenkins
sudo systemctl start jenkins
```

## Plugin Management (CLI)
```bash
java -jar jenkins-cli.jar -s http://localhost:8080/ -auth user:token install-plugin docker-workflow
java -jar jenkins-cli.jar -s http://localhost:8080/ -auth user:token list-plugins
```
