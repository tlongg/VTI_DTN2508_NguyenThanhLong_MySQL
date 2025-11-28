CREATE DATABASE IF NOT EXISTS testing_system;
USE testing_system;

DROP TABLE IF EXISTS exam_question, exam, answer, question, category_question, type_question,
                     group_account, `group`, account, position, department;

CREATE TABLE department (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE position (
    position_id INT AUTO_INCREMENT PRIMARY KEY,
    position_name ENUM('Dev', 'Test', 'ScrumMaster', 'PM') NOT NULL UNIQUE
);

CREATE TABLE account (
    account_id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(100) NOT NULL UNIQUE,
    username VARCHAR(50) NOT NULL UNIQUE,
    full_name VARCHAR(100) NOT NULL,
    department_id INT NOT NULL,
    position_id INT NOT NULL,
    create_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (department_id)
        REFERENCES department (department_id),
    FOREIGN KEY (position_id)
        REFERENCES `position` (position_id)
);

CREATE TABLE `group` (
    group_id INT AUTO_INCREMENT PRIMARY KEY,
    group_name VARCHAR(100) NOT NULL UNIQUE,
    creator_id INT NOT NULL,
    create_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (creator_id)
        REFERENCES account (account_id)
);

CREATE TABLE group_account (
    group_id INT NOT NULL,
    account_id INT NOT NULL,
    join_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (group_id , account_id),
    FOREIGN KEY (group_id)
        REFERENCES `group` (group_id)
        ON DELETE CASCADE,
    FOREIGN KEY (account_id)
        REFERENCES account (account_id)
        ON DELETE CASCADE
);

CREATE TABLE type_question (
    type_id INT AUTO_INCREMENT PRIMARY KEY,
    type_name ENUM('Essay', 'Multiple-Choice') NOT NULL UNIQUE
);

CREATE TABLE category_question (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE question (
    question_id INT AUTO_INCREMENT PRIMARY KEY,
    content TEXT NOT NULL,
    category_id INT NOT NULL,
    type_id INT NOT NULL,
    creator_id INT NOT NULL,
    create_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id)
        REFERENCES category_question (category_id),
    FOREIGN KEY (type_id)
        REFERENCES type_question (type_id),
    FOREIGN KEY (creator_id)
        REFERENCES account (account_id)
);

CREATE TABLE answer (
    answer_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    content TEXT NOT NULL,
    question_id INT NOT NULL,
    is_correct BOOLEAN NOT NULL,
    FOREIGN KEY (question_id)
        REFERENCES question (question_id)
        ON DELETE CASCADE
);

CREATE TABLE exam (
    exam_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(50) UNIQUE NOT NULL,
    title VARCHAR(255) NOT NULL,
    category_id INT NOT NULL,
    duration INT NOT NULL CHECK (duration >= 5),
    creator_id INT NOT NULL,
    create_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id)
        REFERENCES category_question (category_id),
    FOREIGN KEY (creator_id)
        REFERENCES account (account_id)
);

CREATE TABLE exam_question (
    exam_id INT NOT NULL,
    question_id INT NOT NULL,
    PRIMARY KEY (exam_id , question_id),
    FOREIGN KEY (exam_id)
        REFERENCES exam (exam_id)
        ON DELETE CASCADE,
    FOREIGN KEY (question_id)
        REFERENCES question (question_id)
        ON DELETE CASCADE
);


INSERT INTO department (department_id, department_name)
VALUES
    (1, 'Marketing'),
    (2, 'Sale'),
    (3, 'Bảo vệ'),
    (4, 'Nhân sự'),
    (5, 'Kỹ thuật'),
    (6, 'Tài chính'),
    (7, 'Phó giám đốc'),
    (8, 'Giám đốc'),
    (9, 'Thư kí'),
    (10, 'Bán hàng');

INSERT INTO position (position_id, position_name)
VALUES
    (1, 'Dev'),
    (2, 'Test'),
    (3, 'ScrumMaster'),
    (4, 'PM');

