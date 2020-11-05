#!/bin/bash -x

INSTANCE_TYPE_SERVER="c5n.18xlarge"
SPOT_PRICE_SERVER="1.1659"

# $1 = client instance type
function create {
  aws cloudformation create-stack --stack-name ec2-network-benchmark-${1//./-} --parameters ParameterKey=ParentVPCStack,ParameterValue=ec2-network-benchmark-vpc ParameterKey=ParentGlobalStack,ParameterValue=ec2-network-benchmark-global ParameterKey=InstanceTypeClient,ParameterValue=$1 ParameterKey=SpotPriceClient,ParameterValue=$2 ParameterKey=InstanceTypeServer,ParameterValue=$INSTANCE_TYPE_SERVER ParameterKey=SpotPriceServer,ParameterValue=$SPOT_PRICE_SERVER --template-body file://benchmark.yaml
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

create x1e.xlarge 1 
create x1e.2xlarge 0
create x1e.4xlarge 0
create x1e.8xlarge 0
create x1e.16xlarge 0
create x1e.32xlarge 0

wait_create_complete x1e.xlarge
wait_create_complete x1e.2xlarge
wait_create_complete x1e.4xlarge
wait_create_complete x1e.8xlarge
wait_create_complete x1e.16xlarge
wait_create_complete x1e.32xlarge

delete x1e.xlarge
delete x1e.2xlarge
delete x1e.4xlarge
delete x1e.8xlarge
delete x1e.16xlarge
delete x1e.32xlarge

wait_delete_complete x1e.xlarge
wait_delete_complete x1e.2xlarge
wait_delete_complete x1e.4xlarge
wait_delete_complete x1e.8xlarge
wait_delete_complete x1e.16xlarge
wait_delete_complete x1e.32xlarge
