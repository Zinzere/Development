const { sMulQuery } = require('../config/mysql.js');
const db = require('../config/mysql.js');

const GetDB = {  
   getGeneral: async (req, res) => {
      const qry = `SELECT * FROM mydb.mst_type`;           
      var result = await db.query(qry);     
      res.send(result); 
   },  
   getMstUnits: async (req, res) => {
      const billQry = `SELECT * FROM mydb.mst_units ORDER BY TYPE_ID,ACTV_UNIT DESC;`;     
      var result = await db.query(billQry);           
      res.send(result);            
   }, 
   getOrderReport: async (req, res) => {      
      var resMap = {};
      const billQry = `SELECT CSE.NAME,BILL.ID,BILL.BILL_NO,BILL_DATE,BILL.DEL_DATE,+GST_AMT AS TOTAL, CASE WHEN BILL.STATUS = 'W' THEN 'Work In Progress' WHEN BILL.STATUS = 'D' THEN 'Delivered' WHEN BILL.STATUS = 'NS' THEN 'Not Started' END AS BILL_STATUS from mydb.bill BILL JOIN mydb.cse CSE ON CSE.ID = BILL.CS_ID WHERE BILL.BILL_TYPE = 'O';`;     
      var billData = await db.query(billQry);
      if(billData.res){                  
         const itmQry = `SELECT MAT.ID,MAT.NAME,MAT.STOCK_QTY,ROUND(SUM(MAK.REQ_QTY*(BITM.QTY-MAK.COMP_QTY)),2) AS NEED FROM mydb.bill_items BITM JOIN mydb.make MAK ON MAK.BITM_ID = BITM.ID JOIN mydb.materials MAT ON MAT.ID = MAK.MAT_JOB_ID WHERE BITM.BILL_ID = ? AND  MAK.MK_TYPE = 'I' GROUP BY BITM.BILL_ID,MAT.ID;`;
         var billIdList = [];
         billData.data.forEach(bill => {
            billIdList.push([bill.ID]);
         });
         var itmRes =await db.sMulQuery(itmQry,billIdList);                       
         if(itmRes.res){                        
            var checkBal = {};                        
            itmRes.data.map((itmLst,idx)=>{                   
               billData.data[idx]["MAT"]="In Stock";
               var stock = {};                         
               itmLst.forEach((itm)=>{                                   
                  var chkBool = true;
                  if(itm.ID in checkBal){                     
                     var bal=checkBal[itm.ID]-itm.NEED;
                     if(bal<0 && chkBool){billData.data[idx]["MAT"]="Out of Stock";chkBool=false;}
                     checkBal[itm.ID]=bal;                     
                  } else {
                     var bal=itm.STOCK_QTY-itm.NEED;
                     if(bal<0 && chkBool){billData.data[idx]["MAT"]="Out of Stock";chkBool=false;}
                     checkBal[itm.ID]=bal;                     
                  }
                  stock[itm.NAME]={"STOCK":itm.STOCK_QTY,"ITM_ID":itm.ID,"NEED":itm.NEED,"BAL":bal.toFixed(2)};                  
               });
               billData.data[idx]["STOCK"]=stock;               
            });
            const workQry = `SELECT JOB.ID,JOB.NAME,SUM(BITM.QTY) QTY,SUM(MAK.COMP_QTY) COMP,ROUND(SUM(BITM.QTY-MAK.COMP_QTY),2) AS NEED FROM mydb.bill_items BITM JOIN mydb.make MAK ON MAK.BITM_ID = BITM.ID JOIN mydb.mst_type JOB ON JOB.ID = MAK.MAT_JOB_ID WHERE BITM.BILL_ID = ? AND  MAK.MK_TYPE = 'O' GROUP BY BITM.BILL_ID,JOB.ID;`;
            var workRes =await db.sMulQuery(workQry,billIdList);
            workRes.data.map((wrkLst,idx)=>{  
               var comp = 0;               
               wrkLst.forEach((wrk)=>{ 
                  comp=comp+wrk["COMP"];
                  var chkBool = true;
                  if(wrk["NEED"]>0){
                     billData.data[idx]["JOB"]="Work In Progress";
                     chkBool=false;
                  } else if(wrk["NEED"]==0 && chkBool){
                     billData.data[idx]["JOB"]="Completed";
                  }
                  if(comp==0){
                     billData.data[idx]["JOB"]="Not Yet Started";
                  }
               });
               billData.data[idx]["JOB_DTL"]=wrkLst;
            });           
            resMap.res=true;            
            resMap["data"]=billData.data;             
            res.send(resMap);
         } else {
            res.send(itmRes);
         }                               
      } else {
         res.send(billData);            
      }       
   },
   getMaterials: async (req,res) => {
      
   } 
}; 

module.exports = GetDB;

/*
var resMap = {};
      const billQry = `SELECT CSE.NAME,BILL.ID,BILL.BILL_NO,BILL_DATE,BILL.DEL_DATE,+GST_AMT AS TOTAL, CASE WHEN BILL.STATUS = 'W' THEN 'Work In Progress' WHEN BILL.STATUS = 'D' THEN 'Delivered' WHEN BILL.STATUS = 'NS' THEN 'Not Started' END AS BILL_STATUS from mydb.bill BILL JOIN mydb.cse CSE ON CSE.ID = BILL.CS_ID WHERE BILL.BILL_TYPE = 'O';`;     
      var billData = await db.query(billQry);
      if(billData.res){         
         var stock = {};
         const itmQry = `Select BITM.BILL_ID,MAT.ID,MAT.NAME,MAT.STOCK_QTY,ROUND(SUM(MAK.REQ_QTY*BITM.QTY),2) AS SUM FROM mydb.bill_items BITM JOIN mydb.materials MAT ON MAT.ID = BITM.ITEM_ID JOIN mydb.make MAK ON MAK.BITM_ID = BITM.ID AND MAK.MK_TYPE = 'I' WHERE BITM.BILL_ID = ? GROUP BY BITM.BILL_ID,MAT.ID;`;
         var billIdList = [];
         billData.data.forEach(bill => {
            billIdList.push([bill.ID]);
         });
         var itmRes =await db.sMulQuery(itmQry,billIdList);                       
         if(itmRes.res){                        
            itmRes.data.forEach((itmLst)=>{
               itmLst.forEach((itm)=>{
                  if(itm.NAME in stock) {
                     stock[itm.NAME].BILL.push({"BID":itm.BILL_ID,"USD":itm.SUM});
                  } else {
                     stock[itm.NAME]={"STOCK":itm.STOCK_QTY,"ITM_ID":itm.ID,"BILL":[{"BID":itm.BILL_ID,"USD":itm.SUM}]};
                  }
               });
            });

            resMap.res=true;            
            resMap["data"]=billData.data; 
            resMap["mat"]=stock;
            res.send(resMap);
         } else {
            res.send(itmRes);
         }   
*/