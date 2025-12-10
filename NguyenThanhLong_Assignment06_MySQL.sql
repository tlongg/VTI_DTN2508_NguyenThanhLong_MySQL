DELIMITER $$

-- Question 1: Tạo store để người dùng nhập vào tên phòng ban và in ra tất cả các account thuộc phòng ban đó.
CREATE PROCEDURE sp_get_accounts_by_department (
    IN p_department_name VARCHAR(100)
)
BEGIN
    SELECT a.*, d.department_name
    FROM account a
    JOIN department d ON a.department_id = d.department_id
    WHERE d.department_name = p_department_name;
END$$

call testing_system.sp_get_accounts_by_department('Test')$$

-- Question 2: Tạo store để in ra số lượng account trong mỗi group.
CREATE PROCEDURE sp_get_number_of_accounts_by_group ()
BEGIN
    SELECT g.group_id, g.group_name, COUNT(ga.account_id) AS member_count
    FROM `group` g
    LEFT JOIN group_account ga ON g.group_id = ga.group_id
    GROUP BY g.group_id, g.group_name
    ORDER BY member_count DESC;
END$$

call testing_system.sp_get_number_of_accounts_by_group()$$

-- Question 3: Tạo store để thống kê mỗi type question có bao nhiêu question được tạo trong tháng hiện tại.
CREATE PROCEDURE sp_count_questions_by_type_current_month()
BEGIN
    SELECT t.type_id, t.type_name, COUNT(q.question_id) AS total_this_month
    FROM type_question t
    LEFT JOIN question q ON t.type_id = q.type_id
        AND YEAR(q.create_date) = YEAR(CURDATE())
        AND MONTH(q.create_date) = MONTH(CURDATE())
    GROUP BY t.type_id, t.type_name;
END$$

call testing_system.sp_count_questions_by_type_current_month()$$

-- Question 4: Tạo store để trả ra id của type question có nhiều câu hỏi nhất.
CREATE PROCEDURE sp_get_type_id_most_questions()
BEGIN
    SELECT 
    type_id, COUNT(question_id) AS counted_question
FROM
    question
GROUP BY type_id
HAVING counted_question = (SELECT 
        MAX(counted_question) AS max_counted_questions
    FROM
        (SELECT 
            COUNT(question_id) AS counted_question
        FROM
            question
        GROUP BY type_id) AS count_question_table);
END$$
call testing_system.sp_get_type_id_most_questions()$$

-- Question 5: Sử dụng store ở question 4 để tìm ra tên của type question.
CREATE PROCEDURE sp_get_type_name_most_questions()
BEGIN
    SELECT 
    q.type_id, COUNT(question_id) AS counted_question, tq.type_name
FROM
    question AS q
        JOIN
    type_question AS tq ON q.type_id = tq.type_id
GROUP BY type_id
HAVING counted_question = (SELECT 
        MAX(counted_question) AS max_counted_questions
    FROM
        (SELECT 
            COUNT(question_id) AS counted_question
        FROM
            question
        GROUP BY type_id) AS count_question_table);
END$$
call testing_system.sp_get_type_name_most_questions()$$

-- Question 6: Viết 1 store cho phép người dùng nhập vào 1 chuỗi và trả về group có tên chứa chuỗi của người dùng nhập vào hoặc trả về user có username chứa chuỗi của người dùng nhập vào.
# Not done

-- Question 7: Viết 1 store cho phép người dùng nhập vào thông tin fullName, email và trong store sẽ tự động gán:
-- username sẽ giống email nhưng bỏ phần @..mail đi
-- positionID: sẽ có default là developer
-- departmentID: sẽ được cho vào 1 phòng chờ
-- Sau đó in ra kết quả tạo thành công
INSERT INTO `testing_system`.`department` (`department_id`, `department_name`) VALUES ('Waiting room');

CREATE PROCEDURE sp_create_account_with_defaults (
    IN p_full_name VARCHAR(100),
    IN p_email VARCHAR(100)
)
BEGIN
    DECLARE v_username VARCHAR(100);
    DECLARE v_position_id INT;
    DECLARE v_department_id INT;

    SET v_username = SUBSTRING_INDEX(p_email, '@', 1);

    SELECT position_id INTO v_position_id FROM `position` WHERE position_name = 'Dev';

    SELECT department_id INTO v_department_id FROM department WHERE department_name = 'Waiting room';

    INSERT INTO account (email, username, full_name, department_id, position_id)
    VALUES (p_email, v_username, p_full_name, v_department_id, v_position_id);

    SELECT 'SUCCESS' AS status, p_email AS email, v_username AS username, p_full_name AS full_name, v_department_id AS department_id, v_position_id AS position_id;
END$$
call testing_system.sp_create_account_with_defaults ("name", "name@test.com")$$

-- Question 8: Viết 1 store cho phép người dùng nhập vào Essay hoặc Multiple-Choice để thống kê câu hỏi essay hoặc multiple-choice nào có content dài nhất
CREATE PROCEDURE sp_longest_question_by_type (
    IN p_type_name ENUM('Essay','Multiple-Choice')
)
BEGIN
  SELECT 
    q.question_id,
    q.content,
    CHAR_LENGTH(q.content) AS length_chars,
    tq.type_name
FROM
    question q
        JOIN
    type_question tq ON q.type_id = tq.type_id
WHERE
    tq.type_name = 'Essay'
        AND CHAR_LENGTH(q.content) = (SELECT 
            MAX(max_content_length)
        FROM
            (SELECT 
                CHAR_LENGTH(q.content) AS max_content_length
            FROM
                question q) AS content_length_table);
END$$
call testing_system.sp_longest_question_by_type ("Essay")$$

-- Question 9: Viết 1 store cho phép người dùng xóa exam dựa vào ID
CREATE PROCEDURE sp_delete_exam_by_id (
    IN p_exam_id INT
)
BEGIN
    DELETE FROM exam WHERE exam_id = p_exam_id;

    SELECT "SUCCESS" AS result ,p_exam_id AS exam_id;
END$$
call testing_system.sp_delete_exam_by_id (10)$$
 
-- Question 10: Tìm ra các exam được tạo từ 3 năm trước và xóa các exam đó đi (sử dụng store ở câu 9 để xóa). Sau đó in số lượng record đã remove từ các table liên quan trong khi removing
# Not done

-- Question 11: Viết store cho phép người dùng xóa phòng ban bằng cách người dùng nhập vào tên phòng ban và các account thuộc phòng ban đó sẽ được chuyển về phòng ban default là phòng ban chờ việc
# Not done

-- Question 12: Viết store để in ra mỗi tháng có bao nhiêu câu hỏi được tạo trong năm nay
# Not done
