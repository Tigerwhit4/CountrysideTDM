-- phpMyAdmin SQL Dump
-- version 4.1.5
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Mar 14, 2014 at 07:51 AM
-- Server version: 5.5.35
-- PHP Version: 5.4.24

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `Flake_336`
--

-- --------------------------------------------------------

--
-- Table structure for table `adminlogs`
--

CREATE TABLE IF NOT EXISTS `adminlogs` (
  `command` varchar(24) DEFAULT NULL,
  `admin` varchar(41) DEFAULT NULL,
  `usedon` varchar(41) DEFAULT NULL,
  `reason` varchar(41) DEFAULT NULL,
  `date` varchar(41) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `adminlogs`
--

INSERT INTO `adminlogs` (`command`, `admin`, `usedon`, `reason`, `date`) VALUES
('IRC Kick', 'Flake', 'Flake', 'LongKick', '2014-03-14 01:58:06'),
('Game SetLevel', 'Flake', 'Flake', 'N/A', '2014-03-14 02:04:37'),
('Setlevel', 'Flake..', 'Flake..', 'N/A', '2014-03-14 08:19:07');

-- --------------------------------------------------------

--
-- Table structure for table `bans`
--

CREATE TABLE IF NOT EXISTS `bans` (
  `name` varchar(24) NOT NULL,
  `IP` varchar(24) NOT NULL,
  `reason` varchar(16) NOT NULL,
  `bannedby` varchar(16) NOT NULL,
  `date` varchar(24) NOT NULL,
  `status` int(20) NOT NULL,
  `IRCBan` varchar(16) NOT NULL,
  PRIMARY KEY (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `dynamicvehicles`
--

CREATE TABLE IF NOT EXISTS `dynamicvehicles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `model` int(11) NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `a` float NOT NULL,
  `c1` int(11) NOT NULL,
  `c2` int(11) NOT NULL,
  `plate` varchar(9) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=77 ;

--
-- Dumping data for table `dynamicvehicles`
--

INSERT INTO `dynamicvehicles` (`id`, `model`, `x`, `y`, `z`, `a`, `c1`, `c2`, `plate`) VALUES
(1, 422, -1045.7, -1190.77, 128.997, 26.8641, 0, 3, 'plswork'),
(2, 531, -354.48, -1046, 59.3337, 180.862, 3, 3, '$'),
(3, 413, -81.0204, -1198.32, 2.3811, 344.722, 3, 2, 'Mechani'),
(4, 403, -44.5736, -1153.76, 1.68493, 63.1722, 7, 3, 'Trucka'),
(5, 531, -101.762, -1587.88, 2.58317, 306.815, 0, 1, 'Hobo'),
(6, 531, -105.489, -1583.62, 2.57961, 301.625, 0, 1, 'Hobo'),
(7, 404, -43.7878, -1568.3, 2.30646, 157.207, 3, 5, 'hobo'),
(8, 404, -86.8979, -1549.42, 2.34538, 226.844, 0, 0, 'hobo'),
(9, 404, -79.8899, -1543.4, 2.34475, 220.902, 0, 0, 'hobo'),
(10, 422, -36.4273, -1584.79, 2.96738, 324.662, 55, 0, '$$$'),
(11, 422, -23.0542, -1555.2, 2.15701, 343.085, 55, 0, '$$$'),
(12, 543, -69.6754, -1618.6, 3.17093, 300.287, 55, 55, 'Tazman'),
(13, 549, -56.6957, -1609.46, 2.67599, 312.301, 55, 0, 'Tazman'),
(14, 549, -99.1497, -1609.62, 2.31711, 219.544, 55, 0, 'Hobo'),
(15, 549, -87.0465, -1196.53, 1.96648, 345.832, 55, 1, 'Mech'),
(16, 540, -63.0898, -1159.15, 1.60839, 150.682, 50, 1, 'Mech'),
(17, 558, -74.2358, -1153.43, 1.38099, 153.355, 53, 4, 'Mech'),
(18, 552, -71.9091, -1182.63, 1.44906, 335.296, 53, 4, 'Mech'),
(19, 578, -112.317, -1208.1, 3.54804, 125.022, 53, 4, 'Mech'),
(20, 487, -90.5297, -1166.96, 7.92061, 338.573, 100, 20, '.'),
(21, 489, -366.715, -1440.25, 25.8695, 85.2541, 55, 10, 'Yokal'),
(22, 505, -367.436, -1442.49, 25.871, 92.119, 55, 55, 'Yokal'),
(23, 572, -384.58, -1417.95, 25.3062, 273.204, 56, 56, 'Yokal'),
(24, 554, -379.241, -1454.24, 25.8109, 0.18976, 40, 55, 'Farmer'),
(25, 554, -365.998, -1410.71, 25.8141, 91.7812, 40, 55, 'Farmer'),
(26, 512, -416.034, -1377.13, 23.8205, 279.565, 30, 33, 'Farmer'),
(27, 512, -482.317, -1351.01, 27.1809, 43.6569, 30, 33, 'Farmer'),
(28, 525, -67.8816, -1119.75, 0.953099, 70.2909, 36, 83, '.'),
(29, 525, -62.9428, -1111.52, 0.953581, 74.1135, 55, 32, '.'),
(30, 532, -243.705, -1341.25, 8.67962, 146.116, 0, 0, '0'),
(31, 532, -274.471, -1408.76, 12.3859, 187.567, 0, 0, '0'),
(32, 532, -289.889, -1518.88, 8.89084, 287.259, 0, 0, '0'),
(33, 541, -510.671, -544.983, 25.1484, 183.158, 0, 7, '$Ari$'),
(34, 541, -471.501, -524.709, 25.1429, 91.8741, 1, 5, '$Ari$'),
(35, 541, -589.997, -486.257, 25.1485, 1.70231, 1, 2, 'Racer'),
(36, 541, -539.373, -471.568, 25.1437, 176.66, 1, 2, 'Racer'),
(37, 411, -480.78, -539.611, 25.2567, 90.5681, 0, 2, 'Racer'),
(38, 411, -479.506, -533.531, 25.2567, 99.4048, 8, 2, 'Racer'),
(39, 411, -510.32, -487.767, 25.2505, 180.262, 10, 2, 'Racer'),
(40, 411, -550.354, -486.39, 25.2505, 181.704, 10, 2, 'Racer'),
(41, 475, -479.112, -472.527, 25.326, 178.117, 34, 2, 'Racer'),
(42, 475, -547.917, -544.525, 25.3253, 182.115, 34, 2, 'Racer'),
(43, 477, -503.717, -558.542, 25.2773, 271.865, 34, 2, 'Racer'),
(44, 560, -489.298, -471.876, 25.2292, 177.947, 74, 6, 'Racer'),
(45, 422, -1030.8, -1183.69, 129.203, 90.8885, 0, 3, '.'),
(46, 508, -1035.22, -1159.27, 129.594, 95.8761, 0, 1, 'MotherS'),
(47, 483, -1064.64, -1219.88, 129.211, 267.235, 16, 27, 'Ship'),
(48, 483, -1073.38, -1296.6, 129.212, 91.0386, 16, 27, 'Ship'),
(49, 579, -1064.96, -1182.46, 129.15, 264.931, 1, 1, 'w33d'),
(50, 579, -1065.95, -1177.75, 129.152, 269.33, 1, 1, 'w33d'),
(51, 568, -1043.66, -1228.66, 128.724, 180.692, 1, 1, 'w33d'),
(52, 568, -1043.05, -1242.4, 128.635, 182.577, 1, 1, 'w33d'),
(53, 568, -1159.91, -1120.21, 128.819, 93.4208, 1, 1, 'w33d'),
(54, 568, -1179.29, -1057.49, 129.084, 273.194, 1, 1, 'w33d'),
(55, 568, -1028.52, -1054.3, 129.083, 29.3012, 1, 1, 'w33d'),
(56, 476, -1187.73, -1000.41, 129.94, 274.906, 1, 1, 'w33d'),
(57, 476, -1187.27, -969.474, 129.91, 259.624, 44, 24, 'w33d'),
(58, 487, -476.195, -552.399, 33.2984, 92.3542, 3, 0, '$$'),
(59, 487, -472.163, -532.568, 33.2948, 93.7457, 3, 0, '$$'),
(60, 447, -713.344, -1911.88, 6.10169, 292.297, 0, 0, '0'),
(61, 578, -579.115, -1461.24, 10.8946, 309.423, 7, 3, 'Swag'),
(62, 463, -575.776, -1057.4, 23.1837, 234.895, 3, 5, 'Swag'),
(63, 463, -582.968, -1069.19, 22.9238, 236.381, 3, 5, 'Swag'),
(64, 463, -568.24, -1045.65, 23.4647, 237.275, 3, 5, 'Swag'),
(65, 478, -556.825, -1025.81, 24.0569, 229.807, 33, 55, 'Swag'),
(66, 413, -388.664, -1150, 69.5143, 176.278, 55, 3, 'Elliot'),
(67, 554, -398.431, -1437.74, 25.8029, 179.907, 56, 55, 'Farmer'),
(68, 554, -394.391, -1437.01, 25.8121, 180, 56, 55, 'Farmer'),
(69, 411, -299.008, -857.227, 46.4029, 145.719, 0, 0, '1'),
(70, 497, -635.442, -1225.09, 29.8795, 249.532, 9, 1, '2'),
(71, 598, -644.862, -1244, 21.212, 248.801, 9, 1, 'Po Po'),
(72, 598, -651.576, -1246.49, 21.5625, 247.387, 9, 1, 'Po Po'),
(73, 596, -610.378, -1226.62, 20.8335, 157.397, 9, 1, 'Po Po'),
(74, 596, -605.636, -1216.38, 21.0127, 153.225, 9, 1, 'Po Po'),
(75, 599, -607.302, -1189.63, 21.8528, 154.076, 9, 1, 'Po Po'),
(76, 599, -626.246, -1264.26, 20.6382, 340.581, 9, 1, 'Po Po');

-- --------------------------------------------------------

--
-- Table structure for table `HOUSEINFO`
--

CREATE TABLE IF NOT EXISTS `HOUSEINFO` (
  `housename` varchar(51) DEFAULT NULL,
  `houseowner` varchar(25) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `HOUSEINFO`
--

INSERT INTO `HOUSEINFO` (`housename`, `houseowner`) VALUES
('Flakes Hut', 'Flake'),
('Big Trailer', 'Flake'),
('Big Trailer', 'Flake'),
('Big Trailer', 'Flake'),
('Big Trailer', 'Flake'),
('The Bunker', 'Flake'),
('Flakes Hut', 'Flake'),
('The Bunker', 'Matt_Rexford'),
('The Bunker', 'Crunchie'),
('Big Trailer', 'Crunchie'),
('The Bunker', 'Iceman'),
('Big Trailer', 'Iceman'),
('Big Trailer', 'JeaSon'),
('The Bunker', 'JeaSon'),
('Aris Shack', 'UnknownLegend'),
('Big Trailer', 'Flake'),
('Big Trailer', 'Flake'),
('The Bunker', 'Flake'),
('Aris Shack', 'Fer_mdq'),
('The Bunker', 'Fer_mdq'),
('Flakes Hut', '[DIE]saloun'),
('Aris Shack', 'Spyder'),
('Big Trailer', 'spermer'),
('The Bunker', 'Spyder638');

-- --------------------------------------------------------

--
-- Table structure for table `lastkills`
--

CREATE TABLE IF NOT EXISTS `lastkills` (
  `player` varchar(24) DEFAULT NULL,
  `killer` varchar(41) DEFAULT NULL,
  `killerteam` varchar(41) DEFAULT NULL,
  `playerteam` varchar(41) DEFAULT NULL,
  `health` varchar(41) DEFAULT NULL,
  `armor` varchar(41) DEFAULT NULL,
  `weapon` varchar(41) DEFAULT NULL,
  `date` varchar(41) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `lastkills`
--

INSERT INTO `lastkills` (`player`, `killer`, `killerteam`, `playerteam`, `health`, `armor`, `weapon`, `date`) VALUES
('Flake..', 'Jeason', 'Mechanic', 'Hobo', '0.00', '0.00', '', '2014-03-14 08:19:47');

-- --------------------------------------------------------

--
-- Table structure for table `mapicons`
--

CREATE TABLE IF NOT EXISTS `mapicons` (
  `MapIconX` float NOT NULL,
  `MapIconY` float NOT NULL,
  `MapIconZ` float NOT NULL,
  `MapIconType` int(2) NOT NULL,
  `MapIconColor` int(2) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `mapicons`
--

INSERT INTO `mapicons` (`MapIconX`, `MapIconY`, `MapIconZ`, `MapIconType`, `MapIconColor`) VALUES
(-1068.47, -1200.91, 129.219, 56, 1),
(-77.644, -1173.74, 5.67969, 56, 1),
(-82.3147, -1571.78, 2.61072, 56, 1),
(-380.622, -1426.39, 25.7273, 56, 1),
(-539.788, -506.288, 25.5234, 56, 1),
(-713.912, -1909.62, 4.72, 36, 16),
(-87.2738, -1219.83, 2.69913, 31, 2),
(-394.303, -1445.88, 25.7266, 31, 2),
(-385.477, -1141.77, 72.7232, 18, 1),
(-588.969, -1045.17, 26.7327, 18, 1);

-- --------------------------------------------------------

--
-- Table structure for table `playerdata`
--

CREATE TABLE IF NOT EXISTS `playerdata` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nick` varchar(24) NOT NULL,
  `password` varchar(68) NOT NULL,
  `admin` int(20) NOT NULL,
  `score` int(20) NOT NULL,
  `deaths` int(20) NOT NULL,
  `money` int(20) NOT NULL,
  `ping` int(20) NOT NULL,
  `vip` int(20) NOT NULL,
  `cookies` int(20) NOT NULL,
  `TP` int(20) NOT NULL,
  `label` varchar(24) NOT NULL,
  `country` varchar(24) NOT NULL,
  `ip` varchar(16) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=23 ;

--
-- Dumping data for table `playerdata`
--

INSERT INTO `playerdata` (`id`, `nick`, `password`, `admin`, `score`, `deaths`, `money`, `ping`, `vip`, `cookies`, `TP`, `label`, `country`, `ip`) VALUES
(1, 'Flayke', '197722866', 5, 0, 0, 0, 15, 0, 17, 1, 'cake', 'Private IP', '10.0.0.12'),
(4, 'Spyder', '539559464', 0, 0, 15, 0, 50, 0, 0, 0, '', 'Private IP', '109.167.253.102'),
(3, 'Flake', '197722866', 2, 2, 37, 300, 14, 0, 0, 0, '', 'Private IP', '10.0.0.12'),
(5, 'spermer', '442369689', 0, 0, 36, 0, 91, 0, 0, 0, '', 'Private IP', '46.159.25.170'),
(6, 'Spyder638', '470353256', 0, 0, 28, 0, 45, 0, 0, 0, '', 'Private IP', '109.167.253.102'),
(10, '77777Spyder777777', '557188782', 0, 0, 39, 0, 54, 0, 0, 0, '', 'Private IP', '109.167.253.102'),
(7, 'Spyder639', '539559464', 0, 0, 32, 999999599, 45, 0, 0, 0, '', 'Private IP', '109.167.253.102'),
(8, 'Spyder9997', '470353256', 0, 0, 36, 0, 50, 0, 0, 0, '', 'Private IP', '109.167.253.102'),
(9, 'Spyder777777', '539559464', 0, 0, 9, 999999999, 70, 0, 0, 0, '', 'Private IP', '109.167.253.102'),
(11, 'spermer00000', '383649209', 0, 0, 15, 0, 90, 0, 0, 0, '', 'Private IP', '46.159.25.170'),
(12, '77777Spyder7777770', '539559464', 0, 0, 39, 0, 52, 0, 0, 0, '', 'Private IP', '109.167.253.102'),
(13, '707777Spyder7777770', '539559464', 0, 0, 44, 999999499, 50, 0, 0, 0, '', 'Private IP', '109.167.253.102'),
(14, '(li', '192807671', 0, 0, 4, 0, 137, 0, 0, 0, '', 'Private IP', '37.215.175.103'),
(15, 'SpydeR', '539559464', 0, 0, 0, 0, 0, 0, 0, 0, '', '', '109.167.253.102'),
(16, 'Thunder_Joey', '118555035', 0, 0, 51, 0, 80, 0, 0, 0, '', 'Private IP', '37.78.12.35'),
(17, 'Spyder_6665656', '539559464', 0, 0, 37, 999997899, 49, 0, 0, 0, '', 'Private IP', '109.167.253.102'),
(18, 'Flakee', '197722866', 0, 0, 0, 0, 15, 0, 0, 0, '', 'Private IP', '10.0.0.12'),
(19, 'Vast_Snafu', '49807616', 0, 2, 2, 300, 75, 0, 0, 0, '', 'Private IP', '124.171.12.3'),
(20, 'agilus_pogi03', '225575489', 0, 0, 51, 0, 487, 0, 0, 0, '', 'Private IP', '125.212.123.74'),
(21, 'Jeason', '198836973', 0, 0, 0, 0, 588, 0, 1, 0, '', '', '182.182.47.19'),
(22, 'Flake..', '197722866', 5, 0, 0, 0, 493, 0, 2, 0, '', 'Australia', '10.0.0.12');

-- --------------------------------------------------------

--
-- Table structure for table `ServerInfo`
--

CREATE TABLE IF NOT EXISTS `ServerInfo` (
  `Server` varchar(24) DEFAULT NULL,
  `TotalJoins` varchar(24) DEFAULT NULL,
  `TikisFound` varchar(41) DEFAULT NULL,
  `Bans` int(20) DEFAULT NULL,
  `Accounts` int(20) DEFAULT NULL,
  `Bombs` varchar(16) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `ServerInfo`
--

INSERT INTO `ServerInfo` (`Server`, `TotalJoins`, `TikisFound`, `Bans`, `Accounts`, `Bombs`) VALUES
('Hello', NULL, NULL, 1, NULL, NULL),
('Hello', NULL, NULL, 2, NULL, NULL),
('CountryTDM', '1', NULL, 1, 1, '4');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
