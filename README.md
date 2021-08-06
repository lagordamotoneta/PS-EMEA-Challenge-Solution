# PS EMEA Challenge - Terraform and AppDynamics
## Purpose
Install an AppDynamics controller using Terraform and [AppDynamics AWS controller deployment guide](https://docs.appdynamics.com/21.4/en/application-performance-monitoring-platform/planning-your-deployment/aws-controller-deployment-guide) (leaving out some steps)

**NOTE:** This is not a set of official steps nor an approved guidance. This is just a proof of concept and should not be replicated at any customer site.
## Pre-requisites
* AWS account with admin access to create and delete resources. 
* The used AWS account **MUST** have a [Default VPC](https://docs.aws.amazon.com/vpc/latest/userguide/default-vpc.html).
* AWS CLI.
* Terraform 1.0.3
* Git (to clone the project).
* A created SSH key in your AWS account. You must have the key information available (pem file)
* An AppDynamics license key file

## Steps
1. Clone this folder.
2. Run a ```aws configure``` to set your AWS keys (only the keys are necessary as the region is set in the Terraform files)
2. Place your SSH key in the Terraform folder that you just cloned.
3. Place your license.lic file in the Terraform folder that you just cloned.
3.  Update the parameters in the terraform.tfvars on the root folder.
    * key_name = "<the name of your key as it appears in AWS, this is for the EC2 instance creation reference>"
    * key_file = "<the location of the actual .pem file of your key, this can be in the local Terraform folder (you will need to cc it)>"
4. Run:
    * ```terraform init``` - To initialize the Terraform providers.
    * ```terraform plan``` - 9 resources are planned
    * ```terraform apply``` - 9 resources are created
5. Once the terraform apply is done (after 6-7 minutes), you can log into your AWS terminal and monitor the status of your new EC2 instance. You must wait until the "Status Check" field changes from *"Creating"* to *"2-2 Checks passed"*.
6. Once the status is *"2/2 Checks Passed"*, log into your ec2 instace using your key.
7. Perform an ls in the ec2-user home directory and you should see the below files:
    * initLogfile.log
    * installation.sh
    * license.lic
    * platform-setup-x64-linux-21.4.3.24599.sh
    * platform-setup-x64-linux-21.4.3.24599.sh.2761.dir
    * response.varfile
    * resultInstallation.log
    * (maybe an appdynamics folder is already created by the installers)
8. Check the contents of initLogfile.log , the last entry should be:
    *"Executing of file installation.sh (using the Aurora db_endpoint as paramter) started"*
This entry means that the EC, platform and controller installation has started.
9. Check the contents of *resultInstallation.log*. This is the log that monitors the installations. If the entry *"Enterprise Console installation ended"* is present, you can now lof into your EC via public DNS and port 9191. Credentials are the usual from any other controllers you have used in Cloud Machine for example.
10. From the EC you can monitor the controller job. 
11. Once you test your controller as you wish, you **MUST** run ```terraform destroy``` so you are not charged more than necessary for any usage.

## Notes:
* Everything will be installed using the ec2-user.
* All typical credentials are set for this platform.
* **DON'T FORGET TO RUN terraform destroy at the end of your POC**
* The resources used in this challenge do not belong to the free tier and will cost you. Please plan to team with more people so the cost can be split.
* Please use a **PERSONAL** account and not the one provided by the company as it might conflic with security constraints.
