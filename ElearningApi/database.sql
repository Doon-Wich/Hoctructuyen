-- MySQL dump 10.13  Distrib 8.0.41, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: elearning
-- ------------------------------------------------------
-- Server version	8.0.30

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
-- Table structure for table `activity_log`
--

DROP TABLE IF EXISTS `activity_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `activity_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `action` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `activity_log_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `activity_log`
--

LOCK TABLES `activity_log` WRITE;
/*!40000 ALTER TABLE `activity_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `activity_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `assignments`
--

DROP TABLE IF EXISTS `assignments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `assignments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `lesson_id` int NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `is_programming` tinyint(1) NOT NULL DEFAULT '0',
  `attachment` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `deadline` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `lesson_id` (`lesson_id`),
  CONSTRAINT `assignments_ibfk_1` FOREIGN KEY (`lesson_id`) REFERENCES `lesson` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `assignments`
--

LOCK TABLES `assignments` WRITE;
/*!40000 ALTER TABLE `assignments` DISABLE KEYS */;
INSERT INTO `assignments` VALUES (2,3,'Bài 2','Viết chương trình ngôn ngữ C in chính xác dòng sau ra màn hình: Hello World',1,'http://localhost:8000/storage/uploads/MjbkNgtw4Nb3qU0iQ1NwXMuDVjQ20ia3Ble6pDTK.docx','2025-11-20 00:00:00','2025-11-17 09:06:21','2025-12-22 09:50:02');
/*!40000 ALTER TABLE `assignments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categories` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES (1,'Web Development','Lập trình Web','2025-11-10 18:41:14','2026-01-09 20:46:46'),(2,'Front-end Development','Front-end','2026-01-09 20:47:14','2026-01-09 20:50:16'),(3,'Mobile Development','Phát triển ứng dụng mobile','2026-01-09 20:48:14','2026-01-09 20:48:14'),(4,'Back-end Development','Backend','2026-01-09 20:50:04','2026-01-09 20:50:04');
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comment`
--

