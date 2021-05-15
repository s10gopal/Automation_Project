myname=gopal
s3_bucket=upgrad-gopal

apt update -y
apt -qq install apache2
systemctl is-active apache2.service || systemctl start apache2.service
systemctl is-enabled apache2.service || systemctl enable apache2.service

timestamp=$(date '+%d%m%Y-%H%M%S')
file=$myname-httpd-logs-$timestamp.tar

cd /var/log/apache2/; tar cvf /tmp/$file *.log

aws s3 cp /tmp/$file s3://${s3_bucket}/$file
