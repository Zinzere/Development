-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 22, 2022 at 12:31 PM
-- Server version: 10.4.22-MariaDB
-- PHP Version: 8.1.2

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `mydb`
--

-- --------------------------------------------------------

--
-- Table structure for table `address`
--

CREATE TABLE `address` (
  `ID` int(10) NOT NULL,
  `CSE_ID` int(11) UNSIGNED NOT NULL,
  `NAME` varchar(15) NOT NULL,
  `ADDR_1` varchar(50) NOT NULL,
  `ADDR_2` varchar(50) NOT NULL,
  `CITY` varchar(15) NOT NULL,
  `DISTRICT` varchar(15) NOT NULL,
  `STATE` varchar(15) NOT NULL,
  `EMAIL` varchar(20) NOT NULL,
  `PHONE` bigint(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `address`
--

INSERT INTO `address` (`ID`, `CSE_ID`, `NAME`, `ADDR_1`, `ADDR_2`, `CITY`, `DISTRICT`, `STATE`, `EMAIL`, `PHONE`) VALUES
(1, 3, 'Manu', 'Room 402,green terrace building', 'near so and so', 'koratty', 'thrissur', 'kerala', 'n@g.com', 7689012345),
(2, 10, 'Usha', 'Parakal house,kodar lane,aluva,kerala', 'bridge rd', 'aluva', 'ernakulam', 'kerala', 'g@g.com', 6789012345),
(8, 5, 'Rahul', 'Room 402,green terrace building', 'near so and so', 'koratty', 'thrissur', 'kerala', 'n@g.com', 7689012345),
(9, 8, 'Meera', 'Room 402,green terrace building', 'near so and so', 'koratty', 'thrissur', 'kerala', 'g@g.com', 7689012345),
(10, 2, 'Liya', 'Room 402,green terrace building', 'bridge rd', 'koratty', 'thrissur', 'kerala', 'n@g.com', 6789012345),
(25, 36, 'Anzal', 'thattanpady,alauva', 'karumallor', 'aluva', 'ernakulam', 'kerala', 'k@g.com', 7811231211),
(34, 45, 'arun', 'sr rd', 'kaloor,sn road', 'kaloor', 'kottayam', 'kerala', 'a@g.com', 8907890678),
(35, 46, 'shahul', 'gdfd', 'gdcg', 'kochi', 'kanur', 'kerala', 's@g.com', 7890009090),
(36, 47, 'ddv', 'vc', ' c', 'vcv', 'vc', 'c c', 'vc', 0),
(37, 48, 'grf', 'bn', 'bvb', 'bvc', 'bvc', 'b cv', 'v c', 0);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `address`
--
ALTER TABLE `address`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `CSE_ID_FK` (`CSE_ID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `address`
--
ALTER TABLE `address`
  MODIFY `ID` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=38;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
