const path = require('path');
const mysql = require('mysql2/promise');
const dotenv = require('dotenv');

dotenv.config({path:path.resolve(__dirname, '.env')});

const host=process.env.HOST;
const user=process.env.USER;
const password=process.env.PASSWORD;
const database=process.env.MYSQL_DB;

const db = {
    query: async (qry,args,typ) => { //typ=true if return needed with insertid
        const conn = await mysql.createConnection({host:host,user:user,password:password,database:database,dateStrings:true});
        try {
            if (typeof args === "undefined") {
                const [rows,fields] = await conn.execute(qry);        
                return {res:true,data:rows};
            } else {    
                const [rows,fields] = await conn.execute(qry,args);          
                await conn.end();
                if(typ) {
                   return {res:true,data:rows.insertId};
                } else {
                   return {res:true,data:rows};
                }                                
            }
        } catch (err) {
            return {res:false,err:err.message,data:[]};
        }
    },
    mulQuery:async(queries, queryValues) => {
        const conn = await mysql.createConnection({host:host,user:user,password:password,database:database});
        try {
            await conn.beginTransaction();
            const queryList=[];
            queries.forEach((query, index) => {
                queryList.push(conn.query(query,queryValues[index]));
            });
            const res = await Promise.all(queryList);
            await conn.commit();
            await conn.end();
            var results = {res:true,data:[]};                         
            res.forEach((lst)=> {                
               results.data.push(lst[0]["insertId"]);
            });
            return results;
        } catch(err) {
            await connection.rollback();
            await connection.end();            
            return {res:false,err:err.message,data:[]};
        }
    },
    sMulQuery:async(query,kvList,typ) => { //Single Multiple Insert Query
        const conn = await mysql.createConnection({host:host,user:user,password:password,database:database});
        try {
            await conn.beginTransaction();
            const queryList=[];
            kvList.forEach((kv,index) => {
                queryList.push(conn.query(query,kvList[index]));                
            });
            const res = await Promise.all(queryList);
            await conn.commit();
            await conn.end();
            var results = {res:true,data:[]};                         
            res.forEach((lst)=> {
                if(typ){
                    results.data.push(lst[0]["insertId"]);
                } else {
                    results.data.push(lst[0]);
                }                              
            });
            return results;
        } catch(err) {
            await connection.rollback();
            await connection.end();            
            return {res:false,er:err.message,data:[]};
        }
    }
}

module.exports = db; 



// ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'test';
// flush privileges;

// await conn.query('START TRANSACTION');
// await conn.query('INSERT INTO mydb.cse (NAME,TYPE_ID) VALUES (?,?)',['Test',200]);
// await conn.query('INSERT INTO mydb.cse (NAME,TYPE_ID) VALUES (?,?)',['Test2',202]);
// var test = await conn.query('COMMIT');                        
// return test;