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

