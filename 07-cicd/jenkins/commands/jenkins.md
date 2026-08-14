# Jenkins Commands — Day 11

> Hands-on command practice will be done when the laptop is available.

## Service
```bash
sudo systemctl status jenkins
sudo systemctl start jenkins
sudo systemctl stop jenkins
sudo systemctl restart jenkins
```

## Logs
```bash
sudo journalctl -u jenkins
sudo journalctl -u jenkins -f
```

## Java
```bash
java -version
```

## Git commands Jenkins may execute
```bash
git clone <repository>
git checkout <branch>
git pull
```

## Docker commands Jenkins may execute later
```bash
docker build -t backend:v1 .
docker tag backend:v1 vineet/backend:v1
docker push vineet/backend:v1
```
