DROP DATABASE IF EXISTS Library_2nd_Edition;
CREATE DATABASE Library_2nd_Edition;

use Library_2nd_Edition;

CREATE TABLE User (
	ID VARCHAR(10),
    
    primary key (ID)
);

CREATE TABLE Login (
	ID VARCHAR(10),
    password VARCHAR(30),
    Role ENUM('Staff', 'Member'),
    
    primary key (ID),
    foreign key (ID) references User(ID) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Member (
	ID VARCHAR(10),
    firstName VARCHAR(50) NOT NULL,
    lastName VARCHAR(50) NOT NULL,
    contact VARCHAR(50) NOT NULL,
    dateOfBirth DATE NOT NULL,
    
    primary key (ID),
    foreign key (ID) references User(ID) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Staff (
	ID VARCHAR(10),
    firstName VARCHAR(10) NOT NULL,
    lastName VARCHAR(20) NOT NULL,
    contact VARCHAR(50) NOT NULL,
    jobTitle VARCHAR(20),
    reportToID VARCHAR(10),
    
    primary key (ID),
    foreign key (ID) references User(ID) ON UPDATE CASCADE ON DELETE CASCADE,
    foreign key (reportToID) references Staff(ID) ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE Documents (
	ID VARCHAR(15),
    Title VARCHAR(50) not null,
    genre ENUM('Thesis', 'Book') not null,
    totalQuantity INT unsigned not null,
    quantityLeft INT unsigned not null,
	Description TEXT,
	category INT unsigned,
    
    primary key (ID)
);

CREATE TABLE Books (
	ISBN VARCHAR(15),
    author VARCHAR(50) NOT NULL,
    publisher VARCHAR(50),
    releaseYear YEAR,
    
    primary key (ISBN),
    foreign key (ISBN) references Documents(ID) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Thesis (
	ID VARCHAR(15),
	writerID VARCHAR(10),
    advisor VARCHAR(50),
    fieldOfStudy VARCHAR(50),
    
    primary key (ID),
    foreign key (ID) references Documents(ID) ON UPDATE CASCADE ON DELETE CASCADE,
    foreign key (writerID) references User(ID) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE storedDocument (
	ID VARCHAR(15),
	Cover BLOB,
	PDF MEDIUMBLOB,
     
	primary key (ID),
	foreign key (ID) references Documents(ID) ON UPDATE CASCADE ON DELETE CASCADE
);


CREATE TABLE Request (
	requestID VARCHAR(20),
    userID VARCHAR(10),
    documentID VARCHAR(15),
    quantityBorrow INT unsigned,
    borrowDate DATE not null,
    returnDate DATE,
    
    primary key (requestID),
    foreign key (userID) references User(ID) ON UPDATE CASCADE ON DELETE CASCADE,
    foreign key (documentID) references Documents(ID) ON UPDATE CASCADE ON DELETE CASCADE
);


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

use library_2nd_edition;

SET SQL_SAFE_UPDATES = 0;
-- DELETE FROM Documents;
DELETE FROM Documents;
DELETE FROM User;
SET SQL_SAFE_UPDATES = 1;


-- Thêm 3 Member
CALL addMember('M001', 'Nguyen', 'An', '0901234567', '2000-05-01');
CALL addMember('M002', 'Le', 'Binh', '0912345678', '1999-09-10');
CALL addMember('M003', 'Tran', 'Chi', '0923456789', '1998-12-20');


-- Thêm 1 Staff
CALL addStaff('S001', 'Pham', 'Tien', '0934567890', 'Manager', NULL);



-- Thêm 10 Books
CALL addBook('9781234567890', 'The Adventure of Sherlock Holmes', 'Arthur Conan Doyle', 10, 1, 'A collection of detective stories', 'Penguin', 1892);
CALL addBook('9781234567891', 'The Great Gatsby', 'F. Scott Fitzgerald', 15, 1, 'A classic novel set in the Jazz Age', 'Scribner', 1925);
CALL addBook('9781234567892', '1984', 'George Orwell', 20, 1, 'Dystopian novel about totalitarian regime', 'Secker & Warburg', 1949);
CALL addBook('9781234567893', 'Moby-Dick', 'Herman Melville', 12, 1, 'A narrative of Captain Ahab’s obsession with a white whale', 'Harper & Brothers', 1851);
CALL addBook('9781234567894', 'Pride and Prejudice', 'Jane Austen', 8, 1, 'A romantic novel about manners and marriage', 'T. Egerton', 1813);
CALL addBook('9781234567895', 'War and Peace', 'Leo Tolstoy', 25, 1, 'A historical novel set during the Napoleonic Wars', 'The Russian Messenger', 1869);
CALL addBook('9781234567896', 'The Catcher in the Rye', 'J.D. Salinger', 5, 1, 'A novel about teenage rebellion and identity', 'Little, Brown and Company', 1951);
CALL addBook('9781234567897', 'To Kill a Mockingbird', 'Harper Lee', 30, 1, 'A novel about racial injustice in the American South', 'J.B. Lippincott & Co.', 1960);
CALL addBook('9781234567898', 'The Hobbit', 'J.R.R. Tolkien', 40, 1, 'A fantasy novel about Bilbo Baggins’ adventure', 'George Allen & Unwin', 1937);
CALL addBook('9781234567899', 'The Odyssey', 'Homer', 7, 1, 'Epic poem about the adventures of Odysseus', 'Various', 800);
CALL addBook('9781234567900', 'Dế Mèn Phiêu Lưu Ký', 'Tô Hoài', 10, 1, 'Cuốn sách kể về cuộc phiêu lưu của Dế Mèn', 'Nhà xuất bản Kim Đồng', 1941);
    CALL addBook('9781234567901', 'Số Đỏ', 'Vũ Trọng Phụng', 12, 1, 'Cuốn tiểu thuyết hài hước về xã hội Việt Nam thời kỳ cận đại', 'Nhà xuất bản Phụ Nữ', 1936);
	CALL addBook('9781234567902', 'Những Người Bạn', 'Nguyễn Minh Châu', 15, 1, 'Tập truyện ngắn về các mối quan hệ con người trong xã hội Việt Nam', 'Nhà xuất bản Văn học', 1984);
    CALL addBook('9781234567903', 'Chí Phèo', 'Nam Cao', 8, 1, 'Tiểu thuyết nổi tiếng về cuộc đời và số phận của Chí Phèo', 'Nhà xuất bản Văn học', 1941);

-- Thêm 3 Thesis
CALL addThesis('T001', 'Research on Quantum Computing', 'M001', 'Dr. Nguyen', 'Computer Science', 'Exploring the future of computing using quantum principles', 3, 1);
CALL addThesis('T002', 'Advanced Machine Learning Algorithms', 'M002', 'Dr. Le', 'Computer Science', 'Study of advanced algorithms in machine learning', 2, 1);
CALL addThesis('T003', 'The Role of AI in Healthcare', 'M003', 'Dr. Tran', 'Healthcare', 'Exploring how artificial intelligence can transform healthcare systems', 5, 1);
	CALL addThesis('T004', 'Nghiên cứu về trí tuệ nhân tạo trong y tế', 'M001', 'TS. Nguyễn Văn A', 'Công nghệ thông tin', 'Nghiên cứu ứng dụng AI trong y tế, đánh giá hiệu quả trong điều trị bệnh', 4, 1);
	CALL addThesis('T005', 'Phát triển phần mềm quản lý dữ liệu lớn', 'M002', 'TS. Trần Thị B', 'Công nghệ phần mềm', 'Nghiên cứu các phương pháp phát triển phần mềm cho hệ thống xử lý dữ liệu lớn', 3, 1);