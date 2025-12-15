import { SSMClient, GetParameterCommand, DeleteParameterCommand } from "@aws-sdk/client-ssm";
import config from "./config/index.js";
const {aws} = config;
const {region} = aws;

const ssm = new SSMClient({ region });

//key -> sport-data-io-api-key
const getValueWithKeyFromAWSSystemManager = async (key) => {
    const command = new GetParameterCommand({
          Name: key,
          WithDecryption: true,
        })

      const response = await ssm.send(command);
      
      return response.Parameter.Value;

}

export default getValueWithKeyFromAWSSystemManager;



