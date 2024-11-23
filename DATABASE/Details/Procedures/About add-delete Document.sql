
DROP PROCEDURE IF EXISTS addBook;
DELIMITER //
CREATE PROCEDURE addBook (IN 
	newISBN VARCHAR(15),
    newTitle VARCHAR(50),
    theAuthor VARCHAR(50),
	storedQuantity INT unsigned,
    newCategory INT unsigned,
    newDescription TEXT,
    thePublisher VARCHAR(50),
    theReleaseYear YEAR
)
BEGIN
	IF (SELECT COUNT(*) From Documents WHERE ID = newISBN) = 0
    
	THEN 
		INSERT INTO Documents (ID, Title, genre, totalQuantity, Description, category) 
			VALUES (newISBN, newTitle, 'Book', storedQuantity, newDescription, newCategory);
		INSERT INTO Books (ISBN, author, publisher, releaseYear) 
			VALUES (newISBN, theAuthor, thePublisher, theReleaseYear);
		SELECT true as Result;
        
	ELSE 
		SELECT false as Result; -- if the ID already exists
    END IF;
END;
// DELIMITER ;


DROP PROCEDURE IF EXISTS addThesis;
DELIMITER //
CREATE PROCEDURE addThesis (IN 
	newID VARCHAR(15),
    newTitle VARCHAR(50),
    theWriterID VARCHAR(10),
    theAdvisor VARCHAR(50),
    newFieldOfStudy VARCHAR(50),
    newDescription TEXT,
	storedQuantity INT unsigned,
    newCategory INT unsigned
)
BEGIN
	IF (SELECT COUNT(*) From Documents WHERE ID = newID) = 0
    
	THEN 
		INSERT INTO Documents (ID, Title, genre, totalQuantity, Description, category) 
			VALUES (newID, newTitle, 'Thesis', storedQuantity, newDescription, newCategory);
		INSERT INTO Thesis (ID, writerID, advisor, fieldOfStudy)
			VALUES (newID, theWriterID, theAdvisor, newFieldOfStudy);
		SELECT true as Result;
        
	ELSE 
		SELECT false as Result; -- if the ID already exists
    END IF;
END;
// DELIMITER ;


DROP PROCEDURE IF EXISTS loadMoreDocumentCopies;
DELIMITER //
CREATE PROCEDURE loadMoreDocumentCopies (IN documentID VARCHAR(15), quantityChange INT ,staffWhoDid VARCHAR(10))
BEGIN
	IF (SELECT COUNT(*) FROM Staff WHERE ID = staffWhoDid) <> 0
	THEN 
		UPDATE Documents
        SET totalQuantity = totalQuantity + quantityChange,
			quantityLeft = quantityLeft + quantityChange
        WHERE ID = documentID;
    END IF;
END;
// DELIMITER ;

DROP PROCEDURE IF EXISTS loadDocumentCover;
DELIMITER //
CREATE PROCEDURE loadDocumentCover (IN documentID VARCHAR(10), newCover BLOB)
BEGIN
	UPDATE storeddocument 
    SET cover = newCover
    WHERE ID = documentID;
END;
// DELIMITER ;

DROP PROCEDURE IF EXISTS loadDocumentPDF;
DELIMITER //
CREATE PROCEDURE loadDocumentPDF (IN documentID VARCHAR(10), newPDF MEDIUMBLOB)
BEGIN
	UPDATE storeddocument 
    SET PDF = newPDF
    WHERE ID = documentID;
END;
// DELIMITER ;


DROP PROCEDURE IF EXISTS deleteDocument;
DELIMITER //
CREATE PROCEDURE deleteDocument (IN delDocumentID VARCHAR(15), whoDelete VARCHAR(10))
BEGIN
	IF (SELECT COUNT(*) FROM Staff WHERE ID = whoDelete) <> 0
	THEN 
		DELETE FROM Documents WHERE ID = delDocumentID;
    END IF;
END;
// DELIMITER ;