DELIMITER $$
CREATE PROCEDURE GetPortfolio(
IN in_pid BIGINT
)
BEGIN
	DECLARE t_name VARCHAR(50);
    
    SELECT * FROM (
    SELECT c.ticker, c.amount, e.name FROM contains c
    LEFT JOIN etf e ON c.ticker = e.ticker
    WHERE pid = in_pid
    UNION
	SELECT c.ticker, c.amount, s.name FROM contains c
    LEFT JOIN stock s ON c.ticker = s.ticker
    WHERE pid = in_pid ) h
    WHERE h.name IS NOT NULL and h.name<>'';

END $$
DELIMITER ;

-- call GetPortfolio(23)
