const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const dotenv = require('dotenv');
const path = require('./route/path.js');

// import express from "express";
// import bodyParser from "body-parser";
// import cors from "cors";
// import dotenv from 'dotenv';
//import path from "./route/path.js";

dotenv.config({ path: "./config/.env" });
const app = express();

app.use(bodyParser.json({ extended: true })); // parse requests of content-type - application/json
app.use(bodyParser.urlencoded({ extended: false })); // parse requests of content-type - application/x-www-form-urlencoded
app.use(cors());

app.use("/", path);

const PORT = process.env.PORT || 8000;
app.listen(PORT, () => {console.log(`Server is running on port ${PORT}.`);

});