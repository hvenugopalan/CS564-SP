DELIMITER $$
CREATE PROCEDURE GetUserInfo(
IN username VARCHAR(50))
BEGIN
		SELECT p.pid, p.type, IFNULL(c.amount,0) as amount, i.first_name, i.last_name 
        FROM portfolio p 
		INNER JOIN investor i on i.account_number = p.account_number
        LEFT JOIN contains c ON p.pid = c.pid
       
        WHERE i.username = username;
END $$
DELIMITER ;

-- select * from investor where account_number = 123456
-- select * from portfolio where account_number = 123456
-- select * from pid 
-- call GetUserInfo('admin')

-- drop procedure GetUserInfo
-- call GetUserInfo('admin')
