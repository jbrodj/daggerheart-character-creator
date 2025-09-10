-- Create DB
CREATE DATABASE IF NOT EXISTS `dcc`;
USE `dcc`;

-- Add all possible armor values to the armors table
INSERT IGNORE INTO `armors` (`armor_name`, `feature`, `base_score`, `base_thresholds_csv`, `evasion_mod`)
    VALUES ('chainmail','Heavy: -1 to Evasion', 4, '7,15', -1);
INSERT IGNORE INTO `armors` (`armor_name`, `feature`, `base_score`, `base_thresholds_csv`, `evasion_mod`)
    VALUES ('gambeson', 'Flexible: +1 to Evasion', 3, '5,11', 1);
INSERT IGNORE INTO `armors` (`armor_name`, `feature`, `base_score`, `base_thresholds_csv`, `evasion_mod`)
    VALUES ('leather', '', 3, '6,13', 0);

-- Add all possible weapon values to the weapons table
INSERT IGNORE INTO `weapons` (`weapon_name`, `feature`, `trait`, `range`, `damage_die_qty`, `damage_die`, `damage_type`)
    VALUES ('battleaxe',
            '',
            'strength',
            'very close',
            1,
            'd10',
            'phy'
    );
INSERT IGNORE INTO `weapons` (`weapon_name`, `feature`, `trait`, `range`, `damage_die_qty`, `damage_die`, `damage_type`)
    VALUES ('dagger',
            '',
            'finesse',
            'melee',
            1,
            'd8',
            'phy'
    );
INSERT IGNORE INTO `weapons` (`weapon_name`, `feature`, `trait`, `range`, `damage_die_qty`, `damage_die`, `damage_type`)
    VALUES ('dualstaff',
            '',
            'instinct',
            'far',
            1,
            'd6',
            'mag'
    );
INSERT IGNORE INTO `weapons` (`weapon_name`, `feature`, `trait`, `range`, `damage_die_qty`, `damage_die`, `damage_type`)
    VALUES ('longsword',
            '',
            'agility',
            'melee',
            1,
            'd8',
            'phy'
    );
INSERT IGNORE INTO `weapons` (`weapon_name`, `feature`, `trait`, `range`, `damage_die_qty`, `damage_die`, `damage_type`)
    VALUES ('shortbow',
            '',
            'agility',
            'far',
            1,
            'd6',
            'phy'
    );


-- Add all possible Ancestries to the table
INSERT IGNORE INTO `ancestries` (`ancestry_name`, `primary_trait`, `secondary_trait`)
    VALUES('elf',
        'Quick Reactions: Mark a Stress to gain advantage on a reaction roll.',
        'Celestial Trance: During a rest, you can drop into a trance to choose an additional downtime move.'
    );
INSERT IGNORE INTO `ancestries` (`ancestry_name`, `primary_trait`, `secondary_trait`)
    VALUES('giant',
        'Endurance: Gain an additional Hit Point slot at character creation.',
        'Reach: Treat any weapon, ability, spell, or other feature that has a Melee range as though it has a Very Close range instead.'
    );
INSERT IGNORE INTO `ancestries` (`ancestry_name`, `primary_trait`, `secondary_trait`)
    VALUES('human',
        'High Stamina: Gain an additional Stress slot at character creation.',
        'Adaptability: When you fail a roll that utilized one of your Experiences, you can mark a Stress to reroll.'
    );
INSERT IGNORE INTO `ancestries` (`ancestry_name`, `primary_trait`, `secondary_trait`)
    VALUES('katari',
        'Feline Instincts: When you make an Agility Roll, you can spend 2 Hope to reroll your Hope Die.',
        'Retracting Claws: Make an Agility Roll to scratch a target within Melee range. On a success, they become temporarily Vulnerable'
    );
INSERT IGNORE INTO `ancestries` (`ancestry_name`, `primary_trait`, `secondary_trait`)
    VALUES('ribbet',
        'Amphibious: You can breathe and move naturally underwater.',
        'Long Tongue: You can use your long tongue to grab onto things within Close range. Mark a Stress to use your tongue as a Finesse Close weapon that deals d12 physical damage using your Proficiency.'
    );


