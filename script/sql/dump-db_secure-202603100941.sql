-- MySQL dump 10.13  Distrib 8.0.19, for Win64 (x86_64)
--
-- Host: localhost    Database: db_secure
-- ------------------------------------------------------
-- Server version	8.0.36

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
-- Table structure for table `biz_file_operate_log`
--

DROP TABLE IF EXISTS `biz_file_operate_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `biz_file_operate_log` (
  `log_id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志主键',
  `user_id` bigint NOT NULL COMMENT '操作人ID',
  `user_name` varchar(64) DEFAULT NULL COMMENT '操作人账号',
  `file_id` bigint DEFAULT NULL COMMENT '操作的文件ID(可为空)',
  `operate_type` char(1) NOT NULL COMMENT '操作类型(1上传 2下载 3分享 4删除)',
  `ipaddr` varchar(128) DEFAULT '' COMMENT '操作IP地址',
  `create_time` datetime DEFAULT NULL COMMENT '操作时间',
  PRIMARY KEY (`log_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='文件操作审计日志表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `biz_file_operate_log`
--

LOCK TABLES `biz_file_operate_log` WRITE;
/*!40000 ALTER TABLE `biz_file_operate_log` DISABLE KEYS */;
INSERT INTO `biz_file_operate_log` VALUES (1,1,'admin',NULL,'1','127.0.0.1','2026-03-09 10:09:09'),(2,1,'admin',1,'3','127.0.0.1','2026-03-09 10:09:16'),(3,1,'admin',1,'3','127.0.0.1','2026-03-09 10:12:06'),(4,-1,'匿名',1,'2','127.0.0.1','2026-03-09 10:12:24'),(5,2030836971509235714,'zhangsan',NULL,'1','127.0.0.1','2026-03-09 10:50:00'),(6,2030836971509235714,'zhangsan',2,'3','127.0.0.1','2026-03-09 10:50:06'),(7,-1,'匿名',2,'2','127.0.0.1','2026-03-09 10:50:18');
/*!40000 ALTER TABLE `biz_file_operate_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `biz_file_share`
--

DROP TABLE IF EXISTS `biz_file_share`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `biz_file_share` (
  `share_id` bigint NOT NULL AUTO_INCREMENT COMMENT '分享主键',
  `user_id` bigint NOT NULL COMMENT '分享人ID',
  `file_id` bigint NOT NULL COMMENT '被分享的业务文件ID',
  `share_link` varchar(100) NOT NULL COMMENT '短链接标识(如: aBcD123)',
  `extract_code` varchar(10) DEFAULT NULL COMMENT '提取码(4位随机数，为空则无密码)',
  `expire_time` datetime DEFAULT NULL COMMENT '过期时间(为空表示永久有效)',
  `status` char(1) DEFAULT '0' COMMENT '状态(0正常 1失效)',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '分享创建时间',
  PRIMARY KEY (`share_id`),
  UNIQUE KEY `uk_share_link` (`share_link`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='文件安全分享表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `biz_file_share`
--

LOCK TABLES `biz_file_share` WRITE;
/*!40000 ALTER TABLE `biz_file_share` DISABLE KEYS */;
INSERT INTO `biz_file_share` VALUES (1,1,1,'ODQ7jJec','3359',NULL,'0','1','2026-03-09 10:09:16'),(2,1,1,'MdlQHkI7','6779',NULL,'0','1','2026-03-09 10:12:06'),(3,2030836971509235714,2,'6bzcvtB9',NULL,'2026-03-10 10:50:06','0','2030836971509235714','2026-03-09 10:50:06');
/*!40000 ALTER TABLE `biz_file_share` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `biz_user_file`
--

DROP TABLE IF EXISTS `biz_user_file`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `biz_user_file` (
  `file_id` bigint NOT NULL AUTO_INCREMENT COMMENT '业务文件主键',
  `user_id` bigint NOT NULL COMMENT '所属用户ID',
  `oss_id` bigint NOT NULL COMMENT '关联sys_oss主键(物理文件ID)',
  `file_name` varchar(255) NOT NULL COMMENT '文件展示名称',
  `file_suffix` varchar(20) DEFAULT NULL COMMENT '文件后缀扩展名',
  `file_size` bigint DEFAULT '0' COMMENT '文件大小(字节)',
  `is_encrypted` char(1) DEFAULT '1' COMMENT '是否已AES加密(0否 1是)',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标志(0代表存在 2代表删除)',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`file_id`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户个人文件记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `biz_user_file`
--

LOCK TABLES `biz_user_file` WRITE;
/*!40000 ALTER TABLE `biz_user_file` DISABLE KEYS */;
INSERT INTO `biz_user_file` VALUES (1,1,2030828203601928194,'A写作格式规范.doc','doc',121856,'1','0',103,'1','2026-03-09 10:09:09','1','2026-03-09 10:09:09'),(2,2030836971509235714,2030838481886494722,'A写作格式规范.doc','doc',121856,'1','0',NULL,'2030836971509235714','2026-03-09 10:50:00','2030836971509235714','2026-03-09 10:50:00');
/*!40000 ALTER TABLE `biz_user_file` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flow_category`
--

DROP TABLE IF EXISTS `flow_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flow_category` (
  `category_id` bigint NOT NULL COMMENT '流程分类ID',
  `tenant_id` varchar(20) DEFAULT '000000' COMMENT '租户编号',
  `parent_id` bigint DEFAULT '0' COMMENT '父流程分类id',
  `ancestors` varchar(500) DEFAULT '' COMMENT '祖级列表',
  `category_name` varchar(30) NOT NULL COMMENT '流程分类名称',
  `order_num` int DEFAULT '0' COMMENT '显示顺序',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标志（0代表存在 1代表删除）',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='流程分类';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flow_category`
--

LOCK TABLES `flow_category` WRITE;
/*!40000 ALTER TABLE `flow_category` DISABLE KEYS */;
INSERT INTO `flow_category` VALUES (100,'000000',0,'0','OA审批',0,'0',103,1,'2026-03-09 08:59:23',NULL,NULL),(101,'000000',100,'0,100','假勤管理',0,'0',103,1,'2026-03-09 08:59:23',NULL,NULL),(102,'000000',100,'0,100','人事管理',1,'0',103,1,'2026-03-09 08:59:23',NULL,NULL),(103,'000000',101,'0,100,101','请假',0,'0',103,1,'2026-03-09 08:59:23',NULL,NULL),(104,'000000',101,'0,100,101','出差',1,'0',103,1,'2026-03-09 08:59:23',NULL,NULL),(105,'000000',101,'0,100,101','加班',2,'0',103,1,'2026-03-09 08:59:23',NULL,NULL),(106,'000000',101,'0,100,101','换班',3,'0',103,1,'2026-03-09 08:59:23',NULL,NULL),(107,'000000',101,'0,100,101','外出',4,'0',103,1,'2026-03-09 08:59:23',NULL,NULL),(108,'000000',102,'0,100,102','转正',1,'0',103,1,'2026-03-09 08:59:23',NULL,NULL),(109,'000000',102,'0,100,102','离职',2,'0',103,1,'2026-03-09 08:59:23',NULL,NULL);
/*!40000 ALTER TABLE `flow_category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flow_definition`
--

DROP TABLE IF EXISTS `flow_definition`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flow_definition` (
  `id` bigint NOT NULL COMMENT '主键id',
  `flow_code` varchar(40) NOT NULL COMMENT '流程编码',
  `flow_name` varchar(100) NOT NULL COMMENT '流程名称',
  `model_value` varchar(40) NOT NULL DEFAULT 'CLASSICS' COMMENT '设计器模型（CLASSICS经典模型 MIMIC仿钉钉模型）',
  `category` varchar(100) DEFAULT NULL COMMENT '流程类别',
  `version` varchar(20) NOT NULL COMMENT '流程版本',
  `is_publish` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否发布（0未发布 1已发布 9失效）',
  `form_custom` char(1) DEFAULT 'N' COMMENT '审批表单是否自定义（Y是 N否）',
  `form_path` varchar(100) DEFAULT NULL COMMENT '审批表单路径',
  `activity_status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '流程激活状态（0挂起 1激活）',
  `listener_type` varchar(100) DEFAULT NULL COMMENT '监听器类型',
  `listener_path` varchar(400) DEFAULT NULL COMMENT '监听器路径',
  `ext` varchar(500) DEFAULT NULL COMMENT '业务详情 存业务表对象json字符串',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新人',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标志',
  `tenant_id` varchar(40) DEFAULT NULL COMMENT '租户id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='流程定义表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flow_definition`
--

LOCK TABLES `flow_definition` WRITE;
/*!40000 ALTER TABLE `flow_definition` DISABLE KEYS */;
/*!40000 ALTER TABLE `flow_definition` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flow_his_task`
--

DROP TABLE IF EXISTS `flow_his_task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flow_his_task` (
  `id` bigint NOT NULL COMMENT '主键id',
  `definition_id` bigint NOT NULL COMMENT '对应flow_definition表的id',
  `instance_id` bigint NOT NULL COMMENT '对应flow_instance表的id',
  `task_id` bigint NOT NULL COMMENT '对应flow_task表的id',
  `node_code` varchar(100) DEFAULT NULL COMMENT '开始节点编码',
  `node_name` varchar(100) DEFAULT NULL COMMENT '开始节点名称',
  `node_type` tinyint(1) DEFAULT NULL COMMENT '开始节点类型（0开始节点 1中间节点 2结束节点 3互斥网关 4并行网关）',
  `target_node_code` varchar(200) DEFAULT NULL COMMENT '目标节点编码',
  `target_node_name` varchar(200) DEFAULT NULL COMMENT '结束节点名称',
  `approver` varchar(40) DEFAULT NULL COMMENT '审批人',
  `cooperate_type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '协作方式(1审批 2转办 3委派 4会签 5票签 6加签 7减签)',
  `collaborator` varchar(500) DEFAULT NULL COMMENT '协作人',
  `skip_type` varchar(10) NOT NULL COMMENT '流转类型（PASS通过 REJECT退回 NONE无动作）',
  `flow_status` varchar(20) NOT NULL COMMENT '流程状态（0待提交 1审批中 2审批通过 4终止 5作废 6撤销 8已完成 9已退回 10失效 11拿回）',
  `form_custom` char(1) DEFAULT 'N' COMMENT '审批表单是否自定义（Y是 N否）',
  `form_path` varchar(100) DEFAULT NULL COMMENT '审批表单路径',
  `message` varchar(500) DEFAULT NULL COMMENT '审批意见',
  `variable` text COMMENT '任务变量',
  `ext` text COMMENT '业务详情 存业务表对象json字符串',
  `create_time` datetime DEFAULT NULL COMMENT '任务开始时间',
  `update_time` datetime DEFAULT NULL COMMENT '审批完成时间',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标志',
  `tenant_id` varchar(40) DEFAULT NULL COMMENT '租户id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='历史任务记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flow_his_task`
--

LOCK TABLES `flow_his_task` WRITE;
/*!40000 ALTER TABLE `flow_his_task` DISABLE KEYS */;
/*!40000 ALTER TABLE `flow_his_task` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flow_instance`
--

DROP TABLE IF EXISTS `flow_instance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flow_instance` (
  `id` bigint NOT NULL COMMENT '主键id',
  `definition_id` bigint NOT NULL COMMENT '对应flow_definition表的id',
  `business_id` varchar(40) NOT NULL COMMENT '业务id',
  `node_type` tinyint(1) NOT NULL COMMENT '节点类型（0开始节点 1中间节点 2结束节点 3互斥网关 4并行网关）',
  `node_code` varchar(40) NOT NULL COMMENT '流程节点编码',
  `node_name` varchar(100) DEFAULT NULL COMMENT '流程节点名称',
  `variable` text COMMENT '任务变量',
  `flow_status` varchar(20) NOT NULL COMMENT '流程状态（0待提交 1审批中 2审批通过 4终止 5作废 6撤销 8已完成 9已退回 10失效 11拿回）',
  `activity_status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '流程激活状态（0挂起 1激活）',
  `def_json` text COMMENT '流程定义json',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新人',
  `ext` varchar(500) DEFAULT NULL COMMENT '扩展字段，预留给业务系统使用',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标志',
  `tenant_id` varchar(40) DEFAULT NULL COMMENT '租户id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='流程实例表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flow_instance`
--

LOCK TABLES `flow_instance` WRITE;
/*!40000 ALTER TABLE `flow_instance` DISABLE KEYS */;
/*!40000 ALTER TABLE `flow_instance` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flow_instance_biz_ext`
--

DROP TABLE IF EXISTS `flow_instance_biz_ext`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flow_instance_biz_ext` (
  `id` bigint NOT NULL COMMENT '主键id',
  `tenant_id` varchar(20) DEFAULT '000000' COMMENT '租户编号',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `business_code` varchar(255) DEFAULT NULL COMMENT '业务编码',
  `business_title` varchar(1000) DEFAULT NULL COMMENT '业务标题',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标志（0代表存在 1代表删除）',
  `instance_id` bigint DEFAULT NULL COMMENT '流程实例Id',
  `business_id` varchar(255) DEFAULT NULL COMMENT '业务Id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='流程实例业务扩展表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flow_instance_biz_ext`
--

LOCK TABLES `flow_instance_biz_ext` WRITE;
/*!40000 ALTER TABLE `flow_instance_biz_ext` DISABLE KEYS */;
/*!40000 ALTER TABLE `flow_instance_biz_ext` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flow_node`
--

DROP TABLE IF EXISTS `flow_node`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flow_node` (
  `id` bigint NOT NULL COMMENT '主键id',
  `node_type` tinyint(1) NOT NULL COMMENT '节点类型（0开始节点 1中间节点 2结束节点 3互斥网关 4并行网关）',
  `definition_id` bigint NOT NULL COMMENT '流程定义id',
  `node_code` varchar(100) NOT NULL COMMENT '流程节点编码',
  `node_name` varchar(100) DEFAULT NULL COMMENT '流程节点名称',
  `permission_flag` varchar(200) DEFAULT NULL COMMENT '权限标识（权限类型:权限标识，可以多个，用@@隔开)',
  `node_ratio` varchar(200) DEFAULT NULL COMMENT '流程签署比例值',
  `coordinate` varchar(100) DEFAULT NULL COMMENT '坐标',
  `any_node_skip` varchar(100) DEFAULT NULL COMMENT '任意结点跳转',
  `listener_type` varchar(100) DEFAULT NULL COMMENT '监听器类型',
  `listener_path` varchar(400) DEFAULT NULL COMMENT '监听器路径',
  `form_custom` char(1) DEFAULT 'N' COMMENT '审批表单是否自定义（Y是 N否）',
  `form_path` varchar(100) DEFAULT NULL COMMENT '审批表单路径',
  `version` varchar(20) NOT NULL COMMENT '版本',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新人',
  `ext` text COMMENT '节点扩展属性',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标志',
  `tenant_id` varchar(40) DEFAULT NULL COMMENT '租户id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='流程节点表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flow_node`
--

LOCK TABLES `flow_node` WRITE;
/*!40000 ALTER TABLE `flow_node` DISABLE KEYS */;
/*!40000 ALTER TABLE `flow_node` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flow_skip`
--

DROP TABLE IF EXISTS `flow_skip`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flow_skip` (
  `id` bigint NOT NULL COMMENT '主键id',
  `definition_id` bigint NOT NULL COMMENT '流程定义id',
  `now_node_code` varchar(100) NOT NULL COMMENT '当前流程节点的编码',
  `now_node_type` tinyint(1) DEFAULT NULL COMMENT '当前节点类型（0开始节点 1中间节点 2结束节点 3互斥网关 4并行网关）',
  `next_node_code` varchar(100) NOT NULL COMMENT '下一个流程节点的编码',
  `next_node_type` tinyint(1) DEFAULT NULL COMMENT '下一个节点类型（0开始节点 1中间节点 2结束节点 3互斥网关 4并行网关）',
  `skip_name` varchar(100) DEFAULT NULL COMMENT '跳转名称',
  `skip_type` varchar(40) DEFAULT NULL COMMENT '跳转类型（PASS审批通过 REJECT退回）',
  `skip_condition` varchar(200) DEFAULT NULL COMMENT '跳转条件',
  `coordinate` varchar(100) DEFAULT NULL COMMENT '坐标',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新人',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标志',
  `tenant_id` varchar(40) DEFAULT NULL COMMENT '租户id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='节点跳转关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flow_skip`
--

LOCK TABLES `flow_skip` WRITE;
/*!40000 ALTER TABLE `flow_skip` DISABLE KEYS */;
/*!40000 ALTER TABLE `flow_skip` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flow_spel`
--

DROP TABLE IF EXISTS `flow_spel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flow_spel` (
  `id` bigint NOT NULL COMMENT '主键id',
  `component_name` varchar(255) DEFAULT NULL COMMENT '组件名称',
  `method_name` varchar(255) DEFAULT NULL COMMENT '方法名',
  `method_params` varchar(255) DEFAULT NULL COMMENT '参数',
  `view_spel` varchar(255) DEFAULT NULL COMMENT '预览spel表达式',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `status` char(1) DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标志',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='流程spel表达式定义表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flow_spel`
--

LOCK TABLES `flow_spel` WRITE;
/*!40000 ALTER TABLE `flow_spel` DISABLE KEYS */;
INSERT INTO `flow_spel` VALUES (1,'spelRuleComponent','selectDeptLeaderById','initiatorDeptId','#{@spelRuleComponent.selectDeptLeaderById(#initiatorDeptId)}','根据部门id获取部门负责人','0','0',103,1,'2026-03-09 08:59:23',1,'2026-03-09 08:59:23'),(2,NULL,NULL,'initiator','${initiator}','流程发起人','0','0',103,1,'2026-03-09 08:59:23',1,'2026-03-09 08:59:23');
/*!40000 ALTER TABLE `flow_spel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flow_task`
--

DROP TABLE IF EXISTS `flow_task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flow_task` (
  `id` bigint NOT NULL COMMENT '主键id',
  `definition_id` bigint NOT NULL COMMENT '对应flow_definition表的id',
  `instance_id` bigint NOT NULL COMMENT '对应flow_instance表的id',
  `node_code` varchar(100) NOT NULL COMMENT '节点编码',
  `node_name` varchar(100) DEFAULT NULL COMMENT '节点名称',
  `node_type` tinyint(1) NOT NULL COMMENT '节点类型（0开始节点 1中间节点 2结束节点 3互斥网关 4并行网关）',
  `flow_status` varchar(20) NOT NULL COMMENT '流程状态（0待提交 1审批中 2审批通过 4终止 5作废 6撤销 8已完成 9已退回 10失效 11拿回）',
  `form_custom` char(1) DEFAULT 'N' COMMENT '审批表单是否自定义（Y是 N否）',
  `form_path` varchar(100) DEFAULT NULL COMMENT '审批表单路径',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新人',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标志',
  `tenant_id` varchar(40) DEFAULT NULL COMMENT '租户id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='待办任务表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flow_task`
--

LOCK TABLES `flow_task` WRITE;
/*!40000 ALTER TABLE `flow_task` DISABLE KEYS */;
/*!40000 ALTER TABLE `flow_task` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flow_user`
--

DROP TABLE IF EXISTS `flow_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flow_user` (
  `id` bigint NOT NULL COMMENT '主键id',
  `type` char(1) NOT NULL COMMENT '人员类型（1待办任务的审批人权限 2待办任务的转办人权限 3待办任务的委托人权限）',
  `processed_by` varchar(80) DEFAULT NULL COMMENT '权限人',
  `associated` bigint NOT NULL COMMENT '任务表id',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `create_by` varchar(80) DEFAULT NULL COMMENT '创建人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '创建人',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标志',
  `tenant_id` varchar(40) DEFAULT NULL COMMENT '租户id',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `user_processed_type` (`processed_by`,`type`),
  KEY `user_associated` (`associated`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='流程用户表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flow_user`
--

LOCK TABLES `flow_user` WRITE;
/*!40000 ALTER TABLE `flow_user` DISABLE KEYS */;
/*!40000 ALTER TABLE `flow_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gen_table`
--

DROP TABLE IF EXISTS `gen_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gen_table` (
  `table_id` bigint NOT NULL COMMENT '编号',
  `data_name` varchar(200) DEFAULT '' COMMENT '数据源名称',
  `table_name` varchar(200) DEFAULT '' COMMENT '表名称',
  `table_comment` varchar(500) DEFAULT '' COMMENT '表描述',
  `sub_table_name` varchar(64) DEFAULT NULL COMMENT '关联子表的表名',
  `sub_table_fk_name` varchar(64) DEFAULT NULL COMMENT '子表关联的外键名',
  `class_name` varchar(100) DEFAULT '' COMMENT '实体类名称',
  `tpl_category` varchar(200) DEFAULT 'crud' COMMENT '使用的模板（crud单表操作 tree树表操作）',
  `package_name` varchar(100) DEFAULT NULL COMMENT '生成包路径',
  `module_name` varchar(30) DEFAULT NULL COMMENT '生成模块名',
  `business_name` varchar(30) DEFAULT NULL COMMENT '生成业务名',
  `function_name` varchar(50) DEFAULT NULL COMMENT '生成功能名',
  `function_author` varchar(50) DEFAULT NULL COMMENT '生成功能作者',
  `gen_type` char(1) DEFAULT '0' COMMENT '生成代码方式（0zip压缩包 1自定义路径）',
  `gen_path` varchar(200) DEFAULT '/' COMMENT '生成路径（不填默认项目路径）',
  `options` varchar(1000) DEFAULT NULL COMMENT '其它生成选项',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`table_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='代码生成业务表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gen_table`
--

LOCK TABLES `gen_table` WRITE;
/*!40000 ALTER TABLE `gen_table` DISABLE KEYS */;
/*!40000 ALTER TABLE `gen_table` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gen_table_column`
--

DROP TABLE IF EXISTS `gen_table_column`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gen_table_column` (
  `column_id` bigint NOT NULL COMMENT '编号',
  `table_id` bigint DEFAULT NULL COMMENT '归属表编号',
  `column_name` varchar(200) DEFAULT NULL COMMENT '列名称',
  `column_comment` varchar(500) DEFAULT NULL COMMENT '列描述',
  `column_type` varchar(100) DEFAULT NULL COMMENT '列类型',
  `java_type` varchar(500) DEFAULT NULL COMMENT 'JAVA类型',
  `java_field` varchar(200) DEFAULT NULL COMMENT 'JAVA字段名',
  `is_pk` char(1) DEFAULT NULL COMMENT '是否主键（1是）',
  `is_increment` char(1) DEFAULT NULL COMMENT '是否自增（1是）',
  `is_required` char(1) DEFAULT NULL COMMENT '是否必填（1是）',
  `is_insert` char(1) DEFAULT NULL COMMENT '是否为插入字段（1是）',
  `is_edit` char(1) DEFAULT NULL COMMENT '是否编辑字段（1是）',
  `is_list` char(1) DEFAULT NULL COMMENT '是否列表字段（1是）',
  `is_query` char(1) DEFAULT NULL COMMENT '是否查询字段（1是）',
  `query_type` varchar(200) DEFAULT 'EQ' COMMENT '查询方式（等于、不等于、大于、小于、范围）',
  `html_type` varchar(200) DEFAULT NULL COMMENT '显示类型（文本框、文本域、下拉框、复选框、单选框、日期控件）',
  `dict_type` varchar(200) DEFAULT '' COMMENT '字典类型',
  `sort` int DEFAULT NULL COMMENT '排序',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`column_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='代码生成业务表字段';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gen_table_column`
--

LOCK TABLES `gen_table_column` WRITE;
/*!40000 ALTER TABLE `gen_table_column` DISABLE KEYS */;
/*!40000 ALTER TABLE `gen_table_column` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_client`
--

DROP TABLE IF EXISTS `sys_client`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_client` (
  `id` bigint NOT NULL COMMENT 'id',
  `client_id` varchar(64) DEFAULT NULL COMMENT '客户端id',
  `client_key` varchar(32) DEFAULT NULL COMMENT '客户端key',
  `client_secret` varchar(255) DEFAULT NULL COMMENT '客户端秘钥',
  `grant_type` varchar(255) DEFAULT NULL COMMENT '授权类型',
  `device_type` varchar(32) DEFAULT NULL COMMENT '设备类型',
  `active_timeout` int DEFAULT '1800' COMMENT 'token活跃超时时间',
  `timeout` int DEFAULT '604800' COMMENT 'token固定超时',
  `status` char(1) DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标志（0代表存在 1代表删除）',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='系统授权表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_client`
--

LOCK TABLES `sys_client` WRITE;
/*!40000 ALTER TABLE `sys_client` DISABLE KEYS */;
INSERT INTO `sys_client` VALUES (1,'e5cd7e4891bf95d1d19206ce24a7b32e','pc','pc123','password,social','pc',1800,604800,'0','0',103,1,'2026-03-09 08:58:37',1,'2026-03-09 08:58:37'),(2,'428a8310cd442757ae699df5d894f051','app','app123','password,sms,social','android',1800,604800,'0','0',103,1,'2026-03-09 08:58:37',1,'2026-03-09 08:58:37');
/*!40000 ALTER TABLE `sys_client` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_config`
--

DROP TABLE IF EXISTS `sys_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_config` (
  `config_id` bigint NOT NULL COMMENT '参数主键',
  `tenant_id` varchar(20) DEFAULT '000000' COMMENT '租户编号',
  `config_name` varchar(100) DEFAULT '' COMMENT '参数名称',
  `config_key` varchar(100) DEFAULT '' COMMENT '参数键名',
  `config_value` varchar(500) DEFAULT '' COMMENT '参数键值',
  `config_type` char(1) DEFAULT 'N' COMMENT '系统内置（Y是 N否）',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`config_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='参数配置表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_config`
--

LOCK TABLES `sys_config` WRITE;
/*!40000 ALTER TABLE `sys_config` DISABLE KEYS */;
INSERT INTO `sys_config` VALUES (1,'000000','主框架页-默认皮肤样式名称','sys.index.skinName','skin-blue','Y',103,1,'2026-03-09 08:58:37',NULL,NULL,'蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow'),(2,'000000','用户管理-账号初始密码','sys.user.initPassword','123456','Y',103,1,'2026-03-09 08:58:37',NULL,NULL,'初始化密码 123456'),(3,'000000','主框架页-侧边栏主题','sys.index.sideTheme','theme-dark','Y',103,1,'2026-03-09 08:58:37',NULL,NULL,'深色主题theme-dark，浅色主题theme-light'),(5,'000000','账号自助-是否开启用户注册功能','sys.account.registerUser','true','Y',103,1,'2026-03-09 08:58:37',NULL,NULL,'是否开启注册用户功能（true开启，false关闭）'),(11,'000000','OSS预览列表资源开关','sys.oss.previewListResource','true','Y',103,1,'2026-03-09 08:58:37',NULL,NULL,'true:开启, false:关闭');
/*!40000 ALTER TABLE `sys_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_dept`
--

DROP TABLE IF EXISTS `sys_dept`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_dept` (
  `dept_id` bigint NOT NULL COMMENT '部门id',
  `tenant_id` varchar(20) DEFAULT '000000' COMMENT '租户编号',
  `parent_id` bigint DEFAULT '0' COMMENT '父部门id',
  `ancestors` varchar(500) DEFAULT '' COMMENT '祖级列表',
  `dept_name` varchar(30) DEFAULT '' COMMENT '部门名称',
  `dept_category` varchar(100) DEFAULT NULL COMMENT '部门类别编码',
  `order_num` int DEFAULT '0' COMMENT '显示顺序',
  `leader` bigint DEFAULT NULL COMMENT '负责人',
  `phone` varchar(11) DEFAULT NULL COMMENT '联系电话',
  `email` varchar(50) DEFAULT NULL COMMENT '邮箱',
  `status` char(1) DEFAULT '0' COMMENT '部门状态（0正常 1停用）',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标志（0代表存在 1代表删除）',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`dept_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='部门表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_dept`
--

LOCK TABLES `sys_dept` WRITE;
/*!40000 ALTER TABLE `sys_dept` DISABLE KEYS */;
INSERT INTO `sys_dept` VALUES (100,'000000',0,'0','XXX科技',NULL,0,NULL,'15888888888','xxx@qq.com','0','0',103,1,'2026-03-09 08:58:34',NULL,NULL),(101,'000000',100,'0,100','深圳总公司',NULL,1,NULL,'15888888888','xxx@qq.com','0','0',103,1,'2026-03-09 08:58:34',NULL,NULL),(102,'000000',100,'0,100','长沙分公司',NULL,2,NULL,'15888888888','xxx@qq.com','0','0',103,1,'2026-03-09 08:58:34',NULL,NULL),(103,'000000',101,'0,100,101','研发部门',NULL,1,1,'15888888888','xxx@qq.com','0','0',103,1,'2026-03-09 08:58:34',NULL,NULL),(104,'000000',101,'0,100,101','市场部门',NULL,2,NULL,'15888888888','xxx@qq.com','0','0',103,1,'2026-03-09 08:58:34',NULL,NULL),(105,'000000',101,'0,100,101','测试部门',NULL,3,NULL,'15888888888','xxx@qq.com','0','0',103,1,'2026-03-09 08:58:34',NULL,NULL),(106,'000000',101,'0,100,101','财务部门',NULL,4,NULL,'15888888888','xxx@qq.com','0','0',103,1,'2026-03-09 08:58:34',NULL,NULL),(107,'000000',101,'0,100,101','运维部门',NULL,5,NULL,'15888888888','xxx@qq.com','0','0',103,1,'2026-03-09 08:58:34',NULL,NULL),(108,'000000',102,'0,100,102','市场部门',NULL,1,NULL,'15888888888','xxx@qq.com','0','0',103,1,'2026-03-09 08:58:34',NULL,NULL),(109,'000000',102,'0,100,102','财务部门',NULL,2,NULL,'15888888888','xxx@qq.com','0','0',103,1,'2026-03-09 08:58:34',NULL,NULL);
/*!40000 ALTER TABLE `sys_dept` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_dict_data`
--

DROP TABLE IF EXISTS `sys_dict_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_dict_data` (
  `dict_code` bigint NOT NULL COMMENT '字典编码',
  `tenant_id` varchar(20) DEFAULT '000000' COMMENT '租户编号',
  `dict_sort` int DEFAULT '0' COMMENT '字典排序',
  `dict_label` varchar(100) DEFAULT '' COMMENT '字典标签',
  `dict_value` varchar(100) DEFAULT '' COMMENT '字典键值',
  `dict_type` varchar(100) DEFAULT '' COMMENT '字典类型',
  `css_class` varchar(100) DEFAULT NULL COMMENT '样式属性（其他样式扩展）',
  `list_class` varchar(100) DEFAULT NULL COMMENT '表格回显样式',
  `is_default` char(1) DEFAULT 'N' COMMENT '是否默认（Y是 N否）',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='字典数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_dict_data`
--

LOCK TABLES `sys_dict_data` WRITE;
/*!40000 ALTER TABLE `sys_dict_data` DISABLE KEYS */;
INSERT INTO `sys_dict_data` VALUES (1,'000000',1,'男','0','sys_user_sex','','','Y',103,1,'2026-03-09 08:58:37',NULL,NULL,'性别男'),(2,'000000',2,'女','1','sys_user_sex','','','N',103,1,'2026-03-09 08:58:37',NULL,NULL,'性别女'),(3,'000000',3,'未知','2','sys_user_sex','','','N',103,1,'2026-03-09 08:58:37',NULL,NULL,'性别未知'),(4,'000000',1,'显示','0','sys_show_hide','','primary','Y',103,1,'2026-03-09 08:58:37',NULL,NULL,'显示菜单'),(5,'000000',2,'隐藏','1','sys_show_hide','','danger','N',103,1,'2026-03-09 08:58:37',NULL,NULL,'隐藏菜单'),(6,'000000',1,'正常','0','sys_normal_disable','','primary','Y',103,1,'2026-03-09 08:58:37',NULL,NULL,'正常状态'),(7,'000000',2,'停用','1','sys_normal_disable','','danger','N',103,1,'2026-03-09 08:58:37',NULL,NULL,'停用状态'),(12,'000000',1,'是','Y','sys_yes_no','','primary','Y',103,1,'2026-03-09 08:58:37',NULL,NULL,'系统默认是'),(13,'000000',2,'否','N','sys_yes_no','','danger','N',103,1,'2026-03-09 08:58:37',NULL,NULL,'系统默认否'),(14,'000000',1,'通知','1','sys_notice_type','','warning','Y',103,1,'2026-03-09 08:58:37',NULL,NULL,'通知'),(15,'000000',2,'公告','2','sys_notice_type','','success','N',103,1,'2026-03-09 08:58:37',NULL,NULL,'公告'),(16,'000000',1,'正常','0','sys_notice_status','','primary','Y',103,1,'2026-03-09 08:58:37',NULL,NULL,'正常状态'),(17,'000000',2,'关闭','1','sys_notice_status','','danger','N',103,1,'2026-03-09 08:58:37',NULL,NULL,'关闭状态'),(18,'000000',1,'新增','1','sys_oper_type','','info','N',103,1,'2026-03-09 08:58:37',NULL,NULL,'新增操作'),(19,'000000',2,'修改','2','sys_oper_type','','info','N',103,1,'2026-03-09 08:58:37',NULL,NULL,'修改操作'),(20,'000000',3,'删除','3','sys_oper_type','','danger','N',103,1,'2026-03-09 08:58:37',NULL,NULL,'删除操作'),(21,'000000',4,'授权','4','sys_oper_type','','primary','N',103,1,'2026-03-09 08:58:37',NULL,NULL,'授权操作'),(22,'000000',5,'导出','5','sys_oper_type','','warning','N',103,1,'2026-03-09 08:58:37',NULL,NULL,'导出操作'),(23,'000000',6,'导入','6','sys_oper_type','','warning','N',103,1,'2026-03-09 08:58:37',NULL,NULL,'导入操作'),(24,'000000',7,'强退','7','sys_oper_type','','danger','N',103,1,'2026-03-09 08:58:37',NULL,NULL,'强退操作'),(25,'000000',8,'生成代码','8','sys_oper_type','','warning','N',103,1,'2026-03-09 08:58:37',NULL,NULL,'生成操作'),(26,'000000',9,'清空数据','9','sys_oper_type','','danger','N',103,1,'2026-03-09 08:58:37',NULL,NULL,'清空操作'),(27,'000000',1,'成功','0','sys_common_status','','primary','N',103,1,'2026-03-09 08:58:37',NULL,NULL,'正常状态'),(28,'000000',2,'失败','1','sys_common_status','','danger','N',103,1,'2026-03-09 08:58:37',NULL,NULL,'停用状态'),(29,'000000',99,'其他','0','sys_oper_type','','info','N',103,1,'2026-03-09 08:58:37',NULL,NULL,'其他操作'),(30,'000000',0,'密码认证','password','sys_grant_type','el-check-tag','default','N',103,1,'2026-03-09 08:58:37',NULL,NULL,'密码认证'),(31,'000000',0,'短信认证','sms','sys_grant_type','el-check-tag','default','N',103,1,'2026-03-09 08:58:37',NULL,NULL,'短信认证'),(32,'000000',0,'邮件认证','email','sys_grant_type','el-check-tag','default','N',103,1,'2026-03-09 08:58:37',NULL,NULL,'邮件认证'),(33,'000000',0,'小程序认证','xcx','sys_grant_type','el-check-tag','default','N',103,1,'2026-03-09 08:58:37',NULL,NULL,'小程序认证'),(34,'000000',0,'三方登录认证','social','sys_grant_type','el-check-tag','default','N',103,1,'2026-03-09 08:58:37',NULL,NULL,'三方登录认证'),(35,'000000',0,'PC','pc','sys_device_type','','default','N',103,1,'2026-03-09 08:58:37',NULL,NULL,'PC'),(36,'000000',0,'安卓','android','sys_device_type','','default','N',103,1,'2026-03-09 08:58:37',NULL,NULL,'安卓'),(37,'000000',0,'iOS','ios','sys_device_type','','default','N',103,1,'2026-03-09 08:58:37',NULL,NULL,'iOS'),(38,'000000',0,'小程序','xcx','sys_device_type','','default','N',103,1,'2026-03-09 08:58:37',NULL,NULL,'小程序'),(39,'000000',1,'已撤销','cancel','wf_business_status','','danger','N',103,1,'2026-03-09 08:59:23',NULL,NULL,'已撤销'),(40,'000000',2,'草稿','draft','wf_business_status','','info','N',103,1,'2026-03-09 08:59:23',NULL,NULL,'草稿'),(41,'000000',3,'待审核','waiting','wf_business_status','','primary','N',103,1,'2026-03-09 08:59:23',NULL,NULL,'待审核'),(42,'000000',4,'已完成','finish','wf_business_status','','success','N',103,1,'2026-03-09 08:59:23',NULL,NULL,'已完成'),(43,'000000',5,'已作废','invalid','wf_business_status','','danger','N',103,1,'2026-03-09 08:59:23',NULL,NULL,'已作废'),(44,'000000',6,'已退回','back','wf_business_status','','danger','N',103,1,'2026-03-09 08:59:23',NULL,NULL,'已退回'),(45,'000000',7,'已终止','termination','wf_business_status','','danger','N',103,1,'2026-03-09 08:59:23',NULL,NULL,'已终止'),(46,'000000',1,'自定义表单','static','wf_form_type','','success','N',103,1,'2026-03-09 08:59:23',NULL,NULL,'自定义表单'),(47,'000000',2,'动态表单','dynamic','wf_form_type','','primary','N',103,1,'2026-03-09 08:59:23',NULL,NULL,'动态表单'),(48,'000000',1,'撤销','cancel','wf_task_status','','danger','N',103,1,'2026-03-09 08:59:23',NULL,NULL,'撤销'),(49,'000000',2,'通过','pass','wf_task_status','','success','N',103,1,'2026-03-09 08:59:23',NULL,NULL,'通过'),(50,'000000',3,'待审核','waiting','wf_task_status','','primary','N',103,1,'2026-03-09 08:59:23',NULL,NULL,'待审核'),(51,'000000',4,'作废','invalid','wf_task_status','','danger','N',103,1,'2026-03-09 08:59:23',NULL,NULL,'作废'),(52,'000000',5,'退回','back','wf_task_status','','danger','N',103,1,'2026-03-09 08:59:23',NULL,NULL,'退回'),(53,'000000',6,'终止','termination','wf_task_status','','danger','N',103,1,'2026-03-09 08:59:23',NULL,NULL,'终止'),(54,'000000',7,'转办','transfer','wf_task_status','','primary','N',103,1,'2026-03-09 08:59:23',NULL,NULL,'转办'),(55,'000000',8,'委托','depute','wf_task_status','','primary','N',103,1,'2026-03-09 08:59:23',NULL,NULL,'委托'),(56,'000000',9,'抄送','copy','wf_task_status','','primary','N',103,1,'2026-03-09 08:59:23',NULL,NULL,'抄送'),(57,'000000',10,'加签','sign','wf_task_status','','primary','N',103,1,'2026-03-09 08:59:23',NULL,NULL,'加签'),(58,'000000',11,'减签','sign_off','wf_task_status','','danger','N',103,1,'2026-03-09 08:59:23',NULL,NULL,'减签'),(59,'000000',11,'超时','timeout','wf_task_status','','danger','N',103,1,'2026-03-09 08:59:23',NULL,NULL,'超时');
/*!40000 ALTER TABLE `sys_dict_data` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_dict_type`
--

DROP TABLE IF EXISTS `sys_dict_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_dict_type` (
  `dict_id` bigint NOT NULL COMMENT '字典主键',
  `tenant_id` varchar(20) DEFAULT '000000' COMMENT '租户编号',
  `dict_name` varchar(100) DEFAULT '' COMMENT '字典名称',
  `dict_type` varchar(100) DEFAULT '' COMMENT '字典类型',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_id`),
  UNIQUE KEY `tenant_id` (`tenant_id`,`dict_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='字典类型表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_dict_type`
--

LOCK TABLES `sys_dict_type` WRITE;
/*!40000 ALTER TABLE `sys_dict_type` DISABLE KEYS */;
INSERT INTO `sys_dict_type` VALUES (1,'000000','用户性别','sys_user_sex',103,1,'2026-03-09 08:58:37',NULL,NULL,'用户性别列表'),(2,'000000','菜单状态','sys_show_hide',103,1,'2026-03-09 08:58:37',NULL,NULL,'菜单状态列表'),(3,'000000','系统开关','sys_normal_disable',103,1,'2026-03-09 08:58:37',NULL,NULL,'系统开关列表'),(6,'000000','系统是否','sys_yes_no',103,1,'2026-03-09 08:58:37',NULL,NULL,'系统是否列表'),(7,'000000','通知类型','sys_notice_type',103,1,'2026-03-09 08:58:37',NULL,NULL,'通知类型列表'),(8,'000000','通知状态','sys_notice_status',103,1,'2026-03-09 08:58:37',NULL,NULL,'通知状态列表'),(9,'000000','操作类型','sys_oper_type',103,1,'2026-03-09 08:58:37',NULL,NULL,'操作类型列表'),(10,'000000','系统状态','sys_common_status',103,1,'2026-03-09 08:58:37',NULL,NULL,'登录状态列表'),(11,'000000','授权类型','sys_grant_type',103,1,'2026-03-09 08:58:37',NULL,NULL,'认证授权类型'),(12,'000000','设备类型','sys_device_type',103,1,'2026-03-09 08:58:37',NULL,NULL,'客户端设备类型'),(13,'000000','业务状态','wf_business_status',103,1,'2026-03-09 08:59:23',NULL,NULL,'业务状态列表'),(14,'000000','表单类型','wf_form_type',103,1,'2026-03-09 08:59:23',NULL,NULL,'表单类型列表'),(15,'000000','任务状态','wf_task_status',103,1,'2026-03-09 08:59:23',NULL,NULL,'任务状态');
/*!40000 ALTER TABLE `sys_dict_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_logininfor`
--

DROP TABLE IF EXISTS `sys_logininfor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_logininfor` (
  `info_id` bigint NOT NULL COMMENT '访问ID',
  `tenant_id` varchar(20) DEFAULT '000000' COMMENT '租户编号',
  `user_name` varchar(50) DEFAULT '' COMMENT '用户账号',
  `client_key` varchar(32) DEFAULT '' COMMENT '客户端',
  `device_type` varchar(32) DEFAULT '' COMMENT '设备类型',
  `ipaddr` varchar(128) DEFAULT '' COMMENT '登录IP地址',
  `login_location` varchar(255) DEFAULT '' COMMENT '登录地点',
  `browser` varchar(50) DEFAULT '' COMMENT '浏览器类型',
  `os` varchar(50) DEFAULT '' COMMENT '操作系统',
  `status` char(1) DEFAULT '0' COMMENT '登录状态（0成功 1失败）',
  `msg` varchar(255) DEFAULT '' COMMENT '提示消息',
  `login_time` datetime DEFAULT NULL COMMENT '访问时间',
  PRIMARY KEY (`info_id`),
  KEY `idx_sys_logininfor_s` (`status`),
  KEY `idx_sys_logininfor_lt` (`login_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='系统访问记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_logininfor`
--

LOCK TABLES `sys_logininfor` WRITE;
/*!40000 ALTER TABLE `sys_logininfor` DISABLE KEYS */;
INSERT INTO `sys_logininfor` VALUES (2030813529841975297,'000000','admin','pc','pc','127.0.0.1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','登录成功','2026-03-09 09:10:51'),(2030836688762814466,'000000','admin','pc','pc','127.0.0.1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','退出成功','2026-03-09 10:42:52'),(2030836707884646401,'000000','admin','pc','pc','127.0.0.1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','登录成功','2026-03-09 10:42:57'),(2030837522376540161,'000000','admin','pc','pc','127.0.0.1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','退出成功','2026-03-09 10:46:11'),(2030837575124107265,'000000','zhangsan','pc','pc','127.0.0.1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','登录成功','2026-03-09 10:46:24'),(2030837706649092098,'000000','zhangsan','pc','pc','127.0.0.1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','退出成功','2026-03-09 10:46:55'),(2030837869899792385,'000000','admin','pc','pc','127.0.0.1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','登录成功','2026-03-09 10:47:34'),(2030838263963041793,'000000','admin','pc','pc','127.0.0.1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','退出成功','2026-03-09 10:49:08'),(2030838301720166401,'000000','zhangsan','pc','pc','127.0.0.1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','登录成功','2026-03-09 10:49:17'),(2030843117913620481,'000000','zhangsan','pc','pc','127.0.0.1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','退出成功','2026-03-09 11:08:25'),(2030843130890797057,'000000','admin','pc','pc','127.0.0.1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','登录成功','2026-03-09 11:08:28'),(2030846549131116545,'000000','admin','pc','pc','127.0.0.1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','退出成功','2026-03-09 11:22:03'),(2030846617183698945,'000000','zhangsan','pc','pc','127.0.0.1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','登录成功','2026-03-09 11:22:20'),(2030846684141568002,'000000','zhangsan','pc','pc','127.0.0.1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','退出成功','2026-03-09 11:22:35'),(2030846700004425730,'000000','admin','pc','pc','127.0.0.1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','登录成功','2026-03-09 11:22:39'),(2030847999030706177,'000000','admin','pc','pc','127.0.0.1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','退出成功','2026-03-09 11:27:49'),(2031176490360094722,'000000','zhangsan','pc','pc','127.0.0.1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','登录成功','2026-03-10 09:13:07'),(2031176514255044610,'000000','zhangsan','pc','pc','127.0.0.1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','退出成功','2026-03-10 09:13:13'),(2031176569204621313,'000000','admin','pc','pc','127.0.0.1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','登录成功','2026-03-10 09:13:26'),(2031176726025453569,'000000','admin','pc','pc','127.0.0.1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','退出成功','2026-03-10 09:14:04'),(2031176738021163009,'000000','zhangsan','pc','pc','127.0.0.1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','登录成功','2026-03-10 09:14:06'),(2031177252347691009,'000000','zhangsan','pc','pc','127.0.0.1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','退出成功','2026-03-10 09:16:09'),(2031177277744201729,'000000','zhangsan','pc','pc','127.0.0.1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','登录成功','2026-03-10 09:16:15'),(2031177331083165698,'000000','zhangsan','pc','pc','127.0.0.1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','退出成功','2026-03-10 09:16:28'),(2031177386619944962,'000000','admin','pc','pc','127.0.0.1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','登录成功','2026-03-10 09:16:41'),(2031177516723060738,'000000','admin','pc','pc','127.0.0.1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','退出成功','2026-03-10 09:17:12'),(2031177585874550786,'000000','zhangsan','pc','pc','127.0.0.1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','登录成功','2026-03-10 09:17:29'),(2031177725519708162,'000000','zhangsan','pc','pc','127.0.0.1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','退出成功','2026-03-10 09:18:02'),(2031177761548779521,'000000','admin','pc','pc','127.0.0.1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','登录成功','2026-03-10 09:18:10'),(2031177878481780737,'000000','admin','pc','pc','127.0.0.1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','退出成功','2026-03-10 09:18:38'),(2031177892897603585,'000000','zhangsan','pc','pc','127.0.0.1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','登录成功','2026-03-10 09:18:42'),(2031179987189088258,'000000','zhangsan','pc','pc','127.0.0.1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','退出成功','2026-03-10 09:27:01'),(2031180025462112258,'000000','wangwu','pc','pc','127.0.0.1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','登录成功','2026-03-10 09:27:10'),(2031180331814076418,'000000','wangwu','pc','pc','127.0.0.1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','退出成功','2026-03-10 09:28:23'),(2031180349614702594,'000000','zhangsan','pc','pc','127.0.0.1','内网IP','Chrome','Windows 10 or Windows Server 2016','0','登录成功','2026-03-10 09:28:28');
/*!40000 ALTER TABLE `sys_logininfor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_menu`
--

DROP TABLE IF EXISTS `sys_menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_menu` (
  `menu_id` bigint NOT NULL COMMENT '菜单ID',
  `menu_name` varchar(50) NOT NULL COMMENT '菜单名称',
  `parent_id` bigint DEFAULT '0' COMMENT '父菜单ID',
  `order_num` int DEFAULT '0' COMMENT '显示顺序',
  `path` varchar(200) DEFAULT '' COMMENT '路由地址',
  `component` varchar(255) DEFAULT NULL COMMENT '组件路径',
  `query_param` varchar(255) DEFAULT NULL COMMENT '路由参数',
  `is_frame` int DEFAULT '1' COMMENT '是否为外链（0是 1否）',
  `is_cache` int DEFAULT '0' COMMENT '是否缓存（0缓存 1不缓存）',
  `menu_type` char(1) DEFAULT '' COMMENT '菜单类型（M目录 C菜单 F按钮）',
  `visible` char(1) DEFAULT '0' COMMENT '显示状态（0显示 1隐藏）',
  `status` char(1) DEFAULT '0' COMMENT '菜单状态（0正常 1停用）',
  `perms` varchar(100) DEFAULT NULL COMMENT '权限标识',
  `icon` varchar(100) DEFAULT '#' COMMENT '菜单图标',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`menu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='菜单权限表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_menu`
--

LOCK TABLES `sys_menu` WRITE;
/*!40000 ALTER TABLE `sys_menu` DISABLE KEYS */;
INSERT INTO `sys_menu` VALUES (1,'系统管理',0,1,'system',NULL,'',1,0,'M','0','0','','system',103,1,'2026-03-09 08:58:35',NULL,NULL,'系统管理目录'),(2,'系统监控',0,3,'monitor',NULL,'',1,0,'M','0','0','','monitor',103,1,'2026-03-09 08:58:35',NULL,NULL,'系统监控目录'),(3,'系统工具',0,4,'tool',NULL,'',1,0,'M','1','0','','tool',103,1,'2026-03-09 08:58:35',1,'2026-03-09 09:12:54','系统工具目录'),(4,'PLUS官网',0,5,'https://gitee.com/dromara/RuoYi-Vue-Plus',NULL,'',0,0,'M','1','0','','guide',103,1,'2026-03-09 08:58:35',1,'2026-03-09 09:12:48','RuoYi-Vue-Plus官网地址'),(5,'测试菜单',0,5,'demo',NULL,'',1,0,'M','1','0','','star',103,1,'2026-03-09 08:58:35',1,'2026-03-09 09:12:44','测试菜单'),(6,'租户管理',0,2,'tenant',NULL,'',1,0,'M','1','0','','chart',103,1,'2026-03-09 08:58:35',1,'2026-03-09 09:13:02','租户管理目录'),(100,'用户管理',1,1,'user','system/user/index','',1,0,'C','0','0','system:user:list','user',103,1,'2026-03-09 08:58:35',NULL,NULL,'用户管理菜单'),(101,'角色管理',1,2,'role','system/role/index','',1,0,'C','0','0','system:role:list','peoples',103,1,'2026-03-09 08:58:35',NULL,NULL,'角色管理菜单'),(102,'菜单管理',1,3,'menu','system/menu/index','',1,0,'C','0','0','system:menu:list','tree-table',103,1,'2026-03-09 08:58:35',NULL,NULL,'菜单管理菜单'),(103,'部门管理',1,4,'dept','system/dept/index','',1,0,'C','0','0','system:dept:list','tree',103,1,'2026-03-09 08:58:35',NULL,NULL,'部门管理菜单'),(104,'岗位管理',1,5,'post','system/post/index','',1,0,'C','0','0','system:post:list','post',103,1,'2026-03-09 08:58:35',NULL,NULL,'岗位管理菜单'),(105,'字典管理',1,6,'dict','system/dict/index','',1,0,'C','0','0','system:dict:list','dict',103,1,'2026-03-09 08:58:35',NULL,NULL,'字典管理菜单'),(106,'参数设置',1,7,'config','system/config/index','',1,0,'C','0','0','system:config:list','edit',103,1,'2026-03-09 08:58:35',NULL,NULL,'参数设置菜单'),(107,'通知公告',1,8,'notice','system/notice/index','',1,0,'C','0','0','system:notice:list','message',103,1,'2026-03-09 08:58:35',NULL,NULL,'通知公告菜单'),(108,'日志管理',1,9,'log','','',1,0,'M','0','0','','log',103,1,'2026-03-09 08:58:35',NULL,NULL,'日志管理菜单'),(109,'在线用户',2,1,'online','monitor/online/index','',1,0,'C','0','0','monitor:online:list','online',103,1,'2026-03-09 08:58:35',NULL,NULL,'在线用户菜单'),(113,'缓存监控',2,5,'cache','monitor/cache/index','',1,0,'C','0','0','monitor:cache:list','redis',103,1,'2026-03-09 08:58:35',NULL,NULL,'缓存监控菜单'),(115,'代码生成',3,2,'gen','tool/gen/index','',1,0,'C','0','0','tool:gen:list','code',103,1,'2026-03-09 08:58:35',NULL,NULL,'代码生成菜单'),(116,'修改生成配置',3,2,'gen-edit/index/:tableId','tool/gen/editTable','',1,1,'C','1','0','tool:gen:edit','#',103,1,'2026-03-09 08:58:35',NULL,NULL,'/tool/gen'),(117,'Admin监控',2,5,'Admin','monitor/admin/index','',1,0,'C','0','0','monitor:admin:list','dashboard',103,1,'2026-03-09 08:58:35',NULL,NULL,'Admin监控菜单'),(118,'文件管理',1,10,'oss','system/oss/index','',1,0,'C','0','0','system:oss:list','upload',103,1,'2026-03-09 08:58:35',NULL,NULL,'文件管理菜单'),(120,'任务调度中心',2,6,'snailjob','monitor/snailjob/index','',1,0,'C','0','0','monitor:snailjob:list','job',103,1,'2026-03-09 08:58:35',NULL,NULL,'SnailJob控制台菜单'),(121,'租户管理',6,1,'tenant','system/tenant/index','',1,0,'C','0','0','system:tenant:list','list',103,1,'2026-03-09 08:58:35',NULL,NULL,'租户管理菜单'),(122,'租户套餐管理',6,2,'tenantPackage','system/tenantPackage/index','',1,0,'C','0','0','system:tenantPackage:list','form',103,1,'2026-03-09 08:58:35',NULL,NULL,'租户套餐管理菜单'),(123,'客户端管理',1,11,'client','system/client/index','',1,0,'C','0','0','system:client:list','international',103,1,'2026-03-09 08:58:35',NULL,NULL,'客户端管理菜单'),(130,'分配用户',1,2,'role-auth/user/:roleId','system/role/authUser','',1,1,'C','1','0','system:role:edit','#',103,1,'2026-03-09 08:58:35',NULL,NULL,'/system/role'),(131,'分配角色',1,1,'user-auth/role/:userId','system/user/authRole','',1,1,'C','1','0','system:user:edit','#',103,1,'2026-03-09 08:58:35',NULL,NULL,'/system/user'),(132,'字典数据',1,6,'dict-data/index/:dictId','system/dict/data','',1,1,'C','1','0','system:dict:list','#',103,1,'2026-03-09 08:58:35',NULL,NULL,'/system/dict'),(133,'文件配置管理',1,10,'oss-config/index','system/oss/config','',1,1,'C','1','0','system:ossConfig:list','#',103,1,'2026-03-09 08:58:35',NULL,NULL,'/system/oss'),(500,'操作日志',108,1,'operlog','monitor/operlog/index','',1,0,'C','0','0','monitor:operlog:list','form',103,1,'2026-03-09 08:58:35',NULL,NULL,'操作日志菜单'),(501,'登录日志',108,2,'logininfor','monitor/logininfor/index','',1,0,'C','0','0','monitor:logininfor:list','logininfor',103,1,'2026-03-09 08:58:35',NULL,NULL,'登录日志菜单'),(1001,'用户查询',100,1,'','','',1,0,'F','0','0','system:user:query','#',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(1002,'用户新增',100,2,'','','',1,0,'F','0','0','system:user:add','#',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(1003,'用户修改',100,3,'','','',1,0,'F','0','0','system:user:edit','#',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(1004,'用户删除',100,4,'','','',1,0,'F','0','0','system:user:remove','#',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(1005,'用户导出',100,5,'','','',1,0,'F','0','0','system:user:export','#',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(1006,'用户导入',100,6,'','','',1,0,'F','0','0','system:user:import','#',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(1007,'重置密码',100,7,'','','',1,0,'F','0','0','system:user:resetPwd','#',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(1008,'角色查询',101,1,'','','',1,0,'F','0','0','system:role:query','#',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(1009,'角色新增',101,2,'','','',1,0,'F','0','0','system:role:add','#',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(1010,'角色修改',101,3,'','','',1,0,'F','0','0','system:role:edit','#',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(1011,'角色删除',101,4,'','','',1,0,'F','0','0','system:role:remove','#',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(1012,'角色导出',101,5,'','','',1,0,'F','0','0','system:role:export','#',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(1013,'菜单查询',102,1,'','','',1,0,'F','0','0','system:menu:query','#',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(1014,'菜单新增',102,2,'','','',1,0,'F','0','0','system:menu:add','#',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(1015,'菜单修改',102,3,'','','',1,0,'F','0','0','system:menu:edit','#',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(1016,'菜单删除',102,4,'','','',1,0,'F','0','0','system:menu:remove','#',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(1017,'部门查询',103,1,'','','',1,0,'F','0','0','system:dept:query','#',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(1018,'部门新增',103,2,'','','',1,0,'F','0','0','system:dept:add','#',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(1019,'部门修改',103,3,'','','',1,0,'F','0','0','system:dept:edit','#',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(1020,'部门删除',103,4,'','','',1,0,'F','0','0','system:dept:remove','#',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(1021,'岗位查询',104,1,'','','',1,0,'F','0','0','system:post:query','#',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(1022,'岗位新增',104,2,'','','',1,0,'F','0','0','system:post:add','#',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(1023,'岗位修改',104,3,'','','',1,0,'F','0','0','system:post:edit','#',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(1024,'岗位删除',104,4,'','','',1,0,'F','0','0','system:post:remove','#',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(1025,'岗位导出',104,5,'','','',1,0,'F','0','0','system:post:export','#',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(1026,'字典查询',105,1,'#','','',1,0,'F','0','0','system:dict:query','#',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(1027,'字典新增',105,2,'#','','',1,0,'F','0','0','system:dict:add','#',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(1028,'字典修改',105,3,'#','','',1,0,'F','0','0','system:dict:edit','#',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(1029,'字典删除',105,4,'#','','',1,0,'F','0','0','system:dict:remove','#',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(1030,'字典导出',105,5,'#','','',1,0,'F','0','0','system:dict:export','#',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(1031,'参数查询',106,1,'#','','',1,0,'F','0','0','system:config:query','#',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(1032,'参数新增',106,2,'#','','',1,0,'F','0','0','system:config:add','#',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(1033,'参数修改',106,3,'#','','',1,0,'F','0','0','system:config:edit','#',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(1034,'参数删除',106,4,'#','','',1,0,'F','0','0','system:config:remove','#',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(1035,'参数导出',106,5,'#','','',1,0,'F','0','0','system:config:export','#',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(1036,'公告查询',107,1,'#','','',1,0,'F','0','0','system:notice:query','#',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(1037,'公告新增',107,2,'#','','',1,0,'F','0','0','system:notice:add','#',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(1038,'公告修改',107,3,'#','','',1,0,'F','0','0','system:notice:edit','#',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(1039,'公告删除',107,4,'#','','',1,0,'F','0','0','system:notice:remove','#',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(1040,'操作查询',500,1,'#','','',1,0,'F','0','0','monitor:operlog:query','#',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(1041,'操作删除',500,2,'#','','',1,0,'F','0','0','monitor:operlog:remove','#',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(1042,'日志导出',500,4,'#','','',1,0,'F','0','0','monitor:operlog:export','#',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(1043,'登录查询',501,1,'#','','',1,0,'F','0','0','monitor:logininfor:query','#',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(1044,'登录删除',501,2,'#','','',1,0,'F','0','0','monitor:logininfor:remove','#',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(1045,'日志导出',501,3,'#','','',1,0,'F','0','0','monitor:logininfor:export','#',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(1046,'在线查询',109,1,'#','','',1,0,'F','0','0','monitor:online:query','#',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(1047,'批量强退',109,2,'#','','',1,0,'F','0','0','monitor:online:batchLogout','#',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(1048,'单条强退',109,3,'#','','',1,0,'F','0','0','monitor:online:forceLogout','#',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(1050,'账户解锁',501,4,'#','','',1,0,'F','0','0','monitor:logininfor:unlock','#',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(1055,'生成查询',115,1,'#','','',1,0,'F','0','0','tool:gen:query','#',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(1056,'生成修改',115,2,'#','','',1,0,'F','0','0','tool:gen:edit','#',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(1057,'生成删除',115,3,'#','','',1,0,'F','0','0','tool:gen:remove','#',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(1058,'导入代码',115,2,'#','','',1,0,'F','0','0','tool:gen:import','#',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(1059,'预览代码',115,4,'#','','',1,0,'F','0','0','tool:gen:preview','#',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(1060,'生成代码',115,5,'#','','',1,0,'F','0','0','tool:gen:code','#',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(1061,'客户端管理查询',123,1,'#','','',1,0,'F','0','0','system:client:query','#',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(1062,'客户端管理新增',123,2,'#','','',1,0,'F','0','0','system:client:add','#',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(1063,'客户端管理修改',123,3,'#','','',1,0,'F','0','0','system:client:edit','#',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(1064,'客户端管理删除',123,4,'#','','',1,0,'F','0','0','system:client:remove','#',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(1065,'客户端管理导出',123,5,'#','','',1,0,'F','0','0','system:client:export','#',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(1500,'测试单表',5,1,'demo','demo/demo/index','',1,0,'C','0','0','demo:demo:list','#',103,1,'2026-03-09 08:58:36',NULL,NULL,'测试单表菜单'),(1501,'测试单表查询',1500,1,'#','','',1,0,'F','0','0','demo:demo:query','#',103,1,'2026-03-09 08:58:36',NULL,NULL,''),(1502,'测试单表新增',1500,2,'#','','',1,0,'F','0','0','demo:demo:add','#',103,1,'2026-03-09 08:58:36',NULL,NULL,''),(1503,'测试单表修改',1500,3,'#','','',1,0,'F','0','0','demo:demo:edit','#',103,1,'2026-03-09 08:58:36',NULL,NULL,''),(1504,'测试单表删除',1500,4,'#','','',1,0,'F','0','0','demo:demo:remove','#',103,1,'2026-03-09 08:58:36',NULL,NULL,''),(1505,'测试单表导出',1500,5,'#','','',1,0,'F','0','0','demo:demo:export','#',103,1,'2026-03-09 08:58:36',NULL,NULL,''),(1506,'测试树表',5,1,'tree','demo/tree/index','',1,0,'C','0','0','demo:tree:list','#',103,1,'2026-03-09 08:58:36',NULL,NULL,'测试树表菜单'),(1507,'测试树表查询',1506,1,'#','','',1,0,'F','0','0','demo:tree:query','#',103,1,'2026-03-09 08:58:36',NULL,NULL,''),(1508,'测试树表新增',1506,2,'#','','',1,0,'F','0','0','demo:tree:add','#',103,1,'2026-03-09 08:58:36',NULL,NULL,''),(1509,'测试树表修改',1506,3,'#','','',1,0,'F','0','0','demo:tree:edit','#',103,1,'2026-03-09 08:58:36',NULL,NULL,''),(1510,'测试树表删除',1506,4,'#','','',1,0,'F','0','0','demo:tree:remove','#',103,1,'2026-03-09 08:58:36',NULL,NULL,''),(1511,'测试树表导出',1506,5,'#','','',1,0,'F','0','0','demo:tree:export','#',103,1,'2026-03-09 08:58:36',NULL,NULL,''),(1600,'文件查询',118,1,'#','','',1,0,'F','0','0','system:oss:query','#',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(1601,'文件上传',118,2,'#','','',1,0,'F','0','0','system:oss:upload','#',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(1602,'文件下载',118,3,'#','','',1,0,'F','0','0','system:oss:download','#',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(1603,'文件删除',118,4,'#','','',1,0,'F','0','0','system:oss:remove','#',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(1606,'租户查询',121,1,'#','','',1,0,'F','0','0','system:tenant:query','#',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(1607,'租户新增',121,2,'#','','',1,0,'F','0','0','system:tenant:add','#',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(1608,'租户修改',121,3,'#','','',1,0,'F','0','0','system:tenant:edit','#',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(1609,'租户删除',121,4,'#','','',1,0,'F','0','0','system:tenant:remove','#',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(1610,'租户导出',121,5,'#','','',1,0,'F','0','0','system:tenant:export','#',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(1611,'租户套餐查询',122,1,'#','','',1,0,'F','0','0','system:tenantPackage:query','#',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(1612,'租户套餐新增',122,2,'#','','',1,0,'F','0','0','system:tenantPackage:add','#',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(1613,'租户套餐修改',122,3,'#','','',1,0,'F','0','0','system:tenantPackage:edit','#',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(1614,'租户套餐删除',122,4,'#','','',1,0,'F','0','0','system:tenantPackage:remove','#',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(1615,'租户套餐导出',122,5,'#','','',1,0,'F','0','0','system:tenantPackage:export','#',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(1620,'配置列表',118,5,'#','','',1,0,'F','0','0','system:ossConfig:list','#',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(1621,'配置添加',118,6,'#','','',1,0,'F','0','0','system:ossConfig:add','#',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(1622,'配置编辑',118,6,'#','','',1,0,'F','0','0','system:ossConfig:edit','#',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(1623,'配置删除',118,6,'#','','',1,0,'F','0','0','system:ossConfig:remove','#',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(11616,'工作流',0,6,'workflow','','',1,0,'M','1','0','','workflow',103,1,'2026-03-09 08:59:23',1,'2026-03-09 09:12:38',''),(11618,'我的任务',0,7,'task','','',1,0,'M','1','0','','my-task',103,1,'2026-03-09 08:59:23',1,'2026-03-09 09:12:32',''),(11619,'我的待办',11618,2,'taskWaiting','workflow/task/taskWaiting','',1,1,'C','0','0','','waiting',103,1,'2026-03-09 08:59:23',NULL,NULL,''),(11620,'流程定义',11616,3,'processDefinition','workflow/processDefinition/index','',1,1,'C','0','0','','process-definition',103,1,'2026-03-09 08:59:23',NULL,NULL,''),(11621,'流程实例',11630,1,'processInstance','workflow/processInstance/index','',1,1,'C','0','0','','tree-table',103,1,'2026-03-09 08:59:23',NULL,NULL,''),(11622,'流程分类',11616,1,'category','workflow/category/index','',1,0,'C','0','0','workflow:category:list','category',103,1,'2026-03-09 08:59:23',NULL,NULL,''),(11623,'流程分类查询',11622,1,'#','','',1,0,'F','0','0','workflow:category:query','#',103,1,'2026-03-09 08:59:23',NULL,NULL,''),(11624,'流程分类新增',11622,2,'#','','',1,0,'F','0','0','workflow:category:add','#',103,1,'2026-03-09 08:59:23',NULL,NULL,''),(11625,'流程分类修改',11622,3,'#','','',1,0,'F','0','0','workflow:category:edit','#',103,1,'2026-03-09 08:59:23',NULL,NULL,''),(11626,'流程分类删除',11622,4,'#','','',1,0,'F','0','0','workflow:category:remove','#',103,1,'2026-03-09 08:59:23',NULL,NULL,''),(11627,'流程分类导出',11622,5,'#','','',1,0,'F','0','0','workflow:category:export','#',103,1,'2026-03-09 08:59:23',NULL,NULL,''),(11629,'我发起的',11618,1,'myDocument','workflow/task/myDocument','',1,1,'C','0','0','','guide',103,1,'2026-03-09 08:59:23',NULL,NULL,''),(11630,'流程监控',11616,4,'monitor','','',1,0,'M','0','0','','monitor',103,1,'2026-03-09 08:59:23',NULL,NULL,''),(11631,'待办任务',11630,2,'allTaskWaiting','workflow/task/allTaskWaiting','',1,1,'C','0','0','','waiting',103,1,'2026-03-09 08:59:23',NULL,NULL,''),(11632,'我的已办',11618,3,'taskFinish','workflow/task/taskFinish','',1,1,'C','0','0','','finish',103,1,'2026-03-09 08:59:23',NULL,NULL,''),(11633,'我的抄送',11618,4,'taskCopyList','workflow/task/taskCopyList','',1,1,'C','0','0','','my-copy',103,1,'2026-03-09 08:59:23',NULL,NULL,''),(11638,'请假申请',5,1,'leave','workflow/leave/index','',1,0,'C','0','0','workflow:leave:list','#',103,1,'2026-03-09 08:59:23',NULL,NULL,'请假申请菜单'),(11639,'请假申请查询',11638,1,'#','','',1,0,'F','0','0','workflow:leave:query','#',103,1,'2026-03-09 08:59:23',NULL,NULL,''),(11640,'请假申请新增',11638,2,'#','','',1,0,'F','0','0','workflow:leave:add','#',103,1,'2026-03-09 08:59:23',NULL,NULL,''),(11641,'请假申请修改',11638,3,'#','','',1,0,'F','0','0','workflow:leave:edit','#',103,1,'2026-03-09 08:59:23',NULL,NULL,''),(11642,'请假申请删除',11638,4,'#','','',1,0,'F','0','0','workflow:leave:remove','#',103,1,'2026-03-09 08:59:23',NULL,NULL,''),(11643,'请假申请导出',11638,5,'#','','',1,0,'F','0','0','workflow:leave:export','#',103,1,'2026-03-09 08:59:23',NULL,NULL,''),(11700,'流程设计',11616,5,'design/index','workflow/processDefinition/design','',1,1,'C','1','0','workflow:leave:edit','#',103,1,'2026-03-09 08:59:23',NULL,NULL,'/workflow/processDefinition'),(11701,'请假申请',11616,6,'leaveEdit/index','workflow/leave/leaveEdit','',1,1,'C','1','0','workflow:leave:edit','#',103,1,'2026-03-09 08:59:23',NULL,NULL,''),(11801,'流程表达式',11616,2,'spel','workflow/spel/index','',1,0,'C','0','0','workflow:spel:list','input',103,1,'2026-03-09 08:59:23',1,'2026-03-09 08:59:23','流程达式定义菜单'),(11802,'流程达式定义查询',11801,1,'#','',NULL,1,0,'F','0','0','workflow:spel:query','#',103,1,'2026-03-09 08:59:23',NULL,NULL,''),(11803,'流程达式定义新增',11801,2,'#','',NULL,1,0,'F','0','0','workflow:spel:add','#',103,1,'2026-03-09 08:59:23',NULL,NULL,''),(11804,'流程达式定义修改',11801,3,'#','',NULL,1,0,'F','0','0','workflow:spel:edit','#',103,1,'2026-03-09 08:59:23',NULL,NULL,''),(11805,'流程达式定义删除',11801,4,'#','',NULL,1,0,'F','0','0','workflow:spel:remove','#',103,1,'2026-03-09 08:59:23',NULL,NULL,''),(11806,'流程达式定义导出',11801,5,'#','',NULL,1,0,'F','0','0','workflow:spel:export','#',103,1,'2026-03-09 08:59:23',NULL,NULL,''),(11900,'安全存储',0,6,'secure',NULL,NULL,1,0,'M','0','0','','lock',103,1,'2026-03-09 09:56:34',NULL,NULL,'安全存储目录'),(11901,'我的文件',11900,1,'userFile','secure/userFile/UserFile',NULL,1,0,'C','0','0','secure:file:list','list',103,1,'2026-03-09 09:56:34',NULL,NULL,'我的文件菜单'),(11902,'文件审计',11900,2,'fileLog','secure/fileLog/FileLog',NULL,1,0,'C','0','0','secure:fileLog:list','log',103,1,'2026-03-09 10:32:33',1,'2026-03-09 11:08:49','文件操作日志菜单');
/*!40000 ALTER TABLE `sys_menu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_notice`
--

DROP TABLE IF EXISTS `sys_notice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_notice` (
  `notice_id` bigint NOT NULL COMMENT '公告ID',
  `tenant_id` varchar(20) DEFAULT '000000' COMMENT '租户编号',
  `notice_title` varchar(50) NOT NULL COMMENT '公告标题',
  `notice_type` char(1) NOT NULL COMMENT '公告类型（1通知 2公告）',
  `notice_content` longblob COMMENT '公告内容',
  `status` char(1) DEFAULT '0' COMMENT '公告状态（0正常 1关闭）',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`notice_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='通知公告表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_notice`
--

LOCK TABLES `sys_notice` WRITE;
/*!40000 ALTER TABLE `sys_notice` DISABLE KEYS */;
INSERT INTO `sys_notice` VALUES (1,'000000','温馨提醒：2018-07-01 新版本发布啦','2',_binary '新版本内容','0',103,1,'2026-03-09 08:58:37',NULL,NULL,'管理员'),(2,'000000','维护通知：2018-07-01 系统凌晨维护','1',_binary '维护内容','0',103,1,'2026-03-09 08:58:37',NULL,NULL,'管理员');
/*!40000 ALTER TABLE `sys_notice` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_oper_log`
--

DROP TABLE IF EXISTS `sys_oper_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_oper_log` (
  `oper_id` bigint NOT NULL COMMENT '日志主键',
  `tenant_id` varchar(20) DEFAULT '000000' COMMENT '租户编号',
  `title` varchar(50) DEFAULT '' COMMENT '模块标题',
  `business_type` int DEFAULT '0' COMMENT '业务类型（0其它 1新增 2修改 3删除）',
  `method` varchar(100) DEFAULT '' COMMENT '方法名称',
  `request_method` varchar(10) DEFAULT '' COMMENT '请求方式',
  `operator_type` int DEFAULT '0' COMMENT '操作类别（0其它 1后台用户 2手机端用户）',
  `oper_name` varchar(50) DEFAULT '' COMMENT '操作人员',
  `dept_name` varchar(50) DEFAULT '' COMMENT '部门名称',
  `oper_url` varchar(255) DEFAULT '' COMMENT '请求URL',
  `oper_ip` varchar(128) DEFAULT '' COMMENT '主机地址',
  `oper_location` varchar(255) DEFAULT '' COMMENT '操作地点',
  `oper_param` varchar(4000) DEFAULT '' COMMENT '请求参数',
  `json_result` varchar(4000) DEFAULT '' COMMENT '返回参数',
  `status` int DEFAULT '0' COMMENT '操作状态（0正常 1异常）',
  `error_msg` varchar(4000) DEFAULT '' COMMENT '错误消息',
  `oper_time` datetime DEFAULT NULL COMMENT '操作时间',
  `cost_time` bigint DEFAULT '0' COMMENT '消耗时间',
  PRIMARY KEY (`oper_id`),
  KEY `idx_sys_oper_log_bt` (`business_type`),
  KEY `idx_sys_oper_log_s` (`status`),
  KEY `idx_sys_oper_log_ot` (`oper_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='操作日志记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_oper_log`
--

LOCK TABLES `sys_oper_log` WRITE;
/*!40000 ALTER TABLE `sys_oper_log` DISABLE KEYS */;
INSERT INTO `sys_oper_log` VALUES (2030813955547054082,'000000','菜单管理',2,'org.dromara.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"createDept\":103,\"createBy\":null,\"createTime\":\"2026-03-09 08:59:23\",\"updateBy\":null,\"updateTime\":null,\"menuId\":11618,\"parentId\":0,\"menuName\":\"我的任务\",\"orderNum\":7,\"path\":\"task\",\"component\":\"\",\"queryParam\":\"\",\"isFrame\":\"1\",\"isCache\":\"0\",\"menuType\":\"M\",\"visible\":\"1\",\"status\":\"0\",\"perms\":\"\",\"icon\":\"my-task\",\"remark\":\"\"}','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-03-09 09:12:32',24),(2030813981224583169,'000000','菜单管理',2,'org.dromara.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"createDept\":103,\"createBy\":null,\"createTime\":\"2026-03-09 08:59:23\",\"updateBy\":null,\"updateTime\":null,\"menuId\":11616,\"parentId\":0,\"menuName\":\"工作流\",\"orderNum\":6,\"path\":\"workflow\",\"component\":\"\",\"queryParam\":\"\",\"isFrame\":\"1\",\"isCache\":\"0\",\"menuType\":\"M\",\"visible\":\"1\",\"status\":\"0\",\"perms\":\"\",\"icon\":\"workflow\",\"remark\":\"\"}','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-03-09 09:12:38',35),(2030814002586173441,'000000','菜单管理',2,'org.dromara.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"createDept\":103,\"createBy\":null,\"createTime\":\"2026-03-09 08:58:35\",\"updateBy\":null,\"updateTime\":null,\"menuId\":5,\"parentId\":0,\"menuName\":\"测试菜单\",\"orderNum\":5,\"path\":\"demo\",\"component\":null,\"queryParam\":\"\",\"isFrame\":\"1\",\"isCache\":\"0\",\"menuType\":\"M\",\"visible\":\"1\",\"status\":\"0\",\"perms\":\"\",\"icon\":\"star\",\"remark\":\"测试菜单\"}','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-03-09 09:12:44',25),(2030814020428742658,'000000','菜单管理',2,'org.dromara.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"createDept\":103,\"createBy\":null,\"createTime\":\"2026-03-09 08:58:35\",\"updateBy\":null,\"updateTime\":null,\"menuId\":4,\"parentId\":0,\"menuName\":\"PLUS官网\",\"orderNum\":5,\"path\":\"https://gitee.com/dromara/RuoYi-Vue-Plus\",\"component\":null,\"queryParam\":\"\",\"isFrame\":\"0\",\"isCache\":\"0\",\"menuType\":\"M\",\"visible\":\"1\",\"status\":\"0\",\"perms\":\"\",\"icon\":\"guide\",\"remark\":\"RuoYi-Vue-Plus官网地址\"}','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-03-09 09:12:48',23),(2030814047343591425,'000000','菜单管理',2,'org.dromara.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"createDept\":103,\"createBy\":null,\"createTime\":\"2026-03-09 08:58:35\",\"updateBy\":null,\"updateTime\":null,\"menuId\":3,\"parentId\":0,\"menuName\":\"系统工具\",\"orderNum\":4,\"path\":\"tool\",\"component\":null,\"queryParam\":\"\",\"isFrame\":\"1\",\"isCache\":\"0\",\"menuType\":\"M\",\"visible\":\"1\",\"status\":\"0\",\"perms\":\"\",\"icon\":\"tool\",\"remark\":\"系统工具目录\"}','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-03-09 09:12:54',36),(2030814079056723970,'000000','菜单管理',2,'org.dromara.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"createDept\":103,\"createBy\":null,\"createTime\":\"2026-03-09 08:58:35\",\"updateBy\":null,\"updateTime\":null,\"menuId\":6,\"parentId\":0,\"menuName\":\"租户管理\",\"orderNum\":2,\"path\":\"tenant\",\"component\":null,\"queryParam\":\"\",\"isFrame\":\"1\",\"isCache\":\"0\",\"menuType\":\"M\",\"visible\":\"1\",\"status\":\"0\",\"perms\":\"\",\"icon\":\"chart\",\"remark\":\"租户管理目录\"}','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-03-09 09:13:02',26),(2030814688753336321,'000000','OSS对象存储',1,'org.dromara.system.controller.system.SysOssController.upload()','POST',1,'admin','研发部门','/resource/oss/upload','127.0.0.1','内网IP','','',1,'上传文件失败，请检查配置信息:[subscription has been cancelled.]','2026-03-09 09:15:27',1383),(2030815274345283585,'000000','OSS对象存储',1,'org.dromara.system.controller.system.SysOssController.upload()','POST',1,'admin','研发部门','/resource/oss/upload','127.0.0.1','内网IP','','{\"code\":200,\"msg\":\"操作成功\",\"data\":{\"url\":\"http://127.0.0.1:9000/ruoyi/2026/03/09/7e17fc5e0d084d4ba329c8855f157c34.doc\",\"fileName\":\"A写作格式规范.doc\",\"ossId\":\"2030815274219454466\"}}',0,'','2026-03-09 09:17:47',83),(2030827586900828161,'000000','安全文件上传',1,'org.dromara.secure.controller.BizUserFileController.upload()','POST',1,'admin','研发部门','/secure/file/upload','127.0.0.1','内网IP','','',1,'\r\n### Error updating database.  Cause: java.sql.SQLSyntaxErrorException: Unknown column \'create_dept\' in \'field list\'\r\n### The error may exist in org/dromara/secure/mapper/BizUserFileMapper.java (best guess)\r\n### The error may involve org.dromara.secure.mapper.BizUserFileMapper.insert-Inline\r\n### The error occurred while setting parameters\r\n### SQL: INSERT INTO biz_user_file (user_id, oss_id, file_name, file_suffix, file_size, is_encrypted, create_dept, create_by, create_time, update_by, update_time) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)\r\n### Cause: java.sql.SQLSyntaxErrorException: Unknown column \'create_dept\' in \'field list\'\n; bad SQL grammar []','2026-03-09 10:06:42',866),(2030828203731951618,'000000','安全文件上传',1,'org.dromara.secure.controller.BizUserFileController.upload()','POST',1,'admin','研发部门','/secure/file/upload','127.0.0.1','内网IP','','{\"code\":200,\"msg\":\"操作成功\",\"data\":{\"createDept\":103,\"createBy\":1,\"createTime\":\"2026-03-09 10:09:09\",\"updateBy\":1,\"updateTime\":\"2026-03-09 10:09:09\",\"fileId\":1,\"userId\":1,\"ossId\":\"2030828203601928194\",\"fileName\":\"A写作格式规范.doc\",\"fileSuffix\":\"doc\",\"fileSize\":121856,\"isEncrypted\":\"1\",\"delFlag\":null}}',0,'','2026-03-09 10:09:09',60),(2030828230885875713,'000000','创建分享',1,'org.dromara.secure.controller.BizFileShareController.create()','POST',1,'admin','研发部门','/secure/share/create','127.0.0.1','内网IP','{\"needCode\":\"true\",\"fileId\":\"1\"}','{\"code\":200,\"msg\":\"操作成功\",\"data\":{\"shareId\":1,\"userId\":1,\"fileId\":1,\"shareLink\":\"ODQ7jJec\",\"extractCode\":\"3359\",\"expireTime\":null,\"status\":\"0\",\"createBy\":\"1\",\"createTime\":\"2026-03-09 10:09:15\"}}',0,'','2026-03-09 10:09:16',48),(2030828946081816577,'000000','创建分享',1,'org.dromara.secure.controller.BizFileShareController.create()','POST',1,'admin','研发部门','/secure/share/create','127.0.0.1','内网IP','{\"needCode\":\"true\",\"fileId\":\"1\"}','{\"code\":200,\"msg\":\"操作成功\",\"data\":{\"shareId\":2,\"userId\":1,\"fileId\":1,\"shareLink\":\"MdlQHkI7\",\"extractCode\":\"6779\",\"expireTime\":null,\"status\":\"0\",\"createBy\":\"1\",\"createTime\":\"2026-03-09 10:12:06\"}}',0,'','2026-03-09 10:12:06',41),(2030836971643453442,'000000','用户管理',1,'org.dromara.system.controller.system.SysUserController.add()','POST',1,'admin','研发部门','/system/user','127.0.0.1','内网IP','{\"createDept\":null,\"createBy\":null,\"createTime\":null,\"updateBy\":null,\"updateTime\":null,\"userId\":\"2030836971509235714\",\"deptId\":null,\"userName\":\"zhangsan\",\"nickName\":\"张三\",\"userType\":null,\"email\":null,\"phonenumber\":null,\"sex\":\"0\",\"status\":\"0\",\"remark\":\"\",\"roleIds\":[3],\"postIds\":[],\"roleId\":null,\"userIds\":null,\"excludeUserIds\":null,\"superAdmin\":false}','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-03-09 10:44:00',49),(2030837463501094914,'000000','角色管理',1,'org.dromara.system.controller.system.SysRoleController.add()','POST',1,'admin','研发部门','/system/role','127.0.0.1','内网IP','{\"createDept\":null,\"createBy\":null,\"createTime\":null,\"updateBy\":null,\"updateTime\":null,\"roleId\":\"2030837463400431618\",\"roleName\":\"管理员\",\"roleKey\":\"manager\",\"roleSort\":4,\"dataScope\":\"1\",\"menuCheckStrictly\":true,\"deptCheckStrictly\":true,\"status\":\"0\",\"remark\":\"\",\"menuIds\":[1,100,1001,1002,1003,1004,1005,1006,1007,131,101,1008,1009,1010,1011,1012,130,11900,11901,11902],\"deptIds\":[],\"superAdmin\":false}','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-03-09 10:45:57',55),(2030837510519242753,'000000','用户管理',2,'org.dromara.system.controller.system.SysUserController.edit()','PUT',1,'admin','研发部门','/system/user','127.0.0.1','内网IP','{\"createDept\":null,\"createBy\":null,\"createTime\":\"2026-03-09 10:44:00\",\"updateBy\":null,\"updateTime\":null,\"userId\":\"2030836971509235714\",\"deptId\":null,\"userName\":\"zhangsan\",\"nickName\":\"张三\",\"userType\":\"sys_user\",\"email\":\"\",\"phonenumber\":\"\",\"sex\":\"0\",\"status\":\"0\",\"remark\":\"\",\"roleIds\":[\"2030837463400431618\"],\"postIds\":null,\"roleId\":null,\"userIds\":null,\"excludeUserIds\":null,\"superAdmin\":false}','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-03-09 10:46:08',39),(2030838251304632321,'000000','角色管理',2,'org.dromara.system.controller.system.SysRoleController.edit()','PUT',1,'admin','研发部门','/system/role','127.0.0.1','内网IP','{\"createDept\":null,\"createBy\":null,\"createTime\":\"2026-03-09 10:45:57\",\"updateBy\":null,\"updateTime\":null,\"roleId\":\"2030837463400431618\",\"roleName\":\"管理员\",\"roleKey\":\"manager\",\"roleSort\":4,\"dataScope\":\"1\",\"menuCheckStrictly\":false,\"deptCheckStrictly\":true,\"status\":\"0\",\"remark\":\"\",\"menuIds\":[1,100,1001,1002,1003,1004,1005,1006,1007,131,101,1008,1009,1010,1011,1012,130,1013,1014,1015,1016,1040,1041,1042,1600,1601,1602,1603,1620,1621,1622,1623,133,11900,11901,11902],\"deptIds\":[],\"superAdmin\":false}','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-03-09 10:49:05',67),(2030838481949409281,'000000','安全文件上传',1,'org.dromara.secure.controller.BizUserFileController.upload()','POST',1,'zhangsan','','/secure/file/upload','127.0.0.1','内网IP','','{\"code\":200,\"msg\":\"操作成功\",\"data\":{\"createDept\":null,\"createBy\":\"2030836971509235714\",\"createTime\":\"2026-03-09 10:49:59\",\"updateBy\":\"2030836971509235714\",\"updateTime\":\"2026-03-09 10:49:59\",\"fileId\":2,\"userId\":\"2030836971509235714\",\"ossId\":\"2030838481886494722\",\"fileName\":\"A写作格式规范.doc\",\"fileSuffix\":\"doc\",\"fileSize\":121856,\"isEncrypted\":\"1\",\"delFlag\":null}}',0,'','2026-03-09 10:50:00',744),(2030838507866013698,'000000','创建分享',1,'org.dromara.secure.controller.BizFileShareController.create()','POST',1,'zhangsan','','/secure/share/create','127.0.0.1','内网IP','{\"expireDays\":\"1\",\"needCode\":\"false\",\"fileId\":\"2\"}','{\"code\":200,\"msg\":\"操作成功\",\"data\":{\"shareId\":3,\"userId\":\"2030836971509235714\",\"fileId\":2,\"shareLink\":\"6bzcvtB9\",\"extractCode\":null,\"expireTime\":\"2026-03-10 10:50:06\",\"status\":\"0\",\"createBy\":\"2030836971509235714\",\"createTime\":\"2026-03-09 10:50:06\"}}',0,'','2026-03-09 10:50:06',16),(2030843217880662017,'000000','菜单管理',2,'org.dromara.system.controller.system.SysMenuController.edit()','PUT',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"createDept\":103,\"createBy\":null,\"createTime\":\"2026-03-09 10:32:33\",\"updateBy\":null,\"updateTime\":null,\"menuId\":11902,\"parentId\":11900,\"menuName\":\"文件审计\",\"orderNum\":2,\"path\":\"fileLog\",\"component\":\"secure/fileLog/FileLog\",\"queryParam\":null,\"isFrame\":\"1\",\"isCache\":\"0\",\"menuType\":\"C\",\"visible\":\"0\",\"status\":\"0\",\"perms\":\"secure:fileLog:list\",\"icon\":\"log\",\"remark\":\"文件操作日志菜单\"}','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-03-09 11:08:49',46),(2030845909852078082,'000000','个人信息',2,'org.dromara.system.controller.system.SysProfileController.updateProfile()','PUT',1,'admin','研发部门','/system/user/profile','127.0.0.1','内网IP','{\"createDept\":null,\"createBy\":null,\"createTime\":null,\"updateBy\":null,\"updateTime\":null,\"nickName\":\"MIss Chen\",\"email\":\"crazyLionLi@163.com\",\"phonenumber\":\"15888888888\",\"sex\":\"1\"}','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-03-09 11:19:31',29),(2030846172155461634,'000000','用户头像',2,'org.dromara.system.controller.system.SysProfileController.avatar()','POST',1,'admin','研发部门','/system/user/profile/avatar','127.0.0.1','内网IP','','{\"code\":200,\"msg\":\"操作成功\",\"data\":{\"imgUrl\":\"http://127.0.0.1:9000/ruoyi/2026/03/09/be8469c5981742aa974e70b718afd6ee.jpg\"}}',0,'','2026-03-09 11:20:33',51),(2030846512363847682,'000000','用户头像',2,'org.dromara.system.controller.system.SysProfileController.avatar()','POST',1,'admin','研发部门','/system/user/profile/avatar','127.0.0.1','内网IP','','{\"code\":200,\"msg\":\"操作成功\",\"data\":{\"imgUrl\":\"http://127.0.0.1:9000/ruoyi/2026/03/09/365481722cab4540b37ed4412f6d4080.jpg\"}}',0,'','2026-03-09 11:21:55',40),(2030846665950871554,'000000','角色管理',3,'org.dromara.system.controller.system.SysRoleController.remove()','DELETE',1,'zhangsan','','/system/role/4','127.0.0.1','内网IP','[4]','',1,'仅本人已分配，不能删除!','2026-03-09 11:22:31',22),(2030846826957619201,'000000','角色管理',1,'org.dromara.system.controller.system.SysRoleController.add()','POST',1,'admin','研发部门','/system/role','127.0.0.1','内网IP','{\"createDept\":null,\"createBy\":null,\"createTime\":null,\"updateBy\":null,\"updateTime\":null,\"roleId\":\"2030846826877927426\",\"roleName\":\"普通用户\",\"roleKey\":\"common\",\"roleSort\":5,\"dataScope\":\"1\",\"menuCheckStrictly\":true,\"deptCheckStrictly\":true,\"status\":\"0\",\"remark\":\"\",\"menuIds\":[11900,11901],\"deptIds\":[],\"superAdmin\":false}','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-03-09 11:23:10',20),(2030847115609620481,'000000','用户管理',1,'org.dromara.system.controller.system.SysUserController.add()','POST',1,'admin','研发部门','/system/user','127.0.0.1','内网IP','{\"createDept\":null,\"createBy\":null,\"createTime\":null,\"updateBy\":null,\"updateTime\":null,\"userId\":\"2030847115479597058\",\"deptId\":null,\"userName\":\"lisi\",\"nickName\":\"李四\",\"userType\":null,\"email\":null,\"phonenumber\":null,\"sex\":null,\"status\":\"0\",\"remark\":\"\",\"roleIds\":[\"2030846826877927426\"],\"postIds\":[],\"roleId\":null,\"userIds\":null,\"excludeUserIds\":null,\"superAdmin\":false}','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-03-09 11:24:18',31),(2030847182156447745,'000000','用户管理',1,'org.dromara.system.controller.system.SysUserController.add()','POST',1,'admin','研发部门','/system/user','127.0.0.1','内网IP','{\"createDept\":null,\"createBy\":null,\"createTime\":null,\"updateBy\":null,\"updateTime\":null,\"userId\":\"2030847182076755970\",\"deptId\":null,\"userName\":\"wangwu\",\"nickName\":\"王五\",\"userType\":null,\"email\":null,\"phonenumber\":null,\"sex\":null,\"status\":\"0\",\"remark\":\"\",\"roleIds\":[\"2030846826877927426\"],\"postIds\":[],\"roleId\":null,\"userIds\":null,\"excludeUserIds\":null,\"superAdmin\":false}','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-03-09 11:24:34',22),(2030847254965370882,'000000','用户管理',1,'org.dromara.system.controller.system.SysUserController.add()','POST',1,'admin','研发部门','/system/user','127.0.0.1','内网IP','{\"createDept\":null,\"createBy\":null,\"createTime\":null,\"updateBy\":null,\"updateTime\":null,\"userId\":\"2030847254894067714\",\"deptId\":null,\"userName\":\"zhaoliu\",\"nickName\":\"赵六\",\"userType\":null,\"email\":null,\"phonenumber\":null,\"sex\":null,\"status\":\"0\",\"remark\":\"\",\"roleIds\":[\"2030846826877927426\"],\"postIds\":[],\"roleId\":null,\"userIds\":null,\"excludeUserIds\":null,\"superAdmin\":false}','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-03-09 11:24:52',28),(2031177032847179778,'000000','角色管理',3,'org.dromara.system.controller.system.SysRoleController.remove()','DELETE',1,'zhangsan','','/system/role/3','127.0.0.1','内网IP','[3]','',1,'本部门及以下已分配，不能删除!','2026-03-10 09:15:17',27),(2031177052182921217,'000000','角色管理',3,'org.dromara.system.controller.system.SysRoleController.remove()','DELETE',1,'zhangsan','','/system/role/3','127.0.0.1','内网IP','[3]','',1,'本部门及以下已分配，不能删除!','2026-03-10 09:15:21',6),(2031177313240596481,'000000','用户管理',2,'org.dromara.system.controller.system.SysUserController.changeStatus()','PUT',1,'zhangsan','','/system/user/changeStatus','127.0.0.1','内网IP','{\"createDept\":null,\"createBy\":null,\"createTime\":null,\"updateBy\":null,\"updateTime\":null,\"userId\":\"2030836971509235714\",\"deptId\":null,\"userName\":null,\"nickName\":null,\"userType\":null,\"email\":null,\"phonenumber\":null,\"sex\":null,\"status\":\"1\",\"remark\":null,\"roleIds\":null,\"postIds\":null,\"roleId\":null,\"userIds\":null,\"excludeUserIds\":null,\"superAdmin\":false}','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-03-10 09:16:24',10),(2031177321637593089,'000000','用户管理',2,'org.dromara.system.controller.system.SysUserController.changeStatus()','PUT',1,'zhangsan','','/system/user/changeStatus','127.0.0.1','内网IP','{\"createDept\":null,\"createBy\":null,\"createTime\":null,\"updateBy\":null,\"updateTime\":null,\"userId\":\"2030836971509235714\",\"deptId\":null,\"userName\":null,\"nickName\":null,\"userType\":null,\"email\":null,\"phonenumber\":null,\"sex\":null,\"status\":\"0\",\"remark\":null,\"roleIds\":null,\"postIds\":null,\"roleId\":null,\"userIds\":null,\"excludeUserIds\":null,\"superAdmin\":false}','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-03-10 09:16:26',11),(2031177502227546113,'000000','角色管理',2,'org.dromara.system.controller.system.SysRoleController.edit()','PUT',1,'admin','研发部门','/system/role','127.0.0.1','内网IP','{\"createDept\":null,\"createBy\":null,\"createTime\":\"2026-03-09 10:45:57\",\"updateBy\":null,\"updateTime\":null,\"roleId\":\"2030837463400431618\",\"roleName\":\"管理员\",\"roleKey\":\"manager\",\"roleSort\":4,\"dataScope\":\"1\",\"menuCheckStrictly\":false,\"deptCheckStrictly\":true,\"status\":\"0\",\"remark\":\"\",\"menuIds\":[1,100,1001,1002,1003,1004,1005,1006,1007,131,101,1008,1009,1010,1011,1012,130,1013,1014,1015,1016,1040,1041,1042,1600,1601,1602,1603,1620,1621,1622,1623,133,2,109,1046,1047,1048,113,117,11900,11901,11902],\"deptIds\":[],\"superAdmin\":false}','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-03-10 09:17:09',33),(2031177861129945089,'000000','角色管理',2,'org.dromara.system.controller.system.SysRoleController.edit()','PUT',1,'admin','研发部门','/system/role','127.0.0.1','内网IP','{\"createDept\":null,\"createBy\":null,\"createTime\":\"2026-03-09 10:45:57\",\"updateBy\":null,\"updateTime\":null,\"roleId\":\"2030837463400431618\",\"roleName\":\"管理员\",\"roleKey\":\"manager\",\"roleSort\":4,\"dataScope\":\"1\",\"menuCheckStrictly\":false,\"deptCheckStrictly\":true,\"status\":\"0\",\"remark\":\"\",\"menuIds\":[1,100,1001,1002,1003,1004,1005,1006,1007,131,101,1008,1009,1010,1011,1012,130,1013,1014,1015,1016,1040,1041,1042,1600,1601,1602,1603,1620,1621,1622,1623,133,2,109,1046,1047,1048,113,11900,11901,11902],\"deptIds\":[],\"superAdmin\":false}','{\"code\":200,\"msg\":\"操作成功\",\"data\":null}',0,'','2026-03-10 09:18:34',39);
/*!40000 ALTER TABLE `sys_oper_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_oss`
--

DROP TABLE IF EXISTS `sys_oss`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_oss` (
  `oss_id` bigint NOT NULL COMMENT '对象存储主键',
  `tenant_id` varchar(20) DEFAULT '000000' COMMENT '租户编号',
  `file_name` varchar(255) NOT NULL DEFAULT '' COMMENT '文件名',
  `original_name` varchar(255) NOT NULL DEFAULT '' COMMENT '原名',
  `file_suffix` varchar(10) NOT NULL DEFAULT '' COMMENT '文件后缀名',
  `url` varchar(500) NOT NULL COMMENT 'URL地址',
  `ext1` text COMMENT '扩展字段',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `create_by` bigint DEFAULT NULL COMMENT '上传人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新人',
  `service` varchar(20) NOT NULL DEFAULT 'minio' COMMENT '服务商',
  PRIMARY KEY (`oss_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='OSS对象存储表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_oss`
--

LOCK TABLES `sys_oss` WRITE;
/*!40000 ALTER TABLE `sys_oss` DISABLE KEYS */;
INSERT INTO `sys_oss` VALUES (2030815274219454466,'000000','2026/03/09/7e17fc5e0d084d4ba329c8855f157c34.doc','A写作格式规范.doc','.doc','http://127.0.0.1:9000/ruoyi/2026/03/09/7e17fc5e0d084d4ba329c8855f157c34.doc','{\"bizType\":null,\"fileSize\":121856,\"contentType\":\"application/msword\",\"source\":null,\"uploadIp\":null,\"remark\":null,\"tags\":null,\"refId\":null,\"refType\":null,\"isTemp\":null,\"md5\":null}',103,'2026-03-09 09:17:47',1,'2026-03-09 09:17:47',1,'minio'),(2030827586359762946,'000000','2026/03/09/a1154d2b85b14d38a83bb915df1da130.doc','A写作格式规范.doc','.doc','http://127.0.0.1:9000/ruoyi/2026/03/09/a1154d2b85b14d38a83bb915df1da130.doc','{\"bizType\":null,\"fileSize\":121888,\"contentType\":\"application/octet-stream\",\"source\":null,\"uploadIp\":null,\"remark\":null,\"tags\":null,\"refId\":null,\"refType\":null,\"isTemp\":null,\"md5\":null}',103,'2026-03-09 10:06:42',1,'2026-03-09 10:06:42',1,'minio'),(2030828203601928194,'000000','2026/03/09/debb57f1933940f6bcdb704947714794.doc','A写作格式规范.doc','.doc','http://127.0.0.1:9000/ruoyi/2026/03/09/debb57f1933940f6bcdb704947714794.doc','{\"bizType\":null,\"fileSize\":121888,\"contentType\":\"application/octet-stream\",\"source\":null,\"uploadIp\":null,\"remark\":null,\"tags\":null,\"refId\":null,\"refType\":null,\"isTemp\":null,\"md5\":null}',103,'2026-03-09 10:09:09',1,'2026-03-09 10:09:09',1,'minio'),(2030838481886494722,'000000','2026/03/09/1faa52a219ab478195021f1f179506dd.doc','A写作格式规范.doc','.doc','http://127.0.0.1:9000/ruoyi/2026/03/09/1faa52a219ab478195021f1f179506dd.doc','{\"bizType\":null,\"fileSize\":121888,\"contentType\":\"application/octet-stream\",\"source\":null,\"uploadIp\":null,\"remark\":null,\"tags\":null,\"refId\":null,\"refType\":null,\"isTemp\":null,\"md5\":null}',NULL,'2026-03-09 10:50:00',2030836971509235714,'2026-03-09 10:50:00',2030836971509235714,'minio'),(2030846172021243905,'000000','2026/03/09/be8469c5981742aa974e70b718afd6ee.jpg','微信图片_2026-03-09_112016_574.jpg','.jpg','http://127.0.0.1:9000/ruoyi/2026/03/09/be8469c5981742aa974e70b718afd6ee.jpg','{\"bizType\":null,\"fileSize\":121905,\"contentType\":\"image/png\",\"source\":null,\"uploadIp\":null,\"remark\":null,\"tags\":null,\"refId\":null,\"refType\":null,\"isTemp\":null,\"md5\":null}',103,'2026-03-09 11:20:33',1,'2026-03-09 11:20:33',1,'minio'),(2030846512238018562,'000000','2026/03/09/365481722cab4540b37ed4412f6d4080.jpg','微信图片_2026-03-09_112016_574.jpg','.jpg','http://127.0.0.1:9000/ruoyi/2026/03/09/365481722cab4540b37ed4412f6d4080.jpg','{\"bizType\":null,\"fileSize\":117919,\"contentType\":\"image/png\",\"source\":null,\"uploadIp\":null,\"remark\":null,\"tags\":null,\"refId\":null,\"refType\":null,\"isTemp\":null,\"md5\":null}',103,'2026-03-09 11:21:54',1,'2026-03-09 11:21:54',1,'minio');
/*!40000 ALTER TABLE `sys_oss` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_oss_config`
--

DROP TABLE IF EXISTS `sys_oss_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_oss_config` (
  `oss_config_id` bigint NOT NULL COMMENT '主键',
  `tenant_id` varchar(20) DEFAULT '000000' COMMENT '租户编号',
  `config_key` varchar(20) NOT NULL DEFAULT '' COMMENT '配置key',
  `access_key` varchar(255) DEFAULT '' COMMENT 'accessKey',
  `secret_key` varchar(255) DEFAULT '' COMMENT '秘钥',
  `bucket_name` varchar(255) DEFAULT '' COMMENT '桶名称',
  `prefix` varchar(255) DEFAULT '' COMMENT '前缀',
  `endpoint` varchar(255) DEFAULT '' COMMENT '访问站点',
  `domain` varchar(255) DEFAULT '' COMMENT '自定义域名',
  `is_https` char(1) DEFAULT 'N' COMMENT '是否https（Y=是,N=否）',
  `region` varchar(255) DEFAULT '' COMMENT '域',
  `access_policy` char(1) NOT NULL DEFAULT '1' COMMENT '桶权限类型(0=private 1=public 2=custom)',
  `status` char(1) DEFAULT '1' COMMENT '是否默认（0=是,1=否）',
  `ext1` varchar(255) DEFAULT '' COMMENT '扩展字段',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`oss_config_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='对象存储配置表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_oss_config`
--

LOCK TABLES `sys_oss_config` WRITE;
/*!40000 ALTER TABLE `sys_oss_config` DISABLE KEYS */;
INSERT INTO `sys_oss_config` VALUES (1,'000000','minio','ruoyi','ruoyi123','ruoyi','','127.0.0.1:9000','','N','','1','0','',103,1,'2026-03-09 08:58:37',1,'2026-03-09 08:58:37',NULL),(2,'000000','qiniu','XXXXXXXXXXXXXXX','XXXXXXXXXXXXXXX','ruoyi','','s3-cn-north-1.qiniucs.com','','N','','1','1','',103,1,'2026-03-09 08:58:37',1,'2026-03-09 08:58:37',NULL),(3,'000000','aliyun','XXXXXXXXXXXXXXX','XXXXXXXXXXXXXXX','ruoyi','','oss-cn-beijing.aliyuncs.com','','N','','1','1','',103,1,'2026-03-09 08:58:37',1,'2026-03-09 08:58:37',NULL),(4,'000000','qcloud','XXXXXXXXXXXXXXX','XXXXXXXXXXXXXXX','ruoyi-1240000000','','cos.ap-beijing.myqcloud.com','','N','ap-beijing','1','1','',103,1,'2026-03-09 08:58:37',1,'2026-03-09 08:58:37',NULL),(5,'000000','image','ruoyi','ruoyi123','ruoyi','image','127.0.0.1:9000','','N','','1','1','',103,1,'2026-03-09 08:58:37',1,'2026-03-09 08:58:37',NULL);
/*!40000 ALTER TABLE `sys_oss_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_post`
--

DROP TABLE IF EXISTS `sys_post`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_post` (
  `post_id` bigint NOT NULL COMMENT '岗位ID',
  `tenant_id` varchar(20) DEFAULT '000000' COMMENT '租户编号',
  `dept_id` bigint NOT NULL COMMENT '部门id',
  `post_code` varchar(64) NOT NULL COMMENT '岗位编码',
  `post_category` varchar(100) DEFAULT NULL COMMENT '岗位类别编码',
  `post_name` varchar(50) NOT NULL COMMENT '岗位名称',
  `post_sort` int NOT NULL COMMENT '显示顺序',
  `status` char(1) NOT NULL COMMENT '状态（0正常 1停用）',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`post_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='岗位信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_post`
--

LOCK TABLES `sys_post` WRITE;
/*!40000 ALTER TABLE `sys_post` DISABLE KEYS */;
INSERT INTO `sys_post` VALUES (1,'000000',103,'ceo',NULL,'董事长',1,'0',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(2,'000000',100,'se',NULL,'项目经理',2,'0',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(3,'000000',100,'hr',NULL,'人力资源',3,'0',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(4,'000000',100,'user',NULL,'普通员工',4,'0',103,1,'2026-03-09 08:58:35',NULL,NULL,'');
/*!40000 ALTER TABLE `sys_post` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_role`
--

DROP TABLE IF EXISTS `sys_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_role` (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `tenant_id` varchar(20) DEFAULT '000000' COMMENT '租户编号',
  `role_name` varchar(30) NOT NULL COMMENT '角色名称',
  `role_key` varchar(100) NOT NULL COMMENT '角色权限字符串',
  `role_sort` int NOT NULL COMMENT '显示顺序',
  `data_scope` char(1) DEFAULT '1' COMMENT '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限 5：仅本人数据权限 6：部门及以下或本人数据权限）',
  `menu_check_strictly` tinyint(1) DEFAULT '1' COMMENT '菜单树选择项是否关联显示',
  `dept_check_strictly` tinyint(1) DEFAULT '1' COMMENT '部门树选择项是否关联显示',
  `status` char(1) NOT NULL COMMENT '角色状态（0正常 1停用）',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标志（0代表存在 1代表删除）',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='角色信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_role`
--

LOCK TABLES `sys_role` WRITE;
/*!40000 ALTER TABLE `sys_role` DISABLE KEYS */;
INSERT INTO `sys_role` VALUES (1,'000000','超级管理员','superadmin',1,'1',1,1,'0','0',103,1,'2026-03-09 08:58:35',NULL,NULL,'超级管理员'),(3,'000000','本部门及以下','test1',3,'4',1,1,'0','0',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(4,'000000','仅本人','test2',4,'5',1,1,'0','0',103,1,'2026-03-09 08:58:35',NULL,NULL,''),(2030837463400431618,'000000','管理员','manager',4,'1',0,1,'0','0',103,1,'2026-03-09 10:45:57',1,'2026-03-10 09:18:34',''),(2030846826877927426,'000000','普通用户','common',5,'1',1,1,'0','0',103,1,'2026-03-09 11:23:10',1,'2026-03-09 11:23:10','');
/*!40000 ALTER TABLE `sys_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_role_dept`
--

DROP TABLE IF EXISTS `sys_role_dept`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_role_dept` (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `dept_id` bigint NOT NULL COMMENT '部门ID',
  PRIMARY KEY (`role_id`,`dept_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='角色和部门关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_role_dept`
--

LOCK TABLES `sys_role_dept` WRITE;
/*!40000 ALTER TABLE `sys_role_dept` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_role_dept` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_role_menu`
--

DROP TABLE IF EXISTS `sys_role_menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_role_menu` (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `menu_id` bigint NOT NULL COMMENT '菜单ID',
  PRIMARY KEY (`role_id`,`menu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='角色和菜单关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_role_menu`
--

LOCK TABLES `sys_role_menu` WRITE;
/*!40000 ALTER TABLE `sys_role_menu` DISABLE KEYS */;
INSERT INTO `sys_role_menu` VALUES (3,1),(3,5),(3,100),(3,101),(3,102),(3,103),(3,104),(3,105),(3,106),(3,107),(3,108),(3,118),(3,123),(3,130),(3,131),(3,132),(3,133),(3,500),(3,501),(3,1001),(3,1002),(3,1003),(3,1004),(3,1005),(3,1006),(3,1007),(3,1008),(3,1009),(3,1010),(3,1011),(3,1012),(3,1013),(3,1014),(3,1015),(3,1016),(3,1017),(3,1018),(3,1019),(3,1020),(3,1021),(3,1022),(3,1023),(3,1024),(3,1025),(3,1026),(3,1027),(3,1028),(3,1029),(3,1030),(3,1031),(3,1032),(3,1033),(3,1034),(3,1035),(3,1036),(3,1037),(3,1038),(3,1039),(3,1040),(3,1041),(3,1042),(3,1043),(3,1044),(3,1045),(3,1050),(3,1061),(3,1062),(3,1063),(3,1064),(3,1065),(3,1500),(3,1501),(3,1502),(3,1503),(3,1504),(3,1505),(3,1506),(3,1507),(3,1508),(3,1509),(3,1510),(3,1511),(3,1600),(3,1601),(3,1602),(3,1603),(3,1620),(3,1621),(3,1622),(3,1623),(3,11616),(3,11618),(3,11619),(3,11622),(3,11623),(3,11629),(3,11632),(3,11633),(3,11638),(3,11639),(3,11640),(3,11641),(3,11642),(3,11643),(3,11701),(4,5),(4,1500),(4,1501),(4,1502),(4,1503),(4,1504),(4,1505),(4,1506),(4,1507),(4,1508),(4,1509),(4,1510),(4,1511),(2030837463400431618,1),(2030837463400431618,2),(2030837463400431618,100),(2030837463400431618,101),(2030837463400431618,109),(2030837463400431618,113),(2030837463400431618,130),(2030837463400431618,131),(2030837463400431618,133),(2030837463400431618,1001),(2030837463400431618,1002),(2030837463400431618,1003),(2030837463400431618,1004),(2030837463400431618,1005),(2030837463400431618,1006),(2030837463400431618,1007),(2030837463400431618,1008),(2030837463400431618,1009),(2030837463400431618,1010),(2030837463400431618,1011),(2030837463400431618,1012),(2030837463400431618,1013),(2030837463400431618,1014),(2030837463400431618,1015),(2030837463400431618,1016),(2030837463400431618,1040),(2030837463400431618,1041),(2030837463400431618,1042),(2030837463400431618,1046),(2030837463400431618,1047),(2030837463400431618,1048),(2030837463400431618,1600),(2030837463400431618,1601),(2030837463400431618,1602),(2030837463400431618,1603),(2030837463400431618,1620),(2030837463400431618,1621),(2030837463400431618,1622),(2030837463400431618,1623),(2030837463400431618,11900),(2030837463400431618,11901),(2030837463400431618,11902),(2030846826877927426,11900),(2030846826877927426,11901);
/*!40000 ALTER TABLE `sys_role_menu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_social`
--

DROP TABLE IF EXISTS `sys_social`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_social` (
  `id` bigint NOT NULL COMMENT '主键',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `tenant_id` varchar(20) DEFAULT '000000' COMMENT '租户id',
  `auth_id` varchar(255) NOT NULL COMMENT '平台+平台唯一id',
  `source` varchar(255) NOT NULL COMMENT '用户来源',
  `open_id` varchar(255) DEFAULT NULL COMMENT '平台编号唯一id',
  `user_name` varchar(30) NOT NULL COMMENT '登录账号',
  `nick_name` varchar(30) DEFAULT '' COMMENT '用户昵称',
  `email` varchar(255) DEFAULT '' COMMENT '用户邮箱',
  `avatar` varchar(500) DEFAULT '' COMMENT '头像地址',
  `access_token` varchar(2000) NOT NULL COMMENT '用户的授权令牌',
  `expire_in` int DEFAULT NULL COMMENT '用户的授权令牌的有效期，部分平台可能没有',
  `refresh_token` varchar(255) DEFAULT NULL COMMENT '刷新令牌，部分平台可能没有',
  `access_code` varchar(2000) DEFAULT NULL COMMENT '平台的授权信息，部分平台可能没有',
  `union_id` varchar(255) DEFAULT NULL COMMENT '用户的 unionid',
  `scope` varchar(255) DEFAULT NULL COMMENT '授予的权限，部分平台可能没有',
  `token_type` varchar(255) DEFAULT NULL COMMENT '个别平台的授权信息，部分平台可能没有',
  `id_token` varchar(2000) DEFAULT NULL COMMENT 'id token，部分平台可能没有',
  `mac_algorithm` varchar(255) DEFAULT NULL COMMENT '小米平台用户的附带属性，部分平台可能没有',
  `mac_key` varchar(255) DEFAULT NULL COMMENT '小米平台用户的附带属性，部分平台可能没有',
  `code` varchar(255) DEFAULT NULL COMMENT '用户的授权code，部分平台可能没有',
  `oauth_token` varchar(255) DEFAULT NULL COMMENT 'Twitter平台用户的附带属性，部分平台可能没有',
  `oauth_token_secret` varchar(255) DEFAULT NULL COMMENT 'Twitter平台用户的附带属性，部分平台可能没有',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标志（0代表存在 1代表删除）',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='社会化关系表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_social`
--

LOCK TABLES `sys_social` WRITE;
/*!40000 ALTER TABLE `sys_social` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_social` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_tenant`
--

DROP TABLE IF EXISTS `sys_tenant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_tenant` (
  `id` bigint NOT NULL COMMENT 'id',
  `tenant_id` varchar(20) NOT NULL COMMENT '租户编号',
  `contact_user_name` varchar(20) DEFAULT NULL COMMENT '联系人',
  `contact_phone` varchar(20) DEFAULT NULL COMMENT '联系电话',
  `company_name` varchar(30) DEFAULT NULL COMMENT '企业名称',
  `license_number` varchar(30) DEFAULT NULL COMMENT '统一社会信用代码',
  `address` varchar(200) DEFAULT NULL COMMENT '地址',
  `intro` varchar(200) DEFAULT NULL COMMENT '企业简介',
  `domain` varchar(200) DEFAULT NULL COMMENT '域名',
  `remark` varchar(200) DEFAULT NULL COMMENT '备注',
  `package_id` bigint DEFAULT NULL COMMENT '租户套餐编号',
  `expire_time` datetime DEFAULT NULL COMMENT '过期时间',
  `account_count` int DEFAULT '-1' COMMENT '用户数量（-1不限制）',
  `status` char(1) DEFAULT '0' COMMENT '租户状态（0正常 1停用）',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标志（0代表存在 1代表删除）',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='租户表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_tenant`
--

LOCK TABLES `sys_tenant` WRITE;
/*!40000 ALTER TABLE `sys_tenant` DISABLE KEYS */;
INSERT INTO `sys_tenant` VALUES (1,'000000','管理组','15888888888','XXX有限公司',NULL,NULL,'多租户通用后台管理管理系统',NULL,NULL,NULL,NULL,-1,'0','0',103,1,'2026-03-09 08:58:34',NULL,NULL);
/*!40000 ALTER TABLE `sys_tenant` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_tenant_package`
--

DROP TABLE IF EXISTS `sys_tenant_package`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_tenant_package` (
  `package_id` bigint NOT NULL COMMENT '租户套餐id',
  `package_name` varchar(20) DEFAULT NULL COMMENT '套餐名称',
  `menu_ids` varchar(3000) DEFAULT NULL COMMENT '关联菜单id',
  `remark` varchar(200) DEFAULT NULL COMMENT '备注',
  `menu_check_strictly` tinyint(1) DEFAULT '1' COMMENT '菜单树选择项是否关联显示',
  `status` char(1) DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标志（0代表存在 1代表删除）',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`package_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='租户套餐表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_tenant_package`
--

LOCK TABLES `sys_tenant_package` WRITE;
/*!40000 ALTER TABLE `sys_tenant_package` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_tenant_package` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user`
--

DROP TABLE IF EXISTS `sys_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user` (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `tenant_id` varchar(20) DEFAULT '000000' COMMENT '租户编号',
  `dept_id` bigint DEFAULT NULL COMMENT '部门ID',
  `user_name` varchar(30) NOT NULL COMMENT '用户账号',
  `nick_name` varchar(30) NOT NULL COMMENT '用户昵称',
  `user_type` varchar(10) DEFAULT 'sys_user' COMMENT '用户类型（sys_user系统用户）',
  `email` varchar(50) DEFAULT '' COMMENT '用户邮箱',
  `phonenumber` varchar(11) DEFAULT '' COMMENT '手机号码',
  `sex` char(1) DEFAULT '0' COMMENT '用户性别（0男 1女 2未知）',
  `avatar` bigint DEFAULT NULL COMMENT '头像地址',
  `password` varchar(100) DEFAULT '' COMMENT '密码',
  `status` char(1) DEFAULT '0' COMMENT '账号状态（0正常 1停用）',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标志（0代表存在 1代表删除）',
  `login_ip` varchar(128) DEFAULT '' COMMENT '最后登录IP',
  `login_date` datetime DEFAULT NULL COMMENT '最后登录时间',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user`
--

LOCK TABLES `sys_user` WRITE;
/*!40000 ALTER TABLE `sys_user` DISABLE KEYS */;
INSERT INTO `sys_user` VALUES (1,'000000',103,'admin','MIss Chen','sys_user','crazyLionLi@163.com','15888888888','1',2030846512238018562,'0192023a7bbd73250516f069df18b500','0','0','127.0.0.1','2026-03-10 09:18:10',103,1,'2026-03-09 08:58:35',-1,'2026-03-10 09:18:10','管理员'),(3,'000000',108,'test','本部门及以下 密码666666','sys_user','','','0',NULL,'$2a$10$b8yUzN0C71sbz.PhNOCgJe.Tu1yWC3RNrTyjSQ8p1W0.aaUXUJ.Ne','0','0','127.0.0.1','2026-03-09 08:58:35',103,1,'2026-03-09 08:58:35',3,'2026-03-09 08:58:35',NULL),(4,'000000',102,'test1','仅本人 密码666666','sys_user','','','0',NULL,'$2a$10$b8yUzN0C71sbz.PhNOCgJe.Tu1yWC3RNrTyjSQ8p1W0.aaUXUJ.Ne','0','0','127.0.0.1','2026-03-09 08:58:35',103,1,'2026-03-09 08:58:35',4,'2026-03-09 08:58:35',NULL),(2030836971509235714,'000000',NULL,'zhangsan','张三','sys_user','','','0',NULL,'e10adc3949ba59abbe56e057f20f883e','0','0','127.0.0.1','2026-03-10 09:28:28',103,1,'2026-03-09 10:44:00',-1,'2026-03-10 09:28:28',''),(2030847115479597058,'000000',NULL,'lisi','李四','sys_user','','','0',NULL,'e10adc3949ba59abbe56e057f20f883e','0','0','',NULL,103,1,'2026-03-09 11:24:18',1,'2026-03-09 11:24:18',''),(2030847182076755970,'000000',NULL,'wangwu','王五','sys_user','','','0',NULL,'e10adc3949ba59abbe56e057f20f883e','0','0','127.0.0.1','2026-03-10 09:27:10',103,1,'2026-03-09 11:24:34',-1,'2026-03-10 09:27:10',''),(2030847254894067714,'000000',NULL,'zhaoliu','赵六','sys_user','','','0',NULL,'e10adc3949ba59abbe56e057f20f883e','0','0','',NULL,103,1,'2026-03-09 11:24:52',1,'2026-03-09 11:24:52','');
/*!40000 ALTER TABLE `sys_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user_post`
--

DROP TABLE IF EXISTS `sys_user_post`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user_post` (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `post_id` bigint NOT NULL COMMENT '岗位ID',
  PRIMARY KEY (`user_id`,`post_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户与岗位关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user_post`
--

LOCK TABLES `sys_user_post` WRITE;
/*!40000 ALTER TABLE `sys_user_post` DISABLE KEYS */;
INSERT INTO `sys_user_post` VALUES (1,1);
/*!40000 ALTER TABLE `sys_user_post` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user_role`
--

DROP TABLE IF EXISTS `sys_user_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user_role` (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`user_id`,`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户和角色关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user_role`
--

LOCK TABLES `sys_user_role` WRITE;
/*!40000 ALTER TABLE `sys_user_role` DISABLE KEYS */;
INSERT INTO `sys_user_role` VALUES (1,1),(3,3),(4,4),(2030836971509235714,2030837463400431618),(2030847115479597058,2030846826877927426),(2030847182076755970,2030846826877927426),(2030847254894067714,2030846826877927426);
/*!40000 ALTER TABLE `sys_user_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `test_demo`
--

DROP TABLE IF EXISTS `test_demo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `test_demo` (
  `id` bigint NOT NULL COMMENT '主键',
  `tenant_id` varchar(20) DEFAULT '000000' COMMENT '租户编号',
  `dept_id` bigint DEFAULT NULL COMMENT '部门id',
  `user_id` bigint DEFAULT NULL COMMENT '用户id',
  `order_num` int DEFAULT '0' COMMENT '排序号',
  `test_key` varchar(255) DEFAULT NULL COMMENT 'key键',
  `value` varchar(255) DEFAULT NULL COMMENT '值',
  `version` int DEFAULT '0' COMMENT '版本',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `create_by` bigint DEFAULT NULL COMMENT '创建人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新人',
  `del_flag` int DEFAULT '0' COMMENT '删除标志',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='测试单表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `test_demo`
--

LOCK TABLES `test_demo` WRITE;
/*!40000 ALTER TABLE `test_demo` DISABLE KEYS */;
INSERT INTO `test_demo` VALUES (1,'000000',102,4,1,'测试数据权限','测试',0,103,'2026-03-09 08:58:37',1,NULL,NULL,0),(2,'000000',102,3,2,'子节点1','111',0,103,'2026-03-09 08:58:37',1,NULL,NULL,0),(3,'000000',102,3,3,'子节点2','222',0,103,'2026-03-09 08:58:37',1,NULL,NULL,0),(4,'000000',108,4,4,'测试数据','demo',0,103,'2026-03-09 08:58:37',1,NULL,NULL,0),(5,'000000',108,3,13,'子节点11','1111',0,103,'2026-03-09 08:58:37',1,NULL,NULL,0),(6,'000000',108,3,12,'子节点22','2222',0,103,'2026-03-09 08:58:38',1,NULL,NULL,0),(7,'000000',108,3,11,'子节点33','3333',0,103,'2026-03-09 08:58:38',1,NULL,NULL,0),(8,'000000',108,3,10,'子节点44','4444',0,103,'2026-03-09 08:58:38',1,NULL,NULL,0),(9,'000000',108,3,9,'子节点55','5555',0,103,'2026-03-09 08:58:38',1,NULL,NULL,0),(10,'000000',108,3,8,'子节点66','6666',0,103,'2026-03-09 08:58:38',1,NULL,NULL,0),(11,'000000',108,3,7,'子节点77','7777',0,103,'2026-03-09 08:58:38',1,NULL,NULL,0),(12,'000000',108,3,6,'子节点88','8888',0,103,'2026-03-09 08:58:38',1,NULL,NULL,0),(13,'000000',108,3,5,'子节点99','9999',0,103,'2026-03-09 08:58:38',1,NULL,NULL,0);
/*!40000 ALTER TABLE `test_demo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `test_leave`
--

DROP TABLE IF EXISTS `test_leave`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `test_leave` (
  `id` bigint NOT NULL COMMENT 'id',
  `tenant_id` varchar(20) DEFAULT '000000' COMMENT '租户编号',
  `apply_code` varchar(50) NOT NULL COMMENT '申请编号',
  `leave_type` varchar(255) NOT NULL COMMENT '请假类型',
  `start_date` datetime NOT NULL COMMENT '开始时间',
  `end_date` datetime NOT NULL COMMENT '结束时间',
  `leave_days` int NOT NULL COMMENT '请假天数',
  `remark` varchar(255) DEFAULT NULL COMMENT '请假原因',
  `status` varchar(255) DEFAULT NULL COMMENT '状态',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_by` bigint DEFAULT NULL COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='请假申请表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `test_leave`
--

LOCK TABLES `test_leave` WRITE;
/*!40000 ALTER TABLE `test_leave` DISABLE KEYS */;
/*!40000 ALTER TABLE `test_leave` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `test_tree`
--

DROP TABLE IF EXISTS `test_tree`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `test_tree` (
  `id` bigint NOT NULL COMMENT '主键',
  `tenant_id` varchar(20) DEFAULT '000000' COMMENT '租户编号',
  `parent_id` bigint DEFAULT '0' COMMENT '父id',
  `dept_id` bigint DEFAULT NULL COMMENT '部门id',
  `user_id` bigint DEFAULT NULL COMMENT '用户id',
  `tree_name` varchar(255) DEFAULT NULL COMMENT '值',
  `version` int DEFAULT '0' COMMENT '版本',
  `create_dept` bigint DEFAULT NULL COMMENT '创建部门',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `create_by` bigint DEFAULT NULL COMMENT '创建人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `update_by` bigint DEFAULT NULL COMMENT '更新人',
  `del_flag` int DEFAULT '0' COMMENT '删除标志',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='测试树表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `test_tree`
--

LOCK TABLES `test_tree` WRITE;
/*!40000 ALTER TABLE `test_tree` DISABLE KEYS */;
INSERT INTO `test_tree` VALUES (1,'000000',0,102,4,'测试数据权限',0,103,'2026-03-09 08:58:38',1,NULL,NULL,0),(2,'000000',1,102,3,'子节点1',0,103,'2026-03-09 08:58:38',1,NULL,NULL,0),(3,'000000',2,102,3,'子节点2',0,103,'2026-03-09 08:58:38',1,NULL,NULL,0),(4,'000000',0,108,4,'测试树1',0,103,'2026-03-09 08:58:38',1,NULL,NULL,0),(5,'000000',4,108,3,'子节点11',0,103,'2026-03-09 08:58:38',1,NULL,NULL,0),(6,'000000',4,108,3,'子节点22',0,103,'2026-03-09 08:58:38',1,NULL,NULL,0),(7,'000000',4,108,3,'子节点33',0,103,'2026-03-09 08:58:38',1,NULL,NULL,0),(8,'000000',5,108,3,'子节点44',0,103,'2026-03-09 08:58:38',1,NULL,NULL,0),(9,'000000',6,108,3,'子节点55',0,103,'2026-03-09 08:58:38',1,NULL,NULL,0),(10,'000000',7,108,3,'子节点66',0,103,'2026-03-09 08:58:38',1,NULL,NULL,0),(11,'000000',7,108,3,'子节点77',0,103,'2026-03-09 08:58:38',1,NULL,NULL,0),(12,'000000',10,108,3,'子节点88',0,103,'2026-03-09 08:58:38',1,NULL,NULL,0),(13,'000000',10,108,3,'子节点99',0,103,'2026-03-09 08:58:38',1,NULL,NULL,0);
/*!40000 ALTER TABLE `test_tree` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'db_secure'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-03-10  9:41:21
