DELIMITER $$
CREATE PROCEDURE GetTickerCurrentPrice(
IN ticker VARCHAR(15)
)
BEGIN
	SELECT current_price2(ticker);
END $$
DELIMITER ;

-- call GetTickerCurrentPrice('IVV')