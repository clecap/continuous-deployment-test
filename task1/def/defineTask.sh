#!/bin/bash

source ./global-names.sh

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 FAMILYNAME" >&2
  exit 1
fi
FAMILY_NAME=$1

CONTAINER_NAME="container-${FAMILY_NAME}"

source prepareRepository.sh ${FAMILY_NAME}
IMAGE_NAME=${REPOSITORY_URI}

echo "*** Creating a role for executing the task..."
TASK_EXECUTION_ROLE_NAME="role-for-executing-task-${FAMILY_NAME}"
aws iam create-role --role-name ${TASK_EXECUTION_ROLE_NAME} --assume-role-policy-document "{
  \"Version\": \"2012-10-17\",
  \"Statement\": [{\"Effect\": \"Allow\", \"Principal\": {\"Service\": \"codebuild.amazonaws.com\"},\"Action\": \"sts:AssumeRole\"}]}
" 
TASK_EXECUTION_ROLE=`aws iam get-role --role-name ${TASK_EXECUTION_ROLE_NAME} | jq -r '.Role.Arn'`

TASK_EXECUTION_POLICY_NAME="task-execution-policy-for-${FAMILY_NAME}"
### Attach a policy according to https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_execution_IAM_role.html
# NOTE: we here allow access to all resources, we could make this more tight 
echo "*** Adding policy to the role for executing the task..."
echo "   -------------- Policy name: ${TASK_EXECUTION_POLICY_NAME}"
aws iam put-role-policy --role-name ${TASK_EXECUTION_ROLE_NAME} --policy-name ${TASK_EXECUTION_POLICY_NAME} --policy-document "{
  \"Statement\": [
    {
      \"Action\": [
        \"ecr:GetAuthorizationToken\",  \"ecr:BatchCheckLayerAvailability\",
        \"ecr:GetDownloadUrlForLayer\", \"ecr:BatchGetImage\",
        \"logs:CreateLogStream\", \"logs:PutLogEvents\"
      ],
      \"Resource\": \"*\",
      \"Effect\": \"Allow\"
    }
  ],
  \"Version\": \"2012-10-17\"
}"


echo "*** Register task definition"
aws ecs register-task-definition  \
  --family        ${FAMILY_NAME}  \
  --network-mode  "awsvpc"  \
  --container-definitions "[{
    \"name\":    \"${CONTAINER_NAME}\", 
    \"image\":   \"${IMAGE_NAME}\",
    \"portMappings\":  [ 
        {\"containerPort\":  80,  \"hostPort\":  80,  \"protocol\": \"tcp\"},
        {\"containerPort\":  22,  \"hostPort\":  22,  \"protocol\": \"tcp\"},
        {\"containerPort\": 443,  \"hostPort\": 443,  \"protocol\": \"tcp\"}
         ],
    \"essential\":     true, 
    \"entryPoint\":    [\"/entrypoint.sh\"], 
    \"command\":       [\"/entrypoint.sh\"] 
    }]"  \
  --requires-compatibilities FARGATE \
  --execution-role-arn ${TASK_EXECUTION_ROLE} \
  --cpu    256 \
  --memory 512 

echo "*** Registration of task definition completed"


   