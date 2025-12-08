import { SNSClient, PublishCommand } from "@aws-sdk/client-sns";
import config from "../config/index.js";
const  {region,sns_topic_arn} = config.aws;
const client = new SNSClient({ region: region });

async function publishMessage({message, subject}) {
  try {
    const command = new PublishCommand({
      TopicArn: sns_topic_arn,
      Message: message,
      Subject: subject,
    });

    const response = await client.send(command);
    console.log("Message sent:", response);
  } catch (err) {
    throw err;
  }
}

export default publishMessage;