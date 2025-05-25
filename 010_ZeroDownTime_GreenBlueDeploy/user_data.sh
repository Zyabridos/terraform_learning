#!/bin/bash
dnf -y update
dnf -y install httpd

systemctl enable httpd
systemctl start httpd

myip=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)

cat <<EOF > /var/www/html/index.html
<h2>WebServer with IP: $myip</h2><br>
Built by Terraform using External Script!
<br><font color="blue">Hello, World!!</font>
EOF
