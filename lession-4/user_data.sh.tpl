#!/bin/bash
dnf -y update
dnf -y install httpd

myip=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)

cat <<EOF > /var/www/html/index.html
<html>
<h2>Build by Power of Terraform <font color="red> v.0.12</font>"</h2><br>
Owner ${first_name} ${last_name} <br>

%{ for name in names ~}
Hello ${name} from ${first_name}<br>
%{ endof ~}
</html>
EOF
sudo service httpd start
chkconfig httpd on