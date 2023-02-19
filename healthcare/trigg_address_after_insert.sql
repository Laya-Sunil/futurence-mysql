CREATE DEFINER=`root`@`localhost` TRIGGER `address_AFTER_INSERT` AFTER INSERT ON `address` FOR EACH ROW BEGIN
	IF (NEW.city NOT IN (SELECT placeName FROM placesAdded WHERE placeType='city')) THEN
		INSERT INTO placesAdded(placeName, placeType) VALUES (NEW.city,'city');
	
    ELSEIF (NEW.state NOT IN (SELECT placeName FROM placesAdded WHERE placeType='state')) THEN
		INSERT INTO placesAdded(placeName, placeType) VALUES (NEW.state,'state');
	
    ELSE
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='**Error !! Record Insertion Failed in placesAdded Table**';
	END IF;
END