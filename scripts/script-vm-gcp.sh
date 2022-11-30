#install rundeck
sudo apt-get install -yq openjdk-11-jre-headless
curl -L https://packages.rundeck.com/pagerduty/rundeck/gpgkey | sudo apt-key add -
sudo echo 'deb https://packages.rundeck.com/pagerduty/rundeck/any/ any main' > /etc/apt/sources.list.d/rundeck.list
sudo echo 'deb-src https://packages.rundeck.com/pagerduty/rundeck/any/ any main' >> /etc/apt/sources.list.d/rundeck.list
sudo apt-get update -y; apt-get install -y rundeck
sudo systemctl enable rundeckd.service
sudo systemctl start rundeckd.service
