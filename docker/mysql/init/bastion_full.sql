CREATE DATABASE IF NOT EXISTS bastion CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE bastion;

-- MySQL dump 10.13  Distrib 9.3.0, for macos14.7 (x86_64)
--
-- Database: bastion
-- ------------------------------------------------------
-- Server version	8.0.42

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
-- Table structure for table `asset_credentials`
--

DROP TABLE IF EXISTS `asset_credentials`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `asset_credentials` (
  `asset_id` bigint unsigned NOT NULL,
  `credential_id` bigint unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`asset_id`,`credential_id`),
  KEY `idx_asset_id` (`asset_id`),
  KEY `idx_credential_id` (`credential_id`),
  CONSTRAINT `fk_asset_credentials_asset` FOREIGN KEY (`asset_id`) REFERENCES `assets` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_asset_credentials_credential` FOREIGN KEY (`credential_id`) REFERENCES `credentials` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='资产凭证关联表 - 多对多关系';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `asset_credentials`
--

LOCK TABLES `asset_credentials` WRITE;
/*!40000 ALTER TABLE `asset_credentials` DISABLE KEYS */;
INSERT INTO `asset_credentials` VALUES (1,1,'2025-07-19 08:51:29'),(2,1,'2025-07-19 08:51:52'),(3,1,'2025-07-21 09:35:33');
/*!40000 ALTER TABLE `asset_credentials` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `asset_groups`
--

DROP TABLE IF EXISTS `asset_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `asset_groups` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'general' COMMENT '分组类型: production, test, dev, general',
  `parent_id` bigint unsigned DEFAULT NULL COMMENT '父分组ID',
  `sort_order` int DEFAULT '0' COMMENT '排序字段',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_asset_group_name` (`name`),
  KEY `idx_asset_groups_parent_id` (`parent_id`),
  KEY `idx_asset_groups_type` (`type`),
  KEY `idx_deleted_at` (`deleted_at`),
  CONSTRAINT `fk_asset_groups_parent` FOREIGN KEY (`parent_id`) REFERENCES `asset_groups` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='资产分组表 - 支持层级结构的资产分组';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `asset_groups`
--

LOCK TABLES `asset_groups` WRITE;
/*!40000 ALTER TABLE `asset_groups` DISABLE KEYS */;
INSERT INTO `asset_groups` VALUES (1,'生产环境','生产环境资产分组','production',NULL,1,'2025-07-19 08:49:17','2025-07-19 08:49:17',NULL),(2,'测试环境','测试环境资产分组','test',NULL,2,'2025-07-19 08:49:17','2025-07-19 08:49:17',NULL),(3,'开发环境','开发环境资产分组','dev',NULL,3,'2025-07-19 08:49:17','2025-07-19 08:49:17',NULL),(4,'通用分组','通用资产分组','general',NULL,4,'2025-07-19 08:49:17','2025-08-03 10:31:42','2025-08-03 18:31:42'),(5,'Web服务器','Web服务器分组','production',1,1,'2025-07-19 08:49:17','2025-07-19 08:49:17',NULL),(6,'应用服务器','应用服务器分组','production',1,2,'2025-07-19 08:49:17','2025-07-19 08:49:17',NULL),(7,'数据库服务器','数据库服务器分组','production',1,3,'2025-07-19 08:49:17','2025-07-19 08:49:17',NULL),(8,'测试服务器','测试服务器分组','test',2,1,'2025-07-19 08:49:17','2025-07-19 08:49:17',NULL),(9,'开发服务器','开发服务器分组','dev',3,1,'2025-07-19 08:49:17','2025-07-19 08:49:17',NULL),(10,'AI 服务器','测试','general',NULL,0,'2025-08-03 18:38:38','2025-08-03 18:38:38',NULL);
/*!40000 ALTER TABLE `asset_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `assets`
--

DROP TABLE IF EXISTS `assets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `assets` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'server' COMMENT '资产类型: server, database',
  `os_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'linux' COMMENT '操作系统类型: linux, windows',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `port` int DEFAULT '22',
  `protocol` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'ssh' COMMENT '协议: ssh, rdp, vnc, mysql, postgresql',
  `tags` json DEFAULT NULL,
  `status` tinyint DEFAULT '1' COMMENT '状态: 1-启用, 0-禁用',
  `group_id` bigint unsigned DEFAULT NULL COMMENT '资产分组ID',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_type` (`type`),
  KEY `idx_protocol` (`protocol`),
  KEY `idx_status` (`status`),
  KEY `idx_assets_group_id` (`group_id`),
  KEY `idx_deleted_at` (`deleted_at`),
  CONSTRAINT `fk_assets_group_id` FOREIGN KEY (`group_id`) REFERENCES `asset_groups` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='资产表 - 存储服务器和数据库等资产';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `assets`
--

LOCK TABLES `assets` WRITE;
/*!40000 ALTER TABLE `assets` DISABLE KEYS */;
INSERT INTO `assets` VALUES (1,'SSH测试服务器1','server','linux','172.20.0.10',22,'ssh','{"tags": "test"}',1,1,'2025-07-19 16:51:11','2025-07-22 22:01:22',NULL),(2,'SSH测试服务器2','server','linux','172.20.0.11',22,'ssh','{"tags": "test"}',1,5,'2025-07-21 17:35:32','2025-07-22 22:02:36',NULL);
/*!40000 ALTER TABLE `assets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `audit_statistics`
--

