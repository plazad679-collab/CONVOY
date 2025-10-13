-- Hogwarts RP Schema v1
CREATE TABLE IF NOT EXISTS hogwarts_players (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nanos_id VARCHAR(64) NOT NULL,
    last_character_id BIGINT UNSIGNED NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY idx_nanos_id (nanos_id)
);

CREATE TABLE IF NOT EXISTS hogwarts_characters (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    player_id BIGINT UNSIGNED NOT NULL,
    first_name VARCHAR(64) NOT NULL,
    last_name VARCHAR(64) NOT NULL,
    house VARCHAR(32) NOT NULL,
    year TINYINT UNSIGNED NOT NULL DEFAULT 1,
    blood_status ENUM('muggleborn', 'half_blood', 'pure_blood') NOT NULL DEFAULT 'half_blood',
    wand_wood VARCHAR(64) NOT NULL,
    wand_core VARCHAR(64) NOT NULL,
    wand_length DECIMAL(4,2) NOT NULL DEFAULT 10.0,
    patronus VARCHAR(64) NULL,
    inventory JSON NOT NULL,
    currency_galeons INT NOT NULL DEFAULT 0,
    currency_sickles INT NOT NULL DEFAULT 0,
    currency_knuts INT NOT NULL DEFAULT 0,
    reputation JSON NOT NULL,
    schedule JSON NOT NULL,
    stats JSON NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (player_id) REFERENCES hogwarts_players(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS hogwarts_spells (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    character_id BIGINT UNSIGNED NOT NULL,
    spell_id VARCHAR(64) NOT NULL,
    proficiency ENUM('novice', 'adept', 'master') NOT NULL DEFAULT 'novice',
    experience INT NOT NULL DEFAULT 0,
    cooldown FLOAT NOT NULL DEFAULT 0,
    last_cast_at TIMESTAMP NULL,
    FOREIGN KEY (character_id) REFERENCES hogwarts_characters(id) ON DELETE CASCADE,
    INDEX idx_character_spell (character_id, spell_id)
);

CREATE TABLE IF NOT EXISTS hogwarts_classes (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    class_id VARCHAR(64) NOT NULL,
    day_of_week TINYINT UNSIGNED NOT NULL,
    starts_at TIME NOT NULL,
    ends_at TIME NOT NULL,
    location VARCHAR(128) NOT NULL,
    professor VARCHAR(128) NOT NULL,
    max_students SMALLINT UNSIGNED NOT NULL DEFAULT 20,
    UNIQUE KEY idx_class_schedule (class_id, day_of_week, starts_at)
);

CREATE TABLE IF NOT EXISTS hogwarts_attendance (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    class_instance_id BIGINT UNSIGNED NOT NULL,
    character_id BIGINT UNSIGNED NOT NULL,
    attendance_date DATE NOT NULL,
    status ENUM('present', 'late', 'absent') NOT NULL DEFAULT 'present',
    FOREIGN KEY (character_id) REFERENCES hogwarts_characters(id) ON DELETE CASCADE,
    UNIQUE KEY idx_attendance (class_instance_id, character_id, attendance_date)
);

CREATE TABLE IF NOT EXISTS hogwarts_journal_entries (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    character_id BIGINT UNSIGNED NOT NULL,
    title VARCHAR(128) NOT NULL,
    entry TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (character_id) REFERENCES hogwarts_characters(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS hogwarts_mail (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    recipient_id BIGINT UNSIGNED NOT NULL,
    sender_name VARCHAR(128) NOT NULL,
    subject VARCHAR(128) NOT NULL,
    body TEXT NOT NULL,
    delivered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    read_at TIMESTAMP NULL,
    FOREIGN KEY (recipient_id) REFERENCES hogwarts_characters(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS hogwarts_lore_houses (
    id VARCHAR(32) PRIMARY KEY,
    founder VARCHAR(128) NOT NULL,
    ghost VARCHAR(128) NOT NULL,
    relic VARCHAR(128) NOT NULL,
    colors JSON NOT NULL,
    traits JSON NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS hogwarts_lore_spells (
    id VARCHAR(64) PRIMARY KEY,
    name VARCHAR(128) NOT NULL,
    incantation VARCHAR(128) NOT NULL,
    difficulty VARCHAR(32) NOT NULL,
    min_year TINYINT UNSIGNED NOT NULL,
    cooldown FLOAT NOT NULL,
    description TEXT NOT NULL,
    tags JSON NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
