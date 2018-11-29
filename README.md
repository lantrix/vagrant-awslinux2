# vagrant-awslinux2

This builds my own Vagrant Box build for AWS Linux 2 as [documented by AWS](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/amazon-linux-2-virtual-machine.html).

## Pre-requisites

 * [Virtualbox](https://www.virtualbox.org/wiki/Downloads)
 * Mac or Linux
 * [vagrant](https://www.vagrantup.com/downloads.html)

## Usage

Change the default user password in the [`user-data` file](./seedconfig/user-data)

````yaml
ec2-user:plain_text_password
````

Download the Virtualbox Amazon Linux 2 VM Image
Create the box:

````shell
./create-box.sh
````
