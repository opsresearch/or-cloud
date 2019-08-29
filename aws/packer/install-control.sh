#!/usr/bin/env bash

# Latest and greatest
sudo yum -y update

# Install HTTPD
sudo yum install -y httpd
sudo systemctl enable httpd
