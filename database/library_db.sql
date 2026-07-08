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

/*!40000 ALTER TABLE `t_ai_log` DISABLE KEYS */;
INSERT INTO `t_ai_log` VALUES (1,1,'user','有什么好看的科幻小说推荐？','2026-07-07 22:06:27'),(2,1,'assistant','推荐经典科幻小说《三体》（刘慈欣），宏大宇宙观与深刻人性探讨，适合入门。借阅期30天，请按时归还。','2026-07-07 22:06:28'),(3,1,'user','我想看文学小说，你能推荐一下吗','2026-07-07 22:10:18'),(4,1,'assistant','根据您的借阅历史，您对编程类书籍感兴趣，但这次想看文学小说。推荐经典作品《百年孤独》（加西亚·马尔克斯），魔幻现实主义风格，适合喜欢深度阅读的读者。本馆借期30天，请按时归还。','2026-07-07 22:10:20'),(5,1,'user','我要图书馆有的小说','2026-07-07 22:10:46'),(6,1,'assistant','好的，我们图书馆有丰富的经典小说馆藏。根据您的借阅历史，您似乎对技术类书籍感兴趣，但如果您想尝试文学经典，推荐您借阅《百年孤独》（加西亚·马尔克斯），它是一部魔幻现实主义杰作，适合深度阅读。借期30天，请按时归还以维护信用分。','2026-07-07 22:10:48'),(7,1,'user','推荐一本编程方面的书给我','2026-07-07 22:20:00'),(8,1,'assistant','根据您的借阅历史，您曾借阅过《Java编程思想》。推荐您借阅《MySQL必知必会》（作者：Ben Forta），库存3本，适合编程学习。','2026-07-07 22:20:01'),(9,1,'user','帮我推荐一本书','2026-07-07 23:18:15'),(10,1,'assistant','根据您的借阅历史，您曾借过《Java编程思想》，推荐您阅读《Spring Boot实战》（作者：Craig Walls），馆藏4本，可借期30天。','2026-07-07 23:18:16'),(11,1,'user','我想看平凡的世界这本书，你这里有吗','2026-07-07 23:18:35'),(12,1,'assistant','有的。路遥的《平凡的世界》目前库存20本，可以借阅。借期30天，请按时归还，逾期会扣除信用分。','2026-07-07 23:18:36');
/*!40000 ALTER TABLE `t_ai_log` ENABLE KEYS */;

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
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_book`
--

/*!40000 ALTER TABLE `t_book` DISABLE KEYS */;
INSERT INTO `t_book` VALUES (1,'Java编程思想','Bruce Eckel','978-7-111-21382-6','机械工业出版社',108.00,89,'2026-07-07 21:35:46','2026-07-08 19:55:40',1,1,'','https://img2.doubanio.com/view/subject/l/public/s27891001.jpg'),(2,'MySQL必知必会','Ben Forta','978-7-115-19112-0','人民邮电出版社',39.00,2,'2026-07-07 21:35:46','2026-07-08 19:01:18',5,1,'','/book_covers/cover_1783508473071_5454.jpeg'),(3,'三体','刘慈欣','978-7-5366-9293-0','重庆出版社',93.00,9,'2026-07-07 21:35:46','2026-07-08 18:58:54',2,1,'《三体》是刘慈欣的科幻巨作，讲述天体物理学家叶文洁在文革期间向宇宙发送信号，引来三体文明入侵。','https://img2.doubanio.com/view/subject/l/public/s27683781.jpg'),(4,'活着','余华','978-7-5302-2153-2','北京十月文艺出版社',45.00,8,'2026-07-07 21:35:46','2026-07-07 21:35:46',2,1,NULL,NULL),(5,'人类简史','尤瓦尔·赫拉利','978-7-5086-4735-7','中信出版社',68.00,6,'2026-07-07 21:35:46','2026-07-08 19:55:40',3,1,NULL,'https://img2.doubanio.com/view/subject/l/public/s27264181.jpg'),(6,'Spring Boot实战','Craig Walls','978-7-115-43314-5','人民邮电出版社',79.00,4,'2026-07-07 21:35:46','2026-07-07 21:35:46',4,1,NULL,NULL),(7,'《平凡的世界》','路遥','暂无','暂无',28.00,20,'2026-07-07 22:09:02','2026-07-07 22:09:02',2,1,'《平凡的世界》以孙少安、孙少平两兄弟的奋斗历程为主线，描绘了上世纪七八十年代陕北农村的变迁。他们面对贫困与挫折，不屈不挠地追求理想与尊严，展现了普通人在大时代历史进程中所走过的艰难而曲折的道路。',NULL),(8,'活着','余华','9787506365437','作家出版社',18.00,10,'2026-07-07 23:21:15','2026-07-07 23:21:15',2,1,'《活着》讲述农民福贵在动荡年代历经家道中落、亲人相继离世，最终与老牛相依为命。小说以平实笔触展现生命韧性与苦难本质，揭示活着的意义在于承受与坚守。',NULL),(9,'深入理解计算机系统','Randal E. Bryant','978-7-111-54493-7','机械工业出版社',139.00,4,'2026-07-08 19:55:40','2026-07-08 19:55:40',7,1,'从程序员视角全面剖析计算机系统核心概念，涵盖处理器架构、存储器层次、链接、异常控制流等关键主题，被誉为计算机科学领域的经典之作。','https://img2.doubanio.com/view/subject/l/public/s29113991.jpg'),(10,'算法导论','Thomas H. Cormen','978-7-111-40701-0','机械工业出版社',128.00,3,'2026-07-08 19:55:40','2026-07-08 19:55:40',1,1,'全面介绍算法设计与分析的权威教材，涵盖排序、图算法、动态规划、贪心算法等核心内容，兼顾理论与实践。','https://img1.doubanio.com/view/subject/l/public/s28499661.jpg'),(11,'Python深度学习','弗朗索瓦·肖莱','978-7-115-48876-7','人民邮电出版社',119.00,5,'2026-07-08 19:55:40','2026-07-08 19:55:40',6,1,'Keras之父执笔，系统讲解深度学习原理与TensorFlow/Keras实践，涵盖计算机视觉、NLP、生成模型等前沿领域。',NULL),(12,'计算机网络：自顶向下方法','James F. Kurose','978-7-111-59971-5','机械工业出版社',89.00,4,'2026-07-08 19:55:40','2026-07-08 19:55:40',8,1,'以自顶向下的独特视角讲授计算机网络原理，从应用层逐层深入，搭配丰富的实例和练习题。',NULL),(13,'百年孤独','加西亚·马尔克斯','978-7-5442-5399-4','南海出版公司',69.00,7,'2026-07-08 19:55:40','2026-07-08 19:55:40',9,1,'魔幻现实主义代表作，讲述布恩迪亚家族七代人的传奇故事，折射拉丁美洲百年历史变迁。','https://img9.doubanio.com/view/subject/l/public/s29854920.jpg'),(14,'红楼梦','曹雪芹','978-7-02-000220-7','人民文学出版社',59.90,6,'2026-07-08 19:55:40','2026-07-08 19:55:40',10,1,'中国古典文学巅峰之作，以贾宝玉、林黛玉爱情悲剧为主线，展现封建贵族家庭的兴衰命运。','https://img1.doubanio.com/view/subject/l/public/s1070959.jpg'),(15,'思考，快与慢','丹尼尔·卡尼曼','978-7-5086-3355-8','中信出版社',79.00,5,'2026-07-08 19:55:40','2026-07-08 19:55:40',11,1,'诺贝尔经济学奖得主卡尼曼揭示人类直觉与理性两种思维模式，探讨决策中的认知偏见。','https://img1.doubanio.com/view/subject/l/public/s27237891.jpg'),(16,'国富论','亚当·斯密','978-7-100-13301-6','商务印书馆',98.00,3,'2026-07-08 19:55:40','2026-07-08 19:55:40',12,1,'经济学奠基之作，系统阐述劳动分工、市场机制、自由贸易等核心思想，影响深远。',NULL),(17,'设计模式','Erich Gamma','978-7-111-07575-2','机械工业出版社',65.00,4,'2026-07-08 19:55:40','2026-07-08 19:55:40',4,1,'面向对象软件设计的经典参考书，整理23种常用设计模式，是软件工程师必备读物。',NULL),(18,'Linux内核设计与实现','Robert Love','978-7-111-33829-9','机械工业出版社',79.00,3,'2026-07-08 19:55:40','2026-07-08 19:55:40',7,1,'深入讲解Linux内核核心子系统，包括进程调度、内存管理、文件系统、网络协议栈等。',NULL),(19,'围城','钱钟书','978-7-02-002475-9','人民文学出版社',36.00,8,'2026-07-08 19:55:40','2026-07-08 19:55:40',9,1,'被誉为新儒林外史，以幽默犀利的笔触刻画知识分子群像，道尽人情冷暖与人生无奈。','https://img2.doubanio.com/view/subject/l/public/s1106933.jpg'),(20,'小王子','安托万·德·圣-埃克苏佩里','978-7-02-013284-3','人民文学出版社',32.00,10,'2026-07-08 19:55:40','2026-07-08 19:55:40',9,1,'全球发行量仅次于圣经的经典童话，以纯真视角揭示爱与责任的真谛，适合所有年龄读者。','https://img2.doubanio.com/view/subject/l/public/s1001902.jpg'),(21,'黑客与画家','Paul Graham','978-7-115-24949-4','人民邮电出版社',55.00,5,'2026-07-08 19:55:40','2026-07-08 19:55:40',1,1,'硅谷创业教父Paul Graham文集，探讨黑客精神、编程哲学、创业思维与创新文化。',NULL),(22,'明朝那些事儿','当年明月','978-7-213-04633-8','浙江人民出版社',358.00,3,'2026-07-08 19:55:40','2026-07-08 19:55:40',5,1,'以轻松幽默的笔法重述明朝三百年历史，让历史人物鲜活立体，引发全民读史热潮。',NULL),(23,'分布式系统概念与设计','George Coulouris','978-7-111-53744-1','机械工业出版社',109.00,2,'2026-07-08 19:55:40','2026-07-08 19:55:40',1,1,'全面覆盖分布式系统核心主题：通信、命名、同步、一致性、复制、容错与安全。',NULL),(24,'时间简史','史蒂芬·霍金','978-7-5357-4070-5','湖南科学技术出版社',45.00,6,'2026-07-08 19:55:40','2026-07-08 19:55:40',5,1,'霍金以通俗语言讲述宇宙的起源、黑洞、时间旅行等深奥概念，畅销全球的科普经典。',NULL),(25,'平凡的世界','路遥','978-7-5302-0955-2','北京十月文艺出版社',108.00,5,'2026-07-08 19:55:40','2026-07-08 19:55:40',9,1,'全景式展现中国当代城乡社会生活，以孙少安、孙少平兄弟奋斗历程激励无数读者。','https://img9.doubanio.com/view/subject/l/public/s1103154.jpg');
/*!40000 ALTER TABLE `t_book` ENABLE KEYS */;

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
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_borrow_record`
--

