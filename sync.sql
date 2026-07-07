-- Update book status
UPDATE b
SET status = 0
FROM dbo.t_book b
JOIN dbo.t_user u ON b.id IN (u.borrow_book_id1, u.borrow_book_id2, u.borrow_book_id3, u.borrow_book_id4, u.borrow_book_id5);

-- Insert missing borrow records for borrow_book_id1
INSERT INTO dbo.t_borrow_record (user_id, book_id, borrow_time, due_time, status, renew_count)
SELECT id, borrow_book_id1, GETDATE(), DATEADD(day, 30, GETDATE()), 0, 0
FROM dbo.t_user
WHERE borrow_book_id1 IS NOT NULL
AND NOT EXISTS (SELECT 1 FROM dbo.t_borrow_record br WHERE br.user_id = t_user.id AND br.book_id = t_user.borrow_book_id1);

-- Insert missing borrow records for borrow_book_id2
INSERT INTO dbo.t_borrow_record (user_id, book_id, borrow_time, due_time, status, renew_count)
SELECT id, borrow_book_id2, GETDATE(), DATEADD(day, 30, GETDATE()), 0, 0
FROM dbo.t_user
WHERE borrow_book_id2 IS NOT NULL
AND NOT EXISTS (SELECT 1 FROM dbo.t_borrow_record br WHERE br.user_id = t_user.id AND br.book_id = t_user.borrow_book_id2);

-- Insert missing borrow records for borrow_book_id3
INSERT INTO dbo.t_borrow_record (user_id, book_id, borrow_time, due_time, status, renew_count)
SELECT id, borrow_book_id3, GETDATE(), DATEADD(day, 30, GETDATE()), 0, 0
FROM dbo.t_user
WHERE borrow_book_id3 IS NOT NULL
AND NOT EXISTS (SELECT 1 FROM dbo.t_borrow_record br WHERE br.user_id = t_user.id AND br.book_id = t_user.borrow_book_id3);

-- Insert missing borrow records for borrow_book_id4
INSERT INTO dbo.t_borrow_record (user_id, book_id, borrow_time, due_time, status, renew_count)
SELECT id, borrow_book_id4, GETDATE(), DATEADD(day, 30, GETDATE()), 0, 0
FROM dbo.t_user
WHERE borrow_book_id4 IS NOT NULL
AND NOT EXISTS (SELECT 1 FROM dbo.t_borrow_record br WHERE br.user_id = t_user.id AND br.book_id = t_user.borrow_book_id4);

-- Insert missing borrow records for borrow_book_id5
INSERT INTO dbo.t_borrow_record (user_id, book_id, borrow_time, due_time, status, renew_count)
SELECT id, borrow_book_id5, GETDATE(), DATEADD(day, 30, GETDATE()), 0, 0
FROM dbo.t_user
WHERE borrow_book_id5 IS NOT NULL
AND NOT EXISTS (SELECT 1 FROM dbo.t_borrow_record br WHERE br.user_id = t_user.id AND br.book_id = t_user.borrow_book_id5);
