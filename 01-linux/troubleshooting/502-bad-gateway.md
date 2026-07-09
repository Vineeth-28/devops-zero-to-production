# 502 Bad Gateway Debugging


Architecture:


User
 |
Nginx
 |
NodeJS


Steps:


1. Check nginx


systemctl status nginx


2. Check ports


ss -tulpn


3. Check backend


curl localhost:3000


4. Check logs


journalctl -u nginx