INSERT INTO account (account_id, email, username, full_name, department_id, position_id, create_date)
VALUES
    (1, 'nguyenvana@gmail.com', 'nguyenvana', 'Nguyễn Văn A', 1, 1, '2023-10-01'),
    (2, 'tranthib@gmail.com', 'tranthib', 'Trần Thị B', 5, 2, '2023-10-05'),
    (3, 'lethic@gmail.com', 'lethic', 'Lê Thị C', 4, 3, '2023-11-10'),
    (4, 'phamd@gmail.com', 'phamd', 'Phạm Văn D', 8, 4, '2023-09-15'),
    (5, 'hoange@gmail.com', 'hoange', 'Hoàng Thị E', 5, 1, '2023-12-01'),
    (6, 'dao_f@gmail.com', 'daof', 'Đào Văn F', 2, 2, '2023-12-05');

INSERT INTO `group` (group_id, group_name, creator_id, create_date)
VALUES
    (1, 'Nhóm Dev 1', 1, '2024-01-10'),
    (2, 'Nhóm Tester A', 2, '2024-01-15'),
    (3, 'Dự án X-Force', 4, '2024-02-01'),
    (4, 'Nhóm Marketing Mới', 1, '2024-02-20'),
    (5, 'Hội đồng quản trị', 4, '2023-08-01');

INSERT INTO group_account (group_id, account_id, join_date)
VALUES
    (1, 1, '2024-01-10'),
    (1, 5, '2024-01-12'),
    (2, 2, '2024-01-15'),
    (3, 4, '2024-02-01'),
    (4, 6, '2024-02-20'),
    (5, 4, '2023-08-01');

INSERT INTO type_question (type_id, type_name)
VALUES
    (1, 'Essay'),
    (2, 'Multiple-Choice');

INSERT INTO category_question (category_id, category_name)
VALUES
    (1, 'Java'),
    (2, 'SQL'),
    (3, 'Docker'),
    (4, 'DevOps'),
    (5, 'Testing'),
    (6, 'Marketing Digital');

INSERT INTO question (question_id, content, category_id, type_id, creator_id, create_date)
VALUES
    (1, 'Giải thích khái niệm Polymorphism trong Java.', 1, 1, 1, '2024-03-01'),
    (2, 'Tác dụng của GROUP BY trong SQL là gì?', 2, 1, 2, '2024-03-05'),
    (3, 'SELECT * FROM Account WHERE DepartmentID = 5 là đúng hay sai?', 2, 2, 2, '2024-03-06'),
    (4, 'Công dụng chính của Docker là gì?', 3, 2, 5, '2024-03-10'),
    (5, 'Kiểm thử hộp đen (Black Box Testing) là gì?', 5, 1, 2, '2024-03-15');

INSERT INTO answer (answer_id, content, question_id, is_correct)
VALUES
    (1, 'Đa hình là khả năng một interface có nhiều dạng.', 1, 1),
    (2, 'Lệnh dùng để sắp xếp kết quả truy vấn.', 2, 0),
    (3, 'Lệnh dùng để nhóm các hàng có cùng giá trị thành một hàng tóm tắt.', 2, 1),
    (4, 'Đúng.', 3, 1),
    (5, 'Sai.', 3, 0),
    (6, 'Dùng để tạo máy ảo (VM).', 4, 0),
    (7, 'Dùng để đóng gói và cô lập các ứng dụng.', 4, 1);

INSERT INTO exam (exam_id, code, title, category_id, duration, creator_id, create_date)
VALUES
    (1, 'JAVA01', 'Kiểm tra giữa kì Java', 1, 60, 1, '2024-04-01'),
    (2, 'SQL05', 'Đề thi SQL cơ bản', 2, 45, 2, '2024-04-05'),
    (3, 'DOCKER02', 'Đề thi Docker nâng cao', 3, 90, 5, '2024-04-10'),
    (4, 'TEST03', 'Kiểm tra tổng quan Testing', 5, 60, 2, '2024-04-15'),
    (5, 'MKD01', 'Marketing căn bản', 6, 30, 6, '2024-04-20');

INSERT INTO exam_question (exam_id, question_id)
VALUES
    (1, 1),
    (2, 2),
    (2, 3),
    (3, 4),
    (4, 5),
    (5, 5),
    (1, 5);
