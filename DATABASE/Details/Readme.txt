##About Request
+ borrowDocument 		
	(userID VARCHAR(10), documentID VARCHAR(10), borrowQuantity INT)
 -> 'result' = true/false

+ returnDocument 
	(requestID VARCHAR(15), userID VARCHAR(10))
 -> 'result' = true/false

+ checkForUnreturn_DocumentList
	(userID VARCHAR(10))

+ checkForUnreturn_StudentList
	(documentID VARCHAR(10))
+ checkForHistory_DocumentList
	(userID VARCHAR(10))


##About add-delete User
+ addMember (
	newMemberID  	VARCHAR(10),
    	firstName  	VARCHAR(50),
    	lastName  	VARCHAR(50),
    	contact  	VARCHAR(50),
    	dateOfBirth  	DATE)
 -> return <Result = false> if duplicate userID 

+ addStaff (
	newStaffID  	VARCHAR(10),
	firstName  	VARCHAR(50),
    	lastName  	VARCHAR(50),
    	contact  	VARCHAR(50),
    	jobTitle  	VARCHAR(20),
    	reportToID  	VARCHAR(10))
 -> return <Result = false> if duplicate userID 

+ deleteUser (
	delUserID  	VARCHAR(10),
	staffWhoDeleteThisUser  VARCHAR(10))


##About add-delete Document
+ addBook (
	newISBN  	VARCHAR(15),
    	title  		VARCHAR(50),
    	author  	VARCHAR(50),
	storedQuantity  INT(5),
    	category  	INT,
	descrip[tion	TEXT,
    	publisher  	VARCHAR(50),
    	releaseYear  	YEAR
 -> return <Result = false> if duplicate ISBN 

+ addThesis ( 
	newThesisID 	VARCHAR(15),
    	Title 		VARCHAR(50),
    	writerID 	VARCHAR(10),
    	advisor 	VARCHAR(50),
    	fieldOfStudy 	VARCHAR(50),
    	Desciption 	VARCHAR(100),
	storedQuantity 	INT(5)
	category	INT
 -> return <Result = false> if duplicate ThesisID

+ loadMoreDocumentCopies (
	documentID 	VARCHAR(15), 
	quantityChange 	INT, 
	staffWhoDid 	NVARCHAR(10))

+ deleteDocument (
	delDocumentID 	VARCHAR(15), 
	staffWhoDelete 	NVARCHAR(10))


##Search and Get Info
+ getMemberInfo ( userID )
	-> 1. ID, 
	   2. firstName,
	   3. lastName, 
	   4. contact,
	   5. dateOfBirth

+ getStaffInfo ( userID )
	-> 1. ID, 
	   2. firstName,
	   3. lastName, 
	   4. contact,
	   5. jobTitle
	   6. introducerID (like some kind of manager)

+ searchBook ( title '', author '', releaseYear <null>, category <null> )
	-> 1. ISBN
	   2. title
	   3. quantityAvailable
	   4. author
	   5. publisher
	   6. releaseYear
	   7. description
	   8. category

+ searchThesis ( title '', fieldOfStudy '', writerID <null>, advisor '' )
	-> 1. ID
	   2. title
	   3. quantityAvailable
	   4. writerID
	   5. advisor
	   6. fieldOfStudy
	   7. Description
	   8. category

+ searchDocument ( documentID )
	-> 1-8 usual
	   9. genre (Book / Thesis)

##About Login and Password
+ login ( ID, password)
	-> 1. Role (Staff, Member) hoặc NULL if(incorrect)
	   2. firstTry = true/false hoặc NULL if(incorrect)

+ changePassword ( ID, oldPass, newPass)
	-> 1. Result (1/0)
