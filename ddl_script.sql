CREATE DATABASE IF NOT EXISTS InvestmentPortfolio;
USE InvestmentPortfolio;

CREATE TABLE IF NOT EXISTS company(
	ticker VARCHAR(15) NOT NULL,
    year YEAR(4) NOT NULL,
    market_cap DOUBLE(32, 2),
    revenue DOUBLE(32, 4),
    operating_income DOUBLE(32,4),
    net_income DOUBLE(32,4),
    dividend_per_share DOUBLE(32,4),
    total_assets DOUBLE(32,4),
    total_liabilities DOUBLE(32,4),
    PRIMARY KEY(ticker, year)
);
    
CREATE TABLE IF NOT EXISTS stock(
	ticker VARCHAR(15) NOT NULL,
    name VARCHAR(50),
    sector VARCHAR(50),
    industry VARCHAR(50),
    PRIMARY KEY(ticker)
 );
  
CREATE TABLE IF NOT EXISTS security_listing(
	ticker VARCHAR(15) NOT NULL,
    date DATE NOT NULL,
    price DOUBLE(32, 4),
    PRIMARY KEY(ticker, date)
);

CREATE TABLE IF NOT EXISTS etf(
	ticker VARCHAR(15) NOT NULL,
    name VARCHAR(50),
    inception_date DATE,
    shares_outstanding BIGINT,
    PRIMARY KEY(ticker) 
);

drop table Investor;
drop table Portfolio;

CREATE TABLE IF NOT EXISTS investor(
	account_number BIGINT NOT NULL AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    address VARCHAR(200),
    PRIMARY KEY(account_number)
);

CREATE TABLE IF NOT EXISTS portfolio(
	pid BIGINT NOT NULL AUTO_INCREMENT,
    type VARCHAR(30),
    account_number BIGINT,
    PRIMARY KEY(pid),
    FOREIGN KEY(account_number) REFERENCES investor(account_number) ON DELETE CASCADE
);

CREATE TRIGGER InvestmentPortfolio.stock_delete_trigger    
AFTER DELETE ON InvestmentPortfolio.stock
FOR EACH ROW
DELETE FROM InvestmentPortfolio.security_listing where ticker NOT IN (SELECT ticker FROM stock);

CREATE TRIGGER etf_delete_trigger    
AFTER DELETE ON etf
FOR EACH ROW
DELETE FROM security_listing where ticker NOT IN (SELECT ticker FROM etf);

DELIMITER $$
CREATE TRIGGER security_listing_trigger    
BEFORE INSERT ON security_listing
FOR EACH ROW
BEGIN
    IF (NOT EXISTS (SELECT ticker FROM stock WHERE ticker = new.ticker) 
		AND NOT EXISTS (SELECT ticker FROM etf WHERE ticker = new.ticker)) THEN 
			SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'The security listing added is neither an ETF nor a stock. Please add the corresponding stock or ETF information first.';
	END IF;
END$$
DELIMITER ;

CREATE TABLE IF NOT EXISTS holds(
	etf_ticker VARCHAR(15),
    stock_ticker VARCHAR(15),
    market_value DOUBLE(32,4),
    shares BIGINT,
    weight DOUBLE(32,4),
    PRIMARY KEY(etf_ticker, stock_ticker)
); 

CREATE TABLE IF NOT EXISTS contains(
	pid VARCHAR(15),
    ticker BIGINT,
    amount DOUBLE(32,4),
    PRIMARY KEY(pid, ticker)
);