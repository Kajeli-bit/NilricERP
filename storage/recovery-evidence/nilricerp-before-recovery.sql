-- MySQL dump 10.13  Distrib 8.0.32, for Linux (x86_64)
--
-- Host: localhost    Database: nilricerp
-- ------------------------------------------------------
-- Server version	8.0.32

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `banks`
--

DROP TABLE IF EXISTS `banks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `banks` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `street1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `street2` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `city` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `zip` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `state_id` bigint unsigned DEFAULT NULL,
  `country_id` bigint unsigned DEFAULT NULL,
  `creator_id` bigint unsigned NOT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `banks_state_id_foreign` (`state_id`),
  KEY `banks_country_id_foreign` (`country_id`),
  KEY `banks_creator_id_foreign` (`creator_id`),
  CONSTRAINT `banks_country_id_foreign` FOREIGN KEY (`country_id`) REFERENCES `countries` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `banks_creator_id_foreign` FOREIGN KEY (`creator_id`) REFERENCES `users` (`id`),
  CONSTRAINT `banks_state_id_foreign` FOREIGN KEY (`state_id`) REFERENCES `states` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `banks`
--

LOCK TABLES `banks` WRITE;
/*!40000 ALTER TABLE `banks` DISABLE KEYS */;
/*!40000 ALTER TABLE `banks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cache`
--

DROP TABLE IF EXISTS `cache`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cache` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cache`
--

LOCK TABLES `cache` WRITE;
/*!40000 ALTER TABLE `cache` DISABLE KEYS */;
/*!40000 ALTER TABLE `cache` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cache_locks`
--

DROP TABLE IF EXISTS `cache_locks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cache_locks` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `owner` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cache_locks`
--

LOCK TABLES `cache_locks` WRITE;
/*!40000 ALTER TABLE `cache_locks` DISABLE KEYS */;
/*!40000 ALTER TABLE `cache_locks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chatter_followers`
--

DROP TABLE IF EXISTS `chatter_followers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chatter_followers` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `followable_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `followable_id` bigint unsigned NOT NULL,
  `partner_id` bigint unsigned DEFAULT NULL,
  `followed_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `chatter_followers_unique` (`followable_type`,`followable_id`,`partner_id`),
  KEY `chatter_followers_followable_type_followable_id_index` (`followable_type`,`followable_id`),
  KEY `chatter_followers_partner_id_foreign` (`partner_id`),
  CONSTRAINT `chatter_followers_partner_id_foreign` FOREIGN KEY (`partner_id`) REFERENCES `partners_partners` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chatter_followers`
--

LOCK TABLES `chatter_followers` WRITE;
/*!40000 ALTER TABLE `chatter_followers` DISABLE KEYS */;
/*!40000 ALTER TABLE `chatter_followers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `companies`
--

DROP TABLE IF EXISTS `companies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `companies` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `parent_id` bigint unsigned DEFAULT NULL,
  `currency_id` bigint unsigned DEFAULT NULL,
  `creator_id` bigint unsigned DEFAULT NULL,
  `sort` int DEFAULT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `company_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tax_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `registration_number` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `mobile` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `website` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `color` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `founded_date` date DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `companies_company_id_unique` (`company_id`),
  UNIQUE KEY `companies_tax_id_unique` (`tax_id`),
  KEY `companies_parent_id_foreign` (`parent_id`),
  KEY `companies_currency_id_foreign` (`currency_id`),
  KEY `companies_creator_id_foreign` (`creator_id`),
  CONSTRAINT `companies_creator_id_foreign` FOREIGN KEY (`creator_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `companies_currency_id_foreign` FOREIGN KEY (`currency_id`) REFERENCES `currencies` (`id`) ON DELETE SET NULL,
  CONSTRAINT `companies_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `companies` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `companies`
--

LOCK TABLES `companies` WRITE;
/*!40000 ALTER TABLE `companies` DISABLE KEYS */;
/*!40000 ALTER TABLE `companies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `countries`
--

DROP TABLE IF EXISTS `countries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `countries` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `currency_id` bigint unsigned DEFAULT NULL,
  `phone_code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `code` varchar(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `state_required` tinyint(1) NOT NULL DEFAULT '0',
  `zip_required` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `countries_currency_id_foreign` (`currency_id`),
  CONSTRAINT `countries_currency_id_foreign` FOREIGN KEY (`currency_id`) REFERENCES `currencies` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `countries`
--

LOCK TABLES `countries` WRITE;
/*!40000 ALTER TABLE `countries` DISABLE KEYS */;
/*!40000 ALTER TABLE `countries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `currencies`
--

DROP TABLE IF EXISTS `currencies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `currencies` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `symbol` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `iso_numeric` int DEFAULT NULL,
  `decimal_places` tinyint DEFAULT NULL,
  `full_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rounding` decimal(8,2) NOT NULL DEFAULT '0.00',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `currencies`
--

LOCK TABLES `currencies` WRITE;
/*!40000 ALTER TABLE `currencies` DISABLE KEYS */;
/*!40000 ALTER TABLE `currencies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `custom_fields`
--

DROP TABLE IF EXISTS `custom_fields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `custom_fields` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `input_type` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_multiselect` tinyint(1) NOT NULL DEFAULT '0',
  `datalist` json DEFAULT NULL,
  `options` json DEFAULT NULL,
  `form_settings` json DEFAULT NULL,
  `use_in_table` tinyint(1) NOT NULL DEFAULT '0',
  `table_settings` json DEFAULT NULL,
  `infolist_settings` json DEFAULT NULL,
  `sort` int DEFAULT NULL,
  `customizable_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `custom_fields_code_customizable_type_unique` (`code`,`customizable_type`),
  KEY `custom_fields_code_index` (`code`),
  KEY `custom_fields_sort_index` (`sort`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `custom_fields`
--

LOCK TABLES `custom_fields` WRITE;
/*!40000 ALTER TABLE `custom_fields` DISABLE KEYS */;
/*!40000 ALTER TABLE `custom_fields` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employees_categories`
--

DROP TABLE IF EXISTS `employees_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employees_categories` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Name',
  `color` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Color',
  `creator_id` bigint unsigned DEFAULT NULL COMMENT 'Created by',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `employees_categories_name_unique` (`name`),
  KEY `employees_categories_creator_id_foreign` (`creator_id`),
  CONSTRAINT `employees_categories_creator_id_foreign` FOREIGN KEY (`creator_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employees_categories`
--

LOCK TABLES `employees_categories` WRITE;
/*!40000 ALTER TABLE `employees_categories` DISABLE KEYS */;
/*!40000 ALTER TABLE `employees_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employees_departments`
--

DROP TABLE IF EXISTS `employees_departments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employees_departments` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `company_id` bigint unsigned DEFAULT NULL,
  `parent_id` bigint unsigned DEFAULT NULL,
  `master_department_id` bigint unsigned DEFAULT NULL,
  `creator_id` bigint unsigned DEFAULT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `complete_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `parent_path` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `color` text COLLATE utf8mb4_unicode_ci,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `employees_departments_company_id_foreign` (`company_id`),
  KEY `employees_departments_parent_id_foreign` (`parent_id`),
  KEY `employees_departments_master_department_id_foreign` (`master_department_id`),
  KEY `employees_departments_creator_id_foreign` (`creator_id`),
  CONSTRAINT `employees_departments_company_id_foreign` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`) ON DELETE SET NULL,
  CONSTRAINT `employees_departments_creator_id_foreign` FOREIGN KEY (`creator_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `employees_departments_master_department_id_foreign` FOREIGN KEY (`master_department_id`) REFERENCES `employees_departments` (`id`) ON DELETE SET NULL,
  CONSTRAINT `employees_departments_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `employees_departments` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employees_departments`
--

LOCK TABLES `employees_departments` WRITE;
/*!40000 ALTER TABLE `employees_departments` DISABLE KEYS */;
/*!40000 ALTER TABLE `employees_departments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employees_departure_reasons`
--

DROP TABLE IF EXISTS `employees_departure_reasons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employees_departure_reasons` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `sort` int DEFAULT NULL COMMENT 'Sort Order',
  `reason_code` int DEFAULT NULL COMMENT 'Reason Code',
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Name',
  `creator_id` bigint unsigned DEFAULT NULL COMMENT 'Created By',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `employees_departure_reasons_creator_id_foreign` (`creator_id`),
  CONSTRAINT `employees_departure_reasons_creator_id_foreign` FOREIGN KEY (`creator_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employees_departure_reasons`
--

LOCK TABLES `employees_departure_reasons` WRITE;
/*!40000 ALTER TABLE `employees_departure_reasons` DISABLE KEYS */;
/*!40000 ALTER TABLE `employees_departure_reasons` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employees_employees`
--

DROP TABLE IF EXISTS `employees_employees`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employees_employees` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `time_zone` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Employee Timezone',
  `work_permit` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Work permit document',
  `address_id` bigint unsigned DEFAULT NULL COMMENT 'Company address ID',
  `leave_manager_id` bigint unsigned DEFAULT NULL COMMENT 'Leave manager ID',
  `bank_account_id` bigint unsigned DEFAULT NULL,
  `private_state_id` bigint unsigned DEFAULT NULL COMMENT 'Private State',
  `private_country_id` bigint unsigned DEFAULT NULL COMMENT 'Private Country',
  `company_id` bigint unsigned DEFAULT NULL COMMENT 'Company',
  `user_id` bigint unsigned DEFAULT NULL COMMENT 'Related user',
  `creator_id` bigint unsigned DEFAULT NULL COMMENT 'Created by',
  `calendar_id` bigint unsigned DEFAULT NULL COMMENT 'Calendar',
  `department_id` bigint unsigned DEFAULT NULL COMMENT 'Department',
  `job_id` bigint unsigned DEFAULT NULL COMMENT 'Job Position',
  `partner_id` bigint unsigned DEFAULT NULL COMMENT 'Partner',
  `work_location_id` bigint unsigned DEFAULT NULL COMMENT 'Work Location',
  `parent_id` bigint unsigned DEFAULT NULL COMMENT 'Parent',
  `coach_id` bigint unsigned DEFAULT NULL COMMENT 'Coach',
  `country_id` bigint unsigned DEFAULT NULL COMMENT 'Country',
  `state_id` bigint unsigned DEFAULT NULL COMMENT 'State',
  `country_of_birth` bigint unsigned DEFAULT NULL COMMENT 'Country of Birth',
  `departure_reason_id` bigint unsigned DEFAULT NULL COMMENT 'Departure Reason',
  `attendance_manager_id` bigint unsigned DEFAULT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Employee Name',
  `job_title` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Job Title',
  `work_phone` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Work Phone',
  `mobile_phone` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Mobile Phone',
  `color` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Color',
  `children` int DEFAULT NULL COMMENT 'Children',
  `distance_home_work` int DEFAULT '0' COMMENT 'Distance Home Work',
  `km_home_work` int DEFAULT '0' COMMENT 'Km Home Work',
  `distance_home_work_unit` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT 'km' COMMENT 'Distance Home Work Unit',
  `work_email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Work Email',
  `private_phone` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Private Phone',
  `private_email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Private Email',
  `private_street1` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Private Street 1',
  `private_street2` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Private Street 2',
  `private_city` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Private City',
  `private_zip` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Private Postcode',
  `private_car_plate` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Private Car Plate',
  `lang` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Language',
  `gender` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Gender',
  `birthday` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Birthday',
  `marital` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'single' COMMENT 'Marital status',
  `spouse_complete_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Spouse Complete Name',
  `spouse_birthdate` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Spouse Birthdate',
  `place_of_birth` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Place of Birth',
  `ssnid` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'SSN ID',
  `sinid` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'SIN ID',
  `identification_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Identification ID',
  `passport_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Passport ID',
  `permit_no` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Permit No',
  `visa_no` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Visa No',
  `certificate` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Certificate',
  `study_field` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Study Field',
  `study_school` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Study School',
  `emergency_contact` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Emergency Contact',
  `emergency_phone` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Emergency Phone',
  `employee_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'employee' COMMENT 'Employee Type',
  `barcode` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Barcode',
  `pin` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Pin',
  `visa_expire` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Visa Expire',
  `work_permit_expiration_date` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Work Permit Expiration Date',
  `departure_date` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Departure Date',
  `departure_description` text COLLATE utf8mb4_unicode_ci COMMENT 'Departure Description',
  `additional_note` text COLLATE utf8mb4_unicode_ci COMMENT 'Additional Note',
  `notes` text COLLATE utf8mb4_unicode_ci COMMENT 'Notes',
  `is_active` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Status',
  `is_flexible` tinyint(1) DEFAULT NULL COMMENT 'Is Flexible',
  `is_fully_flexible` tinyint(1) DEFAULT NULL COMMENT 'Is Fully Flexible',
  `work_permit_scheduled_activity` tinyint(1) DEFAULT NULL COMMENT 'Work Permit Scheduled Activity',
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `employees_employees_private_state_id_foreign` (`private_state_id`),
  KEY `employees_employees_private_country_id_foreign` (`private_country_id`),
  KEY `employees_employees_company_id_foreign` (`company_id`),
  KEY `employees_employees_user_id_foreign` (`user_id`),
  KEY `employees_employees_creator_id_foreign` (`creator_id`),
  CONSTRAINT `employees_employees_company_id_foreign` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`) ON DELETE SET NULL,
  CONSTRAINT `employees_employees_creator_id_foreign` FOREIGN KEY (`creator_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `employees_employees_private_country_id_foreign` FOREIGN KEY (`private_country_id`) REFERENCES `countries` (`id`) ON DELETE SET NULL,
  CONSTRAINT `employees_employees_private_state_id_foreign` FOREIGN KEY (`private_state_id`) REFERENCES `states` (`id`) ON DELETE SET NULL,
  CONSTRAINT `employees_employees_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employees_employees`
--

LOCK TABLES `employees_employees` WRITE;
/*!40000 ALTER TABLE `employees_employees` DISABLE KEYS */;
/*!40000 ALTER TABLE `employees_employees` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employees_employment_types`
--

DROP TABLE IF EXISTS `employees_employment_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employees_employment_types` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `sort` int DEFAULT NULL COMMENT 'Sort order',
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Employment type name',
  `code` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Employment type code',
  `country_id` bigint unsigned DEFAULT NULL,
  `creator_id` bigint unsigned DEFAULT NULL COMMENT 'Created by',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `employees_employment_types_country_id_foreign` (`country_id`),
  KEY `employees_employment_types_creator_id_foreign` (`creator_id`),
  CONSTRAINT `employees_employment_types_country_id_foreign` FOREIGN KEY (`country_id`) REFERENCES `countries` (`id`) ON DELETE SET NULL,
  CONSTRAINT `employees_employment_types_creator_id_foreign` FOREIGN KEY (`creator_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employees_employment_types`
--

LOCK TABLES `employees_employment_types` WRITE;
/*!40000 ALTER TABLE `employees_employment_types` DISABLE KEYS */;
/*!40000 ALTER TABLE `employees_employment_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employees_job_positions`
--

DROP TABLE IF EXISTS `employees_job_positions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employees_job_positions` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `sort` int DEFAULT NULL COMMENT 'Sort order',
  `expected_employees` int DEFAULT NULL COMMENT 'Expected Employees',
  `no_of_employee` int DEFAULT NULL COMMENT 'No of employees',
  `no_of_recruitment` int DEFAULT NULL COMMENT 'No of recruitment',
  `department_id` bigint unsigned DEFAULT NULL COMMENT 'Department',
  `company_id` bigint unsigned DEFAULT NULL COMMENT 'Company',
  `creator_id` bigint unsigned DEFAULT NULL COMMENT 'Created By',
  `employment_type_id` bigint unsigned DEFAULT NULL COMMENT 'Employment Type',
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Job Position Name',
  `description` text COLLATE utf8mb4_unicode_ci COMMENT 'Job Description',
  `requirements` text COLLATE utf8mb4_unicode_ci COMMENT 'Requirements',
  `is_active` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Active Status',
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `employees_job_positions_department_id_foreign` (`department_id`),
  KEY `employees_job_positions_creator_id_foreign` (`creator_id`),
  KEY `employees_job_positions_company_id_foreign` (`company_id`),
  KEY `employees_job_positions_employment_type_id_foreign` (`employment_type_id`),
  CONSTRAINT `employees_job_positions_company_id_foreign` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`) ON DELETE SET NULL,
  CONSTRAINT `employees_job_positions_creator_id_foreign` FOREIGN KEY (`creator_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `employees_job_positions_department_id_foreign` FOREIGN KEY (`department_id`) REFERENCES `employees_departments` (`id`) ON DELETE SET NULL,
  CONSTRAINT `employees_job_positions_employment_type_id_foreign` FOREIGN KEY (`employment_type_id`) REFERENCES `employees_employment_types` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employees_job_positions`
--

LOCK TABLES `employees_job_positions` WRITE;
/*!40000 ALTER TABLE `employees_job_positions` DISABLE KEYS */;
/*!40000 ALTER TABLE `employees_job_positions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employees_skill_levels`
--

DROP TABLE IF EXISTS `employees_skill_levels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employees_skill_levels` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Name',
  `level` int DEFAULT NULL COMMENT 'Level',
  `default_level` tinyint(1) DEFAULT NULL COMMENT 'Default Levell',
  `skill_type_id` bigint unsigned DEFAULT NULL COMMENT 'Skill Type',
  `creator_id` bigint unsigned DEFAULT NULL COMMENT 'Created by',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `employees_skill_levels_skill_type_id_index` (`skill_type_id`),
  KEY `employees_skill_levels_creator_id_index` (`creator_id`),
  CONSTRAINT `employees_skill_levels_creator_id_foreign` FOREIGN KEY (`creator_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `employees_skill_levels_skill_type_id_foreign` FOREIGN KEY (`skill_type_id`) REFERENCES `employees_skill_types` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employees_skill_levels`
--

LOCK TABLES `employees_skill_levels` WRITE;
/*!40000 ALTER TABLE `employees_skill_levels` DISABLE KEYS */;
/*!40000 ALTER TABLE `employees_skill_levels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employees_skill_types`
--

DROP TABLE IF EXISTS `employees_skill_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employees_skill_types` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Name',
  `color` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Color',
  `is_active` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Active Status',
  `creator_id` bigint unsigned DEFAULT NULL COMMENT 'Created By',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `employees_skill_types_creator_id_foreign` (`creator_id`),
  CONSTRAINT `employees_skill_types_creator_id_foreign` FOREIGN KEY (`creator_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employees_skill_types`
--

LOCK TABLES `employees_skill_types` WRITE;
/*!40000 ALTER TABLE `employees_skill_types` DISABLE KEYS */;
/*!40000 ALTER TABLE `employees_skill_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employees_skills`
--

DROP TABLE IF EXISTS `employees_skills`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employees_skills` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `sort` int DEFAULT NULL COMMENT 'Sort Order',
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Name',
  `skill_type_id` bigint unsigned DEFAULT NULL COMMENT 'Skill Type',
  `creator_id` bigint unsigned DEFAULT NULL COMMENT 'Created by',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `employees_skills_skill_type_id_index` (`skill_type_id`),
  KEY `employees_skills_creator_id_index` (`creator_id`),
  CONSTRAINT `employees_skills_creator_id_foreign` FOREIGN KEY (`creator_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `employees_skills_skill_type_id_foreign` FOREIGN KEY (`skill_type_id`) REFERENCES `employees_skill_types` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employees_skills`
--

LOCK TABLES `employees_skills` WRITE;
/*!40000 ALTER TABLE `employees_skills` DISABLE KEYS */;
/*!40000 ALTER TABLE `employees_skills` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employees_work_locations`
--

DROP TABLE IF EXISTS `employees_work_locations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employees_work_locations` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Work Location',
  `location_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Cover Image',
  `location_number` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Location Number',
  `is_active` tinyint(1) DEFAULT '0' COMMENT 'Status',
  `company_id` bigint unsigned NOT NULL COMMENT 'Company',
  `creator_id` bigint unsigned DEFAULT NULL COMMENT 'Created by',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `employees_work_locations_company_id_foreign` (`company_id`),
  KEY `employees_work_locations_creator_id_foreign` (`creator_id`),
  CONSTRAINT `employees_work_locations_company_id_foreign` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `employees_work_locations_creator_id_foreign` FOREIGN KEY (`creator_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employees_work_locations`
--

LOCK TABLES `employees_work_locations` WRITE;
/*!40000 ALTER TABLE `employees_work_locations` DISABLE KEYS */;
/*!40000 ALTER TABLE `employees_work_locations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `failed_jobs`
--

DROP TABLE IF EXISTS `failed_jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `failed_jobs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `failed_jobs`
--

LOCK TABLES `failed_jobs` WRITE;
/*!40000 ALTER TABLE `failed_jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `failed_jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `job_batches`
--

DROP TABLE IF EXISTS `job_batches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `job_batches` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_jobs` int NOT NULL,
  `pending_jobs` int NOT NULL,
  `failed_jobs` int NOT NULL,
  `failed_job_ids` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `options` mediumtext COLLATE utf8mb4_unicode_ci,
  `cancelled_at` int DEFAULT NULL,
  `created_at` int NOT NULL,
  `finished_at` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `job_batches`
--

LOCK TABLES `job_batches` WRITE;
/*!40000 ALTER TABLE `job_batches` DISABLE KEYS */;
/*!40000 ALTER TABLE `job_batches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `jobs`
--

DROP TABLE IF EXISTS `jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `jobs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `queue` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `attempts` tinyint unsigned NOT NULL,
  `reserved_at` int unsigned DEFAULT NULL,
  `available_at` int unsigned NOT NULL,
  `created_at` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `jobs_queue_index` (`queue`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jobs`
--

LOCK TABLES `jobs` WRITE;
/*!40000 ALTER TABLE `jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `migrations`
--

DROP TABLE IF EXISTS `migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `migrations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `migrations`
--

LOCK TABLES `migrations` WRITE;
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;
INSERT INTO `migrations` VALUES (1,'0001_01_01_000000_create_users_table',1),(2,'0001_01_01_000001_create_cache_table',1),(3,'0001_01_01_000002_create_jobs_table',1),(4,'2022_12_14_083707_create_settings_table',1),(5,'2024_11_04_132945_create_permission_tables',1),(6,'2024_11_05_042358_create_user_settings',1),(7,'2024_11_05_105102_create_plugins_table',1),(8,'2024_11_05_105112_create_plugin_dependencies_table',1),(9,'2024_11_11_112529_create_user_invitations_table',1),(10,'2024_11_12_125715_create_teams_table',1),(11,'2024_11_12_130019_create_user_team_table',1),(12,'2024_11_13_052541_create_custom_fields_table',1),(13,'2024_11_19_142134_create_table_views_table',1),(14,'2024_11_21_142134_create_table_view_favorites_table',1),(15,'2024_11_26_053234_add_resource_permission_column_to_users_table',1),(16,'2024_12_06_061927_create_currencies_table',1),(17,'2024_12_10_092651_create_countries_table',1),(18,'2024_12_10_092657_create_companies_table',1),(19,'2024_12_10_092657_create_states_table',1),(20,'2024_12_10_100944_create_user_allowed_companies_table',1),(21,'2024_12_10_101127_add_default_company_id_column_to_users_table',1),(22,'2024_12_10_101420_create_banks_table',1),(23,'2024_12_11_045350_create_employees_work_locations_table',1),(24,'2024_12_11_051916_create_employees_departments_table',1),(25,'2024_12_11_054555_create_employees_categories_table',1),(26,'2024_12_11_073130_create_employees_employment_types_table',1),(27,'2024_12_11_075004_create_employees_skill_types_table',1),(28,'2024_12_11_075011_create_employees_skill_levels_table',1),(29,'2024_12_11_075017_create_employees_skills_table',1),(30,'2024_12_11_081046_create_employees_job_positions_table',1),(31,'2024_12_11_101127_create_partners_industries_table',1),(32,'2024_12_11_101127_create_partners_titles_table',1),(33,'2024_12_11_101220_create_partners_partners_table',1),(34,'2024_12_11_101222_create_chatter_followers_table',1),(35,'2024_12_11_101420_create_partners_bank_accounts_table',1),(36,'2024_12_11_101927_create_partners_tags_table',1),(37,'2024_12_11_111929_create_partners_partner_tag_table',1),(38,'2024_12_11_120605_create_employees_departure_reasons_table',1);
/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `model_has_permissions`
--

DROP TABLE IF EXISTS `model_has_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `model_has_permissions` (
  `permission_id` bigint unsigned NOT NULL,
  `model_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `model_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`permission_id`,`model_id`,`model_type`),
  KEY `model_has_permissions_model_id_model_type_index` (`model_id`,`model_type`),
  CONSTRAINT `model_has_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `model_has_permissions`
--

LOCK TABLES `model_has_permissions` WRITE;
/*!40000 ALTER TABLE `model_has_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `model_has_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `model_has_roles`
--

DROP TABLE IF EXISTS `model_has_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `model_has_roles` (
  `role_id` bigint unsigned NOT NULL,
  `model_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `model_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`role_id`,`model_id`,`model_type`),
  KEY `model_has_roles_model_id_model_type_index` (`model_id`,`model_type`),
  CONSTRAINT `model_has_roles_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `model_has_roles`
--

LOCK TABLES `model_has_roles` WRITE;
/*!40000 ALTER TABLE `model_has_roles` DISABLE KEYS */;
/*!40000 ALTER TABLE `model_has_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `partners_bank_accounts`
--

DROP TABLE IF EXISTS `partners_bank_accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `partners_bank_accounts` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `account_number` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `account_holder_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `can_send_money` tinyint(1) NOT NULL DEFAULT '0',
  `creator_id` bigint unsigned DEFAULT NULL,
  `partner_id` bigint unsigned NOT NULL,
  `bank_id` bigint unsigned NOT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `partners_bank_accounts_account_number_unique` (`account_number`),
  KEY `partners_bank_accounts_creator_id_foreign` (`creator_id`),
  KEY `partners_bank_accounts_partner_id_foreign` (`partner_id`),
  KEY `partners_bank_accounts_bank_id_foreign` (`bank_id`),
  CONSTRAINT `partners_bank_accounts_bank_id_foreign` FOREIGN KEY (`bank_id`) REFERENCES `banks` (`id`) ON DELETE CASCADE,
  CONSTRAINT `partners_bank_accounts_creator_id_foreign` FOREIGN KEY (`creator_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `partners_bank_accounts_partner_id_foreign` FOREIGN KEY (`partner_id`) REFERENCES `partners_partners` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `partners_bank_accounts`
--

LOCK TABLES `partners_bank_accounts` WRITE;
/*!40000 ALTER TABLE `partners_bank_accounts` DISABLE KEYS */;
/*!40000 ALTER TABLE `partners_bank_accounts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `partners_industries`
--

DROP TABLE IF EXISTS `partners_industries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `partners_industries` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `creator_id` bigint unsigned DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `partners_industries_creator_id_foreign` (`creator_id`),
  CONSTRAINT `partners_industries_creator_id_foreign` FOREIGN KEY (`creator_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `partners_industries`
--

LOCK TABLES `partners_industries` WRITE;
/*!40000 ALTER TABLE `partners_industries` DISABLE KEYS */;
/*!40000 ALTER TABLE `partners_industries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `partners_partner_tag`
--

DROP TABLE IF EXISTS `partners_partner_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `partners_partner_tag` (
  `tag_id` bigint unsigned NOT NULL,
  `partner_id` bigint unsigned NOT NULL,
  KEY `partners_partner_tag_tag_id_foreign` (`tag_id`),
  KEY `partners_partner_tag_partner_id_foreign` (`partner_id`),
  CONSTRAINT `partners_partner_tag_partner_id_foreign` FOREIGN KEY (`partner_id`) REFERENCES `partners_partners` (`id`) ON DELETE CASCADE,
  CONSTRAINT `partners_partner_tag_tag_id_foreign` FOREIGN KEY (`tag_id`) REFERENCES `partners_tags` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `partners_partner_tag`
--

LOCK TABLES `partners_partner_tag` WRITE;
/*!40000 ALTER TABLE `partners_partner_tag` DISABLE KEYS */;
/*!40000 ALTER TABLE `partners_partner_tag` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `partners_partners`
--

DROP TABLE IF EXISTS `partners_partners`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `partners_partners` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `account_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'individual',
  `sub_type` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT 'partner',
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `avatar` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `job_title` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `website` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tax_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `mobile` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `color` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `company_registry` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `reference` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `parent_id` bigint unsigned DEFAULT NULL,
  `creator_id` bigint unsigned DEFAULT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  `title_id` bigint unsigned DEFAULT NULL,
  `company_id` bigint unsigned DEFAULT NULL,
  `industry_id` bigint unsigned DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `partners_partners_parent_id_foreign` (`parent_id`),
  KEY `partners_partners_creator_id_foreign` (`creator_id`),
  KEY `partners_partners_user_id_foreign` (`user_id`),
  KEY `partners_partners_title_id_foreign` (`title_id`),
  KEY `partners_partners_company_id_foreign` (`company_id`),
  KEY `partners_partners_industry_id_foreign` (`industry_id`),
  KEY `partners_partners_sub_type_index` (`sub_type`),
  KEY `partners_partners_name_index` (`name`),
  KEY `partners_partners_tax_id_index` (`tax_id`),
  KEY `partners_partners_phone_index` (`phone`),
  KEY `partners_partners_mobile_index` (`mobile`),
  KEY `partners_partners_company_registry_index` (`company_registry`),
  KEY `partners_partners_reference_index` (`reference`),
  CONSTRAINT `partners_partners_company_id_foreign` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`) ON DELETE SET NULL,
  CONSTRAINT `partners_partners_creator_id_foreign` FOREIGN KEY (`creator_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `partners_partners_industry_id_foreign` FOREIGN KEY (`industry_id`) REFERENCES `partners_industries` (`id`) ON DELETE SET NULL,
  CONSTRAINT `partners_partners_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `partners_partners` (`id`) ON DELETE SET NULL,
  CONSTRAINT `partners_partners_title_id_foreign` FOREIGN KEY (`title_id`) REFERENCES `partners_titles` (`id`) ON DELETE SET NULL,
  CONSTRAINT `partners_partners_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `partners_partners`
--

LOCK TABLES `partners_partners` WRITE;
/*!40000 ALTER TABLE `partners_partners` DISABLE KEYS */;
/*!40000 ALTER TABLE `partners_partners` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `partners_tags`
--

DROP TABLE IF EXISTS `partners_tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `partners_tags` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `color` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `creator_id` bigint unsigned DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `partners_tags_name_unique` (`name`),
  KEY `partners_tags_creator_id_foreign` (`creator_id`),
  CONSTRAINT `partners_tags_creator_id_foreign` FOREIGN KEY (`creator_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `partners_tags`
--

LOCK TABLES `partners_tags` WRITE;
/*!40000 ALTER TABLE `partners_tags` DISABLE KEYS */;
/*!40000 ALTER TABLE `partners_tags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `partners_titles`
--

DROP TABLE IF EXISTS `partners_titles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `partners_titles` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `short_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `creator_id` bigint unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `partners_titles_creator_id_foreign` (`creator_id`),
  CONSTRAINT `partners_titles_creator_id_foreign` FOREIGN KEY (`creator_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `partners_titles`
--

LOCK TABLES `partners_titles` WRITE;
/*!40000 ALTER TABLE `partners_titles` DISABLE KEYS */;
/*!40000 ALTER TABLE `partners_titles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_reset_tokens`
--

DROP TABLE IF EXISTS `password_reset_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_reset_tokens`
--

LOCK TABLES `password_reset_tokens` WRITE;
/*!40000 ALTER TABLE `password_reset_tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `password_reset_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permissions`
--

DROP TABLE IF EXISTS `permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `permissions` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `guard_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `permissions_name_guard_name_unique` (`name`,`guard_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permissions`
--

LOCK TABLES `permissions` WRITE;
/*!40000 ALTER TABLE `permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `plugin_dependencies`
--

DROP TABLE IF EXISTS `plugin_dependencies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `plugin_dependencies` (
  `plugin_id` bigint unsigned NOT NULL,
  `dependency_id` bigint unsigned NOT NULL,
  UNIQUE KEY `plugin_dependencies_plugin_id_dependency_id_unique` (`plugin_id`,`dependency_id`),
  KEY `plugin_dependencies_dependency_id_foreign` (`dependency_id`),
  CONSTRAINT `plugin_dependencies_dependency_id_foreign` FOREIGN KEY (`dependency_id`) REFERENCES `plugins` (`id`) ON DELETE CASCADE,
  CONSTRAINT `plugin_dependencies_plugin_id_foreign` FOREIGN KEY (`plugin_id`) REFERENCES `plugins` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `plugin_dependencies`
--

LOCK TABLES `plugin_dependencies` WRITE;
/*!40000 ALTER TABLE `plugin_dependencies` DISABLE KEYS */;
/*!40000 ALTER TABLE `plugin_dependencies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `plugins`
--

DROP TABLE IF EXISTS `plugins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `plugins` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `author` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `summary` text COLLATE utf8mb4_unicode_ci,
  `description` text COLLATE utf8mb4_unicode_ci,
  `latest_version` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `license` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '0',
  `is_installed` tinyint(1) NOT NULL DEFAULT '0',
  `sort` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `plugins_name_unique` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `plugins`
--

LOCK TABLES `plugins` WRITE;
/*!40000 ALTER TABLE `plugins` DISABLE KEYS */;
/*!40000 ALTER TABLE `plugins` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role_has_permissions`
--

DROP TABLE IF EXISTS `role_has_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role_has_permissions` (
  `permission_id` bigint unsigned NOT NULL,
  `role_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`permission_id`,`role_id`),
  KEY `role_has_permissions_role_id_foreign` (`role_id`),
  CONSTRAINT `role_has_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `role_has_permissions_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role_has_permissions`
--

LOCK TABLES `role_has_permissions` WRITE;
/*!40000 ALTER TABLE `role_has_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `role_has_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `guard_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `roles_name_guard_name_unique` (`name`,`guard_name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sessions` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text COLLATE utf8mb4_unicode_ci,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_activity` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sessions_user_id_index` (`user_id`),
  KEY `sessions_last_activity_index` (`last_activity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sessions`
--

LOCK TABLES `sessions` WRITE;
/*!40000 ALTER TABLE `sessions` DISABLE KEYS */;
/*!40000 ALTER TABLE `sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `settings`
--

DROP TABLE IF EXISTS `settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `settings` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `group` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `locked` tinyint(1) NOT NULL DEFAULT '0',
  `payload` json NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `settings_group_name_unique` (`group`,`name`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `settings`
--

LOCK TABLES `settings` WRITE;
/*!40000 ALTER TABLE `settings` DISABLE KEYS */;
INSERT INTO `settings` VALUES (1,'general','enable_user_invitation',0,'true','2026-10-30 15:37:49','2026-10-30 15:37:49'),(2,'general','enable_reset_password',0,'true','2026-10-30 15:37:49','2026-10-30 15:37:49'),(3,'general','default_role_id',0,'null','2026-10-30 15:37:49','2026-10-30 15:37:49'),(4,'general','default_company_id',0,'null','2026-10-30 15:37:49','2026-10-30 15:37:49');
/*!40000 ALTER TABLE `settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `states`
--

DROP TABLE IF EXISTS `states`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `states` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `country_id` bigint unsigned NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `code` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `states_country_id_foreign` (`country_id`),
  CONSTRAINT `states_country_id_foreign` FOREIGN KEY (`country_id`) REFERENCES `countries` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `states`
--

LOCK TABLES `states` WRITE;
/*!40000 ALTER TABLE `states` DISABLE KEYS */;
/*!40000 ALTER TABLE `states` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `table_view_favorites`
--

DROP TABLE IF EXISTS `table_view_favorites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `table_view_favorites` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `is_favorite` tinyint(1) NOT NULL DEFAULT '1',
  `view_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `view_key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `filterable_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `tbl_view_fav_unique` (`view_type`,`view_key`,`filterable_type`,`user_id`),
  KEY `table_view_favorites_user_id_foreign` (`user_id`),
  CONSTRAINT `table_view_favorites_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `table_view_favorites`
--

LOCK TABLES `table_view_favorites` WRITE;
/*!40000 ALTER TABLE `table_view_favorites` DISABLE KEYS */;
/*!40000 ALTER TABLE `table_view_favorites` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `table_views`
--

DROP TABLE IF EXISTS `table_views`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `table_views` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `icon` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `color` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_public` tinyint(1) NOT NULL DEFAULT '0',
  `filters` json DEFAULT NULL,
  `filterable_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `table_views_user_id_foreign` (`user_id`),
  CONSTRAINT `table_views_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `table_views`
--

LOCK TABLES `table_views` WRITE;
/*!40000 ALTER TABLE `table_views` DISABLE KEYS */;
/*!40000 ALTER TABLE `table_views` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `teams`
--

DROP TABLE IF EXISTS `teams`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `teams` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `teams`
--

LOCK TABLES `teams` WRITE;
/*!40000 ALTER TABLE `teams` DISABLE KEYS */;
/*!40000 ALTER TABLE `teams` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_allowed_companies`
--

DROP TABLE IF EXISTS `user_allowed_companies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_allowed_companies` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `company_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_allowed_companies_user_id_foreign` (`user_id`),
  KEY `user_allowed_companies_company_id_foreign` (`company_id`),
  CONSTRAINT `user_allowed_companies_company_id_foreign` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`) ON DELETE CASCADE,
  CONSTRAINT `user_allowed_companies_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_allowed_companies`
--

LOCK TABLES `user_allowed_companies` WRITE;
/*!40000 ALTER TABLE `user_allowed_companies` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_allowed_companies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_invitations`
--

DROP TABLE IF EXISTS `user_invitations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_invitations` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_invitations`
--

LOCK TABLES `user_invitations` WRITE;
/*!40000 ALTER TABLE `user_invitations` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_invitations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_team`
--

DROP TABLE IF EXISTS `user_team`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_team` (
  `user_id` bigint unsigned NOT NULL,
  `team_id` bigint unsigned NOT NULL,
  KEY `user_team_user_id_foreign` (`user_id`),
  KEY `user_team_team_id_foreign` (`team_id`),
  CONSTRAINT `user_team_team_id_foreign` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`) ON DELETE CASCADE,
  CONSTRAINT `user_team_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_team`
--

LOCK TABLES `user_team` WRITE;
/*!40000 ALTER TABLE `user_team` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_team` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `language` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `resource_permission` enum('group','individual','global') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'individual',
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `default_company_id` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`),
  KEY `users_default_company_id_foreign` (`default_company_id`),
  CONSTRAINT `users_default_company_id_foreign` FOREIGN KEY (`default_company_id`) REFERENCES `companies` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'nilricerp'
--

--
-- Dumping routines for database 'nilricerp'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-30 15:59:33
