#!/bin/bash

# Make sure required environment variables are set
[ -n "$DO_TOKEN" ] || read -p "Enter your Digital Ocean token: " DO_TOKEN
[ -n "$DO_DOCKER_BUILD_REPO" ] || read -p "Enter the git repo you wish to build: " DO_DOCKER_BUILD_REPO
[ -n "$DO_DOCKER_RUN_OPTIONS" ] || read -p "Enter any options to use when running: " DO_DOCKER_RUN_OPTIONS

# Prompt for optional environment variables showing default values
DEFAULT_DO_REGION=sfo1
DEFAULT_DO_SIZE=512mb
DEFAULT_DO_CHANNEL=stable
[ -n "$DO_NAME_PREFIX" ] || read -p "Enter Droplet name prefix []: " DO_NAME_PREFIX
[ -n "$DO_REGION" ] || read -p "Enter Droplet region [$DEFAULT_DO_REGION]: " DO_REGION
[ -n "$DO_SIZE" ] || read -p "Enter Droplet size [$DEFAULT_DO_SIZE]: " DO_SIZE
[ -n "$DO_CHANNEL" ] || read -p "Enter CoreOS channel [$DEFAULT_DO_CHANNEL]: " DO_CHANNEL

DO_API_URL=https://api.digitalocean.com/v2
DO_HEADERS=(-H "Authorization: Bearer $DO_TOKEN" -H "Content-Type: application/json")

if [ -z "$DO_SSH_KEY_FINGERPRINT" ]; then
	SSH_KEY_PATH=~/.ssh/id_ecdsa
	[ -f "$SSH_KEY_PATH" ] || ssh-keygen -t ecdsa -N "" -f $SSH_KEY_PATH

	ADD_KEY_RESULT=$(curl -s -X POST "$DO_API_URL/account/keys" \
		-d'{"name":"'"$DROPLET_NAME"'",
		"public_key":"'"$(cat "$SSH_KEY_PATH.pub")"'"}' \
	    "${DO_HEADERS[@]}")
	# TODO: add error handling
	DO_SSH_KEY_FINGERPRINT=$(ssh-keygen -E md5 -lf $SSH_KEY_PATH.pub | cut -d " " -f 2 | cut -c5-)
fi

# Check and make sure we're using a valid SSH key
GET_KEY_RESULT=$(curl -s -X GET "$DO_API_URL/account/keys/$DO_SSH_KEY_FINGERPRINT" "${DO_HEADERS[@]}")
if [ $(echo $GET_KEY_RESULT | jq -r '.ssh_key.fingerprint') != "$DO_SSH_KEY_FINGERPRINT" ]; then
	echo "$(tput setaf 1)ERROR! Unable to find SSH Key: $DO_SSH_KEY_FINGERPRINT"
    echo $GET_KEY_RESULT | jq .
    exit 1
fi

[ -n "$DO_NAME_PREFIX" ] && DROPLET_NAME="${DO_NAME_PREFIX}-"
DROPLET_NAME+=$(openssl rand -hex 6)
USER_DATA=$(cat <<EOF
#!
docker build -t deployment $DO_DOCKER_BUILD_REPO
docker run $DO_DOCKER_RUN_OPTIONS deployment
EOF
)

DROPLET_CREATE_RESULT=$(curl -s -X POST "$DO_API_URL/droplets" \
	-d'{"name":"'"$DROPLET_NAME"'",
	"region":"'"${DO_REGION:=$DEFAULT_DO_REGION}"'",
	"size":"'"${DO_SIZE:=$DEFAULT_DO_SIZE}"'",
	"private_networking":true,
	"image":"coreos-'"${DO_CHANNEL:=$DEFAULT_DO_CHANNEL}"'",
	"user_data":"'"$USER_DATA"'",
	"ssh_keys":[ "'$DO_SSH_KEY_FINGERPRINT'" ]}' \
    "${DO_HEADERS[@]}")

DROPLET_CREATE_STATUS=$(echo $DROPLET_CREATE_RESULT | jq -r '.droplet.status')
if [ "$DROPLET_CREATE_STATUS" != "new" ]; then
    echo "$(tput setaf 1)ERROR! Something went wrong during creation:"
    echo $DROPLET_CREATE_RESULT | jq .
    exit 1
fi
DROPLET_ID=$(echo $DROPLET_CREATE_RESULT | jq '.droplet.id')
echo "Droplet $DROPLET_NAME with ID $DROPLET_ID created!"
echo -n "Waiting for Droplet $DROPLET_NAME to boot"
for i in {1..60}; do
	DROPLET_STATUS_RESULT=$(curl -s -X GET "$DO_API_URL/droplets/$DROPLET_ID" "${DO_HEADERS[@]}")
    DROPLET_STATUS=$(echo $DROPLET_STATUS_RESULT | jq -r '.droplet.status')
    if [ "$DROPLET_STATUS" == 'active' ]; then
	    break
	fi
    echo -n '.'
    sleep 5
done
echo

if [ "$DROPLET_STATUS" != 'active' ]; then
    echo "$(tput setaf 1)ERROR! Droplet $DROPLET_NAME did not boot in time:"
    echo $DROPLET_STATUS_RESULT | jq .
    exit 1
fi

echo "Droplet $DROPLET_NAME booted."

IP_ADDRESS_RESULT=$(curl -s -X GET "$DO_API_URL/droplets/$DROPLET_ID" "${DO_HEADERS[@]}")
IP_ADDRESS=$(echo $IP_ADDRESS_RESULT | jq -r '.droplet.networks.v4[] | select(.type == "public").ip_address')

echo "Connecting to core@$IP_ADDRESS..."

ssh -t -q -o StrictHostKeyChecking=no -o ConnectTimeout=300 core@$IP_ADDRESS "journalctl --no-tail -f _COMM=bash"