DROP TABLE IF EXISTS `audit_statistics`;
/*!50001 DROP VIEW IF EXISTS `audit_statistics`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `audit_statistics` AS SELECT 
 1 AS `total_login_logs`,
 1 AS `total_operation_logs`,
 1 AS `total_session_records`,
 1 AS `total_command_logs`,
 1 AS `failed_logins`,
 1 AS `active_sessions`,
 1 AS `dangerous_commands`,
 1 AS `today_logins`,
 1 AS `today_operations`,
 1 AS `today_sessions`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `command_filter_logs`
--

DROP TABLE IF EXISTS `command_filter_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `command_filter_logs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `session_id` varchar(100) NOT NULL COMMENT 'SSH会话ID',
  `user_id` bigint unsigned NOT NULL COMMENT '用户ID',
  `username` varchar(50) NOT NULL COMMENT '用户名',
  `asset_id` bigint unsigned NOT NULL COMMENT '资产ID',
  `asset_name` varchar(100) NOT NULL COMMENT '资产名称',
  `account` varchar(50) NOT NULL COMMENT '登录账号',
  `command` text NOT NULL COMMENT '执行的命令',
  `filter_id` bigint unsigned NOT NULL COMMENT '触发的过滤规则ID',
  `filter_name` varchar(100) NOT NULL COMMENT '过滤规则名称',
  `action` varchar(20) NOT NULL COMMENT '执行的动作',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_session_id` (`session_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_asset_id` (`asset_id`),
  KEY `idx_filter_id` (`filter_id`),
  KEY `idx_created_at` (`created_at`),
  KEY `idx_cfl_user_asset` (`user_id`,`asset_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='命令过滤日志表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `command_filter_logs`
--

LOCK TABLES `command_filter_logs` WRITE;
/*!40000 ALTER TABLE `command_filter_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `command_filter_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `command_filters`
--

DROP TABLE IF EXISTS `command_filters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `command_filters` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL COMMENT '过滤规则名称',
  `priority` int NOT NULL DEFAULT '50' COMMENT '优先级，1-100，数字越小优先级越高',
  `enabled` tinyint(1) DEFAULT '1' COMMENT '是否启用',
  `user_type` varchar(20) NOT NULL DEFAULT 'all' COMMENT '用户类型: all-全部, specific-指定, attribute-属性',
  `asset_type` varchar(20) NOT NULL DEFAULT 'all' COMMENT '资产类型: all-全部, specific-指定, attribute-属性',
  `account_type` varchar(20) NOT NULL DEFAULT 'all' COMMENT '账号类型: all-全部, specific-指定',
  `account_names` varchar(500) DEFAULT NULL COMMENT '指定账号名称，逗号分隔',
  `command_group_id` bigint unsigned NOT NULL COMMENT '关联的命令组ID',
  `action` varchar(20) NOT NULL COMMENT '动作: deny-拒绝, allow-接受, alert-告警, prompt_alert-提示并告警',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_priority_enabled` (`priority`,`enabled`),
  KEY `idx_command_group_id` (`command_group_id`),
  KEY `idx_deleted_at` (`deleted_at`),
  KEY `idx_cf_user_type` (`user_type`),
  KEY `idx_cf_asset_type` (`asset_type`),
  KEY `idx_cf_account_type` (`account_type`),
  CONSTRAINT `fk_cf_command_group` FOREIGN KEY (`command_group_id`) REFERENCES `command_groups` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='命令过滤规则表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `command_filters`
--

LOCK TABLES `command_filters` WRITE;
/*!40000 ALTER TABLE `command_filters` DISABLE KEYS */;
INSERT INTO `command_filters` VALUES (1,'快速测试规则',50,1,'all','all','all','',2,'deny','测试规则 - 2025-07-30 17:25:47','2025-07-30 17:25:48','2025-07-30 09:25:48','2025-07-30 17:25:48'),(2,'禁止执行危险命令',10,1,'all','all','all','',3,'deny','测试规则 - 2025-07-30 17:26:11','2025-07-30 17:26:11','2025-07-30 09:26:12','2025-07-30 17:26:12'),(3,'警告网络命令',20,1,'all','all','all','',4,'alert','测试规则 - 2025-07-30 17:26:11','2025-07-30 17:26:11','2025-07-30 15:52:04','2025-07-30 23:52:04'),(4,'禁止执行危险命令',10,1,'all','all','all','',13,'deny','测试规则 - 2025-07-30 21:16:06','2025-07-30 21:16:07','2025-07-30 13:16:08','2025-07-30 21:16:08'),(5,'测试规则',50,1,'specific','specific','specific','root',19,'deny','','2025-07-31 09:40:25','2025-08-02 18:24:52',NULL);
/*!40000 ALTER TABLE `command_filters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `command_group_items`
--

DROP TABLE IF EXISTS `command_group_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `command_group_items` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `command_group_id` bigint unsigned NOT NULL COMMENT '所属命令组ID',
  `type` varchar(20) NOT NULL DEFAULT 'command' COMMENT '类型: command-命令, regex-正则表达式',
  `content` varchar(500) NOT NULL COMMENT '命令内容或正则表达式',
  `ignore_case` tinyint(1) DEFAULT '0' COMMENT '是否忽略大小写',
  `sort_order` int DEFAULT '0' COMMENT '排序顺序',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_command_group_id` (`command_group_id`),
  KEY `idx_content` (`content`(100)),
  KEY `idx_cgi_type_content` (`type`,`content`(100)),
  CONSTRAINT `fk_cgi_command_group` FOREIGN KEY (`command_group_id`) REFERENCES `command_groups` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='命令组项表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `command_group_items`
--

LOCK TABLES `command_group_items` WRITE;
/*!40000 ALTER TABLE `command_group_items` DISABLE KEYS */;
INSERT INTO `command_group_items` VALUES (1,1,'command','rm -rf',0,1,'2025-07-30 07:27:11'),(2,1,'command','shutdown',0,2,'2025-07-30 07:27:11'),(3,1,'command','reboot',0,3,'2025-07-30 07:27:11'),(4,1,'regex','^dd\\s+if=',0,4,'2025-07-30 07:27:11'),(5,1,'regex','^mkfs',0,5,'2025-07-30 07:27:11'),(6,2,'command','test',0,1,'2025-07-30 17:25:48'),(10,4,'command','iptables',0,1,'2025-07-30 17:26:11'),(11,4,'command','firewall-cmd',0,2,'2025-07-30 17:26:11'),(12,4,'regex','^nc\\s+',1,3,'2025-07-30 17:26:11'),(13,3,'command','rm',0,1,'2025-07-30 17:26:11'),(14,3,'command','reboot',0,2,'2025-07-30 17:26:11'),(15,3,'regex','^rm\\s+-rf',0,3,'2025-07-30 17:26:11'),(16,3,'command','shutdown',0,4,'2025-07-30 17:26:11'),(17,5,'command','test',0,1,'2025-07-30 17:26:12'),(18,6,'command','cmd0',0,1,'2025-07-30 17:26:12'),(19,7,'command','cmd1',0,1,'2025-07-30 17:26:12'),(20,8,'command','cmd2',0,1,'2025-07-30 17:26:12'),(21,9,'command','cmd3',0,1,'2025-07-30 17:26:12'),(22,10,'command','cmd4',0,1,'2025-07-30 17:26:12'),(23,13,'command','rm',0,1,'2025-07-30 21:16:07'),(24,13,'command','reboot',0,2,'2025-07-30 21:16:07'),(25,13,'regex','^rm\\s+-rf',0,3,'2025-07-30 21:16:07'),(28,19,'command','rm',0,0,'2025-08-01 20:51:04'),(29,19,'command','shutdown',0,1,'2025-08-01 20:51:04');
/*!40000 ALTER TABLE `command_group_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `command_groups`
--

DROP TABLE IF EXISTS `command_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `command_groups` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL COMMENT '命令组名称',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_name` (`name`),
  KEY `idx_deleted_at` (`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='命令组表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `command_groups`
--

LOCK TABLES `command_groups` WRITE;
/*!40000 ALTER TABLE `command_groups` DISABLE KEYS */;
INSERT INTO `command_groups` VALUES (1,'危险命令示例','包含一些常见的危险命令，仅供参考','2025-07-30 07:27:11','2025-07-30 15:51:48','2025-07-30 23:51:48'),(2,'快速测试组','测试命令组 - 2025-07-30 17:25:47','2025-07-30 17:25:48','2025-07-30 09:25:48','2025-07-30 17:25:48'),(3,'危险命令组_更新','测试命令组 - 2025-07-30 17:26:11','2025-07-30 17:26:11','2025-07-30 09:26:12','2025-07-30 17:26:12'),(4,'网络命令组_测试','测试命令组 - 2025-07-30 17:26:11','2025-07-30 17:26:11','2025-07-30 15:52:33','2025-07-30 23:52:34'),(5,'导入测试命令组','通过导入功能创建','2025-07-30 17:26:12','2025-07-30 15:51:43','2025-07-30 23:51:43'),(6,'性能测试组_0','测试命令组 - 2025-07-30 17:26:11','2025-07-30 17:26:12','2025-07-30 09:26:12','2025-07-30 17:26:12'),(7,'性能测试组_1','测试命令组 - 2025-07-30 17:26:11','2025-07-30 17:26:12','2025-07-30 09:26:12','2025-07-30 17:26:12'),(8,'性能测试组_2','测试命令组 - 2025-07-30 17:26:11','2025-07-30 17:26:12','2025-07-30 09:26:12','2025-07-30 17:26:12'),(9,'性能测试组_3','测试命令组 - 2025-07-30 17:26:11','2025-07-30 17:26:12','2025-07-30 09:26:12','2025-07-30 17:26:12'),(10,'性能测试组_4','测试命令组 - 2025-07-30 17:26:11','2025-07-30 17:26:12','2025-07-30 09:26:12','2025-07-30 17:26:12'),(13,'危险命令组_测试','测试命令组 - 2025-07-30 21:16:06','2025-07-30 21:16:07','2025-07-30 13:16:08','2025-07-30 21:16:08'),(19,'危险命令','','2025-07-30 23:52:54','2025-08-01 20:51:04',NULL);
/*!40000 ALTER TABLE `command_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `command_logs`
--

DROP TABLE IF EXISTS `command_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `command_logs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `session_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `asset_id` bigint unsigned NOT NULL,
  `command` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `output` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `exit_code` int DEFAULT NULL,
  `risk` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'low' COMMENT '风险等级: low, medium, high',
  `start_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `end_time` timestamp NULL DEFAULT NULL,
  `duration` bigint DEFAULT NULL COMMENT '命令执行时间，毫秒',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `action` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'allow' COMMENT '命令过滤动作: block-阻断, allow-放行, warning-警告',
  PRIMARY KEY (`id`),
  KEY `idx_session_id` (`session_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_username` (`username`),
  KEY `idx_asset_id` (`asset_id`),
  KEY `idx_risk` (`risk`),
  KEY `idx_start_time` (`start_time`),
  KEY `idx_created_at` (`created_at`),
  KEY `idx_deleted_at` (`deleted_at`),
  KEY `idx_command_logs_action` (`action`),
  CONSTRAINT `fk_command_logs_asset` FOREIGN KEY (`asset_id`) REFERENCES `assets` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_command_logs_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='命令日志表 - 记录用户在会话中执行的命令';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `command_logs`
--

LOCK TABLES `command_logs` WRITE;
/*!40000 ALTER TABLE `command_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `command_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `credentials`
--

DROP TABLE IF EXISTS `credentials`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `credentials` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'password' COMMENT '凭证类型: password, key',
  `username` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `private_key` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_type` (`type`),
  KEY `idx_deleted_at` (`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='凭证表 - 存储访问资产的认证信息';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `credentials`
--

LOCK TABLES `credentials` WRITE;
/*!40000 ALTER TABLE `credentials` DISABLE KEYS */;
INSERT INTO `credentials` VALUES (1,'管理员','password','root','igsPz4zo3vszSMbtVBrWNRuPlR/qdrWcOHF+WhTZwg==','','2025-07-19 16:51:29','2025-07-21 19:39:22',NULL);
/*!40000 ALTER TABLE `credentials` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `filter_assets`
--

DROP TABLE IF EXISTS `filter_assets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `filter_assets` (
  `filter_id` bigint unsigned NOT NULL COMMENT '过滤规则ID',
  `asset_id` bigint unsigned NOT NULL COMMENT '资产ID',
  PRIMARY KEY (`filter_id`,`asset_id`),
  KEY `idx_asset_id` (`asset_id`),
  CONSTRAINT `fk_fa_asset` FOREIGN KEY (`asset_id`) REFERENCES `assets` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_fa_filter` FOREIGN KEY (`filter_id`) REFERENCES `command_filters` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='过滤规则资产关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `filter_assets`
--

LOCK TABLES `filter_assets` WRITE;
/*!40000 ALTER TABLE `filter_assets` DISABLE KEYS */;
INSERT INTO `filter_assets` VALUES (5,1);
/*!40000 ALTER TABLE `filter_assets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `filter_attributes`
--

DROP TABLE IF EXISTS `filter_attributes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `filter_attributes` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `filter_id` bigint unsigned NOT NULL COMMENT '过滤规则ID',
  `target_type` varchar(20) NOT NULL COMMENT '目标类型: user-用户属性, asset-资产属性',
  `attribute_name` varchar(50) NOT NULL COMMENT '属性名称',
  `attribute_value` varchar(200) NOT NULL COMMENT '属性值',
  PRIMARY KEY (`id`),
  KEY `idx_filter_id` (`filter_id`),
  KEY `idx_target_attribute` (`target_type`,`attribute_name`),
  CONSTRAINT `fk_fattr_filter` FOREIGN KEY (`filter_id`) REFERENCES `command_filters` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='过滤规则属性表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `filter_attributes`
--

LOCK TABLES `filter_attributes` WRITE;
/*!40000 ALTER TABLE `filter_attributes` DISABLE KEYS */;
/*!40000 ALTER TABLE `filter_attributes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `filter_users`
--

DROP TABLE IF EXISTS `filter_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `filter_users` (
  `filter_id` bigint unsigned NOT NULL COMMENT '过滤规则ID',
  `user_id` bigint unsigned NOT NULL COMMENT '用户ID',
  PRIMARY KEY (`filter_id`,`user_id`),
  KEY `idx_user_id` (`user_id`),
  CONSTRAINT `fk_fu_filter` FOREIGN KEY (`filter_id`) REFERENCES `command_filters` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_fu_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='过滤规则用户关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `filter_users`
--

LOCK TABLES `filter_users` WRITE;
/*!40000 ALTER TABLE `filter_users` DISABLE KEYS */;
INSERT INTO `filter_users` VALUES (5,1);
/*!40000 ALTER TABLE `filter_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `login_logs`
--

DROP TABLE IF EXISTS `login_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `login_logs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `ip` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_agent` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `method` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'web',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'success, failed, logout',
  `message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_username` (`username`),
  KEY `idx_ip` (`ip`),
  KEY `idx_status` (`status`),
  KEY `idx_created_at` (`created_at`),
  KEY `idx_deleted_at` (`deleted_at`),
  CONSTRAINT `fk_login_logs_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='登录日志表 - 记录用户登录、登出和登录失败记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `login_logs`
--

LOCK TABLES `login_logs` WRITE;
/*!40000 ALTER TABLE `login_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `login_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `operation_logs`
--

DROP TABLE IF EXISTS `operation_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `operation_logs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `ip` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `method` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'HTTP方法: GET, POST, PUT, DELETE',
  `url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `action` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '操作类型: create, read, update, delete',
  `resource` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '资源类型: user, role, asset, session',
  `resource_id` bigint unsigned DEFAULT NULL COMMENT '资源ID',
  `session_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '完整会话标识符',
  `status` int NOT NULL COMMENT 'HTTP状态码',
  `message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `request_data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `response_data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `duration` bigint DEFAULT NULL COMMENT '请求耗时，毫秒',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_username` (`username`),
  KEY `idx_ip` (`ip`),
  KEY `idx_method` (`method`),
  KEY `idx_action` (`action`),
  KEY `idx_resource` (`resource`),
  KEY `idx_resource_id` (`resource_id`),
  KEY `idx_status` (`status`),
  KEY `idx_created_at` (`created_at`),
  KEY `idx_deleted_at` (`deleted_at`),
  KEY `idx_operation_logs_user_time` (`user_id`,`created_at`),
  KEY `idx_operation_logs_session_id` (`session_id`),
  CONSTRAINT `fk_operation_logs_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='操作日志表 - 记录用户在系统中的所有操作';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `operation_logs`
--

LOCK TABLES `operation_logs` WRITE;
/*!40000 ALTER TABLE `operation_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `operation_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permissions`
--

DROP TABLE IF EXISTS `permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `permissions` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `category` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_permission_name` (`name`),
  KEY `idx_category` (`category`),
  KEY `idx_deleted_at` (`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='权限表 - 存储系统权限定义';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permissions`
--

LOCK TABLES `permissions` WRITE;
/*!40000 ALTER TABLE `permissions` DISABLE KEYS */;
INSERT INTO `permissions` VALUES (1,'user:create','创建用户','user','2025-07-19 08:49:17','2025-07-19 08:49:17',NULL),(2,'user:read','查看用户','user','2025-07-19 08:49:17','2025-07-19 08:49:17',NULL),(3,'user:update','更新用户','user','2025-07-19 08:49:17','2025-07-19 08:49:17',NULL),(4,'user:delete','删除用户','user','2025-07-19 08:49:17','2025-07-19 08:49:17',NULL),(5,'role:create','创建角色','role','2025-07-19 08:49:17','2025-07-19 08:49:17',NULL),(6,'role:read','查看角色','role','2025-07-19 08:49:17','2025-07-19 08:49:17',NULL),(7,'role:update','更新角色','role','2025-07-19 08:49:17','2025-07-19 08:49:17',NULL),(8,'role:delete','删除角色','role','2025-07-19 08:49:17','2025-07-19 08:49:17',NULL),(9,'asset:create','创建资产','asset','2025-07-19 08:49:17','2025-07-19 08:49:17',NULL),(10,'asset:read','查看资产','asset','2025-07-19 08:49:17','2025-07-19 08:49:17',NULL),(11,'asset:update','更新资产','asset','2025-07-19 08:49:17','2025-07-19 08:49:17',NULL),(12,'asset:delete','删除资产','asset','2025-07-19 08:49:17','2025-07-19 08:49:17',NULL),(13,'asset:connect','连接资产','asset','2025-07-19 08:49:17','2025-07-19 08:49:17',NULL),(14,'audit:read','查看审计日志','audit','2025-07-19 08:49:17','2025-07-19 08:49:17',NULL),(15,'audit:cleanup','清理审计日志','audit','2025-07-19 08:49:17','2025-07-19 08:49:17',NULL),(16,'audit:monitor','实时监控权限','audit','2025-07-19 08:49:17','2025-07-19 08:49:17',NULL),(17,'audit:terminate','会话终止权限','audit','2025-07-19 08:49:17','2025-07-19 08:49:17',NULL),(18,'audit:warning','发送警告权限','audit','2025-07-19 08:49:17','2025-07-19 08:49:17',NULL),(19,'login_logs:read','查看登录日志','audit','2025-07-19 08:49:17','2025-07-19 08:49:17',NULL),(20,'operation_logs:read','查看操作日志','audit','2025-07-19 08:49:17','2025-07-19 08:49:17',NULL),(21,'session_records:read','查看会话记录','audit','2025-07-19 08:49:17','2025-07-19 08:49:17',NULL),(22,'command_logs:read','查看命令日志','audit','2025-07-19 08:49:17','2025-07-19 08:49:17',NULL),(23,'session:read','查看会话','session','2025-07-19 08:49:17','2025-07-19 08:49:17',NULL),(24,'log:read','查看日志','log','2025-07-19 08:49:17','2025-07-19 08:49:17',NULL),(25,'all','所有权限','system','2025-07-19 08:49:17','2025-07-19 08:49:17',NULL),(26,'recording:view','查看会话录制列表和详情','recording','2025-07-19 18:18:14','2025-07-19 18:18:14',NULL),(27,'recording:download','下载录制文件','recording','2025-07-19 18:18:14','2025-07-19 18:18:14',NULL),(28,'recording:delete','删除录制记录和文件','recording','2025-07-19 18:18:14','2025-07-19 18:18:14',NULL),(29,'recording:config','管理录制配置','recording','2025-07-19 18:18:14','2025-07-19 18:18:14',NULL),(32,'command_filter:read','查看命令过滤','access_control','2025-07-30 07:27:10','2025-07-30 07:27:10',NULL),(33,'command_filter:write','管理命令过滤','access_control','2025-07-30 07:27:10','2025-07-30 07:27:10',NULL);
/*!40000 ALTER TABLE `permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recording_configs`
--

DROP TABLE IF EXISTS `recording_configs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recording_configs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL COMMENT '配置名称',
  `description` text COMMENT '配置描述',
  `enabled` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否启用',
  `auto_recording` tinyint(1) NOT NULL DEFAULT '1' COMMENT '自动录制',
  `formats` varchar(255) DEFAULT 'asciicast' COMMENT '录制格式',
  `compression_enabled` tinyint(1) NOT NULL DEFAULT '1' COMMENT '启用压缩',
  `compression_level` int DEFAULT '6' COMMENT '压缩级别(1-9)',
  `max_file_size` bigint DEFAULT '0' COMMENT '最大文件大小(字节,0为无限制)',
  `max_duration` bigint DEFAULT '0' COMMENT '最大录制时长(秒,0为无限制)',
  `storage_path` varchar(500) DEFAULT '/var/bastion/recordings' COMMENT '存储路径',
  `retention_days` int DEFAULT '30' COMMENT '保留天数',
  `cloud_storage_enabled` tinyint(1) NOT NULL DEFAULT '0' COMMENT '启用云存储',
  `cloud_storage_config` text COMMENT '云存储配置(JSON)',
  `user_filters` text COMMENT '用户过滤器(JSON)',
  `asset_filters` text COMMENT '资产过滤器(JSON)',
  `permission_filters` text COMMENT '权限过滤器(JSON)',
  `created_by` bigint unsigned NOT NULL COMMENT '创建者ID',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_name` (`name`),
  KEY `idx_enabled` (`enabled`),
  KEY `idx_created_by` (`created_by`),
  KEY `idx_deleted_at` (`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='录制配置表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recording_configs`
--

LOCK TABLES `recording_configs` WRITE;
/*!40000 ALTER TABLE `recording_configs` DISABLE KEYS */;
INSERT INTO `recording_configs` VALUES (1,'default','默认录制配置',1,1,'asciicast',1,6,104857600,7200,'/var/bastion/recordings',30,0,NULL,NULL,NULL,NULL,1,'2025-07-19 18:17:50','2025-07-19 18:18:14',NULL);
/*!40000 ALTER TABLE `recording_configs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role_permissions`
--

DROP TABLE IF EXISTS `role_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role_permissions` (
  `role_id` bigint unsigned NOT NULL,
  `permission_id` bigint unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`role_id`,`permission_id`),
  KEY `idx_role_id` (`role_id`),
  KEY `idx_permission_id` (`permission_id`),
  CONSTRAINT `fk_role_permissions_permission` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_role_permissions_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色权限关联表 - 多对多关系';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role_permissions`
--

LOCK TABLES `role_permissions` WRITE;
/*!40000 ALTER TABLE `role_permissions` DISABLE KEYS */;
INSERT INTO `role_permissions` VALUES (1,25,'2025-07-19 08:49:17'),(1,26,'2025-07-19 18:18:14'),(1,27,'2025-07-19 18:18:14'),(1,28,'2025-07-19 18:18:14'),(1,29,'2025-07-19 18:18:14'),(1,32,'2025-07-30 07:27:10'),(1,33,'2025-07-30 07:27:10'),(2,10,'2025-07-19 08:49:17'),(2,13,'2025-07-19 08:49:17'),(2,23,'2025-07-19 08:49:17'),(3,14,'2025-07-19 08:49:17'),(3,16,'2025-07-19 08:49:17'),(3,19,'2025-07-19 08:49:17'),(3,20,'2025-07-19 08:49:17'),(3,21,'2025-07-19 08:49:17'),(3,22,'2025-07-19 08:49:17');
/*!40000 ALTER TABLE `role_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_role_name` (`name`),
  KEY `idx_deleted_at` (`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色表 - 存储系统角色定义';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'admin','系统管理员','2025-07-19 08:49:17','2025-07-19 08:49:17',NULL),(2,'operator','运维人员','2025-07-19 08:49:17','2025-07-19 08:49:17',NULL),(3,'auditor','审计员','2025-07-19 08:49:17','2025-07-19 08:49:17',NULL);
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `session_monitor_logs`
--

DROP TABLE IF EXISTS `session_monitor_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `session_monitor_logs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `session_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '会话ID',
  `monitor_user_id` bigint unsigned NOT NULL COMMENT '监控用户ID',
  `action_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '操作类型: terminate, warning, view',
  `action_data` json DEFAULT NULL COMMENT '操作数据',
  `reason` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '操作原因',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_session_id` (`session_id`),
  KEY `idx_monitor_user` (`monitor_user_id`),
  KEY `idx_action_type` (`action_type`),
  KEY `idx_created_at` (`created_at`),
  CONSTRAINT `fk_monitor_user` FOREIGN KEY (`monitor_user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='会话监控日志表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `session_monitor_logs`
--

LOCK TABLES `session_monitor_logs` WRITE;
/*!40000 ALTER TABLE `session_monitor_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `session_monitor_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `session_recordings`
--

DROP TABLE IF EXISTS `session_recordings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `session_recordings` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `session_id` varchar(255) NOT NULL COMMENT '会话ID',
  `user_id` bigint unsigned NOT NULL COMMENT '用户ID',
  `asset_id` bigint unsigned NOT NULL COMMENT '资产ID',
  `start_time` datetime NOT NULL COMMENT '录制开始时间',
  `end_time` datetime DEFAULT NULL COMMENT '录制结束时间',
  `duration` bigint DEFAULT '0' COMMENT '录制时长(秒)',
  `file_path` varchar(500) NOT NULL COMMENT '录制文件路径',
  `file_size` bigint DEFAULT '0' COMMENT '文件大小(字节)',
  `compressed_size` bigint DEFAULT '0' COMMENT '压缩后大小(字节)',
  `format` varchar(50) DEFAULT 'asciicast' COMMENT '录制格式',
  `checksum` varchar(100) DEFAULT NULL COMMENT '文件校验和',
  `terminal_width` int DEFAULT '80' COMMENT '终端宽度',
  `terminal_height` int DEFAULT '24' COMMENT '终端高度',
  `total_bytes` bigint DEFAULT '0' COMMENT '总字节数',
  `compressed_bytes` bigint DEFAULT '0' COMMENT '压缩字节数',
  `compression_ratio` decimal(5,2) DEFAULT '0.00' COMMENT '压缩比',
  `record_count` int DEFAULT '0' COMMENT '记录条数',
  `status` varchar(50) DEFAULT 'recording' COMMENT '状态: recording,completed,failed',
  `metadata` text COMMENT '录制元数据(JSON)',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_session_id` (`session_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_asset_id` (`asset_id`),
  KEY `idx_start_time` (`start_time`),
  KEY `idx_status` (`status`),
  KEY `idx_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='会话录制记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `session_recordings`
--

LOCK TABLES `session_recordings` WRITE;
/*!40000 ALTER TABLE `session_recordings` DISABLE KEYS */;
/*!40000 ALTER TABLE `session_recordings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `session_records`
--

DROP TABLE IF EXISTS `session_records`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `session_records` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `session_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `asset_id` bigint unsigned NOT NULL,
  `asset_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `asset_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `credential_id` bigint unsigned NOT NULL,
  `protocol` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '协议: ssh, rdp, vnc',
  `ip` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active' COMMENT 'active, closed, timeout, terminated',
  `start_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `end_time` timestamp NULL DEFAULT NULL,
  `duration` bigint DEFAULT NULL COMMENT '会话持续时间，秒',
  `record_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '录制文件路径',
  `is_terminated` tinyint(1) DEFAULT '0' COMMENT '是否被终止',
  `termination_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '终止原因',
  `terminated_by` bigint unsigned DEFAULT NULL COMMENT '终止人',
  `terminated_at` timestamp NULL DEFAULT NULL COMMENT '终止时间',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `timeout_minutes` int DEFAULT '0' COMMENT '会话超时时间(分钟)，0表示无限制',
  `last_activity` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '最后活动时间',
  `close_reason` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'user_close' COMMENT '关闭原因: user_close, timeout, admin_force, system_error',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_session_id` (`session_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_username` (`username`),
  KEY `idx_asset_id` (`asset_id`),
  KEY `idx_credential_id` (`credential_id`),
  KEY `idx_protocol` (`protocol`),
  KEY `idx_ip` (`ip`),
  KEY `idx_status` (`status`),
  KEY `idx_start_time` (`start_time`),
  KEY `idx_created_at` (`created_at`),
  KEY `idx_deleted_at` (`deleted_at`),
  KEY `idx_session_records_is_terminated` (`is_terminated`),
  KEY `idx_session_records_status_terminated` (`status`,`is_terminated`),
  KEY `idx_sessions_user_time` (`user_id`,`start_time`),
  KEY `idx_terminated_by` (`terminated_by`),
  KEY `idx_session_timeout` (`timeout_minutes`,`last_activity`),
  KEY `idx_session_close_reason` (`close_reason`),
  KEY `idx_last_activity` (`last_activity`),
  CONSTRAINT `fk_session_records_asset` FOREIGN KEY (`asset_id`) REFERENCES `assets` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_session_records_credential` FOREIGN KEY (`credential_id`) REFERENCES `credentials` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_session_records_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_session_terminated_by` FOREIGN KEY (`terminated_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='会话记录表 - 记录用户的SSH/RDP等会话信息';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `session_records`
--

LOCK TABLES `session_records` WRITE;
/*!40000 ALTER TABLE `session_records` DISABLE KEYS */;
/*!40000 ALTER TABLE `session_records` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `session_timeouts`
--

DROP TABLE IF EXISTS `session_timeouts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `session_timeouts` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `session_id` varchar(100) NOT NULL COMMENT '关联的会话ID',
  `timeout_minutes` int NOT NULL DEFAULT '0' COMMENT '超时时间(分钟)，0表示无限制',
  `policy` varchar(20) NOT NULL DEFAULT 'fixed' COMMENT '超时策略',
  `idle_minutes` int DEFAULT NULL COMMENT '空闲时间(分钟)，适用于idle_kick策略',
  `last_activity` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '最后活动时间',
  `warnings_sent` int DEFAULT '0' COMMENT '已发送警告次数',
  `last_warning_at` datetime DEFAULT NULL COMMENT '最后警告时间',
  `is_active` tinyint(1) DEFAULT '1' COMMENT '是否启用',
  `extension_count` int DEFAULT '0' COMMENT '延期次数',
  `max_extensions` int DEFAULT '3' COMMENT '最大延期次数',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_session_id` (`session_id`),
  KEY `idx_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='会话超时配置表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `session_timeouts`
--

LOCK TABLES `session_timeouts` WRITE;
/*!40000 ALTER TABLE `session_timeouts` DISABLE KEYS */;
/*!40000 ALTER TABLE `session_timeouts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `session_warnings`
--

DROP TABLE IF EXISTS `session_warnings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `session_warnings` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `session_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '会话ID',
  `sender_user_id` bigint unsigned NOT NULL COMMENT '发送者用户ID',
  `receiver_user_id` bigint unsigned NOT NULL COMMENT '接收者用户ID',
  `message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '警告消息',
  `level` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'warning' COMMENT 'info, warning, error',
  `is_read` tinyint(1) DEFAULT '0' COMMENT '是否已读',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `read_at` timestamp NULL DEFAULT NULL COMMENT '阅读时间',
  PRIMARY KEY (`id`),
  KEY `idx_session_id` (`session_id`),
  KEY `idx_sender` (`sender_user_id`),
  KEY `idx_receiver` (`receiver_user_id`),
  KEY `idx_created_at` (`created_at`),
  KEY `idx_is_read` (`is_read`),
  CONSTRAINT `fk_warning_receiver` FOREIGN KEY (`receiver_user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_warning_sender` FOREIGN KEY (`sender_user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='会话警告消息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `session_warnings`
--

LOCK TABLES `session_warnings` WRITE;
/*!40000 ALTER TABLE `session_warnings` DISABLE KEYS */;
/*!40000 ALTER TABLE `session_warnings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_roles`
--

DROP TABLE IF EXISTS `user_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_roles` (
  `user_id` bigint unsigned NOT NULL,
  `role_id` bigint unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`,`role_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_role_id` (`role_id`),
  CONSTRAINT `fk_user_roles_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_user_roles_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户角色关联表 - 多对多关系';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_roles`
--

LOCK TABLES `user_roles` WRITE;
/*!40000 ALTER TABLE `user_roles` DISABLE KEYS */;
INSERT INTO `user_roles` VALUES (1,1,'2025-07-19 08:49:17');
/*!40000 ALTER TABLE `user_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` tinyint DEFAULT '1' COMMENT '1-启用, 0-禁用',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_username` (`username`),
  KEY `idx_status` (`status`),
  KEY `idx_deleted_at` (`deleted_at`),
  KEY `idx_users_created_at` (`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户表 - 存储系统用户信息';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'admin','$2a$10$X4iQ52mdwK8Gd7DFo00dx.kFYRBfXjDezkKK3m1JEExYsxPL1bT8i','admin@bastion.local',NULL,1,'2025-07-19 08:49:17','2025-07-28 12:19:57',NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `websocket_connections`
--

DROP TABLE IF EXISTS `websocket_connections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `websocket_connections` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `client_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '客户端ID',
  `user_id` bigint unsigned NOT NULL COMMENT '用户ID',
  `connect_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '连接时间',
  `disconnect_time` timestamp NULL DEFAULT NULL COMMENT '断开时间',
  `ip_address` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '客户端IP',
  `user_agent` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '用户代理',
  `duration` int DEFAULT NULL COMMENT '连接持续时间（秒）',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_connect_time` (`connect_time`),
  KEY `idx_client_id` (`client_id`),
  CONSTRAINT `fk_ws_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='WebSocket连接日志表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `websocket_connections`
--

LOCK TABLES `websocket_connections` WRITE;
/*!40000 ALTER TABLE `websocket_connections` DISABLE KEYS */;
/*!40000 ALTER TABLE `websocket_connections` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Final view structure for view `audit_statistics`
--

/*!50001 DROP VIEW IF EXISTS `audit_statistics`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `audit_statistics` AS select (select count(0) from `login_logs`) AS `total_login_logs`,(select count(0) from `operation_logs`) AS `total_operation_logs`,(select count(0) from `session_records`) AS `total_session_records`,(select count(0) from `command_logs`) AS `total_command_logs`,(select count(0) from `login_logs` where (`login_logs`.`status` = 'failed')) AS `failed_logins`,(select count(0) from `session_records` where (`session_records`.`status` = 'active')) AS `active_sessions`,(select count(0) from `command_logs` where (`command_logs`.`risk` = 'high')) AS `dangerous_commands`,(select count(0) from `login_logs` where (cast(`login_logs`.`created_at` as date) = curdate())) AS `today_logins`,(select count(0) from `operation_logs` where (cast(`operation_logs`.`created_at` as date) = curdate())) AS `today_operations`,(select count(0) from `session_records` where (cast(`session_records`.`start_time` as date) = curdate())) AS `today_sessions` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-08-05 20:31:01
