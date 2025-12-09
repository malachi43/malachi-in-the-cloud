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