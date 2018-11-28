if [[ `uname` -eq 'Darwin' ]]; then
    hdiutil makehybrid -o seed.iso -hfs -joliet -iso -default-volume-name cidata seedconfig/
fi
if [[ `uname` -eq 'Linux' ]]; then
    pushd seedconfig/
    genisoimage -output ../seed.iso -volid cidata -joliet -rock user-data meta-data
    popd
fi
