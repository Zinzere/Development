-- MySQL dump 10.13  Distrib 8.0.29, for Win64 (x86_64)
--
-- Host: localhost    Database: mydb
-- ------------------------------------------------------
-- Server version	8.0.29

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `bill`
--

DROP TABLE IF EXISTS `bill`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bill` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `BILL_TYPE` char(1) DEFAULT NULL COMMENT 'O - Order, P - Purchase, S - Sales',
  `CS_ID` int unsigned DEFAULT NULL,
  `TOTAL` float unsigned DEFAULT NULL,
  `GST_AMT` float unsigned DEFAULT NULL,
  `BILL_DATE` date DEFAULT NULL,
  `DEL_DATE` date DEFAULT NULL,
  `BILL_NO` varchar(30) DEFAULT NULL,
  `STATUS` char(2) DEFAULT NULL COMMENT 'STATUS of ORDER/MAKE -> Not Started/Work In Progress/Completed/Delivered\nFor Purchases P - Normal Purchase, D - Damage RePurchase, R - Re-Work Re Purchase',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bill`
--

LOCK TABLES `bill` WRITE;
/*!40000 ALTER TABLE `bill` DISABLE KEYS */;
INSERT INTO `bill` VALUES (1,'P',5,4000,400,'2022-01-01','2022-02-02','PR-01','P'),(2,'P',6,2420,220,'2022-01-02','2022-02-05','PR-02','P'),(3,'O',1,2300,230,'2022-01-10','2022-02-10','OR-01','W'),(4,'S',1,2300,230,'2022-02-15',NULL,'SO-01','S'),(5,'O',2,9450,450,'2022-04-20','2022-06-22','OR-02','W');
/*!40000 ALTER TABLE `bill` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bill_items`
--

DROP TABLE IF EXISTS `bill_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bill_items` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `BILL_ID` int unsigned DEFAULT NULL,
  `ITEM_ID` int unsigned DEFAULT NULL,
  `QTY` float unsigned DEFAULT NULL,
  `PRICE` float unsigned DEFAULT NULL,
  `GST` float unsigned DEFAULT NULL,
  `GST_AMT` float unsigned DEFAULT NULL,
  `TOTAL` float unsigned DEFAULT NULL,
  `INV_COST` float unsigned DEFAULT NULL COMMENT 'Inventory cost only applicable for Orders like Fabric/Thread',
  `OPR_COST` float unsigned DEFAULT NULL COMMENT 'Operational cost only applicable for Orders like cutting/stitching',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bill_items`
--

LOCK TABLES `bill_items` WRITE;
/*!40000 ALTER TABLE `bill_items` DISABLE KEYS */;
INSERT INTO `bill_items` VALUES (1,1,1,10,100,10,100,1100,NULL,NULL),(2,1,2,10,200,10,200,2200,NULL,NULL),(3,1,3,100,10,10,100,1100,NULL,NULL),(4,2,1,20,110,10,220,2420,NULL,NULL),(5,3,1,3,500,10,150,1650,NULL,NULL),(6,3,2,2,400,10,80,880,NULL,NULL),(7,4,1,3,500,10,150,1650,NULL,NULL),(8,4,2,2,400,10,80,880,NULL,NULL),(9,5,1,2,500,5,250,5250,NULL,NULL),(10,5,2,10,400,5,200,4200,NULL,NULL);
/*!40000 ALTER TABLE `bill_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cse`
--

DROP TABLE IF EXISTS `cse`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cse` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `NAME` varchar(50) DEFAULT NULL COMMENT 'Client/Supplier or Employee Name',
  `TYPE_ID` int DEFAULT NULL COMMENT 'Client Supplier employee type',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cse`
--

LOCK TABLES `cse` WRITE;
/*!40000 ALTER TABLE `cse` DISABLE KEYS */;
INSERT INTO `cse` VALUES (1,'Client1',200),(2,'Client2',200),(3,'Client3',200),(4,'Client4',200),(5,'Supplier1',201),(6,'Supplier2',201),(7,'Supplier3',201),(8,'Supplier4',201),(9,'Emp1',202),(10,'Emp2',202),(11,'Emp3',202),(12,'Emp4',202),(13,'Emp5',202),(32,'New Client',200),(33,'New Employee',202),(34,'New Supplier',201),(35,'New Supplier',201);
/*!40000 ALTER TABLE `cse` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `make`
--

DROP TABLE IF EXISTS `make`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `make` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `BITM_ID` int unsigned DEFAULT NULL COMMENT 'Order bill id',
  `MAT_JOB_ID` int unsigned DEFAULT NULL COMMENT 'Material ID reference like Fabric/Thread ID or Job Id like cutting/stitching id from TYPE',
  `REQ_QTY` float unsigned DEFAULT NULL COMMENT 'Required to make the product like Fabric 1.3 Meters for shirt',
  `COMP_QTY` float unsigned DEFAULT NULL COMMENT 'Work or Material (Cutting/Fabric) completed/used Quantity details',
  `WAG_AVG_COST` float unsigned DEFAULT NULL COMMENT 'Wage per work or Average Cost of material like cutting 15 Rs | Fabric 110 Rs',
  `MK_TYPE` char(1) DEFAULT NULL COMMENT '''I'' for inventory like fabric/thread and ''W'' for work job like cutting, stitching',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `make`
--

LOCK TABLES `make` WRITE;
/*!40000 ALTER TABLE `make` DISABLE KEYS */;
INSERT INTO `make` VALUES (1,5,1,1.5,1,110,'I'),(2,5,3,2,3,33,'I'),(3,5,11,1,3,12,'O'),(4,5,12,1,3,65,'O'),(5,6,2,1.2,2,220,'I'),(6,6,3,2,2,33,'I'),(7,6,11,1,2,10,'O'),(8,6,12,1,2,55,'O'),(9,9,1,1.5,0,110,'I'),(10,9,3,2,0,33,'I'),(11,9,11,1,0,12,'O'),(12,9,12,1,0,65,'O'),(13,10,2,1.2,0,220,'I'),(14,10,3,2,0,33,'I'),(15,10,11,1,0,10,'O'),(16,10,12,1,0,55,'O');
/*!40000 ALTER TABLE `make` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `material_varient`
--

DROP TABLE IF EXISTS `material_varient`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `material_varient` (
  `MATERIAL_ID` int unsigned DEFAULT NULL COMMENT 'Material ID if material has Varient',
  `NAME` varchar(40) DEFAULT NULL COMMENT 'Varient can be like Color/Size - Black, Orange, yellow, XL, Medium, Large'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `material_varient`
--

LOCK TABLES `material_varient` WRITE;
/*!40000 ALTER TABLE `material_varient` DISABLE KEYS */;
/*!40000 ALTER TABLE `material_varient` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `materials`
--

DROP TABLE IF EXISTS `materials`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `materials` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `NAME` varchar(100) DEFAULT NULL,
  `PRD_CODE` varchar(10) DEFAULT NULL COMMENT 'Code will be generated as per name given if - DINNER TABLE BACK => [ DT-BL ]',
  `UNIT_ID` int unsigned DEFAULT NULL COMMENT 'Kg/Meters/Liters etc unit ID from MST_UNIT',
  `TYPE_ID` int unsigned DEFAULT NULL COMMENT 'Shirt Full/Shirt Half/Pot/Table/Chair - TYPES - decides whether the material is used for all products or any particular products. To calculate quantity stock',
  `SUP_ID` int unsigned DEFAULT NULL COMMENT 'Default Supplier id if purchased and sold Products',
  `AVG_PRICE` float unsigned DEFAULT NULL COMMENT 'Average price as we keep purchaing same items',
  `STOCK_QTY` float DEFAULT NULL COMMENT 'Stock Quantity available',
  `STOCK_LIMIT` float unsigned DEFAULT NULL COMMENT 'Stock limit placed for warning, Expected quantity of stock for maintaining a balance',
  `CR_DATE` date DEFAULT NULL,
  `VAR_FLAG` tinyint DEFAULT NULL COMMENT 'If Varient exists like Size/Color etc - Adds to PROD_VARIENT Table',
  `HSN_SAC` varchar(20) DEFAULT NULL COMMENT '002/537',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `materials`
--

LOCK TABLES `materials` WRITE;
/*!40000 ALTER TABLE `materials` DISABLE KEYS */;
INSERT INTO `materials` VALUES (1,'Fabric White','FW',4,4,5,117.3,30,5,'2022-01-01',0,NULL),(2,'Fabric Red','FR',4,4,6,220,10,10,'2022-01-01',0,NULL),(3,'Thread','TRD',6,7,6,5,100,20,'2022-01-01',0,NULL);
/*!40000 ALTER TABLE `materials` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mst_prod_inv_wrk`
--

DROP TABLE IF EXISTS `mst_prod_inv_wrk`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mst_prod_inv_wrk` (
  `MST_PRD_ID` int unsigned NOT NULL COMMENT 'Master product ID like Shirt Half/Shirt Full/Pot/Pathram/Table/Chair',
  `MST_WRK_INV_ID` int unsigned NOT NULL COMMENT 'Master work / inv id - Fabric/Thread/Scrap/Cutting/Stitching/Ironing',
  `TYPE_ID` char(1) DEFAULT NULL COMMENT 'Inventory / Operations - I or O'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mst_prod_inv_wrk`
--

LOCK TABLES `mst_prod_inv_wrk` WRITE;
/*!40000 ALTER TABLE `mst_prod_inv_wrk` DISABLE KEYS */;
INSERT INTO `mst_prod_inv_wrk` VALUES (4,6,'I'),(4,7,'I'),(4,11,'O'),(4,12,'O'),(5,6,'I'),(5,7,'I'),(5,11,'O'),(5,12,'O');
/*!40000 ALTER TABLE `mst_prod_inv_wrk` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mst_type`
--

DROP TABLE IF EXISTS `mst_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mst_type` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `NAME` varchar(50) DEFAULT NULL,
  `TYPE` varchar(20) DEFAULT NULL COMMENT 'Product/Material/Job Type etc',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=533 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mst_type`
--

LOCK TABLES `mst_type` WRITE;
/*!40000 ALTER TABLE `mst_type` DISABLE KEYS */;
INSERT INTO `mst_type` VALUES (2,'Pot','Product'),(3,'Pathram','Product'),(4,'Shirt Half','Product'),(5,'Shirt Full','Product'),(6,'Fabric','Product'),(7,'Thread','Material'),(8,'Button','Material'),(9,'Circle','Material'),(10,'Scrap','Material'),(11,'Cutting','Work'),(12,'Stitching','Work'),(13,'Ironing','Work'),(14,'Packing','Work'),(15,'CircleMaking','Work'),(16,'Pressing','Work'),(50,'Mass (Weight)','Units'),(51,'Capacity (Liter)','Units'),(52,'Length (Distance)','Units'),(53,'Quantity (Nos)','Units'),(100,'Operations','Cost Type'),(101,'Inventory','Cost Type'),(200,'Client','User Type'),(201,'Supplier','User Type'),(202,'Employee','User Type'),(300,'Purchase','Bill Type'),(301,'Sale','Bill Type'),(302,'Order','Bill Type'),(303,'Make','Bill Type'),(500,'Not Started','Make'),(501,'Work In Progress','Make'),(502,'Completed','Make'),(503,'Delivered','Make'),(510,'In Stock','Inventory'),(511,'Not Available','Inventory');
/*!40000 ALTER TABLE `mst_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mst_units`
--

DROP TABLE IF EXISTS `mst_units`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mst_units` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `UNIT` varchar(50) DEFAULT NULL COMMENT 'Unit like Kg/Meters',
  `TYPE_ID` int unsigned DEFAULT NULL COMMENT 'Type like Distance/capacity/Mass (Quantity) etc',
  `ACTV_UNIT` tinyint DEFAULT NULL COMMENT 'Active unit is true, all units get converted as per this unit',
  `UNIT_CALC` float unsigned DEFAULT NULL COMMENT 'Converted ratio of active unit with othres here. 1 Kg = 1000 Gram',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mst_units`
--

LOCK TABLES `mst_units` WRITE;
/*!40000 ALTER TABLE `mst_units` DISABLE KEYS */;
INSERT INTO `mst_units` VALUES (1,'Kadai',50,0,400),(2,'KG',50,1,1),(4,'Meter',52,1,1),(5,'KiloMeter',52,0,1000),(6,'Nos',53,1,1),(7,'Lilter',51,1,1),(8,'Gram',50,0,1000);
/*!40000 ALTER TABLE `mst_units` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `prod_inv_wrk`
--

DROP TABLE IF EXISTS `prod_inv_wrk`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prod_inv_wrk` (
  `PRD_ID` int unsigned DEFAULT NULL COMMENT 'Product ID like Technical Shirts/Technical Pants/Idli Pathram/Dinner Table etc',
  `INV_WRK_ID` int unsigned DEFAULT NULL COMMENT 'Inventory or work types -> MafatlalRed Fabric/Shirts Thread/Aluminium Sheets/Aluminium Cans/Idli Circle/Cutting/Gluing/stitching/Casting',
  `WAGE_QTY` float DEFAULT NULL COMMENT 'Wage or Qty as per item -> Wage - 65 Rs/100 Rs | Inventory - 1.3 Meters/2 Kadaai etc',
  `TYPE_ID` int unsigned DEFAULT NULL COMMENT 'Inventory / Operations - MST_TYPE'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prod_inv_wrk`
--

LOCK TABLES `prod_inv_wrk` WRITE;
/*!40000 ALTER TABLE `prod_inv_wrk` DISABLE KEYS */;
/*!40000 ALTER TABLE `prod_inv_wrk` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `prod_varient`
--

DROP TABLE IF EXISTS `prod_varient`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prod_varient` (
  `PRODUCT_ID` int unsigned DEFAULT NULL COMMENT 'PROD ID for which have varients',
  `NAME` varchar(40) DEFAULT NULL COMMENT 'Varient can be like Color/Size - Black, Orange, yellow, XL, Medium, Large'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prod_varient`
--

LOCK TABLES `prod_varient` WRITE;
/*!40000 ALTER TABLE `prod_varient` DISABLE KEYS */;
/*!40000 ALTER TABLE `prod_varient` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `products` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `NAME` varchar(100) DEFAULT NULL,
  `PRD_CODE` varchar(10) DEFAULT NULL COMMENT 'Code will be generated as per name given if - DINNER TABLE BACK => [ DT-BL ]',
  `SALES_PRICE` float DEFAULT NULL,
  `UNIT_ID` int unsigned DEFAULT NULL COMMENT 'Kg/Meters/Liters etc unit ID from MST_UNIT',
  `HSN_SAC` varchar(20) DEFAULT NULL COMMENT '002/537',
  `SUP_ID` int unsigned DEFAULT NULL COMMENT 'Default Supplier ID if purchased and sold Products',
  `PUR_PRICE` float unsigned DEFAULT NULL COMMENT 'Purchase price if default vendor exists',
  `TYPE_ID` int unsigned DEFAULT NULL COMMENT 'Shirt Full/Shirt Half/Pot/Table/Chair - TYPES',
  `VAR_FLAG` tinyint unsigned DEFAULT NULL COMMENT 'If Varient exists like Size/Color etc - Adds to PROD_VARIENT Table',
  `STOCK_QTY` float DEFAULT NULL COMMENT 'Stock available currently',
  `CR_DATE` date DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (1,'Casual Shirt Full','CSF',500,6,'01',NULL,NULL,5,0,NULL,NULL),(2,'Casual Shirt Half','CSH',400,6,'01',NULL,NULL,4,0,NULL,NULL);
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `test`
--

DROP TABLE IF EXISTS `test`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `test` (
  `id` int DEFAULT NULL,
  `name` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `test`
--

LOCK TABLES `test` WRITE;
/*!40000 ALTER TABLE `test` DISABLE KEYS */;
INSERT INTO `test` VALUES (1,'Unni'),(2,'Testss'),(3,'Test'),(3,'Hello'),(3,'Test'),(3,'Hello');
/*!40000 ALTER TABLE `test` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-06-17 10:42:56
