#!/bin/bash

DO_API_URL=https://api.digitalocean.com/v2/droplets

DROPLET_NAME=$(openssl rand -hex 8)
USER_DATA=$(perl -p -e 's/\$\{([^}]+)\}/defined $ENV{$1} ? $ENV{$1} : $&/eg; s/\$\{([^}]+)\}//eg' cloud-init.sh)
DROPLET_CREATE_RESULT=`curl -s -X POST "$DO_API_URL" \
	-d'{"name":"'"$DROPLET_NAME"'",
	"region":"sfo1",
	"size":"512mb",
	"private_networking":true,
	"image":"coreos-stable",
	"user_data":"'"$USER_DATA"'",
	"ssh_keys":[ "'$DO_SSH_KEY_FINGERPRINT'" ]}' \
     -H "Authorization: Bearer $DO_TOKEN" \
     -H "Content-Type: application/json"`

DROPLET_CREATE_STATUS=`echo $DROPLET_CREATE_RESULT | jq -r '.droplet.status'`
if [ "$DROPLET_CREATE_STATUS" != "new" ]; then
    echo "$(tput setaf 1)ERROR! Something went wrong during creation:"
    echo $DROPLET_CREATE_RESULT | jq .
    exit 1
fi
DROPLET_ID=`echo $DROPLET_CREATE_RESULT | jq '.droplet.id'`
echo "Droplet with ID $DROPLET_ID created!"
echo -n "Waiting for Droplet to boot"
for i in {1..60}; do
	DROPLET_STATUS_RESULT=`curl -s -X GET "$DO_API_URL/$DROPLET_ID" \
	-H "Authorization: Bearer $DO_TOKEN" \
	-H "Content-Type: application/json"`
    DROPLET_STATUS=`echo $DROPLET_STATUS_RESULT | jq -r '.droplet.status'`
    if [ "$DROPLET_STATUS" == 'active' ]; then
	    break
	fi
    echo -n '.'
    sleep 5
done
echo

if [ "$DROPLET_STATUS" != 'active' ]; then
    echo "$(tput setaf 1)ERROR! Droplet did not boot in time:"
    echo $DROPLET_STATUS_RESULT | jq .
    exit 1
fi

echo "Droplet booted."

IP_ADDRESS=`curl -s -X GET "$DO_API_URL/$DROPLET_ID" \
	-H "Authorization: Bearer $DO_TOKEN" \
	-H "Content-Type: application/json" \
	| jq -r '.droplet.networks.v4[] | select(.type == "public").ip_address'`

echo "Connecting to Droplet@$IP_ADDRESS..."

ssh -t -q -o "StrictHostKeyChecking no" core@$IP_ADDRESS "journalctl --no-tail -f _COMM=bash"
