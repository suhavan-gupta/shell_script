# bash changeWriteCapacityUnit.sh table_name no_of_write_capacity_units
# this script is used to change the number of WriteCapacityUnits in dynamodb. It returns with 0 in case of failure
aws dynamodb update-table --provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=$2 --table-name $1 || exit 1

while [ "$(aws dynamodb describe-table --table-name $1 --query 'Table.[TableStatus]' --output text)" = "UPDATING" ]
do 
	echo "Status : UPDATING"
	sleep 5
done

TableStatus="$(aws dynamodb describe-table --table-name $1 --query 'Table.[TableStatus]' --output text)"

WriteCapacityUnits="$(aws dynamodb describe-table --table-name $1 --query 'Table.ProvisionedThroughput.WriteCapacityUnits' --output text)"

if [ "$TableStatus" = "ACTIVE" ]
    then
if [ "$WriteCapacityUnits" = "$2" ]
        then
            echo "WriteCapacityUnit Successfully changed"
            exit 0
        else
	        echo "WriteCapacityUnits are not updated!!!"
            exit 1
        fi
else
    echo "Something went wrong. TableStatus not active"
    exit 1
fi
