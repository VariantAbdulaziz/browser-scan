# usage

## 1. replace

    replace <namespace> with your namespace (usually it will be your app name)

## 2. provision infrastucture

    ```bash
    cd infrastructure
    terraform apply -var-file="terraform.tfvars"
    ```

## 3. deploy

    ```bash
    NAMESPACE="<namespace>"
    aws s3 mb s3://${NAMESPACE}-deployment-artifact
    git archive -o app.zip HEAD
    aws s3 cp app.zip "s3://${NAMESPACE}-deployment-artifact/app.zip"
    aws deploy create-deployment \
    --application-name "${NAMESPACE}-codedeploy-app" \
    --deployment-group-name "${NAMESPACE}-group" \
    --s3-location bucket="${NAMESPACE}-deployment-artifact",bundleType=zip,key=app.zip
    ```
