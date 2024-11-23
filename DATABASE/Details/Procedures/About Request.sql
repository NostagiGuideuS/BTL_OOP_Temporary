
DROP PROCEDURE IF EXISTS borrowDocument;
DELIMITER //
CREATE PROCEDURE borrowDocument (IN uID VARCHAR(10), docuID VARCHAR(10), borrowQuantity INT)
BEGIN
	DECLARE quantityAvailable INT;
	SELECT quantityLeft INTO quantityAvailable
    FROM Documents WHERE ID = docuID;
    
	IF (borrowQuantity <= quantityAvailable)
    THEN 
		INSERT INTO Request (userID, documentID, quantityBorrow, borrowDate)
		VALUES (uID, docuID, borrowQuantity, CURRENT_DATE());
        SELECT true AS Result;
	ELSE 
		SELECT false AS Result;
	END IF;
END;
// DELIMITER ;


DROP PROCEDURE IF EXISTS returnDocument;
DELIMITER //
CREATE PROCEDURE returnDocument (IN rqID VARCHAR(15), uID VARCHAR(10))
BEGIN
	IF uID = (SELECT userID FROM Request WHERE requestID = rqID)
    THEN 
		UPDATE Request
		SET returnDate = CURRENT_DATE()
		WHERE requestID = rqID AND returnDate IS NULL;
        
        SELECT true AS Result;
	ELSE 
		SELECT false AS Result;
	END IF;
END;
// DELIMITER ;


DROP PROCEDURE IF EXISTS checkForUnreturn_DocumentList;
DELIMITER //
CREATE PROCEDURE checkForUnreturn_DocumentList(IN uID VARCHAR(10))
BEGIN
    SELECT
		requestID,
        documentID,
        quantityBorrow,
        borrowDate
	FROM Request
	WHERE userID = uID AND returnDate IS NULL;
END;
// DELIMITER ;


DROP PROCEDURE IF EXISTS checkForUnreturn_StudentList;
DELIMITER //
CREATE PROCEDURE checkForUnreturn_StudentList(IN docuID VARCHAR(10))
BEGIN
   
	 SELECT requestID,
			userID,
			quantityBorrow,
			borrowDate
	FROM Request
	WHERE documentID = docuID AND returnDate IS NULL;
END;
// DELIMITER ;


DROP PROCEDURE IF EXISTS checkForHistory_DocumentList;
DELIMITER //
CREATE PROCEDURE checkForHistory_DocumentList(IN uID VARCHAR(10))
BEGIN
    SELECT requestID,
			documentID,
			quantityBorrow,
			borrowDate,
			returnDate
	FROM Request
	WHERE userID = uID
    ORDER BY DATEDIFF(CURRENT_DATE(), returnDate), borrowDate DESC;
END;
// DELIMITER ;