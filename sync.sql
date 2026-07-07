-- ============================================
-- Library Management System - MySQL 数据同步脚本
-- ============================================

USE library_db;

-- 将已被借出的书状态置为 0
UPDATE t_book b
JOIN t_user u ON b.id IN (u.borrow_book_id1, u.borrow_book_id2, u.borrow_book_id3, u.borrow_book_id4, u.borrow_book_id5)
SET b.status = 0;

-- 为 borrow_book_id1 补齐缺失的借阅记录
INSERT INTO t_borrow_record (user_id, book_id, borrow_time, due_time, status, renew_count)
SELECT id, borrow_book_id1, NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY), 0, 0
FROM t_user
WHERE borrow_book_id1 IS NOT NULL
AND NOT EXISTS (SELECT 1 FROM t_borrow_record br WHERE br.user_id = t_user.id AND br.book_id = t_user.borrow_book_id1);

-- 为 borrow_book_id2 补齐缺失的借阅记录
INSERT INTO t_borrow_record (user_id, book_id, borrow_time, due_time, status, renew_count)
SELECT id, borrow_book_id2, NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY), 0, 0
FROM t_user
WHERE borrow_book_id2 IS NOT NULL
AND NOT EXISTS (SELECT 1 FROM t_borrow_record br WHERE br.user_id = t_user.id AND br.book_id = t_user.borrow_book_id2);

-- 为 borrow_book_id3 补齐缺失的借阅记录
INSERT INTO t_borrow_record (user_id, book_id, borrow_time, due_time, status, renew_count)
SELECT id, borrow_book_id3, NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY), 0, 0
FROM t_user
WHERE borrow_book_id3 IS NOT NULL
AND NOT EXISTS (SELECT 1 FROM t_borrow_record br WHERE br.user_id = t_user.id AND br.book_id = t_user.borrow_book_id3);

-- 为 borrow_book_id4 补齐缺失的借阅记录
INSERT INTO t_borrow_record (user_id, book_id, borrow_time, due_time, status, renew_count)
SELECT id, borrow_book_id4, NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY), 0, 0
FROM t_user
WHERE borrow_book_id4 IS NOT NULL
AND NOT EXISTS (SELECT 1 FROM t_borrow_record br WHERE br.user_id = t_user.id AND br.book_id = t_user.borrow_book_id4);

-- 为 borrow_book_id5 补齐缺失的借阅记录
INSERT INTO t_borrow_record (user_id, book_id, borrow_time, due_time, status, renew_count)
SELECT id, borrow_book_id5, NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY), 0, 0
FROM t_user
WHERE borrow_book_id5 IS NOT NULL
AND NOT EXISTS (SELECT 1 FROM t_borrow_record br WHERE br.user_id = t_user.id AND br.book_id = t_user.borrow_book_id5);