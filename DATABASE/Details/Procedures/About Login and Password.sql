DROP PROCEDURE IF EXISTS login;
DELIMITER //
CREATE PROCEDURE login (IN userID VARCHAR(10), passwordTry VARCHAR(30))
BEGIN
	DECLARE thisRole VARCHAR(10);
    DECLARE thisPassword VARCHAR(30);
    
    SELECT Role, password 
    INTO thisRole, thisPassword
    FROM login WHERE ID = userID;
    
    IF (thisPassword = passwordTry) THEN 
		IF (thisPassword = userID) THEN 
			SELECT thisRole AS Role, true AS firstTry;
        ELSE
			SELECT thisRole AS Role, false AS firstTry;
        END IF;
	ELSE 
		SELECT null AS Role, false AS firstTry;
    END IF;
END;
// DELIMITER ;



DROP PROCEDURE IF EXISTS changePassword;
DELIMITER //
CREATE PROCEDURE changePassword (IN userID VARCHAR(10), oldPassword VARCHAR(30), newPassword VARCHAR(30))
BEGIN
	IF (newPassword <> userID AND oldPassword <> newPassword)
    THEN
		UPDATE login
		SET password = newPassword
		WHERE ID = userID AND password = oldPassword;
    
		SELECT ROW_COUNT() AS Result;
	ELSE 
		SELECT 0 AS Result;
	END IF;
END;
// DELIMITER ;