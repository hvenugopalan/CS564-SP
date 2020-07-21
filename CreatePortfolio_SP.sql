DELIMITER $$
CREATE PROCEDURE CreatePortfolio(
IN type VARCHAR(30),
IN account_number BIGINT
)
BEGIN
	INSERT INTO portfolio(type, account_number) VALUES (type, account_number);
    SELECT max(pid) as pid FROM portfolio;
END $$
DELIMITER ;

-- drop procedure CreatePortfolio

