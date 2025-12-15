STEPS I FOLLOWED TO CREATE THE EVENT-DRIVEN NOTIFICATION SYSTEM

- I logged into my AWS Console
- I searched for SNS (Simple Notification Service) and created a topic. Then I subscribed to the topic using my email
- I created a policy through the IAM interface and chose the service to apply the policy to, the service was SNS
- I created role and attached the policy to the role, I created earlier
- I tested my lambda function to ensure it works as expected.
- Then I heae over to create a scheduler that will trigger my lambda function at a predefined interval using AWS EventBridge Service.

THE ARCHITECTURE

EVENT_BRIDGE (The schedules whent the lambda function will be invoked ) ------> AWS_LAMBDA (This holds the business logic) --------> AWS_SNS (The notification service that we publish to - we publish to a particular topic) --------> Email (This is a subscriber, that subscribes to the topic we created)


EVENT_BRIDGE ---> AWS_LAMBDA --->  AWS_SNS --> Email


Using Terraform
- We use the command `aws ssm put-parameter --name "<NAME>" --value "<VALUE>" --type "SecureString"` to store our keys (API KEY) with a name in the AWS System Manager Store.

- Create a .tf file (file extension for terraform) and populate it with the required configuration

- Run the command `terraform init` (Initialize terraform directory, provider plugin and setup local backend)

- Run the command `terraform fmt` (Format terraform config files to make it clean, readable and follow best practices)

- Run the command `terraform validate` (Check Terraform configurations for syntax errors and correctness)

- Run the command `terraform plan` (Show preview of changes Terraform will make to your infrastructure before applying them)

- Run the command `terraform apply` (Create or update the infrastructure based on the Terraform configuration)


- After `terraform apply` has successfully ran, you need to go your AWS Console -> Search for SNS -> Click on the Simple Notification Service -> Click on the topic you just created -> Create a subscription for the topic (You can subscribe your email to the topic)

The subscription to the topic need to be done manually as that cannot be automated.