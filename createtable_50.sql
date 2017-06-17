
CREATE DATABASE IF NOT EXISTS `moviedb` DEFAULT CHARACTER SET latin1;
USE `moviedb`;

DROP TABLE IF EXISTS `movies`;
CREATE TABLE `movies` (
    `id` INT(20) NOT NULL auto_increment,
    `title` text NOT NULL,
    `year` INT(4) NOT NULL,
    `director` VARCHAR(100) NOT NULL,
    `banner_url` VARCHAR(200) NOT NULL DEFAULT '',
    `trailer_url` VARCHAR(200) NOT NULL DEFAULT '',
    PRIMARY KEY (`id`), 
    FULLTEXT (`title`));

DROP TABLE IF EXISTS `stars`;
CREATE TABLE `stars` (
    `id` INT(20) NOT NULL auto_increment,
    `first_name` VARCHAR(50) NOT NULL,
    `last_name` VARCHAR(50) NOT NULL,
    `dob` DATE DEFAULT NULL,
    `photo_url` VARCHAR(200) NOT NULL DEFAULT '',
    PRIMARY KEY (`id`)
)  ENGINE=INNODB DEFAULT CHARSET=LATIN1;

DROP TABLE IF EXISTS `stars_in_movies`;
CREATE TABLE `stars_in_movies` (
    `star_id` INT(20) NOT NULL,
    `movie_id` INT(20) NOT NULL,
    FOREIGN KEY (`star_id`)
        REFERENCES stars (`id`)
        ON DELETE CASCADE,
	FOREIGN KEY (`movie_id`)
		REFERENCES movies (`id`)
        ON DELETE CASCADE
)  ENGINE=INNODB DEFAULT CHARSET=LATIN1;



DROP TABLE IF EXISTS `genres`;
CREATE TABLE `genres` (
    `id` INT(20) NOT NULL auto_increment,
    `name` VARCHAR(32) NOT NULL, 
    PRIMARY KEY (`id`)
)  ENGINE=INNODB DEFAULT CHARSET=LATIN1;



DROP TABLE IF EXISTS `genres_in_movies`;
CREATE TABLE `genres_in_movies` (
    `genre_id` INT(20) NOT NULL,
    `movie_id` INT(20) NOT NULL,
    FOREIGN KEY (`genre_id`)
		REFERENCES genres (`id`)
        ON DELETE CASCADE,
	FOREIGN KEY (`movie_id`)
		REFERENCES movies (`id`)
        ON DELETE CASCADE
)  ENGINE=INNODB DEFAULT CHARSET=LATIN1;

DROP TABLE IF EXISTS `creditcards`;
CREATE TABLE `creditcards` (
    `id` VARCHAR(20) NOT NULL,
    `first_name` VARCHAR(50) NOT NULL,
    `last_name` VARCHAR(50) NOT NULL,
    `expiration` DATE NOT NULL,
    PRIMARY KEY (`id`)
)  ENGINE=INNODB DEFAULT CHARSET=LATIN1;

DROP TABLE IF EXISTS `customers`;
CREATE TABLE `customers` (
    `id` INT(20) NOT NULL auto_increment,
    `first_name` VARCHAR(50) NOT NULL,
    `last_name` VARCHAR(50) NOT NULL,
    `cc_id` VARCHAR(20) NOT NULL,
    `address` VARCHAR(200) NOT NULL,
    `email` VARCHAR(50) NOT NULL,
    `password` VARCHAR(20) NOT NULL,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`cc_id`)
        REFERENCES creditcards (`id`)
		ON DELETE CASCADE
)  ENGINE=INNODB DEFAULT CHARSET=LATIN1;



DROP TABLE IF EXISTS `sales`;
CREATE TABLE `sales` (
    `id` INT(20) NOT NULL auto_increment,
    `customer_id` INT(20) NOT NULL,
    `movie_id` INT(20) NOT NULL,
    `sale_date` DATE NOT NULL,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`customer_id`)
        REFERENCES customers (`id`)
        ON DELETE CASCADE,
	FOREIGN KEY (`movie_id`)
		REFERENCES movies (`id`)
        ON DELETE CASCADE
)  ENGINE=INNODB DEFAULT CHARSET=LATIN1;



