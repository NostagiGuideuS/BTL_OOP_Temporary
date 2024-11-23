
DROP TRIGGER IF EXISTS genMemberID;
DROP TRIGGER IF EXISTS genStaffID;
DELIMITER //
CREATE TRIGGER genStaffID
BEFORE INSERT ON Staff
FOR EACH ROW
BEGIN
	INSERT INTO User(ID) VALUES (new.ID);
    INSERT INTO Login(ID, password, Role) VALUES (new.ID, new.ID, 'Staff');
END;
// DELIMITER ;

DELIMITER //
CREATE TRIGGER genMemberID
BEFORE INSERT ON Member
FOR EACH ROW
BEGIN
	INSERT INTO User(ID) VALUES (new.ID);
    INSERT INTO Login(ID, password, Role) VALUES (new.ID, new.ID, 'Member');
END;
// DELIMITER ;

/*
*
*
*
*/

DROP TRIGGER IF EXISTS genRequestID;

DELIMITER //
CREATE TRIGGER genRequestID
BEFORE INSERT ON Request
FOR EACH ROW
BEGIN
	DECLARE newMonth INT;
    DECLARE month_prefix CHAR(3);
    DECLARE count INT;
    
    SET newMonth = MONTH(NEW.borrowDate);
    
    SET month_prefix = CASE newMonth
        WHEN 1 THEN 'Jan' WHEN 2 THEN 'Feb'
        WHEN 3 THEN 'Mar' WHEN 4 THEN 'Apr'
        WHEN 5 THEN 'May' WHEN 6 THEN 'Jun'
		WHEN 7 THEN 'Jul' WHEN 8 THEN 'Aug'
        WHEN 9 THEN 'Sep' WHEN 10 THEN 'Oct'
        WHEN 11 THEN 'Nov' WHEN 12 THEN 'Dec'
    END;
    
    SET count = (SELECT COUNT(*) + 1 FROM Request WHERE MONTH(borrowDate) = newMonth);
    
    SET NEW.requestID = CONCAT(YEAR(NEW.borrowDate), month_prefix, count);
END;
// DELIMITER ;

/*
*
*
*
*/

DROP TRIGGER IF EXISTS makeQuantityLeft;
DROP TRIGGER IF EXISTS makeFileSlot;
DROP TRIGGER IF EXISTS minusQuantityLeft;
DROP TRIGGER IF EXISTS plusQuantityLeft;

DELIMITER //
CREATE TRIGGER makeQuantityLeft
BEFORE INSERT ON Documents
FOR EACH ROW
BEGIN
    SET NEW.quantityLeft = NEW.totalQuantity;
END;
// DELIMITER ;

DELIMITER //
CREATE TRIGGER makeFileSlot
AFTER INSERT ON Documents
FOR EACH ROW
BEGIN
    INSERT INTO storedDocument (ID) VALUES (NEW.ID);
END;
// DELIMITER ;

DELIMITER //
CREATE TRIGGER minusQuantityLeft
BEFORE INSERT ON Request
FOR EACH ROW
BEGIN
    -- Cập nhật lại số lượng tồn kho sau khi mượn sách
    IF new.returnDate is null THEN
		UPDATE Documents
		SET quantityLeft = quantityLeft - NEW.quantityBorrow
		WHERE ID = NEW.documentID;
    END IF;
END;
// DELIMITER ;

DELIMITER //
CREATE TRIGGER plusQuantityLeft
BEFORE UPDATE ON Request
FOR EACH ROW
BEGIN
    UPDATE Documents
    SET quantityLeft = quantityLeft + NEW.quantityBorrow - OLD.quantityBorrow
    WHERE ID = NEW.documentID;
END;
// DELIMITER ;