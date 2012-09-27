SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

-- Documents

DROP TABLE IF EXISTS `Documents`;
CREATE TABLE IF NOT EXISTS `Documents` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `label` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

DROP TABLE IF EXISTS `Found`;
CREATE TABLE IF NOT EXISTS `Found` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `word` int(11) NOT NULL,
  `paragraph` int(11) NOT NULL,
  `weight` int(11) NOT NULL,
  `frequency` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- Paragraphs

DROP TABLE IF EXISTS `Paragraphs`;
CREATE TABLE IF NOT EXISTS `Paragraphs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `document` int(11) NOT NULL,
  `xpath` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- Positions

DROP TABLE IF EXISTS `Positions`;
CREATE TABLE IF NOT EXISTS `Positions` (
  `found` int(11) NOT NULL,
  `position` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- Words

DROP TABLE IF EXISTS `Words`;
CREATE TABLE IF NOT EXISTS `Words` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `word` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;
