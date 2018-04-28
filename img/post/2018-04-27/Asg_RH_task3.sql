-- +---------------------------------------------------------
-- | MODEL       : 
-- | AUTHOR      : 
-- | GENERATED BY: Open System Architect
-- +---------------------------------------------------------
-- | WARNING     : Review before execution
-- +---------------------------------------------------------

-- +---------------------------------------------------------
-- | CREATE
-- +---------------------------------------------------------
CREATE TABLE `Room`
(
  id CHAR,
  roomtype TINYINT,
  price INTEGER
);

CREATE TABLE `Hotel`
(
  id ,
  name VARCHAR(256),
  stars TINYINT,
  location 
);

CREATE TABLE `Reservation`
(
  id CHAR,
  checkin DATE,
  checkout DATE,
  price INTEGER
);

CREATE TABLE `Customer`
(
  mail VARCHAR(256),
  name VARCHAR(256),
  gender TINYINT,
  smoking BIT,
  special_requirements LONGTEXT
);

