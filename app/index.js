const express = require('express');
const bodyParser = require('body-parser');
const statusRoutes = require('./routes/status');
const dataRoutes = require('./routes/data');

const app = express();

// Middleware
app.use(bodyParser.json()); // for parsing application/json

// Routes
app.use(statusRoutes);
app.use(dataRoutes);

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});
