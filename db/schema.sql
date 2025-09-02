-- In this SQL file, write (and comment!) the schema of your database, including the CREATE TABLE, CREATE INDEX, CREATE VIEW, etc. statements that compose it

DROP DATABASE IF EXISTS `daggerheart`;
CREATE DATABASE `daggerheart`;
USE `daggerheart`;

-- Create tables to store game-provided data:
CREATE TABLE IF NOT EXISTS `armors` (
    `id` TINYINT AUTO_INCREMENT,
    `armor_name` ENUM('chainmail', 'gambeson', 'leather') UNIQUE NOT NULL,
    `feature` VARCHAR(48),
    `base_score` TINYINT NOT NULL,
    `base_thresholds_csv` VARCHAR(6) NOT NULL,
    `evasion_mod` TINYINT DEFAULT 0,
    PRIMARY KEY (`id`)
);


CREATE TABLE IF NOT EXISTS `weapons` (
    `id` TINYINT AUTO_INCREMENT,
    `weapon_name` ENUM('battleaxe', 'dagger', 'dualstaff', 'longsword', 'shortbow') UNIQUE NOT NULL,
    `feature` VARCHAR(48),
    `trait` ENUM('agility', 'strength', 'finesse', 'instinct', 'presence', 'knowledge') NOT NULL,
    `range` ENUM('melee', 'very close', 'close', 'far') NOT NULL,
    `damage_die_qty` TINYINT NOT NULL DEFAULT 1 CHECK(`damage_die_qty` > 0),
    `damage_die` ENUM('d4', 'd6', 'd8', 'd10', 'd12') NOT NULL,
    `damage_type` ENUM('phy', 'mag') NOT NULL,
    PRIMARY KEY (`id`)
);


CREATE TABLE IF NOT EXISTS `ancestries` (
    `id` TINYINT AUTO_INCREMENT,
    `ancestry_name` ENUM('elf', 'giant', 'human', 'katari', 'ribbet') UNIQUE NOT NULL,
    `primary_trait` VARCHAR(255) NOT NULL,
    `secondary_trait` VARCHAR(255) NOT NULL,
    PRIMARY KEY (`id`)
);


CREATE TABLE IF NOT EXISTS `communities` (
    `id` TINYINT AUTO_INCREMENT,
    `community_name` ENUM('highborne', 'loreborne', 'ridgeborne', 'underborne', 'wildborne') UNIQUE NOT NULL,
    `feature` VARCHAR(255) NOT NULL,
    `traits` VARCHAR(255) NOT NULL,
    PRIMARY KEY (`id`)
);


CREATE TABLE IF NOT EXISTS `classes` (
    `id` TINYINT AUTO_INCREMENT,
    `class_name` ENUM('guardian', 'ranger', 'rogue', 'sorcerer', 'warrior') NOT NULL,
    `class_feature_1` TINYTEXT NOT NULL,
    `class_feature_2` TINYTEXT NOT NULL,
    `class_feature_3` VARCHAR(500) NOT NULL,
    `class_hope_feature` VARCHAR(255) NOT NULL,
    `domains` SET('arcana', 'blade', 'bone', 'grace', 'midnight', 'sage', 'valor') NOT NULL,
    `base_evasion` TINYINT NOT NULL,
    `base_hit_points` TINYINT NOT NULL,
    `primary_ability` ENUM('agility', 'strength', 'finesse', 'instinct', 'presence', 'knowledge'),
    PRIMARY KEY(`id`)
);


CREATE TABLE IF NOT EXISTS `subclasses` (
    `id` TINYINT AUTO_INCREMENT,
    `class_id` TINYINT,
    `subclass_name` VARCHAR(24) UNIQUE NOT NULL,
    `foundation_feature_name` VARCHAR(24) NOT NULL,
    `foundation_feature_text` VARCHAR(500) NOT NULL,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`class_id`) REFERENCES `classes`(`id`)
);


-- Create tables for user-provided data:

CREATE TABLE IF NOT EXISTS `users` (
    `id` BIGINT AUTO_INCREMENT,
    `username` VARCHAR(64) NOT NULL UNIQUE,
    PRIMARY KEY (`id`)
);
-- In production, this table would also store password hashes and other useful user profile info.
-- Didn't bother with it here since we're not using it.


CREATE TABLE IF NOT EXISTS `characters` (
    `id` BIGINT AUTO_INCREMENT,
    `name` VARCHAR(32) NOT NULL,
    `ancestry_id` TINYINT NOT NULL,
    `community_id` TINYINT NOT NULL,
    `class_id` TINYINT NOT NULL,
    `subclass_id` TINYINT NOT NULL,
    `level` TINYINT DEFAULT 1,
    `ability_scores_csv` TINYTEXT NOT NULL,
    `armor_id` TINYINT NOT NULL,
    `weapon_id` TINYINT NOT NULL,
    PRIMARY KEY(`id`),
    FOREIGN KEY(`class_id`) REFERENCES `classes`(`id`),
    FOREIGN KEY (`subclass_id`) REFERENCES `subclasses`(`id`),
    FOREIGN KEY (`ancestry_id`) REFERENCES `ancestries`(`id`),
    FOREIGN KEY (`community_id`) REFERENCES `communities`(`id`),
    FOREIGN KEY (`armor_id`) REFERENCES `armors`(`id`),
    FOREIGN KEY (`weapon_id`) REFERENCES `weapons`(`id`)
);


