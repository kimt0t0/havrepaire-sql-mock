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
  `articleId` VARCHAR(36) NOT NULL UNIQUE,
  `title_Fr` VARCHAR(120) NOT NULL UNIQUE,
  `title_En` VARCHAR(120),
  `text_Fr` VARCHAR(1200),
  `text_En` VARCHAR(1200) NOT NULL,
  `categoryId` VARCHAR(36) NOT NULL DEFAULT('2bd65a10-7cbb-11ee-a619-9828a647f095'),
  `state` ENUM ('draft', 'published', 'archived') NOT NULL DEFAULT 'draft',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ,
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `comments` (
  PRIMARY KEY (commentId),
  `commentId` VARCHAR(36) NOT NULL UNIQUE,
  `text` VARCHAR(500) NOT NULL,
  `language` ENUM ('fr', 'en') DEFAULT 'fr',
  `userId` VARCHAR(36) NOT NULL,
  `articleId` VARCHAR(36) NOT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ,
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  
)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `categories` (
  PRIMARY KEY (categoryId),
  `categoryId` VARCHAR(36) NOT NULL UNIQUE,
  `name` VARCHAR(36) NOT NULL
)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `illustrations` (
  PRIMARY KEY (illustrationId),
  `illustrationId` VARCHAR(36) NOT NULL UNIQUE,
  `filename` VARCHAR(80) NOT NULL UNIQUE,
  `filepath` VARCHAR(256) NOT NULL UNIQUE,
  `articleId` VARCHAR(36) NOT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ,
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  
)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `likes` (
  PRIMARY KEY (likeId),
  `likeId` VARCHAR(36) NOT NULL UNIQUE,
  `userId` VARCHAR(36) NOT NULL,
  `articleId` VARCHAR(36) NOT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ,
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  
)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `users` (
  PRIMARY KEY (userId),
  `userId` VARCHAR(36) NOT NULL UNIQUE,
  `username` VARCHAR(80) NOT NULL UNIQUE,
  `email` VARCHAR(120) NOT NULL UNIQUE,
  `hash` VARCHAR(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `gender` ENUM ('m', 'f', 'n') NOT NULL DEFAULT 'n',
  `pronouns` VARCHAR(80),
  `role` ENUM ('admin', 'viewer', 'ghost') NOT NULL DEFAULT 'viewer',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ,
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  
)
ENGINE = InnoDB;

-- Add constraints on foreign keys --
ALTER TABLE `articles`
  ADD CONSTRAINT `hp_article_category` FOREIGN KEY (`categoryId`) REFERENCES `categories` (`categoryId`) ON DELETE RESTRICT ON UPDATE RESTRICT;

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


-- Add data --

-- (users table) --
INSERT INTO `users` VALUES
(UUID(), 'admin', 'admin@fake.net', 'FakePass@44!', DEFAULT, 'iel', 'admin', DEFAULT, DEFAULT),
('54c4c1d9-7cb4-11ee-a619-9828a647f095', 'titi', 'titi@fake.net', 'TitiPass@44!', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT),
(UUID(), 'toto', 'toto@fake.net', 'TotoPass@44!', 'm', DEFAULT, DEFAULT, DEFAULT, DEFAULT),
(UUID(), 'tonton', 'tonton@fake.net', 'TontonPass@44!', 'm', 'il', DEFAULT, DEFAULT, DEFAULT),
(UUID(), 'tata', 'tata@fake.net', 'TataPass@44!', 'f', 'elle /ael', DEFAULT, DEFAULT, DEFAULT);

-- (categories) --
INSERT INTO `categories` VALUES
( '2bd65a10-7cbb-11ee-a619-9828a647f095', 'science_fiction'),
(UUID(), 'fantasy_fantastic'),
(UUID(), 'news');

-- (articles) --
INSERT INTO `articles` VALUES
('41d6022e-7cb4-11ee-a619-9828a647f095', 'Premier Article', DEFAULT, 'Ceci est le texte de mon tout premier article', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT),
(UUID(), 'Article traduit', 'Translated Article', 'Cet article est traduit.', 'This article is translated.', DEFAULT, DEFAULT, DEFAULT, DEFAULT),
('54c7578b-7cb4-11ee-a619-9828a647f095', 'Article formidable', 'Awesome Article', 'Voici mon super article !', 'Here is my great article !', DEFAULT, 'published', DEFAULT, DEFAULT),
(UUID(), 'Article test 1', DEFAULT, 'Ceci est le texte de test', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT),
(UUID(), 'Article test 2', DEFAULT, 'Ceci est le texte de test', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT),
(UUID(), 'Article test 3', DEFAULT, 'Ceci est le texte de test', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT),
(UUID(), 'Article test 4', DEFAULT, 'Ceci est le texte de test', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT),
(UUID(), 'Article test 5', DEFAULT, 'Ceci est le texte de test', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT),
(UUID(), 'Article test 6', DEFAULT, 'Ceci est le texte de test', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT),
(UUID(), 'Article test 7', DEFAULT, 'Ceci est le texte de test', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);

-- (illustrations) --
INSERT INTO `illustrations` VALUES
(UUID(), 'illus_article_1', '/public/images/illus_article_1.jpeg', '41d6022e-7cb4-11ee-a619-9828a647f095', DEFAULT, DEFAULT),
(UUID(), 'illus_super', '/public/images/super_illus.webp', '54c7578b-7cb4-11ee-a619-9828a647f095', DEFAULT, DEFAULT);

-- (likes) --
INSERT INTO `likes` VALUES
(UUID(), '54c4c1d9-7cb4-11ee-a619-9828a647f095', '41d6022e-7cb4-11ee-a619-9828a647f095', DEFAULT, DEFAULT),
(UUID(), '54c4c1d9-7cb4-11ee-a619-9828a647f095', '54c7578b-7cb4-11ee-a619-9828a647f095', DEFAULT, DEFAULT);

-- (comments) --
INSERT INTO `comments` VALUES
(UUID(), 'I love this text !', 'en', '54c4c1d9-7cb4-11ee-a619-9828a647f095', '54c7578b-7cb4-11ee-a619-9828a647f095', DEFAULT, DEFAULT),
(UUID(), 'commentaire test 1', 'fr', '54c4c1d9-7cb4-11ee-a619-9828a647f095', '41d6022e-7cb4-11ee-a619-9828a647f095', DEFAULT, DEFAULT),
(UUID(), 'commentaire test 2', 'fr', '54c4c1d9-7cb4-11ee-a619-9828a647f095', '41d6022e-7cb4-11ee-a619-9828a647f095', DEFAULT, DEFAULT),
(UUID(), 'commentaire test 3', DEFAULT, '54c4c1d9-7cb4-11ee-a619-9828a647f095', '41d6022e-7cb4-11ee-a619-9828a647f095', DEFAULT, DEFAULT);

COMMIT;
