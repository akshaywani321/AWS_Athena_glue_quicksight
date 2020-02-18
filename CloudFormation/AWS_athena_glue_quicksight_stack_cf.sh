#!/bin/bash
BUCKET_SUFFIX="571941764095-us-east-1"
DATA_BUCKET="smart-hub-data-${BUCKET_SUFFIX}"
SCRIPT_BUCKET="smart-hub-scriptstore-${BUCKET_SUFFIX}"
LOG_BUCKET="smart-hub-logs-${BUCKET_SUFFIX}"
KeyName="smart_hub_test"

aws cloudformation create-stack \
    --stack-name smart-hub-application-stack \
    --template-body file://./AWS_athena_glue_quicksight_stack_cf.json\
    --parameters ParameterKey=DataBucketName,ParameterValue=${DATA_BUCKET} \
                 ParameterKey=ScriptBucketName,ParameterValue=${SCRIPT_BUCKET} \
                 ParameterKey=LogBucketName,ParameterValue=${LOG_BUCKET} \
                 ParameterKey=KeyName,ParameterValue=${KeyName} \
    --capabilities CAPABILITY_NAMED_IAM