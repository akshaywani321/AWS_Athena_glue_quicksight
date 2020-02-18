#!/bin/bash
aws cloudformation create-stack \
    --stack-name smart-hub-serverless-stack \
    --template-body file://./AWS_athena_glue_quicksight_serverless_stack_cf.json \
    --capabilities CAPABILITY_NAMED_IAM