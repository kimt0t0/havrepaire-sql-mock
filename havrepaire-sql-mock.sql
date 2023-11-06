-- Initial settings and start transaction --
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+01:00";

-- Create Database --
DROP SCHEMA IF EXISTS `havrepairedb`;
CREATE SCHEMA IF NOT EXISTS `havrepairedb` DEFAULT CHARACTER SET utf8mb4;
USE `havrepairedb`;

-- Add tables --
CREATE TABLE IF NOT EXISTS `articles` (
  PRIMARY KEY (articleId),
  `articleId` BINARY(16) NOT NULL UNIQUE,
  `title_Fr` VARCHAR(120) NOT NULL UNIQUE,
  `title_En` VARCHAR(120),
  `text_En` VARCHAR(1200),
  `text_Fr` VARCHAR(1200) NOT NULL,
  `categories` SET ('short', 'long', 'news', 'fantasy', 'science_fiction'),
  `state` ENUM ('draft', 'published', 'archived') NOT NULL DEFAULT 'draft'
)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `comments` (
  PRIMARY KEY (commentId),
  `commentId` BINARY(16) NOT NULL UNIQUE,
  `text` VARCHAR(500) NOT NULL,
  `languages` SET ('fr', 'en') DEFAULT 'fr',
  `userId` BINARY(16) NOT NULL,
  `articleId` BINARY(16) NOT NULL
)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `illustrations` (
  PRIMARY KEY (illustrationId),
  `illustrationId` BINARY(16) NOT NULL UNIQUE,
  `filename` VARCHAR(80) NOT NULL UNIQUE,
  `filepath` VARCHAR(256) NOT NULL UNIQUE,
  `articleId` BINARY(16) NOT NULL
)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `likes` (
  PRIMARY KEY (likeId),
  `likeId` BINARY(16) NOT NULL UNIQUE,
  `userId` BINARY(16) NOT NULL,
  `articleId` BINARY(16) NOT NULL
)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `users` (
  PRIMARY KEY (userId),
  `userId` BINARY(16) NOT NULL UNIQUE,
  `username` VARCHAR(80) NOT NULL UNIQUE,
  `email` VARCHAR(120) NOT NULL UNIQUE,
  `hash` VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `gender` ENUM ('m', 'f', 'n') NOT NULL DEFAULT 'n',
  `pronouns` VARCHAR(80),
  `role` ENUM ('admin', 'viewer', 'ghost') NOT NULL DEFAULT 'viewer'
)
ENGINE = InnoDB;

-- Add constraints on foreign keys --

ALTER TABLE `comments`
  ADD CONSTRAINT `hp_comment_user` FOREIGN KEY (`userId`) REFERENCES `users` (`userId`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `hp_comment_article` FOREIGN KEY (`articleId`) REFERENCES `articles` (`articleId`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `likes`
  ADD CONSTRAINT `hp_like_user` FOREIGN KEY (`userId`) REFERENCES `users` (`userId`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `hp_like_article` FOREIGN KEY (`articleId`) REFERENCES `articles` (`articleId`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `illustrations`
  ADD CONSTRAINT `hp_illustration_article` FOREIGN KEY (`articleId`) REFERENCES `articles` (`articleId`) ON DELETE CASCADE ON UPDATE CASCADE;


-- End transaction --
COMMIT;