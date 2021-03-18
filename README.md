# AWS-Terraform-VPCWithPublicAndPrivateSubnets-MultitierArch


Task-3 HMC



Statement: We have to create a web portal for our company with all the security as much as possible.

So, we use the WordPress software with a dedicated database server.

The database should not be accessible from the outside world for security purposes.

We only need to public WordPress to clients.

So here are the steps for proper understanding!



Steps:

1) Write an Infrastructure as code using terraform, which automatically create a VPC.



2) In that VPC we have to create 2 subnets:

  a) public subnet [ Accessible for Public World! ] 

  b) private subnet [ Restricted for Public World! ]



3) Create a public-facing internet gateway to connect our VPC/Network to the internet world and attach this gateway to our VPC.



4) Create a routing table for Internet gateway so that instance can connect to the outside world, update and associate it with the public subnet.



5) Launch an ec2 instance that has WordPress setup already having the security group allowing port 80 so that our client can connect to our WordPress site.

Also, attach the key to the instance for further login into it.



6) Launch an ec2 instance that has MYSQL setup already with a security group allowing port 3306 in a private subnet so that our WordPress VM can connect with the same.