DROP TABLE IF EXISTS `comment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comment` (
  `id` int NOT NULL AUTO_INCREMENT,
  `discussion_id` int NOT NULL,
  `user_id` int NOT NULL,
  `content` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `discussion_id` (`discussion_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `comment_ibfk_1` FOREIGN KEY (`discussion_id`) REFERENCES `discussion` (`id`),
  CONSTRAINT `comment_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comment`
--

LOCK TABLES `comment` WRITE;
/*!40000 ALTER TABLE `comment` DISABLE KEYS */;
/*!40000 ALTER TABLE `comment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `course`
--

DROP TABLE IF EXISTS `course`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `course` (
  `id` int NOT NULL AUTO_INCREMENT,
  `teacher_id` int NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `price` decimal(10,2) DEFAULT '0.00',
  `is_progress_limited` tinyint(1) DEFAULT '0',
  `category_id` int unsigned DEFAULT NULL,
  `slug` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `teacher_id` (`teacher_id`),
  KEY `course_category_id_foreign` (`category_id`),
  CONSTRAINT `course_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `course_ibfk_1` FOREIGN KEY (`teacher_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `course`
--

LOCK TABLES `course` WRITE;
/*!40000 ALTER TABLE `course` DISABLE KEYS */;
INSERT INTO `course` VALUES (1,1,'Kiến Thức Nhập Môn IT','Nhập môn',10000.00,0,1,'kien-thuc-nhap-mon-it','2025-11-10 18:48:07','2026-01-09 19:54:09'),(2,1,'Nhập môn','Khoá nhập môn',100000.00,1,1,'nhap-mon','2025-12-08 09:43:19','2025-12-16 17:55:51'),(3,1,'Lập trình C++ cơ bản, nâng cao','Lập trình C',100000.00,1,4,'lap-trinh-c-co-ban-nang-cao','2026-01-09 19:53:56','2026-01-09 20:52:05'),(4,1,'HTML CSS từ Zero đến Hero','HTML, CSS',100000.00,1,1,'html-css-tu-zero-den-hero','2026-01-09 19:54:40','2026-01-09 19:54:40'),(5,1,'Responsive Với Grid System','Trong khóa này chúng ta sẽ học về cách xây dựng giao diện web responsive với Grid System, tương tự Bootstrap 4.',1000000.00,1,1,'responsive-voi-grid-system','2026-01-09 19:55:12','2026-01-09 19:55:12'),(6,1,'Lập Trình JavaScript Cơ Bản','lập trình',1000000.00,1,1,'lap-trinh-javascript-co-ban','2026-01-09 20:02:45','2026-01-09 20:02:45'),(7,1,'Lập Trình JavaScript Nâng Cao','Lập trình',1000000.00,0,1,'lap-trinh-javascript-nang-cao','2026-01-09 20:03:18','2026-01-09 20:03:18'),(8,1,'Làm việc với Terminal & Ubuntu','Ubuntu',1000000.00,1,1,'lam-viec-voi-terminal-ubuntu','2026-01-09 20:03:53','2026-01-09 20:03:53');
/*!40000 ALTER TABLE `course` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `discussion`
--

DROP TABLE IF EXISTS `discussion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `discussion` (
  `id` int NOT NULL AUTO_INCREMENT,
  `course_id` int NOT NULL,
  `user_id` int NOT NULL,
  `content` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `course_id` (`course_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `discussion_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `course` (`id`),
  CONSTRAINT `discussion_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `discussion`
--

LOCK TABLES `discussion` WRITE;
/*!40000 ALTER TABLE `discussion` DISABLE KEYS */;
/*!40000 ALTER TABLE `discussion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `documents`
--

DROP TABLE IF EXISTS `documents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `documents` (
  `id` int NOT NULL AUTO_INCREMENT,
  `course_id` int NOT NULL,
  `module_id` int DEFAULT NULL,
  `lesson_id` int DEFAULT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `file_path` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `original_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `file_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('pending','processing','done','failed') COLLATE utf8mb4_unicode_ci DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `course_id` (`course_id`),
  KEY `module_id` (`module_id`),
  KEY `lesson_id` (`lesson_id`),
  CONSTRAINT `fk_documents_course` FOREIGN KEY (`course_id`) REFERENCES `course` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_documents_lesson` FOREIGN KEY (`lesson_id`) REFERENCES `lesson` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_documents_module` FOREIGN KEY (`module_id`) REFERENCES `module` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `documents`
--

LOCK TABLES `documents` WRITE;
/*!40000 ALTER TABLE `documents` DISABLE KEYS */;
INSERT INTO `documents` VALUES (23,1,1,1,'Abc','documents/QcwZZrNSqKlqEFhYc6TwoWOlqcailmX2Y7B28boJ.pdf','9203b5d9-3c34-4eb9-befc-f88cc81b76ec.pdf','application/pdf','done','2025-12-16 05:30:31','2025-12-16 05:30:37'),(24,1,1,1,'Abc','documents/jyJ7wJD8sGT7xGblvUTXlnr98UnBlIqieMduoetj.pdf','9203b5d9-3c34-4eb9-befc-f88cc81b76ec.pdf','application/pdf','done','2025-12-25 00:40:48','2025-12-25 00:40:59'),(25,1,1,1,'Abc','documents/o9WBoC9DWhnhRU2ujn56GzjGbNpsPnaaZ6GO2zBd.pdf','9203b5d9-3c34-4eb9-befc-f88cc81b76ec.pdf','application/pdf','done','2025-12-25 00:41:14','2025-12-25 00:41:17'),(26,1,1,2,'Tài liệu tham khảo','documents/lcycXqXVbdL6T6M7ebRTHN4WUlbwuD0YDsYHT67k.pdf','9203b5d9-3c34-4eb9-befc-f88cc81b76ec.pdf','application/pdf','pending','2025-12-25 00:48:24','2025-12-25 00:48:24'),(27,3,5,9,'Tài liệu','documents/jayPaeSayG2ZUobbvV5V2PMEh3a786lIgaoD1Etk.pdf','9203b5d9-3c34-4eb9-befc-f88cc81b76ec.pdf','application/pdf','done','2026-01-09 20:01:19','2026-01-09 20:01:35');
/*!40000 ALTER TABLE `documents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `enrolment`
--

DROP TABLE IF EXISTS `enrolment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `enrolment` (
  `course_id` int NOT NULL,
  `student_id` int NOT NULL,
  `enrolment_datetime` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `completed_datetime` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`course_id`,`student_id`),
  KEY `student_id` (`student_id`),
  CONSTRAINT `enrolment_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `course` (`id`),
  CONSTRAINT `enrolment_ibfk_2` FOREIGN KEY (`student_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `enrolment`
--

LOCK TABLES `enrolment` WRITE;
/*!40000 ALTER TABLE `enrolment` DISABLE KEYS */;
/*!40000 ALTER TABLE `enrolment` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `failed_jobs`
--

LOCK TABLES `failed_jobs` WRITE;
/*!40000 ALTER TABLE `failed_jobs` DISABLE KEYS */;
INSERT INTO `failed_jobs` VALUES (8,'543dd3c0-c62f-4a2a-b992-3e56ae15f5c1','database','default','{\"uuid\":\"543dd3c0-c62f-4a2a-b992-3e56ae15f5c1\",\"displayName\":\"App\\\\Events\\\\ChatMessageSent\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":null,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":null,\"retryUntil\":null,\"data\":{\"commandName\":\"Illuminate\\\\Broadcasting\\\\BroadcastEvent\",\"command\":\"O:38:\\\"Illuminate\\\\Broadcasting\\\\BroadcastEvent\\\":16:{s:5:\\\"event\\\";O:26:\\\"App\\\\Events\\\\ChatMessageSent\\\":1:{s:7:\\\"message\\\";a:3:{s:8:\\\"question\\\";s:5:\\\"Chào\\\";s:6:\\\"answer\\\";s:588:\\\"Xin chào!\\n\\nMô hình Client-Server sử dụng Socket ở chế độ có nối kết (TCP) có 4 giai đoạn: Server tạo socket, gán số hiệu cổng và lắng nghe yêu cầu nối kết; Client tạo socket, yêu cầu thiết lập một nối kết với Server; trao đổi thông tin giữa Client và Server; và kết thúc phiên làm việc.\\n\\nMô hình Client-Server sử dụng Socket ở chế độ không nối kết (UDP) có 3 giai đoạn: Server tạo socket – gán số hiệu cổng; Client tạo socket; và trao đổi thông tin giữa Client và Server.\\\";s:7:\\\"context\\\";s:7775:\\\"HDLT Socket mạng máy tính (Đại học Khoa học Tự nhiên, Đại học Quốc gia Thành phố Hồ Chí Minh) on Studeersnel Studocu is not sponsored or endorsed by any college or university HDLT Socket mạng máy tính (Đại học Khoa học Tự nhiên, Đại học Quốc gia Thành phố Hồ Chí Minh) on Studeersnel Studocu is not sponsored or endorsed by any college or university HƯỚNG DẪN LẬP TRÌNH SOCKET 1. Mô hình Client-Server sử dụng Socket ở chế độ có nối kết (TCP) Có thể phân thành 4 giai đoạn như sau: • Giai đoạn 1: Server tạo Socket, gán số hiệu cổng và lắng nghe yêu cầu nối kết. Server sẵn sàng phục vụ Client.socket(): Server yêu cầu tạo một socket để có thể sử dụng các dịch vụ của tầng vận chuyển. o bind(): Server yêu cầu gán số hiệu cổng (port) cho socket. o listen(): Server lắng nghe các yêu cầu nối kết từ các client trên cổng đã được gán. • Giai đoạn 2: Client tạo Socket, yêu cầu thiết lập một nối kết với Server. o socket(): Client yêu cầu tạo một socket để có thể sử dụng các dịch vụ của tầng vận chuyển, thông thường hệ thống tự động gán một số hiệu cổng còn rảnh cho socket của Client. o connect(): Client gởi yêu cầu nối kết đến server có địa chỉ IP và Port xác định. o accept(): Server chấp nhận nối kết của client, khi đó một kênh giao tiếp ảo được hình thành, Client và server có thể trao đổi thông tin với nhau thông qua kênh ảo này. • Giai đoạn 3: Trao đổi thông tin giữa Client và Server. o Sau khi chấp nhận yêu cầu nối kết, thông thường server thực hiện lệnh read() và nghẽn cho đến khi có thông điệp yêu cầu (Request Message) từ client gởi đến. o Server phân tích và thực thi yêu cầu. Kết quả sẽ được gởi về client bằng lệnh write(). o Sau khi gởi yêu cầu bằng lệnh write(), client chờ nhận thông điệp kết quả (ReplyMessage) từ server bằng lệnh read(). • Giai đoạn 4: Kết thúc phiên làm việc. o Các câu lệnh read(), write() có thể được thưc hiện nhiều lần (ký hiệu bằng hình ellipse). o Kênh ảo sẽ bị xóa khi Server hoặc Client đóng socket bằng lệnh close(). 2.\\n\\nHDLT Socket mạng máy tính (Đại học Khoa học Tự nhiên, Đại học Quốc gia Thành phố Hồ Chí Minh) Scan to open on Studeersnel Studocu is not sponsored or endorsed by any college or university HDLT Socket mạng máy tính (Đại học Khoa học Tự nhiên, Đại học Quốc gia Thành phố Hồ Chí Minh) Scan to open on Studeersnel Studocu is not sponsored or endorsed by any college or university Downloaded by Trí Nguy?n (tringuyen7735@gmail.com) lOMoARcPSD|32470842 HƯỚNG DẪN LẬP TRÌNH SOCKET 1. Mô hình Client-Server sử dụng Socket ở chế độ có nối kết (TCP) Có thể phân thành 4 giai đoạn như sau: Downloaded by Trí Nguy?n (tringuyen7735@gmail.com) lOMoARcPSD|32470842 • Giai đoạn 1: Server tạo Socket, gán số hiệu cổng và lắng nghe yêu cầu nối kết. Server sẵn sàng phục vụ Client.socket(): Server yêu cầu tạo một socket để có thể sử dụng các dịch vụ của tầng vận chuyển. o bind(): Server yêu cầu gán số hiệu cổng (port) cho socket. o listen(): Server lắng nghe các yêu cầu nối kết từ các client trên cổng đã được gán. • Giai đoạn 2: Client tạo Socket, yêu cầu thiết lập một nối kết với Server. o socket(): Client yêu cầu tạo một socket để có thể sử dụng các dịch vụ của tầng vận chuyển, thông thường hệ thống tự động gán một số hiệu cổng còn rảnh cho socket của Client. o connect(): Client gởi yêu cầu nối kết đến server có địa chỉ IP và Port xác định. o accept(): Server chấp nhận nối kết của client, khi đó một kênh giao tiếp ảo được hình thành, Client và server có thể trao đổi thông tin với nhau thông qua kênh ảo này. • Giai đoạn 3: Trao đổi thông tin giữa Client và Server. o Sau khi chấp nhận yêu cầu nối kết, thông thường server thực hiện lệnh read() và nghẽn cho đến khi có thông điệp yêu cầu (Request Message) từ client gởi đến. Downloaded by Trí Nguy?n (tringuyen7735@gmail.com) lOMoARcPSD|32470842 o Server phân tích và thực thi yêu cầu. Kết quả sẽ được gởi về client bằng lệnh write(). o Sau khi gởi yêu cầu bằng lệnh write(), client chờ nhận thông điệp kết quả (ReplyMessage) từ server bằng lệnh read(). • Giai đoạn 4: Kết thúc phiên làm việc. o Các câu lệnh read(), write() có thể được thưc\\n\\nMô hình Client-Server sử dụng Socket ở chế độ không nối kết (UDP) Có thể phân thành 3 giai đoạn như sau: • Giai đoạn 1: Server tạo Socket – gán số hiệu cổng. o socket(): Server yêu cầu tạo một socket để có thể sử dụng các dịch vụ của tầng vận chuyển. o bind(): Server yêu cầu gán số hiệu cổng cho socket. • Giai đoạn 2: Client tạo Socket. o socket(): Client yêu cầu tạo một socket để có thể sử dụng các dịch vụ của tầng vận chuyển, thông thường hệ thống tự động gán một số hiệu cổng còn rảnh cho socket của Client. • Giai đoạn 3: Trao đổi thông tin giữa Client và Server. o Sau khi tạo Socket xong, Client và Server có thể trao đổi thông tin qua lại với nhau thông qua hai hàm send() và receive(). o Đơn vị dữ liệu trao đổi giữa Client và Server là các Datagram Package (Gói tin thư tín). o Protocol của ứng dụng phải định nghĩa khuôn dạng và ý nghĩa của các Datagram Package. Mỗi Datagram Package có chứa thông tin về địa chỉ người gởi và người nhận (IP, Port). \\n\\nhiện nhiều lần (ký hiệu bằng hình ellipse). o Kênh ảo sẽ bị xóa khi Server hoặc Client đóng socket bằng lệnh close(). 2. Mô hình Client-Server sử dụng Socket ở chế độ không nối kết (UDP) Downloaded by Trí Nguy?n (tringuyen7735@gmail.com) lOMoARcPSD|32470842 Có thể phân thành 3 giai đoạn như sau: • Giai đoạn 1: Server tạo Socket – gán số hiệu cổng. o socket(): Server yêu cầu tạo một socket để có thể sử dụng các dịch vụ của tầng vận chuyển. o bind(): Server yêu cầu gán số hiệu cổng cho socket. • Giai đoạn 2: Client tạo Socket. Downloaded by Trí Nguy?n (tringuyen7735@gmail.com) lOMoARcPSD|32470842 o socket(): Client yêu cầu tạo một socket để có thể sử dụng các dịch vụ của tầng vận chuyển, thông thường hệ thống tự động gán một số hiệu cổng còn rảnh cho socket của Client. • Giai đoạn 3: Trao đổi thông tin giữa Client và Server. o Sau khi tạo Socket xong, Client và Server có thể trao đổi thông tin qua lại với nhau thông qua hai hàm send() và receive(). o Đơn vị dữ liệu trao đổi giữa Client và Server là các Datagram Package (Gói tin thư tín). o Protocol của ứng dụng phải định nghĩa khuôn dạng và ý nghĩa của các Datagram Package. Mỗi Datagram Package có chứa thông tin về địa chỉ người gởi và người nhận (IP, Port). Downloaded by Trí Nguy?n (tringuyen7735@gmail.com) lOMoARcPSD|32470842\\\";}}s:5:\\\"tries\\\";N;s:7:\\\"timeout\\\";N;s:7:\\\"backoff\\\";N;s:13:\\\"maxExceptions\\\";N;s:10:\\\"connection\\\";N;s:5:\\\"queue\\\";N;s:12:\\\"messageGroup\\\";N;s:12:\\\"deduplicator\\\";N;s:5:\\\"delay\\\";N;s:11:\\\"afterCommit\\\";N;s:10:\\\"middleware\\\";a:0:{}s:7:\\\"chained\\\";a:0:{}s:15:\\\"chainConnection\\\";N;s:10:\\\"chainQueue\\\";N;s:19:\\\"chainCatchCallbacks\\\";N;}\"},\"createdAt\":1765886090,\"delay\":null}','Illuminate\\Broadcasting\\BroadcastException: Pusher error: The data content of this event exceeds the allowed maximum (10240 bytes). See https://pusher.com/docs/channels/server_api/http-api#publishing-events for more info\n. in D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Broadcasting\\Broadcasters\\PusherBroadcaster.php:163\nStack trace:\n#0 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Broadcasting\\BroadcastEvent.php(93): Illuminate\\Broadcasting\\Broadcasters\\PusherBroadcaster->broadcast(Object(Illuminate\\Support\\Collection), \'App\\\\Events\\\\Chat...\', Array)\n#1 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(36): Illuminate\\Broadcasting\\BroadcastEvent->handle(Object(Illuminate\\Broadcasting\\BroadcastManager))\n#2 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\Util.php(43): Illuminate\\Container\\BoundMethod::Illuminate\\Container\\{closure}()\n#3 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#4 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#5 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\Container.php(836): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#6 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Bus\\Dispatcher.php(132): Illuminate\\Container\\Container->call(Array)\n#7 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Pipeline\\Pipeline.php(180): Illuminate\\Bus\\Dispatcher->Illuminate\\Bus\\{closure}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#8 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Pipeline\\Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->Illuminate\\Pipeline\\{closure}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#9 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Bus\\Dispatcher.php(136): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#10 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\CallQueuedHandler.php(134): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(Illuminate\\Broadcasting\\BroadcastEvent), false)\n#11 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Pipeline\\Pipeline.php(180): Illuminate\\Queue\\CallQueuedHandler->Illuminate\\Queue\\{closure}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#12 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Pipeline\\Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->Illuminate\\Pipeline\\{closure}(Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#13 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\CallQueuedHandler.php(127): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#14 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\CallQueuedHandler.php(68): Illuminate\\Queue\\CallQueuedHandler->dispatchThroughMiddleware(Object(Illuminate\\Queue\\Jobs\\DatabaseJob), Object(Illuminate\\Broadcasting\\BroadcastEvent))\n#15 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Jobs\\Job.php(102): Illuminate\\Queue\\CallQueuedHandler->call(Object(Illuminate\\Queue\\Jobs\\DatabaseJob), Array)\n#16 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Worker.php(451): Illuminate\\Queue\\Jobs\\Job->fire()\n#17 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Worker.php(401): Illuminate\\Queue\\Worker->process(\'database\', Object(Illuminate\\Queue\\Jobs\\DatabaseJob), Object(Illuminate\\Queue\\WorkerOptions))\n#18 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Worker.php(344): Illuminate\\Queue\\Worker->runJob(Object(Illuminate\\Queue\\Jobs\\DatabaseJob), \'database\', Object(Illuminate\\Queue\\WorkerOptions))\n#19 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Console\\WorkCommand.php(148): Illuminate\\Queue\\Worker->runNextJob(\'database\', \'default\', Object(Illuminate\\Queue\\WorkerOptions))\n#20 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Console\\WorkCommand.php(131): Illuminate\\Queue\\Console\\WorkCommand->runWorker(\'database\', \'default\')\n#21 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(36): Illuminate\\Queue\\Console\\WorkCommand->handle()\n#22 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\Util.php(43): Illuminate\\Container\\BoundMethod::Illuminate\\Container\\{closure}()\n#23 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#24 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#25 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\Container.php(836): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#26 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Console\\Command.php(211): Illuminate\\Container\\Container->call(Array)\n#27 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\symfony\\console\\Command\\Command.php(318): Illuminate\\Console\\Command->execute(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#28 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Console\\Command.php(180): Symfony\\Component\\Console\\Command\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#29 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\symfony\\console\\Application.php(1110): Illuminate\\Console\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#30 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\symfony\\console\\Application.php(359): Symfony\\Component\\Console\\Application->doRunCommand(Object(Illuminate\\Queue\\Console\\WorkCommand), Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#31 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\symfony\\console\\Application.php(194): Symfony\\Component\\Console\\Application->doRun(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#32 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Foundation\\Console\\Kernel.php(197): Symfony\\Component\\Console\\Application->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#33 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Foundation\\Application.php(1235): Illuminate\\Foundation\\Console\\Kernel->handle(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#34 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\artisan(16): Illuminate\\Foundation\\Application->handleCommand(Object(Symfony\\Component\\Console\\Input\\ArgvInput))\n#35 {main}','2025-12-16 04:54:53'),(9,'76cb98a1-d262-46b0-af9d-4a0f280eb19b','database','default','{\"uuid\":\"76cb98a1-d262-46b0-af9d-4a0f280eb19b\",\"displayName\":\"App\\\\Jobs\\\\ProcessDocumentJob\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":null,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":null,\"retryUntil\":null,\"data\":{\"commandName\":\"App\\\\Jobs\\\\ProcessDocumentJob\",\"command\":\"O:27:\\\"App\\\\Jobs\\\\ProcessDocumentJob\\\":13:{s:13:\\\"\\u0000*\\u0000documentId\\\";i:26;s:3:\\\"job\\\";N;s:10:\\\"connection\\\";N;s:5:\\\"queue\\\";N;s:12:\\\"messageGroup\\\";N;s:12:\\\"deduplicator\\\";N;s:5:\\\"delay\\\";N;s:11:\\\"afterCommit\\\";N;s:10:\\\"middleware\\\";a:0:{}s:7:\\\"chained\\\";a:0:{}s:15:\\\"chainConnection\\\";N;s:10:\\\"chainQueue\\\";N;s:19:\\\"chainCatchCallbacks\\\";N;}\"},\"createdAt\":1766648904,\"delay\":null}','GuzzleHttp\\Exception\\ConnectException: cURL error 28: Operation timed out after 30003 milliseconds with 0 bytes received (see https://curl.haxx.se/libcurl/c/libcurl-errors.html) for http://127.0.0.1:6333/collections/course_documents/points?wait=true in D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\guzzlehttp\\guzzle\\src\\Handler\\CurlFactory.php:277\nStack trace:\n#0 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\guzzlehttp\\guzzle\\src\\Handler\\CurlFactory.php(207): GuzzleHttp\\Handler\\CurlFactory::createRejection(Object(GuzzleHttp\\Handler\\EasyHandle), Array)\n#1 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\guzzlehttp\\guzzle\\src\\Handler\\CurlFactory.php(159): GuzzleHttp\\Handler\\CurlFactory::finishError(Object(GuzzleHttp\\Handler\\CurlHandler), Object(GuzzleHttp\\Handler\\EasyHandle), Object(GuzzleHttp\\Handler\\CurlFactory))\n#2 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\guzzlehttp\\guzzle\\src\\Handler\\CurlHandler.php(47): GuzzleHttp\\Handler\\CurlFactory::finish(Object(GuzzleHttp\\Handler\\CurlHandler), Object(GuzzleHttp\\Handler\\EasyHandle), Object(GuzzleHttp\\Handler\\CurlFactory))\n#3 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\guzzlehttp\\guzzle\\src\\Handler\\Proxy.php(28): GuzzleHttp\\Handler\\CurlHandler->__invoke(Object(GuzzleHttp\\Psr7\\Request), Array)\n#4 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\guzzlehttp\\guzzle\\src\\Handler\\Proxy.php(48): GuzzleHttp\\Handler\\Proxy::GuzzleHttp\\Handler\\{closure}(Object(GuzzleHttp\\Psr7\\Request), Array)\n#5 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Http\\Client\\PendingRequest.php(1401): GuzzleHttp\\Handler\\Proxy::GuzzleHttp\\Handler\\{closure}(Object(GuzzleHttp\\Psr7\\Request), Array)\n#6 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Http\\Client\\PendingRequest.php(1367): Illuminate\\Http\\Client\\PendingRequest->Illuminate\\Http\\Client\\{closure}(Object(GuzzleHttp\\Psr7\\Request), Array)\n#7 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Http\\Client\\PendingRequest.php(1353): Illuminate\\Http\\Client\\PendingRequest->Illuminate\\Http\\Client\\{closure}(Object(GuzzleHttp\\Psr7\\Request), Array)\n#8 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\guzzlehttp\\guzzle\\src\\PrepareBodyMiddleware.php(64): Illuminate\\Http\\Client\\PendingRequest->Illuminate\\Http\\Client\\{closure}(Object(GuzzleHttp\\Psr7\\Request), Array)\n#9 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\guzzlehttp\\guzzle\\src\\Middleware.php(38): GuzzleHttp\\PrepareBodyMiddleware->__invoke(Object(GuzzleHttp\\Psr7\\Request), Array)\n#10 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\guzzlehttp\\guzzle\\src\\RedirectMiddleware.php(71): GuzzleHttp\\Middleware::GuzzleHttp\\{closure}(Object(GuzzleHttp\\Psr7\\Request), Array)\n#11 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\guzzlehttp\\guzzle\\src\\Middleware.php(63): GuzzleHttp\\RedirectMiddleware->__invoke(Object(GuzzleHttp\\Psr7\\Request), Array)\n#12 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\guzzlehttp\\guzzle\\src\\HandlerStack.php(75): GuzzleHttp\\Middleware::GuzzleHttp\\{closure}(Object(GuzzleHttp\\Psr7\\Request), Array)\n#13 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\guzzlehttp\\guzzle\\src\\Client.php(333): GuzzleHttp\\HandlerStack->__invoke(Object(GuzzleHttp\\Psr7\\Request), Array)\n#14 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\guzzlehttp\\guzzle\\src\\Client.php(169): GuzzleHttp\\Client->transfer(Object(GuzzleHttp\\Psr7\\Request), Array)\n#15 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\guzzlehttp\\guzzle\\src\\Client.php(189): GuzzleHttp\\Client->requestAsync(\'PUT\', Object(GuzzleHttp\\Psr7\\Uri), Array)\n#16 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Http\\Client\\PendingRequest.php(1199): GuzzleHttp\\Client->request(\'PUT\', \'http://127.0.0....\', Array)\n#17 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Http\\Client\\PendingRequest.php(944): Illuminate\\Http\\Client\\PendingRequest->sendRequest(\'PUT\', \'http://127.0.0....\', Array)\n#18 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Support\\helpers.php(329): Illuminate\\Http\\Client\\PendingRequest->Illuminate\\Http\\Client\\{closure}(1)\n#19 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Http\\Client\\PendingRequest.php(942): retry(0, Object(Closure), 100, Object(Closure))\n#20 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Http\\Client\\PendingRequest.php(862): Illuminate\\Http\\Client\\PendingRequest->send(\'PUT\', \'http://127.0.0....\', Array)\n#21 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Http\\Client\\Factory.php(555): Illuminate\\Http\\Client\\PendingRequest->put(\'http://127.0.0....\', Array)\n#22 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Support\\Facades\\Facade.php(363): Illuminate\\Http\\Client\\Factory->__call(\'put\', Array)\n#23 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\app\\Services\\QdrantService.php(28): Illuminate\\Support\\Facades\\Facade::__callStatic(\'put\', Array)\n#24 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\app\\Services\\PdfRagIngestService.php(31): App\\Services\\QdrantService->upsert(\'course_document...\', Array, Array)\n#25 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\app\\Jobs\\ProcessDocumentJob.php(26): App\\Services\\PdfRagIngestService->ingest(Object(App\\Models\\Document))\n#26 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(36): App\\Jobs\\ProcessDocumentJob->handle(Object(App\\Services\\PdfRagIngestService))\n#27 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\Util.php(43): Illuminate\\Container\\BoundMethod::Illuminate\\Container\\{closure}()\n#28 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#29 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#30 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\Container.php(836): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#31 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Bus\\Dispatcher.php(132): Illuminate\\Container\\Container->call(Array)\n#32 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Pipeline\\Pipeline.php(180): Illuminate\\Bus\\Dispatcher->Illuminate\\Bus\\{closure}(Object(App\\Jobs\\ProcessDocumentJob))\n#33 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Pipeline\\Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->Illuminate\\Pipeline\\{closure}(Object(App\\Jobs\\ProcessDocumentJob))\n#34 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Bus\\Dispatcher.php(136): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#35 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\CallQueuedHandler.php(134): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(App\\Jobs\\ProcessDocumentJob), false)\n#36 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Pipeline\\Pipeline.php(180): Illuminate\\Queue\\CallQueuedHandler->Illuminate\\Queue\\{closure}(Object(App\\Jobs\\ProcessDocumentJob))\n#37 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Pipeline\\Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->Illuminate\\Pipeline\\{closure}(Object(App\\Jobs\\ProcessDocumentJob))\n#38 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\CallQueuedHandler.php(127): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#39 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\CallQueuedHandler.php(68): Illuminate\\Queue\\CallQueuedHandler->dispatchThroughMiddleware(Object(Illuminate\\Queue\\Jobs\\DatabaseJob), Object(App\\Jobs\\ProcessDocumentJob))\n#40 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Jobs\\Job.php(102): Illuminate\\Queue\\CallQueuedHandler->call(Object(Illuminate\\Queue\\Jobs\\DatabaseJob), Array)\n#41 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Worker.php(451): Illuminate\\Queue\\Jobs\\Job->fire()\n#42 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Worker.php(401): Illuminate\\Queue\\Worker->process(\'database\', Object(Illuminate\\Queue\\Jobs\\DatabaseJob), Object(Illuminate\\Queue\\WorkerOptions))\n#43 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Worker.php(344): Illuminate\\Queue\\Worker->runJob(Object(Illuminate\\Queue\\Jobs\\DatabaseJob), \'database\', Object(Illuminate\\Queue\\WorkerOptions))\n#44 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Console\\WorkCommand.php(148): Illuminate\\Queue\\Worker->runNextJob(\'database\', \'default\', Object(Illuminate\\Queue\\WorkerOptions))\n#45 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Console\\WorkCommand.php(131): Illuminate\\Queue\\Console\\WorkCommand->runWorker(\'database\', \'default\')\n#46 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(36): Illuminate\\Queue\\Console\\WorkCommand->handle()\n#47 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\Util.php(43): Illuminate\\Container\\BoundMethod::Illuminate\\Container\\{closure}()\n#48 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#49 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#50 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\Container.php(836): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#51 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Console\\Command.php(211): Illuminate\\Container\\Container->call(Array)\n#52 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\symfony\\console\\Command\\Command.php(318): Illuminate\\Console\\Command->execute(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#53 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Console\\Command.php(180): Symfony\\Component\\Console\\Command\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#54 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\symfony\\console\\Application.php(1110): Illuminate\\Console\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#55 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\symfony\\console\\Application.php(359): Symfony\\Component\\Console\\Application->doRunCommand(Object(Illuminate\\Queue\\Console\\WorkCommand), Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#56 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\symfony\\console\\Application.php(194): Symfony\\Component\\Console\\Application->doRun(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#57 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Foundation\\Console\\Kernel.php(197): Symfony\\Component\\Console\\Application->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#58 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Foundation\\Application.php(1235): Illuminate\\Foundation\\Console\\Kernel->handle(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#59 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\artisan(16): Illuminate\\Foundation\\Application->handleCommand(Object(Symfony\\Component\\Console\\Input\\ArgvInput))\n#60 {main}\n\nNext Illuminate\\Http\\Client\\ConnectionException: cURL error 28: Operation timed out after 30003 milliseconds with 0 bytes received (see https://curl.haxx.se/libcurl/c/libcurl-errors.html) for http://127.0.0.1:6333/collections/course_documents/points?wait=true in D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Http\\Client\\PendingRequest.php:1653\nStack trace:\n#0 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Http\\Client\\PendingRequest.php(979): Illuminate\\Http\\Client\\PendingRequest->marshalConnectionException(Object(GuzzleHttp\\Exception\\ConnectException))\n#1 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Support\\helpers.php(329): Illuminate\\Http\\Client\\PendingRequest->Illuminate\\Http\\Client\\{closure}(1)\n#2 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Http\\Client\\PendingRequest.php(942): retry(0, Object(Closure), 100, Object(Closure))\n#3 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Http\\Client\\PendingRequest.php(862): Illuminate\\Http\\Client\\PendingRequest->send(\'PUT\', \'http://127.0.0....\', Array)\n#4 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Http\\Client\\Factory.php(555): Illuminate\\Http\\Client\\PendingRequest->put(\'http://127.0.0....\', Array)\n#5 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Support\\Facades\\Facade.php(363): Illuminate\\Http\\Client\\Factory->__call(\'put\', Array)\n#6 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\app\\Services\\QdrantService.php(28): Illuminate\\Support\\Facades\\Facade::__callStatic(\'put\', Array)\n#7 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\app\\Services\\PdfRagIngestService.php(31): App\\Services\\QdrantService->upsert(\'course_document...\', Array, Array)\n#8 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\app\\Jobs\\ProcessDocumentJob.php(26): App\\Services\\PdfRagIngestService->ingest(Object(App\\Models\\Document))\n#9 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(36): App\\Jobs\\ProcessDocumentJob->handle(Object(App\\Services\\PdfRagIngestService))\n#10 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\Util.php(43): Illuminate\\Container\\BoundMethod::Illuminate\\Container\\{closure}()\n#11 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#12 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#13 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\Container.php(836): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#14 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Bus\\Dispatcher.php(132): Illuminate\\Container\\Container->call(Array)\n#15 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Pipeline\\Pipeline.php(180): Illuminate\\Bus\\Dispatcher->Illuminate\\Bus\\{closure}(Object(App\\Jobs\\ProcessDocumentJob))\n#16 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Pipeline\\Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->Illuminate\\Pipeline\\{closure}(Object(App\\Jobs\\ProcessDocumentJob))\n#17 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Bus\\Dispatcher.php(136): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#18 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\CallQueuedHandler.php(134): Illuminate\\Bus\\Dispatcher->dispatchNow(Object(App\\Jobs\\ProcessDocumentJob), false)\n#19 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Pipeline\\Pipeline.php(180): Illuminate\\Queue\\CallQueuedHandler->Illuminate\\Queue\\{closure}(Object(App\\Jobs\\ProcessDocumentJob))\n#20 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Pipeline\\Pipeline.php(137): Illuminate\\Pipeline\\Pipeline->Illuminate\\Pipeline\\{closure}(Object(App\\Jobs\\ProcessDocumentJob))\n#21 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\CallQueuedHandler.php(127): Illuminate\\Pipeline\\Pipeline->then(Object(Closure))\n#22 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\CallQueuedHandler.php(68): Illuminate\\Queue\\CallQueuedHandler->dispatchThroughMiddleware(Object(Illuminate\\Queue\\Jobs\\DatabaseJob), Object(App\\Jobs\\ProcessDocumentJob))\n#23 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Jobs\\Job.php(102): Illuminate\\Queue\\CallQueuedHandler->call(Object(Illuminate\\Queue\\Jobs\\DatabaseJob), Array)\n#24 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Worker.php(451): Illuminate\\Queue\\Jobs\\Job->fire()\n#25 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Worker.php(401): Illuminate\\Queue\\Worker->process(\'database\', Object(Illuminate\\Queue\\Jobs\\DatabaseJob), Object(Illuminate\\Queue\\WorkerOptions))\n#26 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Worker.php(344): Illuminate\\Queue\\Worker->runJob(Object(Illuminate\\Queue\\Jobs\\DatabaseJob), \'database\', Object(Illuminate\\Queue\\WorkerOptions))\n#27 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Console\\WorkCommand.php(148): Illuminate\\Queue\\Worker->runNextJob(\'database\', \'default\', Object(Illuminate\\Queue\\WorkerOptions))\n#28 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Queue\\Console\\WorkCommand.php(131): Illuminate\\Queue\\Console\\WorkCommand->runWorker(\'database\', \'default\')\n#29 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(36): Illuminate\\Queue\\Console\\WorkCommand->handle()\n#30 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\Util.php(43): Illuminate\\Container\\BoundMethod::Illuminate\\Container\\{closure}()\n#31 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(96): Illuminate\\Container\\Util::unwrapIfClosure(Object(Closure))\n#32 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\BoundMethod.php(35): Illuminate\\Container\\BoundMethod::callBoundMethod(Object(Illuminate\\Foundation\\Application), Array, Object(Closure))\n#33 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Container\\Container.php(836): Illuminate\\Container\\BoundMethod::call(Object(Illuminate\\Foundation\\Application), Array, Array, NULL)\n#34 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Console\\Command.php(211): Illuminate\\Container\\Container->call(Array)\n#35 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\symfony\\console\\Command\\Command.php(318): Illuminate\\Console\\Command->execute(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#36 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Console\\Command.php(180): Symfony\\Component\\Console\\Command\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Illuminate\\Console\\OutputStyle))\n#37 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\symfony\\console\\Application.php(1110): Illuminate\\Console\\Command->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#38 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\symfony\\console\\Application.php(359): Symfony\\Component\\Console\\Application->doRunCommand(Object(Illuminate\\Queue\\Console\\WorkCommand), Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#39 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\symfony\\console\\Application.php(194): Symfony\\Component\\Console\\Application->doRun(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#40 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Foundation\\Console\\Kernel.php(197): Symfony\\Component\\Console\\Application->run(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#41 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\vendor\\laravel\\framework\\src\\Illuminate\\Foundation\\Application.php(1235): Illuminate\\Foundation\\Console\\Kernel->handle(Object(Symfony\\Component\\Console\\Input\\ArgvInput), Object(Symfony\\Component\\Console\\Output\\ConsoleOutput))\n#42 D:\\Sinh vien truong VinhUNI\\ĐACN Năm 4\\elearning\\ElearningApi\\artisan(16): Illuminate\\Foundation\\Application->handleCommand(Object(Symfony\\Component\\Console\\Input\\ArgvInput))\n#43 {main}','2025-12-25 00:48:57');
/*!40000 ALTER TABLE `failed_jobs` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=138 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jobs`
--

LOCK TABLES `jobs` WRITE;
/*!40000 ALTER TABLE `jobs` DISABLE KEYS */;
INSERT INTO `jobs` VALUES (137,'default','{\"uuid\":\"142b9bba-4ccf-429d-a284-acf27863b9f6\",\"displayName\":\"App\\\\Events\\\\ChatMessageSent\",\"job\":\"Illuminate\\\\Queue\\\\CallQueuedHandler@call\",\"maxTries\":null,\"maxExceptions\":null,\"failOnTimeout\":false,\"backoff\":null,\"timeout\":null,\"retryUntil\":null,\"data\":{\"commandName\":\"Illuminate\\\\Broadcasting\\\\BroadcastEvent\",\"command\":\"O:38:\\\"Illuminate\\\\Broadcasting\\\\BroadcastEvent\\\":16:{s:5:\\\"event\\\";O:26:\\\"App\\\\Events\\\\ChatMessageSent\\\":1:{s:7:\\\"message\\\";a:2:{s:8:\\\"question\\\";s:11:\\\"Chào bạn\\\";s:6:\\\"answer\\\";s:1301:\\\"Chào bạn!  \\n\\nTheo tài liệu, mô hình **Client‑Server** sử dụng **Socket** ở chế độ **không nối kết (UDP)** được chia thành **ba giai đoạn**:\\n\\n1. **Giai đoạn 1 – Server tạo Socket và gán số hiệu cổng**  \\n   - Server mở một socket UDP, chỉ định cổng (port) mà nó sẽ lắng nghe các gói tin đến.  \\n\\n2. **Giai đoạn 2 – Client tạo Socket và gửi dữ liệu**  \\n   - Client tạo socket UDP, xác định địa chỉ IP và cổng của Server, sau đó gửi các gói tin (datagram) tới Server mà không cần thiết lập kết nối trước.  \\n\\n3. **Giai đoạn 3 – Server nhận và xử lý dữ liệu, trả kết quả**  \\n   - Server nhận các datagram từ Client, thực hiện xử lý (ví dụ: tính toán, truy xuất dữ liệu) và có thể gửi phản hồi lại cho Client bằng cách tạo và gửi một datagram mới tới địa chỉ và cổng của Client.  \\n\\nCác giai đoạn này cho phép truyền dữ liệu nhanh, không cần thiết lập kết nối ba‑bước như TCP, nhưng không bảo đảm độ tin cậy hay thứ tự gói tin. Nếu bạn cần chi tiết hơn về cách lập trình từng bước (tạo socket, bind, recvfrom, sendto, …) hoặc so sánh\\\";}}s:5:\\\"tries\\\";N;s:7:\\\"timeout\\\";N;s:7:\\\"backoff\\\";N;s:13:\\\"maxExceptions\\\";N;s:10:\\\"connection\\\";N;s:5:\\\"queue\\\";N;s:12:\\\"messageGroup\\\";N;s:12:\\\"deduplicator\\\";N;s:5:\\\"delay\\\";N;s:11:\\\"afterCommit\\\";N;s:10:\\\"middleware\\\";a:0:{}s:7:\\\"chained\\\";a:0:{}s:15:\\\"chainConnection\\\";N;s:10:\\\"chainQueue\\\";N;s:19:\\\"chainCatchCallbacks\\\";N;}\"},\"createdAt\":1768018033,\"delay\":null}',0,NULL,1768018033,1768018033);
/*!40000 ALTER TABLE `jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lesson`
--

DROP TABLE IF EXISTS `lesson`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lesson` (
  `id` int NOT NULL AUTO_INCREMENT,
  `module_id` int NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `number` int DEFAULT NULL,
  `video_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `lesson_details` text COLLATE utf8mb4_unicode_ci,
  `course_order` int DEFAULT NULL,
  `duration` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `module_id` (`module_id`),
  CONSTRAINT `lesson_ibfk_1` FOREIGN KEY (`module_id`) REFERENCES `module` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lesson`
--

LOCK TABLES `lesson` WRITE;
/*!40000 ALTER TABLE `lesson` DISABLE KEYS */;
INSERT INTO `lesson` VALUES (1,1,'Mô hình Client - Server là gì?',1,'https://youtu.be/zoELAirXMJY','abc',1,NULL),(2,1,'Domain là gì? Tên miền là gì?',2,'https://youtu.be/M62l1xA5Eu8','abc',2,NULL),(3,2,'Học IT cần tố chất gì? Góc nhìn khác từ chuyên gia định hướng giáo dục',1,'https://youtu.be/CyZ_O7v62h4','abx',3,1450),(5,2,'Sinh viên IT đi thực tập tại doanh nghiệp cần biết những gì?',2,'https://youtu.be/YH-E4Y3EaT4','abc',4,2091),(6,3,'Bài 1',1,'https://youtu.be/zoELAirXMJY','abc',1,695),(7,3,'Bài 2',2,'https://youtu.be/zoELAirXMJY','abc',2,695),(8,4,'Bài 3',1,'https://youtu.be/zoELAirXMJY','abc',3,695),(9,5,'Giới thiệu khóa học',1,'https://youtu.be/9_uoKY0AwqE','giới thiệu',1,NULL),(10,6,'Hướng dẫn sử dụng Dev - C++',1,'https://youtu.be/vFhKEYRBmVY','Sử dụng',2,NULL);
/*!40000 ALTER TABLE `lesson` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lesson_tracking`
--

DROP TABLE IF EXISTS `lesson_tracking`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lesson_tracking` (
  `id` int NOT NULL AUTO_INCREMENT,
  `student_id` int NOT NULL,
  `lesson_id` int NOT NULL,
  `last_position` int DEFAULT '0',
  `total_watched_time` int DEFAULT '0',
  `progress_percent` int DEFAULT '0',
  `is_completed` tinyint(1) DEFAULT '0',
  `last_viewed` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `student_id` (`student_id`),
  KEY `lesson_id` (`lesson_id`),
  CONSTRAINT `lesson_tracking_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `users` (`id`),
  CONSTRAINT `lesson_tracking_lesson_id_foreign` FOREIGN KEY (`lesson_id`) REFERENCES `lesson` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lesson_tracking`
--

LOCK TABLES `lesson_tracking` WRITE;
/*!40000 ALTER TABLE `lesson_tracking` DISABLE KEYS */;
INSERT INTO `lesson_tracking` VALUES (1,1,1,688,676,99,1,'2025-11-16 15:04:12'),(2,1,2,634,571,100,1,'2025-11-11 04:02:35'),(19,1,3,1387,270,96,1,'2025-12-24 03:52:31'),(20,1,5,605,0,29,0,'2025-12-24 09:02:14');
/*!40000 ALTER TABLE `lesson_tracking` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `migrations`
--

LOCK TABLES `migrations` WRITE;
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;
INSERT INTO `migrations` VALUES (2,'2025_10_23_112548_create_personal_access_tokens_table',1),(3,'2025_11_11_010235_update_foreign_key_lesson_tracking_table',1),(4,'2025_12_15_070250_update_documents_table',2),(5,'2025_12_15_071714_create_jobs_table',3),(6,'2025_12_15_072910_create_failed_jobs_table',4);
/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `module`
--

DROP TABLE IF EXISTS `module`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `module` (
  `id` int NOT NULL AUTO_INCREMENT,
  `course_id` int NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `number` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `course_id` (`course_id`),
  CONSTRAINT `module_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `course` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `module`
--

LOCK TABLES `module` WRITE;
/*!40000 ALTER TABLE `module` DISABLE KEYS */;
INSERT INTO `module` VALUES (1,1,'1. Khái niệm',1),(2,1,'2. Môi trường',2),(3,2,'Chương 1: Khái niệm',1),(4,2,'Chương 2: Kiến thức',2),(5,3,'Chương 1: Giới thiệu',1),(6,3,'Chương 2: Biến và kiểu dữ liệu',2);
/*!40000 ALTER TABLE `module` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notification`
--

DROP TABLE IF EXISTS `notification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notification` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `message` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `read_status` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `notification_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notification`
--

LOCK TABLES `notification` WRITE;
/*!40000 ALTER TABLE `notification` DISABLE KEYS */;
INSERT INTO `notification` VALUES (1,1,'Bạn vừa được giao 1 bài tập mới',1,'2025-11-10 18:31:41');
/*!40000 ALTER TABLE `notification` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_items`
--

DROP TABLE IF EXISTS `order_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_items` (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL,
  `course_id` int NOT NULL,
  `price` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `order_id` (`order_id`),
  KEY `course_id` (`course_id`),
  CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
  CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`course_id`) REFERENCES `course` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_items`
--

LOCK TABLES `order_items` WRITE;
/*!40000 ALTER TABLE `order_items` DISABLE KEYS */;
INSERT INTO `order_items` VALUES (1,1,1,100000.00),(15,15,2,100000.00),(16,16,1,10000.00),(17,17,1,10000.00);
/*!40000 ALTER TABLE `order_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `total_amount` decimal(10,2) NOT NULL,
  `status` enum('pending','paid','cancelled') COLLATE utf8mb4_unicode_ci DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (1,1,100000.00,'paid','2025-11-11 02:50:53'),(15,1,100000.00,'cancelled','2025-12-16 18:18:52'),(16,2,10000.00,'pending','2025-12-25 05:15:39'),(17,5,10000.00,'pending','2026-04-03 02:45:34');
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payments`
--

DROP TABLE IF EXISTS `payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL,
  `payment_method` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `payment_status` enum('pending','success','failed') COLLATE utf8mb4_unicode_ci DEFAULT 'pending',
  `transaction_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `order_id` (`order_id`),
  CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payments`
--

LOCK TABLES `payments` WRITE;
/*!40000 ALTER TABLE `payments` DISABLE KEYS */;
INSERT INTO `payments` VALUES (1,1,'vnpay','success','HD6912A48D95B5F'),(15,15,'vnpay','failed','HD6941A28C50099'),(16,16,'vnpay','pending','HD694CC87B14F9E'),(17,17,'vnpay','pending','HD69CF29CEBCB02');
/*!40000 ALTER TABLE `payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `personal_access_tokens`
--

DROP TABLE IF EXISTS `personal_access_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `personal_access_tokens` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `tokenable_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tokenable_id` bigint unsigned NOT NULL,
  `name` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `abilities` text COLLATE utf8mb4_unicode_ci,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`),
  KEY `personal_access_tokens_expires_at_index` (`expires_at`)
) ENGINE=InnoDB AUTO_INCREMENT=72 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `personal_access_tokens`
--

LOCK TABLES `personal_access_tokens` WRITE;
/*!40000 ALTER TABLE `personal_access_tokens` DISABLE KEYS */;
INSERT INTO `personal_access_tokens` VALUES (62,'App\\Models\\User',2,'Web','5ac82c92c4e3a975e03a4d7e10f7a18b849ed9a4c6dc706e9a28bcb7c07c1cea','[\"*\"]','2025-12-24 22:38:03','2025-12-24 23:10:48','2025-12-24 21:10:48','2025-12-24 22:38:03'),(70,'App\\Models\\User',5,'Web','1c643785bcdc7a8247454b899c719152dc3caaf4d8a7bd18068a71edc255a352','[\"*\"]','2026-04-02 19:46:14','2026-04-02 21:44:22','2026-04-02 19:44:22','2026-04-02 19:46:14'),(71,'App\\Models\\User',1,'Web','e4e8a4b4976d98e3db3478e1bcb736d48f1f175d7d5e8b11da6a2085ba6d1378','[\"*\"]','2026-04-02 19:49:24','2026-04-02 21:46:33','2026-04-02 19:46:33','2026-04-02 19:49:24');
/*!40000 ALTER TABLE `personal_access_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `quiz`
--

DROP TABLE IF EXISTS `quiz`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `quiz` (
  `id` int NOT NULL AUTO_INCREMENT,
  `course_id` int NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `number` int DEFAULT NULL,
  `course_order` int DEFAULT NULL,
  `min_pass_score` int DEFAULT NULL,
  `is_pass_required` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `course_id` (`course_id`),
  CONSTRAINT `quiz_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `course` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quiz`
--

LOCK TABLES `quiz` WRITE;
/*!40000 ALTER TABLE `quiz` DISABLE KEYS */;
INSERT INTO `quiz` VALUES (1,1,'Kết thúc khoá học',1,1,8,1);
/*!40000 ALTER TABLE `quiz` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `quiz_answer`
--

DROP TABLE IF EXISTS `quiz_answer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `quiz_answer` (
  `id` int NOT NULL AUTO_INCREMENT,
  `question_id` int NOT NULL,
  `answer_text` text COLLATE utf8mb4_unicode_ci,
  `is_correct` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `question_id` (`question_id`),
  CONSTRAINT `quiz_answer_ibfk_1` FOREIGN KEY (`question_id`) REFERENCES `quiz_question` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quiz_answer`
--

LOCK TABLES `quiz_answer` WRITE;
/*!40000 ALTER TABLE `quiz_answer` DISABLE KEYS */;
INSERT INTO `quiz_answer` VALUES (17,1,'a',1),(18,1,'b',0),(19,1,'c',0),(20,1,'d',0),(21,3,'c',0),(22,3,'c',0),(23,3,'á',1),(24,3,'s',0),(25,4,'sdas',0),(26,4,'s',1),(27,4,'a',0),(28,4,'s',0),(29,5,'ád',0),(30,5,'ád',1),(31,5,'ád',0),(32,5,'dá',0),(33,6,'s',0),(34,6,'s',0),(35,6,'s',1),(36,6,'s',0);
/*!40000 ALTER TABLE `quiz_answer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `quiz_question`
--

DROP TABLE IF EXISTS `quiz_question`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `quiz_question` (
  `id` int NOT NULL AUTO_INCREMENT,
  `quiz_id` int NOT NULL,
  `question_title` text COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `quiz_id` (`quiz_id`),
  CONSTRAINT `quiz_question_ibfk_1` FOREIGN KEY (`quiz_id`) REFERENCES `quiz` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quiz_question`
--

LOCK TABLES `quiz_question` WRITE;
/*!40000 ALTER TABLE `quiz_question` DISABLE KEYS */;
INSERT INTO `quiz_question` VALUES (1,1,'abcd'),(3,1,'Bac'),(4,1,'Câu 3'),(5,1,'Chào'),(6,1,'Chào bé');
/*!40000 ALTER TABLE `quiz_question` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (3,'Admin'),(2,'Student'),(1,'Teacher');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_answer`
--

DROP TABLE IF EXISTS `student_answer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_answer` (
  `id` int NOT NULL AUTO_INCREMENT,
  `attempt_id` int NOT NULL,
  `question_id` int NOT NULL,
  `answer_id` int DEFAULT NULL,
  `is_correct` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `attempt_id` (`attempt_id`),
  KEY `question_id` (`question_id`),
  KEY `answer_id` (`answer_id`),
  CONSTRAINT `student_answer_ibfk_1` FOREIGN KEY (`attempt_id`) REFERENCES `student_quiz_attempt` (`id`),
  CONSTRAINT `student_answer_ibfk_2` FOREIGN KEY (`question_id`) REFERENCES `quiz_question` (`id`),
  CONSTRAINT `student_answer_ibfk_3` FOREIGN KEY (`answer_id`) REFERENCES `quiz_answer` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_answer`
--

LOCK TABLES `student_answer` WRITE;
/*!40000 ALTER TABLE `student_answer` DISABLE KEYS */;
/*!40000 ALTER TABLE `student_answer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_assignment_submission`
--

DROP TABLE IF EXISTS `student_assignment_submission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_assignment_submission` (
  `id` int NOT NULL AUTO_INCREMENT,
  `assignment_id` int NOT NULL,
  `student_id` int NOT NULL,
  `content` text COLLATE utf8mb4_unicode_ci,
  `file_upload` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `submitted_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `score` decimal(5,2) DEFAULT NULL,
  `teacher_feedback` text COLLATE utf8mb4_unicode_ci,
  `graded_at` timestamp NULL DEFAULT NULL,
  `status` enum('submitted','graded') COLLATE utf8mb4_unicode_ci DEFAULT 'submitted',
  PRIMARY KEY (`id`),
  KEY `assignment_id` (`assignment_id`),
  KEY `student_id` (`student_id`),
  CONSTRAINT `student_assignment_submission_ibfk_1` FOREIGN KEY (`assignment_id`) REFERENCES `assignments` (`id`),
  CONSTRAINT `student_assignment_submission_ibfk_2` FOREIGN KEY (`student_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_assignment_submission`
--

LOCK TABLES `student_assignment_submission` WRITE;
/*!40000 ALTER TABLE `student_assignment_submission` DISABLE KEYS */;
INSERT INTO `student_assignment_submission` VALUES (2,2,1,'{\"text\":\"printf(\'Hello World\\\\n\');\"}','http://localhost:8000/storage/assignments/5BkDZMapfQQaaWQxFSyjateho1PIYjThk8ZxlTUi.docx','2025-12-22 22:43:28',8.00,'/* Bài làm học sinh */\nprintf(\'Hello World\\n\');\n\n/* Nhận xét giáo viên */\nGợi ý: Còn thiếu thư viện, không có hàm main','2025-12-22 22:45:10','graded');
/*!40000 ALTER TABLE `student_assignment_submission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_lesson`
--

DROP TABLE IF EXISTS `student_lesson`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_lesson` (
  `student_id` int NOT NULL,
  `lesson_id` int NOT NULL,
  `completed_datetime` timestamp NULL DEFAULT NULL,
  `progress` int DEFAULT '0',
  `last_viewed` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`student_id`,`lesson_id`),
  KEY `lesson_id` (`lesson_id`),
  CONSTRAINT `student_lesson_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `users` (`id`),
  CONSTRAINT `student_lesson_ibfk_2` FOREIGN KEY (`lesson_id`) REFERENCES `lesson` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_lesson`
--

LOCK TABLES `student_lesson` WRITE;
/*!40000 ALTER TABLE `student_lesson` DISABLE KEYS */;
INSERT INTO `student_lesson` VALUES (1,1,'2025-11-16 15:04:12',99,'2025-11-16 15:04:12'),(1,2,'2025-11-11 04:02:35',100,'2025-11-11 04:02:35'),(1,3,'2025-12-24 03:52:31',96,'2025-12-24 03:52:31');
/*!40000 ALTER TABLE `student_lesson` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_quiz_attempt`
--

DROP TABLE IF EXISTS `student_quiz_attempt`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_quiz_attempt` (
  `id` int NOT NULL AUTO_INCREMENT,
  `student_id` int NOT NULL,
  `quiz_id` int NOT NULL,
  `attempt_datetime` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `score_achieved` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `student_id` (`student_id`),
  KEY `quiz_id` (`quiz_id`),
  CONSTRAINT `student_quiz_attempt_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `users` (`id`),
  CONSTRAINT `student_quiz_attempt_ibfk_2` FOREIGN KEY (`quiz_id`) REFERENCES `quiz` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_quiz_attempt`
--

LOCK TABLES `student_quiz_attempt` WRITE;
/*!40000 ALTER TABLE `student_quiz_attempt` DISABLE KEYS */;
/*!40000 ALTER TABLE `student_quiz_attempt` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `role_id` int NOT NULL,
  `full_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `avatar` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` tinyint DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  KEY `role_id` (`role_id`),
  CONSTRAINT `users_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,1,'Nguyễn Văn A','a@gm.com','$2y$12$5OhaAdukNU4jLHFeSO6bCedvP3NzvotIZBG7s6vaF6EKH076F4TL.',NULL,1,'2025-11-10 18:31:41','2025-11-10 18:31:41'),(2,2,'Văn Nam','vannam@gm.com','$2y$12$YZ0z68CD0JxUv5b0RpG4ZOWyM.GNYRS0pyEzfk0O3y3d9uQ5nCzNO',NULL,1,'2025-12-24 21:10:13','2025-12-25 05:07:11'),(3,2,'Trọng','trong@gm.com','$2y$12$rsb5a2ETpb6PKYIQS9mqn.6w92RAU.PdceplplVyXIqwhMldcqGl2',NULL,1,'2026-01-09 20:01:54','2026-01-09 20:01:54'),(4,1,'Quân','thelu@gmail.com','$2y$12$lk8krI97qWrUua3.CHkcqOeLF2JWPenZJ8LrNjcV6ylh9eo4TQN8y',NULL,1,'2026-01-09 20:02:13','2026-01-09 20:02:13'),(5,1,'Văn Test','vantest@gmail.com','$2y$12$Buf/BGysF0Za3zWzExopiOa1tcX/f87ElYqR3RSES9NS62svCjgTy',NULL,1,'2026-04-02 19:43:36','2026-04-02 19:43:36');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vector_entries`
--

DROP TABLE IF EXISTS `vector_entries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vector_entries` (
  `id` int NOT NULL AUTO_INCREMENT,
  `document_id` int NOT NULL,
  `course_id` int NOT NULL,
  `module_id` int DEFAULT NULL,
  `lesson_id` int DEFAULT NULL,
  `chunk_index` int NOT NULL,
  `text` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `vector_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `document_id` (`document_id`),
  KEY `course_id` (`course_id`),
  KEY `module_id` (`module_id`),
  KEY `lesson_id` (`lesson_id`),
  KEY `vector_id` (`vector_id`),
  CONSTRAINT `fk_vectors_document` FOREIGN KEY (`document_id`) REFERENCES `documents` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vector_entries`
--

LOCK TABLES `vector_entries` WRITE;
/*!40000 ALTER TABLE `vector_entries` DISABLE KEYS */;
/*!40000 ALTER TABLE `vector_entries` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-03 10:01:17
