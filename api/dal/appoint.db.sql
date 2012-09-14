CREATE DATABASE  IF NOT EXISTS `appointments` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `appointments`;
-- MySQL dump 10.13  Distrib 5.5.9, for osx10.6 (i386)
--
-- Host: localhost    Database: appointments
-- ------------------------------------------------------
-- Server version	5.5.9

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `service_provider`
--

DROP TABLE IF EXISTS `service_provider`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `service_provider` (
  `facebook_id` bigint(20) NOT NULL,
  `category` varchar(512) NOT NULL,
  `name` varchar(512) NOT NULL,
  `description` text,
  `country` varchar(512) DEFAULT NULL,
  `region` varchar(512) DEFAULT NULL,
  `city` varchar(512) DEFAULT NULL,
  `address` varchar(512) DEFAULT NULL,
  `phone` varchar(45) DEFAULT NULL,
  `email` varchar(512) DEFAULT NULL,
  `longitude` decimal(9,6) DEFAULT NULL,
  `latitude` decimal(9,6) DEFAULT NULL,
  PRIMARY KEY (`facebook_id`),
  KEY `idx_service_provider_category` (`category`(255)),
  KEY `idx_service_provider_latitude` (`latitude`),
  KEY `idx_service_provider_longitude` (`longitude`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `service_provider`
--

LOCK TABLES `service_provider` WRITE;
/*!40000 ALTER TABLE `service_provider` DISABLE KEYS */;
INSERT INTO `service_provider` VALUES (11101,'Barber','My Barber Shop','Ohh yeah! Best hair cut','Canada','Qc','Montreal','2222 rue St-Cathrine H3G 1X1','1-514-999-9999','mybarbershop@barber.ca',-73.576851,45.499817);
/*!40000 ALTER TABLE `service_provider` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `appointment`
--

DROP TABLE IF EXISTS `appointment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `appointment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `service_provider_facebook_id` bigint(20) NOT NULL,
  `user_facebook_id` bigint(20) NOT NULL,
  `user_first_name` varchar(512) DEFAULT NULL,
  `user_last_name` varchar(512) DEFAULT NULL,
  `user_email` varchar(512) DEFAULT NULL,
  `start_date` datetime NOT NULL,
  `end_date` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_serviceprovider_appointment_idx` (`service_provider_facebook_id`),
  KEY `idx_appointment_appointment_date` (`start_date`),
  CONSTRAINT `fk_serviceprovider_appointment` FOREIGN KEY (`service_provider_facebook_id`) REFERENCES `service_provider` (`facebook_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `appointment`
--

LOCK TABLES `appointment` WRITE;
/*!40000 ALTER TABLE `appointment` DISABLE KEYS */;
INSERT INTO `appointment` VALUES (1,11101,222222,'Doruk','Vardaryildiz','doruk.vardaryildiz@gmail.com','2012-09-12 00:00:00','2012-09-12 01:00:00');
/*!40000 ALTER TABLE `appointment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'appointments'
--
/*!50003 DROP PROCEDURE IF EXISTS `get_all_appointment` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `get_all_appointment`(p_facebook_id BIGINT)
BEGIN
	SELECT *
	FROM appointment
	WHERE service_provider_facebook_id = p_facebook_id ;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_service_provider` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `get_service_provider`(p_facebook_id BIGINT)
BEGIN
SELECT *
FROM `appointment`.`service_provider`
WHERE facebook_id = p_facebook_id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_weekly_appointment` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `get_weekly_appointment`(p_facebook_id BIGINT,p_weeknumber INT)
BEGIN
	SELECT *
	FROM appointment
	WHERE service_provider_facebook_id = p_facebook_id 
			AND (
					WEEK(start_date) = p_weeknumber 
					AND YEAR(start_date) = YEAR(CURDATE())
				);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `insert_appointment` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `insert_appointment`(p_start_date DATETIME,p_end_date DATETIME ,p_service_provider_facebook_id BIGINT,p_user_email VARCHAR(512),p_user_facebook_id BIGINT,p_user_first_name VARCHAR(512),p_user_last_name VARCHAR(512))
BEGIN
	INSERT INTO appointment(start_date,end_date,service_provider_facebook_id,user_email,user_facebook_id,user_first_name,user_last_name)
	VALUE(p_start_date,p_end_date,p_service_provider_facebook_id,p_user_email,p_user_facebook_id,p_user_first_name,p_user_last_name);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `insert_service_provider` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `insert_service_provider`(p_address VARCHAR(512),p_category VARCHAR(512),p_city VARCHAR(512),p_country VARCHAR(512),p_description TEXT,p_email VARCHAR(512),p_facebook_id BIGINT,p_latitude DECIMAL(9,6),p_longitude DECIMAL(9,6),p_name VARCHAR(512),p_phone VARCHAR(512), p_region VARCHAR(512))
BEGIN
INSERT INTO `appointment`.`service_provider`
(`address`,`category`,`city`,`country`,`description`,`email`,`facebook_id`,`latitude`,`longitude`,`name`,`phone`,`region`)
VALUES
(p_address,p_category,p_city,p_country,p_description,p_email,p_facebook_id,p_latitude,p_longitude,p_name,p_phone,p_region);

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_service_provider` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `update_service_provider`(p_address VARCHAR(512),p_category VARCHAR(512),p_city VARCHAR(512),p_country VARCHAR(512),p_description TEXT,p_email VARCHAR(512),p_facebook_id BIGINT,p_latitude DECIMAL(9,6),p_longitude DECIMAL(9,6),p_name VARCHAR(512),p_phone VARCHAR(512), p_region VARCHAR(512))
BEGIN
UPDATE `appointment`.`service_provider`
SET
`address` = p_address,
`category` = p_category,
`city` = p_city,
`country` = p_country,
`description` = p_description,
`email` = p_email,
`latitude` = p_latitude,
`longitude` = p_longitude,
`name` = p_name,
`phone` = p_phone,
`region` = p_region
WHERE `facebook_id` = p_facebook_id;


END */;;
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

-- Dump completed on 2012-09-14 16:10:52
