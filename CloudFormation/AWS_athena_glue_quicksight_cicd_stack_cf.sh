#!/bin/bash
aws cloudformation create-stack \
    --stack-name smart-hub-cicd-stack \
    --template-body file://./AWS_athena_glue_quicksight_cicid_stack_cf.json\
    --capabilities CAPABILITY_NAMED_IAM