-- Add all communities to the table
INSERT IGNORE INTO `communities` (`community_name`, `feature`, `traits`)
    VALUES ('highborne',
            'Privilege: You have advantage on rolls to consort with nobles, negotiate prices, or leverage your reputation to get what you want.',
            'Highborne are often amiable, candid, conniving, enterprising, ostentatious, and unflappable.'
    );
INSERT IGNORE INTO `communities` (`community_name`, `feature`, `traits`)
    VALUES ('loreborne',
            'Well-Read: You have advantage on rolls that involve the history, culture, or politics of a prominent person or place.',
            'Loreborne are often direct, eloquent, inquisitive, patient, rhapsodic, and witty.'
    );
INSERT IGNORE INTO `communities` (`community_name`, `feature`, `traits`)
    VALUES ('ridgeborne',
            'Steady: You have advantage on rolls to traverse dangerous cliffs and ledges, navigate harsh environments, and use your survival knowledge.',
            'Ridgeborne are often bold, hardy, indomitable, loyal, reserved, and stubborn.'
    );
INSERT IGNORE INTO `communities` (`community_name`, `feature`, `traits`)
    VALUES ('underborne',
            'Low-Light Living: When you’re in an area with low light or heavy shadow, you have advantage on rolls to hide, investigate, or perceive details within that area.',
            'Highborne are often amiable, candid, conniving, enterprising, ostentatious, and unflappable.'
    );
INSERT IGNORE INTO `communities` (`community_name`, `feature`, `traits`)
    VALUES ('wildborne',
            'Lightfoot: Your movement is naturally silent. You have advantage on rolls to move without being heard.',
            'Wildborne are often hardy, loyal, nurturing, reclusive, sagacious, and vibrant.'
    );


-- For simplicity, we're just going to add one class to the database for demonstration purposes (otherwise it
-- would require copying a lot of text from the Daggerheart SRD)
INSERT IGNORE INTO `classes` (
        `class_name`,
        `class_feature_1`,
        `class_feature_2`,
        `class_feature_3`,
        `class_hope_feature`,
        `domains`,
        `base_evasion`,
        `base_hit_points`,
        `primary_ability`)
    VALUES (
        'sorcerer',
        'Arcane Sense: You can sense the presence of magical people and objects within Close range.',
        'Minor Illusion: Make a Spellcast Roll (10). On a success, you create a minor visual illusion no larger than yourself within Close range. This illusion is convincing to anyone at Close range or farther.',
        'Channel Raw Power: Once per long rest, you can place a domain card from your loadout into your vault and choose to either: • Gain Hope equal to the level of the card. • Enhance a spell that deals damage, gaining a bonus to your damage roll equal to twice the level of the card.',
        'Volatile Magic: Spend 3 Hope to reroll any number of your damage dice on an attack that deals magic damage.',
        'arcana,midnight',
        10,
        6,
        'instinct');

-- For simplicity, we're just going to add one sublcass to the database for demonstration purposes (otherwise
-- it would require copying a lot of text from the Daggerheart SRD)
INSERT IGNORE INTO `subclasses` (`class_id`, `subclass_name`, `foundation_feature_name`, `foundation_feature_text`)
    VALUES (
        (SELECT `id` FROM `classes` WHERE `class_name` = 'sorcerer'),
        'primal origin',
        'manipulate magic',
        'Your primal origin allows you to modify the essence of magic itself. After you cast a spell or make an attack using a weapon that deals magic damage, you can mark a Stress to do one of the following:
    • Extend the spell or attack’s reach by one range
    • Gain a +2 bonus to the action roll’s result
    • Double a damage die of your choice
    • Hit an additional target within range');


-- Commit changes
COMMIT;

-- Validate all game-provided data by querying each table.
SELECT * FROM `armors`;
SELECT * FROM `weapons`;
SELECT * FROM `ancestries`;
SELECT * FROM `communities`;
SELECT * FROM `classes`;
SELECT * FROM `subclasses`;