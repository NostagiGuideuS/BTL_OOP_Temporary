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