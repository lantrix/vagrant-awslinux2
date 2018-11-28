if [[ "$OSTYPE" == "linux-gnu" ]]; then
    pushd seedconfig/
    genisoimage -output ../seed.iso -volid cidata -joliet -rock user-data meta-data
    popd
    networkInterface=$(route | grep '^default' | grep -o '[^ ]*$')
elif [[ "$OSTYPE" == "darwin"* ]]; then
    hdiutil makehybrid -o seed.iso -hfs -joliet -iso -default-volume-name cidata seedconfig/
    networkInterface=$(route -n get default | grep 'interface:' | grep -o '[^ ]*$')
else
    echo "Unknown OS"
    exit 1
fi

#Get Virtualbox AWS VM
latestImageLocation='https://cdn.amazonlinux.com/os-images/latest/virtualbox/'
baseUrl=$(curl -I ${latestImageLocation} | grep location | awk '{print $2}' | tr -d '\r')
path=$(curl -sL ${latestImageLocation} | grep vdi | grep -o -E 'href="([^"#]+)"' | cut -d'"' -f2 | tr -d '\r')
echo "Downloading Amazon Linux 2 VM Image: ${baseUrl}${path}"
curl --progress-bar "${baseUrl}${path}" -O ${path}

#Spin up VM with seed.iso
VM="amazonliunux2"
VBoxManage createvm --name $VM --ostype "Linux_64" --register
VBoxManage storagectl $VM --name "SATA Controller" --add sata --controller IntelAHCI
VBoxManage storageattach $VM --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium ${path}
VBoxManage storagectl $VM --name "IDE Controller" --add ide
VBoxManage storageattach $VM --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium ./seed.iso
VBoxManage modifyvm $VM --ioapic on
VBoxManage modifyvm $VM --boot1 dvd --boot2 disk --boot3 none --boot4 none
VBoxManage modifyvm $VM --memory 1024 --vram 128
VBoxManage modifyvm $VM --nic1 bridged --bridgeadapter1 ${networkInterface}
VBoxHeadless -s $VM
