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


if [[ ! -f /var/www/html/inventory.html ]]
then
if [[ ! -d /var/www/html ]]
then
mkdir -p /var/www/html
fi
echo "Log Type    Time Created    Type    Size" > /var/www/html/inventory.html
fi

logType="httpd-logs"
type=${file#*.}
size=$(du -h /tmp/$file | cut -f1)

echo "$logType		$timestamp		$type		$size" >> /var/www/html/inventory.html

if [[ ! -f /etc/cron.d/automation ]]
then
echo "0 0 * * * root /root/Automation_Project/automation.sh" > /etc/cron.d/automation
fi
