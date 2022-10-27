
# terraform-oci-create-instnace-modules

> Before You Begin
> 
> Prepare
> 
> Start Terraform



## Before You Begin
To successfully perform this tutorial, you must have the following:

   * An Oracle Cloud Infrastructure account. [See Signing Up for Oracle Cloud Infrastructure](https://docs.oracle.com/en-us/iaas/Content/GSG/Tasks/signingup.htm)
   * A MacOS, Linux, or Windows environment:
   * MacOS
   * Linux (Any distribution)
      - You can install a Linux VM with an **Always Free** Compute shape, on Oracle Cloud Infrastructure:
         +  [Install an Ubuntu VM](https://docs.oracle.com/iaas/developer-tutorials/tutorials/helidon-on-ubuntu/01oci-ubuntu-helidon-summary.htm#create-ubuntu-vm)
         +  [Install an Oracle Linux VM](https://docs.oracle.com/iaas/developer-tutorials/tutorials/apache-on-oracle-linux/01oci-ol-apache-summary.htm#create-oracle-linux-vm)
   * Oracle Cloud Infrastructure Cloud Shell:
      -  [Cloud Shell](https://docs.oracle.com/iaas/Content/API/Concepts/cloudshellintro.htm)
   * Windows 10
      -  [Windows Subsystem for Linux](https://docs.microsoft.com/windows/wsl/install-win10) (WSL)
      -  [Git for Windows](https://gitforwindows.org/) to access a Linux VM.



## Prepare
Prepare your environment for authenticating and running your Terraform scripts. Also, gather the information your account needs to authenticate the scripts.

### Install Terraform
   Install the latest version of Terraform **v1.3.0+**:

   1. In your environment, check your Terraform version.
      ```script
      terraform -v
      ```

      If you don't have Terraform **v1.3.0+**, then install Terraform using the following steps.

   2. From a browser, go to [Download Latest Terraform Release](https://www.terraform.io/downloads.html).

   3. Find the link for your environment and then follow the instructions for your environment. Alternatively, you can perform the following steps. Here is an example for installing Terraform v1.3.3 on Linux 64-bit.

   4. In your environment, create a temp directory and change to that directory:
      ```script
      mkdir temp
      ```
      ```script
      cd temp
      ```

   5. Download the Terraform zip file. Example:
      ```script
      wget https://releases.hashicorp.com/terraform/1.3.3/terraform_1.3.3_linux_amd64.zip
      ```

   6. Unzip the file. Example:
      ```script
      unzip terraform_1.3.3_linux_amd64.zip
      ```

   7. Move the folder to /usr/local/bin or its equivalent in Mac. Example:
      ```script
      sudo mv terraform /usr/local/bin
      ```

   8. Go back to your home directory:
      ```script
      cd
      ```

   9. Check the Terraform version:
      ```script
      terraform -v
      ```

      Example: `Terraform v1.3.3 on linux_amd64`.

### Create API-Key
   If you created API keys for the Terraform Set Up Resource Discovery tutorial, then skip this step.

   Create RSA keys for API signing into your **Oracle Cloud Infrastructure account**.

   1. **Log in to the Oracle Cloud site and access the user portal.**

      ![Login](https://raw.githubusercontent.com/ZConverter-samples/terraform-oci-create-instnace-modules/images/images/login.png)  

   2. **Enter the User menu.**

      ![Account User](https://raw.githubusercontent.com/ZConverter-samples/terraform-oci-create-instnace-modules/images/images/user_account.png)  

   3. **Choice User Account Name to use.**

      ![Account Users](https://raw.githubusercontent.com/ZConverter-samples/terraform-oci-create-instnace-modules/images/images/user_account_choice.png)

   4. **Click api-key in the lower left resource and click add api key**

      ![Api-Key](https://raw.githubusercontent.com/ZConverter-samples/terraform-oci-create-instnace-modules/images/images/api_key_add.png)

   5. **Under API Key Pairing, click Download Private Key and Download Public Key, and then click the Add button. If there are more than three API Key, Delete API Key or use another User Account Name.**

      ![Api-Key](https://raw.githubusercontent.com/ZConverter-samples/terraform-oci-create-instnace-modules/images/images/api_key_download_key_file.png)

   7. **Copy the results from Configuration File Preview onto the notepad.**

      ![Configuration](https://raw.githubusercontent.com/ZConverter-samples/terraform-oci-create-instnace-modules/images/images/api_key_copy.png)
   
   8. **Select Networking from the menu, then select Virtual Cloud Networks**

      ![Networking-Virtual Cloud Network](https://raw.githubusercontent.com/ZConverter-samples/terraform-oci-create-instnace-modules/images/images/click_vcn.png)
   
   9. **Choice VCN User Account Name to use**

      ![Select VCM User Account Name](https://raw.githubusercontent.com/zconverter/ZCM-Baisc/master/image/oci_terraform/click_vcn_zcon.png)

   1. **Choice Subnets Name to use**

      ![Select Subnets Name](https://raw.githubusercontent.com/ZConverter-samples/terraform-oci-create-instnace-modules/images/images/click_subnet.png)

   1. **Copy the Subnet OCID onto the notepad**

      ![Subnet OCID](https://raw.githubusercontent.com/ZConverter-samples/terraform-oci-create-instnace-modules/images/images/copy_subnet_ocid.png)

   1. **Result**

      ![Result](https://raw.githubusercontent.com/ZConverter-samples/terraform-oci-create-instnace-modules/images/images/download_result.png)

##  Start Terraform

### Example tf file
```
terraform {
  required_version  =  ">= 1.3.0"
  required_providers {
    oci  =  {
      source = "oracle/oci"
      version = "4.96.0"
    }
  }
}

provider  "oci" {
  tenancy_ocid  = "<The tenancy ocid you wrote down above>"
  user_ocid  = "<The user ocid you wrote down above>"
  fingerprint  = "<The fingerprint you wrote down above>"
  region  = "<The region you wrote down above>"
  private_key_path  = "<The absolute path of the private key you downloaded>"
}

module  "create_oci_instance" {
  source  =  "git::https://github.com/ZConverter-samples/terraform-oci-create-instnace-modules.git"
  region = "us-ashburn-1"
  vm_name = "oracle-terraform"
  subnet_ocid = "ocid1.subnet.oc1.us-ashburn-1.aaaaa...."
  compartment_ocid = "ocid1.compartment.oc1..aaaa"
  OS = "CentOS"
  OS_version = "7
  instance_type_name = "VM.Standard.E4.Flex"
  instance_cpus = 1
  instance_memory_in_gbs = 16
  ssh_public_key = "ssh-rsa AAAAB3Nza....ssh_public_key"
  additional_volumes =  [50]
  security_list = [
	{
		"direction" : "ingress",
		"protocol" : "tcp",
		"port_range_min" : "22",
		"port_range_max" : "22",
		"remote_ip_prefix" : "0.0.0.0/0"
	}
  ]
}
```
*  Create a `terraform.tf` file
```
touch terraform.tf
```

### `terraform.tf`

#### terraform version
``` 
terraform {
  required_version  =  ">= 1.3.0"
  required_providers {
    oci  =  {
      source = "oracle/oci"
      version = "4.96.0"
    }
  }
}
```
### provider
* If you would like to know more about multiple provider configurations, please refer to [OCI configurations](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformproviderconfiguration.htm).
```
provider  "oci" {
  tenancy_ocid  = "<The tenancy ocid you wrote down above>"
  user_ocid  = "<The user ocid you wrote down above>"
  fingerprint  = "<The fingerprint you wrote down above>"
  region  = "<The region you wrote down above>"
  private_key_path  = "<The absolute path of the private key you downloaded>"
}
```
#### or
```
provider  "oci" {
  config_file_profile = "<The profile you will use for the configuration file>"
}
```
* Profile name if you want to provide authentication credentials using a custom profile in the OCI configuration file. For more information, see Using [SDK and CLI Configuration Files](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformproviderconfiguration.htm#terraformproviderconfiguration_topic-SDK_and_CLI_Config_File).

### module
* example
```
module  "create_oci_instance" {
  source  =  "git::https://github.com/ZConverter-samples/terraform-oci-create-instnace-modules.git"
  region = "us-ashburn-1"
  vm_name = "oracle-terraform"
  subnet_ocid = "ocid1.subnet.oc1.us-ashburn-1.aaaaa...."
  compartment_ocid = "ocid1.compartment.oc1..aaaa"
  OS = "CentOS"
  OS_version = "7
  instance_type_name = "VM.Standard.E4.Flex"
  instance_cpus = 1
  instance_memory_in_gbs = 16
  ssh_public_key = "ssh-rsa AAAAB3Nza....ssh_public_key"
  additional_volumes =  [50]
}
```
### create-instance Attributes
| Attribute | Data Type | Required | Default Value | Valid Values | Description |
|---|---|---|---|---|---|
| region | string | yes | none | string of the region |The region where you want to create an instance.|
|vm_name| string | yes |  none | Display Name | The display name of the instance. |
| compartment_ocid | string | yes | none | Compartments available for the user| OCID of the compartment that the Compute Instance is created in |
| subnet_ocid |string | yes | none | Subnet created | The subnets in which the instance primary VNICs are created. |
| OS | string | yes | none | string of OS Name | One of Canonical Ubuntu, CentOS, Oracle Autonomous Linux, Oracle Linux, Oracle Linux Cloud Developer, Windows |
| OS_version |  string | yes | none| string of OS Version Name | Version of the selected OS. |
| custom_image_name |  string | no | none| string value | When creating an instance using a custom image |
| boot_volume_size_in_gbs| number | no | 50 | number value | Boot volume size of the instance you want to create. |
| instance_type_name | string | yes | none | string of Shape Name | Shape types provided by Oracle Cloud. |
| instance_cpus | number | conditional | 1 | number value | Number of cpu to use when using instance_type_name as flexible type. |
| instance_memory_in_gbs | number | conditional | 16 | number value | Number of memory size to use when using instance_type_name as flexible type. |
| ssh_public_key | string | conditional | none | string value | ssh public key to use when using Linux-based OS. (Use only one of the following: ssh_public_key, ssh_public_key_file_path)|
| ssh_public_key_file_path | string | conditional | none | string value | Absolute path of ssh public key file to use when using Linux-based OS. (Use only one of the following: ssh_public_key, ssh_public_key_file_path)|
| user_data_file_path | string | conditional | none | string value | Absolute path of user data file path to use when cloud-init.|
| additional_volumes | list | conditional | [] | list value | Use to add a block volume. Use numeric arrays.|
| security_list | list | no | none | list value | When you need to create ingress and egress rules |
| direction | string | conditional | none | string value | Either "ingress" or "egress" |
| protocol | string | conditional | none | string value | Enter a supported protocol name |
| port_range_min | string | conditional | none | string value | Minimum Port Range (Use only when using udp, tcp protocol) |
| port_range_max | string | conditional | none | string value | Maximum Port Range (Use only when using udp, tcp protocol) |
| type | string | conditional | none | string value | type number (Use only when using the icmp protocol) |
| code | string | conditional | none | string value | code number (Use only when using the icmp protocol) |
| remote_ip_prefix | string | conditional | none | IPv4 CIDR | CIDR |

```
terraform init
```
```
terraform plan
```
```
terraform apply
```