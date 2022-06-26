# In bajaj auto creating a new column named date_format as date is not in the date data type

alter table `bajaj auto`
add date_format date;

update `bajaj auto` set date_format = str_to_date(date, '%d-%M-%Y');

# Creating a new table named 'bajaj1'
 
create table bajaj1
  as (select date_format as `Date`, `Close Price` as  `Close Price` , 
  avg(`Close Price`) over (order by date_format asc rows 19 preceding) as `20 Day MA`,
  avg(`Close Price`) over (order by date_format asc rows 49 preceding) as `50 Day MA`,
  row_number()     over (order by `date_format` ) as `row_value`
  from `bajaj auto`);
  
# deleting values because calculation is incorrect 
delete from bajaj1 
where  row_value < 50;

alter table bajaj1
drop column row_value;
  
select * from bajaj1 order by `Date`;
 
# In eicher motors creating a new column 'date_format' as date is not in the date data type

alter table `eicher motors`
add date_format date;

update `eicher motors` set date_format = str_to_date(date, '%d-%M-%Y');

# Creating a new table named 'eicher1'

create table eicher1
  as (select `date_format` as `Date`, `Close Price` as  `Close Price` , 
  avg(`Close Price`) over (order by date_format asc rows 19 preceding) as `20 Day MA`,
  avg(`Close Price`) over (order by date_format asc rows 49 preceding) as `50 Day MA`,
  row_number()     over (order by `date_format` ) as `row_value`
  from `eicher motors`);
  
# deleting values because calculation is incorrect  
delete from eicher1 
where  row_value < 50;

alter table eicher1
drop column row_value;

select * from eicher1 order by `Date`;

# In hero motocop creating a new column 'date_format' as date is not in the date data type

alter table `hero motocorp`
add date_format date;

update `hero motocorp` set date_format = str_to_date(date, '%d-%M-%Y');

# Creating a new table named 'hero1'

create table hero1
  as (select `date_format` as `Date`, `Close Price` as  `Close Price` , 
  avg(`Close Price`) over (order by date_format asc rows 19 preceding) as `20 Day MA`,
  avg(`Close Price`) over (order by date_format asc rows 49 preceding) as `50 Day MA`,
   row_number()     over (order by `date_format` ) as `row_value`
  from `hero motocorp`);

# deleting values because calculation is incorrect 

delete from hero1 
where  row_value < 50;

alter table hero1
drop column row_value;

select * from hero1 order by `Date`;

# In infosys creating a new column named date_format as date is not in the date data type

alter table `infosys`
add date_format date;

update `infosys` set date_format = str_to_date(date, '%d-%M-%Y');

# Creating a new table named 'infosys1'

create table infosys1
  as (select `date_format` as `Date`, `Close Price` as  `Close Price` , 
  avg(`Close Price`) over (order by date_format asc rows 19 preceding) as `20 Day MA`,
  avg(`Close Price`) over (order by date_format asc rows 49 preceding) as `50 Day MA`,
   row_number()     over (order by `date_format` ) as `row_value`
  from `infosys`);

# deleting values because calculation is incorrect 

 
delete from infosys1 
where  row_value < 50;

alter table infosys1
drop column row_value;

select * from infosys1 order by `Date`;

# In tcs creating a new column named date_format as date is not in the date data type

alter table `tcs`
add date_format date;

update `tcs` set date_format = str_to_date(date, '%d-%M-%Y');

# Creating a new table named 'tcs1'

create table tcs1
  as (select `date_format` as `Date`, `Close Price` as  `Close Price` , 
  avg(`Close Price`) over (order by date_format asc rows 19 preceding) as `20 Day MA`,
  avg(`Close Price`) over (order by date_format asc rows 49 preceding) as `50 Day MA`,
   row_number()     over (order by `date_format` ) as `row_value`
  from `tcs`);

# deleting values because calculation is incorrect 

delete from tcs1 
where  row_value < 50;

alter table tcs1
drop column row_value;

select * from tcs1 order by `Date`;

# In tvs motors creating a new column named date_format as date is not in the date data type


alter table `tvs motors`
add date_format date;

update `tvs motors` set date_format = str_to_date(date, '%d-%M-%Y');


# Creating a new table named 'tvs1'

create table tvs1
  as (select `date_format` as `Date`, `Close Price` as  `Close Price` , 
  avg(`Close Price`) over (order by date_format asc rows 19 preceding) as `20 Day MA`,
  avg(`Close Price`) over (order by date_format asc rows 49 preceding) as `50 Day MA`,
  row_number()     over (order by `date_format` ) as `row_value`
  from `tvs motors`);

# deleting values because calculation is incorrect 

delete from tvs1 
where  row_value < 50;

alter table tvs1
drop column row_value;

select * from tvs1 order by `Date`;

# Creating a master table containing the date and close price of all the six stocks

create table master
select bajaj.date_format as Date , bajaj.`Close Price` as Bajaj , tcs.`Close Price` as TCS , 
tvs.`Close Price` as TVS , inf.`Close Price` as Infosys , eicher.`Close Price` as Eicher , hero.`Close Price` as Hero
from `bajaj auto` bajaj
inner join `tcs` tcs on tcs.date_format = bajaj.date_format
inner join `tvs motors` tvs on tvs.date_format = bajaj.date_format
inner join `infosys` inf on inf.date_format = bajaj.date_format
inner join `eicher motors` eicher on eicher.date_format = bajaj.date_format
inner join `hero motocorp` hero on hero.date_format = bajaj.date_format ;

select * from master order by `Date`;

# Using the table created earlier to generate buy and sell signal and storing this in another table named 'bajaj2'


