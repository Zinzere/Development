// import exp from "express";
// import TestDB from "../dao/test.js";
const exp = require('express');
const GetDB = require('../dao/get.js');
const PostDB = require('../dao/post.js');

const path = exp.Router();

//export default path;
module.exports = path;

//Get requests
path.get("/getOrderReport", GetDB.getOrderReport);
path.get("/getGeneral", GetDB.getGeneral);
path.get("/getMstUnits",GetDB.getMstUnits);

//Post Requests
path.put("/setTest", PostDB.setTest);
path.put("/updBillItem", PostDB.updBillItem);
path.put("/insDelMasterTypes", PostDB.insDelMasterTypes);
path.put("/insUpdDelMstUnits", PostDB.insUpdDelMstUnits);
path.put("/search", PostDB.search);

