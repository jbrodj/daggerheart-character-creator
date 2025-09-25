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
    `class_name` ENUM('guardian', 'ranger', 'rogue', 'sorcerer', 'warrior') UNIQUE NOT NULL,
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
    `class_id` TINYINT NOT NULL,
    `subclass_name` VARCHAR(24) UNIQUE NOT NULL,
    `foundation_feature_name` VARCHAR(24) NOT NULL,
    `foundation_feature_text` VARCHAR(500) NOT NULL,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`class_id`) REFERENCES `classes`(`id`)
);
