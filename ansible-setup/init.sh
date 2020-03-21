# #!/bin/bash
# sudo dnf update -y;
# sudo dnf install httpd -y;
# sudo systemctl enable httpd;
# sudo systemctl start httpd


sudo dnf update -y;
sudo dnf install python3 -y;
python3 -V;
sudo dnf install python3-pip -y;
useradd ansible;


#passwd ansible
#set the root password for the ansible user
#Please give ansible user full root access
#vi /etc/sudoers
#anisble ALL=(ALL) NOPASSWD: ALL
#Please enable the passwordauthentication yes from /etc/ssh/shhd_config

#install ansible by running the command
pip3 install ansible --user;
ansible --version;
sudo mkdir /etc/ansible;
cd /etc/ansible;
sudo touch hosts;