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
