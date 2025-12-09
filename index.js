import axios from "axios";
import config from "./config/index.js";
import publishToSnsTopic from "./aws/sns.init.js";

const { api_key } = config.sport_data;
const SPORT_DATA_IO_URL = `https://api.sportsdata.io/v4/soccer/scores/json/Areas?key=${api_key}`;
const PORT = process.env.PORT || 5000;

export const handler = async () => {
  let result = null;
  try {
    result = await axios.get(SPORT_DATA_IO_URL);
  } catch (error) {
    console.log("Error fetching data from sportdata.io: ", error.message);
  }
  const { data } = result ?? {};
  const seasons = data[0]["Competitions"][0]["Seasons"];
  const finalData = seasons[seasons.length - 1];
  const {Name,StartDate,EndDate,Rounds} = finalData;

  const roundsInfo = Rounds.map((item, index) => {
    const {Season,Name,Type, StartDate,EndDate,CurrentWeek} = item;
    const formattedMessage = `
  ${index + 1}. The week ${CurrentWeek ?? "N/A"} ${Season} season ${Name} ${Type} will start on (${new Date(StartDate).toDateString()}) and end (${new Date(EndDate).toDateString()})
    `;
    return formattedMessage.trim();
  })
  const message = `
The ${Name} will be starting on ${new Date(StartDate).toDateString()} and will end ${new Date(EndDate).toDateString()}
These are the following rounds for the ${Name}

ROUNDS:
${roundsInfo.join(" \n\n")}
`
  try {
   await publishToSnsTopic({message, subject: "World Cup Notification"})
   console.log("successfully published to topic.")
  } catch (error) {
      console.log("Error publishing to SNS: ", error.message);
  }
};

handler();

