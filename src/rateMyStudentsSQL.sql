-- phpMyAdmin SQL Dump
-- version 4.9.2
-- https://www.phpmyadmin.net/
--
-- Host: classmysql.engr.oregonstate.edu:3306
-- Generation Time: Dec 11, 2019 at 09:55 PM
-- Server version: 10.3.13-MariaDB-log
-- PHP Version: 7.0.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `cs340_marquezi`
--

-- --------------------------------------------------------

--
-- Table structure for table `Class`
--

CREATE TABLE `Class` (
  `name` varchar(50) NOT NULL,
  `course_id` int(11) NOT NULL,
  `department` varchar(50) NOT NULL,
  `username` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `Class`
--

INSERT INTO `Class` (`name`, `course_id`, `department`, `username`) VALUES
('Analysis of Algorithms', 10293, 'Computer Science', 'owenhildebrand'),
('Advanced Hypnosis', 28203, 'Psychology', 'rodneybackstrap'),
('Differential Calculus', 38473, 'Math', 'bobstratton'),
('Integral Calculus', 39485, 'Math', 'bobstratton'),
('Introduction to Basket Weaving', 48374, 'Art', 'olgabaggins'),
('Biology 1', 50828, 'Biology', 'budwilkum'),
('Botany 2', 57482, 'Botany', 'jessicahicks'),
('American History', 58749, 'History', 'gunnerbrian'),
('Introduction to Databases', 79548, 'Computer Science', 'ottoockstrab'),
('Introduction to Binge Watching', 86735, 'Entertainment', 'donaldgoose');

-- --------------------------------------------------------

--
-- Table structure for table `has`
--

CREATE TABLE `has` (
  `season` varchar(10) NOT NULL,
  `year` int(11) NOT NULL,
  `course_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `has`
--

INSERT INTO `has` (`season`, `year`, `course_id`) VALUES
('Summer', 2017, 38473),
('Summer', 2017, 39485),
('Summer', 2017, 57482),
('Summer', 2017, 58749),
('Winter', 2018, 10293),
('Winter', 2018, 28203),
('Winter', 2018, 48374),
('Winter', 2018, 86735),
('Winter', 2019, 28203),
('Winter', 2019, 39485);

-- --------------------------------------------------------

--
-- Table structure for table `Professor`
--

CREATE TABLE `Professor` (
  `email` varchar(50) NOT NULL,
  `password` varchar(250) NOT NULL,
  `username` varchar(50) NOT NULL,
  `name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `Professor`
--

INSERT INTO `Professor` (`email`, `password`, `username`, `name`) VALUES
('admin@yahoo.com', '$2b$10$ldlfV8esgzV1xfqWWvAHb.REsfZJxjGNO8kSKh9jkB1pArPenIH/m', 'admin', 'admin'),
('bobstratton@oregonstate.edu', '$2b$10$R.yDpaUBCbJeAw7qtsZ4X.ulARSpl26vG1G6BpU.suBGNsliDQ/hO', 'bobstratton', 'Bob Stratton'),
('budwilkum@oregonstate.edu', '$2b$10$HB4W/zpfXWYMrOwyf1aH3ebzX/DWgxupfyYdx/kaVEsiOiSKny.AS', 'budwilkum', 'Bud Wilkum'),
('generic@email.com', '$2b$10$60RwijQNEzBa2usL31QhvejWW9spjbCq2P.uvSVUx1yUE33xuv0Ry', 'dick ', 'corey nielsen'),
('donaldgoose@oregonstate.edu', '$2b$10$EAZ3Jks0mI1Hh9a0x8WXaOXY1ApP7foH0paVp/dIQ/qs22iE8vpGe', 'donaldgoose', 'Donald Goose'),
('gunnerbrian@oregonstate.edu', '$2b$10$otjpl989.843ECMcENVSeekJmszq4D4TpzK.ffUakAFDY06MfCjgi', 'gunnerbrian', 'Gunner Brian'),
('jessicahicks@oregonstate.edu', '$2b$10$Lm6VLUuRQs4vXt95UrMK8.8NRAvAPgePgVovKX.bJr2XoultAmAWC', 'jessicahicks', 'Jessica Hicks'),
('martymcflyby@oregonstate.edu', '$2b$10$UZBfGGKgnFdJ74H4aJkfkusxMUgE8wLQYT.JuiVMkhGm/aBZCRroy', 'martymcflyby', 'Marty McFlyby'),
('olgabaggins@oregonstate.edu', '$2b$10$IMYNKjfFz8oVYwbhB.SUZexryzWyVNtHgTmcYFl/FnY/nEw0VYjsK', 'olgabaggins', 'Olga Baggins'),
('ottoockstrab@oregonstate.edu', '$2b$10$yCtL1NhLerjX26Pk2YFz1.C2U4b/82B1993uPKO1SiSK3um9Yz1Qa', 'ottoockstrab', 'Otto Ockstrab'),
('owenhildebrand@oregonstate.edu', '$2b$10$pYsm7FsBGBDYIQrPzDtfRe77cY0YZZwK1tdE7Xpse9sXzMRHuKoPO', 'owenhildebrand', 'Owen Hildebrand'),
('rodneybackstrap@oregonstate.edu', '$2b$10$09J3Fz/pj6JiFvEridERtuHGzFr9YyibKrVCvZjHCJpflbLP97cRW', 'rodneybackstrap', 'Rodney Backstrap'),
('samw@yahoo.com', '$2b$10$mM4wXHw535HMbn/sXdhR1uoa4EG48QwoD2J9aGpWz7lz7haObytsS', 'samw', 'Sam Wilson');

--
-- Triggers `Professor`
--
DELIMITER $$
CREATE TRIGGER `Verify username is valid` BEFORE INSERT ON `Professor` FOR EACH ROW BEGIN

declare msg varchar(128);
	IF EXISTS(SELECT * FROM Professor WHERE NEW.username=username) THEN
    	
        set msg = '*Username Taken';
        signal sqlstate '45000' set MESSAGE_TEXT = msg;
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `Rating`
--

CREATE TABLE `Rating` (
  `comment` varchar(280) DEFAULT NULL,
  `number_scale` int(11) NOT NULL,
  `submissionID` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `course_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `Rating`
--

INSERT INTO `Rating` (`comment`, `number_scale`, `submissionID`, `student_id`, `course_id`) VALUES
('Very disciplined student. Would show up and never acted out once, however he seemed to like to go off and do other stuff during work time. ', 125, 29838, 98444, 28203),
('The score speaks for itself.', 233, 69776, 832932, 38473),
('Well disciplined student, who asked a lot of questions. This kid is gonna go far in life', 210, 178413, 98444, 86735),
('Adequate student. I do have to say, I do not know how he is in high school. He looks about 10, but nevertheless he acts like a pretentious 30 year old. ', 58, 188222, 391912, 48374),
('I\'d rather jump off a bridge than have another class with her.', 7, 247807, 84842, 10293),
('Great student who knows there way around the course work.  First round pick for sure. ', 156, 357989, 182932, 10293),
('I have read other reviews on this student from other teachers. And I have to say I completely agree with their assessment, this person is the worst student I have ever had.', 10, 359730, 398399, 38473),
('What an amazing student. A little old fashion, but shows up and does his work. And with his great grades, it reflects on me greatly :).', 209, 388191, 881041, 86735),
('Would 100% have this student again in my class. So funny, caring and understanding. Takes full advantage of office hours, and wants to learn. So awesome.', 215, 392842, 422892, 57482),
('Showed up to almost all the classes. I always take that as a plus, due to my internal fear of being ousted by my students as a bad teacher.', 172, 409807, 222888, 50828),
('This man has some problems, like some deep rooted problems he should see a therapist for. ', 50, 417404, 832932, 86735),
('Interesting kid, but like not the good interesting. Interesting, as in the use of the word in the context of explaining someone who they think is weird and annoying, but don\'t want to hurt that persons feelings. ', 90, 502035, 391912, 28203),
('Your average student who shows up and does their work, and gets average grades. A great filler to add to your list for this upcoming term. ', 130, 524173, 881041, 39485),
('Solid student, however it seemed like he already had extensive knowledge on computers.', 200, 593028, 182932, 79548),
('Surprising has a strong perception of high level math concepts. Loved having her in class', 189, 621633, 84842, 38473),
('Great student, would recommend for future courses', 210, 656206, 983411, 48374),
('Well behaved student who will show up on time and get good grades. ', 233, 669248, 98444, 50828),
('He\'s perfect.', 169, 765432, 983411, 58749),
('I\'ve had better.', 68, 765879, 182932, 38473),
('Sweet kid, but played on his phone all class, so had to give him a failing grade. ', 50, 781462, 422892, 39485),
('I have had this guy in multiple of my classes, and his knowledge of computers is astounding. I would very much wish to have him in my class again.', 180, 843580, 182932, 57482),
('Student was mind blowingly awesome.', 64, 864686, 222888, 39485),
('Quite an abysmal student.Always would spend the time tweeting instead of paying attention. And one time he stood up in class and declared,\"Sorry losers and haters, but my I.Q. is one of the highest -and you all know it! Please don\'t feel so stupid or insecure,it\'s not your fault\"', 7, 891737, 398399, 57482),
('Was a decent student, but showed up late on multiple occasions. ', 143, 915529, 222888, 28203),
('I don\'t know what weird, isolated town produced this thing. However, I do have to admit he got good grades and always showed up for lab, so I gave him a high score.', 198, 917802, 983411, 79548),
('This little man needs to be kicked out of our fine establishment as soon as possilbe, his attitude and care free nature should not be supported.', 45, 974055, 391912, 58749),
('This student was a little socially awkward, and occasionally spoke out of turn. However, the humor he brought to the class lighten the mood so that I could give out harsher grades without them knowing. ', 56, 1080909, 832932, 48374);

--
-- Triggers `Rating`
--
DELIMITER $$
CREATE TRIGGER `check that class exist` BEFORE INSERT ON `Rating` FOR EACH ROW BEGIN

declare msg varchar(128);
	IF NOT EXISTS(SELECT * FROM Class WHERE NEW.course_id = course_id) THEN
    	
        set msg = '*Course does not exist in database';
        signal sqlstate '45000' set MESSAGE_TEXT = msg;
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `check that student exists` BEFORE INSERT ON `Rating` FOR EACH ROW BEGIN

declare msg varchar(128);
	IF NOT EXISTS(SELECT * FROM Student WHERE NEW.student_id = student_id) THEN
    	
        set msg = '*Student does not exist in database';
        signal sqlstate '45000' set MESSAGE_TEXT = msg;
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `make sure not a duplicate submission` BEFORE INSERT ON `Rating` FOR EACH ROW BEGIN

declare msg varchar(128);
	IF EXISTS(SELECT * FROM Rating WHERE NEW.student_id=student_id AND NEW.course_id=course_id) THEN
    	
        set msg = '*Duplicate entry for given student';
        signal sqlstate '45000' set MESSAGE_TEXT = msg;
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `Student`
--

CREATE TABLE `Student` (
  `student_id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `Student`
--

INSERT INTO `Student` (`student_id`, `name`) VALUES
(84842, 'Martha Stewart '),
(98444, 'Nobuske Tagomi'),
(182932, 'Linus Torvalds'),
(222888, 'Tom Hanks'),
(391912, 'Timmy Turner'),
(398399, 'Donald Trump'),
(422892, 'Alan Turing'),
(832932, 'Micheal Scott'),
(881041, 'Paul Revere'),
(983411, 'Fredrick Douglas');

-- --------------------------------------------------------

--
-- Table structure for table `takes`
--

CREATE TABLE `takes` (
  `course_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `takes`
--

INSERT INTO `takes` (`course_id`, `student_id`) VALUES
(10293, 98444),
(28203, 422892),
(28203, 881041),
(38473, 391912),
(48374, 398399),
(50828, 182932),
(57482, 222888),
(58749, 84842),
(79548, 983411),
(86735, 832932);

-- --------------------------------------------------------

--
-- Table structure for table `Term`
--

CREATE TABLE `Term` (
  `year` int(11) NOT NULL,
  `Season` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `Term`
--

INSERT INTO `Term` (`year`, `Season`) VALUES
(2017, 'Fall'),
(2017, 'Summer'),
(2018, 'Fall'),
(2018, 'Spring'),
(2018, 'Summer'),
(2018, 'Winter'),
(2019, 'Fall'),
(2019, 'Spring'),
(2019, 'Summer'),
(2019, 'Winter');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `Class`
--
ALTER TABLE `Class`
  ADD PRIMARY KEY (`course_id`),
  ADD KEY `username` (`username`);

--
-- Indexes for table `has`
--
ALTER TABLE `has`
  ADD PRIMARY KEY (`year`,`course_id`),
  ADD KEY `course_id` (`course_id`);

--
-- Indexes for table `Professor`
--
ALTER TABLE `Professor`
  ADD PRIMARY KEY (`username`);

--
-- Indexes for table `Rating`
--
ALTER TABLE `Rating`
  ADD PRIMARY KEY (`submissionID`),
  ADD KEY `student_id` (`student_id`);

--
-- Indexes for table `Student`
--
ALTER TABLE `Student`
  ADD PRIMARY KEY (`student_id`);

--
-- Indexes for table `takes`
--
ALTER TABLE `takes`
  ADD PRIMARY KEY (`course_id`,`student_id`),
  ADD KEY `student_id` (`student_id`);

--
-- Indexes for table `Term`
--
ALTER TABLE `Term`
  ADD PRIMARY KEY (`year`,`Season`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `Class`
--
ALTER TABLE `Class`
  ADD CONSTRAINT `Class_ibfk_1` FOREIGN KEY (`username`) REFERENCES `Professor` (`username`);

--
-- Constraints for table `has`
--
ALTER TABLE `has`
  ADD CONSTRAINT `has_ibfk_1` FOREIGN KEY (`year`) REFERENCES `Term` (`year`),
  ADD CONSTRAINT `has_ibfk_2` FOREIGN KEY (`course_id`) REFERENCES `Class` (`course_id`);

--
-- Constraints for table `Rating`
--
ALTER TABLE `Rating`
  ADD CONSTRAINT `Rating_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `Student` (`student_id`);

--
-- Constraints for table `takes`
--
ALTER TABLE `takes`
  ADD CONSTRAINT `takes_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `Class` (`course_id`),
  ADD CONSTRAINT `takes_ibfk_2` FOREIGN KEY (`student_id`) REFERENCES `Student` (`student_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