create table bajaj2 as
select 
		date_value AS "Date",
		close_price AS "Close Price",
		case when first_value(short_term_greater) over w = nth_value(short_term_greater,2) over w then  'Hold'
				when NTH_VALUE(short_term_greater,2) over w = 'Y' then 'Buy'
				when NTH_VALUE(short_term_greater,2) over w = 'N' then 'Sell'
                else 'Hold'
                end
			
		 AS "Signal" 
	FROM
(
select
		`Date` as date_value,
		`Close Price` AS close_price,
		if(`20 Day MA`>`50 Day MA`,'Y','N') short_term_greater
	from
		bajaj1 
) temp_table
window w as (order by date_value rows between 1 preceding and 0 following);

select * from bajaj2 order by `Date`;


# Using the table created earlier to generate buy and sell signal and storing this in another table named 'eicher2'


create table eicher2 as
select 
		date_value AS "Date",
		close_price AS "Close Price",
		case when first_value(short_term_greater) over w = nth_value(short_term_greater,2) over w then  'Hold'
				when NTH_VALUE(short_term_greater,2) over w = 'Y' then 'Buy'
				when NTH_VALUE(short_term_greater,2) over w = 'N' then 'Sell'
                else 'Hold'
                end
			
		 AS "Signal" 
	FROM
(
select
		`Date` as date_value,
		`Close Price` AS close_price,
		if(`20 Day MA`>`50 Day MA`,'Y','N') short_term_greater
	from
		eicher1 
) temp_table
window w as (order by date_value rows between 1 preceding and 0 following);

select * from eicher2 order by `Date`;

# Using the table created earlier to generate buy and sell signal and storing this in another table named 'hero2'

create table hero2 as
select 
		date_value AS "Date",
		close_price AS "Close Price",
		case when first_value(short_term_greater) over w = nth_value(short_term_greater,2) over w then  'Hold'
				when NTH_VALUE(short_term_greater,2) over w = 'Y' then 'Buy'
				when NTH_VALUE(short_term_greater,2) over w = 'N' then 'Sell'
                else 'Hold'
                end
			
		 AS "Signal" 
	FROM
(
select
		`Date` as date_value,
		`Close Price` AS close_price,
		if(`20 Day MA`>`50 Day MA`,'Y','N') short_term_greater
	from
		hero1 
) temp_table
window w as (order by date_value rows between 1 preceding and 0 following);
  
select * from hero2 order by `Date`;

# Using the table created earlier to generate buy and sell signal and storing this in another table named 'infosys2'


create table infosys2 as
select 
		date_value AS "Date",
		close_price AS "Close Price",
		case when first_value(short_term_greater) over w = nth_value(short_term_greater,2) over w then  'Hold'
				when NTH_VALUE(short_term_greater,2) over w = 'Y' then 'Buy'
				when NTH_VALUE(short_term_greater,2) over w = 'N' then 'Sell'
                else 'Hold'
                end
			
		 AS "Signal" 
	FROM
(
select
		`Date` as date_value,
		`Close Price` AS close_price,
		if(`20 Day MA`>`50 Day MA`,'Y','N') short_term_greater
	from
		infosys1 
) temp_table
window w as (order by date_value rows between 1 preceding and 0 following);
  
select * from infosys2 order by `Date`;

# Using the table created earlier to generate buy and sell signal and storing this in another table named 'bajaj2'

create table tcs2 as
select 
		date_value AS "Date",
		close_price AS "Close Price",
		case when first_value(short_term_greater) over w = nth_value(short_term_greater,2) over w then  'Hold'
				when NTH_VALUE(short_term_greater,2) over w = 'Y' then 'Buy'
				when NTH_VALUE(short_term_greater,2) over w = 'N' then 'Sell'
                else 'Hold'
                end
			
		 AS "Signal" 
	FROM
(
select
		`Date` as date_value,
		`Close Price` AS close_price,
		if(`20 Day MA`>`50 Day MA`,'Y','N') short_term_greater
	from
		tcs1 
) temp_table
window w as (order by date_value rows between 1 preceding and 0 following);
  
select * from tcs2 order by `Date`;

# Using the table created earlier to generate buy and sell signal and storing this in another table named 'bajaj2'

create table tvs2 as
select 
		date_value AS "Date",
		close_price AS "Close Price",
		case when first_value(short_term_greater) over w = nth_value(short_term_greater,2) over w then  'Hold'
				when NTH_VALUE(short_term_greater,2) over w = 'Y' then 'Buy'
				when NTH_VALUE(short_term_greater,2) over w = 'N' then 'Sell'
                else 'Hold'
                end
			
		 AS "Signal" 
	FROM
(
select
		`Date` as date_value,
		`Close Price` AS close_price,
		if(`20 Day MA`>`50 Day MA`,'Y','N') short_term_greater
	from
		tvs1 
) temp_table
window w as (order by date_value rows between 1 preceding and 0 following);
  
select * from tvs2 order by `Date`;
  
## 4. Creating a User defined function, that takes the date as input and returns the signal for that particular day (Buy/Sell/Hold) for the Bajaj stock.

delimiter $$

create function get_signal_for_date( input_date date)

returns varchar(10)

deterministic

begin

declare signal_value varchar(10);

select `Signal` into signal_value 
from bajaj2
where `Date` = input_date;

return signal_value;

end $$

delimiter ;


# Removing date_format from all tables so that they become the original table

alter table `bajaj auto`
drop column date_format;
alter table `eicher motors`
drop column date_format;
alter table `hero motocorp`
drop column date_format;
alter table `infosys`
drop column date_format;
alter table `tcs`
drop column date_format;
alter table `tvs motors`
drop column date_format;