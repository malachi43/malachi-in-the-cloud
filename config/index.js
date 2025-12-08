import dotenv from "dotenv";
dotenv.config();

const config = {
    sport_data: {
     api_key: process.env.SPORT_DATA_IO_API_KEY
    },
    aws: {
        sns_topic_arn: process.env.AWS_SNS_TOPIC_ARN,
        region: process.env.AWS_SNS_REGION
    }
}

export default config;