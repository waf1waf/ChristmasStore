-- phpMyAdmin SQL Dump
-- version 4.7.3
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Dec 23, 2017 at 06:26 AM
-- Server version: 5.6.38
-- PHP Version: 5.6.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

-- --------------------------------------------------------

--
-- Table structure for table `area`
--

CREATE TABLE area (
  `id` int(11) NOT NULL,
  `description` varchar(32000) DEFAULT NULL,
  `minimum_age` int(11) DEFAULT NULL,
  `name` varchar(64) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `area`
--

INSERT INTO `area` (`id`, `description`, `minimum_age`, `name`) VALUES
(1, 'Distribute the gifts to gift wrap volunteers and collect them back into the cart when wrapped.', 13, 'Cart Assistant'),
(2, 'Care for and entertain children of the clients; helping them with crafts, snacks, and games.', 18, 'Childcare--Adult'),
(3, 'Meet and escort the clients through the store, helping them to select gifts for each registered child or serve in age-level toy rooms assisting clients.', 16, 'Customer Service'),
(4, 'Wrap gifts for the clients, ensuring that each gift is tagged for the appropriate child.', 15, 'Gift Wrap'),
(5, 'Welcome everyone to the Christmas Store and help guide clients to their next step in the Christmas Store experience.', 14, 'Greeter'),
(6, 'Keep snacks and drinks stocked for customers and volunteers.', 13, 'Hospitality'),
(7, 'Keep the toys in the store organized by age group and restock the selections as needed, distribute batteries to gifts requiring them, or match boxes to gifts before wrapping.', 16, 'Inventory'),
(8, 'Confirm the client\'s appointment and prepare the clipboard with the names of the registered children. Assist clients who do not have appointments by providing available options.', 14, 'Registration'),
(9, 'Serve as a translator to assist communication with Spanish-speaking clients.  Volunteers may serve in various areas throughout the store.', 12, 'Spanish Interpretation'),
(10, 'Take down tables and rearrange chairs in all departments at the end of the store. Pick up trash and make the church ready for services the next day.', 12, 'Take-Down'),
(11, 'Select gifts for clients who missed their appointment at the Christmas Store.  Volunteers in this area will only be needed on Monday, December 11 from 9:00am-12:00pm.', 16, 'Monday Morning Elf'),
(12, 'Escort families and their shopping carts to their cars and help them unload their gifts. Accompany them to the childcare area to pick up their children if needed.', 15, 'Car Loader'),
(13, 'Care for and entertain children of the clients, helping them with crafts, snacks and games.', 13, 'Childcare--Teen');

-- --------------------------------------------------------

--
-- Table structure for table `email`
--

CREATE TABLE `email` (
  `id` varchar(120) NOT NULL,
  `subject` varchar(256) DEFAULT NULL,
  `body` varchar(20000) DEFAULT NULL,
  `bcc` varchar(256) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `email`
--

INSERT INTO `email` (`id`, `subject`, `body`, `bcc`) VALUES
('thank_you', 'Thank you for volunteering!', '{first_name} {last_name},\n\nThank you for volunteering to help with The Christmas Store!\n\n{reservations}\n\nPlease check in at NHF West, 816 E. Williams St. in Apex, right next to New Horizons Fellowship.  There you will receive your volunteer badge and be directed to your Area Leader, who will show you where you will be serving and what you will be doing.\n\nIf you will not be able to work your shift, please contact New Horizons Fellowship at (919) 303-5266 or reply to this email as soon as possible.\n\n--\nMorgan Whaley\nChristmas Store Administrator', ''),
('reminder', 'Christmas Store Reminder', '{first_name} {last_name},\n\nThank you for volunteering to serve others at The Christmas Store!\n\n{reservations}\n\nPlease check in at NHF West, 816 E. Williams Street in Apex, right next to New Horizons Fellowship.  There you will receive your volunteer badge and be directed to your Area Leader, who will show you where you will be serving and what you will be doing.\n\nNHF West will serve as \"volunteer central,\" where you can find restrooms and light refreshments.  Feel free to bring a snack (sweet or savory) to share with the other volunteers.\n\nGet your Christmas Store Volunteer T-shirt while they last!  Proceeds from T-shirt sales go to purchase TOYS, TOYS, and MORE TOYS!  Shirts are $10 each and will be available at Volunteer Check-in.  Adult Sizes: Small-3XL (Talls also available).\n\nIf you will not be able to work your shift, please contact New Horizons Fellowship at (919) 303-5266 or reply to this email as soon as possible.\n\n--\nMorgan Whaley\nChristmas Store Administrator', '');

-- --------------------------------------------------------

--
-- Table structure for table `need`
--

CREATE TABLE `need` (
  `fk_area_id` int(11) DEFAULT NULL,
  `fk_shift_id` int(11) DEFAULT NULL,
  `count` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `need`
--

INSERT INTO `need` (`fk_area_id`, `fk_shift_id`, `count`) VALUES
(1, 1, 8),
(1, 10, 0),
(1, 2, 8),
(1, 3, 8),
(1, 4, 8),
(1, 5, 8),
(1, 6, 8),
(1, 7, 8),
(1, 8, 8),
(1, 9, 0),
(10, 1, 0),
(10, 10, 0),
(10, 2, 0),
(10, 3, 0),
(10, 4, 0),
(10, 5, 0),
(10, 6, 0),
(10, 7, 0),
(10, 8, 0),
(10, 9, 20),
(11, 1, 0),
(11, 10, 3),
(11, 2, 0),
(11, 3, 0),
(11, 4, 0),
(11, 5, 0),
(11, 6, 0),
(11, 7, 0),
(11, 8, 0),
(11, 9, 0),
(12, 1, 4),
(12, 10, 0),
(12, 2, 4),
(12, 3, 4),
(12, 4, 4),
(12, 5, 4),
(12, 6, 4),
(12, 7, 4),
(12, 8, 4),
(12, 9, 0),
(13, 1, 2),
(13, 10, 0),
(13, 2, 2),
(13, 3, 2),
(13, 4, 2),
(13, 5, 2),
(13, 6, 2),
(13, 7, 2),
(13, 8, 2),
(13, 9, 0),
(2, 1, 2),
(2, 10, 0),
(2, 2, 2),
(2, 3, 2),
(2, 4, 2),
(2, 5, 2),
(2, 6, 2),
(2, 7, 2),
(2, 8, 1),
(2, 8, 2),
(2, 9, 0),
(3, 1, 12),
(3, 10, 0),
(3, 2, 12),
(3, 3, 12),
(3, 4, 12),
(3, 5, 12),
(3, 6, 12),
(3, 7, 12),
(3, 8, 12),
(3, 9, 0),
(4, 1, 25),
(4, 10, 0),
(4, 2, 25),
(4, 3, 25),
(4, 4, 25),
(4, 5, 25),
(4, 6, 25),
(4, 7, 25),
(4, 8, 25),
(4, 9, 0),
(5, 1, 2),
(5, 10, 0),
(5, 2, 2),
(5, 3, 2),
(5, 4, 2),
(5, 5, 2),
(5, 6, 2),
(5, 7, 2),
(5, 8, 2),
(5, 9, 0),
(6, 1, 1),
(6, 10, 0),
(6, 2, 1),
(6, 3, 1),
(6, 4, 1),
(6, 5, 1),
(6, 6, 1),
(6, 7, 1),
(6, 8, 1),
(6, 9, 0),
(7, 1, 8),
(7, 10, 0),
(7, 2, 8),
(7, 3, 8),
(7, 4, 8),
(7, 5, 8),
(7, 6, 8),
(7, 7, 8),
(7, 8, 8),
(7, 9, 0),
(8, 1, 2),
(8, 10, 0),
(8, 2, 2),
(8, 3, 2),
(8, 4, 2),
(8, 5, 2),
(8, 6, 2),
(8, 7, 2),
(8, 8, 2),
(8, 9, 0),
(9, 1, 10),
(9, 10, 0),
(9, 2, 10),
(9, 3, 10),
(9, 4, 10),
(9, 5, 10),
(9, 6, 10),
(9, 7, 10),
(9, 8, 10),
(9, 9, 0);

-- --------------------------------------------------------

--
-- Table structure for table `organization`
--

CREATE TABLE `organization` (
  `id` int(11) NOT NULL,
  `name` varchar(128) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `organization`
--

INSERT INTO `organization` (`id`, `name`) VALUES
(1, 'New Horizons Fellowship'),
(2, 'Generation Joshua'),
(3, 'Bob Barker'),
(4, 'EMC'),
(5, 'Apex United Methodist Church'),
(6, 'Fuquay-Varina United Methodist Church'),
(7, 'Ambassador Presbyterian Church'),
(8, 'Peak United Methodist Church'),
(9, 'Sovereign Grace Church'),
(10, 'Hope Chapel'),
(11, 'Jordan Church'),
(12, 'Hope Community Church'),
(13, 'Teen Korps'),
(14, 'Resurrection Lutheran Church'),
(15, 'Woodhaven Baptist Church'),
(16, 'Apex Baptist Church'),
(17, 'Holly Springs United Methodist Church'),
(18, 'St. Mary AME Church'),
(19, 'NC State University'),
(20, 'The Summit Church'),
(21, 'TGIF Bowlers'),
(22, 'Salem Baptist Church'),
(23, 'Zeta Phi Beta Sorority'),
(24, 'Buffaloe Gals Bowling'),
(25, 'Cornerstone Presbyterian Church'),
(26, 'Pleasant Grove Church'),
(27, 'Greater Christian Chapel Church'),
(28, 'Meredith College'),
(29, 'New Life Ministries of Apex'),
(30, 'Abiding Presence Lutheran Church'),
(31, 'The New School Montessori Center'),
(32, 'Amberly Angels'),
(33, 'YMCA of the Triangle'),
(34, 'Girl Scout Troop 3303'),
(35, 'Colonial Baptist Church'),
(36, 'Saint Michael\'s'),
(37, 'Wake Tech'),
(38, 'SECU'),
(39, 'Apex High School'),
(40, 'Activate Good'),
(41, 'Apex Friendship High School'),
(42, 'Holly Springs High School'),
(43, 'The Church of Jesus Christ of Latter Day Saints'),
(44, '519 Church'),
(45, 'Crosspointe Church'),
(46, 'Intentional Love Baptist Church'),
(47, 'Ravenscroft School');

-- --------------------------------------------------------

--
-- Table structure for table `reservation`
--

CREATE TABLE `reservation` (
  `id` int(11) NOT NULL,
  `fk_volunteer_id` int(11) DEFAULT NULL,
  `fk_shift_id` int(11) DEFAULT NULL,
  `fk_area_id` int(11) DEFAULT NULL,
  `count` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `shift`
--

CREATE TABLE `shift` (
  `id` int(11) NOT NULL,
  `pos` int(11) NOT NULL,
  `name` varchar(64) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `shift`
--

INSERT INTO `shift` (`id`, `pos`, `name`) VALUES
(1, 1, 'Fri Dec 14 11:30am - 2:00pm'),
(2, 2, 'Fri Dec 14 1:30pm - 4:00pm'),
(3, 3, 'Fri Dec 14 3:30pm - 6:00pm'),
(4, 4, 'Fri Dec 14 5:30pm - 8:00pm'),
(5, 5, 'Sat Dec 15 8:30am - 11:00am'),
(6, 6, 'Sat Dec 15 10:30am - 1:00pm'),
(7, 7, 'Sat Dec 15 12:30pm - 3:00pm'),
(8, 8, 'Sat Dec 15 2:30pm - 5:00pm'),
(9, 9, 'Sat Dec 15 5:00pm - 6:30pm'),
(10, 10, 'Mon Dec 17 9:00am - 12:00pm');

-- --------------------------------------------------------

--
-- Table structure for table `volunteer`
--

CREATE TABLE `volunteer` (
  `id` int(11) NOT NULL,
  `first_name` varchar(255) DEFAULT NULL,
  `last_name` varchar(255) DEFAULT NULL,
  `email_address` varchar(255) DEFAULT NULL,
  `phone_number` varchar(32) DEFAULT NULL,
  `other_organization` varchar(128) DEFAULT NULL,
  `fk_organization_id` int(11) DEFAULT NULL,
  `n_adults` int(11) NOT NULL,
  `n_children` int(11) NOT NULL,
  `age_of_youngest` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `volunteer`
--

--
-- Indexes for dumped tables
--

--
-- Indexes for table `area`
--
ALTER TABLE `area`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `email`
--
ALTER TABLE `email`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `organization`
--
ALTER TABLE `organization`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `reservation`
--
ALTER TABLE `reservation`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `shift`
--
ALTER TABLE `shift`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `volunteer`
--
ALTER TABLE `volunteer`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `area`
--
ALTER TABLE `area`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;
--
-- AUTO_INCREMENT for table `organization`
--
ALTER TABLE `organization`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=48;
--
-- AUTO_INCREMENT for table `reservation`
--
ALTER TABLE `reservation`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;
--
-- AUTO_INCREMENT for table `shift`
--
ALTER TABLE `shift`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;
--
-- AUTO_INCREMENT for table `volunteer`
--
ALTER TABLE `volunteer`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
