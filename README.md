# vagrant-awslinux2

This builds my own Vagrant Box build for AWS Linux 2 as [documented by AWS](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/amazon-linux-2-virtual-machine.html).

## Usage

Change the default user password in the [`user-data` file](./seedconfig/user-data)

````yaml
ec2-user:plain_text_password
````

Create the box:

````shell
./create-box.sh
````
