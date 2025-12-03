# Pre condition: set up database and tables from previous assignments
CREATE DATABASE IF NOT EXISTS testing_system;
USE testing_system;
SET SQL_SAFE_UPDATES = 0;

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

# Question 1: Thêm ít nhất 10 record vào mỗi table
INSERT INTO department (department_name)
VALUES
('Dev'),
('Test'),
('HR'),
('Sale'),
('Marketing'),
('Finance'),
('Security'),
('Support'),
('Data'),
('QA');

INSERT INTO position (position_name)
VALUES 
('Dev'),
('Test'),
('ScrumMaster'),
('PM');

INSERT INTO account (email, username, full_name, department_id, position_id, create_date)
VALUES
('acc1@mail.com', 'user1', 'Nguyen Van A', 1, 1, '2019-12-01'),
('acc2@mail.com', 'user2', 'Tran Thi B', 2, 2, '2019-12-05'),
('acc3@mail.com', 'user3', 'Le Thi Minh Ngoc Phuong Thanh', 3, 3, '2019-12-10'),
('acc4@mail.com', 'user4', 'Pham Thi Hoang My Duyen', 3, 4, '2019-11-20'),
('acc5@mail.com', 'user5', 'Hoang Van E', 5, 1, '2019-12-15'),
('acc6@mail.com', 'user6', 'Vu Thi F', 6, 2, '2019-12-25'),
('acc7@mail.com', 'user7', 'Bui Tran Thanh Hung Quoc Bao', 3, 3, '2019-10-10'),
('acc8@mail.com', 'user8', 'Do Thi H', 8, 4, '2019-12-18'),
('acc9@mail.com', 'user9', 'Pham Nguyen Hong Quyen', 3, 1, '2019-09-05'),
('acc10@mail.com','user10','Tran Hai K', 10, 2, '2020-01-01'),
('acc11@mail.com','user11','Dinh Hai O', 10, 2, '2020-01-01');

INSERT INTO `group` (group_name, creator_id, create_date)
VALUES
('Group 1', 1, '2019-12-01'),
('Group 2', 2, '2019-11-20'),
('Group 3', 3, '2019-12-10'),
('Group 4', 4, '2019-10-05'),
('Group 5', 5, '2019-12-18'),
('Group 6', 6, '2020-01-01'),
('Group 7', 7, '2020-02-01'),
('Group 8', 8, '2019-12-15'),
('Group 9', 9, '2019-09-10'),
('Group 10',10, '2019-08-25');

INSERT INTO group_account (group_id, account_id, join_date)
VALUES
(1,1,'2019-12-01'),
(2,2,'2019-12-02'),
(3,3,'2019-12-03'),
(4,4,'2019-12-04'),
(5,5,'2019-12-05'),
(6,6,'2019-12-06'),
(7,7,'2019-12-07'),
(8,8,'2019-12-08'),
(9,9,'2019-12-09'),
(10,10,'2019-12-10'),
(10,1,'2020-12-20'),
(10,3,'2020-12-20'),
(10,4,'2020-12-20');

INSERT INTO type_question (type_name)
VALUES ('Essay'), ('Multiple-Choice');

INSERT INTO category_question (category_name)
VALUES
('Java'),
('SQL'),
('Testing'),
('Security'),
('OOP'),
('Network'),
('Web'),
('Data'),
('DevOps'),
('Agile');

INSERT INTO question (content, category_id, type_id, creator_id, create_date)
VALUES
('Câu hỏi 1',1,1,1,'2019-12-01'),
('Câu hỏi 2',2,2,2,'2019-12-05'),
('Câu hỏi 3',3,1,3,'2019-12-10'),
('Câu hỏi 4',4,2,4,'2019-11-20'),
('Câu hỏi 5',5,1,5,'2019-10-15'),
('Câu hỏi 6',6,2,6,'2019-12-25'),
('Câu hỏi 7',7,1,7,'2019-09-15'),
('Câu hỏi 8',8,2,8,'2020-01-01'),
('Câu hỏi 9',9,1,9,'2019-08-10'),
('Câu hỏi 10',10,2,10,'2019-12-18'),
('Not a Câu hỏi 10',10,2,10,'2019-12-18');

