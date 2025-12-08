STEPS I FOLLOWED TO CREATE THE EVENT-DRIVEN NOTIFICATION SYSTEM

- I logged into my AWS Console
- I searched for SNS (Simple Notification Service) and created a topic. Then I subscribed to the topic using my email
- I created a policy through the IAM interface and chose the service to apply the policy to, the service was SNS
- I created role and attached the policy to the role, I created earlier
- I tested my lambda function to ensure it works as expected.
- Then I heae over to create a scheduler that will trigger my lambda function at a predefined interval using AWS EventBridge Service.

