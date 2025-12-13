--  Question 1: Tạo trigger không cho phép người dùng nhập vào Group có ngày tạo trước 1 năm trước
DELIMITER $$
CREATE TRIGGER trg_group_before_insert_no_old_date
BEFORE INSERT ON `group`
FOR EACH ROW
BEGIN
    IF NEW.create_date < DATE_SUB(CURDATE(), INTERVAL 1 YEAR) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Group create_date cannot be older than 1 year';
    END IF;
END$$
DELIMITER ;

INSERT INTO `group` (group_name, creator_id, create_date)
VALUES ('Old Group', 1, DATE_SUB(CURDATE(), INTERVAL 2 YEAR));

-- Question 2: Tạo trigger Không cho phép người dùng thêm bất kỳ user nào vào
-- department "Sale" nữa, khi thêm thì hiện ra thông báo "Department
-- "Sale" cannot add more user"
DELIMITER $$
CREATE TRIGGER trg_account_before_insert_no_sale
BEFORE INSERT ON account
FOR EACH ROW
BEGIN
    IF NEW.department_id = (
        SELECT department_id
        FROM department
        WHERE department_name = 'Sale'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Department "Sale" cannot add more user';
    END IF;
END$$
DELIMITER ;

INSERT INTO account (email, username, full_name, department_id, position_id)
VALUES (
    'sale_test@mail.com',
    'sale_test',
    'Sale User Test',
    (SELECT department_id FROM department WHERE department_name = 'Sale'),
    1
);

-- Question 3: Cấu hình 1 group có nhiều nhất là 5 user
DELIMITER $$
CREATE TRIGGER trg_group_account_before_insert_limit5
BEFORE INSERT ON group_account
FOR EACH ROW
BEGIN
    IF (SELECT COUNT(*) FROM group_account WHERE group_id = NEW.group_id) >= 5 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'A group can have at most 5 users';
    END IF;
END$$
DELIMITER ;

-- Question 4: Cấu hình 1 bài thi có nhiều nhất là 10 Question
DELIMITER $$
CREATE TRIGGER trg_exam_question_before_insert_limit10
BEFORE INSERT ON exam_question
FOR EACH ROW
BEGIN
    IF (SELECT COUNT(*) FROM exam_question WHERE exam_id = NEW.exam_id) >= 2 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'An exam can have at most 10 questions';
    END IF;
END$$
DELIMITER ;

INSERT INTO exam_question (exam_id, question_id)
VALUES (10, 12);

-- Question 5: Tạo trigger không cho phép người dùng xóa tài khoản có email là
-- admin@gmail.com (đây là tài khoản admin, không cho phép user xóa),
-- còn lại các tài khoản khác thì sẽ cho phép xóa và sẽ xóa tất cả các thông
-- tin liên quan tới user đó
DELIMITER $$
CREATE TRIGGER trg_account_before_delete_admin
BEFORE DELETE ON account
FOR EACH ROW
BEGIN
    IF OLD.email = 'admin@gmail.com' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Admin account cannot be deleted';
    END IF;

    DELETE FROM `group` WHERE creator_id = OLD.account_id;
    DELETE FROM group_account WHERE account_id = OLD.account_id;
    DELETE FROM exam WHERE creator_id = OLD.account_id;
    DELETE FROM question WHERE creator_id = OLD.account_id;
END$$
DELIMITER ;

DELETE FROM account
WHERE email = 'admin@gmail.com';

-- Question 6: Không sử dụng cấu hình default cho field DepartmentID của table
-- Account, hãy tạo trigger cho phép người dùng khi tạo account không điền
-- vào departmentID thì sẽ được phân vào phòng ban "waiting Department"
DELIMITER $$
CREATE TRIGGER trg_account_before_insert_waiting
BEFORE INSERT ON account
FOR EACH ROW
BEGIN
    IF NEW.department_id IS NULL THEN
        SET NEW.department_id = (
            SELECT department_id
            FROM department
            WHERE department_name = 'waiting Department'
            LIMIT 1
        );
    END IF;
END$$
DELIMITER ;

INSERT INTO account (email, username, full_name, position_id)
VALUES ('waiting1@mail.com', 'waiting_user1', 'Waiting User', 1);

-- Question 7: Cấu hình 1 bài thi chỉ cho phép user tạo tối đa 4 answers cho mỗi
-- question, trong đó có tối đa 2 đáp án đúng.
DELIMITER $$
CREATE TRIGGER trg_answer_before_insert_limit
BEFORE INSERT ON answer
FOR EACH ROW
BEGIN
    IF (SELECT COUNT(*) FROM answer WHERE question_id = NEW.question_id) >= 4 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Max 4 answers allowed';
    END IF;

    IF NEW.is_correct = 1 AND
       (SELECT COUNT(*) FROM answer WHERE question_id = NEW.question_id AND is_correct = 1) >= 2 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Max 2 correct answers allowed';
    END IF;
END$$
DELIMITER ;

INSERT INTO answer (content, question_id, is_correct)
VALUES ('Extra Answer', 11, 0);

INSERT INTO answer (content, question_id, is_correct)
VALUES ('Extra Correct', 11, 1);

-- Question 8: Viết trigger sửa lại dữ liệu cho đúng:
-- Nếu người dùng nhập vào gender của account là nam, nữ, chưa xác định
-- Thì sẽ đổi lại thành M, F, U cho giống với cấu hình ở database
DELIMITER $$
CREATE TRIGGER trg_account_before_insert_gender
BEFORE INSERT ON account
FOR EACH ROW
BEGIN
    SET NEW.gender =
        CASE LOWER(NEW.gender)
            WHEN 'nam' THEN 'M'
            WHEN 'nữ' THEN 'F'
            WHEN 'nu' THEN 'F'
            WHEN 'chưa xác định' THEN 'U'
            WHEN 'unknown' THEN 'U'
            ELSE NEW.gender
        END;
END$$
DELIMITER ;

INSERT INTO account (email, username, full_name, department_id, position_id, gender)
VALUES ('gender@mail.com', 'gender_user', 'Gender Test', 1, 1, 'nam');

-- Question 9: Viết trigger không cho phép người dùng xóa bài thi mới tạo được 2 ngày
DELIMITER $$
CREATE TRIGGER trg_exam_before_delete_no_recent
BEFORE DELETE ON exam
FOR EACH ROW
BEGIN
    IF OLD.create_date >= DATE_SUB(NOW(), INTERVAL 2 DAY) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot delete exam created within last 2 days';
    END IF;
END$$
DELIMITER ;

-- Question 10: Viết trigger chỉ cho phép người dùng chỉ được update, delete các
-- question khi question đó chưa nằm trong exam nào
DELIMITER $$
CREATE TRIGGER trg_question_before_update_no_exam
BEFORE UPDATE ON question
FOR EACH ROW
BEGIN
    IF (SELECT COUNT(*) FROM exam_question WHERE question_id = OLD.question_id) > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot update question already in exam';
    END IF;
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER trg_question_before_delete_no_exam
BEFORE DELETE ON question
FOR EACH ROW
BEGIN
    IF (SELECT COUNT(*) FROM exam_question WHERE question_id = OLD.question_id) > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot delete question already in exam';
    END IF;
END$$
DELIMITER ;

-- Question 12: Lấy ra thông tin exam trong đó:
-- Duration <= 30 thì sẽ đổi thành giá trị "Short time"
-- 30 < Duration <= 60 thì sẽ đổi thành giá trị "Medium time"
-- Duration > 60 thì sẽ đổi thành giá trị "Long time"
SELECT
    exam_id,
    code,
    title,
    duration,
    CASE
        WHEN duration <= 30 THEN 'Short time'
        WHEN duration <= 60 THEN 'Medium time'
        ELSE 'Long time'
    END AS duration_type
FROM exam;

-- Question 13: Thống kê số account trong mỗi group và in ra thêm 1 column nữa có tên
-- là the_number_user_amount và mang giá trị được quy định như sau:
-- Nếu số lượng user trong group =< 5 thì sẽ có giá trị là few
-- Nếu số lượng user trong group <= 20 và > 5 thì sẽ có giá trị là normal
-- Nếu số lượng user trong group > 20 thì sẽ có giá trị là higher
SELECT
    g.group_id,
    g.group_name,
    COUNT(ga.account_id) AS total_users,
    CASE
        WHEN COUNT(ga.account_id) <= 5 THEN 'few'
        WHEN COUNT(ga.account_id) <= 20 THEN 'normal'
        ELSE 'higher'
    END AS the_number_user_amount
FROM `group` g
LEFT JOIN group_account ga ON g.group_id = ga.group_id
GROUP BY g.group_id, g.group_name;

-- Question 14: Thống kê số mỗi phòng ban có bao nhiêu user, nếu phòng ban nào
-- không có user thì sẽ thay đổi giá trị 0 thành "Không có User"
SELECT
    d.department_id,
    d.department_name,
    CASE
        WHEN COUNT(a.account_id) = 0 THEN 'Không có User'
        ELSE COUNT(a.account_id)
    END AS user_count
FROM department d
LEFT JOIN account a ON d.department_id = a.department_id
GROUP BY d.department_id, d.department_name;