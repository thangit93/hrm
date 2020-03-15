-- MySQL dump 10.13  Distrib 5.5.61-38.13, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: icehrm
-- ------------------------------------------------------
-- Server version	5.5.61-38.13

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
-- Table structure for table `Applications`
--

DROP TABLE IF EXISTS `Applications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Applications` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `job` bigint(20) NOT NULL,
  `candidate` bigint(20) DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `referredByEmail` varchar(200) DEFAULT NULL,
  `notes` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `job` (`job`,`candidate`),
  KEY `Fk_Applications_Candidates` (`candidate`),
  CONSTRAINT `Fk_Applications_Candidates` FOREIGN KEY (`candidate`) REFERENCES `Candidates` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Fk_Applications_Job` FOREIGN KEY (`job`) REFERENCES `Job` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Applications`
--

LOCK TABLES `Applications` WRITE;
/*!40000 ALTER TABLE `Applications` DISABLE KEYS */;
/*!40000 ALTER TABLE `Applications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ArchivedEmployees`
--

DROP TABLE IF EXISTS `ArchivedEmployees`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ArchivedEmployees` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `ref_id` bigint(20) NOT NULL,
  `employee_id` varchar(50) DEFAULT NULL,
  `first_name` varchar(100) NOT NULL DEFAULT '',
  `last_name` varchar(100) NOT NULL DEFAULT '',
  `gender` enum('Male','Female') DEFAULT NULL,
  `ssn_num` varchar(100) DEFAULT '',
  `nic_num` varchar(100) DEFAULT '',
  `other_id` varchar(100) DEFAULT '',
  `work_email` varchar(100) DEFAULT NULL,
  `joined_date` datetime DEFAULT NULL,
  `confirmation_date` datetime DEFAULT NULL,
  `supervisor` bigint(20) DEFAULT NULL,
  `department` bigint(20) DEFAULT NULL,
  `termination_date` datetime DEFAULT NULL,
  `notes` text,
  `data` longtext,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ArchivedEmployees`
--

LOCK TABLES `ArchivedEmployees` WRITE;
/*!40000 ALTER TABLE `ArchivedEmployees` DISABLE KEYS */;
/*!40000 ALTER TABLE `ArchivedEmployees` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `AssetTypes`
--

DROP TABLE IF EXISTS `AssetTypes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `AssetTypes` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(35) NOT NULL,
  `description` text,
  `attachment` varchar(100) DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `updated` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `AssetTypes`
--

LOCK TABLES `AssetTypes` WRITE;
/*!40000 ALTER TABLE `AssetTypes` DISABLE KEYS */;
/*!40000 ALTER TABLE `AssetTypes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Attendance`
--

DROP TABLE IF EXISTS `Attendance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Attendance` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `employee` bigint(20) NOT NULL,
  `in_time` datetime DEFAULT NULL,
  `out_time` datetime DEFAULT NULL,
  `note` varchar(500) DEFAULT NULL,
  `image_in` longtext,
  `image_out` longtext,
  `map_lat` decimal(10,8) DEFAULT NULL,
  `map_lng` decimal(10,8) DEFAULT NULL,
  `map_snapshot` longtext,
  `map_out_lat` decimal(10,8) DEFAULT NULL,
  `map_out_lng` decimal(10,8) DEFAULT NULL,
  `map_out_snapshot` longtext,
  `in_ip` varchar(25) DEFAULT NULL,
  `out_ip` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `in_time` (`in_time`),
  KEY `out_time` (`out_time`),
  KEY `employee_in_time` (`employee`,`in_time`),
  KEY `employee_out_time` (`employee`,`out_time`),
  CONSTRAINT `Fk_Attendance_Employee` FOREIGN KEY (`employee`) REFERENCES `Employees` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Attendance`
--

LOCK TABLES `Attendance` WRITE;
/*!40000 ALTER TABLE `Attendance` DISABLE KEYS */;
/*!40000 ALTER TABLE `Attendance` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `AuditLog`
--

DROP TABLE IF EXISTS `AuditLog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `AuditLog` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `user` bigint(20) NOT NULL,
  `ip` varchar(100) DEFAULT NULL,
  `type` varchar(100) NOT NULL,
  `employee` varchar(300) DEFAULT NULL,
  `details` text,
  PRIMARY KEY (`id`),
  KEY `Fk_AuditLog_Users` (`user`),
  CONSTRAINT `Fk_AuditLog_Users` FOREIGN KEY (`user`) REFERENCES `Users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `AuditLog`
--

LOCK TABLES `AuditLog` WRITE;
/*!40000 ALTER TABLE `AuditLog` DISABLE KEYS */;
/*!40000 ALTER TABLE `AuditLog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Benifits`
--

DROP TABLE IF EXISTS `Benifits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Benifits` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(250) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Benifits`
--

LOCK TABLES `Benifits` WRITE;
/*!40000 ALTER TABLE `Benifits` DISABLE KEYS */;
INSERT INTO `Benifits` VALUES (1,'Retirement plan'),(2,'Health plan'),(3,'Life insurance'),(4,'Paid vacations');
/*!40000 ALTER TABLE `Benifits` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Calls`
--

DROP TABLE IF EXISTS `Calls`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Calls` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `job` bigint(20) NOT NULL,
  `candidate` bigint(20) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `updated` datetime DEFAULT NULL,
  `status` varchar(100) DEFAULT NULL,
  `notes` text,
  PRIMARY KEY (`id`),
  KEY `Fk_Calls_Job` (`job`),
  KEY `Fk_Calls_Candidates` (`candidate`),
  CONSTRAINT `Fk_Calls_Candidates` FOREIGN KEY (`candidate`) REFERENCES `Candidates` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Fk_Calls_Job` FOREIGN KEY (`job`) REFERENCES `Job` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Calls`
--

LOCK TABLES `Calls` WRITE;
/*!40000 ALTER TABLE `Calls` DISABLE KEYS */;
/*!40000 ALTER TABLE `Calls` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Candidates`
--

DROP TABLE IF EXISTS `Candidates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Candidates` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(100) NOT NULL DEFAULT '',
  `last_name` varchar(100) NOT NULL DEFAULT '',
  `nationality` bigint(20) DEFAULT NULL,
  `birthday` datetime DEFAULT NULL,
  `gender` enum('Male','Female') DEFAULT NULL,
  `marital_status` enum('Married','Single','Divorced','Widowed','Other') DEFAULT NULL,
  `address1` varchar(100) DEFAULT '',
  `address2` varchar(100) DEFAULT '',
  `city` varchar(150) DEFAULT '',
  `country` char(2) DEFAULT NULL,
  `province` bigint(20) DEFAULT NULL,
  `postal_code` varchar(20) DEFAULT NULL,
  `email` varchar(200) DEFAULT NULL,
  `home_phone` varchar(50) DEFAULT NULL,
  `mobile_phone` varchar(50) DEFAULT NULL,
  `cv_title` varchar(200) NOT NULL DEFAULT '',
  `cv` varchar(150) DEFAULT NULL,
  `cvtext` text,
  `industry` text,
  `profileImage` varchar(150) DEFAULT NULL,
  `head_line` text,
  `objective` text,
  `work_history` text,
  `education` text,
  `skills` text,
  `referees` text,
  `linkedInUrl` varchar(500) DEFAULT NULL,
  `linkedInData` text,
  `totalYearsOfExperience` int(11) DEFAULT NULL,
  `totalMonthsOfExperience` int(11) DEFAULT NULL,
  `htmlCVData` longtext,
  `generatedCVFile` varchar(150) DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `updated` datetime DEFAULT NULL,
  `expectedSalary` int(11) DEFAULT NULL,
  `preferedPositions` text,
  `preferedJobtype` varchar(60) DEFAULT NULL,
  `preferedCountries` text,
  `tags` text,
  `notes` text,
  `calls` text,
  `age` int(11) DEFAULT NULL,
  `hash` varchar(100) DEFAULT NULL,
  `linkedInProfileLink` varchar(250) DEFAULT NULL,
  `linkedInProfileId` varchar(50) DEFAULT NULL,
  `facebookProfileLink` varchar(250) DEFAULT NULL,
  `facebookProfileId` varchar(50) DEFAULT NULL,
  `twitterProfileLink` varchar(250) DEFAULT NULL,
  `twitterProfileId` varchar(50) DEFAULT NULL,
  `googleProfileLink` varchar(250) DEFAULT NULL,
  `googleProfileId` varchar(50) DEFAULT NULL,
  `hiringStage` bigint(20) DEFAULT NULL,
  `jobId` bigint(20) DEFAULT NULL,
  `source` enum('Sourced','Applied') DEFAULT 'Sourced',
  `emailSent` int(11) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `source_emailSent` (`source`,`emailSent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Candidates`
--

LOCK TABLES `Candidates` WRITE;
/*!40000 ALTER TABLE `Candidates` DISABLE KEYS */;
/*!40000 ALTER TABLE `Candidates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Certifications`
--

DROP TABLE IF EXISTS `Certifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Certifications` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `description` varchar(400) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Certifications`
--

LOCK TABLES `Certifications` WRITE;
/*!40000 ALTER TABLE `Certifications` DISABLE KEYS */;
INSERT INTO `Certifications` VALUES (1,'Red Hat Certified Architect (RHCA)','Red Hat Certified Architect (RHCA)'),(2,'GIAC Secure Software Programmer -Java','GIAC Secure Software Programmer -Java'),(3,'Risk Management Professional (PMI)','Risk Management Professional (PMI)'),(4,'IT Infrastructure Library (ITIL) Expert Certification','IT Infrastructure Library (ITIL) Expert Certification'),(5,'Microsoft Certified Architect','Microsoft Certified Architect'),(6,'Oracle Exadata 11g Certified Implementation Specialist','Oracle Exadata 11g Certified Implementation Specialist'),(7,'Cisco Certified Design Professional (CCDP)','Cisco Certified Design Professional (CCDP)'),(8,'Cisco Certified Internetwork Expert (CCIE)','Cisco Certified Internetwork Expert (CCIE)'),(9,'Cisco Certified Network Associate','Cisco Certified Network Associate'),(10,'HP/Master Accredited Solutions Expert (MASE)','HP/Master Accredited Solutions Expert (MASE)'),(11,'HP/Master Accredited Systems Engineer (Master ASE)','HP/Master Accredited Systems Engineer (Master ASE)'),(12,'Certified Information Security Manager (CISM)','Certified Information Security Manager (CISM)'),(13,'Certified Information Systems Auditor (CISA)','Certified Information Systems Auditor (CISA)'),(14,'CyberSecurity Forensic Analyst (CSFA)','CyberSecurity Forensic Analyst (CSFA)'),(15,'Open Group Certified Architect (OpenCA)','Open Group Certified Architect (OpenCA)'),(16,'Oracle DBA Administrator Certified Master OCM','Oracle DBA Administrator Certified Master OCM'),(17,'Project Management Professional','Project Management Professional'),(18,'Apple Certified Support Professional','Apple Certified Support Professional'),(19,'Certified Public Accountant (CPA)','Certified Public Accountant (CPA)'),(20,'Chartered Financial Analyst','Chartered Financial Analyst'),(21,'Professional in Human Resources (PHR)','Professional in Human Resources (PHR)');
/*!40000 ALTER TABLE `Certifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Clients`
--

DROP TABLE IF EXISTS `Clients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Clients` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `details` text,
  `first_contact_date` date DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `address` text,
  `contact_number` varchar(25) DEFAULT NULL,
  `contact_email` varchar(100) DEFAULT NULL,
  `company_url` varchar(500) DEFAULT NULL,
  `status` enum('Active','Inactive') DEFAULT 'Active',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Clients`
--

LOCK TABLES `Clients` WRITE;
/*!40000 ALTER TABLE `Clients` DISABLE KEYS */;
INSERT INTO `Clients` VALUES (1,'IceHrm Sample Client 1',NULL,'2012-01-04','2013-01-03 05:47:33','001, Sample Road,\nSample City, USA','678-894-1047','icehrm+client1@web-stalk.com','http://icehrm.com','Active'),(2,'IceHrm Sample Client 2',NULL,'2012-01-04','2013-01-03 05:47:33','001, Sample Road,\nSample City, USA','678-894-1047','icehrm+client1@web-stalk.com','http://icehrm.com','Active'),(3,'IceHrm Sample Client 3',NULL,'2012-01-04','2013-01-03 05:47:33','001, Sample Road,\nSample City, USA','678-894-1047','icehrm+client1@web-stalk.com','http://icehrm.com','Active');
/*!40000 ALTER TABLE `Clients` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CompanyAssets`
--

DROP TABLE IF EXISTS `CompanyAssets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `CompanyAssets` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `code` varchar(30) NOT NULL,
  `type` bigint(20) DEFAULT NULL,
  `attachment` varchar(100) DEFAULT NULL,
  `employee` bigint(20) DEFAULT NULL,
  `department` bigint(20) DEFAULT NULL,
  `description` text,
  `created` datetime DEFAULT NULL,
  `updated` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `Fk_CompanyAssets_AssetTypes` (`type`),
  KEY `Fk_CompanyAssets_Employees` (`employee`),
  KEY `Fk_CompanyAssets_CompanyStructures` (`department`),
  CONSTRAINT `Fk_CompanyAssets_AssetTypes` FOREIGN KEY (`type`) REFERENCES `AssetTypes` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `Fk_CompanyAssets_CompanyStructures` FOREIGN KEY (`department`) REFERENCES `CompanyStructures` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `Fk_CompanyAssets_Employees` FOREIGN KEY (`employee`) REFERENCES `Employees` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CompanyAssets`
--

LOCK TABLES `CompanyAssets` WRITE;
/*!40000 ALTER TABLE `CompanyAssets` DISABLE KEYS */;
/*!40000 ALTER TABLE `CompanyAssets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CompanyDocuments`
--

DROP TABLE IF EXISTS `CompanyDocuments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `CompanyDocuments` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `details` text,
  `valid_until` date DEFAULT NULL,
  `status` enum('Active','Inactive','Draft') DEFAULT 'Active',
  `notify_employees` enum('Yes','No') DEFAULT 'Yes',
  `attachment` varchar(100) DEFAULT NULL,
  `share_departments` varchar(100) DEFAULT NULL,
  `share_employees` varchar(100) DEFAULT NULL,
  `share_userlevel` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CompanyDocuments`
--

LOCK TABLES `CompanyDocuments` WRITE;
/*!40000 ALTER TABLE `CompanyDocuments` DISABLE KEYS */;
/*!40000 ALTER TABLE `CompanyDocuments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CompanyLoans`
--

DROP TABLE IF EXISTS `CompanyLoans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `CompanyLoans` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `details` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CompanyLoans`
--

LOCK TABLES `CompanyLoans` WRITE;
/*!40000 ALTER TABLE `CompanyLoans` DISABLE KEYS */;
INSERT INTO `CompanyLoans` VALUES (1,'Personal loan','Personal loans'),(2,'Educational loan','Educational loan');
/*!40000 ALTER TABLE `CompanyLoans` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CompanyStructures`
--

DROP TABLE IF EXISTS `CompanyStructures`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `CompanyStructures` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `title` tinytext NOT NULL,
  `description` text NOT NULL,
  `address` text,
  `type` enum('Company','Head Office','Regional Office','Department','Unit','Sub Unit','Other') DEFAULT NULL,
  `country` varchar(2) NOT NULL DEFAULT '0',
  `parent` bigint(20) DEFAULT NULL,
  `timezone` varchar(100) NOT NULL DEFAULT 'Europe/London',
  `heads` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `Fk_CompanyStructures_Own` (`parent`),
  CONSTRAINT `Fk_CompanyStructures_Own` FOREIGN KEY (`parent`) REFERENCES `CompanyStructures` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CompanyStructures`
--

LOCK TABLES `CompanyStructures` WRITE;
/*!40000 ALTER TABLE `CompanyStructures` DISABLE KEYS */;
INSERT INTO `CompanyStructures` VALUES (1,'Y Viá»‡t','Y Viá»‡t','','Company','VN',NULL,'Asia/Ho_Chi_Minh','[\"1\"]');
/*!40000 ALTER TABLE `CompanyStructures` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ConversationUserStatus`
--

DROP TABLE IF EXISTS `ConversationUserStatus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ConversationUserStatus` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `employee` bigint(20) NOT NULL,
  `status` varchar(15) DEFAULT NULL,
  `seen_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `KEY_ConversationLastSeen_employee` (`employee`),
  KEY `KEY_ConversationLastSeen_seen_at` (`seen_at`),
  KEY `KEY_ConversationLastSeen_status` (`seen_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ConversationUserStatus`
--

LOCK TABLES `ConversationUserStatus` WRITE;
/*!40000 ALTER TABLE `ConversationUserStatus` DISABLE KEYS */;
/*!40000 ALTER TABLE `ConversationUserStatus` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Conversations`
--

DROP TABLE IF EXISTS `Conversations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Conversations` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `message` longtext NOT NULL,
  `type` varchar(35) NOT NULL,
  `attachment` varchar(100) DEFAULT NULL,
  `employee` bigint(20) NOT NULL,
  `target` bigint(20) DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `updated` datetime DEFAULT NULL,
  `timeint` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `KEY_Conversations_attachment` (`attachment`),
  KEY `KEY_Conversations_type` (`type`),
  KEY `KEY_Conversations_employee` (`employee`),
  KEY `KEY_Conversations_target` (`target`),
  KEY `KEY_Conversations_target_type` (`target`,`type`),
  KEY `KEY_Conversations_timeint` (`timeint`),
  KEY `KEY_Conversations_timeint_type` (`timeint`,`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Conversations`
--

LOCK TABLES `Conversations` WRITE;
/*!40000 ALTER TABLE `Conversations` DISABLE KEYS */;
/*!40000 ALTER TABLE `Conversations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Country`
--

DROP TABLE IF EXISTS `Country`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Country` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `code` char(2) NOT NULL DEFAULT '',
  `namecap` varchar(80) DEFAULT '',
  `name` varchar(80) NOT NULL DEFAULT '',
  `iso3` char(3) DEFAULT NULL,
  `numcode` smallint(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=240 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Country`
--

LOCK TABLES `Country` WRITE;
/*!40000 ALTER TABLE `Country` DISABLE KEYS */;
INSERT INTO `Country` VALUES (1,'AF','AFGHANISTAN','Afghanistan','AFG',4),(2,'AL','ALBANIA','Albania','ALB',8),(3,'DZ','ALGERIA','Algeria','DZA',12),(4,'AS','AMERICAN SAMOA','American Samoa','ASM',16),(5,'AD','ANDORRA','Andorra','AND',20),(6,'AO','ANGOLA','Angola','AGO',24),(7,'AI','ANGUILLA','Anguilla','AIA',660),(8,'AQ','ANTARCTICA','Antarctica',NULL,NULL),(9,'AG','ANTIGUA AND BARBUDA','Antigua and Barbuda','ATG',28),(10,'AR','ARGENTINA','Argentina','ARG',32),(11,'AM','ARMENIA','Armenia','ARM',51),(12,'AW','ARUBA','Aruba','ABW',533),(13,'AU','AUSTRALIA','Australia','AUS',36),(14,'AT','AUSTRIA','Austria','AUT',40),(15,'AZ','AZERBAIJAN','Azerbaijan','AZE',31),(16,'BS','BAHAMAS','Bahamas','BHS',44),(17,'BH','BAHRAIN','Bahrain','BHR',48),(18,'BD','BANGLADESH','Bangladesh','BGD',50),(19,'BB','BARBADOS','Barbados','BRB',52),(20,'BY','BELARUS','Belarus','BLR',112),(21,'BE','BELGIUM','Belgium','BEL',56),(22,'BZ','BELIZE','Belize','BLZ',84),(23,'BJ','BENIN','Benin','BEN',204),(24,'BM','BERMUDA','Bermuda','BMU',60),(25,'BT','BHUTAN','Bhutan','BTN',64),(26,'BO','BOLIVIA','Bolivia','BOL',68),(27,'BA','BOSNIA AND HERZEGOVINA','Bosnia and Herzegovina','BIH',70),(28,'BW','BOTSWANA','Botswana','BWA',72),(29,'BV','BOUVET ISLAND','Bouvet Island',NULL,NULL),(30,'BR','BRAZIL','Brazil','BRA',76),(31,'IO','BRITISH INDIAN OCEAN TERRITORY','British Indian Ocean Territory',NULL,NULL),(32,'BN','BRUNEI DARUSSALAM','Brunei Darussalam','BRN',96),(33,'BG','BULGARIA','Bulgaria','BGR',100),(34,'BF','BURKINA FASO','Burkina Faso','BFA',854),(35,'BI','BURUNDI','Burundi','BDI',108),(36,'KH','CAMBODIA','Cambodia','KHM',116),(37,'CM','CAMEROON','Cameroon','CMR',120),(38,'CA','CANADA','Canada','CAN',124),(39,'CV','CAPE VERDE','Cape Verde','CPV',132),(40,'KY','CAYMAN ISLANDS','Cayman Islands','CYM',136),(41,'CF','CENTRAL AFRICAN REPUBLIC','Central African Republic','CAF',140),(42,'TD','CHAD','Chad','TCD',148),(43,'CL','CHILE','Chile','CHL',152),(44,'CN','CHINA','China','CHN',156),(45,'CX','CHRISTMAS ISLAND','Christmas Island',NULL,NULL),(46,'CC','COCOS (KEELING) ISLANDS','Cocos (Keeling) Islands',NULL,NULL),(47,'CO','COLOMBIA','Colombia','COL',170),(48,'KM','COMOROS','Comoros','COM',174),(49,'CG','CONGO','Congo','COG',178),(50,'CD','CONGO, THE DEMOCRATIC REPUBLIC OF THE','Congo, the Democratic Republic of the','COD',180),(51,'CK','COOK ISLANDS','Cook Islands','COK',184),(52,'CR','COSTA RICA','Costa Rica','CRI',188),(53,'CI','COTE D\'IVOIRE','Cote D\'Ivoire','CIV',384),(54,'HR','CROATIA','Croatia','HRV',191),(55,'CU','CUBA','Cuba','CUB',192),(56,'CY','CYPRUS','Cyprus','CYP',196),(57,'CZ','CZECH REPUBLIC','Czech Republic','CZE',203),(58,'DK','DENMARK','Denmark','DNK',208),(59,'DJ','DJIBOUTI','Djibouti','DJI',262),(60,'DM','DOMINICA','Dominica','DMA',212),(61,'DO','DOMINICAN REPUBLIC','Dominican Republic','DOM',214),(62,'EC','ECUADOR','Ecuador','ECU',218),(63,'EG','EGYPT','Egypt','EGY',818),(64,'SV','EL SALVADOR','El Salvador','SLV',222),(65,'GQ','EQUATORIAL GUINEA','Equatorial Guinea','GNQ',226),(66,'ER','ERITREA','Eritrea','ERI',232),(67,'EE','ESTONIA','Estonia','EST',233),(68,'ET','ETHIOPIA','Ethiopia','ETH',231),(69,'FK','FALKLAND ISLANDS (MALVINAS)','Falkland Islands (Malvinas)','FLK',238),(70,'FO','FAROE ISLANDS','Faroe Islands','FRO',234),(71,'FJ','FIJI','Fiji','FJI',242),(72,'FI','FINLAND','Finland','FIN',246),(73,'FR','FRANCE','France','FRA',250),(74,'GF','FRENCH GUIANA','French Guiana','GUF',254),(75,'PF','FRENCH POLYNESIA','French Polynesia','PYF',258),(76,'TF','FRENCH SOUTHERN TERRITORIES','French Southern Territories',NULL,NULL),(77,'GA','GABON','Gabon','GAB',266),(78,'GM','GAMBIA','Gambia','GMB',270),(79,'GE','GEORGIA','Georgia','GEO',268),(80,'DE','GERMANY','Germany','DEU',276),(81,'GH','GHANA','Ghana','GHA',288),(82,'GI','GIBRALTAR','Gibraltar','GIB',292),(83,'GR','GREECE','Greece','GRC',300),(84,'GL','GREENLAND','Greenland','GRL',304),(85,'GD','GRENADA','Grenada','GRD',308),(86,'GP','GUADELOUPE','Guadeloupe','GLP',312),(87,'GU','GUAM','Guam','GUM',316),(88,'GT','GUATEMALA','Guatemala','GTM',320),(89,'GN','GUINEA','Guinea','GIN',324),(90,'GW','GUINEA-BISSAU','Guinea-Bissau','GNB',624),(91,'GY','GUYANA','Guyana','GUY',328),(92,'HT','HAITI','Haiti','HTI',332),(93,'HM','HEARD ISLAND AND MCDONALD ISLANDS','Heard Island and Mcdonald Islands',NULL,NULL),(94,'VA','HOLY SEE (VATICAN CITY STATE)','Holy See (Vatican City State)','VAT',336),(95,'HN','HONDURAS','Honduras','HND',340),(96,'HK','HONG KONG','Hong Kong','HKG',344),(97,'HU','HUNGARY','Hungary','HUN',348),(98,'IS','ICELAND','Iceland','ISL',352),(99,'IN','INDIA','India','IND',356),(100,'ID','INDONESIA','Indonesia','IDN',360),(101,'IR','IRAN, ISLAMIC REPUBLIC OF','Iran, Islamic Republic of','IRN',364),(102,'IQ','IRAQ','Iraq','IRQ',368),(103,'IE','IRELAND','Ireland','IRL',372),(104,'IL','ISRAEL','Israel','ISR',376),(105,'IT','ITALY','Italy','ITA',380),(106,'JM','JAMAICA','Jamaica','JAM',388),(107,'JP','JAPAN','Japan','JPN',392),(108,'JO','JORDAN','Jordan','JOR',400),(109,'KZ','KAZAKHSTAN','Kazakhstan','KAZ',398),(110,'KE','KENYA','Kenya','KEN',404),(111,'KI','KIRIBATI','Kiribati','KIR',296),(112,'KP','KOREA, DEMOCRATIC PEOPLE\'S REPUBLIC OF','Korea, Democratic People\'s Republic of','PRK',408),(113,'KR','KOREA, REPUBLIC OF','Korea, Republic of','KOR',410),(114,'KW','KUWAIT','Kuwait','KWT',414),(115,'KG','KYRGYZSTAN','Kyrgyzstan','KGZ',417),(116,'LA','LAO PEOPLE\'S DEMOCRATIC REPUBLIC','Lao People\'s Democratic Republic','LAO',418),(117,'LV','LATVIA','Latvia','LVA',428),(118,'LB','LEBANON','Lebanon','LBN',422),(119,'LS','LESOTHO','Lesotho','LSO',426),(120,'LR','LIBERIA','Liberia','LBR',430),(121,'LY','LIBYAN ARAB JAMAHIRIYA','Libyan Arab Jamahiriya','LBY',434),(122,'LI','LIECHTENSTEIN','Liechtenstein','LIE',438),(123,'LT','LITHUANIA','Lithuania','LTU',440),(124,'LU','LUXEMBOURG','Luxembourg','LUX',442),(125,'MO','MACAO','Macao','MAC',446),(126,'MK','MACEDONIA, THE FORMER YUGOSLAV REPUBLIC OF','Macedonia, the Former Yugoslav Republic of','MKD',807),(127,'MG','MADAGASCAR','Madagascar','MDG',450),(128,'MW','MALAWI','Malawi','MWI',454),(129,'MY','MALAYSIA','Malaysia','MYS',458),(130,'MV','MALDIVES','Maldives','MDV',462),(131,'ML','MALI','Mali','MLI',466),(132,'MT','MALTA','Malta','MLT',470),(133,'MH','MARSHALL ISLANDS','Marshall Islands','MHL',584),(134,'MQ','MARTINIQUE','Martinique','MTQ',474),(135,'MR','MAURITANIA','Mauritania','MRT',478),(136,'MU','MAURITIUS','Mauritius','MUS',480),(137,'YT','MAYOTTE','Mayotte',NULL,NULL),(138,'MX','MEXICO','Mexico','MEX',484),(139,'FM','MICRONESIA, FEDERATED STATES OF','Micronesia, Federated States of','FSM',583),(140,'MD','MOLDOVA, REPUBLIC OF','Moldova, Republic of','MDA',498),(141,'MC','MONACO','Monaco','MCO',492),(142,'MN','MONGOLIA','Mongolia','MNG',496),(143,'MS','MONTSERRAT','Montserrat','MSR',500),(144,'MA','MOROCCO','Morocco','MAR',504),(145,'MZ','MOZAMBIQUE','Mozambique','MOZ',508),(146,'MM','MYANMAR','Myanmar','MMR',104),(147,'NA','NAMIBIA','Namibia','NAM',516),(148,'NR','NAURU','Nauru','NRU',520),(149,'NP','NEPAL','Nepal','NPL',524),(150,'NL','NETHERLANDS','Netherlands','NLD',528),(151,'AN','NETHERLANDS ANTILLES','Netherlands Antilles','ANT',530),(152,'NC','NEW CALEDONIA','New Caledonia','NCL',540),(153,'NZ','NEW ZEALAND','New Zealand','NZL',554),(154,'NI','NICARAGUA','Nicaragua','NIC',558),(155,'NE','NIGER','Niger','NER',562),(156,'NG','NIGERIA','Nigeria','NGA',566),(157,'NU','NIUE','Niue','NIU',570),(158,'NF','NORFOLK ISLAND','Norfolk Island','NFK',574),(159,'MP','NORTHERN MARIANA ISLANDS','Northern Mariana Islands','MNP',580),(160,'NO','NORWAY','Norway','NOR',578),(161,'OM','OMAN','Oman','OMN',512),(162,'PK','PAKISTAN','Pakistan','PAK',586),(163,'PW','PALAU','Palau','PLW',585),(164,'PS','PALESTINIAN TERRITORY, OCCUPIED','Palestinian Territory, Occupied',NULL,NULL),(165,'PA','PANAMA','Panama','PAN',591),(166,'PG','PAPUA NEW GUINEA','Papua New Guinea','PNG',598),(167,'PY','PARAGUAY','Paraguay','PRY',600),(168,'PE','PERU','Peru','PER',604),(169,'PH','PHILIPPINES','Philippines','PHL',608),(170,'PN','PITCAIRN','Pitcairn','PCN',612),(171,'PL','POLAND','Poland','POL',616),(172,'PT','PORTUGAL','Portugal','PRT',620),(173,'PR','PUERTO RICO','Puerto Rico','PRI',630),(174,'QA','QATAR','Qatar','QAT',634),(175,'RE','REUNION','Reunion','REU',638),(176,'RO','ROMANIA','Romania','ROM',642),(177,'RU','RUSSIAN FEDERATION','Russian Federation','RUS',643),(178,'RW','RWANDA','Rwanda','RWA',646),(179,'SH','SAINT HELENA','Saint Helena','SHN',654),(180,'KN','SAINT KITTS AND NEVIS','Saint Kitts and Nevis','KNA',659),(181,'LC','SAINT LUCIA','Saint Lucia','LCA',662),(182,'PM','SAINT PIERRE AND MIQUELON','Saint Pierre and Miquelon','SPM',666),(183,'VC','SAINT VINCENT AND THE GRENADINES','Saint Vincent and the Grenadines','VCT',670),(184,'WS','SAMOA','Samoa','WSM',882),(185,'SM','SAN MARINO','San Marino','SMR',674),(186,'ST','SAO TOME AND PRINCIPE','Sao Tome and Principe','STP',678),(187,'SA','SAUDI ARABIA','Saudi Arabia','SAU',682),(188,'SN','SENEGAL','Senegal','SEN',686),(189,'CS','SERBIA AND MONTENEGRO','Serbia and Montenegro',NULL,NULL),(190,'SC','SEYCHELLES','Seychelles','SYC',690),(191,'SL','SIERRA LEONE','Sierra Leone','SLE',694),(192,'SG','SINGAPORE','Singapore','SGP',702),(193,'SK','SLOVAKIA','Slovakia','SVK',703),(194,'SI','SLOVENIA','Slovenia','SVN',705),(195,'SB','SOLOMON ISLANDS','Solomon Islands','SLB',90),(196,'SO','SOMALIA','Somalia','SOM',706),(197,'ZA','SOUTH AFRICA','South Africa','ZAF',710),(198,'GS','SOUTH GEORGIA AND THE SOUTH SANDWICH ISLANDS','South Georgia and the South Sandwich Islands',NULL,NULL),(199,'ES','SPAIN','Spain','ESP',724),(200,'LK','SRI LANKA','Sri Lanka','LKA',144),(201,'SD','SUDAN','Sudan','SDN',736),(202,'SR','SURINAME','Suriname','SUR',740),(203,'SJ','SVALBARD AND JAN MAYEN','Svalbard and Jan Mayen','SJM',744),(204,'SZ','SWAZILAND','Swaziland','SWZ',748),(205,'SE','SWEDEN','Sweden','SWE',752),(206,'CH','SWITZERLAND','Switzerland','CHE',756),(207,'SY','SYRIAN ARAB REPUBLIC','Syrian Arab Republic','SYR',760),(208,'TW','TAIWAN, PROVINCE OF CHINA','Taiwan','TWN',158),(209,'TJ','TAJIKISTAN','Tajikistan','TJK',762),(210,'TZ','TANZANIA, UNITED REPUBLIC OF','Tanzania, United Republic of','TZA',834),(211,'TH','THAILAND','Thailand','THA',764),(212,'TL','TIMOR-LESTE','Timor-Leste',NULL,NULL),(213,'TG','TOGO','Togo','TGO',768),(214,'TK','TOKELAU','Tokelau','TKL',772),(215,'TO','TONGA','Tonga','TON',776),(216,'TT','TRINIDAD AND TOBAGO','Trinidad and Tobago','TTO',780),(217,'TN','TUNISIA','Tunisia','TUN',788),(218,'TR','TURKEY','Turkey','TUR',792),(219,'TM','TURKMENISTAN','Turkmenistan','TKM',795),(220,'TC','TURKS AND CAICOS ISLANDS','Turks and Caicos Islands','TCA',796),(221,'TV','TUVALU','Tuvalu','TUV',798),(222,'UG','UGANDA','Uganda','UGA',800),(223,'UA','UKRAINE','Ukraine','UKR',804),(224,'AE','UNITED ARAB EMIRATES','United Arab Emirates','ARE',784),(225,'GB','UNITED KINGDOM','United Kingdom','GBR',826),(226,'US','UNITED STATES','United States','USA',840),(227,'UM','UNITED STATES MINOR OUTLYING ISLANDS','United States Minor Outlying Islands',NULL,NULL),(228,'UY','URUGUAY','Uruguay','URY',858),(229,'UZ','UZBEKISTAN','Uzbekistan','UZB',860),(230,'VU','VANUATU','Vanuatu','VUT',548),(231,'VE','VENEZUELA','Venezuela','VEN',862),(232,'VN','VIET NAM','Viet Nam','VNM',704),(233,'VG','VIRGIN ISLANDS, BRITISH','Virgin Islands, British','VGB',92),(234,'VI','VIRGIN ISLANDS, U.S.','Virgin Islands, U.s.','VIR',850),(235,'WF','WALLIS AND FUTUNA','Wallis and Futuna','WLF',876),(236,'EH','WESTERN SAHARA','Western Sahara','ESH',732),(237,'YE','YEMEN','Yemen','YEM',887),(238,'ZM','ZAMBIA','Zambia','ZMB',894),(239,'ZW','ZIMBABWE','Zimbabwe','ZWE',716);
/*!40000 ALTER TABLE `Country` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Courses`
--

DROP TABLE IF EXISTS `Courses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Courses` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `code` varchar(300) NOT NULL,
  `name` varchar(300) NOT NULL,
  `description` text,
  `coordinator` bigint(20) DEFAULT NULL,
  `trainer` varchar(300) DEFAULT NULL,
  `trainer_info` text,
  `paymentType` enum('Company Sponsored','Paid by Employee') DEFAULT 'Company Sponsored',
  `currency` varchar(3) DEFAULT NULL,
  `cost` decimal(12,2) DEFAULT '0.00',
  `status` enum('Active','Inactive') DEFAULT 'Active',
  `created` datetime DEFAULT NULL,
  `updated` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `Fk_Courses_Employees` (`coordinator`),
  CONSTRAINT `Fk_Courses_Employees` FOREIGN KEY (`coordinator`) REFERENCES `Employees` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Courses`
--

LOCK TABLES `Courses` WRITE;
/*!40000 ALTER TABLE `Courses` DISABLE KEYS */;
INSERT INTO `Courses` VALUES (1,'C0001','Info Marketing','Learn how to Create and Outsource Info Marketing Products',1,'Tim Jhon','Tim Jhon has a background in business management and has been working with small business to establish their online presence','Company Sponsored','USD',55.00,'Active','2020-02-09 02:51:47','2020-02-09 02:51:47'),(2,'C0002','People Management','Learn how to Manage People',1,'Tim Jhon','Tim Jhon has a background in business management and has been working with small business to establish their online presence','Company Sponsored','USD',59.00,'Active','2020-02-09 02:51:47','2020-02-09 02:51:47');
/*!40000 ALTER TABLE `Courses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Crons`
--

DROP TABLE IF EXISTS `Crons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Crons` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `class` varchar(100) NOT NULL,
  `lastrun` datetime DEFAULT NULL,
  `frequency` int(4) NOT NULL,
  `time` varchar(50) NOT NULL,
  `type` enum('Minutely','Hourly','Daily','Weekly','Monthly','Yearly') DEFAULT 'Hourly',
  `status` enum('Enabled','Disabled') DEFAULT 'Enabled',
  PRIMARY KEY (`id`),
  UNIQUE KEY `KEY_Crons_name` (`name`),
  KEY `KEY_Crons_frequency` (`frequency`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Crons`
--

LOCK TABLES `Crons` WRITE;
/*!40000 ALTER TABLE `Crons` DISABLE KEYS */;
INSERT INTO `Crons` VALUES (1,'Email Sender Task','EmailSenderTask',NULL,1,'1','Minutely','Enabled'),(2,'Document Expire Alert','DocumentExpiryNotificationTask',NULL,1,'29','Hourly','Enabled');
/*!40000 ALTER TABLE `Crons` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CurrencyTypes`
--

DROP TABLE IF EXISTS `CurrencyTypes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `CurrencyTypes` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `code` varchar(3) NOT NULL DEFAULT '',
  `name` varchar(70) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `CurrencyTypes_code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=181 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CurrencyTypes`
--

LOCK TABLES `CurrencyTypes` WRITE;
/*!40000 ALTER TABLE `CurrencyTypes` DISABLE KEYS */;
INSERT INTO `CurrencyTypes` VALUES (3,'AED','Utd. Arab Emir. Dirham'),(4,'AFN','Afghanistan Afghani'),(5,'ALL','Albanian Lek'),(6,'ANG','NL Antillian Guilder'),(7,'AOR','Angolan New Kwanza'),(8,'ARS','Argentine Peso'),(10,'AUD','Australian Dollar'),(11,'AWG','Aruban Florin'),(12,'BBD','Barbados Dollar'),(13,'BDT','Bangladeshi Taka'),(15,'BGL','Bulgarian Lev'),(16,'BHD','Bahraini Dinar'),(17,'BIF','Burundi Franc'),(18,'BMD','Bermudian Dollar'),(19,'BND','Brunei Dollar'),(20,'BOB','Bolivian Boliviano'),(21,'BRL','Brazilian Real'),(22,'BSD','Bahamian Dollar'),(23,'BTN','Bhutan Ngultrum'),(24,'BWP','Botswana Pula'),(25,'BZD','Belize Dollar'),(26,'CAD','Canadian Dollar'),(27,'CHF','Swiss Franc'),(28,'CLP','Chilean Peso'),(29,'CNY','Chinese Yuan Renminbi'),(30,'COP','Colombian Peso'),(31,'CRC','Costa Rican Colon'),(32,'CUP','Cuban Peso'),(33,'CVE','Cape Verde Escudo'),(34,'CYP','Cyprus Pound'),(37,'DJF','Djibouti Franc'),(38,'DKK','Danish Krona'),(39,'DOP','Dominican Peso'),(40,'DZD','Algerian Dinar'),(41,'ECS','Ecuador Sucre'),(42,'EUR','Euro'),(43,'EEK','Estonian Krona'),(44,'EGP','Egyptian Pound'),(46,'ETB','Ethiopian Birr'),(48,'FJD','Fiji Dollar'),(49,'FKP','Falkland Islands Pound'),(51,'GBP','Pound Sterling'),(52,'GHC','Ghanaian Cedi'),(53,'GIP','Gibraltar Pound'),(54,'GMD','Gambian Dalasi'),(55,'GNF','Guinea Franc'),(57,'GTQ','Guatemalan Quetzal'),(58,'GYD','Guyanan Dollar'),(59,'HKD','Hong Kong Dollar'),(60,'HNL','Honduran Lempira'),(61,'HRK','Croatian Kuna'),(62,'HTG','Haitian Gourde'),(63,'HUF','Hungarian Forint'),(64,'IDR','Indonesian Rupiah'),(66,'ILS','Israeli New Shekel'),(67,'INR','Indian Rupee'),(68,'IQD','Iraqi Dinar'),(69,'IRR','Iranian Rial'),(70,'ISK','Iceland Krona'),(72,'JMD','Jamaican Dollar'),(73,'JOD','Jordanian Dinar'),(74,'JPY','Japanese Yen'),(75,'KES','Kenyan Shilling'),(76,'KHR','Kampuchean Riel'),(77,'KMF','Comoros Franc'),(78,'KPW','North Korean Won'),(79,'KRW','Korean Won'),(80,'KWD','Kuwaiti Dinar'),(81,'KYD','Cayman Islands Dollar'),(82,'KZT','Kazakhstan Tenge'),(83,'LAK','Lao Kip'),(84,'LBP','Lebanese Pound'),(85,'LKR','Sri Lanka Rupee'),(86,'LRD','Liberian Dollar'),(87,'LSL','Lesotho Loti'),(88,'LTL','Lithuanian Litas'),(90,'LVL','Latvian Lats'),(91,'LYD','Libyan Dinar'),(92,'MAD','Moroccan Dirham'),(93,'MGF','Malagasy Franc'),(94,'MMK','Myanmar Kyat'),(95,'MNT','Mongolian Tugrik'),(96,'MOP','Macau Pataca'),(97,'MRO','Mauritanian Ouguiya'),(98,'MTL','Maltese Lira'),(99,'MUR','Mauritius Rupee'),(100,'MVR','Maldive Rufiyaa'),(101,'MWK','Malawi Kwacha'),(102,'MXN','Mexican New Peso'),(103,'MYR','Malaysian Ringgit'),(104,'MZM','Mozambique Metical'),(105,'NAD','Namibia Dollar'),(106,'NGN','Nigerian Naira'),(107,'NIO','Nicaraguan Cordoba Oro'),(109,'NOK','Norwegian Krona'),(110,'NPR','Nepalese Rupee'),(111,'NZD','New Zealand Dollar'),(112,'OMR','Omani Rial'),(113,'PAB','Panamanian Balboa'),(114,'PEN','Peruvian Nuevo Sol'),(115,'PGK','Papua New Guinea Kina'),(116,'PHP','Philippine Peso'),(117,'PKR','Pakistan Rupee'),(118,'PLN','Polish Zloty'),(120,'PYG','Paraguay Guarani'),(121,'QAR','Qatari Rial'),(122,'ROL','Romanian Leu'),(123,'RUB','Russian Rouble'),(125,'SBD','Solomon Islands Dollar'),(126,'SCR','Seychelles Rupee'),(127,'SDD','Sudanese Dinar'),(128,'SDP','Sudanese Pound'),(129,'SEK','Swedish Krona'),(130,'SKK','Slovak Koruna'),(131,'SGD','Singapore Dollar'),(132,'SHP','St. Helena Pound'),(135,'SLL','Sierra Leone Leone'),(136,'SOS','Somali Shilling'),(137,'SRD','Surinamese Dollar'),(138,'STD','Sao Tome/Principe Dobra'),(139,'SVC','El Salvador Colon'),(140,'SYP','Syrian Pound'),(141,'SZL','Swaziland Lilangeni'),(142,'THB','Thai Baht'),(143,'TND','Tunisian Dinar'),(144,'TOP','Tongan Pa\'anga'),(145,'TRL','Turkish Lira'),(146,'TTD','Trinidad/Tobago Dollar'),(147,'TWD','Taiwan Dollar'),(148,'TZS','Tanzanian Shilling'),(149,'UAH','Ukraine Hryvnia'),(150,'UGX','Uganda Shilling'),(151,'USD','United States Dollar'),(152,'UYP','Uruguayan Peso'),(153,'VEB','Venezuelan Bolivar'),(154,'VND','Vietnamese Dong'),(155,'VUV','Vanuatu Vatu'),(156,'WST','Samoan Tala'),(158,'XAF','CFA Franc BEAC'),(159,'XAG','Silver (oz.)'),(160,'XAU','Gold (oz.)'),(161,'XCD','Eastern Caribbean Dollars'),(162,'XOF','CFA Franc BCEAO'),(163,'XPD','Palladium (oz.)'),(164,'XPF','CFP Franc'),(165,'XPT','Platinum (oz.)'),(166,'YER','Yemeni Riyal'),(167,'YUM','Yugoslavian Dinar'),(168,'ZAR','South African Rand'),(169,'ZRN','New Zaire'),(170,'ZWD','Zimbabwe Dollar'),(171,'CZK','Czech Koruna'),(172,'MXP','Mexican Peso'),(173,'SAR','Saudi Arabia Riyal'),(175,'YUN','Yugoslav Dinar'),(176,'ZMK','Zambian Kwacha'),(177,'ARP','Argentina Pesos'),(179,'XDR','IMF Special Drawing Right'),(180,'RUR','Russia Rubles');
/*!40000 ALTER TABLE `CurrencyTypes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CustomFieldValues`
--

DROP TABLE IF EXISTS `CustomFieldValues`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `CustomFieldValues` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `type` varchar(20) NOT NULL,
  `name` varchar(60) NOT NULL,
  `object_id` varchar(60) NOT NULL,
  `value` text,
  `updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `CustomFields_type_name_object_id` (`type`,`name`,`object_id`),
  KEY `CustomFields_type_object_id` (`type`,`object_id`)
) ENGINE=InnoDB AUTO_INCREMENT=516 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CustomFieldValues`
--

LOCK TABLES `CustomFieldValues` WRITE;
/*!40000 ALTER TABLE `CustomFieldValues` DISABLE KEYS */;
INSERT INTO `CustomFieldValues` VALUES (1,'User','csrf','4','b37e587e833ca87eef5c94dac7df119acb7b6d2f','2020-03-06 09:08:37','2020-03-05 12:56:03'),(2,'User','csrf','5','b37e587e833ca87eef5c94dac7df119acb7b6d2f','2020-03-06 09:08:42','2020-03-05 12:56:17'),(3,'User','csrf','3','b37e587e833ca87eef5c94dac7df119acb7b6d2f','2020-03-06 09:08:32','2020-03-06 09:05:40'),(4,'\\Employees\\Common\\Mo','bank_account','7','123456789','2020-03-08 11:13:40','2020-03-08 11:13:40'),(5,'\\Employees\\Common\\Mo','bank_name','7','ABC','2020-03-08 11:13:40','2020-03-08 11:13:40'),(6,'\\Employees\\Common\\Mo','deparment','7','Y Viet','2020-03-08 11:13:40','2020-03-08 11:13:40'),(7,'\\Employees\\Common\\Mo','indirect-supervisor','7','','2020-03-08 11:13:40','2020-03-08 11:13:40'),(8,'\\Employees\\Common\\Mo','bank_account','9','123456789','2020-03-08 11:13:40','2020-03-08 11:13:40'),(9,'\\Employees\\Common\\Mo','bank_name','9','ABC','2020-03-08 11:13:40','2020-03-08 11:13:40'),(10,'\\Employees\\Common\\Mo','deparment','9','Y Viet','2020-03-08 11:13:40','2020-03-08 11:13:40'),(11,'\\Employees\\Common\\Mo','indirect-supervisor','9','','2020-03-08 11:13:40','2020-03-08 11:13:40'),(12,'\\Employees\\Common\\Mo','bank_account','11','123456789','2020-03-08 11:13:40','2020-03-08 11:13:40'),(13,'\\Employees\\Common\\Mo','bank_name','11','ABC','2020-03-08 11:13:40','2020-03-08 11:13:40'),(14,'\\Employees\\Common\\Mo','deparment','11','Y Viet','2020-03-08 11:13:40','2020-03-08 11:13:40'),(15,'\\Employees\\Common\\Mo','indirect-supervisor','11','','2020-03-08 11:13:40','2020-03-08 11:13:40'),(16,'\\Employees\\Common\\Mo','bank_account','12','123456789','2020-03-08 11:13:40','2020-03-08 11:13:40'),(17,'\\Employees\\Common\\Mo','bank_name','12','ABC','2020-03-08 11:13:40','2020-03-08 11:13:40'),(18,'\\Employees\\Common\\Mo','deparment','12','Y Viet','2020-03-08 11:13:40','2020-03-08 11:13:40'),(19,'\\Employees\\Common\\Mo','indirect-supervisor','12','','2020-03-08 11:13:40','2020-03-08 11:13:40'),(20,'\\Employees\\Common\\Mo','bank_account','13','123456789','2020-03-08 11:13:40','2020-03-08 11:13:40'),(21,'\\Employees\\Common\\Mo','bank_name','13','ABC','2020-03-08 11:13:40','2020-03-08 11:13:40'),(22,'\\Employees\\Common\\Mo','deparment','13','Y Viet','2020-03-08 11:13:40','2020-03-08 11:13:40'),(23,'\\Employees\\Common\\Mo','indirect-supervisor','13','','2020-03-08 11:13:40','2020-03-08 11:13:40'),(24,'\\Employees\\Common\\Mo','bank_account','15','123456789','2020-03-08 11:13:40','2020-03-08 11:13:40'),(25,'\\Employees\\Common\\Mo','bank_name','15','ABC','2020-03-08 11:13:40','2020-03-08 11:13:40'),(26,'\\Employees\\Common\\Mo','deparment','15','Y Viet','2020-03-08 11:13:40','2020-03-08 11:13:40'),(27,'\\Employees\\Common\\Mo','indirect-supervisor','15','','2020-03-08 11:13:40','2020-03-08 11:13:40'),(28,'\\Employees\\Common\\Mo','bank_account','16','123456789','2020-03-08 11:13:40','2020-03-08 11:13:40'),(29,'\\Employees\\Common\\Mo','bank_name','16','ABC','2020-03-08 11:13:40','2020-03-08 11:13:40'),(30,'\\Employees\\Common\\Mo','deparment','16','Y Viet','2020-03-08 11:13:40','2020-03-08 11:13:40'),(31,'\\Employees\\Common\\Mo','indirect-supervisor','16','','2020-03-08 11:13:40','2020-03-08 11:13:40'),(32,'\\Employees\\Common\\Mo','bank_account','17','123456789','2020-03-08 11:13:40','2020-03-08 11:13:40'),(33,'\\Employees\\Common\\Mo','bank_name','17','ABC','2020-03-08 11:13:40','2020-03-08 11:13:40'),(34,'\\Employees\\Common\\Mo','deparment','17','Y Viet','2020-03-08 11:13:40','2020-03-08 11:13:40'),(35,'\\Employees\\Common\\Mo','indirect-supervisor','17','','2020-03-08 11:13:40','2020-03-08 11:13:40'),(36,'\\Employees\\Common\\Mo','bank_account','19','123456789','2020-03-08 11:13:40','2020-03-08 11:13:40'),(37,'\\Employees\\Common\\Mo','bank_name','19','ABC','2020-03-08 11:13:40','2020-03-08 11:13:40'),(38,'\\Employees\\Common\\Mo','deparment','19','Y Viet','2020-03-08 11:13:40','2020-03-08 11:13:40'),(39,'\\Employees\\Common\\Mo','indirect-supervisor','19','','2020-03-08 11:13:40','2020-03-08 11:13:40'),(40,'\\Employees\\Common\\Mo','bank_account','20','123456789','2020-03-08 11:13:40','2020-03-08 11:13:40'),(41,'\\Employees\\Common\\Mo','bank_name','20','ABC','2020-03-08 11:13:40','2020-03-08 11:13:40'),(42,'\\Employees\\Common\\Mo','deparment','20','Y Viet','2020-03-08 11:13:40','2020-03-08 11:13:40'),(43,'\\Employees\\Common\\Mo','indirect-supervisor','20','','2020-03-08 11:13:40','2020-03-08 11:13:40'),(44,'\\Employees\\Common\\Mo','bank_account','21','123456789','2020-03-08 11:13:40','2020-03-08 11:13:40'),(45,'\\Employees\\Common\\Mo','bank_name','21','ABC','2020-03-08 11:13:40','2020-03-08 11:13:40'),(46,'\\Employees\\Common\\Mo','deparment','21','Y Viet','2020-03-08 11:13:40','2020-03-08 11:13:40'),(47,'\\Employees\\Common\\Mo','indirect-supervisor','21','','2020-03-08 11:13:40','2020-03-08 11:13:40'),(48,'\\Employees\\Common\\Mo','bank_account','22','123456789','2020-03-08 11:13:40','2020-03-08 11:13:40'),(49,'\\Employees\\Common\\Mo','bank_name','22','ABC','2020-03-08 11:13:40','2020-03-08 11:13:40'),(50,'\\Employees\\Common\\Mo','deparment','22','Y Viet','2020-03-08 11:13:40','2020-03-08 11:13:40'),(51,'\\Employees\\Common\\Mo','indirect-supervisor','22','','2020-03-08 11:13:40','2020-03-08 11:13:40'),(52,'\\Employees\\Common\\Mo','bank_account','23','123456789','2020-03-08 11:13:40','2020-03-08 11:13:40'),(53,'\\Employees\\Common\\Mo','bank_name','23','ABC','2020-03-08 11:13:40','2020-03-08 11:13:40'),(54,'\\Employees\\Common\\Mo','deparment','23','Y Viet','2020-03-08 11:13:40','2020-03-08 11:13:40'),(55,'\\Employees\\Common\\Mo','indirect-supervisor','23','','2020-03-08 11:13:40','2020-03-08 11:13:40'),(56,'\\Employees\\Common\\Mo','bank_account','24','123456789','2020-03-08 11:13:40','2020-03-08 11:13:40'),(57,'\\Employees\\Common\\Mo','bank_name','24','ABC','2020-03-08 11:13:40','2020-03-08 11:13:40'),(58,'\\Employees\\Common\\Mo','deparment','24','Y Viet','2020-03-08 11:13:40','2020-03-08 11:13:40'),(59,'\\Employees\\Common\\Mo','indirect-supervisor','24','','2020-03-08 11:13:40','2020-03-08 11:13:40'),(60,'\\Employees\\Common\\Mo','bank_account','25','123456789','2020-03-08 11:13:40','2020-03-08 11:13:40'),(61,'\\Employees\\Common\\Mo','bank_name','25','ABC','2020-03-08 11:13:40','2020-03-08 11:13:40'),(62,'\\Employees\\Common\\Mo','deparment','25','Y Viet','2020-03-08 11:13:40','2020-03-08 11:13:40'),(63,'\\Employees\\Common\\Mo','indirect-supervisor','25','','2020-03-08 11:13:40','2020-03-08 11:13:40'),(64,'\\Employees\\Common\\Mo','bank_account','26','123456789','2020-03-08 11:13:40','2020-03-08 11:13:40'),(65,'\\Employees\\Common\\Mo','bank_name','26','ABC','2020-03-08 11:13:40','2020-03-08 11:13:40'),(66,'\\Employees\\Common\\Mo','deparment','26','Y Viet','2020-03-08 11:13:40','2020-03-08 11:13:40'),(67,'\\Employees\\Common\\Mo','indirect-supervisor','26','Nguyá»…n Ngá»c Quang & VÅ© Máº¡nh TÃº','2020-03-08 11:13:40','2020-03-08 11:13:40'),(68,'\\Employees\\Common\\Mo','bank_account','27','123456789','2020-03-08 11:13:40','2020-03-08 11:13:40'),(69,'\\Employees\\Common\\Mo','bank_name','27','ABC','2020-03-08 11:13:40','2020-03-08 11:13:40'),(70,'\\Employees\\Common\\Mo','deparment','27','Y Viet','2020-03-08 11:13:40','2020-03-08 11:13:40'),(71,'\\Employees\\Common\\Mo','indirect-supervisor','27','','2020-03-08 11:13:40','2020-03-08 11:13:40'),(72,'\\Employees\\Common\\Mo','bank_account','29','123456789','2020-03-08 11:13:40','2020-03-08 11:13:40'),(73,'\\Employees\\Common\\Mo','bank_name','29','ABC','2020-03-08 11:13:40','2020-03-08 11:13:40'),(74,'\\Employees\\Common\\Mo','deparment','29','Y Viet','2020-03-08 11:13:40','2020-03-08 11:13:40'),(75,'\\Employees\\Common\\Mo','indirect-supervisor','29','','2020-03-08 11:13:40','2020-03-08 11:13:40'),(76,'\\Employees\\Common\\Mo','bank_account','30','123456789','2020-03-08 11:13:40','2020-03-08 11:13:40'),(77,'\\Employees\\Common\\Mo','bank_name','30','ABC','2020-03-08 11:13:40','2020-03-08 11:13:40'),(78,'\\Employees\\Common\\Mo','deparment','30','Y Viet','2020-03-08 11:13:40','2020-03-08 11:13:40'),(79,'\\Employees\\Common\\Mo','indirect-supervisor','30','VÅ© Máº¡nh TÃº','2020-03-08 11:13:40','2020-03-08 11:13:40'),(80,'\\Employees\\Common\\Mo','bank_account','31','123456789','2020-03-08 11:13:40','2020-03-08 11:13:40'),(81,'\\Employees\\Common\\Mo','bank_name','31','ABC','2020-03-08 11:13:40','2020-03-08 11:13:40'),(82,'\\Employees\\Common\\Mo','deparment','31','Y Viet','2020-03-08 11:13:40','2020-03-08 11:13:40'),(83,'\\Employees\\Common\\Mo','indirect-supervisor','31','','2020-03-08 11:13:40','2020-03-08 11:13:40'),(84,'\\Employees\\Common\\Mo','bank_account','32','123456789','2020-03-08 11:13:40','2020-03-08 11:13:40'),(85,'\\Employees\\Common\\Mo','bank_name','32','ABC','2020-03-08 11:13:40','2020-03-08 11:13:40'),(86,'\\Employees\\Common\\Mo','deparment','32','Y Viet','2020-03-08 11:13:40','2020-03-08 11:13:40'),(87,'\\Employees\\Common\\Mo','indirect-supervisor','32','','2020-03-08 11:13:40','2020-03-08 11:13:40'),(88,'\\Employees\\Common\\Mo','bank_account','33','123456789','2020-03-08 11:13:40','2020-03-08 11:13:40'),(89,'\\Employees\\Common\\Mo','bank_name','33','ABC','2020-03-08 11:13:40','2020-03-08 11:13:40'),(90,'\\Employees\\Common\\Mo','deparment','33','Y Viet','2020-03-08 11:13:40','2020-03-08 11:13:40'),(91,'\\Employees\\Common\\Mo','indirect-supervisor','33','','2020-03-08 11:13:40','2020-03-08 11:13:40'),(92,'\\Employees\\Common\\Mo','bank_account','35','123456789','2020-03-08 11:13:40','2020-03-08 11:13:40'),(93,'\\Employees\\Common\\Mo','bank_name','35','ABC','2020-03-08 11:13:40','2020-03-08 11:13:40'),(94,'\\Employees\\Common\\Mo','deparment','35','Y Viet','2020-03-08 11:13:40','2020-03-08 11:13:40'),(95,'\\Employees\\Common\\Mo','indirect-supervisor','35','Nguyá»…n Ngá»c Quang ','2020-03-08 11:13:40','2020-03-08 11:13:40'),(96,'\\Employees\\Common\\Mo','bank_account','36','123456789','2020-03-08 11:13:40','2020-03-08 11:13:40'),(97,'\\Employees\\Common\\Mo','bank_name','36','ABC','2020-03-08 11:13:40','2020-03-08 11:13:40'),(98,'\\Employees\\Common\\Mo','deparment','36','Y Viet','2020-03-08 11:13:40','2020-03-08 11:13:40'),(99,'\\Employees\\Common\\Mo','indirect-supervisor','36','','2020-03-08 11:13:40','2020-03-08 11:13:40'),(100,'\\Employees\\Common\\Mo','bank_account','37','123456789','2020-03-08 11:13:40','2020-03-08 11:13:40'),(101,'\\Employees\\Common\\Mo','bank_name','37','ABC','2020-03-08 11:13:40','2020-03-08 11:13:40'),(102,'\\Employees\\Common\\Mo','deparment','37','Y Viet','2020-03-08 11:13:40','2020-03-08 11:13:40'),(103,'\\Employees\\Common\\Mo','indirect-supervisor','37','','2020-03-08 11:13:40','2020-03-08 11:13:40'),(104,'\\Employees\\Common\\Mo','bank_account','38','123456789','2020-03-08 11:13:40','2020-03-08 11:13:40'),(105,'\\Employees\\Common\\Mo','bank_name','38','ABC','2020-03-08 11:13:40','2020-03-08 11:13:40'),(106,'\\Employees\\Common\\Mo','deparment','38','Y Viet','2020-03-08 11:13:40','2020-03-08 11:13:40'),(107,'\\Employees\\Common\\Mo','indirect-supervisor','38','','2020-03-08 11:13:40','2020-03-08 11:13:40'),(108,'\\Employees\\Common\\Mo','bank_account','39','123456789','2020-03-08 11:13:40','2020-03-08 11:13:40'),(109,'\\Employees\\Common\\Mo','bank_name','39','ABC','2020-03-08 11:13:40','2020-03-08 11:13:40'),(110,'\\Employees\\Common\\Mo','deparment','39','Y Viet','2020-03-08 11:13:40','2020-03-08 11:13:40'),(111,'\\Employees\\Common\\Mo','indirect-supervisor','39','','2020-03-08 11:13:40','2020-03-08 11:13:40'),(112,'\\Employees\\Common\\Mo','bank_account','40','123456789','2020-03-08 11:13:40','2020-03-08 11:13:40'),(113,'\\Employees\\Common\\Mo','bank_name','40','ABC','2020-03-08 11:13:40','2020-03-08 11:13:40'),(114,'\\Employees\\Common\\Mo','deparment','40','Y Viet','2020-03-08 11:13:40','2020-03-08 11:13:40'),(115,'\\Employees\\Common\\Mo','indirect-supervisor','40','','2020-03-08 11:13:40','2020-03-08 11:13:40'),(116,'\\Employees\\Common\\Mo','bank_account','41','123456789','2020-03-08 11:13:40','2020-03-08 11:13:40'),(117,'\\Employees\\Common\\Mo','bank_name','41','ABC','2020-03-08 11:13:40','2020-03-08 11:13:40'),(118,'\\Employees\\Common\\Mo','deparment','41','Y Viet','2020-03-08 11:13:40','2020-03-08 11:13:40'),(119,'\\Employees\\Common\\Mo','indirect-supervisor','41','','2020-03-08 11:13:40','2020-03-08 11:13:40'),(120,'\\Employees\\Common\\Mo','bank_account','42','123456789','2020-03-08 11:13:40','2020-03-08 11:13:40'),(121,'\\Employees\\Common\\Mo','bank_name','42','ABC','2020-03-08 11:13:40','2020-03-08 11:13:40'),(122,'\\Employees\\Common\\Mo','deparment','42','Y Viet','2020-03-08 11:13:40','2020-03-08 11:13:40'),(123,'\\Employees\\Common\\Mo','indirect-supervisor','42','','2020-03-08 11:13:40','2020-03-08 11:13:40'),(124,'\\Employees\\Common\\Mo','bank_account','43','123456789','2020-03-08 11:13:40','2020-03-08 11:13:40'),(125,'\\Employees\\Common\\Mo','bank_name','43','ABC','2020-03-08 11:13:40','2020-03-08 11:13:40'),(126,'\\Employees\\Common\\Mo','deparment','43','Y Viet','2020-03-08 11:13:40','2020-03-08 11:13:40'),(127,'\\Employees\\Common\\Mo','indirect-supervisor','43','','2020-03-08 11:13:40','2020-03-08 11:13:40'),(128,'\\Employees\\Common\\Mo','bank_account','44','123456789','2020-03-08 11:13:40','2020-03-08 11:13:40'),(129,'\\Employees\\Common\\Mo','bank_name','44','ABC','2020-03-08 11:13:40','2020-03-08 11:13:40'),(130,'\\Employees\\Common\\Mo','deparment','44','Y Viet','2020-03-08 11:13:40','2020-03-08 11:13:40'),(131,'\\Employees\\Common\\Mo','indirect-supervisor','44','','2020-03-08 11:13:40','2020-03-08 11:13:40'),(132,'\\Employees\\Common\\Mo','bank_account','46','123456789','2020-03-09 08:11:52','2020-03-09 08:11:52'),(133,'\\Employees\\Common\\Mo','bank_name','46','ABC','2020-03-09 08:11:52','2020-03-09 08:11:52'),(134,'\\Employees\\Common\\Mo','deparment','46','Y Viet','2020-03-09 08:11:52','2020-03-09 08:11:52'),(135,'\\Employees\\Common\\Mo','indirect-supervisor','46','','2020-03-09 08:11:52','2020-03-09 08:11:52'),(136,'\\Employees\\Common\\Mo','bank_account','47','123456789','2020-03-09 08:11:52','2020-03-09 08:11:52'),(137,'\\Employees\\Common\\Mo','bank_name','47','ABC','2020-03-09 08:11:52','2020-03-09 08:11:52'),(138,'\\Employees\\Common\\Mo','deparment','47','Y Viet','2020-03-09 08:11:52','2020-03-09 08:11:52'),(139,'\\Employees\\Common\\Mo','indirect-supervisor','47','','2020-03-09 08:11:52','2020-03-09 08:11:52'),(140,'\\Employees\\Common\\Mo','bank_account','48','123456789','2020-03-09 08:11:52','2020-03-09 08:11:52'),(141,'\\Employees\\Common\\Mo','bank_name','48','ABC','2020-03-09 08:11:52','2020-03-09 08:11:52'),(142,'\\Employees\\Common\\Mo','deparment','48','Y Viet','2020-03-09 08:11:52','2020-03-09 08:11:52'),(143,'\\Employees\\Common\\Mo','indirect-supervisor','48','','2020-03-09 08:11:52','2020-03-09 08:11:52'),(144,'\\Employees\\Common\\Mo','bank_account','49','123456789','2020-03-09 08:11:52','2020-03-09 08:11:52'),(145,'\\Employees\\Common\\Mo','bank_name','49','ABC','2020-03-09 08:11:52','2020-03-09 08:11:52'),(146,'\\Employees\\Common\\Mo','deparment','49','Y Viet','2020-03-09 08:11:52','2020-03-09 08:11:52'),(147,'\\Employees\\Common\\Mo','indirect-supervisor','49','','2020-03-09 08:11:52','2020-03-09 08:11:52'),(148,'\\Employees\\Common\\Mo','bank_account','50','123456789','2020-03-09 08:11:52','2020-03-09 08:11:52'),(149,'\\Employees\\Common\\Mo','bank_name','50','ABC','2020-03-09 08:11:52','2020-03-09 08:11:52'),(150,'\\Employees\\Common\\Mo','deparment','50','Y Viet','2020-03-09 08:11:52','2020-03-09 08:11:52'),(151,'\\Employees\\Common\\Mo','indirect-supervisor','50','','2020-03-09 08:11:52','2020-03-09 08:11:52'),(152,'\\Employees\\Common\\Mo','bank_account','51','123456789','2020-03-09 08:11:52','2020-03-09 08:11:52'),(153,'\\Employees\\Common\\Mo','bank_name','51','ABC','2020-03-09 08:11:52','2020-03-09 08:11:52'),(154,'\\Employees\\Common\\Mo','deparment','51','Y Viet','2020-03-09 08:11:52','2020-03-09 08:11:52'),(155,'\\Employees\\Common\\Mo','indirect-supervisor','51','','2020-03-09 08:11:52','2020-03-09 08:11:52'),(156,'\\Employees\\Common\\Mo','bank_account','52','123456789','2020-03-09 08:11:52','2020-03-09 08:11:52'),(157,'\\Employees\\Common\\Mo','bank_name','52','ABC','2020-03-09 08:11:52','2020-03-09 08:11:52'),(158,'\\Employees\\Common\\Mo','deparment','52','Y Viet','2020-03-09 08:11:52','2020-03-09 08:11:52'),(159,'\\Employees\\Common\\Mo','indirect-supervisor','52','','2020-03-09 08:11:52','2020-03-09 08:11:52'),(160,'\\Employees\\Common\\Mo','bank_account','53','123456789','2020-03-09 08:11:52','2020-03-09 08:11:52'),(161,'\\Employees\\Common\\Mo','bank_name','53','ABC','2020-03-09 08:11:52','2020-03-09 08:11:52'),(162,'\\Employees\\Common\\Mo','deparment','53','Y Viet','2020-03-09 08:11:52','2020-03-09 08:11:52'),(163,'\\Employees\\Common\\Mo','indirect-supervisor','53','','2020-03-09 08:11:52','2020-03-09 08:11:52'),(164,'\\Employees\\Common\\Mo','bank_account','54','123456789','2020-03-09 08:11:52','2020-03-09 08:11:52'),(165,'\\Employees\\Common\\Mo','bank_name','54','ABC','2020-03-09 08:11:52','2020-03-09 08:11:52'),(166,'\\Employees\\Common\\Mo','deparment','54','Y Viet','2020-03-09 08:11:52','2020-03-09 08:11:52'),(167,'\\Employees\\Common\\Mo','indirect-supervisor','54','','2020-03-09 08:11:52','2020-03-09 08:11:52'),(168,'\\Employees\\Common\\Mo','bank_account','55','123456789','2020-03-09 08:11:52','2020-03-09 08:11:52'),(169,'\\Employees\\Common\\Mo','bank_name','55','ABC','2020-03-09 08:11:52','2020-03-09 08:11:52'),(170,'\\Employees\\Common\\Mo','deparment','55','Y Viet','2020-03-09 08:11:52','2020-03-09 08:11:52'),(171,'\\Employees\\Common\\Mo','indirect-supervisor','55','','2020-03-09 08:11:52','2020-03-09 08:11:52'),(172,'\\Employees\\Common\\Mo','bank_account','56','123456789','2020-03-09 08:11:52','2020-03-09 08:11:52'),(173,'\\Employees\\Common\\Mo','bank_name','56','ABC','2020-03-09 08:11:52','2020-03-09 08:11:52'),(174,'\\Employees\\Common\\Mo','deparment','56','Y Viet','2020-03-09 08:11:52','2020-03-09 08:11:52'),(175,'\\Employees\\Common\\Mo','indirect-supervisor','56','','2020-03-09 08:11:52','2020-03-09 08:11:52'),(176,'\\Employees\\Common\\Mo','bank_account','57','123456789','2020-03-09 08:11:52','2020-03-09 08:11:52'),(177,'\\Employees\\Common\\Mo','bank_name','57','ABC','2020-03-09 08:11:52','2020-03-09 08:11:52'),(178,'\\Employees\\Common\\Mo','deparment','57','Y Viet','2020-03-09 08:11:52','2020-03-09 08:11:52'),(179,'\\Employees\\Common\\Mo','indirect-supervisor','57','','2020-03-09 08:11:52','2020-03-09 08:11:52'),(180,'\\Employees\\Common\\Mo','bank_account','58','123456789','2020-03-09 08:11:52','2020-03-09 08:11:52'),(181,'\\Employees\\Common\\Mo','bank_name','58','ABC','2020-03-09 08:11:52','2020-03-09 08:11:52'),(182,'\\Employees\\Common\\Mo','deparment','58','Y Viet','2020-03-09 08:11:52','2020-03-09 08:11:52'),(183,'\\Employees\\Common\\Mo','indirect-supervisor','58','','2020-03-09 08:11:52','2020-03-09 08:11:52'),(184,'\\Employees\\Common\\Mo','bank_account','59','123456789','2020-03-09 08:11:52','2020-03-09 08:11:52'),(185,'\\Employees\\Common\\Mo','bank_name','59','ABC','2020-03-09 08:11:52','2020-03-09 08:11:52'),(186,'\\Employees\\Common\\Mo','deparment','59','Y Viet','2020-03-09 08:11:52','2020-03-09 08:11:52'),(187,'\\Employees\\Common\\Mo','indirect-supervisor','59','','2020-03-09 08:11:52','2020-03-09 08:11:52'),(188,'\\Employees\\Common\\Mo','bank_account','60','123456789','2020-03-09 08:11:52','2020-03-09 08:11:52'),(189,'\\Employees\\Common\\Mo','bank_name','60','ABC','2020-03-09 08:11:52','2020-03-09 08:11:52'),(190,'\\Employees\\Common\\Mo','deparment','60','Y Viet','2020-03-09 08:11:52','2020-03-09 08:11:52'),(191,'\\Employees\\Common\\Mo','indirect-supervisor','60','','2020-03-09 08:11:52','2020-03-09 08:11:52'),(192,'\\Employees\\Common\\Mo','bank_account','61','123456789','2020-03-09 08:11:52','2020-03-09 08:11:52'),(193,'\\Employees\\Common\\Mo','bank_name','61','ABC','2020-03-09 08:11:52','2020-03-09 08:11:52'),(194,'\\Employees\\Common\\Mo','deparment','61','Y Viet','2020-03-09 08:11:52','2020-03-09 08:11:52'),(195,'\\Employees\\Common\\Mo','indirect-supervisor','61','NGUYá»„N NGá»ŒC QUANG & VÅ¨ Máº NH TÃš','2020-03-09 08:11:52','2020-03-09 08:11:52'),(196,'\\Employees\\Common\\Mo','bank_account','62','123456789','2020-03-09 08:11:52','2020-03-09 08:11:52'),(197,'\\Employees\\Common\\Mo','bank_name','62','ABC','2020-03-09 08:11:52','2020-03-09 08:11:52'),(198,'\\Employees\\Common\\Mo','deparment','62','Y Viet','2020-03-09 08:11:52','2020-03-09 08:11:52'),(199,'\\Employees\\Common\\Mo','indirect-supervisor','62','','2020-03-09 08:11:52','2020-03-09 08:11:52'),(200,'\\Employees\\Common\\Mo','bank_account','63','123456789','2020-03-09 08:11:52','2020-03-09 08:11:52'),(201,'\\Employees\\Common\\Mo','bank_name','63','ABC','2020-03-09 08:11:52','2020-03-09 08:11:52'),(202,'\\Employees\\Common\\Mo','deparment','63','Y Viet','2020-03-09 08:11:52','2020-03-09 08:11:52'),(203,'\\Employees\\Common\\Mo','indirect-supervisor','63','','2020-03-09 08:11:52','2020-03-09 08:11:52'),(204,'\\Employees\\Common\\Mo','bank_account','64','123456789','2020-03-09 08:11:52','2020-03-09 08:11:52'),(205,'\\Employees\\Common\\Mo','bank_name','64','ABC','2020-03-09 08:11:52','2020-03-09 08:11:52'),(206,'\\Employees\\Common\\Mo','deparment','64','Y Viet','2020-03-09 08:11:52','2020-03-09 08:11:52'),(207,'\\Employees\\Common\\Mo','indirect-supervisor','64','VÅ¨ Máº NH TÃš','2020-03-09 08:11:52','2020-03-09 08:11:52'),(208,'\\Employees\\Common\\Mo','bank_account','65','123456789','2020-03-09 08:11:52','2020-03-09 08:11:52'),(209,'\\Employees\\Common\\Mo','bank_name','65','ABC','2020-03-09 08:11:52','2020-03-09 08:11:52'),(210,'\\Employees\\Common\\Mo','deparment','65','Y Viet','2020-03-09 08:11:52','2020-03-09 08:11:52'),(211,'\\Employees\\Common\\Mo','indirect-supervisor','65','','2020-03-09 08:11:52','2020-03-09 08:11:52'),(212,'\\Employees\\Common\\Mo','bank_account','66','123456789','2020-03-09 08:11:52','2020-03-09 08:11:52'),(213,'\\Employees\\Common\\Mo','bank_name','66','ABC','2020-03-09 08:11:52','2020-03-09 08:11:52'),(214,'\\Employees\\Common\\Mo','deparment','66','Y Viet','2020-03-09 08:11:52','2020-03-09 08:11:52'),(215,'\\Employees\\Common\\Mo','indirect-supervisor','66','','2020-03-09 08:11:52','2020-03-09 08:11:52'),(216,'\\Employees\\Common\\Mo','bank_account','67','123456789','2020-03-09 08:11:52','2020-03-09 08:11:52'),(217,'\\Employees\\Common\\Mo','bank_name','67','ABC','2020-03-09 08:11:52','2020-03-09 08:11:52'),(218,'\\Employees\\Common\\Mo','deparment','67','Y Viet','2020-03-09 08:11:52','2020-03-09 08:11:52'),(219,'\\Employees\\Common\\Mo','indirect-supervisor','67','','2020-03-09 08:11:52','2020-03-09 08:11:52'),(220,'\\Employees\\Common\\Mo','bank_account','68','123456789','2020-03-09 08:11:52','2020-03-09 08:11:52'),(221,'\\Employees\\Common\\Mo','bank_name','68','ABC','2020-03-09 08:11:52','2020-03-09 08:11:52'),(222,'\\Employees\\Common\\Mo','deparment','68','Y Viet','2020-03-09 08:11:52','2020-03-09 08:11:52'),(223,'\\Employees\\Common\\Mo','indirect-supervisor','68','NGUYá»„N NGá»ŒC QUANG','2020-03-09 08:11:52','2020-03-09 08:11:52'),(224,'\\Employees\\Common\\Mo','bank_account','69','123456789','2020-03-09 08:11:52','2020-03-09 08:11:52'),(225,'\\Employees\\Common\\Mo','bank_name','69','ABC','2020-03-09 08:11:52','2020-03-09 08:11:52'),(226,'\\Employees\\Common\\Mo','deparment','69','Y Viet','2020-03-09 08:11:52','2020-03-09 08:11:52'),(227,'\\Employees\\Common\\Mo','indirect-supervisor','69','','2020-03-09 08:11:52','2020-03-09 08:11:52'),(228,'\\Employees\\Common\\Mo','bank_account','70','123456789','2020-03-09 08:11:52','2020-03-09 08:11:52'),(229,'\\Employees\\Common\\Mo','bank_name','70','ABC','2020-03-09 08:11:52','2020-03-09 08:11:52'),(230,'\\Employees\\Common\\Mo','deparment','70','Y Viet','2020-03-09 08:11:52','2020-03-09 08:11:52'),(231,'\\Employees\\Common\\Mo','indirect-supervisor','70','','2020-03-09 08:11:52','2020-03-09 08:11:52'),(232,'\\Employees\\Common\\Mo','bank_account','71','123456789','2020-03-09 08:11:52','2020-03-09 08:11:52'),(233,'\\Employees\\Common\\Mo','bank_name','71','ABC','2020-03-09 08:11:52','2020-03-09 08:11:52'),(234,'\\Employees\\Common\\Mo','deparment','71','Y Viet','2020-03-09 08:11:52','2020-03-09 08:11:52'),(235,'\\Employees\\Common\\Mo','indirect-supervisor','71','','2020-03-09 08:11:52','2020-03-09 08:11:52'),(236,'\\Employees\\Common\\Mo','bank_account','72','123456789','2020-03-09 08:11:52','2020-03-09 08:11:52'),(237,'\\Employees\\Common\\Mo','bank_name','72','ABC','2020-03-09 08:11:52','2020-03-09 08:11:52'),(238,'\\Employees\\Common\\Mo','deparment','72','Y Viet','2020-03-09 08:11:52','2020-03-09 08:11:52'),(239,'\\Employees\\Common\\Mo','indirect-supervisor','72','','2020-03-09 08:11:52','2020-03-09 08:11:52'),(240,'\\Employees\\Common\\Mo','bank_account','73','123456789','2020-03-09 08:11:52','2020-03-09 08:11:52'),(241,'\\Employees\\Common\\Mo','bank_name','73','ABC','2020-03-09 08:11:52','2020-03-09 08:11:52'),(242,'\\Employees\\Common\\Mo','deparment','73','Y Viet','2020-03-09 08:11:52','2020-03-09 08:11:52'),(243,'\\Employees\\Common\\Mo','indirect-supervisor','73','','2020-03-09 08:11:52','2020-03-09 08:11:52'),(244,'\\Employees\\Common\\Mo','bank_account','74','123456789','2020-03-09 08:11:53','2020-03-09 08:11:53'),(245,'\\Employees\\Common\\Mo','bank_name','74','ABC','2020-03-09 08:11:53','2020-03-09 08:11:53'),(246,'\\Employees\\Common\\Mo','deparment','74','Y Viet','2020-03-09 08:11:53','2020-03-09 08:11:53'),(247,'\\Employees\\Common\\Mo','indirect-supervisor','74','','2020-03-09 08:11:53','2020-03-09 08:11:53'),(248,'\\Employees\\Common\\Mo','bank_account','75','123456789','2020-03-09 08:11:53','2020-03-09 08:11:53'),(249,'\\Employees\\Common\\Mo','bank_name','75','ABC','2020-03-09 08:11:53','2020-03-09 08:11:53'),(250,'\\Employees\\Common\\Mo','deparment','75','Y Viet','2020-03-09 08:11:53','2020-03-09 08:11:53'),(251,'\\Employees\\Common\\Mo','indirect-supervisor','75','','2020-03-09 08:11:53','2020-03-09 08:11:53'),(252,'\\Employees\\Common\\Mo','bank_account','76','123456789','2020-03-09 08:11:53','2020-03-09 08:11:53'),(253,'\\Employees\\Common\\Mo','bank_name','76','ABC','2020-03-09 08:11:53','2020-03-09 08:11:53'),(254,'\\Employees\\Common\\Mo','deparment','76','Y Viet','2020-03-09 08:11:53','2020-03-09 08:11:53'),(255,'\\Employees\\Common\\Mo','indirect-supervisor','76','','2020-03-09 08:11:53','2020-03-09 08:11:53'),(256,'\\Employees\\Common\\Mo','bank_account','77','123456789','2020-03-09 08:11:53','2020-03-09 08:11:53'),(257,'\\Employees\\Common\\Mo','bank_name','77','ABC','2020-03-09 08:11:53','2020-03-09 08:11:53'),(258,'\\Employees\\Common\\Mo','deparment','77','Y Viet','2020-03-09 08:11:53','2020-03-09 08:11:53'),(259,'\\Employees\\Common\\Mo','indirect-supervisor','77','','2020-03-09 08:11:53','2020-03-09 08:11:53'),(260,'\\Employees\\Common\\Mo','bank_account','79','123456789','2020-03-09 08:23:23','2020-03-09 08:23:23'),(261,'\\Employees\\Common\\Mo','bank_name','79','ABC','2020-03-09 08:23:23','2020-03-09 08:23:23'),(262,'\\Employees\\Common\\Mo','deparment','79','Y Viet','2020-03-09 08:23:23','2020-03-09 08:23:23'),(263,'\\Employees\\Common\\Mo','indirect-supervisor','79','','2020-03-09 08:23:23','2020-03-09 08:23:23'),(264,'\\Employees\\Common\\Mo','bank_account','80','123456789','2020-03-09 08:23:23','2020-03-09 08:23:23'),(265,'\\Employees\\Common\\Mo','bank_name','80','ABC','2020-03-09 08:23:23','2020-03-09 08:23:23'),(266,'\\Employees\\Common\\Mo','deparment','80','Y Viet','2020-03-09 08:23:23','2020-03-09 08:23:23'),(267,'\\Employees\\Common\\Mo','indirect-supervisor','80','','2020-03-09 08:23:23','2020-03-09 08:23:23'),(268,'\\Employees\\Common\\Mo','bank_account','81','123456789','2020-03-09 08:23:23','2020-03-09 08:23:23'),(269,'\\Employees\\Common\\Mo','bank_name','81','ABC','2020-03-09 08:23:23','2020-03-09 08:23:23'),(270,'\\Employees\\Common\\Mo','deparment','81','Y Viet','2020-03-09 08:23:23','2020-03-09 08:23:23'),(271,'\\Employees\\Common\\Mo','indirect-supervisor','81','','2020-03-09 08:23:23','2020-03-09 08:23:23'),(272,'\\Employees\\Common\\Mo','bank_account','82','123456789','2020-03-09 08:23:23','2020-03-09 08:23:23'),(273,'\\Employees\\Common\\Mo','bank_name','82','ABC','2020-03-09 08:23:23','2020-03-09 08:23:23'),(274,'\\Employees\\Common\\Mo','deparment','82','Y Viet','2020-03-09 08:23:23','2020-03-09 08:23:23'),(275,'\\Employees\\Common\\Mo','indirect-supervisor','82','','2020-03-09 08:23:23','2020-03-09 08:23:23'),(276,'\\Employees\\Common\\Mo','bank_account','83','123456789','2020-03-09 08:23:23','2020-03-09 08:23:23'),(277,'\\Employees\\Common\\Mo','bank_name','83','ABC','2020-03-09 08:23:23','2020-03-09 08:23:23'),(278,'\\Employees\\Common\\Mo','deparment','83','Y Viet','2020-03-09 08:23:23','2020-03-09 08:23:23'),(279,'\\Employees\\Common\\Mo','indirect-supervisor','83','','2020-03-09 08:23:23','2020-03-09 08:23:23'),(280,'\\Employees\\Common\\Mo','bank_account','84','123456789','2020-03-09 08:23:23','2020-03-09 08:23:23'),(281,'\\Employees\\Common\\Mo','bank_name','84','ABC','2020-03-09 08:23:23','2020-03-09 08:23:23'),(282,'\\Employees\\Common\\Mo','deparment','84','Y Viet','2020-03-09 08:23:23','2020-03-09 08:23:23'),(283,'\\Employees\\Common\\Mo','indirect-supervisor','84','','2020-03-09 08:23:23','2020-03-09 08:23:23'),(284,'\\Employees\\Common\\Mo','bank_account','85','123456789','2020-03-09 08:23:23','2020-03-09 08:23:23'),(285,'\\Employees\\Common\\Mo','bank_name','85','ABC','2020-03-09 08:23:23','2020-03-09 08:23:23'),(286,'\\Employees\\Common\\Mo','deparment','85','Y Viet','2020-03-09 08:23:23','2020-03-09 08:23:23'),(287,'\\Employees\\Common\\Mo','indirect-supervisor','85','','2020-03-09 08:23:23','2020-03-09 08:23:23'),(288,'\\Employees\\Common\\Mo','bank_account','86','123456789','2020-03-09 08:23:23','2020-03-09 08:23:23'),(289,'\\Employees\\Common\\Mo','bank_name','86','ABC','2020-03-09 08:23:23','2020-03-09 08:23:23'),(290,'\\Employees\\Common\\Mo','deparment','86','Y Viet','2020-03-09 08:23:23','2020-03-09 08:23:23'),(291,'\\Employees\\Common\\Mo','indirect-supervisor','86','','2020-03-09 08:23:23','2020-03-09 08:23:23'),(292,'\\Employees\\Common\\Mo','bank_account','87','123456789','2020-03-09 08:23:23','2020-03-09 08:23:23'),(293,'\\Employees\\Common\\Mo','bank_name','87','ABC','2020-03-09 08:23:23','2020-03-09 08:23:23'),(294,'\\Employees\\Common\\Mo','deparment','87','Y Viet','2020-03-09 08:23:23','2020-03-09 08:23:23'),(295,'\\Employees\\Common\\Mo','indirect-supervisor','87','','2020-03-09 08:23:23','2020-03-09 08:23:23'),(296,'\\Employees\\Common\\Mo','bank_account','88','123456789','2020-03-09 08:23:23','2020-03-09 08:23:23'),(297,'\\Employees\\Common\\Mo','bank_name','88','ABC','2020-03-09 08:23:23','2020-03-09 08:23:23'),(298,'\\Employees\\Common\\Mo','deparment','88','Y Viet','2020-03-09 08:23:23','2020-03-09 08:23:23'),(299,'\\Employees\\Common\\Mo','indirect-supervisor','88','','2020-03-09 08:23:23','2020-03-09 08:23:23'),(300,'\\Employees\\Common\\Mo','bank_account','89','123456789','2020-03-09 08:23:23','2020-03-09 08:23:23'),(301,'\\Employees\\Common\\Mo','bank_name','89','ABC','2020-03-09 08:23:23','2020-03-09 08:23:23'),(302,'\\Employees\\Common\\Mo','deparment','89','Y Viet','2020-03-09 08:23:23','2020-03-09 08:23:23'),(303,'\\Employees\\Common\\Mo','indirect-supervisor','89','','2020-03-09 08:23:23','2020-03-09 08:23:23'),(304,'\\Employees\\Common\\Mo','bank_account','90','123456789','2020-03-09 08:23:23','2020-03-09 08:23:23'),(305,'\\Employees\\Common\\Mo','bank_name','90','ABC','2020-03-09 08:23:23','2020-03-09 08:23:23'),(306,'\\Employees\\Common\\Mo','deparment','90','Y Viet','2020-03-09 08:23:23','2020-03-09 08:23:23'),(307,'\\Employees\\Common\\Mo','indirect-supervisor','90','','2020-03-09 08:23:23','2020-03-09 08:23:23'),(308,'\\Employees\\Common\\Mo','bank_account','91','123456789','2020-03-09 08:23:23','2020-03-09 08:23:23'),(309,'\\Employees\\Common\\Mo','bank_name','91','ABC','2020-03-09 08:23:23','2020-03-09 08:23:23'),(310,'\\Employees\\Common\\Mo','deparment','91','Y Viet','2020-03-09 08:23:23','2020-03-09 08:23:23'),(311,'\\Employees\\Common\\Mo','indirect-supervisor','91','','2020-03-09 08:23:24','2020-03-09 08:23:24'),(312,'\\Employees\\Common\\Mo','bank_account','92','123456789','2020-03-09 08:23:24','2020-03-09 08:23:24'),(313,'\\Employees\\Common\\Mo','bank_name','92','ABC','2020-03-09 08:23:24','2020-03-09 08:23:24'),(314,'\\Employees\\Common\\Mo','deparment','92','Y Viet','2020-03-09 08:23:24','2020-03-09 08:23:24'),(315,'\\Employees\\Common\\Mo','indirect-supervisor','92','','2020-03-09 08:23:24','2020-03-09 08:23:24'),(316,'\\Employees\\Common\\Mo','bank_account','93','123456789','2020-03-09 08:23:24','2020-03-09 08:23:24'),(317,'\\Employees\\Common\\Mo','bank_name','93','ABC','2020-03-09 08:23:24','2020-03-09 08:23:24'),(318,'\\Employees\\Common\\Mo','deparment','93','Y Viet','2020-03-09 08:23:24','2020-03-09 08:23:24'),(319,'\\Employees\\Common\\Mo','indirect-supervisor','93','','2020-03-09 08:23:24','2020-03-09 08:23:24'),(320,'\\Employees\\Common\\Mo','bank_account','94','123456789','2020-03-09 08:23:24','2020-03-09 08:23:24'),(321,'\\Employees\\Common\\Mo','bank_name','94','ABC','2020-03-09 08:23:24','2020-03-09 08:23:24'),(322,'\\Employees\\Common\\Mo','deparment','94','Y Viet','2020-03-09 08:23:24','2020-03-09 08:23:24'),(323,'\\Employees\\Common\\Mo','indirect-supervisor','94','NGUYá»„N NGá»ŒC QUANG & VÅ¨ Máº NH TÃš','2020-03-09 08:23:24','2020-03-09 08:23:24'),(324,'\\Employees\\Common\\Mo','bank_account','95','123456789','2020-03-09 08:23:24','2020-03-09 08:23:24'),(325,'\\Employees\\Common\\Mo','bank_name','95','ABC','2020-03-09 08:23:24','2020-03-09 08:23:24'),(326,'\\Employees\\Common\\Mo','deparment','95','Y Viet','2020-03-09 08:23:24','2020-03-09 08:23:24'),(327,'\\Employees\\Common\\Mo','indirect-supervisor','95','','2020-03-09 08:23:24','2020-03-09 08:23:24'),(328,'\\Employees\\Common\\Mo','bank_account','96','123456789','2020-03-09 08:23:24','2020-03-09 08:23:24'),(329,'\\Employees\\Common\\Mo','bank_name','96','ABC','2020-03-09 08:23:24','2020-03-09 08:23:24'),(330,'\\Employees\\Common\\Mo','deparment','96','Y Viet','2020-03-09 08:23:24','2020-03-09 08:23:24'),(331,'\\Employees\\Common\\Mo','indirect-supervisor','96','','2020-03-09 08:23:24','2020-03-09 08:23:24'),(332,'\\Employees\\Common\\Mo','bank_account','97','123456789','2020-03-09 08:23:24','2020-03-09 08:23:24'),(333,'\\Employees\\Common\\Mo','bank_name','97','ABC','2020-03-09 08:23:24','2020-03-09 08:23:24'),(334,'\\Employees\\Common\\Mo','deparment','97','Y Viet','2020-03-09 08:23:24','2020-03-09 08:23:24'),(335,'\\Employees\\Common\\Mo','indirect-supervisor','97','VÅ¨ Máº NH TÃš','2020-03-09 08:23:24','2020-03-09 08:23:24'),(336,'\\Employees\\Common\\Mo','bank_account','98','123456789','2020-03-09 08:23:24','2020-03-09 08:23:24'),(337,'\\Employees\\Common\\Mo','bank_name','98','ABC','2020-03-09 08:23:24','2020-03-09 08:23:24'),(338,'\\Employees\\Common\\Mo','deparment','98','Y Viet','2020-03-09 08:23:24','2020-03-09 08:23:24'),(339,'\\Employees\\Common\\Mo','indirect-supervisor','98','','2020-03-09 08:23:24','2020-03-09 08:23:24'),(340,'\\Employees\\Common\\Mo','bank_account','99','123456789','2020-03-09 08:23:24','2020-03-09 08:23:24'),(341,'\\Employees\\Common\\Mo','bank_name','99','ABC','2020-03-09 08:23:24','2020-03-09 08:23:24'),(342,'\\Employees\\Common\\Mo','deparment','99','Y Viet','2020-03-09 08:23:24','2020-03-09 08:23:24'),(343,'\\Employees\\Common\\Mo','indirect-supervisor','99','','2020-03-09 08:23:24','2020-03-09 08:23:24'),(344,'\\Employees\\Common\\Mo','bank_account','100','123456789','2020-03-09 08:23:24','2020-03-09 08:23:24'),(345,'\\Employees\\Common\\Mo','bank_name','100','ABC','2020-03-09 08:23:24','2020-03-09 08:23:24'),(346,'\\Employees\\Common\\Mo','deparment','100','Y Viet','2020-03-09 08:23:24','2020-03-09 08:23:24'),(347,'\\Employees\\Common\\Mo','indirect-supervisor','100','','2020-03-09 08:23:24','2020-03-09 08:23:24'),(348,'\\Employees\\Common\\Mo','bank_account','101','123456789','2020-03-09 08:23:24','2020-03-09 08:23:24'),(349,'\\Employees\\Common\\Mo','bank_name','101','ABC','2020-03-09 08:23:24','2020-03-09 08:23:24'),(350,'\\Employees\\Common\\Mo','deparment','101','Y Viet','2020-03-09 08:23:24','2020-03-09 08:23:24'),(351,'\\Employees\\Common\\Mo','indirect-supervisor','101','NGUYá»„N NGá»ŒC QUANG','2020-03-09 08:23:24','2020-03-09 08:23:24'),(352,'\\Employees\\Common\\Mo','bank_account','102','123456789','2020-03-09 08:23:24','2020-03-09 08:23:24'),(353,'\\Employees\\Common\\Mo','bank_name','102','ABC','2020-03-09 08:23:24','2020-03-09 08:23:24'),(354,'\\Employees\\Common\\Mo','deparment','102','Y Viet','2020-03-09 08:23:24','2020-03-09 08:23:24'),(355,'\\Employees\\Common\\Mo','indirect-supervisor','102','','2020-03-09 08:23:24','2020-03-09 08:23:24'),(356,'\\Employees\\Common\\Mo','bank_account','103','123456789','2020-03-09 08:23:24','2020-03-09 08:23:24'),(357,'\\Employees\\Common\\Mo','bank_name','103','ABC','2020-03-09 08:23:24','2020-03-09 08:23:24'),(358,'\\Employees\\Common\\Mo','deparment','103','Y Viet','2020-03-09 08:23:24','2020-03-09 08:23:24'),(359,'\\Employees\\Common\\Mo','indirect-supervisor','103','','2020-03-09 08:23:24','2020-03-09 08:23:24'),(360,'\\Employees\\Common\\Mo','bank_account','104','123456789','2020-03-09 08:23:24','2020-03-09 08:23:24'),(361,'\\Employees\\Common\\Mo','bank_name','104','ABC','2020-03-09 08:23:24','2020-03-09 08:23:24'),(362,'\\Employees\\Common\\Mo','deparment','104','Y Viet','2020-03-09 08:23:24','2020-03-09 08:23:24'),(363,'\\Employees\\Common\\Mo','indirect-supervisor','104','','2020-03-09 08:23:24','2020-03-09 08:23:24'),(364,'\\Employees\\Common\\Mo','bank_account','105','123456789','2020-03-09 08:23:24','2020-03-09 08:23:24'),(365,'\\Employees\\Common\\Mo','bank_name','105','ABC','2020-03-09 08:23:24','2020-03-09 08:23:24'),(366,'\\Employees\\Common\\Mo','deparment','105','Y Viet','2020-03-09 08:23:24','2020-03-09 08:23:24'),(367,'\\Employees\\Common\\Mo','indirect-supervisor','105','','2020-03-09 08:23:24','2020-03-09 08:23:24'),(368,'\\Employees\\Common\\Mo','bank_account','106','123456789','2020-03-09 08:23:24','2020-03-09 08:23:24'),(369,'\\Employees\\Common\\Mo','bank_name','106','ABC','2020-03-09 08:23:24','2020-03-09 08:23:24'),(370,'\\Employees\\Common\\Mo','deparment','106','Y Viet','2020-03-09 08:23:24','2020-03-09 08:23:24'),(371,'\\Employees\\Common\\Mo','indirect-supervisor','106','','2020-03-09 08:23:24','2020-03-09 08:23:24'),(372,'\\Employees\\Common\\Mo','bank_account','107','123456789','2020-03-09 08:23:24','2020-03-09 08:23:24'),(373,'\\Employees\\Common\\Mo','bank_name','107','ABC','2020-03-09 08:23:24','2020-03-09 08:23:24'),(374,'\\Employees\\Common\\Mo','deparment','107','Y Viet','2020-03-09 08:23:24','2020-03-09 08:23:24'),(375,'\\Employees\\Common\\Mo','indirect-supervisor','107','','2020-03-09 08:23:24','2020-03-09 08:23:24'),(376,'\\Employees\\Common\\Mo','bank_account','108','123456789','2020-03-09 08:23:24','2020-03-09 08:23:24'),(377,'\\Employees\\Common\\Mo','bank_name','108','ABC','2020-03-09 08:23:24','2020-03-09 08:23:24'),(378,'\\Employees\\Common\\Mo','deparment','108','Y Viet','2020-03-09 08:23:24','2020-03-09 08:23:24'),(379,'\\Employees\\Common\\Mo','indirect-supervisor','108','','2020-03-09 08:23:24','2020-03-09 08:23:24'),(380,'\\Employees\\Common\\Mo','bank_account','109','123456789','2020-03-09 08:23:24','2020-03-09 08:23:24'),(381,'\\Employees\\Common\\Mo','bank_name','109','ABC','2020-03-09 08:23:24','2020-03-09 08:23:24'),(382,'\\Employees\\Common\\Mo','deparment','109','Y Viet','2020-03-09 08:23:24','2020-03-09 08:23:24'),(383,'\\Employees\\Common\\Mo','indirect-supervisor','109','','2020-03-09 08:23:24','2020-03-09 08:23:24'),(384,'\\Employees\\Common\\Mo','bank_account','110','123456789','2020-03-09 08:23:24','2020-03-09 08:23:24'),(385,'\\Employees\\Common\\Mo','bank_name','110','ABC','2020-03-09 08:23:24','2020-03-09 08:23:24'),(386,'\\Employees\\Common\\Mo','deparment','110','Y Viet','2020-03-09 08:23:24','2020-03-09 08:23:24'),(387,'\\Employees\\Common\\Mo','indirect-supervisor','110','','2020-03-09 08:23:24','2020-03-09 08:23:24'),(388,'\\Employees\\Common\\Mo','bank_account','112','123456789','2020-03-10 11:34:50','2020-03-10 11:34:50'),(389,'\\Employees\\Common\\Mo','bank_name','112','ABC','2020-03-10 11:34:50','2020-03-10 11:34:50'),(390,'\\Employees\\Common\\Mo','deparment','112','Y Viet','2020-03-10 11:34:50','2020-03-10 11:34:50'),(391,'\\Employees\\Common\\Mo','indirect-supervisor','112','','2020-03-10 11:34:50','2020-03-10 11:34:50'),(392,'\\Employees\\Common\\Mo','bank_account','113','123456789','2020-03-10 11:34:50','2020-03-10 11:34:50'),(393,'\\Employees\\Common\\Mo','bank_name','113','ABC','2020-03-10 11:34:50','2020-03-10 11:34:50'),(394,'\\Employees\\Common\\Mo','deparment','113','Y Viet','2020-03-10 11:34:50','2020-03-10 11:34:50'),(395,'\\Employees\\Common\\Mo','indirect-supervisor','113','','2020-03-10 11:34:50','2020-03-10 11:34:50'),(396,'\\Employees\\Common\\Mo','bank_account','114','123456789','2020-03-10 11:34:50','2020-03-10 11:34:50'),(397,'\\Employees\\Common\\Mo','bank_name','114','ABC','2020-03-10 11:34:50','2020-03-10 11:34:50'),(398,'\\Employees\\Common\\Mo','deparment','114','Y Viet','2020-03-10 11:34:50','2020-03-10 11:34:50'),(399,'\\Employees\\Common\\Mo','indirect-supervisor','114','','2020-03-10 11:34:50','2020-03-10 11:34:50'),(400,'\\Employees\\Common\\Mo','bank_account','115','123456789','2020-03-10 11:34:50','2020-03-10 11:34:50'),(401,'\\Employees\\Common\\Mo','bank_name','115','ABC','2020-03-10 11:34:50','2020-03-10 11:34:50'),(402,'\\Employees\\Common\\Mo','deparment','115','Y Viet','2020-03-10 11:34:50','2020-03-10 11:34:50'),(403,'\\Employees\\Common\\Mo','indirect-supervisor','115','','2020-03-10 11:34:50','2020-03-10 11:34:50'),(404,'\\Employees\\Common\\Mo','bank_account','116','123456789','2020-03-10 11:34:51','2020-03-10 11:34:51'),(405,'\\Employees\\Common\\Mo','bank_name','116','ABC','2020-03-10 11:34:51','2020-03-10 11:34:51'),(406,'\\Employees\\Common\\Mo','deparment','116','Y Viet','2020-03-10 11:34:51','2020-03-10 11:34:51'),(407,'\\Employees\\Common\\Mo','indirect-supervisor','116','','2020-03-10 11:34:51','2020-03-10 11:34:51'),(408,'\\Employees\\Common\\Mo','bank_account','117','123456789','2020-03-10 11:34:51','2020-03-10 11:34:51'),(409,'\\Employees\\Common\\Mo','bank_name','117','ABC','2020-03-10 11:34:51','2020-03-10 11:34:51'),(410,'\\Employees\\Common\\Mo','deparment','117','Y Viet','2020-03-10 11:34:51','2020-03-10 11:34:51'),(411,'\\Employees\\Common\\Mo','indirect-supervisor','117','','2020-03-10 11:34:51','2020-03-10 11:34:51'),(412,'\\Employees\\Common\\Mo','bank_account','118','123456789','2020-03-10 11:34:51','2020-03-10 11:34:51'),(413,'\\Employees\\Common\\Mo','bank_name','118','ABC','2020-03-10 11:34:51','2020-03-10 11:34:51'),(414,'\\Employees\\Common\\Mo','deparment','118','Y Viet','2020-03-10 11:34:51','2020-03-10 11:34:51'),(415,'\\Employees\\Common\\Mo','indirect-supervisor','118','','2020-03-10 11:34:51','2020-03-10 11:34:51'),(416,'\\Employees\\Common\\Mo','bank_account','119','123456789','2020-03-10 11:34:51','2020-03-10 11:34:51'),(417,'\\Employees\\Common\\Mo','bank_name','119','ABC','2020-03-10 11:34:51','2020-03-10 11:34:51'),(418,'\\Employees\\Common\\Mo','deparment','119','Y Viet','2020-03-10 11:34:51','2020-03-10 11:34:51'),(419,'\\Employees\\Common\\Mo','indirect-supervisor','119','','2020-03-10 11:34:51','2020-03-10 11:34:51'),(420,'\\Employees\\Common\\Mo','bank_account','120','123456789','2020-03-10 11:34:51','2020-03-10 11:34:51'),(421,'\\Employees\\Common\\Mo','bank_name','120','ABC','2020-03-10 11:34:51','2020-03-10 11:34:51'),(422,'\\Employees\\Common\\Mo','deparment','120','Y Viet','2020-03-10 11:34:51','2020-03-10 11:34:51'),(423,'\\Employees\\Common\\Mo','indirect-supervisor','120','','2020-03-10 11:34:51','2020-03-10 11:34:51'),(424,'\\Employees\\Common\\Mo','bank_account','121','123456789','2020-03-10 11:34:51','2020-03-10 11:34:51'),(425,'\\Employees\\Common\\Mo','bank_name','121','ABC','2020-03-10 11:34:51','2020-03-10 11:34:51'),(426,'\\Employees\\Common\\Mo','deparment','121','Y Viet','2020-03-10 11:34:51','2020-03-10 11:34:51'),(427,'\\Employees\\Common\\Mo','indirect-supervisor','121','','2020-03-10 11:34:51','2020-03-10 11:34:51'),(428,'\\Employees\\Common\\Mo','bank_account','122','123456789','2020-03-10 11:34:51','2020-03-10 11:34:51'),(429,'\\Employees\\Common\\Mo','bank_name','122','ABC','2020-03-10 11:34:51','2020-03-10 11:34:51'),(430,'\\Employees\\Common\\Mo','deparment','122','Y Viet','2020-03-10 11:34:51','2020-03-10 11:34:51'),(431,'\\Employees\\Common\\Mo','indirect-supervisor','122','','2020-03-10 11:34:51','2020-03-10 11:34:51'),(432,'\\Employees\\Common\\Mo','bank_account','123','123456789','2020-03-10 11:34:51','2020-03-10 11:34:51'),(433,'\\Employees\\Common\\Mo','bank_name','123','ABC','2020-03-10 11:34:51','2020-03-10 11:34:51'),(434,'\\Employees\\Common\\Mo','deparment','123','Y Viet','2020-03-10 11:34:51','2020-03-10 11:34:51'),(435,'\\Employees\\Common\\Mo','indirect-supervisor','123','','2020-03-10 11:34:51','2020-03-10 11:34:51'),(436,'\\Employees\\Common\\Mo','bank_account','124','123456789','2020-03-10 11:34:51','2020-03-10 11:34:51'),(437,'\\Employees\\Common\\Mo','bank_name','124','ABC','2020-03-10 11:34:51','2020-03-10 11:34:51'),(438,'\\Employees\\Common\\Mo','deparment','124','Y Viet','2020-03-10 11:34:51','2020-03-10 11:34:51'),(439,'\\Employees\\Common\\Mo','indirect-supervisor','124','','2020-03-10 11:34:51','2020-03-10 11:34:51'),(440,'\\Employees\\Common\\Mo','bank_account','125','123456789','2020-03-10 11:34:51','2020-03-10 11:34:51'),(441,'\\Employees\\Common\\Mo','bank_name','125','ABC','2020-03-10 11:34:51','2020-03-10 11:34:51'),(442,'\\Employees\\Common\\Mo','deparment','125','Y Viet','2020-03-10 11:34:51','2020-03-10 11:34:51'),(443,'\\Employees\\Common\\Mo','indirect-supervisor','125','','2020-03-10 11:34:51','2020-03-10 11:34:51'),(444,'\\Employees\\Common\\Mo','bank_account','126','123456789','2020-03-10 11:34:51','2020-03-10 11:34:51'),(445,'\\Employees\\Common\\Mo','bank_name','126','ABC','2020-03-10 11:34:51','2020-03-10 11:34:51'),(446,'\\Employees\\Common\\Mo','deparment','126','Y Viet','2020-03-10 11:34:51','2020-03-10 11:34:51'),(447,'\\Employees\\Common\\Mo','indirect-supervisor','126','','2020-03-10 11:34:51','2020-03-10 11:34:51'),(448,'\\Employees\\Common\\Mo','bank_account','127','123456789','2020-03-10 11:34:51','2020-03-10 11:34:51'),(449,'\\Employees\\Common\\Mo','bank_name','127','ABC','2020-03-10 11:34:51','2020-03-10 11:34:51'),(450,'\\Employees\\Common\\Mo','deparment','127','Y Viet','2020-03-10 11:34:51','2020-03-10 11:34:51'),(451,'\\Employees\\Common\\Mo','indirect-supervisor','127','NGUYá»„N NGá»ŒC QUANG & VÅ¨ Máº NH TÃš','2020-03-10 11:34:51','2020-03-10 11:34:51'),(452,'\\Employees\\Common\\Mo','bank_account','128','123456789','2020-03-10 11:34:51','2020-03-10 11:34:51'),(453,'\\Employees\\Common\\Mo','bank_name','128','ABC','2020-03-10 11:34:51','2020-03-10 11:34:51'),(454,'\\Employees\\Common\\Mo','deparment','128','Y Viet','2020-03-10 11:34:51','2020-03-10 11:34:51'),(455,'\\Employees\\Common\\Mo','indirect-supervisor','128','','2020-03-10 11:34:51','2020-03-10 11:34:51'),(456,'\\Employees\\Common\\Mo','bank_account','129','123456789','2020-03-10 11:34:51','2020-03-10 11:34:51'),(457,'\\Employees\\Common\\Mo','bank_name','129','ABC','2020-03-10 11:34:51','2020-03-10 11:34:51'),(458,'\\Employees\\Common\\Mo','deparment','129','Y Viet','2020-03-10 11:34:51','2020-03-10 11:34:51'),(459,'\\Employees\\Common\\Mo','indirect-supervisor','129','','2020-03-10 11:34:51','2020-03-10 11:34:51'),(460,'\\Employees\\Common\\Mo','bank_account','130','123456789','2020-03-10 11:34:51','2020-03-10 11:34:51'),(461,'\\Employees\\Common\\Mo','bank_name','130','ABC','2020-03-10 11:34:51','2020-03-10 11:34:51'),(462,'\\Employees\\Common\\Mo','deparment','130','Y Viet','2020-03-10 11:34:51','2020-03-10 11:34:51'),(463,'\\Employees\\Common\\Mo','indirect-supervisor','130','VÅ¨ Máº NH TÃš','2020-03-10 11:34:51','2020-03-10 11:34:51'),(464,'\\Employees\\Common\\Mo','bank_account','131','123456789','2020-03-10 11:34:51','2020-03-10 11:34:51'),(465,'\\Employees\\Common\\Mo','bank_name','131','ABC','2020-03-10 11:34:51','2020-03-10 11:34:51'),(466,'\\Employees\\Common\\Mo','deparment','131','Y Viet','2020-03-10 11:34:51','2020-03-10 11:34:51'),(467,'\\Employees\\Common\\Mo','indirect-supervisor','131','','2020-03-10 11:34:51','2020-03-10 11:34:51'),(468,'\\Employees\\Common\\Mo','bank_account','132','123456789','2020-03-10 11:34:51','2020-03-10 11:34:51'),(469,'\\Employees\\Common\\Mo','bank_name','132','ABC','2020-03-10 11:34:51','2020-03-10 11:34:51'),(470,'\\Employees\\Common\\Mo','deparment','132','Y Viet','2020-03-10 11:34:51','2020-03-10 11:34:51'),(471,'\\Employees\\Common\\Mo','indirect-supervisor','132','','2020-03-10 11:34:51','2020-03-10 11:34:51'),(472,'\\Employees\\Common\\Mo','bank_account','133','123456789','2020-03-10 11:34:51','2020-03-10 11:34:51'),(473,'\\Employees\\Common\\Mo','bank_name','133','ABC','2020-03-10 11:34:51','2020-03-10 11:34:51'),(474,'\\Employees\\Common\\Mo','deparment','133','Y Viet','2020-03-10 11:34:51','2020-03-10 11:34:51'),(475,'\\Employees\\Common\\Mo','indirect-supervisor','133','','2020-03-10 11:34:51','2020-03-10 11:34:51'),(476,'\\Employees\\Common\\Mo','bank_account','134','123456789','2020-03-10 11:34:51','2020-03-10 11:34:51'),(477,'\\Employees\\Common\\Mo','bank_name','134','ABC','2020-03-10 11:34:51','2020-03-10 11:34:51'),(478,'\\Employees\\Common\\Mo','deparment','134','Y Viet','2020-03-10 11:34:51','2020-03-10 11:34:51'),(479,'\\Employees\\Common\\Mo','indirect-supervisor','134','NGUYá»„N NGá»ŒC QUANG','2020-03-10 11:34:51','2020-03-10 11:34:51'),(480,'\\Employees\\Common\\Mo','bank_account','135','123456789','2020-03-10 11:34:51','2020-03-10 11:34:51'),(481,'\\Employees\\Common\\Mo','bank_name','135','ABC','2020-03-10 11:34:51','2020-03-10 11:34:51'),(482,'\\Employees\\Common\\Mo','deparment','135','Y Viet','2020-03-10 11:34:51','2020-03-10 11:34:51'),(483,'\\Employees\\Common\\Mo','indirect-supervisor','135','','2020-03-10 11:34:51','2020-03-10 11:34:51'),(484,'\\Employees\\Common\\Mo','bank_account','136','123456789','2020-03-10 11:34:51','2020-03-10 11:34:51'),(485,'\\Employees\\Common\\Mo','bank_name','136','ABC','2020-03-10 11:34:51','2020-03-10 11:34:51'),(486,'\\Employees\\Common\\Mo','deparment','136','Y Viet','2020-03-10 11:34:51','2020-03-10 11:34:51'),(487,'\\Employees\\Common\\Mo','indirect-supervisor','136','','2020-03-10 11:34:51','2020-03-10 11:34:51'),(488,'\\Employees\\Common\\Mo','bank_account','137','123456789','2020-03-10 11:34:51','2020-03-10 11:34:51'),(489,'\\Employees\\Common\\Mo','bank_name','137','ABC','2020-03-10 11:34:51','2020-03-10 11:34:51'),(490,'\\Employees\\Common\\Mo','deparment','137','Y Viet','2020-03-10 11:34:51','2020-03-10 11:34:51'),(491,'\\Employees\\Common\\Mo','indirect-supervisor','137','','2020-03-10 11:34:51','2020-03-10 11:34:51'),(492,'\\Employees\\Common\\Mo','bank_account','138','123456789','2020-03-10 11:34:51','2020-03-10 11:34:51'),(493,'\\Employees\\Common\\Mo','bank_name','138','ABC','2020-03-10 11:34:51','2020-03-10 11:34:51'),(494,'\\Employees\\Common\\Mo','deparment','138','Y Viet','2020-03-10 11:34:51','2020-03-10 11:34:51'),(495,'\\Employees\\Common\\Mo','indirect-supervisor','138','','2020-03-10 11:34:51','2020-03-10 11:34:51'),(496,'\\Employees\\Common\\Mo','bank_account','139','123456789','2020-03-10 11:34:51','2020-03-10 11:34:51'),(497,'\\Employees\\Common\\Mo','bank_name','139','ABC','2020-03-10 11:34:51','2020-03-10 11:34:51'),(498,'\\Employees\\Common\\Mo','deparment','139','Y Viet','2020-03-10 11:34:51','2020-03-10 11:34:51'),(499,'\\Employees\\Common\\Mo','indirect-supervisor','139','','2020-03-10 11:34:51','2020-03-10 11:34:51'),(500,'\\Employees\\Common\\Mo','bank_account','140','123456789','2020-03-10 11:34:51','2020-03-10 11:34:51'),(501,'\\Employees\\Common\\Mo','bank_name','140','ABC','2020-03-10 11:34:51','2020-03-10 11:34:51'),(502,'\\Employees\\Common\\Mo','deparment','140','Y Viet','2020-03-10 11:34:51','2020-03-10 11:34:51'),(503,'\\Employees\\Common\\Mo','indirect-supervisor','140','','2020-03-10 11:34:51','2020-03-10 11:34:51'),(504,'\\Employees\\Common\\Mo','bank_account','141','123456789','2020-03-10 11:34:51','2020-03-10 11:34:51'),(505,'\\Employees\\Common\\Mo','bank_name','141','ABC','2020-03-10 11:34:51','2020-03-10 11:34:51'),(506,'\\Employees\\Common\\Mo','deparment','141','Y Viet','2020-03-10 11:34:51','2020-03-10 11:34:51'),(507,'\\Employees\\Common\\Mo','indirect-supervisor','141','','2020-03-10 11:34:51','2020-03-10 11:34:51'),(508,'\\Employees\\Common\\Mo','bank_account','142','123456789','2020-03-10 11:34:51','2020-03-10 11:34:51'),(509,'\\Employees\\Common\\Mo','bank_name','142','ABC','2020-03-10 11:34:51','2020-03-10 11:34:51'),(510,'\\Employees\\Common\\Mo','deparment','142','Y Viet','2020-03-10 11:34:51','2020-03-10 11:34:51'),(511,'\\Employees\\Common\\Mo','indirect-supervisor','142','','2020-03-10 11:34:51','2020-03-10 11:34:51'),(512,'\\Employees\\Common\\Mo','bank_account','143','123456789','2020-03-10 11:34:51','2020-03-10 11:34:51'),(513,'\\Employees\\Common\\Mo','bank_name','143','ABC','2020-03-10 11:34:51','2020-03-10 11:34:51'),(514,'\\Employees\\Common\\Mo','deparment','143','Y Viet','2020-03-10 11:34:51','2020-03-10 11:34:51'),(515,'\\Employees\\Common\\Mo','indirect-supervisor','143','','2020-03-10 11:34:51','2020-03-10 11:34:51');
/*!40000 ALTER TABLE `CustomFieldValues` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CustomFields`
--

DROP TABLE IF EXISTS `CustomFields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `CustomFields` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `type` varchar(20) NOT NULL,
  `name` varchar(20) NOT NULL,
  `data` text,
  `display` enum('Form','Table and Form','Hidden') DEFAULT 'Form',
  `created` datetime DEFAULT NULL,
  `updated` datetime DEFAULT NULL,
  `field_type` varchar(20) DEFAULT NULL,
  `field_label` varchar(50) DEFAULT NULL,
  `field_validation` varchar(50) DEFAULT NULL,
  `field_options` varchar(500) DEFAULT NULL,
  `display_order` int(11) DEFAULT '0',
  `display_section` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `CustomFields_name` (`type`,`name`)
) ENGINE=InnoDB AUTO_INCREMENT=513 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CustomFields`
--

LOCK TABLES `CustomFields` WRITE;
/*!40000 ALTER TABLE `CustomFields` DISABLE KEYS */;
INSERT INTO `CustomFields` VALUES (1,'\\Employees\\Common\\Mo','bank_account',NULL,'Form',NULL,NULL,'text','','none',NULL,0,NULL),(2,'\\Employees\\Common\\Mo','bank_name',NULL,'Form',NULL,NULL,'text','','none',NULL,0,NULL),(3,'\\Employees\\Common\\Mo','deparment',NULL,'Form',NULL,NULL,'text','','none',NULL,0,NULL),(4,'\\Employees\\Common\\Mo','indirect-supervisor',NULL,'Form',NULL,NULL,'text','','none',NULL,0,NULL);
/*!40000 ALTER TABLE `CustomFields` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `DataEntryBackups`
--

DROP TABLE IF EXISTS `DataEntryBackups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `DataEntryBackups` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `tableType` varchar(200) DEFAULT NULL,
  `data` longtext,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `DataEntryBackups`
--

LOCK TABLES `DataEntryBackups` WRITE;
/*!40000 ALTER TABLE `DataEntryBackups` DISABLE KEYS */;
/*!40000 ALTER TABLE `DataEntryBackups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `DataImport`
--

DROP TABLE IF EXISTS `DataImport`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `DataImport` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(60) NOT NULL,
  `dataType` varchar(60) NOT NULL,
  `details` text,
  `columns` text,
  `updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `DataImport`
--

LOCK TABLES `DataImport` WRITE;
/*!40000 ALTER TABLE `DataImport` DISABLE KEYS */;
INSERT INTO `DataImport` VALUES (1,'Employee Data Import','EmployeeDataImporter','','[{\"name\":\"employee_id\",\"title\":\"\",\"type\":\"Normal\",\"dependOn\":\"NULL\",\"dependOnField\":\"\",\"isKeyField\":\"No\",\"idField\":\"No\",\"id\":\"columns_33\"},{\"name\":\"first_name\",\"title\":\"\",\"type\":\"Normal\",\"dependOn\":\"NULL\",\"dependOnField\":\"\",\"isKeyField\":\"No\",\"idField\":\"No\",\"id\":\"columns_3\"},{\"name\":\"birthday\",\"title\":\"\",\"type\":\"Normal\",\"dependOn\":\"NULL\",\"dependOnField\":\"\",\"isKeyField\":\"No\",\"idField\":\"No\",\"id\":\"columns_20\"},{\"name\":\"joined_date\",\"title\":\"\",\"type\":\"Normal\",\"dependOn\":\"NULL\",\"dependOnField\":\"\",\"isKeyField\":\"No\",\"idField\":\"No\",\"id\":\"columns_34\"},{\"name\":\"bank_account\",\"title\":\"\",\"type\":\"Normal\",\"dependOn\":\"NULL\",\"dependOnField\":\"\",\"isKeyField\":\"Yes\",\"idField\":\"No\",\"id\":\"columns_35\"},{\"name\":\"bank_name\",\"title\":\"\",\"type\":\"Normal\",\"dependOn\":\"NULL\",\"dependOnField\":\"\",\"isKeyField\":\"Yes\",\"idField\":\"No\",\"id\":\"columns_36\"},{\"name\":\"deparment\",\"title\":\"\",\"type\":\"Normal\",\"dependOn\":\"NULL\",\"dependOnField\":\"\",\"isKeyField\":\"No\",\"idField\":\"No\",\"id\":\"columns_37\"},{\"name\":\"job_title\",\"title\":\"\",\"type\":\"Normal\",\"dependOn\":\"NULL\",\"dependOnField\":\"\",\"isKeyField\":\"No\",\"idField\":\"No\",\"id\":\"columns_32\"},{\"name\":\"supervisor\",\"title\":\"\",\"type\":\"Normal\",\"dependOn\":\"NULL\",\"dependOnField\":\"\",\"isKeyField\":\"No\",\"idField\":\"No\",\"id\":\"columns_38\"},{\"name\":\"indirect-supervisor\",\"title\":\"\",\"type\":\"Normal\",\"dependOn\":\"NULL\",\"dependOnField\":\"\",\"isKeyField\":\"No\",\"idField\":\"No\",\"id\":\"columns_39\"}]','2016-06-02 18:56:32','2016-06-02 18:56:32'),(2,'Attendance Data Import','AttendanceDataImporter','','[{\"name\":\"employee\",\"title\":\"\",\"type\":\"Reference\",\"dependOn\":\"Employee\",\"dependOnField\":\"employee_id\",\"isKeyField\":\"Yes\",\"idField\":\"No\",\"id\":\"columns_1\"},{\"name\":\"in_time\",\"title\":\"\",\"type\":\"Normal\",\"dependOn\":\"NULL\",\"dependOnField\":\"\",\"isKeyField\":\"No\",\"idField\":\"No\",\"id\":\"columns_2\"},{\"name\":\"out_time\",\"title\":\"\",\"type\":\"Normal\",\"dependOn\":\"NULL\",\"dependOnField\":\"\",\"isKeyField\":\"No\",\"idField\":\"No\",\"id\":\"columns_3\"},{\"name\":\"note\",\"title\":\"\",\"type\":\"Normal\",\"dependOn\":\"NULL\",\"dependOnField\":\"\",\"isKeyField\":\"No\",\"idField\":\"No\",\"id\":\"columns_4\"}]','2016-08-14 02:51:56','2016-08-14 02:51:56'),(3,'Payroll Data Import','PayrollDataImporter','','[]','2016-08-14 02:51:56','2016-08-14 02:51:56');
/*!40000 ALTER TABLE `DataImport` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `DataImportFiles`
--

DROP TABLE IF EXISTS `DataImportFiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `DataImportFiles` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(60) NOT NULL,
  `data_import_definition` varchar(200) NOT NULL,
  `status` varchar(15) DEFAULT NULL,
  `file` varchar(100) DEFAULT NULL,
  `details` text,
  `updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `DataImportFiles`
--

LOCK TABLES `DataImportFiles` WRITE;
/*!40000 ALTER TABLE `DataImportFiles` DISABLE KEYS */;
INSERT INTO `DataImportFiles` VALUES (5,'Danh sach nhan vien','1','Processed','file_6fHpJptHOsrfaB1583820245731','[\n    [\n        [\n            \"1\",\n            \"TR\\u1ea6N TH\\u1eca KIM THOA\",\n            \"08\\/06\\/1990\",\n            \"08\\/06\\/2015\",\n            \"123456789\",\n            \"ABC\",\n            \"Y Viet\",\n            \"Tr\\u1ee3 l\\u00fd T\\u1ed5ng Gi\\u00e1m \\u0110\\u1ed1c & quy\\u1ec1n gi\\u00e1m \\u0111\\u1ed1c Vmed\",\n            \"Ph\\u1ea1m Hu\\u1ef3nh Long\",\n            \"\",\n            \"0\",\n            \"0\",\n            \"0\"\n        ],\n        {\n            \"MainId\": 112,\n            \"CustomFields\": [\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    112,\n                    \"bank_account\",\n                    \"123456789\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    112,\n                    \"bank_name\",\n                    \"ABC\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    112,\n                    \"deparment\",\n                    \"Y Viet\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    112,\n                    \"indirect-supervisor\",\n                    \"\"\n                ]\n            ]\n        }\n    ],\n    [\n        [\n            \"2\",\n            \"TR\\u1ea6N TH\\u1eca TR\\u00daC MAI \",\n            \"08\\/07\\/1990\",\n            \"08\\/07\\/2015\",\n            \"123456789\",\n            \"ABC\",\n            \"Y Viet\",\n            \"Tr\\u01b0\\u1edfng ph\\u00f2ng h\\u1ed7 tr\\u1ee3 kinh doanh & d\\u1ef1 \\u00e1n\",\n            \"TR\\u1ea6N TH\\u1eca KIM THOA\",\n            \"\",\n            \"0\",\n            \"0\",\n            \"0\"\n        ],\n        {\n            \"MainId\": 113,\n            \"CustomFields\": [\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    113,\n                    \"bank_account\",\n                    \"123456789\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    113,\n                    \"bank_name\",\n                    \"ABC\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    113,\n                    \"deparment\",\n                    \"Y Viet\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    113,\n                    \"indirect-supervisor\",\n                    \"\"\n                ]\n            ]\n        }\n    ],\n    [\n        [\n            \"3\",\n            \"NGUY\\u1ec4N NH\\u1eacT KH\\u00c1NH TRANG\",\n            \"08\\/08\\/1990\",\n            \"08\\/08\\/2015\",\n            \"123456789\",\n            \"ABC\",\n            \"Y Viet\",\n            \"Nh\\u00e2n vi\\u00ean h\\u1ed7 tr\\u1ee3 kinh doanh & d\\u1ef1 \\u00e1n\",\n            \"TR\\u1ea6N TH\\u1eca TR\\u00daC MAI \",\n            \"\",\n            \"0\",\n            \"0\",\n            \"0\"\n        ],\n        {\n            \"MainId\": 114,\n            \"CustomFields\": [\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    114,\n                    \"bank_account\",\n                    \"123456789\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    114,\n                    \"bank_name\",\n                    \"ABC\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    114,\n                    \"deparment\",\n                    \"Y Viet\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    114,\n                    \"indirect-supervisor\",\n                    \"\"\n                ]\n            ]\n        }\n    ],\n    [\n        [\n            \"4\",\n            \"B\\u00d9I TH\\u1eca TH\\u00daY\",\n            \"08\\/09\\/1990\",\n            \"08\\/09\\/2015\",\n            \"123456789\",\n            \"ABC\",\n            \"Y Viet\",\n            \"Nh\\u00e2n vi\\u00ean h\\u1ed7 tr\\u1ee3 kinh doanh & d\\u1ef1 \\u00e1n\",\n            \"TR\\u1ea6N TH\\u1eca TR\\u00daC MAI \",\n            \"\",\n            \"0\",\n            \"0\",\n            \"0\"\n        ],\n        {\n            \"MainId\": 115,\n            \"CustomFields\": [\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    115,\n                    \"bank_account\",\n                    \"123456789\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    115,\n                    \"bank_name\",\n                    \"ABC\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    115,\n                    \"deparment\",\n                    \"Y Viet\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    115,\n                    \"indirect-supervisor\",\n                    \"\"\n                ]\n            ]\n        }\n    ],\n    [\n        [\n            \"5\",\n            \"NGUY\\u1ec4N NG\\u1eccC UY\\u00caN\",\n            \"08\\/10\\/1990\",\n            \"08\\/10\\/2015\",\n            \"123456789\",\n            \"ABC\",\n            \"Y Viet\",\n            \"Gi\\u00e1m \\u0111\\u1ed1c t\\u00e0i ch\\u00ednh & nh\\u00e2n s\\u1ef1\",\n            \"Ph\\u1ea1m Hu\\u1ef3nh Long\",\n            \"\",\n            \"0\",\n            \"0\",\n            \"0\"\n        ],\n        {\n            \"MainId\": 116,\n            \"CustomFields\": [\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    116,\n                    \"bank_account\",\n                    \"123456789\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    116,\n                    \"bank_name\",\n                    \"ABC\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    116,\n                    \"deparment\",\n                    \"Y Viet\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    116,\n                    \"indirect-supervisor\",\n                    \"\"\n                ]\n            ]\n        }\n    ],\n    [\n        [\n            \"6\",\n            \"\\u0110\\u00c0O \\u00c1NH NGUY\\u1ec6T\",\n            \"08\\/11\\/1990\",\n            \"08\\/11\\/2015\",\n            \"123456789\",\n            \"ABC\",\n            \"Y Viet\",\n            \"Nh\\u00e2n vi\\u00ean k\\u1ebf to\\u00e1n\",\n            \"NGUY\\u1ec4N NG\\u1eccC UY\\u00caN\",\n            \"\",\n            \"0\",\n            \"0\",\n            \"0\"\n        ],\n        {\n            \"MainId\": 117,\n            \"CustomFields\": [\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    117,\n                    \"bank_account\",\n                    \"123456789\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    117,\n                    \"bank_name\",\n                    \"ABC\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    117,\n                    \"deparment\",\n                    \"Y Viet\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    117,\n                    \"indirect-supervisor\",\n                    \"\"\n                ]\n            ]\n        }\n    ],\n    [\n        [\n            \"7\",\n            \"TR\\u1ea6N KIM HOA \",\n            \"08\\/12\\/1990\",\n            \"08\\/12\\/2015\",\n            \"123456789\",\n            \"ABC\",\n            \"Y Viet\",\n            \"Nh\\u00e2n vi\\u00ean k\\u1ebf to\\u00e1n\",\n            \"NGUY\\u1ec4N NG\\u1eccC UY\\u00caN\",\n            \"\",\n            \"0\",\n            \"0\",\n            \"0\"\n        ],\n        {\n            \"MainId\": 118,\n            \"CustomFields\": [\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    118,\n                    \"bank_account\",\n                    \"123456789\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    118,\n                    \"bank_name\",\n                    \"ABC\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    118,\n                    \"deparment\",\n                    \"Y Viet\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    118,\n                    \"indirect-supervisor\",\n                    \"\"\n                ]\n            ]\n        }\n    ],\n    [\n        [\n            \"8\",\n            \"TR\\u1ea6N TH\\u1ee4Y MINH TRANG\",\n            \"08\\/13\\/1990\",\n            \"08\\/13\\/2015\",\n            \"123456789\",\n            \"ABC\",\n            \"Y Viet\",\n            \"Chuy\\u00ean vi\\u00ean nh\\u00e2n s\\u1ef1 & Th\\u1ee7 qu\\u1ef9\",\n            \"NGUY\\u1ec4N NG\\u1eccC UY\\u00caN\",\n            \"\",\n            \"0\",\n            \"0\",\n            \"0\"\n        ],\n        {\n            \"MainId\": 119,\n            \"CustomFields\": [\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    119,\n                    \"bank_account\",\n                    \"123456789\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    119,\n                    \"bank_name\",\n                    \"ABC\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    119,\n                    \"deparment\",\n                    \"Y Viet\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    119,\n                    \"indirect-supervisor\",\n                    \"\"\n                ]\n            ]\n        }\n    ],\n    [\n        [\n            \"9\",\n            \"NGUY\\u1ec4N CH\\u00c2U PH\\u01af\\u01a0NG\",\n            \"08\\/14\\/1990\",\n            \"08\\/14\\/2015\",\n            \"123456789\",\n            \"ABC\",\n            \"Y Viet\",\n            \"T\\u00e0i x\\u1ebf tr\\u01b0\\u1edfng\",\n            \"TR\\u1ea6N TH\\u1ee4Y MINH TRANG\",\n            \"\",\n            \"0\",\n            \"0\",\n            \"0\"\n        ],\n        {\n            \"MainId\": 120,\n            \"CustomFields\": [\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    120,\n                    \"bank_account\",\n                    \"123456789\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    120,\n                    \"bank_name\",\n                    \"ABC\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    120,\n                    \"deparment\",\n                    \"Y Viet\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    120,\n                    \"indirect-supervisor\",\n                    \"\"\n                ]\n            ]\n        }\n    ],\n    [\n        [\n            \"10\",\n            \"T\\u0102NG TR\\u1ea6N TU\\u1ea4N TH\\u00c0NH \",\n            \"08\\/15\\/1990\",\n            \"08\\/15\\/2015\",\n            \"123456789\",\n            \"ABC\",\n            \"Y Viet\",\n            \"T\\u00e0i x\\u1ebf  \",\n            \"TR\\u1ea6N TH\\u1ee4Y MINH TRANG\",\n            \"\",\n            \"0\",\n            \"0\",\n            \"0\"\n        ],\n        {\n            \"MainId\": 121,\n            \"CustomFields\": [\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    121,\n                    \"bank_account\",\n                    \"123456789\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    121,\n                    \"bank_name\",\n                    \"ABC\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    121,\n                    \"deparment\",\n                    \"Y Viet\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    121,\n                    \"indirect-supervisor\",\n                    \"\"\n                ]\n            ]\n        }\n    ],\n    [\n        [\n            \"11\",\n            \"TR\\u1ea6N QUANG THU\\u1eacT\",\n            \"08\\/16\\/1990\",\n            \"08\\/16\\/2015\",\n            \"123456789\",\n            \"ABC\",\n            \"Y Viet\",\n            \"T\\u00e0i x\\u1ebf\",\n            \"TR\\u1ea6N TH\\u1ee4Y MINH TRANG\",\n            \"\",\n            \"0\",\n            \"0\",\n            \"0\"\n        ],\n        {\n            \"MainId\": 122,\n            \"CustomFields\": [\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    122,\n                    \"bank_account\",\n                    \"123456789\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    122,\n                    \"bank_name\",\n                    \"ABC\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    122,\n                    \"deparment\",\n                    \"Y Viet\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    122,\n                    \"indirect-supervisor\",\n                    \"\"\n                ]\n            ]\n        }\n    ],\n    [\n        [\n            \"12\",\n            \"TR\\u1ea6N V\\u0102N TI\\u1ec6P\",\n            \"08\\/17\\/1990\",\n            \"08\\/17\\/2015\",\n            \"123456789\",\n            \"ABC\",\n            \"Y Viet\",\n            \"T\\u00e0i x\\u1ebf\",\n            \"TR\\u1ea6N TH\\u1ee4Y MINH TRANG\",\n            \"\",\n            \"0\",\n            \"0\",\n            \"0\"\n        ],\n        {\n            \"MainId\": 123,\n            \"CustomFields\": [\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    123,\n                    \"bank_account\",\n                    \"123456789\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    123,\n                    \"bank_name\",\n                    \"ABC\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    123,\n                    \"deparment\",\n                    \"Y Viet\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    123,\n                    \"indirect-supervisor\",\n                    \"\"\n                ]\n            ]\n        }\n    ],\n    [\n        [\n            \"13\",\n            \"HU\\u1ef2NH NGUY\\u1ec6T TH\\u1ee6Y\",\n            \"08\\/18\\/1990\",\n            \"08\\/18\\/2015\",\n            \"123456789\",\n            \"ABC\",\n            \"Y Viet\",\n            \"T\\u1ea1p v\\u1ee5\",\n            \"TR\\u1ea6N TH\\u1ee4Y MINH TRANG\",\n            \"\",\n            \"0\",\n            \"0\",\n            \"0\"\n        ],\n        {\n            \"MainId\": 124,\n            \"CustomFields\": [\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    124,\n                    \"bank_account\",\n                    \"123456789\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    124,\n                    \"bank_name\",\n                    \"ABC\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    124,\n                    \"deparment\",\n                    \"Y Viet\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    124,\n                    \"indirect-supervisor\",\n                    \"\"\n                ]\n            ]\n        }\n    ],\n    [\n        [\n            \"14\",\n            \"NGUY\\u1ec4N MINH T\\u00c2M\",\n            \"08\\/19\\/1990\",\n            \"08\\/19\\/2015\",\n            \"123456789\",\n            \"ABC\",\n            \"Y Viet\",\n            \"B\\u1ea3o v\\u1ec7\",\n            \"TR\\u1ea6N TH\\u1ee4Y MINH TRANG\",\n            \"\",\n            \"0\",\n            \"0\",\n            \"0\"\n        ],\n        {\n            \"MainId\": 125,\n            \"CustomFields\": [\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    125,\n                    \"bank_account\",\n                    \"123456789\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    125,\n                    \"bank_name\",\n                    \"ABC\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    125,\n                    \"deparment\",\n                    \"Y Viet\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    125,\n                    \"indirect-supervisor\",\n                    \"\"\n                ]\n            ]\n        }\n    ],\n    [\n        [\n            \"15\",\n            \"\\u0110\\u1eb6NG V\\u0168 QU\\u1ef2NH GIAO\",\n            \"08\\/20\\/1990\",\n            \"08\\/20\\/2015\",\n            \"123456789\",\n            \"ABC\",\n            \"Y Viet\",\n            \"Ti\\u1ebfp t\\u00e2n\",\n            \"TR\\u1ea6N TH\\u1ee4Y MINH TRANG\",\n            \"\",\n            \"0\",\n            \"0\",\n            \"0\"\n        ],\n        {\n            \"MainId\": 126,\n            \"CustomFields\": [\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    126,\n                    \"bank_account\",\n                    \"123456789\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    126,\n                    \"bank_name\",\n                    \"ABC\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    126,\n                    \"deparment\",\n                    \"Y Viet\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    126,\n                    \"indirect-supervisor\",\n                    \"\"\n                ]\n            ]\n        }\n    ],\n    [\n        [\n            \"16\",\n            \"L\\u00ca TH\\u1eca HI\\u1ebeU \",\n            \"08\\/21\\/1990\",\n            \"08\\/21\\/2015\",\n            \"123456789\",\n            \"ABC\",\n            \"Y Viet\",\n            \"Tr\\u01b0\\u1edfng ph\\u00f2ng truy\\u1ec1n th\\u00f4ng & s\\u1ef1 ki\\u1ec7n\",\n            \"Ph\\u1ea1m Hu\\u1ef3nh Long\",\n            \"NGUY\\u1ec4N NG\\u1eccC QUANG & V\\u0168 M\\u1ea0NH T\\u00da\",\n            \"0\",\n            \"0\",\n            \"0\"\n        ],\n        {\n            \"MainId\": 127,\n            \"CustomFields\": [\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    127,\n                    \"bank_account\",\n                    \"123456789\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    127,\n                    \"bank_name\",\n                    \"ABC\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    127,\n                    \"deparment\",\n                    \"Y Viet\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    127,\n                    \"indirect-supervisor\",\n                    \"NGUY\\u1ec4N NG\\u1eccC QUANG & V\\u0168 M\\u1ea0NH T\\u00da\"\n                ]\n            ]\n        }\n    ],\n    [\n        [\n            \"17\",\n            \"NGUY\\u1ec4N NG\\u1eccC QUANG\",\n            \"08\\/22\\/1990\",\n            \"08\\/22\\/2015\",\n            \"123456789\",\n            \"ABC\",\n            \"Y Viet\",\n            \"Gi\\u00e1m \\u0111\\u1ed1c kinh doanh (DI)\",\n            \"Ph\\u1ea1m Hu\\u1ef3nh Long\",\n            \"\",\n            \"0\",\n            \"0\",\n            \"0\"\n        ],\n        {\n            \"MainId\": 128,\n            \"CustomFields\": [\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    128,\n                    \"bank_account\",\n                    \"123456789\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    128,\n                    \"bank_name\",\n                    \"ABC\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    128,\n                    \"deparment\",\n                    \"Y Viet\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    128,\n                    \"indirect-supervisor\",\n                    \"\"\n                ]\n            ]\n        }\n    ],\n    [\n        [\n            \"18\",\n            \"\\u0110O\\u00c0N TH\\u1eca THU H\\u00c0\",\n            \"08\\/23\\/1990\",\n            \"08\\/23\\/2015\",\n            \"123456789\",\n            \"ABC\",\n            \"Y Viet\",\n            \"Nh\\u00e2n vi\\u00ean kinh doanh\",\n            \"NGUY\\u1ec4N NG\\u1eccC QUANG\",\n            \"\",\n            \"0\",\n            \"0\",\n            \"0\"\n        ],\n        {\n            \"MainId\": 129,\n            \"CustomFields\": [\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    129,\n                    \"bank_account\",\n                    \"123456789\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    129,\n                    \"bank_name\",\n                    \"ABC\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    129,\n                    \"deparment\",\n                    \"Y Viet\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    129,\n                    \"indirect-supervisor\",\n                    \"\"\n                ]\n            ]\n        }\n    ],\n    [\n        [\n            \"19\",\n            \"HU\\u1ef2NH H\\u1eeeU KH\\u00c1NH \",\n            \"08\\/24\\/1990\",\n            \"08\\/24\\/2015\",\n            \"123456789\",\n            \"ABC\",\n            \"Y Viet\",\n            \"Tr\\u01b0\\u1edfng ph\\u00f2ng d\\u1ef1 \\u00e1n ME\",\n            \"NGUY\\u1ec4N NG\\u1eccC QUANG\",\n            \"V\\u0168 M\\u1ea0NH T\\u00da\",\n            \"0\",\n            \"0\",\n            \"0\"\n        ],\n        {\n            \"MainId\": 130,\n            \"CustomFields\": [\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    130,\n                    \"bank_account\",\n                    \"123456789\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    130,\n                    \"bank_name\",\n                    \"ABC\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    130,\n                    \"deparment\",\n                    \"Y Viet\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    130,\n                    \"indirect-supervisor\",\n                    \"V\\u0168 M\\u1ea0NH T\\u00da\"\n                ]\n            ]\n        }\n    ],\n    [\n        [\n            \"20\",\n            \"T\\u0102NG MINH PH\\u01af\\u01a0NG\",\n            \"08\\/25\\/1990\",\n            \"08\\/25\\/2015\",\n            \"123456789\",\n            \"ABC\",\n            \"Y Viet\",\n            \"T\\u1ea1m quy\\u1ec1n tr\\u01b0\\u1edfng ph\\u00f2ng k\\u1ef9 thu\\u1eadt\",\n            \"NGUY\\u1ec4N NG\\u1eccC QUANG\",\n            \"\",\n            \"0\",\n            \"0\",\n            \"0\"\n        ],\n        {\n            \"MainId\": 131,\n            \"CustomFields\": [\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    131,\n                    \"bank_account\",\n                    \"123456789\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    131,\n                    \"bank_name\",\n                    \"ABC\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    131,\n                    \"deparment\",\n                    \"Y Viet\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    131,\n                    \"indirect-supervisor\",\n                    \"\"\n                ]\n            ]\n        }\n    ],\n    [\n        [\n            \"21\",\n            \"KI\\u1ec0U NH\\u01af QU\\u00c2N\",\n            \"08\\/26\\/1990\",\n            \"08\\/26\\/2015\",\n            \"123456789\",\n            \"ABC\",\n            \"Y Viet\",\n            \"Nh\\u00e2n vi\\u00ean k\\u1ef9 thu\\u1eadt\",\n            \"NGUY\\u1ec4N NG\\u1eccC QUANG\",\n            \"\",\n            \"0\",\n            \"0\",\n            \"0\"\n        ],\n        {\n            \"MainId\": 132,\n            \"CustomFields\": [\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    132,\n                    \"bank_account\",\n                    \"123456789\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    132,\n                    \"bank_name\",\n                    \"ABC\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    132,\n                    \"deparment\",\n                    \"Y Viet\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    132,\n                    \"indirect-supervisor\",\n                    \"\"\n                ]\n            ]\n        }\n    ],\n    [\n        [\n            \"22\",\n            \"V\\u0168 M\\u1ea0NH T\\u00da\",\n            \"08\\/27\\/1990\",\n            \"08\\/27\\/2015\",\n            \"123456789\",\n            \"ABC\",\n            \"Y Viet\",\n            \"Gi\\u00e1m \\u0111\\u1ed1c kinh doanh (ICU)\",\n            \"Ph\\u1ea1m Hu\\u1ef3nh Long\",\n            \"\",\n            \"0\",\n            \"0\",\n            \"0\"\n        ],\n        {\n            \"MainId\": 133,\n            \"CustomFields\": [\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    133,\n                    \"bank_account\",\n                    \"123456789\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    133,\n                    \"bank_name\",\n                    \"ABC\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    133,\n                    \"deparment\",\n                    \"Y Viet\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    133,\n                    \"indirect-supervisor\",\n                    \"\"\n                ]\n            ]\n        }\n    ],\n    [\n        [\n            \"23\",\n            \"HU\\u1ef2NH TH\\u1eca B\\u1ea2O QUY\\u00caN\",\n            \"08\\/28\\/1990\",\n            \"08\\/28\\/2015\",\n            \"123456789\",\n            \"ABC\",\n            \"Y Viet\",\n            \"Chuy\\u00ean vi\\u00ean APP\",\n            \"V\\u0168 M\\u1ea0NH T\\u00da\",\n            \"NGUY\\u1ec4N NG\\u1eccC QUANG\",\n            \"0\",\n            \"0\",\n            \"0\"\n        ],\n        {\n            \"MainId\": 134,\n            \"CustomFields\": [\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    134,\n                    \"bank_account\",\n                    \"123456789\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    134,\n                    \"bank_name\",\n                    \"ABC\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    134,\n                    \"deparment\",\n                    \"Y Viet\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    134,\n                    \"indirect-supervisor\",\n                    \"NGUY\\u1ec4N NG\\u1eccC QUANG\"\n                ]\n            ]\n        }\n    ],\n    [\n        [\n            \"24\",\n            \"NGUY\\u1ec4N QU\\u1ed0C VI\\u1ec6T\",\n            \"08\\/29\\/1990\",\n            \"08\\/29\\/2015\",\n            \"123456789\",\n            \"ABC\",\n            \"Y Viet\",\n            \"Nh\\u00e2n vi\\u00ean kinh doanh\",\n            \"V\\u0168 M\\u1ea0NH T\\u00da\",\n            \"\",\n            \"0\",\n            \"0\",\n            \"0\"\n        ],\n        {\n            \"MainId\": 135,\n            \"CustomFields\": [\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    135,\n                    \"bank_account\",\n                    \"123456789\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    135,\n                    \"bank_name\",\n                    \"ABC\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    135,\n                    \"deparment\",\n                    \"Y Viet\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    135,\n                    \"indirect-supervisor\",\n                    \"\"\n                ]\n            ]\n        }\n    ],\n    [\n        [\n            \"25\",\n            \"L\\u00ca V\\u0102N D\\u0168NG\",\n            \"08\\/30\\/1990\",\n            \"08\\/30\\/2015\",\n            \"123456789\",\n            \"ABC\",\n            \"Y Viet\",\n            \"Nh\\u00e2n vi\\u00ean kinh doanh\",\n            \"V\\u0168 M\\u1ea0NH T\\u00da\",\n            \"\",\n            \"0\",\n            \"0\",\n            \"0\"\n        ],\n        {\n            \"MainId\": 136,\n            \"CustomFields\": [\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    136,\n                    \"bank_account\",\n                    \"123456789\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    136,\n                    \"bank_name\",\n                    \"ABC\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    136,\n                    \"deparment\",\n                    \"Y Viet\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    136,\n                    \"indirect-supervisor\",\n                    \"\"\n                ]\n            ]\n        }\n    ],\n    [\n        [\n            \"26\",\n            \"NGUY\\u1ec4N TH\\u00c1I QUY\\u1ec0N\",\n            \"08\\/31\\/1990\",\n            \"08\\/31\\/2015\",\n            \"123456789\",\n            \"ABC\",\n            \"Y Viet\",\n            \"Nh\\u00e2n vi\\u00ean kinh doanh\",\n            \"V\\u0168 M\\u1ea0NH T\\u00da\",\n            \"\",\n            \"0\",\n            \"0\",\n            \"0\"\n        ],\n        {\n            \"MainId\": 137,\n            \"CustomFields\": [\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    137,\n                    \"bank_account\",\n                    \"123456789\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    137,\n                    \"bank_name\",\n                    \"ABC\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    137,\n                    \"deparment\",\n                    \"Y Viet\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    137,\n                    \"indirect-supervisor\",\n                    \"\"\n                ]\n            ]\n        }\n    ],\n    [\n        [\n            \"27\",\n            \"L\\u00ca V\\u0128NH TH\\u1ea0CH\",\n            \"09\\/01\\/1990\",\n            \"09\\/01\\/2015\",\n            \"123456789\",\n            \"ABC\",\n            \"Y Viet\",\n            \"Nh\\u00e2n vi\\u00ean kinh doanh\",\n            \"V\\u0168 M\\u1ea0NH T\\u00da\",\n            \"\",\n            \"0\",\n            \"0\",\n            \"0\"\n        ],\n        {\n            \"MainId\": 138,\n            \"CustomFields\": [\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    138,\n                    \"bank_account\",\n                    \"123456789\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    138,\n                    \"bank_name\",\n                    \"ABC\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    138,\n                    \"deparment\",\n                    \"Y Viet\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    138,\n                    \"indirect-supervisor\",\n                    \"\"\n                ]\n            ]\n        }\n    ],\n    [\n        [\n            \"28\",\n            \"L\\u00ca KI\\u1ec0U OANH\",\n            \"09\\/02\\/1990\",\n            \"09\\/02\\/2015\",\n            \"123456789\",\n            \"ABC\",\n            \"Y Viet\",\n            \"Nh\\u00e2n vi\\u00ean kinh doanh\",\n            \"V\\u0168 M\\u1ea0NH T\\u00da\",\n            \"\",\n            \"0\",\n            \"0\",\n            \"0\"\n        ],\n        {\n            \"MainId\": 139,\n            \"CustomFields\": [\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    139,\n                    \"bank_account\",\n                    \"123456789\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    139,\n                    \"bank_name\",\n                    \"ABC\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    139,\n                    \"deparment\",\n                    \"Y Viet\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    139,\n                    \"indirect-supervisor\",\n                    \"\"\n                ]\n            ]\n        }\n    ],\n    [\n        [\n            \"29\",\n            \"NGUY\\u1ec4N TH\\u1eca H\\u1ed2NG NH\\u01af\",\n            \"09\\/03\\/1990\",\n            \"09\\/03\\/2015\",\n            \"123456789\",\n            \"ABC\",\n            \"Y Viet\",\n            \"Nh\\u00e2n vi\\u00ean kinh doanh\",\n            \"V\\u0168 M\\u1ea0NH T\\u00da\",\n            \"\",\n            \"0\",\n            \"0\",\n            \"0\"\n        ],\n        {\n            \"MainId\": 140,\n            \"CustomFields\": [\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    140,\n                    \"bank_account\",\n                    \"123456789\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    140,\n                    \"bank_name\",\n                    \"ABC\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    140,\n                    \"deparment\",\n                    \"Y Viet\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    140,\n                    \"indirect-supervisor\",\n                    \"\"\n                ]\n            ]\n        }\n    ],\n    [\n        [\n            \"30\",\n            \"PH\\u1ea0M TR\\u1eccNG QU\\u1ef2NH\",\n            \"09\\/04\\/1990\",\n            \"09\\/04\\/2015\",\n            \"123456789\",\n            \"ABC\",\n            \"Y Viet\",\n            \"Nh\\u00e2n vi\\u00ean k\\u1ef9 thu\\u1eadt\",\n            \"V\\u0168 M\\u1ea0NH T\\u00da\",\n            \"\",\n            \"0\",\n            \"0\",\n            \"0\"\n        ],\n        {\n            \"MainId\": 141,\n            \"CustomFields\": [\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    141,\n                    \"bank_account\",\n                    \"123456789\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    141,\n                    \"bank_name\",\n                    \"ABC\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    141,\n                    \"deparment\",\n                    \"Y Viet\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    141,\n                    \"indirect-supervisor\",\n                    \"\"\n                ]\n            ]\n        }\n    ],\n    [\n        [\n            \"31\",\n            \"H\\u1ed2 N\\u0102NG T\\u00c2N\",\n            \"09\\/05\\/1990\",\n            \"09\\/05\\/2015\",\n            \"123456789\",\n            \"ABC\",\n            \"Y Viet\",\n            \"Nh\\u00e2n vi\\u00ean k\\u1ef9 thu\\u1eadt\",\n            \"V\\u0168 M\\u1ea0NH T\\u00da\",\n            \"\",\n            \"0\",\n            \"0\",\n            \"0\"\n        ],\n        {\n            \"MainId\": 142,\n            \"CustomFields\": [\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    142,\n                    \"bank_account\",\n                    \"123456789\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    142,\n                    \"bank_name\",\n                    \"ABC\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    142,\n                    \"deparment\",\n                    \"Y Viet\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    142,\n                    \"indirect-supervisor\",\n                    \"\"\n                ]\n            ]\n        }\n    ],\n    [\n        [\n            \"32\",\n            \"TI\\u00caU NG\\u1eccC THI\\u1ec6N PH\\u00da\",\n            \"09\\/06\\/1990\",\n            \"09\\/06\\/2015\",\n            \"123456789\",\n            \"ABC\",\n            \"Y Viet\",\n            \"Nh\\u00e2n vi\\u00ean k\\u1ef9 thu\\u1eadt\",\n            \"V\\u0168 M\\u1ea0NH T\\u00da\",\n            \"\",\n            \"0\",\n            \"0\",\n            \"0\"\n        ],\n        {\n            \"MainId\": 143,\n            \"CustomFields\": [\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    143,\n                    \"bank_account\",\n                    \"123456789\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    143,\n                    \"bank_name\",\n                    \"ABC\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    143,\n                    \"deparment\",\n                    \"Y Viet\"\n                ],\n                [\n                    \"\\\\Employees\\\\Common\\\\Model\\\\Employee\",\n                    143,\n                    \"indirect-supervisor\",\n                    \"\"\n                ]\n            ]\n        }\n    ]\n]','2020-03-10 11:34:47','2020-03-10 11:34:47');
/*!40000 ALTER TABLE `DataImportFiles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `DeductionGroup`
--

DROP TABLE IF EXISTS `DeductionGroup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `DeductionGroup` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `DeductionGroup`
--

LOCK TABLES `DeductionGroup` WRITE;
/*!40000 ALTER TABLE `DeductionGroup` DISABLE KEYS */;
/*!40000 ALTER TABLE `DeductionGroup` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Deductions`
--

DROP TABLE IF EXISTS `Deductions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Deductions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `componentType` varchar(250) DEFAULT NULL,
  `component` varchar(250) DEFAULT NULL,
  `payrollColumn` int(11) DEFAULT NULL,
  `rangeAmounts` text,
  `deduction_group` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `Fk_Deductions_DeductionGroup` (`deduction_group`),
  CONSTRAINT `Fk_Deductions_DeductionGroup` FOREIGN KEY (`deduction_group`) REFERENCES `DeductionGroup` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Deductions`
--

LOCK TABLES `Deductions` WRITE;
/*!40000 ALTER TABLE `Deductions` DISABLE KEYS */;
/*!40000 ALTER TABLE `Deductions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Documents`
--

DROP TABLE IF EXISTS `Documents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Documents` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `details` text,
  `expire_notification` enum('Yes','No') DEFAULT 'Yes',
  `expire_notification_month` enum('Yes','No') DEFAULT 'Yes',
  `expire_notification_week` enum('Yes','No') DEFAULT 'Yes',
  `expire_notification_day` enum('Yes','No') DEFAULT 'Yes',
  `sign` enum('Yes','No') DEFAULT 'Yes',
  `sign_label` varchar(500) DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `updated` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Documents`
--

LOCK TABLES `Documents` WRITE;
/*!40000 ALTER TABLE `Documents` DISABLE KEYS */;
INSERT INTO `Documents` VALUES (1,'ID Copy','Your ID copy','Yes','Yes','Yes','Yes','No',NULL,'2020-02-09 02:51:47','2020-02-09 02:51:47'),(2,'Degree Certificate','Degree Certificate','Yes','Yes','Yes','Yes','Yes',NULL,'2020-02-09 02:51:47','2020-02-09 02:51:47'),(3,'Driving License','Driving License','Yes','Yes','Yes','Yes','Yes',NULL,'2020-02-09 02:51:47','2020-02-09 02:51:47');
/*!40000 ALTER TABLE `Documents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `EducationLevel`
--

DROP TABLE IF EXISTS `EducationLevel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `EducationLevel` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(250) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `EducationLevel`
--

LOCK TABLES `EducationLevel` WRITE;
/*!40000 ALTER TABLE `EducationLevel` DISABLE KEYS */;
INSERT INTO `EducationLevel` VALUES (1,'Unspecified'),(2,'High School or equivalent'),(3,'Certification'),(4,'Vocational'),(5,'Associate Degree'),(6,'Bachelor\'s Degree'),(7,'Master\'s Degree'),(8,'Doctorate'),(9,'Professional'),(10,'Some College Coursework Completed'),(11,'Vocational - HS Diploma'),(12,'Vocational - Degree'),(13,'Some High School Coursework');
/*!40000 ALTER TABLE `EducationLevel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Educations`
--

DROP TABLE IF EXISTS `Educations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Educations` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `description` varchar(400) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Educations`
--

LOCK TABLES `Educations` WRITE;
/*!40000 ALTER TABLE `Educations` DISABLE KEYS */;
INSERT INTO `Educations` VALUES (1,'Bachelors Degree','Bachelors Degree'),(2,'Diploma','Diploma'),(3,'Masters Degree','Masters Degree'),(4,'Doctorate','Doctorate');
/*!40000 ALTER TABLE `Educations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Emails`
--

DROP TABLE IF EXISTS `Emails`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Emails` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `subject` varchar(300) NOT NULL,
  `toEmail` varchar(300) NOT NULL,
  `template` text,
  `params` text,
  `cclist` varchar(500) DEFAULT NULL,
  `bcclist` varchar(500) DEFAULT NULL,
  `error` varchar(500) DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `updated` datetime DEFAULT NULL,
  `status` enum('Pending','Sent','Error') DEFAULT 'Pending',
  PRIMARY KEY (`id`),
  KEY `KEY_Emails_status` (`status`),
  KEY `KEY_Emails_created` (`created`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Emails`
--

LOCK TABLES `Emails` WRITE;
/*!40000 ALTER TABLE `Emails` DISABLE KEYS */;
/*!40000 ALTER TABLE `Emails` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `EmergencyContacts`
--

DROP TABLE IF EXISTS `EmergencyContacts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `EmergencyContacts` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `employee` bigint(20) NOT NULL,
  `name` varchar(100) NOT NULL,
  `relationship` varchar(100) DEFAULT NULL,
  `home_phone` varchar(15) DEFAULT NULL,
  `work_phone` varchar(15) DEFAULT NULL,
  `mobile_phone` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `Fk_EmergencyContacts_Employee` (`employee`),
  CONSTRAINT `Fk_EmergencyContacts_Employee` FOREIGN KEY (`employee`) REFERENCES `Employees` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `EmergencyContacts`
--

LOCK TABLES `EmergencyContacts` WRITE;
/*!40000 ALTER TABLE `EmergencyContacts` DISABLE KEYS */;
/*!40000 ALTER TABLE `EmergencyContacts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `EmployeeApprovals`
--

DROP TABLE IF EXISTS `EmployeeApprovals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `EmployeeApprovals` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `type` varchar(100) NOT NULL,
  `element` bigint(20) NOT NULL,
  `approver` bigint(20) DEFAULT NULL,
  `level` int(11) DEFAULT '0',
  `status` int(11) DEFAULT '0',
  `active` int(11) DEFAULT '0',
  `created` datetime DEFAULT NULL,
  `updated` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `EmployeeApprovals_type_element_level` (`type`,`element`,`level`),
  KEY `EmployeeApprovals_type_element_status_level` (`type`,`element`,`status`,`level`),
  KEY `EmployeeApprovals_type_element` (`type`,`element`),
  KEY `EmployeeApprovals_type` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `EmployeeApprovals`
--

LOCK TABLES `EmployeeApprovals` WRITE;
/*!40000 ALTER TABLE `EmployeeApprovals` DISABLE KEYS */;
/*!40000 ALTER TABLE `EmployeeApprovals` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `EmployeeAttendanceSheets`
--

DROP TABLE IF EXISTS `EmployeeAttendanceSheets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `EmployeeAttendanceSheets` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `employee` bigint(20) NOT NULL,
  `date_start` date NOT NULL,
  `date_end` date NOT NULL,
  `status` enum('Approved','Pending','Rejected','Submitted') DEFAULT 'Pending',
  PRIMARY KEY (`id`),
  UNIQUE KEY `EmployeeAttendanceSheetsKey` (`employee`,`date_start`,`date_end`),
  KEY `EmployeeAttendanceSheets_date_end` (`date_end`),
  CONSTRAINT `Fk_EmployeeAttendanceSheets_Employee` FOREIGN KEY (`employee`) REFERENCES `Employees` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `EmployeeAttendanceSheets`
--

LOCK TABLES `EmployeeAttendanceSheets` WRITE;
/*!40000 ALTER TABLE `EmployeeAttendanceSheets` DISABLE KEYS */;
/*!40000 ALTER TABLE `EmployeeAttendanceSheets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `EmployeeCertifications`
--

DROP TABLE IF EXISTS `EmployeeCertifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `EmployeeCertifications` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `certification_id` bigint(20) DEFAULT NULL,
  `employee` bigint(20) NOT NULL,
  `institute` varchar(400) DEFAULT NULL,
  `date_start` date DEFAULT NULL,
  `date_end` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `employee` (`employee`,`certification_id`),
  KEY `Fk_EmployeeCertifications_Certifications` (`certification_id`),
  CONSTRAINT `Fk_EmployeeCertifications_Certifications` FOREIGN KEY (`certification_id`) REFERENCES `Certifications` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Fk_EmployeeCertifications_Employee` FOREIGN KEY (`employee`) REFERENCES `Employees` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `EmployeeCertifications`
--

LOCK TABLES `EmployeeCertifications` WRITE;
/*!40000 ALTER TABLE `EmployeeCertifications` DISABLE KEYS */;
/*!40000 ALTER TABLE `EmployeeCertifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `EmployeeCompanyLoans`
--

DROP TABLE IF EXISTS `EmployeeCompanyLoans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `EmployeeCompanyLoans` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `employee` bigint(20) NOT NULL,
  `loan` bigint(20) DEFAULT NULL,
  `start_date` date NOT NULL,
  `last_installment_date` date NOT NULL,
  `period_months` bigint(20) DEFAULT NULL,
  `currency` bigint(20) DEFAULT NULL,
  `amount` decimal(10,2) NOT NULL,
  `monthly_installment` decimal(10,2) NOT NULL,
  `status` enum('Approved','Repayment','Paid','Suspended') DEFAULT 'Approved',
  `details` text,
  PRIMARY KEY (`id`),
  KEY `Fk_EmployeeCompanyLoans_CompanyLoans` (`loan`),
  KEY `Fk_EmployeeCompanyLoans_Employee` (`employee`),
  CONSTRAINT `Fk_EmployeeCompanyLoans_CompanyLoans` FOREIGN KEY (`loan`) REFERENCES `CompanyLoans` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `Fk_EmployeeCompanyLoans_Employee` FOREIGN KEY (`employee`) REFERENCES `Employees` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `EmployeeCompanyLoans`
--

LOCK TABLES `EmployeeCompanyLoans` WRITE;
/*!40000 ALTER TABLE `EmployeeCompanyLoans` DISABLE KEYS */;
/*!40000 ALTER TABLE `EmployeeCompanyLoans` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `EmployeeDataHistory`
--

DROP TABLE IF EXISTS `EmployeeDataHistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `EmployeeDataHistory` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `type` varchar(100) NOT NULL,
  `employee` bigint(20) NOT NULL,
  `field` varchar(100) NOT NULL,
  `old_value` varchar(500) DEFAULT NULL,
  `new_value` varchar(500) DEFAULT NULL,
  `description` varchar(800) DEFAULT NULL,
  `user` bigint(20) DEFAULT NULL,
  `updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `Fk_EmployeeDataHistory_Employee` (`employee`),
  KEY `Fk_EmployeeDataHistory_Users` (`user`),
  CONSTRAINT `Fk_EmployeeDataHistory_Employee` FOREIGN KEY (`employee`) REFERENCES `Employees` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Fk_EmployeeDataHistory_Users` FOREIGN KEY (`user`) REFERENCES `Users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `EmployeeDataHistory`
--

LOCK TABLES `EmployeeDataHistory` WRITE;
/*!40000 ALTER TABLE `EmployeeDataHistory` DISABLE KEYS */;
/*!40000 ALTER TABLE `EmployeeDataHistory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `EmployeeDependents`
--

DROP TABLE IF EXISTS `EmployeeDependents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `EmployeeDependents` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `employee` bigint(20) NOT NULL,
  `name` varchar(100) NOT NULL,
  `relationship` enum('Child','Spouse','Parent','Other') DEFAULT NULL,
  `dob` date DEFAULT NULL,
  `id_number` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `Fk_EmployeeDependents_Employee` (`employee`),
  CONSTRAINT `Fk_EmployeeDependents_Employee` FOREIGN KEY (`employee`) REFERENCES `Employees` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `EmployeeDependents`
--

LOCK TABLES `EmployeeDependents` WRITE;
/*!40000 ALTER TABLE `EmployeeDependents` DISABLE KEYS */;
/*!40000 ALTER TABLE `EmployeeDependents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `EmployeeDocuments`
--

DROP TABLE IF EXISTS `EmployeeDocuments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `EmployeeDocuments` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `employee` bigint(20) NOT NULL,
  `document` bigint(20) DEFAULT NULL,
  `date_added` date NOT NULL,
  `valid_until` date DEFAULT NULL,
  `status` enum('Active','Inactive','Draft') DEFAULT 'Active',
  `details` text,
  `attachment` varchar(100) DEFAULT NULL,
  `signature` text,
  `expire_notification_last` int(4) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `Fk_EmployeeDocuments_Documents` (`document`),
  KEY `Fk_EmployeeDocuments_Employee` (`employee`),
  KEY `KEY_EmployeeDocuments_valid_until` (`valid_until`),
  KEY `KEY_EmployeeDocuments_valid_until_status` (`valid_until`,`status`,`expire_notification_last`),
  CONSTRAINT `Fk_EmployeeDocuments_Documents` FOREIGN KEY (`document`) REFERENCES `Documents` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `Fk_EmployeeDocuments_Employee` FOREIGN KEY (`employee`) REFERENCES `Employees` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `EmployeeDocuments`
--

LOCK TABLES `EmployeeDocuments` WRITE;
/*!40000 ALTER TABLE `EmployeeDocuments` DISABLE KEYS */;
/*!40000 ALTER TABLE `EmployeeDocuments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `EmployeeEducations`
--

DROP TABLE IF EXISTS `EmployeeEducations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `EmployeeEducations` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `education_id` bigint(20) DEFAULT NULL,
  `employee` bigint(20) NOT NULL,
  `institute` varchar(400) DEFAULT NULL,
  `date_start` date DEFAULT NULL,
  `date_end` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `Fk_EmployeeEducations_Educations` (`education_id`),
  KEY `Fk_EmployeeEducations_Employee` (`employee`),
  CONSTRAINT `Fk_EmployeeEducations_Educations` FOREIGN KEY (`education_id`) REFERENCES `Educations` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Fk_EmployeeEducations_Employee` FOREIGN KEY (`employee`) REFERENCES `Employees` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `EmployeeEducations`
--

LOCK TABLES `EmployeeEducations` WRITE;
/*!40000 ALTER TABLE `EmployeeEducations` DISABLE KEYS */;
/*!40000 ALTER TABLE `EmployeeEducations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `EmployeeEthnicity`
--

DROP TABLE IF EXISTS `EmployeeEthnicity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `EmployeeEthnicity` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `employee` bigint(20) NOT NULL,
  `ethnicity` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `Fk_EmployeeEthnicity_Employee` (`employee`),
  KEY `Fk_EmployeeEthnicity_Ethnicity` (`ethnicity`),
  CONSTRAINT `Fk_EmployeeEthnicity_Employee` FOREIGN KEY (`employee`) REFERENCES `Employees` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Fk_EmployeeEthnicity_Ethnicity` FOREIGN KEY (`ethnicity`) REFERENCES `Ethnicity` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `EmployeeEthnicity`
--

LOCK TABLES `EmployeeEthnicity` WRITE;
/*!40000 ALTER TABLE `EmployeeEthnicity` DISABLE KEYS */;
/*!40000 ALTER TABLE `EmployeeEthnicity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `EmployeeExpenses`
--

DROP TABLE IF EXISTS `EmployeeExpenses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `EmployeeExpenses` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `employee` bigint(20) NOT NULL,
  `expense_date` date DEFAULT NULL,
  `payment_method` bigint(20) NOT NULL,
  `transaction_no` varchar(300) NOT NULL,
  `payee` varchar(500) NOT NULL,
  `category` bigint(20) NOT NULL,
  `notes` text,
  `amount` decimal(10,3) DEFAULT NULL,
  `currency` bigint(20) DEFAULT NULL,
  `attachment1` varchar(100) DEFAULT NULL,
  `attachment2` varchar(100) DEFAULT NULL,
  `attachment3` varchar(100) DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `updated` datetime DEFAULT NULL,
  `status` enum('Approved','Pending','Rejected','Cancellation Requested','Cancelled','Processing') DEFAULT 'Pending',
  PRIMARY KEY (`id`),
  KEY `Fk_EmployeeExpenses_Employee` (`employee`),
  KEY `Fk_EmployeeExpenses_pm` (`payment_method`),
  KEY `Fk_EmployeeExpenses_category` (`category`),
  CONSTRAINT `Fk_EmployeeExpenses_category` FOREIGN KEY (`category`) REFERENCES `ExpensesCategories` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Fk_EmployeeExpenses_Employee` FOREIGN KEY (`employee`) REFERENCES `Employees` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Fk_EmployeeExpenses_pm` FOREIGN KEY (`payment_method`) REFERENCES `ExpensesPaymentMethods` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `EmployeeExpenses`
--

LOCK TABLES `EmployeeExpenses` WRITE;
/*!40000 ALTER TABLE `EmployeeExpenses` DISABLE KEYS */;
/*!40000 ALTER TABLE `EmployeeExpenses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `EmployeeForms`
--

DROP TABLE IF EXISTS `EmployeeForms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `EmployeeForms` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `employee` bigint(20) NOT NULL,
  `form` bigint(20) NOT NULL,
  `status` enum('Pending','Completed') DEFAULT 'Pending',
  `created` datetime DEFAULT NULL,
  `updated` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `Fk_EmployeeForms_Employee` (`employee`),
  KEY `Fk_EmployeeForms_Forms` (`form`),
  CONSTRAINT `Fk_EmployeeForms_Employee` FOREIGN KEY (`employee`) REFERENCES `Employees` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Fk_EmployeeForms_Forms` FOREIGN KEY (`form`) REFERENCES `Forms` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `EmployeeForms`
--

LOCK TABLES `EmployeeForms` WRITE;
/*!40000 ALTER TABLE `EmployeeForms` DISABLE KEYS */;
/*!40000 ALTER TABLE `EmployeeForms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `EmployeeImmigrationStatus`
--

DROP TABLE IF EXISTS `EmployeeImmigrationStatus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `EmployeeImmigrationStatus` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `employee` bigint(20) NOT NULL,
  `status` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `Fk_EmployeeImmigrationStatus_Employee` (`employee`),
  KEY `Fk_EmployeeImmigrationStatus_Type` (`status`),
  CONSTRAINT `Fk_EmployeeImmigrationStatus_Employee` FOREIGN KEY (`employee`) REFERENCES `Employees` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Fk_EmployeeImmigrationStatus_Type` FOREIGN KEY (`status`) REFERENCES `ImmigrationStatus` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `EmployeeImmigrationStatus`
--

LOCK TABLES `EmployeeImmigrationStatus` WRITE;
/*!40000 ALTER TABLE `EmployeeImmigrationStatus` DISABLE KEYS */;
/*!40000 ALTER TABLE `EmployeeImmigrationStatus` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `EmployeeImmigrations`
--

DROP TABLE IF EXISTS `EmployeeImmigrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `EmployeeImmigrations` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `employee` bigint(20) NOT NULL,
  `document` bigint(20) DEFAULT NULL,
  `documentname` varchar(150) NOT NULL,
  `valid_until` date NOT NULL,
  `status` enum('Active','Inactive','Draft') DEFAULT 'Active',
  `details` text,
  `attachment1` varchar(100) DEFAULT NULL,
  `attachment2` varchar(100) DEFAULT NULL,
  `attachment3` varchar(100) DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `updated` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `Fk_EmployeeImmigrations_Employee` (`employee`),
  KEY `Fk_EmployeeImmigrations_ImmigrationDocuments` (`document`),
  CONSTRAINT `Fk_EmployeeImmigrations_Employee` FOREIGN KEY (`employee`) REFERENCES `Employees` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Fk_EmployeeImmigrations_ImmigrationDocuments` FOREIGN KEY (`document`) REFERENCES `ImmigrationDocuments` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `EmployeeImmigrations`
--

LOCK TABLES `EmployeeImmigrations` WRITE;
/*!40000 ALTER TABLE `EmployeeImmigrations` DISABLE KEYS */;
/*!40000 ALTER TABLE `EmployeeImmigrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `EmployeeLanguages`
--

DROP TABLE IF EXISTS `EmployeeLanguages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `EmployeeLanguages` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `language_id` bigint(20) DEFAULT NULL,
  `employee` bigint(20) NOT NULL,
  `reading` enum('Elementary Proficiency','Limited Working Proficiency','Professional Working Proficiency','Full Professional Proficiency','Native or Bilingual Proficiency') DEFAULT NULL,
  `speaking` enum('Elementary Proficiency','Limited Working Proficiency','Professional Working Proficiency','Full Professional Proficiency','Native or Bilingual Proficiency') DEFAULT NULL,
  `writing` enum('Elementary Proficiency','Limited Working Proficiency','Professional Working Proficiency','Full Professional Proficiency','Native or Bilingual Proficiency') DEFAULT NULL,
  `understanding` enum('Elementary Proficiency','Limited Working Proficiency','Professional Working Proficiency','Full Professional Proficiency','Native or Bilingual Proficiency') DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `employee` (`employee`,`language_id`),
  KEY `Fk_EmployeeLanguages_Languages` (`language_id`),
  CONSTRAINT `Fk_EmployeeLanguages_Employee` FOREIGN KEY (`employee`) REFERENCES `Employees` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Fk_EmployeeLanguages_Languages` FOREIGN KEY (`language_id`) REFERENCES `Languages` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `EmployeeLanguages`
--

LOCK TABLES `EmployeeLanguages` WRITE;
/*!40000 ALTER TABLE `EmployeeLanguages` DISABLE KEYS */;
/*!40000 ALTER TABLE `EmployeeLanguages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `EmployeeLeaveDays`
--

DROP TABLE IF EXISTS `EmployeeLeaveDays`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `EmployeeLeaveDays` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `employee_leave` bigint(20) NOT NULL,
  `leave_date` date DEFAULT NULL,
  `leave_type` enum('Full Day','Half Day - Morning','Half Day - Afternoon','1 Hour - Morning','2 Hours - Morning','3 Hours - Morning','1 Hour - Afternoon','2 Hours - Afternoon','3 Hours - Afternoon') NOT NULL,
  PRIMARY KEY (`id`),
  KEY `Fk_EmployeeLeaveDays_EmployeeLeaves` (`employee_leave`),
  CONSTRAINT `Fk_EmployeeLeaveDays_EmployeeLeaves` FOREIGN KEY (`employee_leave`) REFERENCES `EmployeeLeaves` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `EmployeeLeaveDays`
--

LOCK TABLES `EmployeeLeaveDays` WRITE;
/*!40000 ALTER TABLE `EmployeeLeaveDays` DISABLE KEYS */;
/*!40000 ALTER TABLE `EmployeeLeaveDays` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `EmployeeLeaveLog`
--

DROP TABLE IF EXISTS `EmployeeLeaveLog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `EmployeeLeaveLog` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `employee_leave` bigint(20) NOT NULL,
  `user_id` bigint(20) DEFAULT NULL,
  `data` varchar(500) NOT NULL,
  `status_from` enum('Approved','Pending','Rejected','Cancellation Requested','Cancelled','Processing') DEFAULT 'Pending',
  `status_to` enum('Approved','Pending','Rejected','Cancellation Requested','Cancelled','Processing') DEFAULT 'Pending',
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `Fk_EmployeeLeaveLog_EmployeeLeaves` (`employee_leave`),
  KEY `Fk_EmployeeLeaveLog_Users` (`user_id`),
  CONSTRAINT `Fk_EmployeeLeaveLog_EmployeeLeaves` FOREIGN KEY (`employee_leave`) REFERENCES `EmployeeLeaves` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Fk_EmployeeLeaveLog_Users` FOREIGN KEY (`user_id`) REFERENCES `Users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `EmployeeLeaveLog`
--

LOCK TABLES `EmployeeLeaveLog` WRITE;
/*!40000 ALTER TABLE `EmployeeLeaveLog` DISABLE KEYS */;
/*!40000 ALTER TABLE `EmployeeLeaveLog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `EmployeeLeaves`
--

DROP TABLE IF EXISTS `EmployeeLeaves`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `EmployeeLeaves` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `employee` bigint(20) NOT NULL,
  `leave_type` bigint(20) NOT NULL,
  `leave_period` bigint(20) NOT NULL,
  `date_start` date DEFAULT NULL,
  `date_end` date DEFAULT NULL,
  `details` text,
  `status` enum('Approved','Pending','Rejected','Cancellation Requested','Cancelled','Processing') DEFAULT 'Pending',
  `attachment` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `Fk_EmployeeLeaves_Employee` (`employee`),
  KEY `Fk_EmployeeLeaves_LeaveTypes` (`leave_type`),
  KEY `Fk_EmployeeLeaves_LeavePeriods` (`leave_period`),
  CONSTRAINT `Fk_EmployeeLeaves_Employee` FOREIGN KEY (`employee`) REFERENCES `Employees` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Fk_EmployeeLeaves_LeavePeriods` FOREIGN KEY (`leave_period`) REFERENCES `LeavePeriods` (`id`),
  CONSTRAINT `Fk_EmployeeLeaves_LeaveTypes` FOREIGN KEY (`leave_type`) REFERENCES `LeaveTypes` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `EmployeeLeaves`
--

LOCK TABLES `EmployeeLeaves` WRITE;
/*!40000 ALTER TABLE `EmployeeLeaves` DISABLE KEYS */;
/*!40000 ALTER TABLE `EmployeeLeaves` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `EmployeeOvertime`
--

DROP TABLE IF EXISTS `EmployeeOvertime`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `EmployeeOvertime` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `employee` bigint(20) NOT NULL,
  `start_time` datetime DEFAULT NULL,
  `end_time` datetime DEFAULT NULL,
  `category` bigint(20) NOT NULL,
  `project` bigint(20) DEFAULT NULL,
  `notes` text,
  `created` datetime DEFAULT NULL,
  `updated` datetime DEFAULT NULL,
  `status` enum('Approved','Pending','Rejected','Cancellation Requested','Cancelled','Processing') DEFAULT 'Pending',
  PRIMARY KEY (`id`),
  KEY `Fk_EmployeeOvertime_Employee` (`employee`),
  KEY `Fk_EmployeeOvertime_Category` (`category`),
  CONSTRAINT `Fk_EmployeeOvertime_Category` FOREIGN KEY (`category`) REFERENCES `OvertimeCategories` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Fk_EmployeeOvertime_Employee` FOREIGN KEY (`employee`) REFERENCES `Employees` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `EmployeeOvertime`
--

LOCK TABLES `EmployeeOvertime` WRITE;
/*!40000 ALTER TABLE `EmployeeOvertime` DISABLE KEYS */;
/*!40000 ALTER TABLE `EmployeeOvertime` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `EmployeeProjects`
--

DROP TABLE IF EXISTS `EmployeeProjects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `EmployeeProjects` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `employee` bigint(20) NOT NULL,
  `project` bigint(20) DEFAULT NULL,
  `date_start` date DEFAULT NULL,
  `date_end` date DEFAULT NULL,
  `status` enum('Current','Inactive','Completed') DEFAULT 'Current',
  `details` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `EmployeeProjectsKey` (`employee`,`project`),
  KEY `Fk_EmployeeProjects_Projects` (`project`),
  CONSTRAINT `Fk_EmployeeProjects_Employee` FOREIGN KEY (`employee`) REFERENCES `Employees` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Fk_EmployeeProjects_Projects` FOREIGN KEY (`project`) REFERENCES `Projects` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `EmployeeProjects`
--

LOCK TABLES `EmployeeProjects` WRITE;
/*!40000 ALTER TABLE `EmployeeProjects` DISABLE KEYS */;
/*!40000 ALTER TABLE `EmployeeProjects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `EmployeeSalary`
--

DROP TABLE IF EXISTS `EmployeeSalary`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `EmployeeSalary` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `employee` bigint(20) NOT NULL,
  `component` bigint(20) NOT NULL,
  `pay_frequency` enum('Hourly','Daily','Bi Weekly','Weekly','Semi Monthly','Monthly') DEFAULT NULL,
  `currency` bigint(20) DEFAULT NULL,
  `amount` decimal(10,2) NOT NULL,
  `details` text,
  PRIMARY KEY (`id`),
  KEY `Fk_EmployeeSalary_Employee` (`employee`),
  KEY `Fk_EmployeeSalary_Currency` (`currency`),
  CONSTRAINT `Fk_EmployeeSalary_Currency` FOREIGN KEY (`currency`) REFERENCES `CurrencyTypes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Fk_EmployeeSalary_Employee` FOREIGN KEY (`employee`) REFERENCES `Employees` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `EmployeeSalary`
--

LOCK TABLES `EmployeeSalary` WRITE;
/*!40000 ALTER TABLE `EmployeeSalary` DISABLE KEYS */;
INSERT INTO `EmployeeSalary` VALUES (1,112,1,NULL,NULL,10000.00,'');
/*!40000 ALTER TABLE `EmployeeSalary` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `EmployeeSkills`
--

DROP TABLE IF EXISTS `EmployeeSkills`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `EmployeeSkills` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `skill_id` bigint(20) DEFAULT NULL,
  `employee` bigint(20) NOT NULL,
  `details` varchar(400) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `employee` (`employee`,`skill_id`),
  KEY `Fk_EmployeeSkills_Skills` (`skill_id`),
  CONSTRAINT `Fk_EmployeeSkills_Employee` FOREIGN KEY (`employee`) REFERENCES `Employees` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Fk_EmployeeSkills_Skills` FOREIGN KEY (`skill_id`) REFERENCES `Skills` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `EmployeeSkills`
--

LOCK TABLES `EmployeeSkills` WRITE;
/*!40000 ALTER TABLE `EmployeeSkills` DISABLE KEYS */;
/*!40000 ALTER TABLE `EmployeeSkills` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `EmployeeTimeEntry`
--

DROP TABLE IF EXISTS `EmployeeTimeEntry`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `EmployeeTimeEntry` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `project` bigint(20) DEFAULT NULL,
  `employee` bigint(20) NOT NULL,
  `timesheet` bigint(20) NOT NULL,
  `details` text,
  `created` datetime DEFAULT NULL,
  `date_start` datetime DEFAULT NULL,
  `time_start` varchar(10) NOT NULL,
  `date_end` datetime DEFAULT NULL,
  `time_end` varchar(10) NOT NULL,
  `status` enum('Active','Inactive') DEFAULT 'Active',
  PRIMARY KEY (`id`),
  KEY `Fk_EmployeeTimeEntry_Projects` (`project`),
  KEY `Fk_EmployeeTimeEntry_EmployeeTimeSheets` (`timesheet`),
  KEY `employee_project` (`employee`,`project`),
  KEY `employee_project_date_start` (`employee`,`project`,`date_start`),
  CONSTRAINT `Fk_EmployeeTimeEntry_Employee` FOREIGN KEY (`employee`) REFERENCES `Employees` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Fk_EmployeeTimeEntry_EmployeeTimeSheets` FOREIGN KEY (`timesheet`) REFERENCES `EmployeeTimeSheets` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Fk_EmployeeTimeEntry_Projects` FOREIGN KEY (`project`) REFERENCES `Projects` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `EmployeeTimeEntry`
--

LOCK TABLES `EmployeeTimeEntry` WRITE;
/*!40000 ALTER TABLE `EmployeeTimeEntry` DISABLE KEYS */;
/*!40000 ALTER TABLE `EmployeeTimeEntry` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `EmployeeTimeSheets`
--

DROP TABLE IF EXISTS `EmployeeTimeSheets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `EmployeeTimeSheets` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `employee` bigint(20) NOT NULL,
  `date_start` date NOT NULL,
  `date_end` date NOT NULL,
  `status` enum('Approved','Pending','Rejected','Submitted') DEFAULT 'Pending',
  PRIMARY KEY (`id`),
  UNIQUE KEY `EmployeeTimeSheetsKey` (`employee`,`date_start`,`date_end`),
  KEY `EmployeeTimeSheets_date_end` (`date_end`),
  CONSTRAINT `Fk_EmployeeTimeSheets_Employee` FOREIGN KEY (`employee`) REFERENCES `Employees` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `EmployeeTimeSheets`
--

LOCK TABLES `EmployeeTimeSheets` WRITE;
/*!40000 ALTER TABLE `EmployeeTimeSheets` DISABLE KEYS */;
INSERT INTO `EmployeeTimeSheets` VALUES (1,1,'2020-02-09','2020-02-15','Pending'),(2,1,'2020-02-16','2020-02-22','Pending'),(3,1,'2020-02-23','2020-02-29','Pending'),(4,1,'2020-03-01','2020-03-07','Pending');
/*!40000 ALTER TABLE `EmployeeTimeSheets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `EmployeeTrainingSessions`
--

DROP TABLE IF EXISTS `EmployeeTrainingSessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `EmployeeTrainingSessions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `employee` bigint(20) NOT NULL,
  `trainingSession` bigint(20) DEFAULT NULL,
  `feedBack` varchar(1500) DEFAULT NULL,
  `status` enum('Scheduled','Attended','Not-Attended','Completed') DEFAULT 'Scheduled',
  `proof` varchar(300) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `Fk_EmployeeTrainingSessions_TrainingSessions` (`trainingSession`),
  KEY `Fk_EmployeeTrainingSessions_Employee` (`employee`),
  CONSTRAINT `Fk_EmployeeTrainingSessions_Employee` FOREIGN KEY (`employee`) REFERENCES `Employees` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Fk_EmployeeTrainingSessions_TrainingSessions` FOREIGN KEY (`trainingSession`) REFERENCES `TrainingSessions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `EmployeeTrainingSessions`
--

LOCK TABLES `EmployeeTrainingSessions` WRITE;
/*!40000 ALTER TABLE `EmployeeTrainingSessions` DISABLE KEYS */;
/*!40000 ALTER TABLE `EmployeeTrainingSessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `EmployeeTravelRecords`
--

DROP TABLE IF EXISTS `EmployeeTravelRecords`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `EmployeeTravelRecords` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `employee` bigint(20) NOT NULL,
  `type` varchar(200) DEFAULT '',
  `purpose` varchar(200) NOT NULL,
  `travel_from` varchar(200) NOT NULL,
  `travel_to` varchar(200) NOT NULL,
  `travel_date` datetime DEFAULT NULL,
  `return_date` datetime DEFAULT NULL,
  `details` varchar(500) DEFAULT NULL,
  `funding` decimal(10,3) DEFAULT NULL,
  `currency` bigint(20) DEFAULT NULL,
  `attachment1` varchar(100) DEFAULT NULL,
  `attachment2` varchar(100) DEFAULT NULL,
  `attachment3` varchar(100) DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `updated` datetime DEFAULT NULL,
  `status` enum('Approved','Pending','Rejected','Cancellation Requested','Cancelled','Processing') DEFAULT 'Pending',
  PRIMARY KEY (`id`),
  KEY `Fk_EmployeeTravelRecords_Employee` (`employee`),
  CONSTRAINT `Fk_EmployeeTravelRecords_Employee` FOREIGN KEY (`employee`) REFERENCES `Employees` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `EmployeeTravelRecords`
--

LOCK TABLES `EmployeeTravelRecords` WRITE;
/*!40000 ALTER TABLE `EmployeeTravelRecords` DISABLE KEYS */;
/*!40000 ALTER TABLE `EmployeeTravelRecords` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Employees`
--

DROP TABLE IF EXISTS `Employees`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Employees` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `employee_id` varchar(50) DEFAULT NULL,
  `first_name` varchar(100) NOT NULL DEFAULT '',
  `middle_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  `nationality` bigint(20) DEFAULT NULL,
  `birthday` date DEFAULT NULL,
  `gender` enum('Male','Female') DEFAULT NULL,
  `marital_status` enum('Married','Single','Divorced','Widowed','Other') DEFAULT NULL,
  `ssn_num` varchar(100) DEFAULT NULL,
  `nic_num` varchar(100) DEFAULT NULL,
  `other_id` varchar(100) DEFAULT NULL,
  `driving_license` varchar(100) DEFAULT NULL,
  `driving_license_exp_date` date DEFAULT NULL,
  `employment_status` bigint(20) DEFAULT NULL,
  `job_title` bigint(20) DEFAULT NULL,
  `pay_grade` bigint(20) DEFAULT NULL,
  `work_station_id` varchar(100) DEFAULT NULL,
  `address1` varchar(100) DEFAULT NULL,
  `address2` varchar(100) DEFAULT NULL,
  `city` varchar(150) DEFAULT NULL,
  `country` char(2) DEFAULT NULL,
  `province` bigint(20) DEFAULT NULL,
  `postal_code` varchar(20) DEFAULT NULL,
  `home_phone` varchar(50) DEFAULT NULL,
  `mobile_phone` varchar(50) DEFAULT NULL,
  `work_phone` varchar(50) DEFAULT NULL,
  `work_email` varchar(100) DEFAULT NULL,
  `private_email` varchar(100) DEFAULT NULL,
  `joined_date` date DEFAULT NULL,
  `confirmation_date` date DEFAULT NULL,
  `supervisor` bigint(20) DEFAULT NULL,
  `indirect_supervisors` varchar(250) DEFAULT NULL,
  `department` bigint(20) DEFAULT NULL,
  `custom1` varchar(250) DEFAULT NULL,
  `custom2` varchar(250) DEFAULT NULL,
  `custom3` varchar(250) DEFAULT NULL,
  `custom4` varchar(250) DEFAULT NULL,
  `custom5` varchar(250) DEFAULT NULL,
  `custom6` varchar(250) DEFAULT NULL,
  `custom7` varchar(250) DEFAULT NULL,
  `custom8` varchar(250) DEFAULT NULL,
  `custom9` varchar(250) DEFAULT NULL,
  `custom10` varchar(250) DEFAULT NULL,
  `termination_date` date DEFAULT NULL,
  `notes` text,
  `status` enum('Active','Terminated') DEFAULT 'Active',
  `ethnicity` bigint(20) DEFAULT NULL,
  `immigration_status` bigint(20) DEFAULT NULL,
  `approver1` bigint(20) DEFAULT NULL,
  `approver2` bigint(20) DEFAULT NULL,
  `approver3` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `employee_id` (`employee_id`),
  KEY `Fk_Employee_Nationality` (`nationality`),
  KEY `Fk_Employee_JobTitle` (`job_title`),
  KEY `Fk_Employee_EmploymentStatus` (`employment_status`),
  KEY `Fk_Employee_Country` (`country`),
  KEY `Fk_Employee_Province` (`province`),
  KEY `Fk_Employee_Supervisor` (`supervisor`),
  KEY `Fk_Employee_CompanyStructures` (`department`),
  KEY `Fk_Employee_PayGrades` (`pay_grade`),
  CONSTRAINT `Fk_Employee_CompanyStructures` FOREIGN KEY (`department`) REFERENCES `CompanyStructures` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `Fk_Employee_Country` FOREIGN KEY (`country`) REFERENCES `Country` (`code`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `Fk_Employee_EmploymentStatus` FOREIGN KEY (`employment_status`) REFERENCES `EmploymentStatus` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `Fk_Employee_JobTitle` FOREIGN KEY (`job_title`) REFERENCES `JobTitles` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `Fk_Employee_Nationality` FOREIGN KEY (`nationality`) REFERENCES `Nationality` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `Fk_Employee_PayGrades` FOREIGN KEY (`pay_grade`) REFERENCES `PayGrades` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `Fk_Employee_Province` FOREIGN KEY (`province`) REFERENCES `Province` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `Fk_Employee_Supervisor` FOREIGN KEY (`supervisor`) REFERENCES `Employees` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=144 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Employees`
--

LOCK TABLES `Employees` WRITE;
/*!40000 ALTER TABLE `Employees` DISABLE KEYS */;
INSERT INTO `Employees` VALUES (1,'EMP001','IceHrm','Sample','Employee',35,'1984-03-17','Male','Married','','294-38-3535','294-38-3535','',NULL,NULL,NULL,2,'','2772 Flynn Street','Willoughby','Willoughby','US',41,'44094','440-953-4578','440-953-4578','440-953-4578','icehrm+admin@web-stalk.com','icehrm+admin@web-stalk.com','2005-08-03',NULL,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Active',NULL,NULL,NULL,NULL,NULL),(3,'DEMO-01','Demo','','Superadmin',1,'1990-01-01','Male','Married','','','','',NULL,NULL,NULL,NULL,'','','','','VN',NULL,'','','','','','','2020-03-06',NULL,NULL,'[\"NULL\"]',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'','Active',NULL,NULL,NULL,NULL,NULL),(4,'DEMO-02','Demo','','Admin',1,'1990-01-01','Male','Married','','','','',NULL,NULL,NULL,NULL,'','','','','VN',NULL,'','','','','','','2020-03-06',NULL,NULL,'[\"NULL\"]',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'','Active',NULL,NULL,NULL,NULL,NULL),(5,'DEMO-03','Demo','','Staff',1,'1990-01-01','Male','Married','','','','',NULL,NULL,NULL,NULL,'','','','','VN',NULL,'','','','','','','2020-03-06',NULL,NULL,'[\"NULL\"]',1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'','Active',NULL,NULL,NULL,NULL,NULL),(111,NULL,'Long','Huá»³nh','Pháº¡m',NULL,'2020-02-20',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2020-02-20',NULL,NULL,NULL,NULL,'abd468eb06dbbb7f80be4b5a6b6a3110',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Active',NULL,NULL,NULL,NULL,NULL),(112,'1','THOA','THá»Š KIM','TRáº¦N',NULL,'1990-08-06',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,14,NULL,NULL,NULL,NULL,NULL,'VN',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2015-08-06',NULL,111,NULL,NULL,'b40b1280660c0cfec5dd31b89a24df8f','123456789',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Active',NULL,NULL,NULL,NULL,NULL),(113,'2','MAI','THá»Š TRÃšC','TRáº¦N',NULL,'1990-08-07',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,15,NULL,NULL,NULL,NULL,NULL,'VN',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2015-08-07',NULL,112,NULL,NULL,'4352b682b1056f66102b14854413689c','123456789',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Active',NULL,NULL,NULL,NULL,NULL),(114,'3','TRANG','NHáº¬T KHÃNH','NGUYá»„N',NULL,'1990-08-08',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,16,NULL,NULL,NULL,NULL,NULL,'VN',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2015-08-08',NULL,113,NULL,NULL,'f06cfd0b76cec008562057061efca578','123456789',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Active',NULL,NULL,NULL,NULL,NULL),(115,'4','THÃšY','THá»Š','BÃ™I',NULL,'1990-08-09',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,16,NULL,NULL,NULL,NULL,NULL,'VN',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2015-08-09',NULL,113,NULL,NULL,'443be4828b95a55f588ddb780a28ad7d','123456789',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Active',NULL,NULL,NULL,NULL,NULL),(116,'5','UYÃŠN','NGá»ŒC','NGUYá»„N',NULL,'1990-08-10',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,17,NULL,NULL,NULL,NULL,NULL,'VN',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2015-08-10',NULL,111,NULL,NULL,'047d6836e4da5e9d4d7cdce71b8f5a52','123456789',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Active',NULL,NULL,NULL,NULL,NULL),(117,'6','NGUYá»†T','ÃNH','ÄÃ€O',NULL,'1990-08-11',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,18,NULL,NULL,NULL,NULL,NULL,'VN',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2015-08-11',NULL,116,NULL,NULL,'7f5c24c5596419b709564496842f3090','123456789',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Active',NULL,NULL,NULL,NULL,NULL),(118,'7','HOA','KIM','TRáº¦N',NULL,'1990-08-12',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,18,NULL,NULL,NULL,NULL,NULL,'VN',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2015-08-12',NULL,116,NULL,NULL,'b96f8c5d7fd0d4ecfa715d5b704938ad','123456789',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Active',NULL,NULL,NULL,NULL,NULL),(119,'8','TRANG','THá»¤Y MINH','TRáº¦N',NULL,'1990-08-13',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,19,NULL,NULL,NULL,NULL,NULL,'VN',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2015-08-13',NULL,116,NULL,NULL,'bc53c08235a5736a2a97b10eb3548a82','123456789',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Active',NULL,NULL,NULL,NULL,NULL),(120,'9','PHÆ¯Æ NG','CHÃ‚U','NGUYá»„N',NULL,'1990-08-14',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,20,NULL,NULL,NULL,NULL,NULL,'VN',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2015-08-14',NULL,119,NULL,NULL,'787eae3d425627ea74f40b92b0d0dfdd','123456789',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Active',NULL,NULL,NULL,NULL,NULL),(121,'10','THÃ€NH','TRáº¦N TUáº¤N','TÄ‚NG',NULL,'1990-08-15',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,21,NULL,NULL,NULL,NULL,NULL,'VN',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2015-08-15',NULL,119,NULL,NULL,'f670f5bc779f08baaa4dffcc7679eb33','123456789',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Active',NULL,NULL,NULL,NULL,NULL),(122,'11','THUáº¬T','QUANG','TRáº¦N',NULL,'1990-08-16',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,21,NULL,NULL,NULL,NULL,NULL,'VN',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2015-08-16',NULL,119,NULL,NULL,'ee4537d95121ce210eab04e0ed779aa7','123456789',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Active',NULL,NULL,NULL,NULL,NULL),(123,'12','TIá»†P','VÄ‚N','TRáº¦N',NULL,'1990-08-17',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,21,NULL,NULL,NULL,NULL,NULL,'VN',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2015-08-17',NULL,119,NULL,NULL,'6adaed70a63a21578ed817ba89b9523c','123456789',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Active',NULL,NULL,NULL,NULL,NULL),(124,'13','THá»¦Y','NGUYá»†T','HUá»²NH',NULL,'1990-08-18',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,22,NULL,NULL,NULL,NULL,NULL,'VN',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2015-08-18',NULL,119,NULL,NULL,'fb20b145dc9e7d852e84f85c14feb9ba','123456789',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Active',NULL,NULL,NULL,NULL,NULL),(125,'14','TÃ‚M','MINH','NGUYá»„N',NULL,'1990-08-19',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,23,NULL,NULL,NULL,NULL,NULL,'VN',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2015-08-19',NULL,119,NULL,NULL,'cf01e67670bbb4811d242d37419546ed','123456789',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Active',NULL,NULL,NULL,NULL,NULL),(126,'15','GIAO','VÅ¨ QUá»²NH','Äáº¶NG',NULL,'1990-08-20',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,24,NULL,NULL,NULL,NULL,NULL,'VN',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2015-08-20',NULL,119,NULL,NULL,'2d42958054f5e6ac33da765abfd5dab6','123456789',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Active',NULL,NULL,NULL,NULL,NULL),(127,'16','HIáº¾U','THá»Š','LÃŠ',NULL,'1990-08-21',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,25,NULL,NULL,NULL,NULL,NULL,'VN',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2015-08-21',NULL,111,NULL,NULL,'77aaa52b4ac0bf4a7cba9f03a0f77e19','123456789',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Active',NULL,NULL,NULL,NULL,NULL),(128,'17','QUANG','NGá»ŒC','NGUYá»„N',NULL,'1990-08-22',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,26,NULL,NULL,NULL,NULL,NULL,'VN',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2015-08-22',NULL,111,NULL,NULL,'674fc5efaf4072b7bf5d7ea121ec00d3','123456789',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Active',NULL,NULL,NULL,NULL,NULL),(129,'18','HÃ€','THá»Š THU','ÄOÃ€N',NULL,'1990-08-23',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,27,NULL,NULL,NULL,NULL,NULL,'VN',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2015-08-23',NULL,128,NULL,NULL,'e203e4145211ce2293862faae66c135e','123456789',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Active',NULL,NULL,NULL,NULL,NULL),(130,'19','KHÃNH','Há»®U','HUá»²NH',NULL,'1990-08-24',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,28,NULL,NULL,NULL,NULL,NULL,'VN',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2015-08-24',NULL,128,NULL,NULL,'eff2294e4559430307c15164976b4d52','123456789',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Active',NULL,NULL,NULL,NULL,NULL),(131,'20','PHÆ¯Æ NG','MINH','TÄ‚NG',NULL,'1990-08-25',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,29,NULL,NULL,NULL,NULL,NULL,'VN',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2015-08-25',NULL,128,NULL,NULL,'4d8cbd5aca79084d0c1bc85a8c65e587','123456789',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Active',NULL,NULL,NULL,NULL,NULL),(132,'21','QUÃ‚N','NHÆ¯','KIá»€U',NULL,'1990-08-26',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,30,NULL,NULL,NULL,NULL,NULL,'VN',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2015-08-26',NULL,128,NULL,NULL,'8aca1f660bc473ad1a8b44f8e57e0585','123456789',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Active',NULL,NULL,NULL,NULL,NULL),(133,'22','TÃš','Máº NH','VÅ¨',NULL,'1990-08-27',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,31,NULL,NULL,NULL,NULL,NULL,'VN',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2015-08-27',NULL,111,NULL,NULL,'730b8be373c91d7385d538af953736c7','123456789',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Active',NULL,NULL,NULL,NULL,NULL),(134,'23','QUYÃŠN','THá»Š Báº¢O','HUá»²NH',NULL,'1990-08-28',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,32,NULL,NULL,NULL,NULL,NULL,'VN',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2015-08-28',NULL,133,NULL,NULL,'27ca0b9e182ad8a3ff92abde94884a41','123456789',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Active',NULL,NULL,NULL,NULL,NULL),(135,'24','VIá»†T','QUá»C','NGUYá»„N',NULL,'1990-08-29',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,27,NULL,NULL,NULL,NULL,NULL,'VN',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2015-08-29',NULL,133,NULL,NULL,'672f9ff0c11f6acbc13a649941203a24','123456789',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Active',NULL,NULL,NULL,NULL,NULL),(136,'25','DÅ¨NG','VÄ‚N','LÃŠ',NULL,'1990-08-30',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,27,NULL,NULL,NULL,NULL,NULL,'VN',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2015-08-30',NULL,133,NULL,NULL,'1422f2b51f88f95a9a6a8df9e6953a9f','123456789',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Active',NULL,NULL,NULL,NULL,NULL),(137,'26','QUYá»€N','THÃI','NGUYá»„N',NULL,'1990-08-31',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,27,NULL,NULL,NULL,NULL,NULL,'VN',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2015-08-31',NULL,133,NULL,NULL,'0f6637013648ecf1d3760c3cec7b944c','123456789',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Active',NULL,NULL,NULL,NULL,NULL),(138,'27','THáº CH','VÄ¨NH','LÃŠ',NULL,'1990-09-01',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,27,NULL,NULL,NULL,NULL,NULL,'VN',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2015-09-01',NULL,133,NULL,NULL,'a6491bae21830c94723d8186640aa5f7','123456789',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Active',NULL,NULL,NULL,NULL,NULL),(139,'28','OANH','KIá»€U','LÃŠ',NULL,'1990-09-02',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,27,NULL,NULL,NULL,NULL,NULL,'VN',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2015-09-02',NULL,133,NULL,NULL,'9125e1b54b982a1288c25f5618886ff1','123456789',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Active',NULL,NULL,NULL,NULL,NULL),(140,'29','NHÆ¯','THá»Š Há»’NG','NGUYá»„N',NULL,'1990-09-03',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,27,NULL,NULL,NULL,NULL,NULL,'VN',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2015-09-03',NULL,133,NULL,NULL,'81c448605f21952820e99a68a4e2f921','123456789',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Active',NULL,NULL,NULL,NULL,NULL),(141,'30','QUá»²NH','TRá»ŒNG','PHáº M',NULL,'1990-09-04',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,30,NULL,NULL,NULL,NULL,NULL,'VN',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2015-09-04',NULL,133,NULL,NULL,'121a8dc000068945b46b5f27935dff6a','123456789',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Active',NULL,NULL,NULL,NULL,NULL),(142,'31','TÃ‚N','NÄ‚NG','Há»’',NULL,'1990-09-05',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,30,NULL,NULL,NULL,NULL,NULL,'VN',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2015-09-05',NULL,133,NULL,NULL,'fb23f7605fd7823ef19699e5cc476028','123456789',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Active',NULL,NULL,NULL,NULL,NULL),(143,'32','PHÃš','NGá»ŒC THIá»†N','TIÃŠU',NULL,'1990-09-06',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,30,NULL,NULL,NULL,NULL,NULL,'VN',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2015-09-06',NULL,133,NULL,NULL,'894d46db7faecb4dc61060ab89d7671c','123456789',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Active',NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `Employees` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `EmployementType`
--

DROP TABLE IF EXISTS `EmployementType`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `EmployementType` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(250) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `EmployementType`
--

LOCK TABLES `EmployementType` WRITE;
/*!40000 ALTER TABLE `EmployementType` DISABLE KEYS */;
INSERT INTO `EmployementType` VALUES (1,'Full-time'),(2,'Part-time'),(3,'Contract'),(4,'Temporary'),(5,'Other');
/*!40000 ALTER TABLE `EmployementType` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `EmploymentStatus`
--

DROP TABLE IF EXISTS `EmploymentStatus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `EmploymentStatus` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `description` varchar(400) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `EmploymentStatus`
--

LOCK TABLES `EmploymentStatus` WRITE;
/*!40000 ALTER TABLE `EmploymentStatus` DISABLE KEYS */;
INSERT INTO `EmploymentStatus` VALUES (1,'ToÃ n thá»i gian','ToÃ n thá»i gian'),(2,'BÃ¡n thá»i gian','BÃ¡n thá»i gian'),(3,'Thá»±c táº­p','Thá»±c táº­p');
/*!40000 ALTER TABLE `EmploymentStatus` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Ethnicity`
--

DROP TABLE IF EXISTS `Ethnicity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Ethnicity` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Ethnicity`
--

LOCK TABLES `Ethnicity` WRITE;
/*!40000 ALTER TABLE `Ethnicity` DISABLE KEYS */;
INSERT INTO `Ethnicity` VALUES (1,'Kinh'),(2,'KhÃ¡c');
/*!40000 ALTER TABLE `Ethnicity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ExpensesCategories`
--

DROP TABLE IF EXISTS `ExpensesCategories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ExpensesCategories` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(500) NOT NULL,
  `created` datetime DEFAULT NULL,
  `updated` datetime DEFAULT NULL,
  `pre_approve` enum('Yes','No') DEFAULT 'Yes',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ExpensesCategories`
--

LOCK TABLES `ExpensesCategories` WRITE;
/*!40000 ALTER TABLE `ExpensesCategories` DISABLE KEYS */;
INSERT INTO `ExpensesCategories` VALUES (1,'Auto - Gas',NULL,NULL,'Yes'),(2,'Auto - Insurance',NULL,NULL,'Yes'),(3,'Auto - Maintenance',NULL,NULL,'Yes'),(4,'Auto - Payment',NULL,NULL,'Yes'),(5,'Transportation',NULL,NULL,'Yes'),(6,'Bank Fees',NULL,NULL,'Yes'),(7,'Dining Out',NULL,NULL,'Yes'),(8,'Entertainment',NULL,NULL,'Yes'),(9,'Hotel / Motel',NULL,NULL,'Yes'),(10,'Insurance',NULL,NULL,'Yes'),(11,'Interest Charges',NULL,NULL,'Yes'),(12,'Loan Payment',NULL,NULL,'Yes'),(13,'Medical',NULL,NULL,'Yes'),(14,'Mileage',NULL,NULL,'Yes'),(15,'Rent',NULL,NULL,'Yes'),(16,'Rental Car',NULL,NULL,'Yes'),(17,'Utility',NULL,NULL,'Yes');
/*!40000 ALTER TABLE `ExpensesCategories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ExpensesPaymentMethods`
--

DROP TABLE IF EXISTS `ExpensesPaymentMethods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ExpensesPaymentMethods` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(500) NOT NULL,
  `created` datetime DEFAULT NULL,
  `updated` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ExpensesPaymentMethods`
--

LOCK TABLES `ExpensesPaymentMethods` WRITE;
/*!40000 ALTER TABLE `ExpensesPaymentMethods` DISABLE KEYS */;
INSERT INTO `ExpensesPaymentMethods` VALUES (1,'Cash',NULL,NULL),(2,'Check',NULL,NULL),(3,'Credit Card',NULL,NULL),(4,'Debit Card',NULL,NULL);
/*!40000 ALTER TABLE `ExpensesPaymentMethods` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ExperienceLevel`
--

DROP TABLE IF EXISTS `ExperienceLevel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ExperienceLevel` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(250) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ExperienceLevel`
--

LOCK TABLES `ExperienceLevel` WRITE;
/*!40000 ALTER TABLE `ExperienceLevel` DISABLE KEYS */;
INSERT INTO `ExperienceLevel` VALUES (1,'Not Applicable'),(2,'Internship'),(3,'Entry level'),(4,'Associate'),(5,'Mid-Senior level'),(6,'Director'),(7,'Executive');
/*!40000 ALTER TABLE `ExperienceLevel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `FieldNameMappings`
--

DROP TABLE IF EXISTS `FieldNameMappings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `FieldNameMappings` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `type` varchar(20) NOT NULL,
  `name` varchar(20) NOT NULL,
  `textOrig` varchar(200) DEFAULT NULL,
  `textMapped` varchar(200) DEFAULT NULL,
  `display` enum('Form','Table and Form','Hidden') DEFAULT 'Form',
  `created` datetime DEFAULT NULL,
  `updated` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `FieldNameMappings`
--

LOCK TABLES `FieldNameMappings` WRITE;
/*!40000 ALTER TABLE `FieldNameMappings` DISABLE KEYS */;
INSERT INTO `FieldNameMappings` VALUES (1,'Employee','employee_id','Employee Number','Employee Number','Table and Form',NULL,NULL),(2,'Employee','first_name','First Name','First Name','Table and Form',NULL,NULL),(3,'Employee','middle_name','Middle Name','Middle Name','Form',NULL,NULL),(4,'Employee','last_name','Last Name','Last Name','Table and Form',NULL,NULL),(5,'Employee','nationality','Nationality','Nationality','Form',NULL,NULL),(6,'Employee','ethnicity','Ethnicity','Ethnicity','Form',NULL,NULL),(7,'Employee','immigration_status','Immigration Status','Immigration Status','Form',NULL,NULL),(8,'Employee','birthday','Date of Birth','Date of Birth','Form',NULL,NULL),(9,'Employee','gender','Gender','Gender','Form',NULL,NULL),(10,'Employee','marital_status','Marital Status','Marital Status','Form',NULL,NULL),(11,'Employee','ssn_num','SSN/NRIC','SSN/NRIC','Form',NULL,NULL),(12,'Employee','nic_num','NIC','NIC','Form',NULL,NULL),(13,'Employee','other_id','Other ID','Other ID','Form',NULL,NULL),(14,'Employee','driving_license','Driving License No','Driving License No','Form',NULL,NULL),(15,'Employee','employment_status','Employment Status','Employment Status','Form',NULL,NULL),(16,'Employee','job_title','Job Title','Job Title','Form',NULL,NULL),(17,'Employee','pay_grade','Pay Grade','Pay Grade','Form',NULL,NULL),(18,'Employee','work_station_id','Work Station Id','Work Station Id','Form',NULL,NULL),(19,'Employee','address1','Address Line 1','Address Line 1','Form',NULL,NULL),(20,'Employee','address2','Address Line 2','Address Line 2','Form',NULL,NULL),(21,'Employee','city','City','City','Form',NULL,NULL),(22,'Employee','country','Country','Country','Form',NULL,NULL),(23,'Employee','province','Province','Province','Form',NULL,NULL),(24,'Employee','postal_code','Postal/Zip Code','Postal/Zip Code','Form',NULL,NULL),(25,'Employee','home_phone','Home Phone','Home Phone','Form',NULL,NULL),(26,'Employee','mobile_phone','Mobile Phone','Mobile Phone','Table and Form',NULL,NULL),(27,'Employee','work_phone','Work Phone','Work Phone','Form',NULL,NULL),(28,'Employee','work_email','Work Email','Work Email','Form',NULL,NULL),(29,'Employee','private_email','Private Email','Private Email','Form',NULL,NULL),(30,'Employee','joined_date','Joined Date','Joined Date','Form',NULL,NULL),(31,'Employee','confirmation_date','Confirmation Date','Confirmation Date','Form',NULL,NULL),(32,'Employee','termination_date','Termination Date','Termination Date','Form',NULL,NULL),(33,'Employee','supervisor','Supervisor','Supervisor','Table and Form',NULL,NULL),(34,'Employee','department','Department','Department','Table and Form',NULL,NULL),(35,'Employee','indirect_supervisors','Indirect Supervisors','Indirect Supervisors','Form',NULL,NULL),(36,'Employee','notes','Notes','Notes','Form',NULL,NULL);
/*!40000 ALTER TABLE `FieldNameMappings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Files`
--

DROP TABLE IF EXISTS `Files`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Files` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `filename` varchar(100) NOT NULL,
  `employee` bigint(20) DEFAULT NULL,
  `file_group` varchar(100) NOT NULL,
  `size` bigint(20) DEFAULT NULL,
  `size_text` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `filename` (`filename`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Files`
--

LOCK TABLES `Files` WRITE;
/*!40000 ALTER TABLE `Files` DISABLE KEYS */;
INSERT INTO `Files` VALUES (5,'file_6fHpJptHOsrfaB1583820245731','file_6fHpJptHOsrfaB1583820245731.csv',3,'DataImportFile',4176,'4.08 K');
/*!40000 ALTER TABLE `Files` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Forms`
--

DROP TABLE IF EXISTS `Forms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Forms` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `description` varchar(500) DEFAULT NULL,
  `items` text,
  `created` datetime DEFAULT NULL,
  `updated` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Forms`
--

LOCK TABLES `Forms` WRITE;
/*!40000 ALTER TABLE `Forms` DISABLE KEYS */;
/*!40000 ALTER TABLE `Forms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `HiringPipeline`
--

DROP TABLE IF EXISTS `HiringPipeline`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `HiringPipeline` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `type` enum('Short Listed','Phone Screen','Assessment','Interview','Offer','Hired','Rejected','Archived') DEFAULT 'Short Listed',
  `notes` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `HiringPipeline`
--

LOCK TABLES `HiringPipeline` WRITE;
/*!40000 ALTER TABLE `HiringPipeline` DISABLE KEYS */;
INSERT INTO `HiringPipeline` VALUES (1,'Sourced','Short Listed',NULL),(2,'Applied','Short Listed',NULL),(3,'Phone Screen','Phone Screen',NULL),(4,'Assessment','Assessment',NULL),(5,'First Interview','Interview',NULL),(6,'Second Interview','Interview',NULL),(7,'Final Interview','Interview',NULL),(8,'Offer Sent','Offer',NULL),(9,'Offer Accepted','Offer',NULL),(10,'Offer Rejected','Offer',NULL),(11,'Not Qualified','Rejected',NULL),(12,'Archived','Archived',NULL),(13,'Hired','Hired',NULL);
/*!40000 ALTER TABLE `HiringPipeline` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `HoliDays`
--

DROP TABLE IF EXISTS `HoliDays`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `HoliDays` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `dateh` date DEFAULT NULL,
  `status` enum('Full Day','Half Day') DEFAULT 'Full Day',
  `country` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `holidays_dateh_country` (`dateh`,`country`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `HoliDays`
--

LOCK TABLES `HoliDays` WRITE;
/*!40000 ALTER TABLE `HoliDays` DISABLE KEYS */;
INSERT INTO `HoliDays` VALUES (1,'New Year\'s Day','2015-01-01','Full Day',NULL),(2,'Christmas Day','2015-12-25','Full Day',NULL);
/*!40000 ALTER TABLE `HoliDays` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ImmigrationDocuments`
--

DROP TABLE IF EXISTS `ImmigrationDocuments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ImmigrationDocuments` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `details` text,
  `required` enum('Yes','No') DEFAULT 'Yes',
  `alert_on_missing` enum('Yes','No') DEFAULT 'Yes',
  `alert_before_expiry` enum('Yes','No') DEFAULT 'Yes',
  `alert_before_day_number` int(11) NOT NULL,
  `created` datetime DEFAULT NULL,
  `updated` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ImmigrationDocuments`
--

LOCK TABLES `ImmigrationDocuments` WRITE;
/*!40000 ALTER TABLE `ImmigrationDocuments` DISABLE KEYS */;
/*!40000 ALTER TABLE `ImmigrationDocuments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ImmigrationStatus`
--

DROP TABLE IF EXISTS `ImmigrationStatus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ImmigrationStatus` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ImmigrationStatus`
--

LOCK TABLES `ImmigrationStatus` WRITE;
/*!40000 ALTER TABLE `ImmigrationStatus` DISABLE KEYS */;
INSERT INTO `ImmigrationStatus` VALUES (1,'ThÆ°á»ng trÃº'),(2,'Táº¡m trÃº');
/*!40000 ALTER TABLE `ImmigrationStatus` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Industry`
--

DROP TABLE IF EXISTS `Industry`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Industry` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(250) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Industry`
--

LOCK TABLES `Industry` WRITE;
/*!40000 ALTER TABLE `Industry` DISABLE KEYS */;
/*!40000 ALTER TABLE `Industry` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Interviews`
--

DROP TABLE IF EXISTS `Interviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Interviews` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `job` bigint(20) NOT NULL,
  `candidate` bigint(20) DEFAULT NULL,
  `level` varchar(100) DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `updated` datetime DEFAULT NULL,
  `scheduled` datetime DEFAULT NULL,
  `location` varchar(500) DEFAULT NULL,
  `mapId` bigint(20) DEFAULT NULL,
  `status` varchar(100) DEFAULT NULL,
  `notes` text,
  `scheduleUpdated` int(11) DEFAULT '0',
  `interviewers` text,
  PRIMARY KEY (`id`),
  KEY `Fk_Interviews_Job` (`job`),
  KEY `Fk_Interviews_Candidates` (`candidate`),
  CONSTRAINT `Fk_Interviews_Candidates` FOREIGN KEY (`candidate`) REFERENCES `Candidates` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Fk_Interviews_Job` FOREIGN KEY (`job`) REFERENCES `Job` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Interviews`
--

LOCK TABLES `Interviews` WRITE;
/*!40000 ALTER TABLE `Interviews` DISABLE KEYS */;
/*!40000 ALTER TABLE `Interviews` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Job`
--

DROP TABLE IF EXISTS `Job`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Job` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `title` varchar(200) NOT NULL,
  `shortDescription` text,
  `description` text,
  `requirements` text,
  `benefits` text,
  `country` bigint(20) DEFAULT NULL,
  `company` bigint(20) DEFAULT NULL,
  `department` varchar(100) DEFAULT NULL,
  `code` varchar(20) DEFAULT NULL,
  `employementType` bigint(20) DEFAULT NULL,
  `industry` bigint(20) DEFAULT NULL,
  `experienceLevel` bigint(20) DEFAULT NULL,
  `jobFunction` bigint(20) DEFAULT NULL,
  `educationLevel` bigint(20) DEFAULT NULL,
  `currency` bigint(20) DEFAULT NULL,
  `showSalary` enum('Yes','No') DEFAULT NULL,
  `salaryMin` bigint(20) DEFAULT NULL,
  `salaryMax` bigint(20) DEFAULT NULL,
  `keywords` text,
  `status` enum('Active','On hold','Closed') DEFAULT NULL,
  `closingDate` datetime DEFAULT NULL,
  `attachment` varchar(100) DEFAULT NULL,
  `display` varchar(200) NOT NULL,
  `postedBy` bigint(20) DEFAULT NULL,
  `location` varchar(500) DEFAULT NULL,
  `postalCode` varchar(20) DEFAULT NULL,
  `hiringManager` bigint(20) DEFAULT NULL,
  `companyName` varchar(100) DEFAULT NULL,
  `showHiringManager` enum('Yes','No') DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `Job_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Job`
--

LOCK TABLES `Job` WRITE;
/*!40000 ALTER TABLE `Job` DISABLE KEYS */;
/*!40000 ALTER TABLE `Job` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `JobFunction`
--

DROP TABLE IF EXISTS `JobFunction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `JobFunction` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(250) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `JobFunction`
--

LOCK TABLES `JobFunction` WRITE;
/*!40000 ALTER TABLE `JobFunction` DISABLE KEYS */;
INSERT INTO `JobFunction` VALUES (1,'Accounting/Auditing'),(2,'Administrative'),(3,'Advertising'),(4,'Business Analyst'),(5,'Financial Analyst'),(6,'Data Analyst'),(7,'Art/Creative'),(8,'Business Development'),(9,'Consulting'),(10,'Customer Service'),(11,'Distribution'),(12,'Design'),(13,'Education'),(14,'Engineering'),(15,'Finance'),(16,'General Business'),(17,'Health Care Provider'),(18,'Human Resources'),(19,'Information Technology'),(20,'Legal'),(21,'Management'),(22,'Manufacturing'),(23,'Marketing'),(24,'Other'),(25,'Public Relations'),(26,'Purchasing'),(27,'Product Management'),(28,'Project Management'),(29,'Production'),(30,'Quality Assurance'),(31,'Research'),(32,'Sales'),(33,'Science'),(34,'Strategy/Planning'),(35,'Supply Chain'),(36,'Training'),(37,'Writing/Editing');
/*!40000 ALTER TABLE `JobFunction` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `JobTitles`
--

DROP TABLE IF EXISTS `JobTitles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `JobTitles` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `code` varchar(10) NOT NULL DEFAULT '',
  `name` varchar(100) DEFAULT NULL,
  `description` varchar(200) DEFAULT NULL,
  `specification` varchar(400) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `JobTitles`
--

LOCK TABLES `JobTitles` WRITE;
/*!40000 ALTER TABLE `JobTitles` DISABLE KEYS */;
INSERT INTO `JobTitles` VALUES (14,'205b40ad09','Trá»£ lÃ½ Tá»•ng GiÃ¡m Äá»‘c & quyá»n giÃ¡m Ä‘á»‘c Vmed','Imported from Employee Data Importer',NULL),(15,'7f8ff54d34','TrÆ°á»Ÿng phÃ²ng há»— trá»£ kinh doanh & dá»± Ã¡n','Imported from Employee Data Importer',NULL),(16,'f61f68be3b','NhÃ¢n viÃªn há»— trá»£ kinh doanh & dá»± Ã¡n','Imported from Employee Data Importer',NULL),(17,'dc5fed0c25','GiÃ¡m Ä‘á»‘c tÃ i chÃ­nh & nhÃ¢n sá»±','Imported from Employee Data Importer',NULL),(18,'d53a6d328e','NhÃ¢n viÃªn káº¿ toÃ¡n','Imported from Employee Data Importer',NULL),(19,'dd2ed80586','ChuyÃªn viÃªn nhÃ¢n sá»± & Thá»§ quá»¹','Imported from Employee Data Importer',NULL),(20,'1fec60ef69','TÃ i xáº¿ trÆ°á»Ÿng','Imported from Employee Data Importer',NULL),(21,'d6678b8c4d','TÃ i xáº¿','Imported from Employee Data Importer',NULL),(22,'f789ef0448','Táº¡p vá»¥','Imported from Employee Data Importer',NULL),(23,'5f36e8bc85','Báº£o vá»‡','Imported from Employee Data Importer',NULL),(24,'e1817c8421','Tiáº¿p tÃ¢n','Imported from Employee Data Importer',NULL),(25,'f30c7688d3','TrÆ°á»Ÿng phÃ²ng truyá»n thÃ´ng & sá»± kiá»‡n','Imported from Employee Data Importer',NULL),(26,'a49fb783d7','GiÃ¡m Ä‘á»‘c kinh doanh (DI)','Imported from Employee Data Importer',NULL),(27,'0efa4133a2','NhÃ¢n viÃªn kinh doanh','Imported from Employee Data Importer',NULL),(28,'24d47c7c8c','TrÆ°á»Ÿng phÃ²ng dá»± Ã¡n ME','Imported from Employee Data Importer',NULL),(29,'2b6802c5b0','Táº¡m quyá»n trÆ°á»Ÿng phÃ²ng ká»¹ thuáº­t','Imported from Employee Data Importer',NULL),(30,'094cfa76dd','NhÃ¢n viÃªn ká»¹ thuáº­t','Imported from Employee Data Importer',NULL),(31,'150725913b','GiÃ¡m Ä‘á»‘c kinh doanh (ICU)','Imported from Employee Data Importer',NULL),(32,'75208b0469','ChuyÃªn viÃªn APP','Imported from Employee Data Importer',NULL);
/*!40000 ALTER TABLE `JobTitles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Languages`
--

DROP TABLE IF EXISTS `Languages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Languages` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `description` varchar(400) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Languages`
--

LOCK TABLES `Languages` WRITE;
/*!40000 ALTER TABLE `Languages` DISABLE KEYS */;
/*!40000 ALTER TABLE `Languages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `LeaveGroupEmployees`
--

DROP TABLE IF EXISTS `LeaveGroupEmployees`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `LeaveGroupEmployees` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `employee` bigint(20) NOT NULL,
  `leave_group` bigint(20) NOT NULL,
  `created` datetime DEFAULT NULL,
  `updated` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `Fk_LeaveGroupEmployees_LeaveGroups` (`leave_group`),
  KEY `Fk_LeaveGroupEmployees_Employee` (`employee`),
  CONSTRAINT `Fk_LeaveGroupEmployees_Employee` FOREIGN KEY (`employee`) REFERENCES `Employees` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Fk_LeaveGroupEmployees_LeaveGroups` FOREIGN KEY (`leave_group`) REFERENCES `LeaveGroups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `LeaveGroupEmployees`
--

LOCK TABLES `LeaveGroupEmployees` WRITE;
/*!40000 ALTER TABLE `LeaveGroupEmployees` DISABLE KEYS */;
/*!40000 ALTER TABLE `LeaveGroupEmployees` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `LeaveGroups`
--

DROP TABLE IF EXISTS `LeaveGroups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `LeaveGroups` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `details` text,
  `created` datetime DEFAULT NULL,
  `updated` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `LeaveGroups`
--

LOCK TABLES `LeaveGroups` WRITE;
/*!40000 ALTER TABLE `LeaveGroups` DISABLE KEYS */;
/*!40000 ALTER TABLE `LeaveGroups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `LeavePeriods`
--

DROP TABLE IF EXISTS `LeavePeriods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `LeavePeriods` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `date_start` date DEFAULT NULL,
  `date_end` date DEFAULT NULL,
  `status` enum('Active','Inactive') DEFAULT 'Inactive',
  `country` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `LeavePeriods`
--

LOCK TABLES `LeavePeriods` WRITE;
/*!40000 ALTER TABLE `LeavePeriods` DISABLE KEYS */;
INSERT INTO `LeavePeriods` VALUES (3,'Year 2015','2015-01-01','2015-12-31','Active',NULL),(4,'Year 2016','2016-01-01','2016-12-31','Active',NULL),(5,'Year 2017','2017-01-01','2017-12-31','Active',NULL);
/*!40000 ALTER TABLE `LeavePeriods` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `LeaveRules`
--

DROP TABLE IF EXISTS `LeaveRules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `LeaveRules` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `leave_type` bigint(20) NOT NULL,
  `job_title` bigint(20) DEFAULT NULL,
  `employment_status` bigint(20) DEFAULT NULL,
  `employee` bigint(20) DEFAULT NULL,
  `supervisor_leave_assign` enum('Yes','No') DEFAULT 'Yes',
  `employee_can_apply` enum('Yes','No') DEFAULT 'Yes',
  `apply_beyond_current` enum('Yes','No') DEFAULT 'Yes',
  `leave_accrue` enum('No','Yes') DEFAULT 'No',
  `carried_forward` enum('No','Yes') DEFAULT 'No',
  `default_per_year` decimal(10,3) NOT NULL,
  `carried_forward_percentage` int(11) DEFAULT '0',
  `carried_forward_leave_availability` int(11) DEFAULT '365',
  `propotionate_on_joined_date` enum('No','Yes') DEFAULT 'No',
  `leave_group` bigint(20) DEFAULT NULL,
  `max_carried_forward_amount` int(11) DEFAULT '0',
  `exp_days` int(11) DEFAULT NULL,
  `leave_period` bigint(20) DEFAULT NULL,
  `department` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `Fk_LeaveRules_leave_period` (`leave_period`),
  KEY `Fk_LeaveRules_department` (`department`),
  CONSTRAINT `Fk_LeaveRules_department` FOREIGN KEY (`department`) REFERENCES `CompanyStructures` (`id`),
  CONSTRAINT `Fk_LeaveRules_leave_period` FOREIGN KEY (`leave_period`) REFERENCES `LeavePeriods` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `LeaveRules`
--

LOCK TABLES `LeaveRules` WRITE;
/*!40000 ALTER TABLE `LeaveRules` DISABLE KEYS */;
/*!40000 ALTER TABLE `LeaveRules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `LeaveStartingBalance`
--

DROP TABLE IF EXISTS `LeaveStartingBalance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `LeaveStartingBalance` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `leave_type` bigint(20) NOT NULL,
  `employee` bigint(20) DEFAULT NULL,
  `leave_period` bigint(20) NOT NULL,
  `amount` decimal(10,3) NOT NULL,
  `note` text,
  `created` datetime DEFAULT NULL,
  `updated` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `LeaveStartingBalance`
--

LOCK TABLES `LeaveStartingBalance` WRITE;
/*!40000 ALTER TABLE `LeaveStartingBalance` DISABLE KEYS */;
/*!40000 ALTER TABLE `LeaveStartingBalance` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `LeaveTypes`
--

DROP TABLE IF EXISTS `LeaveTypes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `LeaveTypes` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `supervisor_leave_assign` enum('Yes','No') DEFAULT 'Yes',
  `employee_can_apply` enum('Yes','No') DEFAULT 'Yes',
  `apply_beyond_current` enum('Yes','No') DEFAULT 'Yes',
  `leave_accrue` enum('No','Yes') DEFAULT 'No',
  `carried_forward` enum('No','Yes') DEFAULT 'No',
  `default_per_year` decimal(10,3) NOT NULL,
  `carried_forward_percentage` int(11) DEFAULT '0',
  `carried_forward_leave_availability` int(11) DEFAULT '365',
  `propotionate_on_joined_date` enum('No','Yes') DEFAULT 'No',
  `send_notification_emails` enum('Yes','No') DEFAULT 'Yes',
  `leave_group` bigint(20) DEFAULT NULL,
  `leave_color` varchar(10) DEFAULT NULL,
  `max_carried_forward_amount` int(11) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `LeaveTypes`
--

LOCK TABLES `LeaveTypes` WRITE;
/*!40000 ALTER TABLE `LeaveTypes` DISABLE KEYS */;
INSERT INTO `LeaveTypes` VALUES (1,'Annual leave','No','Yes','No','No','No',14.000,0,365,'No','Yes',NULL,NULL,0),(2,'Casual leave','Yes','Yes','No','No','No',7.000,0,365,'No','Yes',NULL,NULL,0),(3,'Medical leave','Yes','Yes','Yes','No','No',7.000,0,365,'No','Yes',NULL,NULL,0);
/*!40000 ALTER TABLE `LeaveTypes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Migrations`
--

DROP TABLE IF EXISTS `Migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Migrations` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `file` varchar(50) NOT NULL,
  `version` int(11) NOT NULL,
  `created` datetime DEFAULT NULL,
  `updated` datetime DEFAULT NULL,
  `status` enum('Pending','Up','Down','UpError','DownError') DEFAULT 'Pending',
  `last_error` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `KEY_Migrations_file` (`file`),
  KEY `KEY_Migrations_status` (`status`),
  KEY `KEY_Migrations_version` (`version`)
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Migrations`
--

LOCK TABLES `Migrations` WRITE;
/*!40000 ALTER TABLE `Migrations` DISABLE KEYS */;
INSERT INTO `Migrations` VALUES (1,'v20161116_190001_unique_index_cron_name.php',190001,'2020-02-09 08:21:52','2020-02-09 08:21:52','Up',NULL),(2,'v20170310_190401_add_timesheet_changes.php',190401,'2020-02-09 08:21:52','2020-02-09 08:21:52','Up',NULL),(3,'v20170621_190401_report_modifications.php',190401,'2020-02-09 08:21:52','2020-02-09 08:21:52','Up',NULL),(4,'v20170702_190500_add_attendance_image.php',190500,'2020-02-09 08:21:52','2020-02-09 08:21:52','Up',NULL),(5,'v20170908_200000_payroll_group.php',200000,'2020-02-09 08:21:52','2020-02-09 08:21:52','Up',NULL),(6,'v20170918_200000_add_attendance_image_out.php',200000,'2020-02-09 08:21:52','2020-02-09 08:21:52','Up',NULL),(7,'v20171001_200201_update_attendance_out.php',200201,'2020-02-09 08:21:52','2020-02-09 08:21:52','Up',NULL),(8,'v20171003_200301_add_deduction_group_payroll.php',200301,'2020-02-09 08:21:52','2020-02-09 08:21:52','Up',NULL),(9,'v20171003_200302_payroll_meta_export.php',200302,'2020-02-09 08:21:52','2020-02-09 08:21:52','Up',NULL),(10,'v20171126_200303_swift_mail.php',200303,'2020-02-09 08:21:52','2020-02-09 08:21:52','Up',NULL),(11,'v20180305_210100_drop_si_hi_languages.php',210100,'2020-02-09 08:21:52','2020-02-09 08:21:52','Up',NULL),(12,'v20180317_210200_leave_rule_experience.php',210200,'2020-02-09 08:21:52','2020-02-09 08:21:52','Up',NULL),(13,'v20180325_210101_delete_leave_group_employee.php',210101,'2020-02-09 08:21:52','2020-02-09 08:21:52','Up',NULL),(14,'v20180417_210501_update_menu_names.php',210501,'2020-02-09 08:21:52','2020-02-09 08:21:52','Up',NULL),(15,'v20180507_230001_update_travel_record_type.php',230001,'2020-02-09 08:21:52','2020-02-09 08:21:52','Up',NULL),(16,'v20180514_230002_add_conversation_tables.php',230002,'2020-02-09 08:21:52','2020-02-09 08:21:52','Up',NULL),(17,'v20180527_230003_update_menu_names.php',230003,'2020-02-09 08:21:52','2020-02-09 08:21:52','Up',NULL),(18,'v20180602_230004_add_gsuite_fields.php',230004,'2020-02-09 08:21:52','2020-02-09 08:21:52','Up',NULL),(19,'v20180615_230402_remove_eh_manager.php',230402,'2020-02-09 08:21:52','2020-02-09 08:21:52','Up',NULL),(20,'v20180622_240001_set_valid_until_null.php',240001,'2020-02-09 08:21:52','2020-02-09 08:21:52','Up',NULL),(21,'v20180623_240002_update_employee_report.php',240002,'2020-02-09 08:21:52','2020-02-09 08:21:52','Up',NULL),(22,'v20180801_240003_asset_management.php',240003,'2020-02-09 08:21:52','2020-02-09 08:21:52','Up',NULL),(23,'v20180808_250004_add_languages.php',250004,'2020-02-09 08:21:52','2020-02-09 08:21:52','Up',NULL),(24,'v20180810_250005_performance_review.php',250005,'2020-02-09 08:21:52','2020-02-09 08:21:52','Up',NULL),(25,'v20180912_250006_remove_null_users.php',250006,'2020-02-09 08:21:52','2020-02-09 08:21:52','Up',NULL),(26,'v20181025_260001_dept_based_leave_periods.php',260001,'2020-02-09 08:21:52','2020-02-09 08:21:52','Up',NULL),(27,'v20181106_260002_add_arabic_lang.php',260002,'2020-02-09 08:21:52','2020-02-09 08:21:52','Up',NULL),(28,'v20190125_260003_attendance_with_map.php',260003,'2020-02-09 08:21:52','2020-02-09 08:21:52','Up',NULL),(29,'v20190508_260004_update_time_zones.php',260004,'2020-02-09 08:21:52','2020-02-09 08:21:52','Up',NULL),(30,'v20190509_260004_add_location_filed_to_job.php',260004,'2020-02-09 08:21:52','2020-02-09 08:21:52','Up',NULL),(31,'v20190510_260004_add_hiring_manager_job.php',260004,'2020-02-09 08:21:52','2020-02-09 08:21:52','Up',NULL),(32,'v20190630_260601_update_module_names.php',260601,'2020-02-09 08:21:52','2020-02-09 08:21:52','Up',NULL),(33,'v20190630_260602_add_leave_period_to_rule.php',260602,'2020-02-09 08:21:52','2020-02-09 08:21:52','Up',NULL),(34,'v20190630_260603_add_dept_leave_to_rule.php',260603,'2020-02-09 08:21:52','2020-02-09 08:21:52','Up',NULL),(35,'v20190707_260004_attendance_out_map.php',260004,'2020-02-09 08:21:52','2020-02-09 08:21:52','Up',NULL),(36,'v20190707_260005_attendance_location.php',260005,'2020-02-09 08:21:52','2020-02-09 08:21:52','Up',NULL),(37,'v20190707_260006_google_map_api.php',260006,'2020-02-09 08:21:52','2020-02-09 08:21:52','Up',NULL),(38,'v20200221_260007_y_viet_language.php',260007,'2020-03-04 09:28:30','2020-03-04 09:28:30','Up',NULL),(39,'v20200221_260008_y_viet_language.php',260008,'2020-03-05 19:18:03','2020-03-07 12:47:33','Up',NULL),(40,'v20200221_260009_y_viet_language.php',260009,'2020-03-07 12:47:33','2020-03-07 12:47:33','Up',NULL),(41,'v20200308_122400_employee_data_importer.php',122400,'2020-03-08 11:04:19','2020-03-08 11:04:19','Up',NULL),(42,'v20200222_260010_y_viet_language.php',260010,'2020-03-09 02:28:42','2020-03-09 02:28:42','Up',NULL),(43,'v20200222_260011_y_viet_language.php',260011,'2020-03-09 02:48:41','2020-03-09 02:48:41','Up',NULL);
/*!40000 ALTER TABLE `Migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Modules`
--

DROP TABLE IF EXISTS `Modules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Modules` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `menu` varchar(30) NOT NULL,
  `name` varchar(100) NOT NULL,
  `label` varchar(100) NOT NULL,
  `icon` varchar(50) DEFAULT NULL,
  `mod_group` varchar(30) NOT NULL,
  `mod_order` int(11) DEFAULT NULL,
  `status` enum('Enabled','Disabled') DEFAULT 'Enabled',
  `version` varchar(10) DEFAULT '',
  `update_path` varchar(500) DEFAULT '',
  `user_levels` varchar(500) NOT NULL,
  `user_roles` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `Modules_name_modgroup` (`name`,`mod_group`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Modules`
--

LOCK TABLES `Modules` WRITE;
/*!40000 ALTER TABLE `Modules` DISABLE KEYS */;
INSERT INTO `Modules` VALUES (1,'Employees','attendance','Monitor Attendance','fa-clock','admin',8,'Disabled','','admin>attendance','[\"Admin\",\"Manager\"]','[]'),(2,'Admin','company_structure','Company Structure','fa-building','admin',2,'Enabled','','admin>company_structure','[\"Admin\",\"Manager\"]',''),(3,'Admin','dashboard','Dashboard','fa-desktop','admin',1,'Enabled','','admin>dashboard','[\"Admin\",\"Other\"]',''),(4,'System','data','Data','fa-database','admin',8,'Enabled','','admin>data','[\"Admin\"]',''),(5,'Employees','employees','Employees','fa-users','admin',1,'Enabled','','admin>employees','[\"Admin\",\"Manager\"]',''),(6,'Admin','fieldnames','Employee Custom Fields','fa-ruler-horizontal','admin',83,'Disabled','','admin>fieldnames','[\"Admin\"]','[]'),(7,'Admin','jobs','Job Details Setup','fa-columns','admin',3,'Enabled','','admin>jobs','[\"Admin\"]',''),(8,'Admin','loans','Company Loans','fa-money-check','admin',89,'Disabled','','admin>loans','[\"Admin\"]',''),(9,'System','metadata','Manage Metadata','fa-microchip','admin',6,'Disabled','','admin>metadata','[\"Admin\"]','[]'),(10,'System','modules','Manage Modules','fa-folder-open','admin',3,'Enabled','','admin>modules','[\"Admin\"]',''),(11,'Admin','overtime','Overtime Administration','fa-align-center','admin',82,'Disabled','','admin>overtime','[\"Admin\",\"Manager\"]','[]'),(12,'Payroll','payroll','Payroll Reports','fa-cogs','admin',6,'Disabled','','admin>payroll','[\"Admin\"]',''),(13,'System','permissions','Manage Permissions','fa-unlock','admin',4,'Enabled','','admin>permissions','[\"Admin\"]','[]'),(14,'Admin','projects','Projects/Client Setup','fa-list-alt','admin',51,'Disabled','','admin>projects','[\"Admin\",\"Manager\"]','[]'),(15,'Admin','qualifications','Qualifications Setup','fa-check-square','admin',4,'Disabled','','admin>qualifications','[\"Admin\",\"Manager\"]','[]'),(16,'Admin Reports','reports','Reports','fa-window-maximize','admin',1,'Disabled','','admin>reports','[\"Admin\",\"Manager\"]','[]'),(17,'Payroll','salary','Salary','fa-money-check-alt','admin',1,'Enabled','','admin>salary','[\"Admin\"]','[]'),(18,'System','settings','Settings','fa-cogs','admin',1,'Enabled','','admin>settings','[\"Admin\"]',''),(19,'Employees','travel','Travel Requests','fa-plane','admin',6,'Disabled','','admin>travel','[\"Admin\",\"Manager\"]',''),(20,'System','users','Users','fa-user','admin',2,'Enabled','','admin>users','[\"Admin\"]',''),(21,'Time Management','attendance','Attendance','fa-clock','user',2,'Disabled','','modules>attendance','[\"Admin\",\"Manager\",\"Employee\"]','[]'),(22,'Personal Information','dashboard','Dashboard','fa-desktop','user',1,'Enabled','','modules>dashboard','[\"Admin\",\"Manager\",\"Employee\"]',''),(23,'Personal Information','dependents','Dependents','fa-expand','user',5,'Disabled','','modules>dependents','[\"Admin\",\"Manager\",\"Employee\"]','[]'),(24,'Personal Information','emergency_contact','Emergency Contacts','fa-phone-square','user',6,'Disabled','','modules>emergency_contact','[\"Admin\",\"Manager\"]','[]'),(25,'Personal Information','employees','Basic Information','fa-user','user',2,'Enabled','','modules>employees','[\"Admin\",\"Manager\",\"Employee\"]',''),(26,'Finance','loans','Loans','fa-money-check','user',3,'Disabled','','modules>loans','[\"Admin\",\"Manager\",\"Employee\"]',''),(27,'Time Management','overtime','Overtime Requests','fa-calendar-plus','user',5,'Disabled','','modules>overtime','[\"Admin\",\"Manager\"]','[]'),(28,'Time Management','projects','Projects','fa-project-diagram','user',1,'Disabled','','modules>projects','[\"Admin\",\"Manager\"]','[]'),(29,'Personal Information','qualifications','Qualifications','fa-graduation-cap','user',3,'Disabled','','modules>qualifications','[\"Admin\",\"Manager\",\"Employee\"]','[]'),(30,'User Reports','reports','Reports','fa-window-maximize','user',1,'Disabled','','modules>reports','[\"Admin\",\"Manager\"]','[]'),(31,'Finance','salary','Salary','fa-calculator','user',2,'Disabled','','modules>salary','[\"Admin\",\"Manager\",\"Employee\"]',''),(32,'Company','staffdirectory','Staff Directory','fa-user','user',1,'Disabled','','modules>staffdirectory','[\"Admin\",\"Manager\",\"Employee\"]','[]'),(33,'Time Management','time_sheets','Time Sheets','fa-stopwatch','user',3,'Disabled','','modules>time_sheets','[\"Admin\",\"Manager\"]','[]'),(34,'Travel Management','travel','Travel','fa-plane','user',1,'Disabled','','modules>travel','[\"Admin\",\"Manager\",\"Employee\"]','');
/*!40000 ALTER TABLE `Modules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Nationality`
--

DROP TABLE IF EXISTS `Nationality`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Nationality` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=195 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Nationality`
--

LOCK TABLES `Nationality` WRITE;
/*!40000 ALTER TABLE `Nationality` DISABLE KEYS */;
INSERT INTO `Nationality` VALUES (1,'Viá»‡t Nam'),(2,'Albanian'),(3,'Algerian'),(4,'American'),(5,'Andorran'),(6,'Angolan'),(7,'Antiguans'),(8,'Argentinean'),(9,'Armenian'),(10,'Australian'),(11,'Austrian'),(12,'Azerbaijani'),(13,'Bahamian'),(14,'Bahraini'),(15,'Bangladeshi'),(16,'Barbadian'),(17,'Barbudans'),(18,'Batswana'),(19,'Belarusian'),(20,'Belgian'),(21,'Belizean'),(22,'Beninese'),(23,'Bhutanese'),(24,'Bolivian'),(25,'Bosnian'),(26,'Brazilian'),(27,'British'),(28,'Bruneian'),(29,'Bulgarian'),(30,'Burkinabe'),(31,'Burmese'),(32,'Burundian'),(33,'Cambodian'),(34,'Cameroonian'),(35,'Canadian'),(36,'Cape Verdean'),(37,'Central African'),(38,'Chadian'),(39,'Chilean'),(40,'Chinese'),(41,'Colombian'),(42,'Comoran'),(43,'Congolese'),(44,'Costa Rican'),(45,'Croatian'),(46,'Cuban'),(47,'Cypriot'),(48,'Czech'),(49,'Danish'),(50,'Djibouti'),(51,'Dominican'),(52,'Dutch'),(53,'East Timorese'),(54,'Ecuadorean'),(55,'Egyptian'),(56,'Emirian'),(57,'Equatorial Guinean'),(58,'Eritrean'),(59,'Estonian'),(60,'Ethiopian'),(61,'Fijian'),(62,'Filipino'),(63,'Finnish'),(64,'French'),(65,'Gabonese'),(66,'Gambian'),(67,'Georgian'),(68,'German'),(69,'Ghanaian'),(70,'Greek'),(71,'Grenadian'),(72,'Guatemalan'),(73,'Guinea-Bissauan'),(74,'Guinean'),(75,'Guyanese'),(76,'Haitian'),(77,'Herzegovinian'),(78,'Honduran'),(79,'Hungarian'),(80,'I-Kiribati'),(81,'Icelander'),(82,'Indian'),(83,'Indonesian'),(84,'Iranian'),(85,'Iraqi'),(86,'Irish'),(87,'Israeli'),(88,'Italian'),(89,'Ivorian'),(90,'Jamaican'),(91,'Japanese'),(92,'Jordanian'),(93,'Kazakhstani'),(94,'Kenyan'),(95,'Kittian and Nevisian'),(96,'Kuwaiti'),(97,'Kyrgyz'),(98,'Laotian'),(99,'Latvian'),(100,'Lebanese'),(101,'Liberian'),(102,'Libyan'),(103,'Liechtensteiner'),(104,'Lithuanian'),(105,'Luxembourger'),(106,'Macedonian'),(107,'Malagasy'),(108,'Malawian'),(109,'Malaysian'),(110,'Maldivan'),(111,'Malian'),(112,'Maltese'),(113,'Marshallese'),(114,'Mauritanian'),(115,'Mauritian'),(116,'Mexican'),(117,'Micronesian'),(118,'Moldovan'),(119,'Monacan'),(120,'Mongolian'),(121,'Moroccan'),(122,'Mosotho'),(123,'Motswana'),(124,'Mozambican'),(125,'Namibian'),(126,'Nauruan'),(127,'Nepalese'),(128,'New Zealander'),(129,'Nicaraguan'),(130,'Nigerian'),(131,'Nigerien'),(132,'North Korean'),(133,'Northern Irish'),(134,'Norwegian'),(135,'Omani'),(136,'Pakistani'),(137,'Palauan'),(138,'Panamanian'),(139,'Papua New Guinean'),(140,'Paraguayan'),(141,'Peruvian'),(142,'Polish'),(143,'Portuguese'),(144,'Qatari'),(145,'Romanian'),(146,'Russian'),(147,'Rwandan'),(148,'Saint Lucian'),(149,'Salvadoran'),(150,'Samoan'),(151,'San Marinese'),(152,'Sao Tomean'),(153,'Saudi'),(154,'Scottish'),(155,'Senegalese'),(156,'Serbian'),(157,'Seychellois'),(158,'Sierra Leonean'),(159,'Singaporean'),(160,'Slovakian'),(161,'Slovenian'),(162,'Solomon Islander'),(163,'Somali'),(164,'South African'),(165,'South Korean'),(166,'Spanish'),(167,'Sri Lankan'),(168,'Sudanese'),(169,'Surinamer'),(170,'Swazi'),(171,'Swedish'),(172,'Swiss'),(173,'Syrian'),(174,'Taiwanese'),(175,'Tajik'),(176,'Tanzanian'),(177,'Thai'),(178,'Togolese'),(179,'Tongan'),(180,'Trinidadian or Tobagonian'),(181,'Tunisian'),(182,'Turkish'),(183,'Tuvaluan'),(184,'Ugandan'),(185,'Ukrainian'),(186,'Uruguayan'),(187,'Uzbekistani'),(188,'Venezuelan'),(189,'Afghan'),(190,'Welsh'),(191,'Yemenite'),(192,'Zambian'),(193,'Zimbabwean'),(194,'');
/*!40000 ALTER TABLE `Nationality` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Notifications`
--

DROP TABLE IF EXISTS `Notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Notifications` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `time` datetime DEFAULT NULL,
  `fromUser` bigint(20) DEFAULT NULL,
  `fromEmployee` bigint(20) DEFAULT NULL,
  `toUser` bigint(20) NOT NULL,
  `image` varchar(500) DEFAULT NULL,
  `message` text,
  `action` text,
  `type` varchar(100) DEFAULT NULL,
  `status` enum('Unread','Read') DEFAULT 'Unread',
  `employee` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `toUser_time` (`toUser`,`time`),
  KEY `toUser_status_time` (`toUser`,`status`,`time`),
  CONSTRAINT `Fk_Notifications_Users` FOREIGN KEY (`toUser`) REFERENCES `Users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Notifications`
--

LOCK TABLES `Notifications` WRITE;
/*!40000 ALTER TABLE `Notifications` DISABLE KEYS */;
/*!40000 ALTER TABLE `Notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `OvertimeCategories`
--

DROP TABLE IF EXISTS `OvertimeCategories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `OvertimeCategories` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(500) NOT NULL,
  `created` datetime DEFAULT NULL,
  `updated` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `OvertimeCategories`
--

LOCK TABLES `OvertimeCategories` WRITE;
/*!40000 ALTER TABLE `OvertimeCategories` DISABLE KEYS */;
/*!40000 ALTER TABLE `OvertimeCategories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PayFrequency`
--

DROP TABLE IF EXISTS `PayFrequency`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PayFrequency` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PayFrequency`
--

LOCK TABLES `PayFrequency` WRITE;
/*!40000 ALTER TABLE `PayFrequency` DISABLE KEYS */;
INSERT INTO `PayFrequency` VALUES (1,'Bi Weekly'),(2,'Weekly'),(3,'Semi Monthly'),(4,'Monthly'),(5,'Yearly');
/*!40000 ALTER TABLE `PayFrequency` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PayGrades`
--

DROP TABLE IF EXISTS `PayGrades`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PayGrades` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `currency` varchar(3) NOT NULL,
  `min_salary` decimal(12,2) DEFAULT '0.00',
  `max_salary` decimal(12,2) DEFAULT '0.00',
  PRIMARY KEY (`id`),
  KEY `Fk_PayGrades_CurrencyTypes` (`currency`),
  CONSTRAINT `Fk_PayGrades_CurrencyTypes` FOREIGN KEY (`currency`) REFERENCES `CurrencyTypes` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PayGrades`
--

LOCK TABLES `PayGrades` WRITE;
/*!40000 ALTER TABLE `PayGrades` DISABLE KEYS */;
INSERT INTO `PayGrades` VALUES (1,'Manager','SGD',5000.00,15000.00),(2,'Executive','SGD',3500.00,7000.00),(3,'Assistant ','SGD',2000.00,4000.00),(4,'Administrator','SGD',2000.00,6000.00);
/*!40000 ALTER TABLE `PayGrades` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Payroll`
--

DROP TABLE IF EXISTS `Payroll`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Payroll` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) DEFAULT NULL,
  `pay_period` bigint(20) NOT NULL,
  `department` bigint(20) NOT NULL,
  `column_template` bigint(20) DEFAULT NULL,
  `columns` varchar(500) DEFAULT NULL,
  `date_start` date DEFAULT NULL,
  `date_end` date DEFAULT NULL,
  `status` enum('Draft','Completed','Processing') DEFAULT 'Draft',
  `payslipTemplate` bigint(20) DEFAULT NULL,
  `deduction_group` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Payroll`
--

LOCK TABLES `Payroll` WRITE;
/*!40000 ALTER TABLE `Payroll` DISABLE KEYS */;
/*!40000 ALTER TABLE `Payroll` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PayrollColumnTemplates`
--

DROP TABLE IF EXISTS `PayrollColumnTemplates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PayrollColumnTemplates` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `columns` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PayrollColumnTemplates`
--

LOCK TABLES `PayrollColumnTemplates` WRITE;
/*!40000 ALTER TABLE `PayrollColumnTemplates` DISABLE KEYS */;
/*!40000 ALTER TABLE `PayrollColumnTemplates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PayrollColumns`
--

DROP TABLE IF EXISTS `PayrollColumns`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PayrollColumns` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `calculation_hook` varchar(200) DEFAULT NULL,
  `salary_components` varchar(500) DEFAULT NULL,
  `deductions` varchar(500) DEFAULT NULL,
  `add_columns` varchar(500) DEFAULT NULL,
  `sub_columns` varchar(500) DEFAULT NULL,
  `colorder` int(11) DEFAULT NULL,
  `editable` enum('Yes','No') DEFAULT 'Yes',
  `enabled` enum('Yes','No') DEFAULT 'Yes',
  `default_value` varchar(25) DEFAULT NULL,
  `calculation_columns` varchar(500) DEFAULT NULL,
  `calculation_function` varchar(100) DEFAULT NULL,
  `deduction_group` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PayrollColumns`
--

LOCK TABLES `PayrollColumns` WRITE;
/*!40000 ALTER TABLE `PayrollColumns` DISABLE KEYS */;
/*!40000 ALTER TABLE `PayrollColumns` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PayrollData`
--

DROP TABLE IF EXISTS `PayrollData`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PayrollData` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `payroll` bigint(20) NOT NULL,
  `employee` bigint(20) NOT NULL,
  `payroll_item` int(11) NOT NULL,
  `amount` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `PayrollDataUniqueKey` (`payroll`,`employee`,`payroll_item`),
  CONSTRAINT `Fk_PayrollData_Payroll` FOREIGN KEY (`payroll`) REFERENCES `Payroll` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PayrollData`
--

LOCK TABLES `PayrollData` WRITE;
/*!40000 ALTER TABLE `PayrollData` DISABLE KEYS */;
/*!40000 ALTER TABLE `PayrollData` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PayrollEmployees`
--

DROP TABLE IF EXISTS `PayrollEmployees`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PayrollEmployees` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `employee` bigint(20) NOT NULL,
  `pay_frequency` int(11) DEFAULT NULL,
  `currency` bigint(20) DEFAULT NULL,
  `deduction_exemptions` varchar(250) DEFAULT NULL,
  `deduction_allowed` varchar(250) DEFAULT NULL,
  `deduction_group` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `PayrollEmployees_employee` (`employee`),
  KEY `Fk_PayrollEmployees_DeductionGroup` (`deduction_group`),
  CONSTRAINT `Fk_PayrollEmployees_DeductionGroup` FOREIGN KEY (`deduction_group`) REFERENCES `DeductionGroup` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `Fk_PayrollEmployee_Employee` FOREIGN KEY (`employee`) REFERENCES `Employees` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PayrollEmployees`
--

LOCK TABLES `PayrollEmployees` WRITE;
/*!40000 ALTER TABLE `PayrollEmployees` DISABLE KEYS */;
/*!40000 ALTER TABLE `PayrollEmployees` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PayslipTemplates`
--

DROP TABLE IF EXISTS `PayslipTemplates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PayslipTemplates` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `data` longtext,
  `status` enum('Show','Hide') DEFAULT 'Show',
  `created` datetime DEFAULT NULL,
  `updated` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PayslipTemplates`
--

LOCK TABLES `PayslipTemplates` WRITE;
/*!40000 ALTER TABLE `PayslipTemplates` DISABLE KEYS */;
/*!40000 ALTER TABLE `PayslipTemplates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PerformanceReviews`
--

DROP TABLE IF EXISTS `PerformanceReviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PerformanceReviews` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  `employee` bigint(20) DEFAULT NULL,
  `coordinator` bigint(20) DEFAULT NULL,
  `attendees` varchar(50) NOT NULL,
  `form` bigint(20) DEFAULT NULL,
  `status` varchar(20) NOT NULL,
  `review_date` datetime DEFAULT NULL,
  `review_period_start` datetime DEFAULT NULL,
  `review_period_end` datetime DEFAULT NULL,
  `self_assessment_due` datetime DEFAULT NULL,
  `notes` text,
  `created` datetime DEFAULT NULL,
  `updated` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `Fk_PerformanceReviews_ReviewTemplates` (`form`),
  KEY `Fk_PerformanceReviews_Employees1` (`employee`),
  KEY `Fk_PerformanceReviews_Employees2` (`coordinator`),
  CONSTRAINT `Fk_PerformanceReviews_Employees1` FOREIGN KEY (`employee`) REFERENCES `Employees` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `Fk_PerformanceReviews_Employees2` FOREIGN KEY (`coordinator`) REFERENCES `Employees` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `Fk_PerformanceReviews_ReviewTemplates` FOREIGN KEY (`form`) REFERENCES `ReviewTemplates` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PerformanceReviews`
--

LOCK TABLES `PerformanceReviews` WRITE;
/*!40000 ALTER TABLE `PerformanceReviews` DISABLE KEYS */;
/*!40000 ALTER TABLE `PerformanceReviews` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Permissions`
--

DROP TABLE IF EXISTS `Permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Permissions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_level` enum('Admin','Employee','Manager') DEFAULT NULL,
  `module_id` bigint(20) NOT NULL,
  `permission` varchar(200) DEFAULT NULL,
  `meta` varchar(500) DEFAULT NULL,
  `value` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `Module_Permission` (`user_level`,`module_id`,`permission`)
) ENGINE=InnoDB AUTO_INCREMENT=74 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Permissions`
--

LOCK TABLES `Permissions` WRITE;
/*!40000 ALTER TABLE `Permissions` DISABLE KEYS */;
INSERT INTO `Permissions` VALUES (1,'Manager',2,'Add Company Structure','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"Yes\",\"Yes\"],[\"No\",\"No\"]]}]','No'),(2,'Manager',2,'Edit Company Structure','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"Yes\",\"Yes\"],[\"No\",\"No\"]]}]','No'),(3,'Manager',2,'Delete Company Structure','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"Yes\",\"Yes\"],[\"No\",\"No\"]]}]','No'),(4,'Manager',14,'Add Projects','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"Yes\",\"Yes\"],[\"No\",\"No\"]]}]','No'),(5,'Manager',14,'Edit Projects','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"Yes\",\"Yes\"],[\"No\",\"No\"]]}]','No'),(6,'Manager',14,'Delete Projects','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"Yes\",\"Yes\"],[\"No\",\"No\"]]}]','No'),(7,'Manager',14,'Add Clients','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"Yes\",\"Yes\"],[\"No\",\"No\"]]}]','No'),(8,'Manager',14,'Edit Clients','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"Yes\",\"Yes\"],[\"No\",\"No\"]]}]','No'),(9,'Manager',14,'Delete Clients','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"Yes\",\"Yes\"],[\"No\",\"No\"]]}]','No'),(10,'Manager',15,'Add Skills','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"Yes\",\"Yes\"],[\"No\",\"No\"]]}]','No'),(11,'Manager',15,'Edit Skills','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"Yes\",\"Yes\"],[\"No\",\"No\"]]}]','No'),(12,'Manager',15,'Delete Skills','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"Yes\",\"Yes\"],[\"No\",\"No\"]]}]','No'),(13,'Manager',15,'Add Education','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"Yes\",\"Yes\"],[\"No\",\"No\"]]}]','No'),(14,'Manager',15,'Edit Education','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"Yes\",\"Yes\"],[\"No\",\"No\"]]}]','No'),(15,'Manager',15,'Delete Education','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"Yes\",\"Yes\"],[\"No\",\"No\"]]}]','No'),(16,'Manager',15,'Add Certifications','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"Yes\",\"Yes\"],[\"No\",\"No\"]]}]','No'),(17,'Manager',15,'Edit Certifications','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"Yes\",\"Yes\"],[\"No\",\"No\"]]}]','No'),(18,'Manager',15,'Delete Certifications','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"Yes\",\"Yes\"],[\"No\",\"No\"]]}]','No'),(19,'Manager',15,'Add Languages','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"Yes\",\"Yes\"],[\"No\",\"No\"]]}]','No'),(20,'Manager',15,'Edit Languages','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"Yes\",\"Yes\"],[\"No\",\"No\"]]}]','No'),(21,'Manager',15,'Delete Languages','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"Yes\",\"Yes\"],[\"No\",\"No\"]]}]','No'),(22,'Manager',23,'Add Dependents','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"Yes\",\"Yes\"],[\"No\",\"No\"]]}]','No'),(23,'Manager',23,'Edit Dependents','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"Yes\",\"Yes\"],[\"No\",\"No\"]]}]','No'),(24,'Manager',23,'Delete Dependents','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"Yes\",\"Yes\"],[\"No\",\"No\"]]}]','No'),(25,'Employee',23,'Add Dependents','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"Yes\",\"Yes\"],[\"No\",\"No\"]]}]','No'),(26,'Employee',23,'Edit Dependents','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"Yes\",\"Yes\"],[\"No\",\"No\"]]}]','No'),(27,'Employee',23,'Delete Dependents','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"Yes\",\"Yes\"],[\"No\",\"No\"]]}]','No'),(28,'Manager',24,'Add Emergency Contacts','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"Yes\",\"Yes\"],[\"No\",\"No\"]]}]','No'),(29,'Manager',24,'Edit Emergency Contacts','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"Yes\",\"Yes\"],[\"No\",\"No\"]]}]','No'),(30,'Manager',24,'Delete Emergency Contacts','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"Yes\",\"Yes\"],[\"No\",\"No\"]]}]','No'),(31,'Employee',24,'Add Emergency Contacts','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"Yes\",\"Yes\"],[\"No\",\"No\"]]}]','No'),(32,'Employee',24,'Edit Emergency Contacts','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"Yes\",\"Yes\"],[\"No\",\"No\"]]}]','No'),(33,'Employee',24,'Delete Emergency Contacts','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"Yes\",\"Yes\"],[\"No\",\"No\"]]}]','No'),(34,'Manager',25,'Edit Employee Number','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"Yes\",\"Yes\"],[\"No\",\"No\"]]}]','No'),(35,'Manager',25,'Edit EPF/CPF Number','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"Yes\",\"Yes\"],[\"No\",\"No\"]]}]','No'),(36,'Manager',25,'Edit Employment Status','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"Yes\",\"Yes\"],[\"No\",\"No\"]]}]','No'),(37,'Manager',25,'Edit Job Title','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"Yes\",\"Yes\"],[\"No\",\"No\"]]}]','No'),(38,'Manager',25,'Edit Pay Grade','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"Yes\",\"Yes\"],[\"No\",\"No\"]]}]','No'),(39,'Manager',25,'Edit Joined Date','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"Yes\",\"Yes\"],[\"No\",\"No\"]]}]','No'),(40,'Manager',25,'Edit Department','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"Yes\",\"Yes\"],[\"No\",\"No\"]]}]','Yes'),(41,'Manager',25,'Edit Work Email','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"Yes\",\"Yes\"],[\"No\",\"No\"]]}]','No'),(42,'Manager',25,'Edit Country','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"Yes\",\"Yes\"],[\"No\",\"No\"]]}]','Yes'),(43,'Manager',25,'Upload/Delete Profile Image','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"Yes\",\"Yes\"],[\"No\",\"No\"]]}]','Yes'),(44,'Manager',25,'Edit Employee Details','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"Yes\",\"Yes\"],[\"No\",\"No\"]]}]','Yes'),(45,'Employee',25,'Edit Employee Number','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"Yes\",\"Yes\"],[\"No\",\"No\"]]}]','No'),(46,'Employee',25,'Edit EPF/CPF Number','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"Yes\",\"Yes\"],[\"No\",\"No\"]]}]','Yes'),(47,'Employee',25,'Edit Employment Status','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"Yes\",\"Yes\"],[\"No\",\"No\"]]}]','No'),(48,'Employee',25,'Edit Job Title','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"Yes\",\"Yes\"],[\"No\",\"No\"]]}]','No'),(49,'Employee',25,'Edit Pay Grade','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"Yes\",\"Yes\"],[\"No\",\"No\"]]}]','No'),(50,'Employee',25,'Edit Joined Date','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"Yes\",\"Yes\"],[\"No\",\"No\"]]}]','No'),(51,'Employee',25,'Edit Department','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"Yes\",\"Yes\"],[\"No\",\"No\"]]}]','No'),(52,'Employee',25,'Edit Work Email','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"Yes\",\"Yes\"],[\"No\",\"No\"]]}]','No'),(53,'Employee',25,'Edit Country','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"Yes\",\"Yes\"],[\"No\",\"No\"]]}]','No'),(54,'Employee',25,'Upload/Delete Profile Image','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"Yes\",\"Yes\"],[\"No\",\"No\"]]}]','Yes'),(55,'Employee',25,'Edit Employee Details','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"Yes\",\"Yes\"],[\"No\",\"No\"]]}]','Yes'),(56,'Manager',28,'Add Projects','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"Yes\",\"Yes\"],[\"No\",\"No\"]]}]','Yes'),(57,'Manager',28,'Edit Projects','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"Yes\",\"Yes\"],[\"No\",\"No\"]]}]','Yes'),(58,'Manager',28,'Delete Projects','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"Yes\",\"Yes\"],[\"No\",\"No\"]]}]','Yes'),(59,'Employee',28,'Add Projects','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"Yes\",\"Yes\"],[\"No\",\"No\"]]}]','No'),(60,'Employee',28,'Edit Projects','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"Yes\",\"Yes\"],[\"No\",\"No\"]]}]','No'),(61,'Employee',28,'Delete Projects','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"Yes\",\"Yes\"],[\"No\",\"No\"]]}]','No'),(62,'Manager',31,'Add Salary','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"Yes\",\"Yes\"],[\"No\",\"No\"]]}]','No'),(63,'Manager',31,'Edit Salary','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"Yes\",\"Yes\"],[\"No\",\"No\"]]}]','No'),(64,'Manager',31,'Delete Salary','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"Yes\",\"Yes\"],[\"No\",\"No\"]]}]','No'),(65,'Employee',31,'Add Salary','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"Yes\",\"Yes\"],[\"No\",\"No\"]]}]','No'),(66,'Employee',31,'Edit Salary','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"Yes\",\"Yes\"],[\"No\",\"No\"]]}]','No'),(67,'Employee',31,'Delete Salary','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"Yes\",\"Yes\"],[\"No\",\"No\"]]}]','No'),(68,'Manager',34,'Add Travel Request','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"Yes\",\"Yes\"],[\"No\",\"No\"]]}]','No'),(69,'Manager',34,'Edit Travel Request','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"Yes\",\"Yes\"],[\"No\",\"No\"]]}]','Yes'),(70,'Manager',34,'Delete Travel Request','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"Yes\",\"Yes\"],[\"No\",\"No\"]]}]','Yes'),(71,'Employee',34,'Add Travel Request','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"Yes\",\"Yes\"],[\"No\",\"No\"]]}]','Yes'),(72,'Employee',34,'Edit Travel Request','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"Yes\",\"Yes\"],[\"No\",\"No\"]]}]','Yes'),(73,'Employee',34,'Delete Travel Request','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"Yes\",\"Yes\"],[\"No\",\"No\"]]}]','Yes');
/*!40000 ALTER TABLE `Permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Projects`
--

DROP TABLE IF EXISTS `Projects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Projects` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `client` bigint(20) DEFAULT NULL,
  `details` text,
  `created` datetime DEFAULT NULL,
  `status` enum('Active','On Hold','Completed','Dropped') DEFAULT 'Active',
  PRIMARY KEY (`id`),
  KEY `Fk_Projects_Client` (`client`),
  CONSTRAINT `Fk_Projects_Client` FOREIGN KEY (`client`) REFERENCES `Clients` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Projects`
--

LOCK TABLES `Projects` WRITE;
/*!40000 ALTER TABLE `Projects` DISABLE KEYS */;
INSERT INTO `Projects` VALUES (1,'Project 1',3,NULL,'2013-01-03 05:53:38','Active'),(2,'Project 2',3,NULL,'2013-01-03 05:54:22','Active'),(3,'Project 3',1,NULL,'2013-01-03 05:55:02','Active'),(4,'Project 4',2,NULL,'2013-01-03 05:56:16','Active');
/*!40000 ALTER TABLE `Projects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Province`
--

DROP TABLE IF EXISTS `Province`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Province` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(40) NOT NULL DEFAULT '',
  `code` char(2) NOT NULL DEFAULT '',
  `country` char(2) NOT NULL DEFAULT 'US',
  PRIMARY KEY (`id`),
  KEY `Fk_Province_Country` (`country`),
  CONSTRAINT `Fk_Province_Country` FOREIGN KEY (`country`) REFERENCES `Country` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=66 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Province`
--

LOCK TABLES `Province` WRITE;
/*!40000 ALTER TABLE `Province` DISABLE KEYS */;
INSERT INTO `Province` VALUES (1,'Alaska','AK','US'),(2,'Alabama','AL','US'),(3,'American Samoa','AS','US'),(4,'Arizona','AZ','US'),(5,'Arkansas','AR','US'),(6,'California','CA','US'),(7,'Colorado','CO','US'),(8,'Connecticut','CT','US'),(9,'Delaware','DE','US'),(10,'District of Columbia','DC','US'),(11,'Federated States of Micronesia','FM','US'),(12,'Florida','FL','US'),(13,'Georgia','GA','US'),(14,'Guam','GU','US'),(15,'Hawaii','HI','US'),(16,'Idaho','ID','US'),(17,'Illinois','IL','US'),(18,'Indiana','IN','US'),(19,'Iowa','IA','US'),(20,'Kansas','KS','US'),(21,'Kentucky','KY','US'),(22,'Louisiana','LA','US'),(23,'Maine','ME','US'),(24,'Marshall Islands','MH','US'),(25,'Maryland','MD','US'),(26,'Massachusetts','MA','US'),(27,'Michigan','MI','US'),(28,'Minnesota','MN','US'),(29,'Mississippi','MS','US'),(30,'Missouri','MO','US'),(31,'Montana','MT','US'),(32,'Nebraska','NE','US'),(33,'Nevada','NV','US'),(34,'New Hampshire','NH','US'),(35,'New Jersey','NJ','US'),(36,'New Mexico','NM','US'),(37,'New York','NY','US'),(38,'North Carolina','NC','US'),(39,'North Dakota','ND','US'),(40,'Northern Mariana Islands','MP','US'),(41,'Ohio','OH','US'),(42,'Oklahoma','OK','US'),(43,'Oregon','OR','US'),(44,'Palau','PW','US'),(45,'Pennsylvania','PA','US'),(46,'Puerto Rico','PR','US'),(47,'Rhode Island','RI','US'),(48,'South Carolina','SC','US'),(49,'South Dakota','SD','US'),(50,'Tennessee','TN','US'),(51,'Texas','TX','US'),(52,'Utah','UT','US'),(53,'Vermont','VT','US'),(54,'Virgin Islands','VI','US'),(55,'Virginia','VA','US'),(56,'Washington','WA','US'),(57,'West Virginia','WV','US'),(58,'Wisconsin','WI','US'),(59,'Wyoming','WY','US'),(60,'Armed Forces Africa','AE','US'),(61,'Armed Forces Americas (except Canada)','AA','US'),(62,'Armed Forces Canada','AE','US'),(63,'Armed Forces Europe','AE','US'),(64,'Armed Forces Middle East','AE','US'),(65,'Armed Forces Pacific','AP','US');
/*!40000 ALTER TABLE `Province` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ReportFiles`
--

DROP TABLE IF EXISTS `ReportFiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ReportFiles` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `employee` bigint(20) DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `attachment` varchar(100) NOT NULL,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ReportFiles_attachment` (`attachment`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ReportFiles`
--

LOCK TABLES `ReportFiles` WRITE;
/*!40000 ALTER TABLE `ReportFiles` DISABLE KEYS */;
/*!40000 ALTER TABLE `ReportFiles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Reports`
--

DROP TABLE IF EXISTS `Reports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Reports` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `details` text,
  `parameters` text,
  `query` text,
  `paramOrder` varchar(500) NOT NULL,
  `type` enum('Query','Class') DEFAULT 'Query',
  `report_group` varchar(500) DEFAULT NULL,
  `output` varchar(15) NOT NULL DEFAULT 'CSV',
  PRIMARY KEY (`id`),
  UNIQUE KEY `Reports_Name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Reports`
--

LOCK TABLES `Reports` WRITE;
/*!40000 ALTER TABLE `Reports` DISABLE KEYS */;
INSERT INTO `Reports` VALUES (1,'Employee Details Report','This report list all employee details and you can filter employees by department, employment status or job title','[[\"department\", {\"label\":\"Department\",\"type\":\"select2\",\"remote-source\":[\"CompanyStructure\",\"id\",\"title\"],\"allow-null\":true}],[\"employment_status\", {\"label\":\"Employment Status\",\"type\":\"select2\",\"remote-source\":[\"EmploymentStatus\",\"id\",\"name\"],\"allow-null\":true}],[\"job_title\", {\"label\":\"Job Title\",\"type\":\"select2\",\"remote-source\":[\"JobTitle\",\"id\",\"name\"],\"allow-null\":true}]]','EmployeeDetailsReport','[\"department\",\"employment_status\",\"job_title\"]','Class','Employee Information','CSV'),(2,'Employee Attendance Report','This report list all employee attendance entries by employee and date range','[\r\n[ \"employee\", {\"label\":\"Employee\",\"type\":\"select2multi\",\"allow-null\":true,\"null-label\":\"All Employees\",\"remote-source\":[\"Employee\",\"id\",\"first_name+last_name\"]}],\r\n[ \"date_start\", {\"label\":\"Start Date\",\"type\":\"date\"}],\r\n[ \"date_end\", {\"label\":\"End Date\",\"type\":\"date\"}]\r\n]','EmployeeAttendanceReport','[\"employee\",\"date_start\",\"date_end\"]','Class','Time Management','CSV'),(3,'Employee Time Tracking Report','This report list employee working hours and attendance details for each day for a given period ','[\r\n[ \"employee\", {\"label\":\"Employee\",\"type\":\"select2\",\"allow-null\":false,\"remote-source\":[\"Employee\",\"id\",\"first_name+last_name\"]}],\r\n[ \"date_start\", {\"label\":\"Start Date\",\"type\":\"date\"}],\r\n[ \"date_end\", {\"label\":\"End Date\",\"type\":\"date\"}]\r\n]','EmployeeTimeTrackReport','[\"employee\",\"date_start\",\"date_end\"]','Class','Time Management','CSV'),(4,'Employee Time Entry Report','View employee time entries by date range and project','[\r\n[ \"employee\", {\"label\":\"Employee\",\"type\":\"select2multi\",\"allow-null\":true,\"null-label\":\"All Employees\",\"remote-source\":[\"Employee\",\"id\",\"first_name+last_name\"]}],\r\n[ \"client\", {\"label\":\"Select Client\",\"type\":\"select\",\"allow-null\":true,\"null-label\":\"Not Selected\",\"remote-source\":[\"Client\",\"id\",\"name\"]}],\r\n[ \"project\", {\"label\":\"Or Project\",\"type\":\"select\",\"allow-null\":true,\"null-label\":\"All Projects\",\"remote-source\":[\"Project\",\"id\",\"name\",\"getAllProjects\"]}],\r\n[ \"date_start\", {\"label\":\"Start Date\",\"type\":\"date\"}],\r\n[ \"date_end\", {\"label\":\"End Date\",\"type\":\"date\"}]\r\n]','EmployeeTimesheetReport','[\"employee\",\"client\",\"project\",\"date_start\",\"date_end\",\"status\"]','Class','Time Management','CSV'),(5,'Active Employee Report','This report list employees who are currently active based on joined date and termination date ','[\r\n[ \"department\", {\"label\":\"Department\",\"type\":\"select2\",\"remote-source\":[\"CompanyStructure\",\"id\",\"title\"],\"allow-null\":true}]\r\n]','ActiveEmployeeReport','[\"department\"]','Class','Employee Information','CSV'),(6,'New Hires Employee Report','This report list employees who are joined between given two dates ','[[ \"department\", {\"label\":\"Department\",\"type\":\"select2\",\"remote-source\":[\"CompanyStructure\",\"id\",\"title\"],\"allow-null\":true}],\r\n[ \"date_start\", {\"label\":\"Start Date\",\"type\":\"date\"}],\r\n[ \"date_end\", {\"label\":\"End Date\",\"type\":\"date\"}]\r\n]','NewHiresEmployeeReport','[\"department\",\"date_start\",\"date_end\"]','Class','Employee Information','CSV'),(7,'Terminated Employee Report','This report list employees who are terminated between given two dates ','[[ \"department\", {\"label\":\"Department\",\"type\":\"select2\",\"remote-source\":[\"CompanyStructure\",\"id\",\"title\"],\"allow-null\":true}],\r\n[ \"date_start\", {\"label\":\"Start Date\",\"type\":\"date\"}],\r\n[ \"date_end\", {\"label\":\"End Date\",\"type\":\"date\"}]\r\n]','TerminatedEmployeeReport','[\"department\",\"date_start\",\"date_end\"]','Class','Employee Information','CSV'),(8,'Travel Request Report','This report list employees travel requests for a specified period','[\r\n[ \"employee\", {\"label\":\"Employee\",\"type\":\"select2multi\",\"allow-null\":true,\"null-label\":\"All Employees\",\"remote-source\":[\"Employee\",\"id\",\"first_name+last_name\"]}],\r\n[ \"date_start\", {\"label\":\"Start Date\",\"type\":\"date\"}],\r\n[ \"date_end\", {\"label\":\"End Date\",\"type\":\"date\"}],\r\n[ \"status\", {\"label\":\"Status\",\"type\":\"select\",\"source\":[[\"NULL\",\"All Statuses\"],[\"Approved\",\"Approved\"],[\"Pending\",\"Pending\"],[\"Rejected\",\"Rejected\"],[\"Cancellation Requested\",\"Cancellation Requested\"],[\"Cancelled\",\"Cancelled\"]]}]\r\n]','TravelRequestReport','[\"employee\",\"date_start\",\"date_end\",\"status\"]','Class','Travel and Expense Management','CSV'),(9,'Employee Time Sheet Report','This report list all employee time sheets by employee and date range','[\r\n[ \"employee\", {\"label\":\"Employee\",\"type\":\"select2multi\",\"allow-null\":true,\"null-label\":\"All Employees\",\"remote-source\":[\"Employee\",\"id\",\"first_name+last_name\"]}],\r\n[ \"date_start\", {\"label\":\"Start Date\",\"type\":\"date\"}],\r\n[ \"date_end\", {\"label\":\"End Date\",\"type\":\"date\"}],\r\n[ \"status\", {\"label\":\"Status\",\"allow-null\":true,\"null-label\":\"All Status\",\"type\":\"select\",\"source\":[[\"Approved\",\"Approved\"],[\"Pending\",\"Pending\"],[\"Rejected\",\"Rejected\"]]}]\r\n]','EmployeeTimeSheetData','[\"employee\",\"date_start\",\"date_end\",\"status\"]','Class','Time Management','CSV'),(10,'Employee Leave Entitlement','This report list employees leave entitlement for current leave period by department or by employee ','[[ \"department\", {\"label\":\"Department\",\"type\":\"select2\",\"remote-source\":[\"CompanyStructure\",\"id\",\"title\"],\"allow-null\":true, \"null-label\":\"All Departments\",\"validation\":\"none\"}],\r\n[ \"employee\", {\"label\":\"Employee\",\"type\":\"select2\",\"allow-null\":true, \"null-label\":\"All Employees\", \"validation\":\"none\",\"remote-source\":[\"Employee\",\"id\",\"first_name+last_name\"]}]]','EmployeeLeaveEntitlementReport','[\"department\",\"employee\"]','Class','Leave Management','CSV'),(11,'Payroll Meta Data Export','Export payroll module configurations','[\r\n[ \"deduction_group\", {\"label\":\"Calculation Group\",\"type\":\"select2\",\"allow-null\":false,\"remote-source\":[\"DeductionGroup\",\"id\",\"name\"]}],\r\n[ \"payroll\", {\"label\":\"Sample Payroll\",\"type\":\"select2\",\"allow-null\":false,\"remote-source\":[\"Payroll\",\"id\",\"name\"]}]]','PayrollDataExport','[\"deduction_group\",\"payroll\"]','Class','Payroll','JSON'),(12,'Company Asset Report','List company assets assigned to employees and departments','[[\"department\", {\"label\":\"Department\",\"type\":\"select2\",\"remote-source\":[\"CompanyStructure\",\"id\",\"title\"],\"allow-null\":true}],[\"type\", {\"label\":\"Asset Type\",\"type\":\"select2\",\"remote-source\":[\"AssetType\",\"id\",\"name\"],\"allow-null\":true}]]','AssetUsageReport','[\"department\",\"type\"]','Class','Resources','CSV');
/*!40000 ALTER TABLE `Reports` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `RestAccessTokens`
--

DROP TABLE IF EXISTS `RestAccessTokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `RestAccessTokens` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `userId` bigint(20) NOT NULL,
  `hash` varchar(32) DEFAULT NULL,
  `token` varchar(500) DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `updated` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `userId` (`userId`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `RestAccessTokens`
--

LOCK TABLES `RestAccessTokens` WRITE;
/*!40000 ALTER TABLE `RestAccessTokens` DISABLE KEYS */;
INSERT INTO `RestAccessTokens` VALUES (1,1,'550ef08ef5031e2229d0173339ecce21','zwH0b8hzP15iHZ2W4TtkzEL+v+MDSv3qxs0o39ituTMLTN9cnn0seCcDPH9IlWBaj9o6FpQKp/jtd2IBx6GSYamw1CIeyg==','2020-02-09 08:21:52','2020-02-09 08:21:52'),(2,2,'21c2361b87045918bf5edc8acb1c0810','QQK09tOJWF5AKjSbenZxZ+e/fIVDC/76ttO4OTw78FtXlYnuYClKs9FgD2xdSKko0qhzIfMepTxKoljUUYnH72Mvs3fNkg==','2020-02-28 09:02:35','2020-02-28 09:02:35'),(3,3,'819a3bcc9f35998c12a8f352326a581d','+gCSvt/FYV7bP4YbJ+is9Qf+R4Niszjg4zFCW7CQHWYYu1JsnLmL0LzrI8JLBfpoknajlbkHBeDCSA8ONURlX6XLFN+LGA==','2020-03-06 09:09:11','2020-03-06 09:09:11'),(4,9,'5603978f8d3e5415ee997e10d2b5c153','hgOgzwUYY15hULvVHuYOs6cqiufgXQc/U+71BgfCvHsCgBVm/IcSpw418pk3fmj7g2jJeT5nZmmRTJ8s5zQOTlzdluAFcA==','2020-03-07 09:11:57','2020-03-07 09:11:57'),(5,10,'d86a9c3274ace83b70593f83d7e8711f','ugFM/J25Y1560MIAtHM9KAXD10raI/HUzxkXD7lXJCe9cOxhd0GBRDpGyaJHtqS7pRX9Aw7lhEun4JNwpq+F5v/TAXPueSc=','2020-03-07 20:41:25','2020-03-07 20:41:25'),(6,4,'f8d7451b2edb3d3025f9a31c9fd77c5c','MwKiNKi3ZF6iYXS96acjRCPwb0UbOdaVD6qhYxJQQfivA0LQ9omoen9HSo0Csubfw+qtmGhCyY3pJ7QxFisow/i5iUosCg==','2020-03-08 09:26:56','2020-03-08 14:45:20'),(7,14,'857409fe36b72f9129dca0e95e2f3a0f','uwPuOiCLZF4O3X21b0mti2/f0gWirUvfmmsrBeXaocf/TgS0qqcB+P3Q6xiI0nCsmHxt2XBH/dad2wxR48aDIM7azGJ/DO0=','2020-03-08 11:26:40','2020-03-08 11:35:20'),(8,43,'92a5babe032e3f12b00254b52e40d424','egDNn1C3ZF47Y1MJ0dc5Qg6hMRBNDJC6BXQ8QK/QOGliSOSH1HFYCYhi5udNU6zSZcCszrPxkV5PSxT2OdkM2rcc8K7sYuI=','2020-03-08 14:43:52','2020-03-08 14:43:52'),(9,5,'db95a1258a97c840bfb762dd4fae5d79','vQJr0zGxZV7VxCkg1CrwIdfaBtbl+Z5DmxkvMotpytfngvwzC0v4O+hHwG5wvEEaqLl/MrqzSXZbDHMVJVOx1tIvevBpAA==','2020-03-09 08:30:01','2020-03-09 08:30:01'),(10,76,'cab95d0f8df24a537d032d94885e7674','RgBafqG0ZV5vz6OyfLyMwO7JwKWU/oB8pB3YYwpaaAHboio65ObN7QTg2GbGoU/cU4I7mOFq35TBSE9p45qsrrNld0/vAh4=','2020-03-09 08:44:41','2020-03-09 08:44:41');
/*!40000 ALTER TABLE `RestAccessTokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ReviewFeedbacks`
--

DROP TABLE IF EXISTS `ReviewFeedbacks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ReviewFeedbacks` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `employee` bigint(20) DEFAULT NULL,
  `review` bigint(20) DEFAULT NULL,
  `subject` bigint(20) DEFAULT NULL,
  `form` bigint(20) DEFAULT NULL,
  `status` varchar(20) NOT NULL,
  `dueon` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `updated` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `Fk_ReviewFeedbacks_ReviewTemplates` (`form`),
  KEY `Fk_ReviewFeedbacks_PerformanceReviews` (`review`),
  KEY `Fk_ReviewFeedbacks_Employees1` (`employee`),
  KEY `Fk_ReviewFeedbacks_Employees2` (`subject`),
  CONSTRAINT `Fk_ReviewFeedbacks_Employees1` FOREIGN KEY (`employee`) REFERENCES `Employees` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `Fk_ReviewFeedbacks_Employees2` FOREIGN KEY (`subject`) REFERENCES `Employees` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `Fk_ReviewFeedbacks_PerformanceReviews` FOREIGN KEY (`review`) REFERENCES `PerformanceReviews` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `Fk_ReviewFeedbacks_ReviewTemplates` FOREIGN KEY (`form`) REFERENCES `ReviewTemplates` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ReviewFeedbacks`
--

LOCK TABLES `ReviewFeedbacks` WRITE;
/*!40000 ALTER TABLE `ReviewFeedbacks` DISABLE KEYS */;
/*!40000 ALTER TABLE `ReviewFeedbacks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ReviewTemplates`
--

DROP TABLE IF EXISTS `ReviewTemplates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ReviewTemplates` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `description` varchar(500) DEFAULT NULL,
  `items` text,
  `created` datetime DEFAULT NULL,
  `updated` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ReviewTemplates`
--

LOCK TABLES `ReviewTemplates` WRITE;
/*!40000 ALTER TABLE `ReviewTemplates` DISABLE KEYS */;
/*!40000 ALTER TABLE `ReviewTemplates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SalaryComponent`
--

DROP TABLE IF EXISTS `SalaryComponent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SalaryComponent` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `componentType` bigint(20) DEFAULT NULL,
  `details` text,
  PRIMARY KEY (`id`),
  KEY `Fk_SalaryComponent_SalaryComponentType` (`componentType`),
  CONSTRAINT `Fk_SalaryComponent_SalaryComponentType` FOREIGN KEY (`componentType`) REFERENCES `SalaryComponentType` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SalaryComponent`
--

LOCK TABLES `SalaryComponent` WRITE;
/*!40000 ALTER TABLE `SalaryComponent` DISABLE KEYS */;
INSERT INTO `SalaryComponent` VALUES (1,'Basic Salary',1,NULL),(2,'Fixed Allowance',1,NULL),(3,'Car Allowance',2,NULL),(4,'Telephone Allowance',2,NULL),(5,'Regular Hourly Pay',3,NULL),(6,'Overtime Hourly Pay',3,NULL),(7,'Double Time Hourly Pay',3,NULL);
/*!40000 ALTER TABLE `SalaryComponent` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SalaryComponentType`
--

DROP TABLE IF EXISTS `SalaryComponentType`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SalaryComponentType` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `code` varchar(10) NOT NULL,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SalaryComponentType`
--

LOCK TABLES `SalaryComponentType` WRITE;
/*!40000 ALTER TABLE `SalaryComponentType` DISABLE KEYS */;
INSERT INTO `SalaryComponentType` VALUES (1,'B001','Basic'),(2,'B002','Allowance'),(3,'B003','Hourly');
/*!40000 ALTER TABLE `SalaryComponentType` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Settings`
--

DROP TABLE IF EXISTS `Settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Settings` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `value` text,
  `description` text,
  `meta` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=62 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Settings`
--

LOCK TABLES `Settings` WRITE;
/*!40000 ALTER TABLE `Settings` DISABLE KEYS */;
INSERT INTO `Settings` VALUES (1,'Company: Logo','','','[ \"value\", {\"label\":\"Logo\",\"type\":\"fileupload\",\"validation\":\"none\"}]'),(2,'Company: Name','Sample Company Pvt Ltd','Update your company name - For updating company logo copy a file named logo.png to /app/data/ folder',''),(3,'Company: Description','This is a company using icehrm.com','',''),(4,'Email: Enable','0','0 will disable all outgoing emails from modules. Value 1 will enable outgoing emails','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"1\",\"Yes\"],[\"0\",\"No\"]]}]'),(5,'Email: Mode','SMTP','Update email sender','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"SMTP\",\"SMTP\"],[\"Swift SMTP\",\"Swift SMTP\"],[\"PHP Mailer\",\"PHP Mailer\"],[\"SES\",\"Amazon SES\"]]}]'),(6,'Email: SMTP Host','localhost','SMTP host IP',''),(7,'Email: SMTP Authentication Required','0','Is authentication required by this SMTP server','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"1\",\"Yes\"],[\"0\",\"No\"]]}]'),(8,'Email: SMTP User','none','SMTP user',''),(9,'Email: SMTP Password','none','SMTP password',''),(10,'Email: SMTP Port','none','25',''),(11,'Email: Amazon Access Key ID','','If email mode is Amazon SNS please provide SNS Key',''),(12,'Email: Amazon Secret Access Key','','If email mode is Amazon SNS please provide SNS Secret',''),(13,'Email: Email From','icehrm@mydomain.com','',''),(14,'System: Do not pass JSON in request','0','Select Yes if you are having trouble loading data for some tables','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"1\",\"Yes\"],[\"0\",\"No\"]]}]'),(15,'System: Reset Modules and Permissions','0','Select this to reset module and permission information in Database (If you have done any changes to meta files)','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"1\",\"Yes\"],[\"0\",\"No\"]]}]'),(16,'System: Reset Module Names','0','Select this to reset module names in Database','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"1\",\"Yes\"],[\"0\",\"No\"]]}]'),(17,'System: Add New Permissions','0','Select this to add new permission changes done to meta.json file of any module','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"1\",\"Yes\"],[\"0\",\"No\"]]}]'),(18,'System: Debug Mode','0','','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"1\",\"Yes\"],[\"0\",\"No\"]]}]'),(19,'Projects: Make All Projects Available to Employees','1','','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"1\",\"Yes\"],[\"0\",\"No\"]]}]'),(20,'Leave: Share Calendar to Whole Company','1','','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"1\",\"Yes\"],[\"0\",\"No\"]]}]'),(21,'Leave: CC Emails','','Every email sent though leave module will be CC to these comma seperated list of emails addresses',''),(22,'Leave: BCC Emails','','Every email sent though leave module will be BCC to these comma seperated list of emails addresses',''),(23,'Attendance: Time-sheet Cross Check','0','Only allow users to add an entry to a timesheet only if they have marked atteandance for the selected period','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"1\",\"Yes\"],[\"0\",\"No\"]]}]'),(24,'Api: REST Api Enabled','1','','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"0\",\"No\"],[\"1\",\"Yes\"]]}]'),(25,'Api: REST Api Token','Click on edit icon','','[\"value\", {\"label\":\"Value\",\"type\":\"placeholder\"}]'),(26,'LDAP: Enabled','0','','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"0\",\"No\"],[\"1\",\"Yes\"]]}]'),(27,'LDAP: Server','','LDAP Server IP or DNS',''),(28,'LDAP: Port','389','LDAP Server Port',''),(29,'LDAP: Root DN','','e.g: dc=mycompany,dc=net',''),(30,'LDAP: Manager DN','','e.g: cn=admin,dc=mycompany,dc=net',''),(31,'LDAP: Manager Password','','Password of the manager user',''),(32,'LDAP: Version 3','1','Are you using LDAP v3','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"1\",\"Yes\"],[\"0\",\"No\"]]}]'),(33,'LDAP: User Filter','','e.g: uid={}, we will replace {} with actual username provided by the user at the time of login',''),(34,'Recruitment: Show Quick Apply','1','Show quick apply button when candidates are applying for jobs. Quick apply allow candidates to apply with minimum amount of information','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"1\",\"Yes\"],[\"0\",\"No\"]]}]'),(35,'Recruitment: Show Apply','1','Show apply button when candidates are applying for jobs','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"1\",\"Yes\"],[\"0\",\"No\"]]}]'),(36,'Notifications: Send Document Expiry Emails','1','','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"1\",\"Yes\"],[\"0\",\"No\"]]}]'),(37,'Notifications: Copy Document Expiry Emails to Manager','1','','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"1\",\"Yes\"],[\"0\",\"No\"]]}]'),(38,'Expense: Pre-Approve Expenses','0','','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"1\",\"Yes\"],[\"0\",\"No\"]]}]'),(39,'Travel: Pre-Approve Travel Request','0','','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"1\",\"Yes\"],[\"0\",\"No\"]]}]'),(40,'Attendance: Use Department Time Zone','0','','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"1\",\"Yes\"],[\"0\",\"No\"]]}]'),(41,'Travel: Allow Indirect Admins to Approve','0','Allow indirect admins to approve travel requests','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"1\",\"Yes\"],[\"0\",\"No\"]]}]'),(42,'Attendance: Overtime Calculation Class','BasicOvertimeCalculator','Set the method used to calculate overtime','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"BasicOvertimeCalculator\",\"BasicOvertimeCalculator\"],[\"CaliforniaOvertimeCalculator\",\"CaliforniaOvertimeCalculator\"]]}]'),(43,'Attendance: Overtime Calculation Period','Daily','Set the period for overtime calculation. (Affects attendance sheets)','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"Daily\",\"Daily\"],[\"Weekly\",\"Weekly\"]]}]'),(44,'Attendance: Overtime Start Hour','8','Overtime calculation will start after an employee work this number of hours per day, 0 to indicate no overtime',''),(45,'Attendance: Double time Start Hour','12','Double time calculation will start after an employee work this number of hours per day, 0 to indicate no double time',''),(46,'Attendance: Work Week Start Day','0','Set the starting day of the work week','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"0\",\"Sunday\"],[\"1\",\"Monday\"],[\"2\",\"Tuesday\"],[\"3\",\"Wednesday\"],[\"4\",\"Thursday\"],[\"5\",\"Friday\"],[\"6\",\"Saturday\"]]}]'),(47,'System: Allowed Countries','[\"232\"]','Only these countries will be allowed in select boxes','[\"value\", {\"label\":\"Value\",\"type\":\"select2multi\",\"remote-source\":[\"Country\",\"id\",\"name\"]}]'),(48,'System: Allowed Currencies','[\"154\"]','Only these currencies will be allowed in select boxes','[\"value\", {\"label\":\"Value\",\"type\":\"select2multi\",\"remote-source\":[\"CurrencyType\",\"id\",\"code+name\"]}]'),(49,'System: Allowed Nationality','[\"1\"]','Only these nationalities will be allowed in select boxes','[\"value\", {\"label\":\"Value\",\"type\":\"select2multi\",\"remote-source\":[\"Nationality\",\"id\",\"name\"]}]'),(50,'System: Language','vn','Current Language','[\"value\", {\"label\":\"Value\",\"type\":\"select2\",\"allow-null\":false,\"remote-source\":[\"SupportedLanguage\",\"name\",\"description\"]}]'),(51,'System: Time-sheet Entry Start and End time Required','1','Select 0 if you only need to store the time spend in time sheets','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"1\",\"Yes\"],[\"0\",\"No\"]]}]'),(52,'Attendance: Photo Attendance','0','Require submitting a photo using web cam when marking attendance','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"1\",\"Yes\"],[\"0\",\"No\"]]}]'),(53,'System: G Suite Enabled','0','If you want to allow users to login via G Suite accounts','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"1\",\"Yes\"],[\"0\",\"No\"]]}]'),(54,'System: G Suite Disable Password Login','0','If you want to allow users to login only via G Suite accounts','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"1\",\"Yes\"],[\"0\",\"No\"]]}]'),(55,'Leave: Select Leave Period from Employee Department Country','0','The leave period for the employee should be decided based on the country of the department which the employee is attached to','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"1\",\"Yes\"],[\"0\",\"No\"]]}]'),(56,'Attendance: Request Attendance Location on Mobile','1','Push attendance location when marking attendance via mobile app','[\"value\", {\"label\":\"Value\",\"type\":\"select\",\"source\":[[\"1\",\"Yes\"],[\"0\",\"No\"]]}]'),(58,'System: Google Maps Api Key','','Google Map Api Key',''),(59,'Instance : ID','80e9e5cacc12a5d42732f02a7ba4668f',NULL,NULL),(60,'Instance: Key','kgJy9NZzP14896tgRO6wWSmWB9oBg7j8HmD7irayR3aIP4chN5wE5+356N1+aEY=',NULL,NULL),(61,'Modules : Group','leave,attendance,basic','all','');
/*!40000 ALTER TABLE `Settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Skills`
--

DROP TABLE IF EXISTS `Skills`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Skills` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `description` varchar(400) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Skills`
--

LOCK TABLES `Skills` WRITE;
/*!40000 ALTER TABLE `Skills` DISABLE KEYS */;
INSERT INTO `Skills` VALUES (1,'Programming and Application Development','Programming and Application Development'),(2,'Project Management','Project Management'),(3,'Help Desk/Technical Support','Help Desk/Technical Support'),(4,'Networking','Networking'),(5,'Databases','Databases'),(6,'Business Intelligence','Business Intelligence'),(7,'Cloud Computing','Cloud Computing'),(8,'Information Security','Information Security'),(9,'HTML Skills','HTML Skills'),(10,'Graphic Designing','Graphic Designing');
/*!40000 ALTER TABLE `Skills` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `StatusChangeLogs`
--

DROP TABLE IF EXISTS `StatusChangeLogs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `StatusChangeLogs` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `type` varchar(100) NOT NULL,
  `element` bigint(20) NOT NULL,
  `user_id` bigint(20) DEFAULT NULL,
  `data` varchar(500) NOT NULL,
  `status_from` enum('Approved','Pending','Rejected','Cancellation Requested','Cancelled','Processing') DEFAULT 'Pending',
  `status_to` enum('Approved','Pending','Rejected','Cancellation Requested','Cancelled','Processing') DEFAULT 'Pending',
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `EmployeeApprovals_type_element` (`type`,`element`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `StatusChangeLogs`
--

LOCK TABLES `StatusChangeLogs` WRITE;
/*!40000 ALTER TABLE `StatusChangeLogs` DISABLE KEYS */;
/*!40000 ALTER TABLE `StatusChangeLogs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SupportedLanguages`
--

DROP TABLE IF EXISTS `SupportedLanguages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SupportedLanguages` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `description` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SupportedLanguages`
--

LOCK TABLES `SupportedLanguages` WRITE;
/*!40000 ALTER TABLE `SupportedLanguages` DISABLE KEYS */;
INSERT INTO `SupportedLanguages` VALUES (1,'vn','Vietnamese'),(2,'en','English');
/*!40000 ALTER TABLE `SupportedLanguages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Tags`
--

DROP TABLE IF EXISTS `Tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Tags` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(250) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Tags`
--

LOCK TABLES `Tags` WRITE;
/*!40000 ALTER TABLE `Tags` DISABLE KEYS */;
/*!40000 ALTER TABLE `Tags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Timezones`
--

DROP TABLE IF EXISTS `Timezones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Timezones` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL DEFAULT '',
  `details` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `TimezoneNameKey` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=538 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Timezones`
--

LOCK TABLES `Timezones` WRITE;
/*!40000 ALTER TABLE `Timezones` DISABLE KEYS */;
INSERT INTO `Timezones` VALUES (2,'US/Samoa','(GMT-11:00) Samoa'),(3,'US/Hawaii','(GMT-10:00) Hawaii'),(4,'US/Alaska','(GMT-09:00) Alaska'),(5,'US/Pacific','(GMT-08:00) Pacific Time (US, Canada)'),(7,'US/Arizona','(GMT-07:00) Arizona'),(8,'US/Mountain','(GMT-07:00) Mountain Time (US, Canada)'),(13,'Canada/Saskatchewan','(GMT-06:00) Saskatchewan'),(14,'US/Central','(GMT-06:00) Central Time (US , Canada)'),(15,'US/Eastern','(GMT-05:00) Eastern Time (US , Canada)'),(16,'US/East-Indiana','(GMT-05:00) Indiana (East)'),(20,'Canada/Atlantic','(GMT-04:00) Atlantic Time (Canada)'),(23,'Canada/Newfoundland','(GMT-03:30) Newfoundland'),(24,'America/Buenos_Aires','(GMT-03:00) Buenos Aires'),(88,'Asia/Chongqing','(GMT+08:00) Chongqing'),(103,'Australia/Canberra','(GMT+10:00) Canberra'),(113,'Africa/Abidjan','Africa/Abidjan'),(114,'Africa/Accra','Africa/Accra'),(115,'Africa/Addis_Ababa','Africa/Addis_Ababa'),(116,'Africa/Algiers','Africa/Algiers'),(117,'Africa/Asmara','Africa/Asmara'),(118,'Africa/Bamako','Africa/Bamako'),(119,'Africa/Bangui','Africa/Bangui'),(120,'Africa/Banjul','Africa/Banjul'),(121,'Africa/Bissau','Africa/Bissau'),(122,'Africa/Blantyre','Africa/Blantyre'),(123,'Africa/Brazzaville','Africa/Brazzaville'),(124,'Africa/Bujumbura','Africa/Bujumbura'),(125,'Africa/Cairo','Africa/Cairo'),(126,'Africa/Casablanca','Africa/Casablanca'),(127,'Africa/Ceuta','Africa/Ceuta'),(128,'Africa/Conakry','Africa/Conakry'),(129,'Africa/Dakar','Africa/Dakar'),(130,'Africa/Dar_es_Salaam','Africa/Dar_es_Salaam'),(131,'Africa/Djibouti','Africa/Djibouti'),(132,'Africa/Douala','Africa/Douala'),(133,'Africa/El_Aaiun','Africa/El_Aaiun'),(134,'Africa/Freetown','Africa/Freetown'),(135,'Africa/Gaborone','Africa/Gaborone'),(136,'Africa/Harare','Africa/Harare'),(137,'Africa/Johannesburg','Africa/Johannesburg'),(138,'Africa/Juba','Africa/Juba'),(139,'Africa/Kampala','Africa/Kampala'),(140,'Africa/Khartoum','Africa/Khartoum'),(141,'Africa/Kigali','Africa/Kigali'),(142,'Africa/Kinshasa','Africa/Kinshasa'),(143,'Africa/Lagos','Africa/Lagos'),(144,'Africa/Libreville','Africa/Libreville'),(145,'Africa/Lome','Africa/Lome'),(146,'Africa/Luanda','Africa/Luanda'),(147,'Africa/Lubumbashi','Africa/Lubumbashi'),(148,'Africa/Lusaka','Africa/Lusaka'),(149,'Africa/Malabo','Africa/Malabo'),(150,'Africa/Maputo','Africa/Maputo'),(151,'Africa/Maseru','Africa/Maseru'),(152,'Africa/Mbabane','Africa/Mbabane'),(153,'Africa/Mogadishu','Africa/Mogadishu'),(154,'Africa/Monrovia','Africa/Monrovia'),(155,'Africa/Nairobi','Africa/Nairobi'),(156,'Africa/Ndjamena','Africa/Ndjamena'),(157,'Africa/Niamey','Africa/Niamey'),(158,'Africa/Nouakchott','Africa/Nouakchott'),(159,'Africa/Ouagadougou','Africa/Ouagadougou'),(160,'Africa/Porto-Novo','Africa/Porto-Novo'),(161,'Africa/Sao_Tome','Africa/Sao_Tome'),(162,'Africa/Tripoli','Africa/Tripoli'),(163,'Africa/Tunis','Africa/Tunis'),(164,'Africa/Windhoek','Africa/Windhoek'),(165,'America/Adak','America/Adak'),(166,'America/Anchorage','America/Anchorage'),(167,'America/Anguilla','America/Anguilla'),(168,'America/Antigua','America/Antigua'),(169,'America/Araguaina','America/Araguaina'),(170,'America/Argentina/Buenos_Aires','America/Argentina/Buenos_Aires'),(171,'America/Argentina/Catamarca','America/Argentina/Catamarca'),(172,'America/Argentina/Cordoba','America/Argentina/Cordoba'),(173,'America/Argentina/Jujuy','America/Argentina/Jujuy'),(174,'America/Argentina/La_Rioja','America/Argentina/La_Rioja'),(175,'America/Argentina/Mendoza','America/Argentina/Mendoza'),(176,'America/Argentina/Rio_Gallegos','America/Argentina/Rio_Gallegos'),(177,'America/Argentina/Salta','America/Argentina/Salta'),(178,'America/Argentina/San_Juan','America/Argentina/San_Juan'),(179,'America/Argentina/San_Luis','America/Argentina/San_Luis'),(180,'America/Argentina/Tucuman','America/Argentina/Tucuman'),(181,'America/Argentina/Ushuaia','America/Argentina/Ushuaia'),(182,'America/Aruba','America/Aruba'),(183,'America/Asuncion','America/Asuncion'),(184,'America/Atikokan','America/Atikokan'),(185,'America/Bahia','America/Bahia'),(186,'America/Bahia_Banderas','America/Bahia_Banderas'),(187,'America/Barbados','America/Barbados'),(188,'America/Belem','America/Belem'),(189,'America/Belize','America/Belize'),(190,'America/Blanc-Sablon','America/Blanc-Sablon'),(191,'America/Boa_Vista','America/Boa_Vista'),(192,'America/Bogota','America/Bogota'),(193,'America/Boise','America/Boise'),(194,'America/Cambridge_Bay','America/Cambridge_Bay'),(195,'America/Campo_Grande','America/Campo_Grande'),(196,'America/Cancun','America/Cancun'),(197,'America/Caracas','America/Caracas'),(198,'America/Cayenne','America/Cayenne'),(199,'America/Cayman','America/Cayman'),(200,'America/Chicago','America/Chicago'),(201,'America/Chihuahua','America/Chihuahua'),(202,'America/Costa_Rica','America/Costa_Rica'),(203,'America/Creston','America/Creston'),(204,'America/Cuiaba','America/Cuiaba'),(205,'America/Curacao','America/Curacao'),(206,'America/Danmarkshavn','America/Danmarkshavn'),(207,'America/Dawson','America/Dawson'),(208,'America/Dawson_Creek','America/Dawson_Creek'),(209,'America/Denver','America/Denver'),(210,'America/Detroit','America/Detroit'),(211,'America/Dominica','America/Dominica'),(212,'America/Edmonton','America/Edmonton'),(213,'America/Eirunepe','America/Eirunepe'),(214,'America/El_Salvador','America/El_Salvador'),(215,'America/Fort_Nelson','America/Fort_Nelson'),(216,'America/Fortaleza','America/Fortaleza'),(217,'America/Glace_Bay','America/Glace_Bay'),(218,'America/Godthab','America/Godthab'),(219,'America/Goose_Bay','America/Goose_Bay'),(220,'America/Grand_Turk','America/Grand_Turk'),(221,'America/Grenada','America/Grenada'),(222,'America/Guadeloupe','America/Guadeloupe'),(223,'America/Guatemala','America/Guatemala'),(224,'America/Guayaquil','America/Guayaquil'),(225,'America/Guyana','America/Guyana'),(226,'America/Halifax','America/Halifax'),(227,'America/Havana','America/Havana'),(228,'America/Hermosillo','America/Hermosillo'),(229,'America/Indiana/Indianapolis','America/Indiana/Indianapolis'),(230,'America/Indiana/Knox','America/Indiana/Knox'),(231,'America/Indiana/Marengo','America/Indiana/Marengo'),(232,'America/Indiana/Petersburg','America/Indiana/Petersburg'),(233,'America/Indiana/Tell_City','America/Indiana/Tell_City'),(234,'America/Indiana/Vevay','America/Indiana/Vevay'),(235,'America/Indiana/Vincennes','America/Indiana/Vincennes'),(236,'America/Indiana/Winamac','America/Indiana/Winamac'),(237,'America/Inuvik','America/Inuvik'),(238,'America/Iqaluit','America/Iqaluit'),(239,'America/Jamaica','America/Jamaica'),(240,'America/Juneau','America/Juneau'),(241,'America/Kentucky/Louisville','America/Kentucky/Louisville'),(242,'America/Kentucky/Monticello','America/Kentucky/Monticello'),(243,'America/Kralendijk','America/Kralendijk'),(244,'America/La_Paz','America/La_Paz'),(245,'America/Lima','America/Lima'),(246,'America/Los_Angeles','America/Los_Angeles'),(247,'America/Lower_Princes','America/Lower_Princes'),(248,'America/Maceio','America/Maceio'),(249,'America/Managua','America/Managua'),(250,'America/Manaus','America/Manaus'),(251,'America/Marigot','America/Marigot'),(252,'America/Martinique','America/Martinique'),(253,'America/Matamoros','America/Matamoros'),(254,'America/Mazatlan','America/Mazatlan'),(255,'America/Menominee','America/Menominee'),(256,'America/Merida','America/Merida'),(257,'America/Metlakatla','America/Metlakatla'),(258,'America/Mexico_City','America/Mexico_City'),(259,'America/Miquelon','America/Miquelon'),(260,'America/Moncton','America/Moncton'),(261,'America/Monterrey','America/Monterrey'),(262,'America/Montevideo','America/Montevideo'),(263,'America/Montserrat','America/Montserrat'),(264,'America/Nassau','America/Nassau'),(265,'America/New_York','America/New_York'),(266,'America/Nipigon','America/Nipigon'),(267,'America/Nome','America/Nome'),(268,'America/Noronha','America/Noronha'),(269,'America/North_Dakota/Beulah','America/North_Dakota/Beulah'),(270,'America/North_Dakota/Center','America/North_Dakota/Center'),(271,'America/North_Dakota/New_Salem','America/North_Dakota/New_Salem'),(272,'America/Ojinaga','America/Ojinaga'),(273,'America/Panama','America/Panama'),(274,'America/Pangnirtung','America/Pangnirtung'),(275,'America/Paramaribo','America/Paramaribo'),(276,'America/Phoenix','America/Phoenix'),(277,'America/Port-au-Prince','America/Port-au-Prince'),(278,'America/Port_of_Spain','America/Port_of_Spain'),(279,'America/Porto_Velho','America/Porto_Velho'),(280,'America/Puerto_Rico','America/Puerto_Rico'),(281,'America/Punta_Arenas','America/Punta_Arenas'),(282,'America/Rainy_River','America/Rainy_River'),(283,'America/Rankin_Inlet','America/Rankin_Inlet'),(284,'America/Recife','America/Recife'),(285,'America/Regina','America/Regina'),(286,'America/Resolute','America/Resolute'),(287,'America/Rio_Branco','America/Rio_Branco'),(288,'America/Santarem','America/Santarem'),(289,'America/Santiago','America/Santiago'),(290,'America/Santo_Domingo','America/Santo_Domingo'),(291,'America/Sao_Paulo','America/Sao_Paulo'),(292,'America/Scoresbysund','America/Scoresbysund'),(293,'America/Sitka','America/Sitka'),(294,'America/St_Barthelemy','America/St_Barthelemy'),(295,'America/St_Johns','America/St_Johns'),(296,'America/St_Kitts','America/St_Kitts'),(297,'America/St_Lucia','America/St_Lucia'),(298,'America/St_Thomas','America/St_Thomas'),(299,'America/St_Vincent','America/St_Vincent'),(300,'America/Swift_Current','America/Swift_Current'),(301,'America/Tegucigalpa','America/Tegucigalpa'),(302,'America/Thule','America/Thule'),(303,'America/Thunder_Bay','America/Thunder_Bay'),(304,'America/Tijuana','America/Tijuana'),(305,'America/Toronto','America/Toronto'),(306,'America/Tortola','America/Tortola'),(307,'America/Vancouver','America/Vancouver'),(308,'America/Whitehorse','America/Whitehorse'),(309,'America/Winnipeg','America/Winnipeg'),(310,'America/Yakutat','America/Yakutat'),(311,'America/Yellowknife','America/Yellowknife'),(312,'Antarctica/Casey','Antarctica/Casey'),(313,'Antarctica/Davis','Antarctica/Davis'),(314,'Antarctica/DumontDUrville','Antarctica/DumontDUrville'),(315,'Antarctica/Macquarie','Antarctica/Macquarie'),(316,'Antarctica/Mawson','Antarctica/Mawson'),(317,'Antarctica/McMurdo','Antarctica/McMurdo'),(318,'Antarctica/Palmer','Antarctica/Palmer'),(319,'Antarctica/Rothera','Antarctica/Rothera'),(320,'Antarctica/Syowa','Antarctica/Syowa'),(321,'Antarctica/Troll','Antarctica/Troll'),(322,'Antarctica/Vostok','Antarctica/Vostok'),(323,'Arctic/Longyearbyen','Arctic/Longyearbyen'),(324,'Asia/Aden','Asia/Aden'),(325,'Asia/Almaty','Asia/Almaty'),(326,'Asia/Amman','Asia/Amman'),(327,'Asia/Anadyr','Asia/Anadyr'),(328,'Asia/Aqtau','Asia/Aqtau'),(329,'Asia/Aqtobe','Asia/Aqtobe'),(330,'Asia/Ashgabat','Asia/Ashgabat'),(331,'Asia/Atyrau','Asia/Atyrau'),(332,'Asia/Baghdad','Asia/Baghdad'),(333,'Asia/Bahrain','Asia/Bahrain'),(334,'Asia/Baku','Asia/Baku'),(335,'Asia/Bangkok','Asia/Bangkok'),(336,'Asia/Barnaul','Asia/Barnaul'),(337,'Asia/Beirut','Asia/Beirut'),(338,'Asia/Bishkek','Asia/Bishkek'),(339,'Asia/Brunei','Asia/Brunei'),(340,'Asia/Chita','Asia/Chita'),(341,'Asia/Choibalsan','Asia/Choibalsan'),(342,'Asia/Colombo','Asia/Colombo'),(343,'Asia/Damascus','Asia/Damascus'),(344,'Asia/Dhaka','Asia/Dhaka'),(345,'Asia/Dili','Asia/Dili'),(346,'Asia/Dubai','Asia/Dubai'),(347,'Asia/Dushanbe','Asia/Dushanbe'),(348,'Asia/Famagusta','Asia/Famagusta'),(349,'Asia/Gaza','Asia/Gaza'),(350,'Asia/Hebron','Asia/Hebron'),(351,'Asia/Ho_Chi_Minh','Asia/Ho_Chi_Minh'),(352,'Asia/Hong_Kong','Asia/Hong_Kong'),(353,'Asia/Hovd','Asia/Hovd'),(354,'Asia/Irkutsk','Asia/Irkutsk'),(355,'Asia/Jakarta','Asia/Jakarta'),(356,'Asia/Jayapura','Asia/Jayapura'),(357,'Asia/Jerusalem','Asia/Jerusalem'),(358,'Asia/Kabul','Asia/Kabul'),(359,'Asia/Kamchatka','Asia/Kamchatka'),(360,'Asia/Karachi','Asia/Karachi'),(361,'Asia/Kathmandu','Asia/Kathmandu'),(362,'Asia/Khandyga','Asia/Khandyga'),(363,'Asia/Kolkata','Asia/Kolkata'),(364,'Asia/Krasnoyarsk','Asia/Krasnoyarsk'),(365,'Asia/Kuala_Lumpur','Asia/Kuala_Lumpur'),(366,'Asia/Kuching','Asia/Kuching'),(367,'Asia/Kuwait','Asia/Kuwait'),(368,'Asia/Macau','Asia/Macau'),(369,'Asia/Magadan','Asia/Magadan'),(370,'Asia/Makassar','Asia/Makassar'),(371,'Asia/Manila','Asia/Manila'),(372,'Asia/Muscat','Asia/Muscat'),(373,'Asia/Nicosia','Asia/Nicosia'),(374,'Asia/Novokuznetsk','Asia/Novokuznetsk'),(375,'Asia/Novosibirsk','Asia/Novosibirsk'),(376,'Asia/Omsk','Asia/Omsk'),(377,'Asia/Oral','Asia/Oral'),(378,'Asia/Phnom_Penh','Asia/Phnom_Penh'),(379,'Asia/Pontianak','Asia/Pontianak'),(380,'Asia/Pyongyang','Asia/Pyongyang'),(381,'Asia/Qatar','Asia/Qatar'),(382,'Asia/Qyzylorda','Asia/Qyzylorda'),(383,'Asia/Riyadh','Asia/Riyadh'),(384,'Asia/Sakhalin','Asia/Sakhalin'),(385,'Asia/Samarkand','Asia/Samarkand'),(386,'Asia/Seoul','Asia/Seoul'),(387,'Asia/Shanghai','Asia/Shanghai'),(388,'Asia/Singapore','Asia/Singapore'),(389,'Asia/Srednekolymsk','Asia/Srednekolymsk'),(390,'Asia/Taipei','Asia/Taipei'),(391,'Asia/Tashkent','Asia/Tashkent'),(392,'Asia/Tbilisi','Asia/Tbilisi'),(393,'Asia/Tehran','Asia/Tehran'),(394,'Asia/Thimphu','Asia/Thimphu'),(395,'Asia/Tokyo','Asia/Tokyo'),(396,'Asia/Tomsk','Asia/Tomsk'),(397,'Asia/Ulaanbaatar','Asia/Ulaanbaatar'),(398,'Asia/Urumqi','Asia/Urumqi'),(399,'Asia/Ust-Nera','Asia/Ust-Nera'),(400,'Asia/Vientiane','Asia/Vientiane'),(401,'Asia/Vladivostok','Asia/Vladivostok'),(402,'Asia/Yakutsk','Asia/Yakutsk'),(403,'Asia/Yangon','Asia/Yangon'),(404,'Asia/Yekaterinburg','Asia/Yekaterinburg'),(405,'Asia/Yerevan','Asia/Yerevan'),(406,'Atlantic/Azores','Atlantic/Azores'),(407,'Atlantic/Bermuda','Atlantic/Bermuda'),(408,'Atlantic/Canary','Atlantic/Canary'),(409,'Atlantic/Cape_Verde','Atlantic/Cape_Verde'),(410,'Atlantic/Faroe','Atlantic/Faroe'),(411,'Atlantic/Madeira','Atlantic/Madeira'),(412,'Atlantic/Reykjavik','Atlantic/Reykjavik'),(413,'Atlantic/South_Georgia','Atlantic/South_Georgia'),(414,'Atlantic/St_Helena','Atlantic/St_Helena'),(415,'Atlantic/Stanley','Atlantic/Stanley'),(416,'Australia/Adelaide','Australia/Adelaide'),(417,'Australia/Brisbane','Australia/Brisbane'),(418,'Australia/Broken_Hill','Australia/Broken_Hill'),(419,'Australia/Currie','Australia/Currie'),(420,'Australia/Darwin','Australia/Darwin'),(421,'Australia/Eucla','Australia/Eucla'),(422,'Australia/Hobart','Australia/Hobart'),(423,'Australia/Lindeman','Australia/Lindeman'),(424,'Australia/Lord_Howe','Australia/Lord_Howe'),(425,'Australia/Melbourne','Australia/Melbourne'),(426,'Australia/Perth','Australia/Perth'),(427,'Australia/Sydney','Australia/Sydney'),(428,'Europe/Amsterdam','Europe/Amsterdam'),(429,'Europe/Andorra','Europe/Andorra'),(430,'Europe/Astrakhan','Europe/Astrakhan'),(431,'Europe/Athens','Europe/Athens'),(432,'Europe/Belgrade','Europe/Belgrade'),(433,'Europe/Berlin','Europe/Berlin'),(434,'Europe/Bratislava','Europe/Bratislava'),(435,'Europe/Brussels','Europe/Brussels'),(436,'Europe/Bucharest','Europe/Bucharest'),(437,'Europe/Budapest','Europe/Budapest'),(438,'Europe/Busingen','Europe/Busingen'),(439,'Europe/Chisinau','Europe/Chisinau'),(440,'Europe/Copenhagen','Europe/Copenhagen'),(441,'Europe/Dublin','Europe/Dublin'),(442,'Europe/Gibraltar','Europe/Gibraltar'),(443,'Europe/Guernsey','Europe/Guernsey'),(444,'Europe/Helsinki','Europe/Helsinki'),(445,'Europe/Isle_of_Man','Europe/Isle_of_Man'),(446,'Europe/Istanbul','Europe/Istanbul'),(447,'Europe/Jersey','Europe/Jersey'),(448,'Europe/Kaliningrad','Europe/Kaliningrad'),(449,'Europe/Kiev','Europe/Kiev'),(450,'Europe/Kirov','Europe/Kirov'),(451,'Europe/Lisbon','Europe/Lisbon'),(452,'Europe/Ljubljana','Europe/Ljubljana'),(453,'Europe/London','Europe/London'),(454,'Europe/Luxembourg','Europe/Luxembourg'),(455,'Europe/Madrid','Europe/Madrid'),(456,'Europe/Malta','Europe/Malta'),(457,'Europe/Mariehamn','Europe/Mariehamn'),(458,'Europe/Minsk','Europe/Minsk'),(459,'Europe/Monaco','Europe/Monaco'),(460,'Europe/Moscow','Europe/Moscow'),(461,'Europe/Oslo','Europe/Oslo'),(462,'Europe/Paris','Europe/Paris'),(463,'Europe/Podgorica','Europe/Podgorica'),(464,'Europe/Prague','Europe/Prague'),(465,'Europe/Riga','Europe/Riga'),(466,'Europe/Rome','Europe/Rome'),(467,'Europe/Samara','Europe/Samara'),(468,'Europe/San_Marino','Europe/San_Marino'),(469,'Europe/Sarajevo','Europe/Sarajevo'),(470,'Europe/Saratov','Europe/Saratov'),(471,'Europe/Simferopol','Europe/Simferopol'),(472,'Europe/Skopje','Europe/Skopje'),(473,'Europe/Sofia','Europe/Sofia'),(474,'Europe/Stockholm','Europe/Stockholm'),(475,'Europe/Tallinn','Europe/Tallinn'),(476,'Europe/Tirane','Europe/Tirane'),(477,'Europe/Ulyanovsk','Europe/Ulyanovsk'),(478,'Europe/Uzhgorod','Europe/Uzhgorod'),(479,'Europe/Vaduz','Europe/Vaduz'),(480,'Europe/Vatican','Europe/Vatican'),(481,'Europe/Vienna','Europe/Vienna'),(482,'Europe/Vilnius','Europe/Vilnius'),(483,'Europe/Volgograd','Europe/Volgograd'),(484,'Europe/Warsaw','Europe/Warsaw'),(485,'Europe/Zagreb','Europe/Zagreb'),(486,'Europe/Zaporozhye','Europe/Zaporozhye'),(487,'Europe/Zurich','Europe/Zurich'),(488,'Indian/Antananarivo','Indian/Antananarivo'),(489,'Indian/Chagos','Indian/Chagos'),(490,'Indian/Christmas','Indian/Christmas'),(491,'Indian/Cocos','Indian/Cocos'),(492,'Indian/Comoro','Indian/Comoro'),(493,'Indian/Kerguelen','Indian/Kerguelen'),(494,'Indian/Mahe','Indian/Mahe'),(495,'Indian/Maldives','Indian/Maldives'),(496,'Indian/Mauritius','Indian/Mauritius'),(497,'Indian/Mayotte','Indian/Mayotte'),(498,'Indian/Reunion','Indian/Reunion'),(499,'Pacific/Apia','Pacific/Apia'),(500,'Pacific/Auckland','Pacific/Auckland'),(501,'Pacific/Bougainville','Pacific/Bougainville'),(502,'Pacific/Chatham','Pacific/Chatham'),(503,'Pacific/Chuuk','Pacific/Chuuk'),(504,'Pacific/Easter','Pacific/Easter'),(505,'Pacific/Efate','Pacific/Efate'),(506,'Pacific/Enderbury','Pacific/Enderbury'),(507,'Pacific/Fakaofo','Pacific/Fakaofo'),(508,'Pacific/Fiji','Pacific/Fiji'),(509,'Pacific/Funafuti','Pacific/Funafuti'),(510,'Pacific/Galapagos','Pacific/Galapagos'),(511,'Pacific/Gambier','Pacific/Gambier'),(512,'Pacific/Guadalcanal','Pacific/Guadalcanal'),(513,'Pacific/Guam','Pacific/Guam'),(514,'Pacific/Honolulu','Pacific/Honolulu'),(515,'Pacific/Kiritimati','Pacific/Kiritimati'),(516,'Pacific/Kosrae','Pacific/Kosrae'),(517,'Pacific/Kwajalein','Pacific/Kwajalein'),(518,'Pacific/Majuro','Pacific/Majuro'),(519,'Pacific/Marquesas','Pacific/Marquesas'),(520,'Pacific/Midway','Pacific/Midway'),(521,'Pacific/Nauru','Pacific/Nauru'),(522,'Pacific/Niue','Pacific/Niue'),(523,'Pacific/Norfolk','Pacific/Norfolk'),(524,'Pacific/Noumea','Pacific/Noumea'),(525,'Pacific/Pago_Pago','Pacific/Pago_Pago'),(526,'Pacific/Palau','Pacific/Palau'),(527,'Pacific/Pitcairn','Pacific/Pitcairn'),(528,'Pacific/Pohnpei','Pacific/Pohnpei'),(529,'Pacific/Port_Moresby','Pacific/Port_Moresby'),(530,'Pacific/Rarotonga','Pacific/Rarotonga'),(531,'Pacific/Saipan','Pacific/Saipan'),(532,'Pacific/Tahiti','Pacific/Tahiti'),(533,'Pacific/Tarawa','Pacific/Tarawa'),(534,'Pacific/Tongatapu','Pacific/Tongatapu'),(535,'Pacific/Wake','Pacific/Wake'),(536,'Pacific/Wallis','Pacific/Wallis'),(537,'UTC','UTC');
/*!40000 ALTER TABLE `Timezones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `TrainingSessions`
--

DROP TABLE IF EXISTS `TrainingSessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TrainingSessions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(300) NOT NULL,
  `course` bigint(20) NOT NULL,
  `description` text,
  `scheduled` datetime DEFAULT NULL,
  `dueDate` datetime DEFAULT NULL,
  `deliveryMethod` enum('Classroom','Self Study','Online') DEFAULT 'Classroom',
  `deliveryLocation` varchar(500) DEFAULT NULL,
  `status` enum('Pending','Approved','Completed','Cancelled') DEFAULT 'Pending',
  `attendanceType` enum('Sign Up','Assign') DEFAULT 'Sign Up',
  `attachment` varchar(300) DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `updated` datetime DEFAULT NULL,
  `requireProof` enum('Yes','No') DEFAULT 'Yes',
  PRIMARY KEY (`id`),
  KEY `Fk_TrainingSessions_Courses` (`course`),
  CONSTRAINT `Fk_TrainingSessions_Courses` FOREIGN KEY (`course`) REFERENCES `Courses` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TrainingSessions`
--

LOCK TABLES `TrainingSessions` WRITE;
/*!40000 ALTER TABLE `TrainingSessions` DISABLE KEYS */;
/*!40000 ALTER TABLE `TrainingSessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `UserReports`
--

DROP TABLE IF EXISTS `UserReports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `UserReports` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `details` text,
  `parameters` text,
  `query` text,
  `paramOrder` varchar(500) NOT NULL,
  `type` enum('Query','Class') DEFAULT 'Query',
  `report_group` varchar(500) DEFAULT NULL,
  `output` varchar(15) NOT NULL DEFAULT 'CSV',
  PRIMARY KEY (`id`),
  UNIQUE KEY `UserReports_Name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `UserReports`
--

LOCK TABLES `UserReports` WRITE;
/*!40000 ALTER TABLE `UserReports` DISABLE KEYS */;
INSERT INTO `UserReports` VALUES (1,'Time Entry Report','View your time entries by date range and project','[\r\n[ \"client\", {\"label\":\"Select Client\",\"type\":\"select\",\"allow-null\":true,\"null-label\":\"Not Selected\",\"remote-source\":[\"Client\",\"id\",\"name\"]}],\r\n[ \"project\", {\"label\":\"Or Project\",\"type\":\"select\",\"allow-null\":true,\"null-label\":\"All Projects\",\"remote-source\":[\"Project\",\"id\",\"name\",\"getAllProjects\"]}],\r\n[ \"date_start\", {\"label\":\"Start Date\",\"type\":\"date\"}],\r\n[ \"date_end\", {\"label\":\"End Date\",\"type\":\"date\"}]\r\n]','EmployeeTimesheetReport','[\"client\",\"project\",\"date_start\",\"date_end\",\"status\"]','Class','Time Management','CSV'),(2,'Attendance Report','View your attendance entries by date range','[\r\n[ \"date_start\", {\"label\":\"Start Date\",\"type\":\"date\"}],\r\n[ \"date_end\", {\"label\":\"End Date\",\"type\":\"date\"}]\r\n]','EmployeeAttendanceReport','[\"date_start\",\"date_end\"]','Class','Time Management','CSV'),(3,'Time Tracking Report','View your working hours and attendance details for each day for a given period ','[\r\n[ \"date_start\", {\"label\":\"Start Date\",\"type\":\"date\"}],\r\n[ \"date_end\", {\"label\":\"End Date\",\"type\":\"date\"}]\r\n]','EmployeeTimeTrackReport','[\"date_start\",\"date_end\"]','Class','Time Management','CSV'),(4,'Travel Request Report','View travel requests for a specified period','[\r\n[ \"date_start\", {\"label\":\"Start Date\",\"type\":\"date\"}],\r\n[ \"date_end\", {\"label\":\"End Date\",\"type\":\"date\"}],\r\n[ \"status\", {\"label\":\"Status\",\"type\":\"select\",\"source\":[[\"NULL\",\"All Statuses\"],[\"Approved\",\"Approved\"],[\"Pending\",\"Pending\"],[\"Rejected\",\"Rejected\"],[\"Cancellation Requested\",\"Cancellation Requested\"],[\"Cancelled\",\"Cancelled\"]]}]\r\n]','TravelRequestReport','[\"date_start\",\"date_end\",\"status\"]','Class','Travel and Expense Management','CSV'),(5,'Time Sheet Report','This report list all employee time sheets by employee and date range','[\r\n[ \"date_start\", {\"label\":\"Start Date\",\"type\":\"date\"}],\r\n[ \"date_end\", {\"label\":\"End Date\",\"type\":\"date\"}],\r\n[ \"status\", {\"label\":\"Status\",\"allow-null\":true,\"null-label\":\"All Status\",\"type\":\"select\",\"source\":[[\"Approved\",\"Approved\"],[\"Pending\",\"Pending\"],[\"Rejected\",\"Rejected\"]]}]\r\n]','EmployeeTimeSheetData','[\"date_start\",\"date_end\",\"status\"]','Class','Time Management','CSV'),(6,'Client Project Time Report','View your time entries for projects under a given client','[\r\n[ \"client\", {\"label\":\"Select Client\",\"type\":\"select\",\"allow-null\":false,\"remote-source\":[\"Client\",\"id\",\"name\"]}],\r\n[ \"date_start\", {\"label\":\"Start Date\",\"type\":\"date\"}],\r\n[ \"date_end\", {\"label\":\"End Date\",\"type\":\"date\"}]\r\n]','ClientProjectTimeReport','[\"client\",\"date_start\",\"date_end\",\"status\"]','Class','Time Management','PDF'),(7,'Download Payslips','Download your payslips','[\r\n[ \"payroll\", {\"label\":\"Select Payroll\",\"type\":\"select\",\"allow-null\":false,\"remote-source\":[\"Payroll\",\"id\",\"name\",\"getEmployeePayrolls\"]}]]','PayslipReport','[\"payroll\"]','Class','Finance','PDF');
/*!40000 ALTER TABLE `UserReports` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `UserRoles`
--

DROP TABLE IF EXISTS `UserRoles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `UserRoles` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `UserRoles`
--

LOCK TABLES `UserRoles` WRITE;
/*!40000 ALTER TABLE `UserRoles` DISABLE KEYS */;
INSERT INTO `UserRoles` VALUES (2,'Attendance Manager'),(1,'Report Manager');
/*!40000 ALTER TABLE `UserRoles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Users`
--

DROP TABLE IF EXISTS `Users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Users` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `username` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `password` varchar(100) DEFAULT NULL,
  `employee` bigint(20) DEFAULT NULL,
  `default_module` bigint(20) DEFAULT NULL,
  `user_level` enum('Admin','Employee','Manager','Other') DEFAULT NULL,
  `user_roles` text,
  `last_login` datetime DEFAULT NULL,
  `last_update` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `login_hash` varchar(64) DEFAULT NULL,
  `lang` bigint(20) DEFAULT NULL,
  `googleUserData` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  KEY `Fk_User_Employee` (`employee`),
  KEY `Fk_User_SupportedLanguages` (`lang`),
  KEY `login_hash_index` (`login_hash`),
  CONSTRAINT `Fk_User_Employee` FOREIGN KEY (`employee`) REFERENCES `Employees` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `Fk_User_SupportedLanguages` FOREIGN KEY (`lang`) REFERENCES `SupportedLanguages` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=140 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Users`
--

LOCK TABLES `Users` WRITE;
/*!40000 ALTER TABLE `Users` DISABLE KEYS */;
INSERT INTO `Users` VALUES (1,'admin','icehrm+admin@web-stalk.com','21232f297a57a5a743894a0e4a801fc3',1,NULL,'Admin','','2020-03-13 12:40:32',NULL,NULL,'c6f8d97d68f4ffcd696c498611d695dc175bc17d',NULL,NULL),(3,'demo.superadmin','demo.superadmin@example.com','25f9e794323b453885f5181f1b624d0b',3,NULL,'Admin',NULL,'2020-03-12 19:50:41','2020-03-05 12:54:49','2020-03-05 12:54:49',NULL,1,NULL),(4,'demo.admin','demo.admin@example.com','25d55ad283aa400af464c76d713c07ad',4,NULL,'Manager',NULL,'2020-03-10 09:18:10','2020-03-05 12:55:11','2020-03-05 12:55:11',NULL,NULL,NULL),(5,'demo.staff','demo.staff@example.com','25f9e794323b453885f5181f1b624d0b',5,NULL,'Employee',NULL,'2020-03-10 08:22:31','2020-03-05 12:55:26','2020-03-05 12:55:26',NULL,NULL,NULL),(108,'thoatran1990','thoatran1990@example.company','cdefefc5c13c5998c610d11fad5fa280',112,NULL,'Employee',NULL,'2020-03-10 11:34:50','2020-03-10 11:34:50','2020-03-10 11:34:50',NULL,NULL,NULL),(109,'maitran1990','maitran1990@example.company','4f8aaa42b404453a6d73f46cd521d219',113,NULL,'Employee',NULL,'2020-03-10 11:34:50','2020-03-10 11:34:50','2020-03-10 11:34:50',NULL,NULL,NULL),(110,'trangnguyen1990','trangnguyen1990@example.company','0badcaa70448408bf0c40599f174040a',114,NULL,'Employee',NULL,'2020-03-10 11:34:50','2020-03-10 11:34:50','2020-03-10 11:34:50',NULL,NULL,NULL),(111,'thuybui1990','thuybui1990@example.company','2979813acf7bab9ab1bda3b7de42c932',115,NULL,'Employee',NULL,'2020-03-10 11:34:50','2020-03-10 11:34:50','2020-03-10 11:34:50',NULL,NULL,NULL),(112,'uyennguyen1990','uyennguyen1990@example.company','b2bf3f52612f2eff5851b20cc9ecb97e',116,NULL,'Employee',NULL,'2020-03-10 11:34:51','2020-03-10 11:34:51','2020-03-10 11:34:51',NULL,NULL,NULL),(113,'nguyetdao1990','nguyetdao1990@example.company','aeba1ef92f5422c9b547ade62a497e77',117,NULL,'Employee',NULL,'2020-03-10 11:34:51','2020-03-10 11:34:51','2020-03-10 11:34:51',NULL,NULL,NULL),(114,'hoatran1990','hoatran1990@example.company','49ca7a3d08cb17637b2997638642a4b8',118,NULL,'Employee',NULL,'2020-03-10 11:34:51','2020-03-10 11:34:51','2020-03-10 11:34:51',NULL,NULL,NULL),(115,'trangtran1990','trangtran1990@example.company','437c5c139f6486d314de17cc15d48155',119,NULL,'Employee',NULL,'2020-03-10 11:34:51','2020-03-10 11:34:51','2020-03-10 11:34:51',NULL,NULL,NULL),(116,'phuongnguyen1990','phuongnguyen1990@example.company','d7e4a4ea3dd124cc7c5d40093db65c23',120,NULL,'Employee',NULL,'2020-03-10 11:34:51','2020-03-10 11:34:51','2020-03-10 11:34:51',NULL,NULL,NULL),(117,'thanhtang1990','thanhtang1990@example.company','d12efb10fc97e865b8dbf409cc356091',121,NULL,'Employee',NULL,'2020-03-10 11:34:51','2020-03-10 11:34:51','2020-03-10 11:34:51',NULL,NULL,NULL),(118,'thuattran1990','thuattran1990@example.company','41821074a2dccb857bb6bf83a1384532',122,NULL,'Employee',NULL,'2020-03-10 11:34:51','2020-03-10 11:34:51','2020-03-10 11:34:51',NULL,NULL,NULL),(119,'tieptran1990','tieptran1990@example.company','357fef999d1fd0f75792481b482ef8e7',123,NULL,'Employee',NULL,'2020-03-10 11:34:51','2020-03-10 11:34:51','2020-03-10 11:34:51',NULL,NULL,NULL),(120,'thuyhuynh1990','thuyhuynh1990@example.company','7499edeadf6cdeb808f57b4d430176e0',124,NULL,'Employee',NULL,'2020-03-10 11:34:51','2020-03-10 11:34:51','2020-03-10 11:34:51',NULL,NULL,NULL),(121,'tamnguyen1990','tamnguyen1990@example.company','66ae6e429be78d3ffbde25e334f52850',125,NULL,'Employee',NULL,'2020-03-10 11:34:51','2020-03-10 11:34:51','2020-03-10 11:34:51',NULL,NULL,NULL),(122,'giaodang1990','giaodang1990@example.company','efb75fc0eccd04cc98b753d3518833e4',126,NULL,'Employee',NULL,'2020-03-10 11:34:51','2020-03-10 11:34:51','2020-03-10 11:34:51',NULL,NULL,NULL),(123,'hieule1990','hieule1990@example.company','57cc4f5815f15f2ef021220fa7f52d04',127,NULL,'Employee',NULL,'2020-03-10 11:34:51','2020-03-10 11:34:51','2020-03-10 11:34:51',NULL,NULL,NULL),(124,'quangnguyen1990','quangnguyen1990@example.company','ad6e28386d47f37b4a7db9f2bf4dfb4c',128,NULL,'Employee',NULL,'2020-03-10 11:34:51','2020-03-10 11:34:51','2020-03-10 11:34:51',NULL,NULL,NULL),(125,'hadoan1990','hadoan1990@example.company','6bd7a07edaa4a5564f2f8242c618dab2',129,NULL,'Employee',NULL,'2020-03-10 11:34:51','2020-03-10 11:34:51','2020-03-10 11:34:51',NULL,NULL,NULL),(126,'khanhhuynh1990','khanhhuynh1990@example.company','80704132805564d7f11fb40ea730265d',130,NULL,'Employee',NULL,'2020-03-10 11:34:51','2020-03-10 11:34:51','2020-03-10 11:34:51',NULL,NULL,NULL),(127,'phuongtang1990','phuongtang1990@example.company','12a03beac49e6b92c3038479a025b617',131,NULL,'Employee',NULL,'2020-03-10 11:34:51','2020-03-10 11:34:51','2020-03-10 11:34:51',NULL,NULL,NULL),(128,'quankieu1990','quankieu1990@example.company','8ab5aac265f799c2310450af1ea688c2',132,NULL,'Employee',NULL,'2020-03-10 11:34:51','2020-03-10 11:34:51','2020-03-10 11:34:51',NULL,NULL,NULL),(129,'tuvu1990','tuvu1990@example.company','255eddf364243f6d932c807c4fa2b4cf',133,NULL,'Employee',NULL,'2020-03-10 11:34:51','2020-03-10 11:34:51','2020-03-10 11:34:51',NULL,NULL,NULL),(130,'quyenhuynh1990','quyenhuynh1990@example.company','17067745ee68c759fdc1f0c6a744c4a5',134,NULL,'Employee',NULL,'2020-03-10 11:34:51','2020-03-10 11:34:51','2020-03-10 11:34:51',NULL,NULL,NULL),(131,'vietnguyen1990','vietnguyen1990@example.company','f68618d606f9a606a63f90bba87032ec',135,NULL,'Employee',NULL,'2020-03-10 11:34:51','2020-03-10 11:34:51','2020-03-10 11:34:51',NULL,NULL,NULL),(132,'dungle1990','dungle1990@example.company','50b9e32d96d45d36f8740ba48a548024',136,NULL,'Employee',NULL,'2020-03-10 11:34:51','2020-03-10 11:34:51','2020-03-10 11:34:51',NULL,NULL,NULL),(133,'quyennguyen1990','quyennguyen1990@example.company','f6148d5327b15487db953ec7f72052dd',137,NULL,'Employee',NULL,'2020-03-10 11:34:51','2020-03-10 11:34:51','2020-03-10 11:34:51',NULL,NULL,NULL),(134,'thachle1990','thachle1990@example.company','e13c6ef0c8d58c7988067b3dc3732487',138,NULL,'Employee',NULL,'2020-03-10 11:34:51','2020-03-10 11:34:51','2020-03-10 11:34:51',NULL,NULL,NULL),(135,'oanhle1990','oanhle1990@example.company','c7a5fab8448cd07ac502ce035096afab',139,NULL,'Employee',NULL,'2020-03-10 11:34:51','2020-03-10 11:34:51','2020-03-10 11:34:51',NULL,NULL,NULL),(136,'nhunguyen1990','nhunguyen1990@example.company','94d3c42e17d013c057c05170dcfbdaba',140,NULL,'Employee',NULL,'2020-03-10 11:34:51','2020-03-10 11:34:51','2020-03-10 11:34:51',NULL,NULL,NULL),(137,'quynhpham1990','quynhpham1990@example.company','0c62243577a7b2f4461a9bcc895ef833',141,NULL,'Employee',NULL,'2020-03-10 11:34:51','2020-03-10 11:34:51','2020-03-10 11:34:51',NULL,NULL,NULL),(138,'tanho1990','tanho1990@example.company','577674ea4feb9d9599856761420edfd1',142,NULL,'Employee',NULL,'2020-03-10 11:34:51','2020-03-10 11:34:51','2020-03-10 11:34:51',NULL,NULL,NULL),(139,'phutieu1990','phutieu1990@example.company','0eceb59a32a7009da09e39dea347028f',143,NULL,'Employee',NULL,'2020-03-10 11:34:51','2020-03-10 11:34:51','2020-03-10 11:34:51',NULL,NULL,NULL);
/*!40000 ALTER TABLE `Users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `WorkDays`
--

DROP TABLE IF EXISTS `WorkDays`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `WorkDays` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `status` enum('Full Day','Half Day','Non-working Day') DEFAULT 'Full Day',
  `country` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `workdays_name_country` (`name`,`country`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `WorkDays`
--

LOCK TABLES `WorkDays` WRITE;
/*!40000 ALTER TABLE `WorkDays` DISABLE KEYS */;
INSERT INTO `WorkDays` VALUES (1,'Monday','Full Day',NULL),(2,'Tuesday','Full Day',NULL),(3,'Wednesday','Full Day',NULL),(4,'Thursday','Full Day',NULL),(5,'Friday','Full Day',NULL),(6,'Saturday','Non-working Day',NULL),(7,'Sunday','Non-working Day',NULL);
/*!40000 ALTER TABLE `WorkDays` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-03-13 13:32:54
