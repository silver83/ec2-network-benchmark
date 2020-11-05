#!/bin/bash 

source $(dirname "$0")/common.sh

INSTANCE_TYPE_SERVER="c5n.18xlarge"
SPOT_PRICE_SERVER="2"

# $1 = client instance type
function create {
  aws cloudformation create-stack \
  	--stack-name ec2-network-benchmark-${1//./-} \
  	--parameters \
  		ParameterKey=SubnetId,ParameterValue=$SUBNET_ID \
		ParameterKey=ParentGlobalStack,ParameterValue=ec2-network-benchmark-global \
		ParameterKey=InstanceTypeClient,ParameterValue=$1 ParameterKey=SpotPriceClient,ParameterValue=$2 \
		ParameterKey=InstanceTypeServer,ParameterValue=$INSTANCE_TYPE_SERVER \
		ParameterKey=SpotPriceServer,ParameterValue=$SPOT_PRICE_SERVER \
		--template-body file://benchmark.yaml
}

# $1 = client instance type
function wait_create_complete {
  aws cloudformation wait stack-create-complete --stack-name ec2-network-benchmark-${1//./-}
}

# $1 = client instance type
function delete {
  aws cloudformation delete-stack --stack-name ec2-network-benchmark-${1//./-} 
}

# $1 = client instance type
function wait_delete_complete {
  aws cloudformation wait stack-delete-complete --stack-name ec2-network-benchmark-${1//./-}
}

create c5n.large 2
create c5n.xlarge 2
create c5n.2xlarge 2
create c5n.4xlarge 2
create c5n.9xlarge 2
create c5n.18xlarge 2

wait_create_complete c5n.large
wait_create_complete c5n.xlarge
wait_create_complete c5n.2xlarge
wait_create_complete c5n.4xlarge
wait_create_complete c5n.9xlarge
wait_create_complete c5n.18xlarge

delete c5n.large
delete c5n.xlarge
delete c5n.2xlarge
delete c5n.4xlarge
delete c5n.9xlarge
delete c5n.18xlarge

wait_delete_complete c5n.large
wait_delete_complete c5n.xlarge
wait_delete_complete c5n.2xlarge
wait_delete_complete c5n.4xlarge
wait_delete_complete c5n.9xlarge
wait_delete_complete c5n.18xlarge