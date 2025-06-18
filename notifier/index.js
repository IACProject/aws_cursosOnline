const AWS = require('aws-sdk')

exports.handler = async (event) => {
    console.log("S3 Trigger,", JSON.stringify(event))
    console.log(process.env)
}