INSERT INTO answer (content, question_id, is_correct)
VALUES
('Answer 1',1,1),
('Answer 2',2,0),
('Answer 3',3,1),
('Answer 4',4,0),
('Answer 5',5,1),
('Answer 6',6,0),
('Answer 7',7,1),
('Answer 8',8,0),
('Answer 9',9,1),
('Answer 10',10,0),
('Answer 11',11,0),
('Answer 12',11,0),
('Answer 13',11,0),
('Answer 10',11,0);

INSERT INTO exam (code, title, category_id, duration, creator_id, create_date)
VALUES
('EX001','Exam 1',1,30,1,'2019-12-01'),
('EX002','Exam 2',2,45,2,'2019-12-05'),
('EX003','Exam 3',3,60,3,'2019-11-20'),
('EX004','Exam 4',4,90,4,'2019-12-10'),
('EX005','Exam 5',5,120,5,'2019-12-15'),
('EX006','Exam 6',6,75,6,'2019-10-01'),
('EX007','Exam 7',7,35,7,'2019-09-05'),
('EX008','Exam 8',8,50,8,'2020-01-01'),
('EX009','Exam 9',9,80,9,'2019-08-20'),
('EX010','Exam 10',10,100,10,'2019-12-2'),
('EX011','Exam 11',10,100,10,'2020-12-22'),
('EX012','Exam 12',10,100,10,'2020-12-2');

INSERT INTO exam_question (exam_id, question_id)
VALUES
(1,1),
(2,2),
(3,3),
(4,4),
(5,5),
(6,6),
(7,7),
(8,8),
(9,9),
(10,10);
    
# Question 2: lấy ra tất cả các phòng ban
SELECT 
    *
FROM
    department;

# Question 3: lấy ra id của phòng ban "Sale"
SELECT 
    department_id
FROM
    department
WHERE
    department_name = 'Sale';

# Question 4: lấy ra thông tin account có full name dài nhất
SELECT 
    *, CHAR_LENGTH(full_name)
FROM
    account
WHERE
    CHAR_LENGTH(full_name) = (SELECT 
            MAX(CHAR_LENGTH(full_name))
        FROM
            account);

# Question 5: Lấy ra thông tin account có full name dài nhất và thuộc phòng ban có id= 3
SELECT 
    *, CHAR_LENGTH(full_name)
FROM
    account
WHERE
    CHAR_LENGTH(full_name) = (SELECT 
            MAX(CHAR_LENGTH(full_name))
        FROM
            account
        WHERE
            department_id = 3); 
            
# Question 6: Lấy ra tên group đã tham gia trước ngày 20/12/2019
SELECT DISTINCT
    g.group_name, ga.join_date, ga.account_id
FROM
    `group` g
        JOIN
    group_account ga ON g.group_id = ga.group_id
WHERE
    ga.join_date < '2019-12-20';

# Question 7: Lấy ra ID của question có >= 4 câu trả lời
SELECT 
    question_id
FROM
    answer
GROUP BY question_id
HAVING COUNT(*) >= 4;

# Question 8: Lấy ra các mã đề thi có thời gian thi >= 60 phút và được tạo trước ngày 20/12/2019
SELECT 
    *
FROM
    exam
WHERE
    duration >= 60
        AND create_date < '2019-12-20';

# Question 9: Lấy ra 5 group được tạo gần đây nhất
SELECT 
    *
FROM
    `group`
ORDER BY create_date DESC
LIMIT 5;

# Question 10: Đếm số nhân viên thuộc department có id = 2
SELECT 
    COUNT(*) AS total_staff
FROM
    account
WHERE
    department_id = 32;

# Question 11: Lấy ra nhân viên có tên bắt đầu bằng chữ "D" và kết thúc bằng chữ "o"
SELECT 
    *
FROM
    account
WHERE
    full_name LIKE 'D%o';

# Question 12: Xóa tất cả các exam được tạo trước ngày 20/12/2019
DELETE FROM exam 
WHERE
    create_date < '2019-12-20';

# Question 13: Xóa tất cả các question có nội dung bắt đầu bằng từ "câu hỏi"
DELETE FROM question 
WHERE
    content LIKE 'Câu hỏi%';

# Question 14: Update thông tin của account có id = 5 thành tên "Nguyễn Bá Lộc" và email thành loc.nguyenba@vti.com.vn
UPDATE account
SET full_name = 'Nguyễn Bá Lộc',
    email = 'loc.nguyenba@vti.com.vn'
WHERE account_id = 5;

# Question 15: update account có id = 5 sẽ thuộc group có id = 4
UPDATE group_account 
SET 
    group_id = 4
WHERE
    account_id = 5;
