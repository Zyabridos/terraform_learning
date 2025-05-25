#!/bin/bash
dnf -y update
dnf -y install httpd

systemctl enable httpd
systemctl start httpd

echo "<h1>Hello from WebServer $(hostname -f)</h1>" > /var/www/html/index.html
