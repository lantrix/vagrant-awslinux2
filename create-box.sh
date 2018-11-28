if [[ "$OSTYPE" == "linux-gnu" ]]; then
    pushd seedconfig/
    genisoimage -output ../seed.iso -volid cidata -joliet -rock user-data meta-data
    popd
elif [[ "$OSTYPE" == "darwin"* ]]; then
    hdiutil makehybrid -o seed.iso -hfs -joliet -iso -default-volume-name cidata seedconfig/
else
    echo "Unknown OS"
    exit 1
fi
