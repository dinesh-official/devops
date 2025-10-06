# Steps
1. Create a VPC
2. Create 6 Subnets
- 2 subnet (Web Server)
- 2 subnet (App
Server)
- 2 subnet (DI
Create 2 Route table
- Public-rt connects with Internet gateway and 2 public subnet
- Private-rt connects with Nat gateway and 2 private app server subnet
- No NAT for DB
4. Create 3 Security Group
- Public-SG (SSH-ALL, HTTP-ALL, HTTPS-ALL)
- Private-SG (5000-Public-SG, SSH-Public-SG) outbound (MYS@L-Db-SG) |
- Db-SG (3306-Mysql-Private-SG) |
5. Create RDS
- Create DB Subnet group (atleast 2 subnets needed)
- Create a MySQL DB in Private Subnet with Db-SG
Create Web server EC2
- Create Ec2 in Public Subnet with Web-SG
7. Create App server EC2
- Create Ec2 in Private Subnet with App-SG
8. Create Application Load Balancer
- Create 1 targate group for App server Ec2 with port as 5000 and health check path as /login
- Create LB in public Subnet with listner port as 80 and attach targate group
9. Create R53 Hosted zone
- A record type,simple routing
*******************************************************************


Web Server:
#!/bin/bash
sudo yum install httpd -y sudo service httpd start
cd /var/www/html/
