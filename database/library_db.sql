mysqldump: [Warning] Using a password on the command line interface can be insecure.
-- MySQL dump 10.13  Distrib 9.3.0, for macos15.2 (arm64)
--
-- Host: localhost    Database: library_db
-- ------------------------------------------------------
-- Server version	9.3.0

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
-- Table structure for table `t_ai_log`
--

DROP TABLE IF EXISTS `t_ai_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_ai_log` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `role` varchar(20) NOT NULL COMMENT 'user/assistant',
  `content` text NOT NULL COMMENT '消息内容',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='AI聊天记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_ai_log`
--

LOCK TABLES `t_ai_log` WRITE;
/*!40000 ALTER TABLE `t_ai_log` DISABLE KEYS */;
INSERT INTO `t_ai_log` VALUES (1,1,'user','有什么好看的科幻小说推荐？','2026-07-07 22:06:27'),(2,1,'assistant','推荐经典科幻小说《三体》（刘慈欣），宏大宇宙观与深刻人性探讨，适合入门。借阅期30天，请按时归还。','2026-07-07 22:06:28'),(3,1,'user','我想看文学小说，你能推荐一下吗','2026-07-07 22:10:18'),(4,1,'assistant','根据您的借阅历史，您对编程类书籍感兴趣，但这次想看文学小说。推荐经典作品《百年孤独》（加西亚·马尔克斯），魔幻现实主义风格，适合喜欢深度阅读的读者。本馆借期30天，请按时归还。','2026-07-07 22:10:20'),(5,1,'user','我要图书馆有的小说','2026-07-07 22:10:46'),(6,1,'assistant','好的，我们图书馆有丰富的经典小说馆藏。根据您的借阅历史，您似乎对技术类书籍感兴趣，但如果您想尝试文学经典，推荐您借阅《百年孤独》（加西亚·马尔克斯），它是一部魔幻现实主义杰作，适合深度阅读。借期30天，请按时归还以维护信用分。','2026-07-07 22:10:48'),(7,1,'user','推荐一本编程方面的书给我','2026-07-07 22:20:00'),(8,1,'assistant','根据您的借阅历史，您曾借阅过《Java编程思想》。推荐您借阅《MySQL必知必会》（作者：Ben Forta），库存3本，适合编程学习。','2026-07-07 22:20:01'),(9,1,'user','帮我推荐一本书','2026-07-07 23:18:15'),(10,1,'assistant','根据您的借阅历史，您曾借过《Java编程思想》，推荐您阅读《Spring Boot实战》（作者：Craig Walls），馆藏4本，可借期30天。','2026-07-07 23:18:16'),(11,1,'user','我想看平凡的世界这本书，你这里有吗','2026-07-07 23:18:35'),(12,1,'assistant','有的。路遥的《平凡的世界》目前库存20本，可以借阅。借期30天，请按时归还，逾期会扣除信用分。','2026-07-07 23:18:36');
/*!40000 ALTER TABLE `t_ai_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_book`
--

DROP TABLE IF EXISTS `t_book`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_book` (
  `id` int NOT NULL AUTO_INCREMENT,
  `book_name` varchar(100) NOT NULL,
  `author` varchar(50) DEFAULT NULL,
  `isbn` varchar(30) DEFAULT NULL,
  `publish_house` varchar(100) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `stock` int DEFAULT '0',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `category_id` bigint DEFAULT NULL,
  `status` int NOT NULL DEFAULT '1',
  `summary` text COMMENT 'AI生成的图书摘要',
  `cover_url` varchar(500) DEFAULT NULL COMMENT '图书封面图片URL',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_isbn` (`isbn`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_book`
--

LOCK TABLES `t_book` WRITE;
/*!40000 ALTER TABLE `t_book` DISABLE KEYS */;
INSERT INTO `t_book` VALUES (1,'Java编程思想','Bruce Eckel','978-7-111-21382-6','机械工业出版社',108.00,89,'2026-07-07 21:35:46','2026-07-07 21:38:11',1,1,NULL,NULL),(2,'MySQL必知必会','Ben Forta','978-7-115-19112-0','人民邮电出版社',39.00,2,'2026-07-07 21:35:46','2026-07-08 15:27:38',5,1,NULL,NULL),(3,'三体','刘慈欣','978-7-5366-9293-0','重庆出版社',93.00,10,'2026-07-07 21:35:46','2026-07-08 15:26:41',2,1,'《三体》是刘慈欣的科幻巨作，讲述天体物理学家叶文洁在文革期间向宇宙发送信号，引来三体文明入侵。','https://img2.doubanio.com/view/subject/l/public/s27683781.jpg'),(4,'活着','余华','978-7-5302-2153-2','北京十月文艺出版社',45.00,8,'2026-07-07 21:35:46','2026-07-07 21:35:46',2,1,NULL,NULL),(5,'人类简史','尤瓦尔·赫拉利','978-7-5086-4735-7','中信出版社',68.00,6,'2026-07-07 21:35:46','2026-07-07 21:35:46',3,1,NULL,NULL),(6,'Spring Boot实战','Craig Walls','978-7-115-43314-5','人民邮电出版社',79.00,4,'2026-07-07 21:35:46','2026-07-07 21:35:46',4,1,NULL,NULL),(7,'《平凡的世界》','路遥','暂无','暂无',28.00,20,'2026-07-07 22:09:02','2026-07-07 22:09:02',2,1,'《平凡的世界》以孙少安、孙少平两兄弟的奋斗历程为主线，描绘了上世纪七八十年代陕北农村的变迁。他们面对贫困与挫折，不屈不挠地追求理想与尊严，展现了普通人在大时代历史进程中所走过的艰难而曲折的道路。',NULL),(8,'活着','余华','9787506365437','作家出版社',18.00,10,'2026-07-07 23:21:15','2026-07-07 23:21:15',2,1,'《活着》讲述农民福贵在动荡年代历经家道中落、亲人相继离世，最终与老牛相依为命。小说以平实笔触展现生命韧性与苦难本质，揭示活着的意义在于承受与坚守。',NULL);
/*!40000 ALTER TABLE `t_book` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_borrow_record`
--

DROP TABLE IF EXISTS `t_borrow_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_borrow_record` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `book_id` bigint NOT NULL,
  `borrow_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `due_time` datetime NOT NULL,
  `return_time` datetime DEFAULT NULL,
  `status` int NOT NULL DEFAULT '0',
  `renew_count` int NOT NULL DEFAULT '0',
  `remark` varchar(255) DEFAULT NULL,
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_borrow_user` (`user_id`),
  CONSTRAINT `fk_borrow_user` FOREIGN KEY (`user_id`) REFERENCES `t_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_borrow_record`
--

LOCK TABLES `t_borrow_record` WRITE;
/*!40000 ALTER TABLE `t_borrow_record` DISABLE KEYS */;
INSERT INTO `t_borrow_record` VALUES (1,1,1,'2026-07-07 21:38:11','2026-08-06 21:38:11',NULL,0,0,NULL,'2026-07-07 21:38:11','2026-07-07 21:38:11'),(2,1,2,'2026-07-08 15:27:39','2026-08-07 15:27:39',NULL,0,0,NULL,'2026-07-08 15:27:38','2026-07-08 15:27:38');
/*!40000 ALTER TABLE `t_borrow_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_category`
--

DROP TABLE IF EXISTS `t_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_category` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `parent_id` bigint DEFAULT '0',
  `sort` int DEFAULT '0',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_category`
--

LOCK TABLES `t_category` WRITE;
/*!40000 ALTER TABLE `t_category` DISABLE KEYS */;
INSERT INTO `t_category` VALUES (1,'计算机科学',0,1,'2026-07-07 21:35:46','2026-07-07 21:35:46'),(2,'文学小说',0,2,'2026-07-07 21:35:46','2026-07-07 21:35:46'),(3,'历史哲学',0,3,'2026-07-07 21:35:46','2026-07-07 21:35:46'),(4,'编程语言',1,1,'2026-07-07 21:35:46','2026-07-07 21:35:46'),(5,'数据库',1,2,'2026-07-07 21:35:46','2026-07-07 21:35:46');
/*!40000 ALTER TABLE `t_category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_user`
--

DROP TABLE IF EXISTS `t_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `real_name` varchar(50) NOT NULL DEFAULT '',
  `email` varchar(100) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `max_books` int NOT NULL DEFAULT '5',
  `status` int NOT NULL DEFAULT '1',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `gender` varchar(2) DEFAULT NULL,
  `borrow_book_id1` int DEFAULT NULL,
  `borrow_book_id2` int DEFAULT NULL,
  `borrow_book_id3` int DEFAULT NULL,
  `borrow_book_id4` int DEFAULT NULL,
  `borrow_book_id5` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_user`
--

LOCK TABLES `t_user` WRITE;
/*!40000 ALTER TABLE `t_user` DISABLE KEYS */;
INSERT INTO `t_user` VALUES (1,'reader','reader123','张三','zhangsan@qq.com','13800138000',5,1,'2026-07-07 21:35:46','2026-07-07 21:39:37','男',NULL,NULL,NULL,NULL,NULL),(2,'reader2','reader123','李四','lisi@qq.com','13900139000',5,1,'2026-07-07 21:35:46','2026-07-07 21:35:46','女',NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `t_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `uer`
--

DROP TABLE IF EXISTS `uer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `uer` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(100) NOT NULL,
  `role` varchar(20) NOT NULL DEFAULT 'user',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_uer_username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `uer`
--

LOCK TABLES `uer` WRITE;
/*!40000 ALTER TABLE `uer` DISABLE KEYS */;
INSERT INTO `uer` VALUES (1,'admin','admin123','admin','2026-07-07 21:35:46');
/*!40000 ALTER TABLE `uer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'library_db'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-07-08 15:35:54
