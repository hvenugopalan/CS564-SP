DELIMITER $$
select roa('APPL',null)
-- drop function ROA
CREATE FUNCTION ROA(ticker_param VARCHAR(10), year YEAR(4)) RETURNS DOUBLE(16,2)
BEGIN
	DECLARE roa DOUBLE(16,2);
    SET roa = 0;
	IF(year IS NULL) THEN
		SELECT (S.net_income / S.total_assets) *100 INTO roa
		FROM company S 
		WHERE ticker_param = S.ticker AND S.year = 2018; 
	ELSE 
		SELECT (S.net_income / S.total_assets) *100 INTO roa
		FROM company S 
		WHERE ticker_param = S.ticker AND S.year = year;
	END IF;
    RETURN roa;
END;
$$
DELIMITER ;

-- drop function operatingMargin
DELIMITER $$
CREATE FUNCTION operatingMargin(ticker_param VARCHAR(10), year YEAR(4)) RETURNS DOUBLE(16,2)
BEGIN
	DECLARE opMargin DOUBLE(16,2);
    SET opMargin = 0;
	IF(year IS NULL) THEN
		SELECT (S.operating_income / S.revenue) *100 INTO opMargin
		FROM company S 
		WHERE ticker_param = S.ticker AND S.year = 2018; 
	ELSE 
		SELECT (S.operating_income / S.revenue) *100 INTO opMargin
		FROM company S 
		WHERE ticker_param = S.ticker AND S.year = year;
	END IF;
    RETURN opMargin;
END;
$$
DELIMITER ;

-- drop function netMargin
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

-- drop function shareholderEquity
DELIMITER $$
CREATE FUNCTION shareholderEquity(ticker_param VARCHAR(10), year YEAR(4)) RETURNS DOUBLE(32,4)
BEGIN
	DECLARE se DOUBLE(32,4);
    SET se = 0;

    IF(year IS NULL) THEN
		SELECT total_assets - total_liabilities as diff into se
		FROM company S 
		WHERE ticker_param = S.ticker AND S.year = 2018; 
	ELSE 
		SELECT total_assets - total_liabilities as diff into se
		FROM company S 
		WHERE ticker_param = S.ticker AND S.year = year;
	END IF;
    RETURN se;
END;
$$
DELIMITER ;

-- drop function current_price
DELIMITER $$
CREATE FUNCTION current_price(securityID VARCHAR(10)) RETURNS DOUBLE(32, 4)
BEGIN
	DECLARE curr_price DOUBLE(32,4);
    SET curr_price = 0;
	SELECT AVG(L.price) 
    INTO curr_price
	FROM security_listing L 
	WHERE YEAR(L.date) = (select max(YEAR(date)) FROM security_listing WHERE ticker = securityID) AND L.ticker = securityID;
    RETURN curr_price;
END $$
DELIMITER ;

-- drop function current_price
