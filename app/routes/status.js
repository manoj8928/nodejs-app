const express = require('express');
const router = express.Router();

router.get('/status', (req, res) => {
    res.json({ status: 'Up and running!' });
});

module.exports = router;
