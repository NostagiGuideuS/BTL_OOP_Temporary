User abstract
# ID String
# firstName String
# lastName String

?+ login (userID String, password String) loginAlert
+ changeOwnPassword(oldPassword String, newPassword String) boolean
+ firstLogInChangePassword(String newPassword) boolean

+ borrowDocument (documentID String) boolean
?+ returnDocument (requestID String) boolean
+ getMyUnreturnDocument () ArrayList<Request>
+ getMyBorrowHistory () ArrayList<Request>

+ getter/ setter

------------------------------------------

Member extends User
# contact String
# dateOfBirth String 	// format "YYYY-MM-DD"

+ Member (ID String, firstName String, lastName String, contact String, dateOfBirth String)

+ Member (ID String)
// controller chỉ dùng contructor này này

+ getter/ setter

------------------------------------------

Staff extends User
# contact String
# jobTitle String
# introducerID		// hiểu là manager cũng được

+ Staff (ID String, firstName String, lastName String)
+ Staff (ID String, firstName String, lastName String, contact String, jobTitle String, introducerID String)

+ Staff (ID String)
// controller chỉ dùng cái này

+ getUserInfo (ID String) User
+ getMemberInfo (ID String) Member
+ getStaffInfo (ID String) Staff

+ addNewMember (ID String, firstName String, lastName String, contact String, dateOfBirth String) boolean
+ addNewMember (newOne Member) boolean
+ addNewStaff (ID String, firstName String, lastName String, contact String, jobTitle String) boolean
+ deleteUser (ID String)

+ addDocument (newDocument Document) boolean
+ addBook (newBook Book) boolean
+ addThesis (newThesis Thesis) boolean
+ deleteDocument (documentId String) boolean
?+ loadMoreCopies (String documentID, quantityChange) boolean

+ getUnreturnDocument (userID String) ArrayList<Request> 
+ getBorrowHistory (userID String) ArrayList<Request>
+ getUserBorrowThisDocument (documentID String) ArrayList<Request>

+ getter/ setter

------------------------------------------

Document abstract
# ID String
# title String
# availableCopies int
# category ArrayList<String>
# description String

+ searchDocument (keyword String) ArrayList<Document>
+ getDocumentInfo (documentID String) Document

+ getter/ setter

------------------------------------------

Book extends Document
# author String
# publisher String
# releaseYear int

# Book (ISBN String, title String, author String, publisher String, releaseYear int, category List<String>)
+ Book (documentID String)
// controller chỉ dùng cái này

*+ searchBook (title String, author String, releaseYear int???,  List<String> category???) ArrayList<Book>

+ getter/ setter

------------------------------------------

Thesis extends Document
# writerID String
# advisor String
# fieldOfStudy String

# Thesis (ID String, title String, writerID String, advisor String, fieldOfStudy String, description String, availableCopies int)
+ Thesis (documentID String)

+ searchThesis(titleKeyword String, fieldOfStudyKeyword String, writerID String, advisor String) ArrayList<Thesis> 

+ getter/ setter

------------------------------------------

Request
- requestID String
- userID String
- documentID String
- quantityBorrow int
- borrowDate String	// format: "YYYY-MM-DD"
- returnDate String

Request (requestID String, userID String, documentID String, quantityBorrow int, borrowDate String, returnDate String)

+ getter/ setter
// Không có gì
