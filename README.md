s# Azure Infrastructure Operations Project: Deploying a scalable IaaS web server in Azure

### Introduction
For this project, you will write a Packer template and a Terraform template to deploy a customizable, scalable web server in Azure.

### Getting Started
1. Clone this repository

2. Create your infrastructure as code

3. Update this README to reflect how someone would use your code.

### Dependencies
1. Create an [Azure Account](https://portal.azure.com) 
2. Install the [Azure command line interface](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
3. Install [Packer](https://www.packer.io/downloads)
4. Install [Terraform](https://www.terraform.io/downloads.html)

### Instructions
## Deploy a Policy
Login to Azure Portal to create a policy that ensures all indexed resources are tagged and deny deployment if they do not. This will help us with organization and tracking, and make it easier to log when things go wrong.

Use command - <code>'az policy assignment list'</code> to verify the tag For instructions on how to create and apply policy in Azure CLI.  This policy is also viewable in Azure Portal. You can [view policy here](https://github.com/kojof/udacity-azure-devops-web-server-deploy/blob/develop/Azure%20Tagging%20Policy.png)

## Packer Template
1. Create a server image using Packer using server.js starter code from Github repository. 

2. Packer authenticates with Azure using a service principal. An Azure service principal is a security identity that you can use with apps, services, and automation tools like Packer. You control and define the permissions as to what operations the service principal can perform in Azure.

3. Create a service principal with az ad sp create-for-rbac and output the credentials that Packer needs:

    <code>az ad sp create-for-rbac --query "{ client_id: appId, client_secret: password, tenant_id: tenant }"</code>

 <code>Output of Query above is for example:
{
    "client_id": "f5b6a5cf-fbdf-4a9f-b3b8-3c2cd00225a4",
    "client_secret": "0e760437-bf34-4aad-9f8d-870be799c55d",
    "tenant_id": "72f988bf-86f1-41af-91ab-2d7cd011db47"
} </code>

4. To authenticate to Azure, you also need to obtain your Azure subscription ID with az account show:

    <code> az account show --query "{ subscription_id: id }"</code>

5. Build Image by specifying your Packer Template file - server.js

   <code> ./packer build ubuntu.json</code>


### Output
An example of the output from the preceding commands is as [follows:](https://github.com/kojof/udacity-azure-devops-web-server-deploy/blob/develop/Packer%20Template%20Output.png)



## Terraform Template
### Create and apply a Terraform execution plan

1. To initialize the Terraform deployment, run  <code>'terraform init' </code>. This command downloads the Azure modules required to create an Azure resource group.

2. After initialization, you create an execution plan by running terraform plan -  <code>'terraform plan -out solution.plan'</code>.

3. Once you're ready to apply the execution plan to your cloud infrastructure, you run terraform apply -  <code>'terraform apply solution.plan'</code>. 

4. Destroy a Terraform execution plan -  <code>'terraform destroy' </code>

### Output
To view the output of the Terraform Execution plan, run command  <code>'Terraform Show'</code> to see created infrastructure.

Output of terraform [Show Plan:](https://github.com/kojof/udacity-azure-devops-web-server-deploy/blob/develop/Terraform%20Show%20Plan%20Output.png)

