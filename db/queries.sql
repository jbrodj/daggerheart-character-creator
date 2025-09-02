-- In this SQL file, write (and comment!) the typical SQL queries users will run on your database

-- To set up - let's add the game-provided data to our tables on ancestries, cultures, classes, subclasses, armor and weapons.
-- Add all possible armor values to the armors table
INSERT IGNORE INTO `armors` (`armor_name`, `feature`, `base_score`, `base_thresholds_csv`, `evasion_mod`)
    VALUES ('chainmail','Heavy: -1 to Evasion', 4, '7,15', 0);
INSERT IGNORE INTO `armors` (`armor_name`, `feature`, `base_score`, `base_thresholds_csv`, `evasion_mod`)
    VALUES ('gambeson', 'Flexible: +1 to Evasion', 3, '5,11', 1);
INSERT IGNORE INTO `armors` (`armor_name`, `feature`, `base_score`, `base_thresholds_csv`, `evasion_mod`)
    VALUES ('leather', '', 3, '6,13', -1);

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


-- Validate all game-provided data by querying each table.
SELECT * FROM `armors`;
SELECT * FROM `weapons`;
SELECT * FROM `ancestries`;
SELECT * FROM `communities`;
SELECT * FROM `classes`;
SELECT * FROM `subclasses`;

-- Now let's simualte a user creating a character!
-- Let's say a user with the email 'very_kewl_email_address@kewlmail.com' signs up and wishes to create a sorcerer named 'Frannie'
-- Let's store those values as user-defined variables to use below.

SET @user_name = 'very_kewl_email_address@kewlmail.com';
SET @char_name = 'frannie';
SELECT @char_name;

-- First we need a user

INSERT IGNORE INTO `users` (`username`)
    VALUES (
        (SELECT @user_name)
    );

-- Validate users table:
SELECT * FROM `users`;

-- Let's store the current user id as a user defined variable so we can use it to update the user/char id table when we add a character.
SET @user_id = (SELECT `id` FROM `users` WHERE `username` = (SELECT @user_name));

-- Validate user-defined var:
SELECT @user_id;


-- Now the character. For example: --
-- a user selects a Loreborne Elf as a Primal Origin Sorcerer wearing leather armor and weilding a dualstaff
-- with a name of 'Frannie' and ability scores of 0,-1,+1,+2,+1,0.


INSERT INTO `characters` (
        `name`,
        `ancestry_id`,
        `community_id`,
        `class_id`,
        `subclass_id`,
        `ability_scores_csv`,
        `armor_id`,
        `weapon_id`
    )
    VALUES (
        (SELECT @char_name),
        (SELECT `id` FROM `ancestries` WHERE `ancestry_name` = 'elf'),
        (SELECT `id` FROM `communities` WHERE `community_name` = 'loreborne'),
        (SELECT `id` FROM `classes` WHERE `class_name` = 'sorcerer'),
        (SELECT `id` FROM `subclasses` WHERE `subclass_name` = 'primal origin'),
        '0,-1,1,2,1,0',
        (SELECT `id` FROM `armors` WHERE `armor_name` = 'leather'),
        (SELECT `id` FROM `weapons` WHERE `weapon_name` = 'dualstaff')
    );

-- Validate character insert:
SELECT * FROM `characters`;

-- We'll also want to store the character id as a user-defined variable to use in subsequent queries.
-- Since the name of a character may not be unique (multiple users could have a character with the same name),
-- We'll need to reference the user id when accessing a character by name to find its id value.

-- Now we are capable of selecting a character by its name (even if mutliple users store characters with the same name)
-- because we can use our `user_char_ids` table to relate users and characters. This will only work if the user is prevented
-- from having multiple characters with identical names (need to think of a solution for that).
SET @current_char_id = (SELECT `id` FROM `characters`
    WHERE `name` = (SELECT @char_name) AND `id` IN (
        (SELECT `char_id` FROM `user_char_ids` WHERE `user_id` = (SELECT @user_id))
        )
    );

SELECT * FROM `user_char_ids` WHERE `user_id` = (SELECT @user_id);
SELECT @current_char_id;

-- Let's get a list of all characters for the current user by using our stored procedure
CALL `select_current_user_characters` ((SELECT @user_id));

-- Now let's imagine the UI is trying to display a character sheet with all of this new character's stats and features.
-- We need to access several tables to compile all the relevant data. These could be organized as a JS object to serve the UI.

-- Get the data for the character's selected armor
SELECT `armor_name`, `feature`, `base_score`, `base_thresholds_csv`, `evasion_mod` FROM `armors` WHERE `id` = (
    SELECT `armor_id` FROM `characters` WHERE `id` = (SELECT @current_char_id)
    );

