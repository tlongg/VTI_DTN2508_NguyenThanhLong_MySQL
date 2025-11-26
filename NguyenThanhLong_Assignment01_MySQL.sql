CREATE DATABASE testing_system;
USE testing_system;

CREATE TABLE department (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE position (
    position_id INT AUTO_INCREMENT PRIMARY KEY,
    position_name ENUM('Dev', 'Test', 'ScrumMaster', 'PM') NOT NULL
);

CREATE TABLE account (
    account_id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(100) NOT NULL UNIQUE,
    username VARCHAR(50) NOT NULL UNIQUE,
    full_name VARCHAR(100),
    department_id INT,
    position_id INT,
    create_date DATETIME DEFAULT NOW(),

    FOREIGN KEY (department_id) REFERENCES department(department_id),
    FOREIGN KEY (position_id) REFERENCES `position`(position_id)
);

CREATE TABLE `group` (
    group_id INT AUTO_INCREMENT PRIMARY KEY,
    group_name VARCHAR(100) NOT NULL UNIQUE,
    creator_id INT,
    create_date DATETIME DEFAULT NOW(),
    FOREIGN KEY (creator_id)
        REFERENCES account (account_id)
);

CREATE TABLE group_account (
    group_id INT,
    account_id INT,
    join_date DATETIME DEFAULT NOW(),
    PRIMARY KEY (group_id , account_id),
    FOREIGN KEY (group_id)
        REFERENCES `group` (group_id),
    FOREIGN KEY (account_id)
        REFERENCES account (account_id)
);

CREATE TABLE type_question (
    type_id INT AUTO_INCREMENT PRIMARY KEY,
    type_name ENUM('Essay', 'Multiple-Choice') NOT NULL
);

CREATE TABLE category_question (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE question (
    question_id INT AUTO_INCREMENT PRIMARY KEY,
    content TEXT NOT NULL,
    category_id INT,
    type_id INT,
    creator_id INT,
    create_date DATETIME DEFAULT NOW(),
    FOREIGN KEY (category_id)
        REFERENCES category_question (category_id),
    FOREIGN KEY (type_id)
        REFERENCES type_question (type_id),
    FOREIGN KEY (creator_id)
        REFERENCES account (account_id)
);

CREATE TABLE answer (
    answer_id INT NOT NULL AUTO_INCREMENT,
    content TEXT NOT NULL,
    question_id INT NOT NULL,
    is_correct BOOLEAN NOT NULL,
    PRIMARY KEY (answer_id),
    FOREIGN KEY (question_id)
        REFERENCES question (question_id)
);

CREATE TABLE exam (
    exam_id INT NOT NULL AUTO_INCREMENT,
    code VARCHAR(50) UNIQUE NOT NULL,
    title VARCHAR(255) NOT NULL,
    category_id INT,
    duration INT COMMENT 'Duration in minutes',
    creator_id INT,
    create_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (exam_id)
);

CREATE TABLE exam_question (
    exam_id INT NOT NULL,
    question_id INT NOT NULL,
    PRIMARY KEY (exam_id , question_id),
    FOREIGN KEY (exam_id)
        REFERENCES exam (exam_id),
    FOREIGN KEY (question_id)
        REFERENCES question (question_id)
);
