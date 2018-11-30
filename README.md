# vagrant-awslinux2

This builds my own Vagrant Box build for AWS Linux 2 as [documented by AWS](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/amazon-linux-2-virtual-machine.html).

## Pre-requisites

 * [Virtualbox](https://www.virtualbox.org/wiki/Downloads)
 * Mac or Linux
 * [vagrant](https://www.vagrantup.com/downloads.html)

## Usage

### Create Box

Change the default user password in the [`user-data` file](./seedconfig/user-data)

````yaml
ec2-user:plain_text_password
````

Create the box:

````shell
./create-box.sh
````
### Release Box

Create a new version & provider (virtualbox): https://app.vagrantup.com/lantrix/boxes/amazonlinux2/versions/new

Release the box, for example:

````shell
./release-box-cloud.sh 2018.11.26 'Amazon Linux 2 - 11/26/2018 Update'
````
