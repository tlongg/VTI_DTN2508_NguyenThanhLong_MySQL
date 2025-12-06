-- Question 1: Tạo view có chứa danh sách nhân viên thuộc phòng ban sale
CREATE OR REPLACE VIEW view_sale_employees AS
    SELECT 
        a.*, d.department_name
    FROM
        account AS a
            JOIN
        department AS d ON a.department_id = d.department_id
    WHERE
        department_name = 'Sale';
SELECT 
    *
FROM
    view_sale_employees;
    
-- Question 2: Tạo view có chứa thông tin các account tham gia vào nhiều group nhất
CREATE OR REPLACE VIEW view_most_group_accounts AS
    SELECT 
        a.*, COUNT(ga.group_id) AS total_joined_group
    FROM
        account AS a
            JOIN
        group_account AS ga ON a.account_id = ga.account_id
    GROUP BY account_id
    HAVING COUNT(ga.group_id) = (SELECT 
            MAX(total_joined_group)
        FROM
            (SELECT 
                COUNT(ga.group_id) AS total_joined_group
            FROM
                account AS a
            JOIN group_account AS ga ON a.account_id = ga.account_id
            GROUP BY a.account_id) AS total_group_joined);  
SELECT 
    *
FROM
    view_most_group_accounts;
    
-- Question 3: Tạo view có chứa câu hỏi có những content quá dài (content quá 300 từ được coi là quá dài) và xóa nó đi
CREATE OR REPLACE VIEW view_long_questions AS
    SELECT 
        *
    FROM
        question
    WHERE
        CHAR_LENGTH(content) > 300;
SELECT 
    *
FROM
    view_long_questions;
DROP VIEW view_long_questions;

-- Question 4: Tạo view có chứa danh sách các phòng ban có nhiều nhân viên nhất
CREATE OR REPLACE VIEW view_max_employee_department AS
SELECT 
    d.department_id,
    d.department_name,
    COUNT(a.account_id) AS total_staff
FROM
    department d
        JOIN
    account a ON d.department_id = a.department_id
GROUP BY d.department_id
HAVING COUNT(a.account_id) = (SELECT 
        MAX(total_staff)
    FROM
        (SELECT 
            COUNT(a.account_id) AS total_staff
        FROM
            department d
        JOIN account a ON d.department_id = a.department_id
        GROUP BY d.department_id) AS total_staff_joined);
SELECT 
    *
FROM
    view_max_employee_department;
    
-- Question 5: Tạo view có chứa tất các các câu hỏi do user họ Nguyễn tạo.
CREATE OR REPLACE VIEW view_nguyen_questions AS
    SELECT 
        *
    FROM
        question
    WHERE
        creator_id IN (SELECT 
                account_id
            FROM
                account
            WHERE
                full_name LIKE 'Nguyen%'
                    OR full_name LIKE 'Nguyễn%');
SELECT 
    *
FROM
    view_nguyen_questions;     

