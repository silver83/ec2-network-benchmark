#!/bin/bash

source $(dirname "$0")/common.sh

aws cloudformation create-stack \
	--stack-name ec2-network-benchmark-global \
	--parameters ParameterKey=VpcId,ParameterValue=$VPC_ID \
	--template-body file://global.yaml \
	--capabilities CAPABILITY_IAM