-- Get the data for the character's selected weapon
SELECT `weapon_name`, `feature`, `trait`, `range`, `damage_die_qty`, `damage_die`, `damage_type` FROM `weapons` WHERE `id` = (
    SELECT `weapon_id` FROM `characters` WHERE `id` = (SELECT @current_char_id)
    );

-- Get the data for the character's selected ancestry
SELECT `community_name`, `feature`, `traits` FROM `communities` WHERE `id` = (
    SELECT `ancestry_id` FROM `characters` WHERE `id` = (SELECT @current_char_id)
);

-- Get the data for the character's selected culture
SELECT `ancestry_name`, `primary_trait`, `secondary_trait` FROM `ancestries` WHERE `id` = (
    SELECT `ancestry_id` FROM `characters` WHERE `id` = (SELECT @current_char_id)
);


-- Get the data for the character's selected class
SELECT `class_name`,
        `class_feature_1`,
        `class_feature_2`,
        `class_feature_3`,
        `class_hope_feature`,
        `domains`,
        `base_evasion`,
        `base_hit_points`,
        `primary_ability`
        FROM `classes` WHERE `id` = (
    SELECT `ancestry_id` FROM `characters` WHERE `id` = (SELECT @current_char_id)
);


-- Get the data for the character's selected subclass
SELECT `ancestry_name`, `primary_trait`, `secondary_trait` FROM `ancestries` WHERE `id` = (
    SELECT `ancestry_id` FROM `characters` WHERE `id` = (SELECT @current_char_id)
);


-- Get the data for the character's status
SELECT * FROM `character_status` WHERE `character_id` = (SELECT @current_char_id);

-- When we wish to view all character information, it may make sense to create a view that combines data from the characters
-- table with the long-form data in the supplementary tables (ancestry, culture, subclass features, etc).
-- To that end, we can create a custom view to combine that data into a single virtual table. This is likely what we would
-- serve to a UI to display the character info to a user.
CALL `create_current_char_view` ((SELECT @current_char_id));


-- Our character is ready to play! Let's say we rolled our first die roll and rolled a 6 on the fear die and a 7 on the hope die,
-- which requires us to mark one hope on our character.
-- Then let's say we used a class feature that requires us to mark a stress on our character.
-- Then we got hit by a goblin (ouch) and lost one hit point.
UPDATE `character_status` SET `hope` = `hope` + 1 WHERE `character_id` = (SELECT @current_char_id);
UPDATE `character_status` SET `stress` = `stress` + 1 WHERE `character_id` = (SELECT @current_char_id);
UPDATE `character_status` SET `hit_point_current` = `hit_point_current` - 1 WHERE `character_id` = (SELECT @current_char_id);

-- Validate our update!
SELECT * FROM `character_status` WHERE `character_id` = (SELECT @current_char_id);


-- Test archiving and deleting a character
INSERT INTO `characters` (
        `name`,
        `ancestry_id`,
        `community_id`,
        `class_id`,
        `subclass_id`,
        `ability_scores_csv`,
        `armor_id`,
        `weapon_id`
    )
    VALUES (
        'namerino',
        (SELECT `id` FROM `ancestries` WHERE `ancestry_name` = 'elf'),
        (SELECT `id` FROM `communities` WHERE `community_name` = 'loreborne'),
        (SELECT `id` FROM `classes` WHERE `class_name` = 'sorcerer'),
        (SELECT `id` FROM `subclasses` WHERE `subclass_name` = 'primal origin'),
        '0,0,0,0,0,0',
        (SELECT `id` FROM `armors` WHERE `armor_name` = 'leather'),
        (SELECT `id` FROM `weapons` WHERE `weapon_name` = 'dualstaff')
    );

SELECT * FROM `characters`;
SELECT * FROM `user_char_ids`;
SELECT * FROM `character_status`;
-- Should see two characters

UPDATE `character_status`
    SET `is_archived` = TRUE
    WHERE `character_id` = (SELECT `id` FROM `characters` WHERE `name` = 'namerino');

SELECT * FROM `character_status`;
SELECT * FROM `character_status`;
-- Should see archived character noted with value 1
CALL `select_current_user_characters`((SELECT @user_id));
SELECT * FROM `character_status`;
-- Should not see archived character in list

DELETE FROM `characters` WHERE `name` = 'namerino';

SELECT * FROM `characters`;
SELECT * FROM `user_char_ids`;
SELECT * FROM `character_status`;
-- Should see one character
