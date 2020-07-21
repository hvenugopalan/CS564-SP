DELIMITER $$
CREATE PROCEDURE GetUserInfo(
IN username VARCHAR(50))
BEGIN
		SELECT p.pid, p.type, c.amount, i.first_name, i.last_name 
        FROM portfolio p 
        INNER JOIN contains c ON p.pid = c.pid
        INNER JOIN investor i on i.account_number = p.account_number
        WHERE i.username = username;
END $$
DELIMITER ;

-- call GetUserInfo('admin')

-- drop procedure GetUserInfo
-- call GetUserInfo('admin')
