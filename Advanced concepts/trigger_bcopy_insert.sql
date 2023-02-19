CREATE DEFINER=`root`@`localhost` TRIGGER `book_AFTER_INSERT` AFTER INSERT ON `book` FOR EACH ROW BEGIN
	insert into bcopy values(1, new.bookid, 'available');
END