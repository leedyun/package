CREATE TABLE candies (
  id    integer     unsigned not null auto_increment,
  name  varchar(50) not null default "",
  price integer     not null default 0,
  sweet tinyint     not null default 0,
  primary key (id)
)

INSERT INTO candies(name, price, sweet)
VALUES
("strawberry", 130, 4),
("orange",     120, 3),
("lemon",      100, 1),
("chocolate",  150, 5);


CREATE TABLE sales (
  id        integer  unsigned not null auto_increment,
  candy_id  integer  not null,
  num       integer  not null default 0,
  created_at datetime not null default current_timestamp,
  primary key (id)
)

INSERT INTO sales(candy_id, num, created_at)
VALUES
(1, 6,  '2014-01-01'),
(1, 11, '2014-02-12'),
(1, 12, '2014-03-08'),
(1, 9,  '2015-06-03'),
(1, 27, '2015-07-05'),
(1, 13, '2015-08-09'),
(2, 26, '2014-04-21'),
(2, 25, '2014-05-22'),
(2, 19, '2015-05-04'),
(2, 14, '2015-07-30'),
(3, 20, '2014-03-09'),
(3, 28, '2015-02-11'),
(3, 21, '2015-04-20'),
(3, 9,  '2015-11-02'),
(3, 1,  '2015-12-03'),
(3, 18, '2015-06-07'),
(3, 7,  '2015-03-25'),
(4, 2,  '2014-12-07'),
(4, 4,  '2015-02-22'),
(4, 3,  '2015-04-25');



