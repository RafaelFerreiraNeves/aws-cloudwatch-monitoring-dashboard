const AWS = require("aws-sdk");

const sns = new AWS.SNS();

exports.handler = async (event) => {

    console.log("Alarm event received:", JSON.stringify(event));

    await sns.publish({
        TopicArn: process.env.SNS_TOPIC_ARN,

        Subject: "CloudWatch Alarm Triggered",

        Message: JSON.stringify(event, null, 2)

    }).promise();

    return {
        statusCode: 200,

        body: "Notification sent"
    };
};