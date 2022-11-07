#!/bin/bash
set -e -o pipefail

function get_ecs_ip() {
    echo "----- METADATA ----"

    JSON=$(curl ${ECS_CONTAINER_METADATA_URI_V4}/task)
    echo $JSON | jq .
    echo "----- END METADATA ----"

    # get the eni from the private ip and print the info
    PRIVATE_IP=$(echo $JSON | jq -r '.Containers[0].Networks[0].IPv4Addresses[0]')
    echo "PRIVATE_IP=$PRIVATE_IP"

    # get the public dns
    ENI_INFO=$(aws ec2 describe-network-interfaces --filters "Name=addresses.private-ip-address,Values=${PRIVATE_IP}")
    echo "----- ENI -----"
    echo $ENI_INFO | jq .
    echo "----- END ENI -----"
    export PUBLIC_IP=$(echo $ENI_INFO | jq -r '.NetworkInterfaces[0].Association.PublicIp')
    export PUBLIC_DNS=$(echo $ENI_INFO | jq -r '.NetworkInterfaces[0].Association.PublicDnsName')
}

get_ecs_ip

# FOR TESTING
#PUBLIC_DNS=ec2-15-156-8-173.ca-central-1.compute.amazonaws.com
#PUBLIC_IP=15.156.8.173

echo "PUBLIC_DNS=$PUBLIC_DNS"
echo "PUBLIC_IP=$PUBLIC_IP"

# adjust cert generation config
function generate_cert_config() {
    PUBLIC_IP=$1
    PUBLIC_DNS=$2
   cat certificates/certificate_template.conf | sed 's/{PUBLIC_IP}/'"${PUBLIC_IP}"'/g' | sed 's/{PUBLIC_DNS}/'"${PUBLIC_DNS}"'/g' > certificates/certificate.conf
}
sudo bash -c "$(declare -f generate_cert_config); generate_cert_config $PUBLIC_IP $PUBLIC_DNS"

# generate the config
(cd certificates; sudo ./generate.sh)
(sudo chmod +r .cache/certificates/*)
cat .cache/certificates/ca.crt

python server.py
