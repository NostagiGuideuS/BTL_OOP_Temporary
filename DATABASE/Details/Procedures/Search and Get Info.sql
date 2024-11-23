DROP PROCEDURE IF EXISTS getMemberInfo;
DELIMITER //
CREATE PROCEDURE getMemberInfo (IN findID VARCHAR(10))
BEGIN
	SELECT ID, firstName, lastName, contact, dateOfBirth 
    FROM Member 
    WHERE ID = findID;
END;
// DELIMITER ;

DROP PROCEDURE IF EXISTS getStaffInfo;
DELIMITER //
CREATE PROCEDURE getStaffInfo (IN findID VARCHAR(10))
BEGIN
	SELECT ID, firstName, lastName, contact, jobTitle, reportToID
    FROM Staff
    WHERE ID = findID;
END;
// DELIMITER ;

-- DROP PROCEDURE IF EXISTS searchMember;
-- DELIMITER //
-- CREATE PROCEDURE searchMember (IN findID VARCHAR(10), findName VARCHAR(50), findContact VARCHAR(50), findDateOfBirht DATE)
-- BEGIN
-- 	SELECT ID, firstName, lastName, contact, dateOfBirth 
--     FROM Member 
--     WHERE ID = CONCAT(findID, '%')
--     AND ;
-- END;
-- // DELIMITER ;

DROP PROCEDURE IF EXISTS searchThesis;
DELIMITER //
CREATE PROCEDURE searchThesis (IN 
	titleKey VARCHAR(50),
    fieldOfStudyKey VARCHAR(50),
    byWriterID VARCHAR(10),
    byAdvisor VARCHAR(50)
)
BEGIN
	SELECT 
		thesis.ID AS ID,
		documents.title AS title,
		documents.quantityLeft AS quantityAvailable,
		thesis.writerID AS writerID,
		thesis.advisor AS advisor,
		thesis.fieldOfStudy AS fieldOfStudy,
		documents.Description AS Description,
		documents.category AS category
	FROM thesis left join documents using(ID)
    WHERE (byWriterID IS NULL OR thesis.writerID = byWriterID)
	AND (byAdvisor IS NULL OR thesis.advisor LIKE CONCAT('%', byAdvisor, '%'))
	AND (titleKey IS NULL OR documents.title LIKE CONCAT('%', titleKey, '%'))
	AND (fieldOfStudyKey IS NULL OR thesis.fieldOfStudy LIKE CONCAT('%', fieldOfStudyKey, '%'));

END;
// DELIMITER ;


DROP PROCEDURE IF EXISTS searchBook;
DELIMITER //
CREATE PROCEDURE searchBook (IN 
	titleKey VARCHAR(50),
    authorKey VARCHAR(50),
    releaseYearKey YEAR,
    categoryKey INT unsigned
)
BEGIN
	SELECT 
		books.ISBN AS ISBN,
		documents.title AS title,
		documents.quantityLeft AS quantityAvailable,
		books.author AS author,
		books.publisher AS publisher,
		books.releaseYear AS releaseYear,
		documents.Description AS Description,
		documents.category AS category
	FROM books left join documents ON (books.isbn = documents.ID)
	WHERE ((titleKey is null) OR (documents.title LIKE CONCAT('%', titleKey, '%')))
    AND ((authorKey is null) OR (books.author LIKE CONCAT('%', authorKey, '%')))
    AND ((releaseYearKey is null) OR (books.releaseYear = releaseYearKey))
    AND ((categoryKey is null) OR (documents.category = categoryKey));
END;
// DELIMITER ;


DROP PROCEDURE IF EXISTS searchDocument;
DELIMITER //
CREATE PROCEDURE searchDocument (IN documentID VARCHAR(15))
BEGIN
	IF (SELECT COUNT(*) FROM Documents WHERE ID = documentID) > 0
	THEN
		IF (SELECT genre FROM Documents WHERE ID = documentID) = 'Book'
		THEN
			SELECT 
				books.ISBN AS ISBN,
				documents.title AS title,
				documents.quantityLeft AS quantityAvailable,
				books.author AS author,
				books.publisher AS publisher,
				books.releaseYear AS releaseYear,
				documents.Description AS Description,
				books.category AS category,
                documents.genre AS genre
			FROM books left join documents ON (books.isbn = documents.ID)
			WHERE books.isbn = documentID;
		ELSE
			SELECT 
				thesis.ID AS ID,
				documents.title AS title,
				documents.quantityLeft AS quantityAvailable,
				thesis.writerID AS writerID,
				thesis.advisor AS advisor,
				thesis.fieldOfStudy AS fieldOfStudy,
				documents.Description AS Description,
				documents.category AS category,
                documents.genre AS genre
			FROM thesis left join documents using(ID)
			WHERE thesis.ID = documentID;
		END IF;
	END IF;
END;
// DELIMITER ;