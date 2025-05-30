-- MySQL dump 10.13  Distrib 8.0.40, for Win64 (x86_64)
--
-- Host: localhost    Database: info_db
-- ------------------------------------------------------
-- Server version	8.0.40

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
-- Table structure for table `contact_log`
--

DROP TABLE IF EXISTS `contact_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contact_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `logged_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contact_log`
--

LOCK TABLES `contact_log` WRITE;
/*!40000 ALTER TABLE `contact_log` DISABLE KEYS */;
INSERT INTO `contact_log` VALUES (1,'Leo','2025-05-30 04:58:04');
/*!40000 ALTER TABLE `contact_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contact_messages`
--

DROP TABLE IF EXISTS `contact_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contact_messages` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `email` varchar(255) NOT NULL,
  `message` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contact_messages`
--

LOCK TABLES `contact_messages` WRITE;
/*!40000 ALTER TABLE `contact_messages` DISABLE KEYS */;
INSERT INTO `contact_messages` VALUES (1,'Fahad Rafaqat','fahadrafaqat9@gmail.com','3wyey3q37q3q73q'),(2,'Fahad Rafaqat','fahadrafaqat342@gmail.com','it\'s working'),(3,'Fahad Rafaqat','fahadrafaqat97@gmail.com','working'),(4,'Fahad Rafaqat','pmon3209@gmail.com','all done'),(5,'Leo','Leo97@gmail.com','Nice one!');
/*!40000 ALTER TABLE `contact_messages` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `after_contact_insert` AFTER INSERT ON `contact_messages` FOR EACH ROW BEGIN
    INSERT INTO contact_log (name)
    VALUES (NEW.name);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `newsletter_subscription`
--

DROP TABLE IF EXISTS `newsletter_subscription`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `newsletter_subscription` (
  `id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `newsletter_subscription`
--

LOCK TABLES `newsletter_subscription` WRITE;
/*!40000 ALTER TABLE `newsletter_subscription` DISABLE KEYS */;
INSERT INTO `newsletter_subscription` VALUES (2,'fahadrafaqat342@gmail.com'),(1,'fahadrafaqat9@gmail.com'),(3,'fahadrafaqat97@gmail.com'),(7,'leo@gmail.com'),(4,'pmon3209@gmail.com'),(6,'rao125@gmail.com');
/*!40000 ALTER TABLE `newsletter_subscription` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orderproduct`
--

DROP TABLE IF EXISTS `orderproduct`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orderproduct` (
  `order_id` int NOT NULL,
  `product_id` int NOT NULL,
  `quantity` int DEFAULT '1',
  PRIMARY KEY (`order_id`,`product_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `orderproduct_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
  CONSTRAINT `orderproduct_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orderproduct`
--

LOCK TABLES `orderproduct` WRITE;
/*!40000 ALTER TABLE `orderproduct` DISABLE KEYS */;
/*!40000 ALTER TABLE `orderproduct` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `id` int NOT NULL AUTO_INCREMENT,
  `items` text NOT NULL,
  `total` float NOT NULL,
  `timestamp` datetime DEFAULT NULL,
  `status` varchar(50) DEFAULT 'Pending',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (1,'{\"1\":{\"name\":\"Reusable Bags\",\"price\":10,\"quantity\":2},\"5\":{\"name\":\"Reusable Bottles\",\"price\":12,\"quantity\":4}}',68,'2025-04-23 21:23:39','Fulfilled'),(2,'{\"4\":{\"name\":\"Eco-friendly Straws\",\"price\":8,\"quantity\":3},\"7\":{\"name\":\"Bamboo Toothbrush\",\"price\":5,\"quantity\":2}}',34,'2025-04-23 21:25:20','Fulfilled'),(3,'{\"2\":{\"name\":\"Bamboo Utensils\",\"price\":13,\"quantity\":3}}',39,'2025-05-01 13:03:39','Fulfilled'),(4,'{\"2\":{\"name\":\"Bamboo Utensils\",\"price\":13,\"quantity\":1},\"5\":{\"name\":\"Reusable Bottles\",\"price\":12,\"quantity\":1},\"6\":{\"name\":\"Organic Towels\",\"price\":20,\"quantity\":1}}',45,'2025-05-27 06:21:40','Fulfilled'),(5,'{\"7\":{\"name\":\"Bamboo Toothbrush\",\"price\":5,\"quantity\":2},\"9\":{\"name\":\"Solar Lamp\",\"price\":18,\"quantity\":1}}',28,'2025-05-27 07:48:23','Fulfilled'),(6,'{\"4\":{\"name\":\"Eco-friendly Straws\",\"price\":8,\"quantity\":1},\"6\":{\"name\":\"Organic Towels\",\"price\":20,\"quantity\":1}}',28,'2025-05-27 07:48:34','Fulfilled'),(7,'{\"11\":{\"name\":\"aaaa\",\"price\":10,\"quantity\":4}}',40,'2025-05-27 14:03:41','Fulfilled'),(8,'{\"1\":{\"name\":\"Reusable Bags\",\"price\":10,\"quantity\":1},\"3\":{\"name\":\"Biodegradable Packaging\",\"price\":15,\"quantity\":1}}',25,'2025-05-29 19:09:53','Fulfilled');
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product`
--

DROP TABLE IF EXISTS `product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `price` float NOT NULL,
  `image_url` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product`
--

LOCK TABLES `product` WRITE;
/*!40000 ALTER TABLE `product` DISABLE KEYS */;
INSERT INTO `product` VALUES (1,'Reusable Bags','Eco-friendly bags designed to reduce plastic waste, made from durable materials suitable for shopping and storage.',10,'images/bag.jpeg'),(2,'Bamboo Utensils','Sustainable and stylish bamboo-based utensils for everyday use, perfect for eco-conscious individuals looking to minimize plastic waste.',13,'images/utensils.jpeg'),(3,'Biodegradable Packaging','Environmentally-friendly packaging solutions made from biodegradable materials, offering an alternative to traditional plastic packaging.',15,'images/packaging.jpeg'),(4,'Eco-friendly Straws','Reusable and sustainable straws made from bamboo, stainless steel, and other eco-friendly materials.',8,'images/straws.jpeg'),(5,'Reusable Bottles','Stainless steel and BPA-free bottles to keep your drinks hot or cold while reducing plastic waste.',12,'images/bottles.jpeg'),(6,'Organic Towels','Soft, absorbent towels made from organic cotton, free of harmful chemicals and dyes.',20,'images/towels.jpeg'),(7,'Bamboo Toothbrush','Eco-friendly bamboo toothbrush with biodegradable bristles for a sustainable dental care routine.',5,'images/brush.jpeg'),(8,'Recycled Paper Notebooks','Notebooks made from recycled paper, an excellent alternative to traditional paper products.',7,'images/book.jpeg'),(9,'Solar Lamp','Charge during the day and illuminate your space at night with an eco-friendly solar-powered lamp.',18,'images/lamp.jpeg');
/*!40000 ALTER TABLE `product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(100) NOT NULL,
  `email` varchar(120) NOT NULL,
  `password_hash` varchar(512) DEFAULT NULL,
  `is_admin` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'admin','fahad@admin.com','scrypt:32768:8:1$eDFxyIsTg77CZgSv$0492e221204a22a8fc56083d5b3f7c42eb6d7d56aefab2ebd53c2e9b9edc87590ad70482b623b58ceb319d24f49870053517aca21ee3f3e5e74291bc7545b77c',1);
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'info_db'
--
/*!50003 DROP PROCEDURE IF EXISTS `mark_all_orders_fulfilled` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `mark_all_orders_fulfilled`()
BEGIN
    UPDATE orders SET status = 'Fulfilled' WHERE status != 'Fulfilled';
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-05-30  5:12:42
