#!/bin/bash
set -e

if [ "${TRAVIS_REPO_SLUG}" != "pmd/pmd" ] || [ "${TRAVIS_PULL_REQUEST}" != "false" ] || [ "${TRAVIS_SECURE_ENV_VARS}" != "true" ] || [ "${encrypted_5630fbebf057_iv}" = "" ]; then
    echo "Not setting up secrets:"
    echo "  TRAVIS_REPO_SLUG=${TRAVIS_REPO_SLUG}"
    echo "  TRAVIS_PULL_REQUEST=${TRAVIS_PULL_REQUEST}"
    echo "  TRAVIS_SECURE_ENV_VARS=${TRAVIS_SECURE_ENV_VARS}"
    [ "${encrypted_c422865a395e_iv}" = "" ] && echo "  Variable encrypted_c422865a395e_iv is not set"
    exit 0
fi

echo "Setting up secrets..."

openssl aes-256-cbc -K ${encrypted_c422865a395e_key} -iv ${encrypted_c422865a395e_iv} -in .travis/secrets.tar.enc -out .travis/secrets.tar -d
pushd .travis && tar xfv secrets.tar && popd
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"
mv .travis/id_rsa "$HOME/.ssh/id_rsa"
chmod 600 "$HOME/.ssh/id_rsa"
mkdir -p "$HOME/.gpg"
gpg --batch --import .travis/release-signing-key-82DE7BE82166E84E.gpg
rm .travis/secrets.tar
rm .travis/release-signing-key-82DE7BE82166E84E.gpg

echo "Setting up .ssh/known_hosts..."
#
# https://sourceforge.net/p/forge/documentation/SSH%20Key%20Fingerprints/
#
# run locally:
# ssh-keyscan web.sourceforge.net | tee -a known_hosts
#
# verify fingerprints:
# ssh-keygen -F web.sourceforge.net -l -f known_hosts 
# # Host web.sourceforge.net found: line 1 
# web.sourceforge.net RSA SHA256:xB2rnn0NUjZ/E0IXQp4gyPqc7U7gjcw7G26RhkDyk90 
# # Host web.sourceforge.net found: line 2 
# web.sourceforge.net ECDSA SHA256:QAAxYkf0iI/tc9oGa0xSsVOAzJBZstcO8HqGKfjpxcY 
# # Host web.sourceforge.net found: line 3 
# web.sourceforge.net ED25519 SHA256:209BDmH3jsRyO9UeGPPgLWPSegKmYCBIya0nR/AWWCY 
#
# then add output of `ssh-keygen -F web.sourceforge.net -f known_hosts`
#
echo 'web.sourceforge.net ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA2uifHZbNexw6cXbyg1JnzDitL5VhYs0E65Hk/tLAPmcmm5GuiGeUoI/B0eUSNFsbqzwgwrttjnzKMKiGLN5CWVmlN1IXGGAfLYsQwK6wAu7kYFzkqP4jcwc5Jr9UPRpJdYIK733tSEmzab4qc5Oq8izKQKIaxXNe7FgmL15HjSpatFt9w/ot/CHS78FUAr3j3RwekHCm/jhPeqhlMAgC+jUgNJbFt3DlhDaRMa0NYamVzmX8D47rtmBbEDU3ld6AezWBPUR5Lh7ODOwlfVI58NAf/aYNlmvl2TZiauBCTa7OPYSyXJnIPbQXg6YQlDknNCr0K769EjeIlAfY87Z4tw==' >> "$HOME/.ssh/known_hosts"
echo 'web.sourceforge.net ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBCwsY6sZT4MTTkHfpRzYjxG7mnXrGL74RCT2cO/NFvRrZVNB5XNwKNn7G5fHbYLdJ6UzpURDRae1eMg92JG0+yo=' >> "$HOME/.ssh/known_hosts"
echo 'web.sourceforge.net ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOQD35Ujalhh+JJkPvMckDlhu4dS7WH6NsOJ15iGCJLC' >> "$HOME/.ssh/known_hosts"

