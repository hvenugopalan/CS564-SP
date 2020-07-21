DELIMITER $$
CREATE FUNCTION ROA(ticker_param VARCHAR(10)) RETURNS DOUBLE(16,2)
BEGIN
	DECLARE roa DOUBLE(16,2);
    SET roa = 0;
	SELECT (S.net_income / S.total_assets) * 100 INTO roa
	FROM company S 
	WHERE ticker_param = S.ticker; 
    RETURN roa;
END;
$$
DELIMITER ;

DELIMITER $$
CREATE FUNCTION operatingMargin(ticker_param VARCHAR(10)) RETURNS DOUBLE(16,2)
BEGIN
	DECLARE opMargin DOUBLE(16,2);
    SET opMargin = 0;
	SELECT (S.operating_income / S.revenue) * 100 INTO opMargin
	FROM company S 
    WHERE ticker_param = S.ticker; 
    RETURN opMargin;
END;
$$
DELIMITER ;

DELIMITER $$
CREATE FUNCTION netMargin(ticker_param VARCHAR(10), year YEAR(4)) RETURNS DOUBLE(16,2)
BEGIN
	DECLARE nm DOUBLE(16,2);
    SET nm = 0;
    IF(year IS NULL) THEN
		SELECT (S.net_income / S.revenue) *100 INTO nm
		FROM company S 
		WHERE ticker_param = S.ticker AND S.year = 2018; 
	ELSE 
		SELECT (S.net_income / S.revenue) *100 INTO nm
		FROM company S 
		WHERE ticker_param = S.ticker AND S.year = year;
	END IF;
    RETURN nm;
END;
$$
DELIMITER ;

DELIMITER $$
CREATE FUNCTION shareholderEquity(ticker_param VARCHAR(10)) RETURNS DOUBLE(32,4)
BEGIN
	DECLARE se DOUBLE(32,4);
    SET se = 0;
	SELECT total_assets - total_liabilities as diff into se
    FROM company  
	WHERE ticker_param = ticker; 
    RETURN se;
END;
$$
DELIMITER ;

DELIMITER $$
CREATE FUNCTION current_price(securityID VARCHAR(10)) RETURNS DOUBLE(32, 4)
BEGIN
	DECLARE curr_price DOUBLE(32,4);
    SET curr_price = 0;
	SELECT AVG(L.price) 
    INTO curr_price
	FROM security_listing L 
	WHERE L.date LIKE '2018-%' AND L.ticker = securityID;
    RETURN curr_price;
END $$
DELIMITER ;

-- drop function current_price