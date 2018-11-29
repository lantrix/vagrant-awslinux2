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
awsSigningKey='https://cdn.amazonlinux.com/_assets/11CF1F95C87F5B1A.asc'
baseUrl=$(curl -I ${latestImageLocation} | grep location | awk '{print $2}' | tr -d '\r')
path=$(curl -sL ${latestImageLocation} | grep vdi | grep -o -E 'href="([^"#]+)"' | cut -d'"' -f2 | tr -d '\r')
shaFile=$(curl -sL ${latestImageLocation} | grep SHA256SUMS.gpg | grep -o -E 'href="([^"#]+)"' | cut -d'"' -f2)
curl -s -L -O "${baseUrl}${shaFile}"
decryptedShaSumsFile='SHA256SUMS'
echo "Checking GPG signature of ${shaFile} and extracting ${decryptedShaSumsFile}"
tempPubRing=$(mktemp)
tempSecRing=$(mktemp)
curl -s ${awsSigningKey} | gpg --no-options --no-default-keyring --keyring ${tempPubRing} --secret-keyring ${tempSecRing} --import -
rm -f ${decryptedShaSumsFile} > /dev/null 2>&1
gpg -d --keyring ${tempPubRing} --secret-keyring ${tempSecRing} --output ${decryptedShaSumsFile} ${shaFile}
if ! [ "$?" = "0" ]; then
    echo "ERROR: Failed to verify GPG signature"
    #exit 1
fi
echo "Checking for existing VM Image..."
shasum -c -a 256 ${decryptedShaSumsFile} #Check for existing download
if ! [ "$?" = "0" ]; then
    echo "Downloading Amazon Linux 2 VM Image: ${baseUrl}${path}"
    #curl --progress-bar -L -O -C - "${baseUrl}${path}"
    wget -c --show-progress "${baseUrl}${path}"
    shasum -c -a 256 ${decryptedShaSumsFile} # Check download against pre checked GPG signed SHA256SUMS
    if ! [ "$?" = "0" ]; then
        echo "ERROR: SHA256 Sum of ${path} downloaded doesn't match from decrypted GPG ${shaFile}"
        #exit 1
    fi
else
    echo "Existing ${path} matches SHA256 from decrypted GPG ${shaFile}"
fi

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