/*!40000 ALTER TABLE `t_borrow_record` DISABLE KEYS */;
INSERT INTO `t_borrow_record` VALUES (1,1,1,'2026-07-07 21:38:11','2026-08-06 21:38:11',NULL,0,0,NULL,'2026-07-07 21:38:11','2026-07-07 21:38:11'),(2,1,2,'2026-07-08 15:27:39','2026-08-07 15:27:39',NULL,0,0,NULL,'2026-07-08 15:27:38','2026-07-08 15:27:38'),(3,1,3,'2026-07-08 18:58:55','2026-08-07 18:58:55','2026-07-08 19:47:36',1,0,'正常归还','2026-07-08 18:58:54','2026-07-08 19:47:35'),(4,1,1,'2026-06-25 10:30:00','2026-07-25 10:30:00',NULL,0,0,NULL,'2026-07-08 19:55:40','2026-07-08 19:55:40'),(5,1,11,'2026-06-15 09:00:00','2026-07-15 09:00:00','2026-07-01 14:20:00',1,0,NULL,'2026-07-08 19:55:40','2026-07-08 19:55:40'),(6,1,16,'2026-07-02 16:00:00','2026-08-01 16:00:00',NULL,0,0,NULL,'2026-07-08 19:55:40','2026-07-08 19:55:40'),(7,2,3,'2026-06-28 11:00:00','2026-07-28 11:00:00',NULL,0,1,'续借一次','2026-07-08 19:55:40','2026-07-08 19:55:40'),(8,2,8,'2026-06-20 15:30:00','2026-07-20 15:30:00','2026-07-12 10:00:00',1,0,NULL,'2026-07-08 19:55:40','2026-07-08 19:55:40'),(9,3,2,'2026-07-05 08:30:00','2026-08-04 08:30:00',NULL,0,0,NULL,'2026-07-08 19:55:40','2026-07-08 19:55:40'),(10,3,4,'2026-07-01 13:00:00','2026-07-31 13:00:00',NULL,0,0,NULL,'2026-07-08 19:55:40','2026-07-08 19:55:40'),(11,3,6,'2026-06-10 14:00:00','2026-07-10 14:00:00','2026-07-05 09:30:00',1,0,NULL,'2026-07-08 19:55:40','2026-07-08 19:55:40'),(12,4,5,'2026-07-03 10:00:00','2026-08-02 10:00:00',NULL,0,0,NULL,'2026-07-08 19:55:40','2026-07-08 19:55:40'),(13,4,7,'2026-06-18 16:00:00','2026-07-18 16:00:00','2026-07-10 14:00:00',1,0,NULL,'2026-07-08 19:55:40','2026-07-08 19:55:40'),(14,5,12,'2026-07-06 09:30:00','2026-08-05 09:30:00',NULL,0,0,NULL,'2026-07-08 19:55:40','2026-07-08 19:55:40'),(15,5,17,'2026-06-22 11:00:00','2026-07-22 11:00:00','2026-07-15 16:00:00',1,0,NULL,'2026-07-08 19:55:40','2026-07-08 19:55:40'),(16,6,9,'2026-07-04 14:00:00','2026-08-03 14:00:00',NULL,0,0,NULL,'2026-07-08 19:55:40','2026-07-08 19:55:40'),(17,6,10,'2026-06-08 10:30:00','2026-07-08 10:30:00','2026-07-08 09:00:00',1,1,'超期3天已处理','2026-07-08 19:55:40','2026-07-08 19:55:40'),(18,7,14,'2026-07-07 15:00:00','2026-08-06 15:00:00',NULL,0,0,NULL,'2026-07-08 19:55:40','2026-07-08 19:55:40'),(19,8,13,'2026-06-30 08:00:00','2026-07-30 08:00:00',NULL,0,0,NULL,'2026-07-08 19:55:40','2026-07-08 19:55:40'),(20,8,15,'2026-06-12 10:00:00','2026-07-12 10:00:00','2026-07-08 11:00:00',1,0,NULL,'2026-07-08 19:55:40','2026-07-08 19:55:40'),(21,9,2,'2026-07-01 16:30:00','2026-07-31 16:30:00',NULL,0,0,NULL,'2026-07-08 19:55:40','2026-07-08 19:55:40'),(22,9,17,'2026-06-25 14:00:00','2026-07-25 14:00:00','2026-07-05 10:00:00',1,0,NULL,'2026-07-08 19:55:40','2026-07-08 19:55:40'),(23,10,1,'2026-07-05 11:00:00','2026-08-04 11:00:00',NULL,0,0,NULL,'2026-07-08 19:55:40','2026-07-08 19:55:40'),(24,10,5,'2026-06-28 09:00:00','2026-07-28 09:00:00','2026-07-20 15:00:00',1,0,NULL,'2026-07-08 19:55:40','2026-07-08 19:55:40'),(25,11,8,'2026-07-06 10:00:00','2026-08-05 10:00:00',NULL,0,0,NULL,'2026-07-08 19:55:40','2026-07-08 19:55:40'),(26,12,11,'2026-07-03 13:30:00','2026-08-02 13:30:00',NULL,0,0,NULL,'2026-07-08 19:55:40','2026-07-08 19:55:40'),(27,12,16,'2026-06-15 09:30:00','2026-07-15 09:30:00','2026-07-10 11:00:00',1,0,NULL,'2026-07-08 19:55:40','2026-07-08 19:55:40');
/*!40000 ALTER TABLE `t_borrow_record` ENABLE KEYS */;

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
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_category`
--

/*!40000 ALTER TABLE `t_category` DISABLE KEYS */;
INSERT INTO `t_category` VALUES (1,'计算机科学',0,1,'2026-07-07 21:35:46','2026-07-07 21:35:46'),(2,'文学小说',0,2,'2026-07-07 21:35:46','2026-07-07 21:35:46'),(3,'历史哲学',0,3,'2026-07-07 21:35:46','2026-07-07 21:35:46'),(4,'编程语言',1,1,'2026-07-07 21:35:46','2026-07-07 21:35:46'),(5,'数据库',1,2,'2026-07-07 21:35:46','2026-07-07 21:35:46'),(6,'人工智能',1,3,'2026-07-08 19:55:40','2026-07-08 19:55:40'),(7,'网络技术',1,4,'2026-07-08 19:55:40','2026-07-08 19:55:40'),(8,'操作系统',1,5,'2026-07-08 19:55:40','2026-07-08 19:55:40'),(9,'外国文学',2,3,'2026-07-08 19:55:40','2026-07-08 19:55:40'),(10,'中国古典',2,4,'2026-07-08 19:55:40','2026-07-08 19:55:40'),(11,'心理学',3,4,'2026-07-08 19:55:40','2026-07-08 19:55:40'),(12,'经济学',3,5,'2026-07-08 19:55:40','2026-07-08 19:55:40');
/*!40000 ALTER TABLE `t_category` ENABLE KEYS */;

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
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_user`
--

