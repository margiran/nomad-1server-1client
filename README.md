# Nomad 
## one server one client 
* In order to deploy nomad cluster we are going to use terraform to provision the infrastructure and Run a Nomad server and a client in aws.

![datacenter image](https://github.com/margiran/nomad-one_server-one_client/blob/master/diagram/simple_nomad_cluster.jpeg?raw=true)

## Pre-requisites

* You must have [Terraform](https://www.terraform.io/downloads) installed on your computer. 
* You must have an [Amazon Web Services (AWS) account](http://aws.amazon.com/).


## Quick start

**Please note that this example will deploy real resources into your AWS account. We have made every effort to ensure 
all the resources qualify for the [AWS Free Tier](https://aws.amazon.com/free/), but we are not responsible for any
charges you may incur.** 

Configure your [AWS access 
keys](http://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys) as 
environment variables:

```
export AWS_ACCESS_KEY_ID=(your access key id)
export AWS_SECRET_ACCESS_KEY=(your secret access key)
```
Clone the repository:
```

git clone git@github.com:margiran/nomad-1server-1client.git
cd nomad-1server-1client
```
Deploy the code:
```
terraform init
terraform apply
```
we use our local machine to provision infrastructure we have as code, Terraform needs some binaries in order to interact with provider API you use in terraform file.  When the `init` command completes, you have all the 

When the `apply` command completes, it will output the public IP address of the server. To test that IP:

```
echo $(terraform output private_key_pem) > ~/.ssh/terraform.pem
```

The server can be accessed by 
```
ssh ubuntu@$(terraform output server_public_ip) -i ~/.ssh/terraform.pem
```
The client can be accessed by 
```
ssh ubuntu@$(terraform output client_public_ip) -i ~/.ssh/terraform.pem
```

Clean up when you're done:

```
terraform destroy
```
