const express = require('express');
const AWS = require('aws-sdk');
const router = express.Router();

// Initialize DynamoDB client
AWS.config.update({
    region: "eu-central-1"  // Adjust based on your region
 });

const dynamoDB = new AWS.DynamoDB.DocumentClient();

router.post('/data', async (req, res) => {
    const { body } = req;
    
    const params = {
        TableName: 'demo',  // replace with your DynamoDB table name
        Item: body
    };

    try {
        await dynamoDB.put(params).promise();
        res.status(201).json({ message: 'Data stored successfully.' });
    } catch (error) {
        console.error("Error:", error);
        res.status(500).json({ message: 'Internal Server Error' });
    }
});

module.exports = router;
