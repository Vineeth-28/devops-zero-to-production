# 🚀 AWS EC2 Nginx Linux Lab


## Environment

Cloud:

AWS EC2


OS:

Ubuntu Linux


Purpose:

Practice Linux production debugging.

---

# Setup


## Update Server


```bash
sudo apt update
```


---

## Install Nginx


```bash
sudo apt install nginx -y
```


---

## Start Nginx


```bash
sudo systemctl start nginx
```


---

## Check Service


```bash
systemctl status nginx
```


Expected:

```
active (running)
```


---

# Process Investigation


Find nginx process:


```bash
ps aux | grep nginx
```


Check PID:

```
root  1234 nginx
```


---

# Port Investigation


Check listening ports:


```bash
sudo ss -tulpn
```


Expected:


```
:80 nginx
```


---

# Logs Investigation


```bash
journalctl -u nginx
```


---

# Failure Simulation


Stop nginx:


```bash
sudo systemctl stop nginx
```


Debug:


1. Check service

```bash
systemctl status nginx
```


2. Check logs


```bash
journalctl -u nginx
```


3. Start again


```bash
sudo systemctl start nginx
```


---

# Learning Outcome


After this lab:

✅ Understand Linux services

✅ Debug process issues

✅ Investigate ports

✅ Read production logs