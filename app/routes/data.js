const express = require('express');
const AWS = require('aws-sdk');
const router = express.Router();
const { v4: uuidv4 } = require('uuid');

// Initialize DynamoDB client
AWS.config.update({
    region: "eu-central-1"  // Adjust based on your region
 });

//const dynamoDB = new AWS.DynamoDB.DocumentClient();

const dynamoDb = new AWS.DynamoDB.DocumentClient();

router.post('/data', async (req, res) => {
    const data = req.body;

    // Generate a unique ID for the item
    const id = uuidv4();

    const item = {
        id: id,
        ...data
    };

    // Use the item for DynamoDB put operation
    try {
        await dynamoDb.put({
            TableName: 'demo',
            Item: item
        }).promise();

        res.json({ success: true, message: 'Data stored successfully', id: id });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

module.exports = router;

