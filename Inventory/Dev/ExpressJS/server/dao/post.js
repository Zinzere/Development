const db = require('../config/mysql.js');

const PostDB = {    
  setTest:async (req, res) => {
    const json = req.body; 
    console.log(json.name  + "-" + json.type);               
    const getIdQry = `SELECT ID FROM mydb.mst_type WHERE TYPE = ? AND NAME = ?;`;          
    var result = await db.query(getIdQry,['User Type',json.type]);  
    if(result.res) {
      const insCseQry = `INSERT INTO mydb.cse (NAME,TYPE_ID) VALUES (?,?);`;          
      var result = await db.query(insCseQry,[json.name,result.data[0].ID],true);     
      res.send(result);            
    } else {
      res.send(result);            
    }         
  },
  updBillItem:async (req, res) => {
    const json = req.body;      
    const qry = `UPDATE mydb.bill SET BILL_NO= ? WHERE ID = ?;`;         
    var result = await db.query(qry,[json.status,json.id]);         
    res.send(result);            
  },
  insDelMasterTypes:async (req, res) => {
    const json = req.body;
    if(json.type=="DEL") {
      const qry = `DELETE FROM mydb.mst_type WHERE ID = ?;`;         
      var result = await db.query(qry,[json.id],true); 
    } else {
      const qry = `INSERT INTO mydb.mst_type (NAME,TYPE) VALUES (?,?);`;         
      var result = await db.query(qry,[json.name,json.type],true); 
    }                 
    res.send(result);            
  },
  insUpdDelMstUnits:async(req, res) => {
    const json = req.body;
    if(json.type=="UF") { //update ACTV_UNIT Flag - {type: UF, rec: [{id: 1, flag: 1}, {id: 2, flag: 0}]}
      const qry = `UPDATE mydb.mst_units set ACTV_UNIT = ? WHERE ID = ?;`;         
      var result = await db.sMulQuery(qry,getArgs(json.rec,['flag','id']),true); 
    } else if(json.type=="INS") {
      const qry = `INSERT INTO mydb.mst_units (UNIT,TYPE_ID,ACTV_UNIT,UNIT_CALC) VALUES (?,?,?,?) ;`;         
      var result = await db.query(qry,[json.unit,json.typeId,0,json.calc],true); 
    }                
    res.send(result);            
  },
  search:async(req, res) => {
    const json = req.body;      
    const qry = `select * from mydb.mst_type where TYPE='Unit' AND NAME like ?;`;           
    var result = await db.query(qry,['%' + json.name + '%']);         
    res.send(result);            
  }
};

function getArgs(kvList,keyList) { //sends [{id: 1, flag: 1}, {id: 2, flag: 0}] Returns [{1,1},{2,0}]
   sendList = [];
   kvList.forEach(kv => {
     subList = [];
     keyList.forEach(key => {
      subList.push(kv[key]);     
     });
     sendList.push(subList);     
   });
   return sendList;
}

module.exports = PostDB;