-- Junction table for users + characters
CREATE TABLE IF NOT EXISTS `user_char_ids` (
    `user_id` BIGINT NOT NULL,
    `char_id` BIGINT NOT NULL UNIQUE,
    PRIMARY KEY (`user_id`, `char_id`),
    FOREIGN KEY (`user_id`) REFERENCES `users`(`id`),
    FOREIGN KEY (`char_id`) REFERENCES `characters`(`id`)
);


CREATE TABLE IF NOT EXISTS `character_status` (
    `character_id` BIGINT,
    `is_alive` BOOLEAN DEFAULT TRUE,
    `level` TINYINT DEFAULT 1 CHECK(`level`>0 AND `level`<=20),
    `hit_point_max` TINYINT NOT NULL CHECK(`hit_point_max`>0),
    `hit_point_current` TINYINT CHECK(`hit_point_current`>=0),
    `stress` TINYINT DEFAULT 0 CHECK(`stress`>=0 AND `stress`<=12),
    `hope` TINYINT DEFAULT 0 CHECK(`hope`>=0 AND `hope`<=6),
    `is_archived` BOOLEAN DEFAULT FALSE,
    PRIMARY KEY(`character_id`),
    FOREIGN KEY (`character_id`) REFERENCES `characters`(`id`)
);


-- Optimizations & automation:

-- Since we need to access characters by their name, querying will be faster if we index the name column
-- --> Revisit this - not using this column as often anymore
CREATE INDEX `char_name_index`
    ON `characters` (`name`);


DELIMITER //
-- For convenience, let's store the user id as a user-defined variable when a new user is created.
CREATE TRIGGER `create_user_id_var`
    AFTER INSERT ON `users`
    FOR EACH ROW
    BEGIN
        SET @user_id = NEW.`id`;
    END //


-- In order to access characters that are related to a specific user, we'll need to update the `user_char_ids` junction table
-- whenever a new character is inserted in the `characters` table. We can use a trigger for this.
-- We need to access the id in the `characters` table, so this trigger needs to occur after the insert.
CREATE TRIGGER `insert_user_char_ids`
    AFTER INSERT ON `characters`
    FOR EACH ROW
    BEGIN
        INSERT INTO `user_char_ids` (`user_id`, `char_id`)
        VALUES ((SELECT @user_id), NEW.`id`);
    END //


-- We should also include a trigger to clean up the `user_char_ids` table when a character deleted. This should occur before
-- the delete on the `characters` table to comply with the foreign key constraint, we can consider this being capable of running
-- multiple rows in case we want to support deleting a user (and all their characters).
CREATE TRIGGER `delete_user_char_ids`
    BEFORE DELETE ON `characters`
    FOR EACH ROW
    BEGIN
        DELETE FROM `user_char_ids` WHERE `char_id` = OLD.`id`;
    END //


-- We also need to create a row on the `character_status` table for a new character and populate it with the character.id.
-- Since a new character's current hit points is always = its max hit points, we can reference the same base hp value from class info.
CREATE TRIGGER `insert_character_status`
    AFTER INSERT ON `characters`
    FOR EACH ROW
    BEGIN
        INSERT INTO `character_status` (`character_id`, `hit_point_max`, `hit_point_current`)
        VALUES (
            NEW.`id`,
            (SELECT `base_hit_points` FROM `classes` WHERE `id` = NEW.`class_id`),
            (SELECT `base_hit_points` FROM `classes` WHERE `id` = NEW.`class_id`)
        );
    END //


-- We should also delete the character status entry if a character is deleted
CREATE TRIGGER `delete_character_status`
    BEFORE DELETE ON `characters`
    FOR EACH ROW
    BEGIN
        DELETE FROM `character_status` WHERE `character_id` = OLD.`id`;
    END //


-- Create a reusable way to fetch a list of characters that belong to the current user and are not currently archived.
CREATE PROCEDURE IF NOT EXISTS `select_current_user_characters` (IN `current_user` bigint)
    BEGIN
        SELECT `char_id`, `is_archived` FROM `user_char_ids`
        JOIN `character_status` ON `user_char_ids`.`char_id` = `character_status`.`character_id`
        WHERE `user_id` = `current_user` AND `is_archived` = FALSE;
    END //


-- Create a resuable way to fetch all pertinent game data for the currently selected character.
CREATE PROCEDURE IF NOT EXISTS `create_current_char_view`(IN `current_character` bigint)
    BEGIN
        SELECT
            `characters`.`id`,
            `name`,
            `community_name`,
            `ancestry_name`,
            `character_status`.`level`,
            `class_name`,
            `subclass_name`,
            `ability_scores_csv`,
            `is_alive`,
            `hit_point_max`,
            `hit_point_current`,
            `stress`,
            `hope`,
            `armor_name`,
            -- `armors`.`feature` AS `armor_feature`,
            `base_score` AS `base_armor_score`,
            `base_thresholds_csv`,
            `evasion_mod`,
            `weapon_name`,
            -- `weapons`.`feature` AS `weapon_feature`,
            `weapons`.`trait` AS `weapon_trait`,
            `range`,
            `damage_die_qty`,
            `damage_die`,
            `damage_type`
        FROM `characters`
        JOIN `character_status` ON `characters`.`id` = `character_status`.`character_id`
        JOIN `classes` ON `classes`.`id` = `characters`.`class_id`
        JOIN `subclasses` ON `subclasses`.`id` = `characters`.`subclass_id`
        JOIN `ancestries` ON `ancestries`.`id` = `characters`.`ancestry_id`
        JOIN `communities` ON `communities`.`id` = `characters`.`community_id`
        JOIN `armors` ON `armors`.`id` = `characters`.`armor_id`
        JOIN `weapons` ON `weapons`.`id` = `characters`.`weapon_id`
        ;
    END //

DELIMITER ;


