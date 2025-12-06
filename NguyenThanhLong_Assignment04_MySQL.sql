-- Question 1: Lấy ra danh sách nhân viên và thông tin phòng ban của họ
SELECT 
    a.*, d.department_name
FROM
    account a
        JOIN
    department d ON a.department_id = d.department_id;

-- Question 2: Lấy ra thông tin các account được tạo sau ngày 20/12/2010
SELECT 
    *
FROM
    account
WHERE
    create_date > '2010-12-20';

-- Question 3: Lấy ra tất cả các developer
SELECT 
    a.*, p.position_name
FROM
    account a
        JOIN
    position p ON a.position_id = p.position_id
WHERE
    p.position_name = 'Dev';

-- Question 4: Lấy ra danh sách phòng ban có >3 nhân viên
SELECT 
    d.department_id,
    d.department_name,
    COUNT(a.account_id) AS total_staff
FROM
    department d
        JOIN
    account a ON d.department_id = a.department_id
GROUP BY d.department_id
HAVING COUNT(a.account_id) > 3;

-- Question 5: Lấy ra danh sách câu hỏi được sử dụng trong đề thi nhiều nhất
SELECT 
    q.question_id, q.content, COUNT(eq.exam_id) AS total_used
FROM
    question q
        JOIN
    exam_question eq ON q.question_id = eq.question_id
GROUP BY q.question_id
HAVING total_used = (SELECT 
        MAX(cnt)
    FROM
        (SELECT 
            COUNT(*) AS cnt
        FROM
            exam_question
        GROUP BY question_id) AS t);

-- Question 6: Thống kê mỗi category Question được sử dụng trong bao nhiêu Question
SELECT 
    c.category_id,
    c.category_name,
    COUNT(q.question_id) AS total_questions
FROM
    category_question c
        LEFT JOIN
    question q ON c.category_id = q.category_id
GROUP BY c.category_id;

-- Question 7: Thống kê mỗi Question được sử dụng trong bao nhiêu Exam
SELECT 
    q.question_id, q.content, COUNT(eq.exam_id) AS total_exam
FROM
    question q
        LEFT JOIN
    exam_question eq ON q.question_id = eq.question_id
GROUP BY q.question_id;

-- Question 8: Lấy ra Question có nhiều câu trả lời nhất
SELECT 
    q.question_id, q.content, COUNT(a.answer_id) AS total_answer
FROM
    question q
        JOIN
    answer a ON q.question_id = a.question_id
GROUP BY q.question_id
ORDER BY total_answer DESC
LIMIT 1;

-- Question 9: Thống kê số lượng account trong mỗi group
SELECT 
    g.group_id,
    g.group_name,
    COUNT(ga.account_id) AS total_member
FROM
    `group` g
        LEFT JOIN
    group_account ga ON g.group_id = ga.group_id
GROUP BY g.group_id;

-- Question 10: Tìm chức vụ có ít người nhất
SELECT 
    p.position_id,
    p.position_name,
    COUNT(a.account_id) AS total_account
FROM
    position p
        LEFT JOIN
    account a ON p.position_id = a.position_id
GROUP BY p.position_id
ORDER BY total_account ASC
LIMIT 1;

-- Question 11: Thống kê mỗi phòng ban có bao nhiêu dev, test, scrum master, PM
SELECT 
    d.department_name, COUNT(a.account_id) AS employee_count
FROM
    department d
        JOIN
    account a ON d.department_id = a.department_id
GROUP BY d.department_id , d.department_name
ORDER BY employee_count DESC;

-- Question 12: Lấy thông tin chi tiết câu hỏi gồm: thông tin cơ bản + category + type + người tạo
SELECT 
    q.question_id,
    q.content,
    q.create_date,
    c.category_name,
    t.type_name,
    a.full_name AS creator_full_name
FROM
    question q
        JOIN
    category_question c ON q.category_id = c.category_id
        JOIN
    type_question t ON q.type_id = t.type_id
        JOIN
    account a ON q.creator_id = a.account_id;

-- Question 13: Lấy số lượng câu hỏi của mỗi loại tự luận hay trắc nghiệm
SELECT 
    t.type_id,
    t.type_name,
    COUNT(q.question_id) AS total_question
FROM
    type_question t
        LEFT JOIN
    question q ON t.type_id = q.type_id
GROUP BY t.type_id;

-- Question 14: Lấy ra group không có account nào
SELECT 
    g.*
FROM
    `group` g
        LEFT JOIN
    group_account ga ON g.group_id = ga.group_id
WHERE
    ga.account_id IS NULL;

-- Question 15: Lấy ra group có account nào (group có >= 1 member)
SELECT DISTINCT
    g.*
FROM
    `group` g
        JOIN
    group_account ga ON g.group_id = ga.group_id;

-- Question 16: Lấy ra question không có answer nào
SELECT 
    q.*
FROM
    question q
        LEFT JOIN
    answer a ON q.question_id = a.question_id
WHERE
    a.answer_id IS NULL;
    
--  Question 17:
-- a) Lấy các account thuộc nhóm thứ 1
-- b) Lấy các account thuộc nhóm thứ 2
-- c) Ghép 2 kết quả từ câu a) và câu b) sao cho không có record nào trùng nhau
SELECT 
    a.account_id, a.full_name
FROM
    group_account ga
        JOIN
    account a ON ga.account_id = a.account_id
WHERE
    ga.group_id = 1 
UNION SELECT 
    a.account_id, a.full_name
FROM
    group_account ga
        JOIN
    account a ON ga.account_id = a.account_id
WHERE
    ga.group_id = 2;

-- Question 18:
-- a) Lấy các group có lớn hơn 5 thành viên
-- b) Lấy các group có nhỏ hơn 7 thành viên
-- c) Ghép 2 kết quả từ câu a) và câu b).
SELECT 
    g.group_id, g.group_name
FROM
    `group` g
        JOIN
    group_account ga ON g.group_id = ga.group_id
GROUP BY g.group_id , g.group_name
HAVING COUNT(ga.account_id) > 5 
UNION SELECT 
    g.group_id, g.group_name
FROM
    `group` g
        JOIN
    group_account ga ON g.group_id = ga.group_id
GROUP BY g.group_id , g.group_name
HAVING COUNT(ga.account_id) < 7;