/*!40000 ALTER TABLE `t_user` DISABLE KEYS */;
INSERT INTO `t_user` VALUES (1,'reader','reader123','张三','zhangsan@qq.com','13800138000',5,1,'2026-07-07 21:35:46','2026-07-08 19:41:20','男',NULL,NULL,NULL,NULL,NULL),(2,'reader2','reader123','李四','lisi@qq.com','13900139000',5,1,'2026-07-07 21:35:46','2026-07-08 19:55:40','女',3,NULL,NULL,NULL,NULL),(3,'wangwu','reader123','王五','wangwu@qq.com','13700137000',5,1,'2026-07-08 19:55:40','2026-07-08 19:55:40','男',NULL,NULL,NULL,NULL,NULL),(4,'zhaoliu','reader123','赵六','zhaoliu@163.com','13600136000',5,1,'2026-07-08 19:55:40','2026-07-08 19:55:40','男',NULL,NULL,NULL,NULL,NULL),(5,'sunqi','reader123','孙七','sunqi@gmail.com','13500135000',5,1,'2026-07-08 19:55:40','2026-07-08 19:55:40','女',NULL,NULL,NULL,NULL,NULL),(6,'zhouba','reader123','周八','zhouba@qq.com','13400134000',5,1,'2026-07-08 19:55:40','2026-07-08 19:55:40','女',NULL,NULL,NULL,NULL,NULL),(7,'wujiu','reader123','吴九','wujiu@163.com','13300133000',3,1,'2026-07-08 19:55:40','2026-07-08 19:55:40','男',NULL,NULL,NULL,NULL,NULL),(8,'zhengshi','reader123','郑十','zhengshi@qq.com','13200132000',5,1,'2026-07-08 19:55:40','2026-07-08 19:55:40','女',NULL,NULL,NULL,NULL,NULL),(9,'chenyi','reader123','陈一','chenyi@gmail.com','13100131000',5,1,'2026-07-08 19:55:40','2026-07-08 19:55:40','男',NULL,NULL,NULL,NULL,NULL),(10,'liner','reader123','林二','liner@163.com','13000130000',4,1,'2026-07-08 19:55:40','2026-07-08 19:55:40','女',NULL,NULL,NULL,NULL,NULL),(11,'huangsan','reader123','黄三','huangsan@qq.com','13910139010',5,1,'2026-07-08 19:55:40','2026-07-08 19:55:40','男',NULL,NULL,NULL,NULL,NULL),(12,'xusi','reader123','许四','xusi@gmail.com','13810138010',5,1,'2026-07-08 19:55:40','2026-07-08 19:55:40','女',NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `t_user` ENABLE KEYS */;

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

/*!40000 ALTER TABLE `uer` DISABLE KEYS */;
INSERT INTO `uer` VALUES (1,'admin','admin123','admin','2026-07-07 21:35:46');
/*!40000 ALTER TABLE `uer` ENABLE KEYS */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-07-09  1:00:22
