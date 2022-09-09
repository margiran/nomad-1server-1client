# Nomad 
## one server one client 
* In order to deploy nomad cluster we are using terraform to provision the infrastructure and Run a Nomad server and a client in aws.

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
Build using Terraform:
```
terraform init
```
we use our local machine to provision infrastructure we have as code, Terraform needs some binaries in order to interact with provider API you use in terraform file.
this is the output of this command:

    Initializing the backend...

    Initializing provider plugins...
    - Reusing previous version of hashicorp/aws from the dependency lock file
    - Reusing previous version of hashicorp/tls from the dependency lock file
    - Using previously-installed hashicorp/aws v4.29.0
    - Using previously-installed hashicorp/tls v4.0.2

    Terraform has been successfully initialized!

```
terraform apply
```
when you run the `apply` command terraform will show the plan (a list of resources need to create/change to achieve yor desire state) and ask for your approval, you need to type 'yes':
    Do you want to perform these actions?
      Terraform will perform the actions described above.
      Only 'yes' will be accepted to approve.

      Enter a value:  

At the end terraform will show a message that indicate your infrastructure is ready:

  Apply complete! Resources: 5 added, 0 changed, 0 destroyed.

  Outputs:
   server_public_ip = "10.10.10.10"
   .
   .
   ssh_server_public_ip = "ssh ubuntu@10.10.10.10 -i ~/.ssh/terraform.pem"

Use following commands to capture the private key in a pem file:
```
terraform output private_key_pem | grep -v EOT > ~/.ssh/terraform.pem
chmod 0400 ~/.ssh/terraform.pem
```
The Outputs gives you the information about created instance you need in order to connect to the instances.
for simplicity we generate the ssh command, so try :
```
terraform output ssh_server_public_ip
```
Copy the value of "ssh_server_public_ip" and paste it in the command line 

Clean up when you're done:
```
terraform destroy
```
