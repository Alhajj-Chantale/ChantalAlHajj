--
-- Database: `SMB215`
--

DROP DATABASE IF EXISTS SMB215;

CREATE DATABASE SMB215;

USE SMB215;

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
CREATE TABLE IF NOT EXISTS `roles` (
  `role_name` varchar(20) NOT NULL,
  PRIMARY KEY (`role_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`role_name`) VALUES
('System Administrator'),
('User');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `user_name` varchar(20) NOT NULL,
  `password` varchar(32) NOT NULL,
  `pass2` varchar(255) NOT NULL,
  `isGoogleAuth` char(3) DEFAULT 'no',
  `email` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `userGoogleId` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `isBanned` char(3) DEFAULT 'no',
  `flagChangePass` char(3) DEFAULT NULL,
  PRIMARY KEY (`user_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_name`, `password`, `pass2`, `isGoogleAuth`, `email`, `userGoogleId`, `isBanned`, `flagChangePass`) VALUES
('mdekmak', '202cb962ac59075b964b07152d234b70', '41974a7a57fd1ce6cf6b03bfa4602e7e', 'no', NULL, NULL, 'no', NULL),
('user1', 'c4ca4238a0b923820dcc509a6f75849b', 'e30b12f6a26d0288ddf7831bbd4e22c7', 'no', NULL, NULL, 'no', NULL),
('user2', 'c20ad4d76fe97759aa27a0c99bff6710', '58f5d9223155a6aca46e354a85ff2dab', 'no', NULL, NULL, 'no', NULL),
('user3', '202cb962ac59075b964b07152d234b70', '41974a7a57fd1ce6cf6b03bfa4602e7e', 'no', NULL, NULL, 'no', NULL),
('user4', '81dc9bdb52d04dc20036dbd8313ed055', '69f43d8ef697dcb6b643f99930242a18', 'no', NULL, NULL, 'no', NULL),
('user5', '827ccb0eea8a706c4c34a16891f84e7b', '4fddb82a8dde335aa90e9eca0dcbcdd7', 'no', NULL, NULL, 'no', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `users_roles`
--

DROP TABLE IF EXISTS `users_roles`;
CREATE TABLE IF NOT EXISTS `users_roles` (
  `user_name` varchar(20) NOT NULL,
  `role_name` varchar(20) NOT NULL,
  PRIMARY KEY (`user_name`,`role_name`),
  KEY `users_roles_foreign_key_2` (`role_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `users_roles`
--

INSERT INTO `users_roles` (`user_name`, `role_name`) VALUES
('mdekmak', 'System Administrator'),
('user1', 'User'),
('user2', 'User'),
('user3', 'User'),
('user4', 'User'),
('user5', 'User');

--
-- Constraints for dumped tables
--

--
-- Constraints for table `users_roles`
--
ALTER TABLE `users_roles`
  ADD CONSTRAINT `users_roles_foreign_key_1` FOREIGN KEY (`user_name`) REFERENCES `users` (`user_name`),
  ADD CONSTRAINT `users_roles_foreign_key_2` FOREIGN KEY (`role_name`) REFERENCES `roles` (`role_name`);

--
-- Table structure for table `contacts`
--

DROP TABLE IF EXISTS `contacts`;
CREATE TABLE IF NOT EXISTS `contacts` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `firstName` varchar(255) NOT NULL,
  `lastName` varchar(255) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `gender` varchar(255) DEFAULT NULL,
  `jobTitle` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `dateOfBirth` varchar(255) DEFAULT NULL,
  `mobile` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `fax` varchar(255) DEFAULT NULL,
  `address1` varchar(255) DEFAULT NULL,
  `address2` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `state` varchar(255) DEFAULT NULL,
  `country` varchar(255) DEFAULT NULL,
  `zip` varchar(255) DEFAULT NULL,
  `createdBy` varchar(255) NOT NULL,
  `createdOn` date NOT NULL,
  `modifiedOn` date DEFAULT NULL,
  `modifiedBy` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `createdBy` (`createdBy`),
  KEY `modifiedBy` (`modifiedBy`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
CREATE TABLE IF NOT EXISTS `notifications` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `user_name` varchar(20) NOT NULL,
  `message` text NOT NULL,
  `status` enum('seen','unseen') NOT NULL,
  `sentDate` date NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `system_preferences`
--

DROP TABLE IF EXISTS `system_preferences`;
CREATE TABLE IF NOT EXISTS `system_preferences` (
  `sysKey` text NOT NULL,
  `sysValue` text
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `contacts`
--
ALTER TABLE `contacts`
  ADD CONSTRAINT `contacts_ibfk_1` FOREIGN KEY (`createdBy`) REFERENCES `users` (`user_name`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `contacts_ibfk_2` FOREIGN KEY (`modifiedBy`) REFERENCES `users` (`user_name`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Dumping data for table `system_preferences`
--

INSERT INTO `system_preferences` (`sysKey`, `sysValue`) VALUES
('smtpUsername', 'example-user@gmail.com'),
('smtpPassword', '3923ed40de807ab6840a563fe0a829a5');


--
-- Table structure for table `calendar`
--

DROP TABLE IF EXISTS `calendar`;
CREATE TABLE IF NOT EXISTS `calendar` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `start` varchar(255) NOT NULL,
  `end` varchar(255) DEFAULT NULL,
  `createdBy` varchar(255) NOT NULL,
  `location` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `createdBy` (`createdBy`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `calendar`
--
ALTER TABLE `calendar`
  ADD CONSTRAINT `calendar_ibfk_1` FOREIGN KEY (`createdBy`) REFERENCES `users` (`user_name`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Table structure for table `calendar_users`
--

DROP TABLE IF EXISTS `calendar_users`;
CREATE TABLE IF NOT EXISTS `calendar_users` (
  `event_id` int(10) NOT NULL,
  `user_name` varchar(255) NOT NULL,
  KEY `event_id` (`event_id`),
  KEY `user_name` (`user_name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `calendar_users`
--
ALTER TABLE `calendar_users`
  ADD CONSTRAINT `calendar_users_ibfk_2` FOREIGN KEY (`user_name`) REFERENCES `users` (`user_name`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `calendar_users_ibfk_1` FOREIGN KEY (`event_id`) REFERENCES `calendar` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
