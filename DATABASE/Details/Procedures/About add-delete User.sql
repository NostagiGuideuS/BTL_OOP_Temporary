
DROP PROCEDURE IF EXISTS addMember;
DELIMITER //
CREATE PROCEDURE addMember (IN 
	newID VARCHAR(10),
    newFirstName VARCHAR(50),
    newLastName VARCHAR(50),
    newContact VARCHAR(50),
    newBirthDate DATE
)
BEGIN
	IF (SELECT COUNT(*) From User WHERE ID = newID) = 0
    
	THEN 
		INSERT INTO Member (ID, firstName, lastName, contact, dateOfBirth) 
			VALUES (newID, newFirstName, newLastName, newContact, newBirthDate);
		SELECT true as Result;
        
	ELSE 
		SELECT false as Result; -- if duplicate userID
    END IF;
END;
// DELIMITER ;


DROP PROCEDURE IF EXISTS addStaff;
DELIMITER //
CREATE PROCEDURE addStaff (IN 
	newID VARCHAR(10),
    newFirstName VARCHAR(50),
    newLastName VARCHAR(50),
    newContact VARCHAR(50),
    newJobTitle VARCHAR(20),
    newReportToID VARCHAR(10)
)
BEGIN
	IF (SELECT COUNT(*) From User WHERE ID = newID) = 0 
    AND (newReportToID is null OR (SELECT COUNT(*) FROM Staff WHERE ID = newReportToID) = 1)
    
	THEN 
		INSERT INTO Staff (ID, firstName, lastName, contact, jobTitle, reportToID) 
			VALUES (newID, newFirstName, newLastName, newContact, newJobTitle, newReportToID);
		SELECT true as Result;
        
	ELSE 
		SELECT false as Result; -- if duplicate userID
    END IF;
END;
// DELIMITER ;


DROP PROCEDURE IF EXISTS deleteUser;
DELIMITER //
CREATE PROCEDURE deleteUser (IN delID VARCHAR(10), whoDelete VARCHAR(10))
BEGIN
	IF (SELECT COUNT(*) FROM Staff WHERE ID = whoDelete)
	THEN DELETE FROM User WHERE ID = delID;
    END IF;
END;
// DELIMITER ;