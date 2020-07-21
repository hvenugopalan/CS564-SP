DELIMITER $$
CREATE PROCEDURE `GetCompanySearchResults`(
IN name VARCHAR(50),
IN roa INT,
IN year YEAR(4),
IN sector VARCHAR(50),
IN operation_margin INT,
IN net_margin INT,
IN industry VARCHAR(50),
IN ticker VARCHAR(15),
IN shareholder_equity INT,
IN inception_date INT,
IN shares_outstanding BIGINT,
IN company_weight INT,
IN type VARCHAR(15)
)
BEGIN

	DECLARE innerQuery VARCHAR(65535);
	SET innerQuery = ' WHERE 1=1 ';
    
    IF(type = 'stock') THEN
    BEGIN
		IF( name IS NOT NULL and name<>'') THEN
			SET innerQuery = CONCAT(innerQuery, ' AND s.name = ''', ticker, '''');
		END IF;
    
		IF( year IS NOT NULL) THEN
			SET innerQuery = CONCAT(innerQuery, ' AND c.year = ''', year, '''');
		END IF;
        
        IF( roa IS NOT NULL) THEN
			IF(roa = 1) THEN
				SET innerQuery = CONCAT(innerQuery, ' AND roa(c.ticker) > 0');
			ELSEIF(roa = 2) THEN
				SET innerQuery = CONCAT(innerQuery, ' AND roa(c.ticker) < 0');
			ELSEIF(roa = 3) THEN
				SET innerQuery = CONCAT(innerQuery, ' AND roa(c.ticker) > 15');
			ELSEIF(roa = 4) THEN
				SET innerQuery = CONCAT(innerQuery, ' AND roa(c.ticker) < -15');
			END IF;
		END IF;
        
        IF( sector IS NOT NULL and sector<>'') THEN
			SET innerQuery = CONCAT(innerQuery, ' AND s.sector = ''', sector, '''');
		END IF;
        
        IF( operation_margin IS NOT NULL) THEN
			IF(operation_margin = 1) THEN
				SET innerQuery = CONCAT(innerQuery, ' AND operationMargin(c.ticker)  > 0' );
			ELSEIF(operation_margin = 2) THEN
				SET innerQuery = CONCAT(innerQuery, ' AND operationMargin(c.ticker)  < 0');
			ELSEIF(operation_margin = 3) THEN
				SET innerQuery = CONCAT(innerQuery, ' AND operationMargin(c.ticker)  < -20');
			ELSEIF(operation_margin = 4) THEN
				SET innerQuery = CONCAT(innerQuery, ' AND operationMargin(c.ticker)  > 25');
			END IF;
		END IF;
        
         IF( net_margin IS NOT NULL) THEN
			IF(net_margin = 1) THEN
				SET innerQuery = CONCAT(innerQuery, ' AND netMargin(c.ticker, ', year, ')  > 0' );
			ELSEIF(net_margin = 2) THEN
				SET innerQuery = CONCAT(innerQuery, ' AND netMargin(c.ticker, ', year, ')  < 0');
			ELSEIF(net_margin = 3) THEN
				SET innerQuery = CONCAT(innerQuery, ' AND netMargin(c.ticker, ', year, ')  < -20');
			ELSEIF(net_margin = 4) THEN
				SET innerQuery = CONCAT(innerQuery, ' AND netMargin(c.ticker, ', year, ')  > 20');
			END IF;
		END IF;
        
        IF( industry IS NOT NULL and industry<>'') THEN
			SET innerQuery = CONCAT(innerQuery, ' AND s.industry = ''', industry, '''');
		END IF;
        
        IF( ticker IS NOT NULL and ticker<>'') THEN
			SET innerQuery = CONCAT(innerQuery, ' AND s.ticker = ''', ticker, '''');
		END IF;
        
         IF( shareholder_equity IS NOT NULL) THEN
			IF(shareholder_equity = 1) THEN
				SET innerQuery = CONCAT(innerQuery, ' AND shareholderEquity(c.ticker) > 0' );
			ELSEIF(shareholder_equity = 2) THEN
				SET innerQuery = CONCAT(innerQuery, ' AND shareholderEquity(c.ticker) < 0');
			END IF;
		END IF;
        
		SET @Query = CONCAT('SELECT DISTINCT c.ticker, s.name, current_price(c.ticker) as current_price FROM company c INNER JOIN stock s ON c.ticker = s.ticker ', innerQuery, ' limit 0,1000' );
    END;
    ELSEIF(type = 'etf') THEN
    BEGIN
		IF( name IS NOT NULL and name<>'') THEN
			SET innerQuery = CONCAT(innerQuery, ' AND e.name = ''', ticker, '''');
		END IF;
    
		IF( year IS NOT NULL) THEN
			SET innerQuery = CONCAT(innerQuery, ' AND c.year = ''', year, '''');
		END IF;
        
        IF( roa IS NOT NULL) THEN
			IF(roa = 1) THEN
				SET innerQuery = CONCAT(innerQuery, ' AND roa(c.ticker) > 0');
			ELSEIF(roa = 2) THEN
				SET innerQuery = CONCAT(innerQuery, ' AND roa(c.ticker) < 0');
			ELSEIF(roa = 3) THEN
				SET innerQuery = CONCAT(innerQuery, ' AND roa(c.ticker) > 15');
			ELSEIF(roa = 4) THEN
				SET innerQuery = CONCAT(innerQuery, ' AND roa(c.ticker) < -15');
			END IF;
		END IF;
              
        IF( operation_margin IS NOT NULL) THEN
			IF(operation_margin = 1) THEN
				SET innerQuery = CONCAT(innerQuery, ' AND operationMargin(c.ticker)  > 0' );
			ELSEIF(operation_margin = 2) THEN
				SET innerQuery = CONCAT(innerQuery, ' AND operationMargin(c.ticker)  < 0');
			ELSEIF(operation_margin = 3) THEN
				SET innerQuery = CONCAT(innerQuery, ' AND operationMargin(c.ticker)  < -20');
			ELSEIF(operation_margin = 4) THEN
				SET innerQuery = CONCAT(innerQuery, ' AND operationMargin(c.ticker)  > 25');
			END IF;
		END IF;
        
		IF( net_margin IS NOT NULL) THEN
			IF(net_margin = 1) THEN
				SET innerQuery = CONCAT(innerQuery, ' AND netMargin(c.ticker, ', year, ')  > 0' );
			ELSEIF(net_margin = 2) THEN
				SET innerQuery = CONCAT(innerQuery, ' AND netMargin(c.ticker, ', year, ')  < 0');
			ELSEIF(net_margin = 3) THEN
				SET innerQuery = CONCAT(innerQuery, ' AND netMargin(c.ticker, ', year, ')  < -20');
			ELSEIF(net_margin = 4) THEN
				SET innerQuery = CONCAT(innerQuery, ' AND netMargin(c.ticker, ', year, ')  > 20');
			END IF;
		END IF;
        
        IF( ticker IS NOT NULL and ticker<>'') THEN
			SET innerQuery = CONCAT(innerQuery, ' AND e.ticker = ''', ticker, '''');
		END IF;
        
		IF( shareholder_equity IS NOT NULL) THEN
			IF(shareholder_equity = 1) THEN
				SET innerQuery = CONCAT(innerQuery, ' AND shareholderEquity(c.ticker) > 0' );
			ELSEIF(shareholder_equity = 2) THEN
				SET innerQuery = CONCAT(innerQuery, ' AND shareholderEquity(c.ticker) < 0');
			END IF;
		END IF;
        
        IF( inception_date IS NOT NULL) THEN
			IF(inception_date = 1) THEN
				SET innerQuery = CONCAT(innerQuery, ' AND e.inception_date < 1990-01-01');
			ELSEIF(inception_date = 2) THEN
				SET innerQuery = CONCAT(innerQuery, ' AND e.inception_date BETWEEN ''1990-01-01'' and ''2000-01-01''');
			ELSEIF(inception_date = 3) THEN
				SET innerQuery = CONCAT(innerQuery, ' AND e.inception_date BETWEEN ''2000-01-01'' and ''2010-01-01''');
			ELSEIF(inception_date = 4) THEN
				SET innerQuery = CONCAT(innerQuery, ' AND e.inception_date > ''2010-01-01''');
			END IF;
		END IF;
        
        IF( shares_outstanding IS NOT NULL) THEN
			IF(shares_outstanding = 1) THEN
				SET innerQuery = CONCAT(innerQuery, ' AND e.shares_outstanding BETWEEN 0 and 250000000');
			ELSEIF(shares_outstanding = 2) THEN
				SET innerQuery = CONCAT(innerQuery, ' AND e.shares_outstanding BETWEEN 250000000 and 500000000');
			ELSEIF(shares_outstanding = 3) THEN
				SET innerQuery = CONCAT(innerQuery, ' AND e.shares_outstanding BETWEEN 500000000 and 750000000');
			ELSEIF(shares_outstanding = 4) THEN
				SET innerQuery = CONCAT(innerQuery, ' AND e.shares_outstanding BETWEEN 750000000 and 1000000000');
			ELSEIF(shares_outstanding = 5) THEN
				SET innerQuery = CONCAT(innerQuery, ' AND e.shares_outstanding > 1000000000');
			END IF;
		END IF;
        
        IF( company_weight IS NOT NULL) THEN
			IF(company_weight = 1) THEN
				SET innerQuery = CONCAT(innerQuery, ' AND e.company_weight BETWEEN 0 and 1');
			ELSEIF(company_weight = 2) THEN
				SET innerQuery = CONCAT(innerQuery, ' AND e.company_weight BETWEEN 1 and 3');
			ELSEIF(company_weight = 3) THEN
				SET innerQuery = CONCAT(innerQuery, ' AND e.company_weight BETWEEN 3 and 5');
			ELSEIF(company_weight = 4) THEN
				SET innerQuery = CONCAT(innerQuery, ' AND e.company_weight BETWEEN 5 and 10');
			ELSEIF(company_weight = 5) THEN
				SET innerQuery = CONCAT(innerQuery, ' AND e.company_weight > 10');
			END IF;
		END IF;
        
		SET @Query = CONCAT('SELECT DISTINCT c.ticker, e.name, current_price(c.ticker) as current_price FROM company c INNER JOIN etf e ON c.ticker = e.ticker', innerQuery, ' limit 0,1000');
    END;
    END IF;

	PREPARE b FROM @Query;
	EXECUTE b;

END $$
DELIMITER ;

-- drop procedure GetCompanySearchResults