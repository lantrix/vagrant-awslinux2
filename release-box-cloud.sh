#!/bin/bash
# https://aws.amazon.com/amazon-linux-2/release-notes/
#Example Usage:
[ $# -eq 0 ] && { echo -e "\nUsage `basename $0` <VERSION> '<Description>'\n"; exit 1; }
# Inputs & Params for script
versionNo=${1?param missing - new box VERSION}
description=${2?param missin - new version Description}

vagrant cloud publish \
    lantrix/amazonlinux2 \
    ${versionNo} \
    virtualbox \
    amazonlinux2.box \
    -d "Box created from AWS Virtualbox VM https://github.com/lantrix/vagrant-awslinux2 #aws #amazonlinux" \
    --version-description "${description}" \
    --release \
    --short-description "https://github.com/lantrix/vagrant-awslinux2"
