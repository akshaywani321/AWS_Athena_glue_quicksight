#!/bin/bash
BUCKET_SUFFIX="571941764095-us-east-1"
DATA_BUCKET="smart-hub-data-${BUCKET_SUFFIX}"
SCRIPT_BUCKET="smart-hub-scripts-${BUCKET_SUFFIX}"
LOG_BUCKET="smart-hub-logs-${BUCKET_SUFFIX}"

aws cloudformation create-stack \
    --stack-name smart-hub-athena-glue-stack \
    --template-body file://./AWS_athena_glue_quicksight_stack_cf.json\
    --parameters ParameterKey=Data_Bucket_Name,ParameterValue=${DATA_BUCKET} \
                 ParameterKey=Script_Bucket_Name,ParameterValue=${SCRIPT_BUCKET} \
                 ParameterKey=Log_Bucket_Name,ParameterValue=${LOG_BUCKET} \
    --capabilities CAPABILITY_NAMED_IAM