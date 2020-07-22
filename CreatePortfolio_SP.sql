DELIMITER $$
CREATE PROCEDURE CreatePortfolio(
IN type VARCHAR(30),
IN usrname VARCHAR(50)
)
BEGIN
	DECLARE act_num BIGINT;
    SELECT account_number INTO act_num FROM investor WHERE username = usrname;
    IF act_num IS NULL THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'A user with the given username does not exist.', MYSQL_ERRNO = 1001;
	ELSE
		INSERT INTO portfolio(type, account_number) VALUES (type, act_num);
		SELECT max(pid) as pid FROM portfolio;
	END IF;
END $$
DELIMITER ;

-- drop procedure CreatePortfolio

