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

create p3.2xlarge 0
create p3.8xlarge 0
create p3.16xlarge 0

wait_create_complete p3.2xlarge
wait_create_complete p3.8xlarge
wait_create_complete p3.16xlarge

delete p3.2xlarge
delete p3.8xlarge
delete p3.16xlarge

wait_delete_complete p3.2xlarge
wait_delete_complete p3.8xlarge
wait_delete_complete p3.16xlarge
