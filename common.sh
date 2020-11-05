SUBNET_ID=$1
SCRIPT_PATH=$(realpath --relative-to="`pwd`" $0)
function usage {
    echo -e "usage: ./$SCRIPT_PATH <subnet-id>\n"
}

if [[ -z "$SUBNET_ID" ]]; then
    echo "must provide subnet-id"
    usage
    exit 1
fi

VPC_ID=$(aws ec2 describe-subnets --subnet-id $SUBNET_ID | jq -r '.Subnets[0].VpcId')
if [[ -z "$VPC_ID" ]]; then
    echo "failed getting vpc for subnet $SUBNET_ID" ; 
    exit 1;
fi
