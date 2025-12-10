-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema elearning
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema elearning
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `elearning` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci ;
USE `elearning` ;

-- -----------------------------------------------------
-- Table `elearning`.`roles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `elearning`.`roles` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `name` (`name` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `elearning`.`users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `elearning`.`users` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `role_id` INT NOT NULL,
  `full_name` VARCHAR(100) NULL DEFAULT NULL,
  `email` VARCHAR(100) NOT NULL,
  `password` VARCHAR(255) NOT NULL,
  `avatar` VARCHAR(255) NULL DEFAULT NULL,
  `status` TINYINT NULL DEFAULT '1',
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `email` (`email` ASC) VISIBLE,
  INDEX `role_id` (`role_id` ASC) VISIBLE,
  CONSTRAINT `users_ibfk_1`
    FOREIGN KEY (`role_id`)
    REFERENCES `elearning`.`roles` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `elearning`.`activity_log`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `elearning`.`activity_log` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `action` VARCHAR(100) NOT NULL,
  `ip_address` VARCHAR(45) NULL DEFAULT NULL,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `user_id` (`user_id` ASC) VISIBLE,
  CONSTRAINT `activity_log_ibfk_1`
    FOREIGN KEY (`user_id`)
    REFERENCES `elearning`.`users` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `elearning`.`course`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `elearning`.`course` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `teacher_id` INT NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  `description` TEXT NULL DEFAULT NULL,
  `price` DECIMAL(10,2) NULL DEFAULT '0.00',
  `is_progress_limited` TINYINT(1) NULL DEFAULT '0',
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `teacher_id` (`teacher_id` ASC) VISIBLE,
  CONSTRAINT `course_ibfk_1`
    FOREIGN KEY (`teacher_id`)
    REFERENCES `elearning`.`users` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `elearning`.`discussion`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `elearning`.`discussion` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `course_id` INT NOT NULL,
  `user_id` INT NOT NULL,
  `content` TEXT NOT NULL,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `course_id` (`course_id` ASC) VISIBLE,
  INDEX `user_id` (`user_id` ASC) VISIBLE,
  CONSTRAINT `discussion_ibfk_1`
    FOREIGN KEY (`course_id`)
    REFERENCES `elearning`.`course` (`id`),
  CONSTRAINT `discussion_ibfk_2`
    FOREIGN KEY (`user_id`)
    REFERENCES `elearning`.`users` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `elearning`.`comment`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `elearning`.`comment` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `discussion_id` INT NOT NULL,
  `user_id` INT NOT NULL,
  `content` TEXT NOT NULL,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `discussion_id` (`discussion_id` ASC) VISIBLE,
  INDEX `user_id` (`user_id` ASC) VISIBLE,
  CONSTRAINT `comment_ibfk_1`
    FOREIGN KEY (`discussion_id`)
    REFERENCES `elearning`.`discussion` (`id`),
  CONSTRAINT `comment_ibfk_2`
    FOREIGN KEY (`user_id`)
    REFERENCES `elearning`.`users` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `elearning`.`enrolment`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `elearning`.`enrolment` (
  `course_id` INT NOT NULL,
  `student_id` INT NOT NULL,
  `enrolment_datetime` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `completed_datetime` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`course_id`, `student_id`),
  INDEX `student_id` (`student_id` ASC) VISIBLE,
  CONSTRAINT `enrolment_ibfk_1`
    FOREIGN KEY (`course_id`)
    REFERENCES `elearning`.`course` (`id`),
  CONSTRAINT `enrolment_ibfk_2`
    FOREIGN KEY (`student_id`)
    REFERENCES `elearning`.`users` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `elearning`.`module`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `elearning`.`module` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `course_id` INT NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  `number` INT NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `course_id` (`course_id` ASC) VISIBLE,
  CONSTRAINT `module_ibfk_1`
    FOREIGN KEY (`course_id`)
    REFERENCES `elearning`.`course` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `elearning`.`lesson`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `elearning`.`lesson` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `module_id` INT NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  `number` INT NULL DEFAULT NULL,
  `video_url` VARCHAR(255) NULL DEFAULT NULL,
  `lesson_details` TEXT NULL DEFAULT NULL,
  `course_order` INT NULL DEFAULT NULL,
  `duration` INT NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `module_id` (`module_id` ASC) VISIBLE,
  CONSTRAINT `lesson_ibfk_1`
    FOREIGN KEY (`module_id`)
    REFERENCES `elearning`.`module` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `elearning`.`lesson_tracking`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `elearning`.`lesson_tracking` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `student_id` INT NOT NULL,
  `lesson_id` INT NOT NULL,
  `last_position` INT NULL DEFAULT '0',
  `total_watched_time` INT NULL DEFAULT '0',
  `progress_percent` INT NULL DEFAULT '0',
  `is_completed` TINYINT(1) NULL DEFAULT '0',
  `last_viewed` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `student_id` (`student_id` ASC) VISIBLE,
  INDEX `lesson_id` (`lesson_id` ASC) VISIBLE,
  CONSTRAINT `lesson_tracking_ibfk_1`
    FOREIGN KEY (`student_id`)
    REFERENCES `elearning`.`users` (`id`),
  CONSTRAINT `lesson_tracking_ibfk_2`
    FOREIGN KEY (`lesson_id`)
    REFERENCES `elearning`.`lesson` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `elearning`.`notification`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `elearning`.`notification` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `message` VARCHAR(255) NOT NULL,
  `read_status` TINYINT(1) NULL DEFAULT '0',
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `user_id` (`user_id` ASC) VISIBLE,
  CONSTRAINT `notification_ibfk_1`
    FOREIGN KEY (`user_id`)
    REFERENCES `elearning`.`users` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `elearning`.`orders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `elearning`.`orders` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `total_amount` DECIMAL(10,2) NOT NULL,
  `status` ENUM('pending', 'paid', 'cancelled') NULL DEFAULT 'pending',
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `user_id` (`user_id` ASC) VISIBLE,
  CONSTRAINT `orders_ibfk_1`
    FOREIGN KEY (`user_id`)
    REFERENCES `elearning`.`users` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `elearning`.`order_items`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `elearning`.`order_items` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `order_id` INT NOT NULL,
  `course_id` INT NOT NULL,
  `price` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `order_id` (`order_id` ASC) VISIBLE,
  INDEX `course_id` (`course_id` ASC) VISIBLE,
  CONSTRAINT `order_items_ibfk_1`
    FOREIGN KEY (`order_id`)
    REFERENCES `elearning`.`orders` (`id`),
  CONSTRAINT `order_items_ibfk_2`
    FOREIGN KEY (`course_id`)
    REFERENCES `elearning`.`course` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `elearning`.`payments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `elearning`.`payments` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `order_id` INT NOT NULL,
  `payment_method` VARCHAR(50) NULL DEFAULT NULL,
  `payment_status` ENUM('pending', 'success', 'failed') NULL DEFAULT 'pending',
  `transaction_id` VARCHAR(100) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `order_id` (`order_id` ASC) VISIBLE,
  CONSTRAINT `payments_ibfk_1`
    FOREIGN KEY (`order_id`)
    REFERENCES `elearning`.`orders` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `elearning`.`quiz`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `elearning`.`quiz` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `course_id` INT NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  `number` INT NULL DEFAULT NULL,
  `course_order` INT NULL DEFAULT NULL,
  `min_pass_score` INT NULL DEFAULT NULL,
  `is_pass_required` TINYINT(1) NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  INDEX `course_id` (`course_id` ASC) VISIBLE,
  CONSTRAINT `quiz_ibfk_1`
    FOREIGN KEY (`course_id`)
    REFERENCES `elearning`.`course` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `elearning`.`quiz_question`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `elearning`.`quiz_question` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `quiz_id` INT NOT NULL,
  `question_title` TEXT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `quiz_id` (`quiz_id` ASC) VISIBLE,
  CONSTRAINT `quiz_question_ibfk_1`
    FOREIGN KEY (`quiz_id`)
    REFERENCES `elearning`.`quiz` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `elearning`.`quiz_answer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `elearning`.`quiz_answer` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `question_id` INT NOT NULL,
  `answer_text` TEXT NULL DEFAULT NULL,
  `is_correct` TINYINT(1) NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  INDEX `question_id` (`question_id` ASC) VISIBLE,
  CONSTRAINT `quiz_answer_ibfk_1`
    FOREIGN KEY (`question_id`)
    REFERENCES `elearning`.`quiz_question` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `elearning`.`student_quiz_attempt`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `elearning`.`student_quiz_attempt` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `student_id` INT NOT NULL,
  `quiz_id` INT NOT NULL,
  `attempt_datetime` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `score_achieved` INT NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `student_id` (`student_id` ASC) VISIBLE,
  INDEX `quiz_id` (`quiz_id` ASC) VISIBLE,
  CONSTRAINT `student_quiz_attempt_ibfk_1`
    FOREIGN KEY (`student_id`)
    REFERENCES `elearning`.`users` (`id`),
  CONSTRAINT `student_quiz_attempt_ibfk_2`
    FOREIGN KEY (`quiz_id`)
    REFERENCES `elearning`.`quiz` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `elearning`.`student_answer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `elearning`.`student_answer` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `attempt_id` INT NOT NULL,
  `question_id` INT NOT NULL,
  `answer_id` INT NULL DEFAULT NULL,
  `answer_text` TEXT NULL DEFAULT NULL,
  `is_correct` TINYINT(1) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `attempt_id` (`attempt_id` ASC) VISIBLE,
  INDEX `question_id` (`question_id` ASC) VISIBLE,
  INDEX `answer_id` (`answer_id` ASC) VISIBLE,
  CONSTRAINT `student_answer_ibfk_1`
    FOREIGN KEY (`attempt_id`)
    REFERENCES `elearning`.`student_quiz_attempt` (`id`),
  CONSTRAINT `student_answer_ibfk_2`
    FOREIGN KEY (`question_id`)
    REFERENCES `elearning`.`quiz_question` (`id`),
  CONSTRAINT `student_answer_ibfk_3`
    FOREIGN KEY (`answer_id`)
    REFERENCES `elearning`.`quiz_answer` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `elearning`.`student_lesson`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `elearning`.`student_lesson` (
  `student_id` INT NOT NULL,
  `lesson_id` INT NOT NULL,
  `completed_datetime` TIMESTAMP NULL DEFAULT NULL,
  `progress` INT NULL DEFAULT '0',
  `last_viewed` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`student_id`, `lesson_id`),
  INDEX `lesson_id` (`lesson_id` ASC) VISIBLE,
  CONSTRAINT `student_lesson_ibfk_1`
    FOREIGN KEY (`student_id`)
    REFERENCES `elearning`.`users` (`id`),
  CONSTRAINT `student_lesson_ibfk_2`
    FOREIGN KEY (`lesson_id`)
    REFERENCES `elearning`.`lesson` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
