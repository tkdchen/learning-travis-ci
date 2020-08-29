#!/bin/bash -ex

openssl aes-256-cbc -K $encrypted_9173bd2c25f4_key -iv $encrypted_9173bd2c25f4_iv \
    -in copr-cli.conf.enc -out copr-cli.conf -d

docker run -v $(pwd):/code:Z --rm -it registry.fedoraproject.org/fedora:32 /bin/bash -c "
    set -ex

    dnf --disablerepo=fedora-modular \
        --disablerepo=updates-modular \
        --disablerepo=fedora-cisco-openh264 \
        install -y rpm rpm-build copr-cli openssl

    cd /code

    python3 setup.py sdist
    rpmbuild --define '_sourcedir /code/dist' \
             --define '_srcrpmdir /code/dist' \
             --define '_rpmdir /code/dist' \
             -bs coolempty.spec

    srpmfile=\$(rpm -q --queryformat='%{NVR}' --specfile coolempty.spec)

    copr-cli --config /code/copr-cli.conf build cqi/fake-empty-package /code/dist/\$srpmfile
"
