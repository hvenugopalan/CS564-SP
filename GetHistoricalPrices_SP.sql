DELIMITER $$
CREATE PROCEDURE GetHistoricalPrices(
IN in_ticker VARCHAR(15)
)
BEGIN
	SELECT date, price FROM security_listing WHERE ticker = in_ticker;
END $$
DELIMITER ;