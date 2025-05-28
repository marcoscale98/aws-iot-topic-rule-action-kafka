# Get started Kafka action

This guide helps you to deploy an AWS IoT Topic Rule with Kafka Action

## Steps

### 1. generate keystore secrets

- `./secrets_generation.sh`
- Use the generated secrets in the next step as parameters

### 2. MSK and accessories resources creation

- Create a new stack based on `msk-and-accessories.yaml` by AWS Console or AWS CLI
- Use the Output in the next step as parameters


### 3. IoT Topic Rule creation

- Get bootstrap server string in the MSK section of AWS Console
- Create a new stack based on `iot-topic-rule.yaml` by AWS Console or AWS CLI