DELIMITER $$
CREATE PROCEDURE BuySellSecurity(
IN in_pid BIGINT,
IN in_ticker VARCHAR(15),
IN in_quantity INT,
IN transaction_type VARCHAR(15)
)
BEGIN
DECLARE cuml_amount DOUBLE(32,4);
SET cuml_amount = 0;
	IF(transaction_type = 'buy') THEN
		SELECT sum(amount) INTO cuml_amount FROM contains WHERE pid = in_pid and ticker = in_ticker;
        IF cuml_amount IS NULL THEN
			SET  cuml_amount = 0;
            SET cuml_amount = cuml_amount + current_price2(in_ticker) * in_quantity;
			INSERT INTO contains(pid, ticker, amount) values (in_pid, in_ticker, cuml_amount);
		ELSE
			 SET cuml_amount = cuml_amount + current_price2(in_ticker) * in_quantity;
             UPDATE contains SET amount = cuml_amount WHERE pid = in_pid and ticker = in_ticker;
		END IF;
	
    ELSEIF(transaction_type = 'sell') THEN
		SELECT sum(amount) INTO cuml_amount FROM contains WHERE pid = in_pid and ticker = in_ticker;
        IF cuml_amount IS NOT NULL THEN
			SET cuml_amount = cuml_amount - current_price2(in_ticker) * in_quantity;
            IF cuml_amount < 0 THEN
				SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'You cannot sell more shares than you own.', MYSQL_ERRNO = 1001;
			ELSEIF cuml_amount = 0 THEN
				DELETE FROM contains WHERE pid =  in_pid AND ticker = in_ticker;
			ELSE
				UPDATE contains SET  amount = cuml_amount WHERE pid = in_pid AND ticker = in_ticker;
			END IF;
		END IF;
        
    END IF;
END $$
DELIMITER ;

-- drop procedure BuySellSecurity
-- select current_price('AAPL')
-- call BuySellSecurity(23, 'AAPL', 1, 'buy')
-- select * from contains