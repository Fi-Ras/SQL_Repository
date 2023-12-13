-- Active: 1702405895474@@127.0.0.1@5432@dbs_analyse
--Create a new DATABASE

--CREATE DATABASE DBS_ANALYSE;

-- Check the existance of the new Database
SELECT datname FROM pg_database;

-- CREATE evanston311 table
drop table if exists evanston311;

create table evanston311 (
  id int primary key,
  priority varchar(6),
  source varchar(20),
  category varchar(64),
  date_created timestamp with time zone,
  date_completed timestamp with time zone,
  street varchar(48),
  house_num varchar(12),
  zip char(5),
  description text
);

-- Insert values into the table evanston311
COPY evanston311
	FROM PROGRAM 'curl "https://assets.datacamp.com/production/repositories/3567/datasets/48ea25f9557bdad445f18055f13903455189359c/ev311.csv"' (DELIMITER ',', FORMAT CSV, HEADER, NULL 'NA');

--Show the table (Onlys the first 10 lines)
SELECT * FROM evanston311
LIMIT 10;


--Create stackoverflow, tag_type, tag_company, company, fortune500 tables
drop table if exists stackoverflow;
create table stackoverflow (
   id serial,
   tag varchar(30) references tag_company(tag),
   date date,
   question_count integer default 0,  
   question_pct double precision, 
   unanswered_count integer,
   unanswered_pct double precision
);


drop table if exists tag_type;
create table tag_type (
  id serial,
  tag varchar(30) references tag_company(tag),
  type varchar(30)
);


drop table if exists tag_company;
create table tag_company (
  tag varchar(30) primary key,
  company_id int references company(id)
);


drop table if exists company;
create table company (
  id int primary key,
  exchange varchar(10),
  ticker char(5) unique,
  name varchar not null,
  parent_id int references company(id)
);


drop table if exists fortune500;
create table fortune500 (
  rank int not null,
  title varchar primary key,
  name varchar not null unique,
  ticker char(5),
  url varchar,
  hq varchar,
  sector varchar,
  industry varchar,
  employees int check (employees > 0),
  revenues int,
  revenues_change real,
  profits numeric,
  profits_change real,
  assets numeric check (assets > 0),
  equity numeric
);

-- Insert values into tables
insert into company values 
(1, 'nasdaq', 'PYPL', 'PayPal Holdings Incorporated', NULL),
(2, 'nasdaq', 'AMZN', 'Amazon.com Inc', NULL),
(3, 'nasdaq', 'MSFT', 'Microsoft Corp.', NULL),
(4, 'nasdaq', 'MDB', 'MongoDB', NULL),
(5, 'nasdaq', 'DBX', 'Dropbox', NULL),
(6, 'nasdaq', 'AAPL', 'Apple Incorporated', NULL),
(7, 'nasdaq', 'CTXS', 'Citrix Systems', NULL),
(8, 'nasdaq', 'GOOGL', 'Alphabet', NULL),
(9, 'nyse', 'IBM', 'International Business Machines Corporation', NULL),
(10, 'nasdaq', 'ADBE', 'Adobe Systems Incorporated', NULL),
(11, NULL, NULL, 'Stripe', NULL),
(12, NULL, NULL, 'Amazon Web Services', 2),
(13, NULL, NULL, 'Google LLC', 8),
(14, 'nasdaq', 'EBAY', 'eBay, Inc.', NULL);


insert into tag_company (tag, company_id) values 
('actionscript', 10),
('actionscript-3', 10),
('amazon', 2),
('amazon-api', 2),
('amazon-appstore', 2),
('amazon-cloudformation', 12),
('amazon-cloudfront', 12),
('amazon-cloudsearch', 12),
('amazon-cloudwatch', 12),
('amazon-cognito', 12),
('amazon-data-pipeline', 12),
('amazon-dynamodb', 12),
('amazon-ebs', 12),
('amazon-ec2', 12),
('amazon-ecs', 12),
('amazon-elastic-beanstalk', 12),
('amazon-elasticache', 12),
('amazon-elb', 12),
('amazon-emr', 12),
('amazon-fire-tv', 2),
('amazon-glacier', 12),
('amazon-kinesis', 12),
('amazon-lambda', 12),
('amazon-mws', 12),
('amazon-rds', 12),
('amazon-rds-aurora', 12),
('amazon-redshift', 12),
('amazon-route53', 12),
('amazon-s3', 12),
('amazon-ses', 12),
('amazon-simpledb', 12),
('amazon-sns', 12),
('amazon-sqs', 12),
('amazon-swf', 12),
('amazon-vpc', 12),
('amazon-web-services', 12),
('android', 13),
('android-pay', 13),
('applepay', 6),
('applepayjs', 6),
('azure', 3),
('citrix', 7),
('cognos', 9),
('dropbox', 5),
('dropbox-api', 5),
('excel', 3),
('google-spreadsheet', 13),
('ios', 6),
('ios8', 6),
('ios9', 6),
('mongodb', 4),
('osx', 6),
('paypal', 1),
('sql-server', 3),
('stripe-payments', 11),
('windows', 3);

insert into tag_type (tag, type) values 
('amazon-cloudformation', 'cloud'),
('amazon-cloudfront', 'cloud'),
('amazon-cloudsearch', 'cloud'),
('amazon-cloudwatch', 'cloud'),
('amazon-cognito', 'cloud'),
('amazon-cognito', 'identity'),
('amazon-data-pipeline', 'cloud'),
('amazon-dynamodb', 'cloud'),
('amazon-dynamodb', 'database'),
('amazon-ebs', 'cloud'),
('amazon-ec2', 'cloud'),
('amazon-ecs', 'cloud'),
('amazon-elastic-beanstalk', 'cloud'),
('amazon-elasticache', 'cloud'),
('amazon-elb', 'cloud'),
('amazon-emr', 'cloud'),
('amazon-glacier', 'cloud'),
('amazon-glacier', 'storage'),
('amazon-kinesis', 'cloud'),
('amazon-lambda', 'cloud'),
('amazon-mws', 'api'),
('amazon-rds-aurora', 'cloud'),
('amazon-rds', 'cloud'),
('amazon-rds-aurora', 'database'),
('amazon-rds', 'database'),
('amazon-redshift', 'cloud'),
('amazon-route53', 'cloud'),
('amazon-s3', 'cloud'),
('amazon-ses', 'cloud'),
('amazon-simpledb', 'cloud'),
('amazon-simpledb', 'database'),
('amazon-sns', 'cloud'),
('amazon-sqs', 'cloud'),
('amazon-swf', 'cloud'),
('amazon-vpc', 'cloud'),
('amazon-web-services', 'cloud'),
('amazon', 'company'),
('android-pay', 'payment'),
('android', 'mobile-os'),
('applepay', 'payment'),
('applepayjs', 'payment'),
('azure', 'cloud'),
('citrix', 'company'),
('dropbox-api', 'api'),
('dropbox-api', 'api'),
('dropbox-api', 'api'),
('dropbox', 'storage'),
('dropbox', 'cloud'),
('dropbox', 'company'),
('excel', 'spreadsheet'),
('google-spreadsheet', 'spreadsheet'),
('ios', 'mobile-os'),
('ios8', 'mobile-os'),
('ios9', 'mobile-os'),
('mongodb', 'database'),
('osx', 'os'),
('paypal', 'payment'),
('paypal', 'company'),
('sql-server', 'database'),
('stripe-payments', 'payment'),
('windows', 'os');


COPY stackoverflow (tag, date, question_count, question_pct, unanswered_count, unanswered_pct) 
	FROM PROGRAM 'curl "https://assets.datacamp.com/production/repositories/3567/datasets/1e9257c9d86e03a979124c6d99a0ff154da953fd/stackexchange.csv"' (DELIMITER ',', FORMAT CSV, HEADER, NULL 'NA');
	
COPY fortune500
	FROM PROGRAM 'curl "https://assets.datacamp.com/production/repositories/3567/datasets/19cf8e7841e26d71feb3516c7a4b135aff8a8b4f/fortune.csv"' (DELIMITER ',', FORMAT CSV, HEADER, NULL 'NA');


-- Select the count of the number of rows
SELECT count(*)
  FROM fortune500;


-- Select the count of ticker, 
-- subtract from the total number of rows, 
-- and alias as missing
SELECT count(*) - count(ticker) AS missing
  FROM fortune500;


-- Select the count of profits_change, 
-- subtract from total number of rows, and alias as missing
SELECT count(*) - count(profits_change) AS missing
  FROM fortune500;


-- Select the count of industry, 
-- subtract from total number of rows, and alias as missing
SELECT count(*) - count(industry) AS missing
  FROM fortune500;

-- Select company names
SELECT company.name
  FROM company
      INNER JOIN fortune500
      ON company.ticker = fortune500.ticker;


-- Count the number of tags with each type
SELECT type, count(*) AS count
  FROM tag_type
 -- To get the count for each type, what do you need to do?
GROUP BY type
 -- Order the results with the most common
 -- tag types listed first
ORDER BY count DESC;



-- Select the 3 columns desired
SELECT company.name, tag_type.tag, tag_type.type
  FROM company
  	   -- Join to the tag_company table
       INNER JOIN tag_company 
       ON company.id = tag_company.company_id
       -- Join to the tag_type table
       INNER JOIN tag_type
       ON tag_company.tag = tag_type.tag
  -- Filter to most common type
  WHERE type='cloud';


-- Use coalesce
SELECT coalesce(industry, sector, 'Unknown') AS industry2,
       -- Don't forget to count!
       count(*)
  FROM fortune500 
-- Group by what? (What are you counting by?)
 GROUP BY industry2
-- Order results to see most common first
 ORDER by count DESC 
-- Limit results to get just the one value you want
 Limit 1;


SELECT company_original.name, title, rank
  -- Start with original company information
  FROM company AS company_original
       -- Join to another copy of company with parent
       -- company information
	   LEFT JOIN company AS company_parent
       ON company_original.parent_id = company_parent.id 
       -- Join to fortune500, only keep rows that match
       INNER JOIN fortune500 
       -- Use parent ticker if there is one, 
       -- otherwise original ticker
       ON coalesce(company_parent.ticker, 
                   company_original.ticker) = 
             fortune500.ticker
 -- For clarity, order by rank
 ORDER BY rank; 


-- Select the original value
SELECT profits_change, 
	   -- Cast profits_change
       CAST(profits_change AS integer) AS profits_change_int
  FROM fortune500;


-- Divide 10 by 3
SELECT 10/3 AS "10/3", 
       -- Cast 10 as numeric and divide by 3
       10::numeric/3 AS "10/3 To Numeric";


SELECT '3.2'::numeric,
       '-123'::numeric,
       '1e3'::numeric,
       '1e-3'::numeric,
       '02314'::numeric,
       '0002'::numeric;


-- Select the count of each value of revenues_change
SELECT revenues_change, count(revenues_change)
  FROM fortune500
 GROUP BY revenues_change
 -- order by the values of revenues_change
 ORDER BY count desc;


 -- Select the count of each revenues_change integer value
SELECT revenues_change::integer, count(revenues_change)
  FROM fortune500
 GROUP BY revenues_change::integer
 -- order by the values of revenues_change
 ORDER BY count desc;


-- Count rows 
SELECT count(*)
  FROM fortune500
 -- Where...
 WHERE revenues_change >  0;


-- Select average revenue per employee by sector
SELECT sector, 
       avg(revenues/employees::numeric) AS avg_rev_employee
  FROM fortune500
 GROUP BY sector
 -- Use the column alias to order the results
 ORDER BY avg_rev_employee;


-- Divide unanswered_count by question_count
SELECT unanswered_count/question_count::numeric AS computed_pct, 
       -- What are you comparing the above quantity to?
       unanswered_pct
  FROM stackoverflow
 -- Select rows where question_count is not 0
 WHERE question_count != 0
 limit 10;


 -- Select min, avg, max, and stddev of fortune500 profits
SELECT min(profits),
       avg(profits),
       max(profits),
       stddev(profits)
  FROM fortune500
   -- What to group by?
 GROUP BY sector
 -- Order by the average profits
 ORDER BY avg;


-- Compute standard deviation of maximum values
SELECT stddev(maxval),
	   -- min
       min(maxval),
       -- max
       max(maxval),
       -- avg
       avg(maxval)
  -- Subquery to compute max of question_count by tag
  FROM (SELECT max(question_count) AS maxval
          FROM stackoverflow
         -- Compute max by...
         GROUP BY tag) AS max_results; -- alias for subquery 


-- Truncate employees
SELECT trunc(employees, -5) AS employee_bin,
       -- Count number of companies with each truncated value
       count(*)
  FROM fortune500
 -- Use alias to group
 GROUP BY employee_bin
 -- Use alias to order
 ORDER BY employee_bin;


-- Truncate employees
SELECT trunc(employees, -4) AS employee_bin,
       -- Count number of companies with each truncated value
       count(*)
  FROM fortune500
 -- Limit to which companies?
 WHERE  employees < 100000
 -- Use alias to group
 GROUP BY employee_bin
 -- Use alias to order
 ORDER BY employee_bin;


-- Select the min and max of question_count
SELECT min(question_count), 
       max(question_count)
  -- From what table?
  FROM stackoverflow
 -- For tag dropbox
 WHERE tag = 'dropbox';


 -- Create lower and upper bounds of bins
SELECT generate_series(2200, 3050, 50) AS lower,
       generate_series(2250, 3100, 50) AS upper;


-- Bins created in Step 2
WITH bins AS (
      SELECT generate_series(2200, 3050, 50) AS lower,
             generate_series(2250, 3100, 50) AS upper),
     -- Subset stackoverflow to just tag dropbox (Step 1)
     dropbox AS (
      SELECT question_count 
        FROM stackoverflow
       WHERE tag='dropbox') 
-- Select columns for result
-- What column are you counting to summarize?
SELECT lower, upper, count(question_count) 
  FROM bins  -- Created above
       -- Join to dropbox (created above), 
       -- keeping all rows from the bins table in the join
       left JOIN dropbox
       -- Compare question_count to lower and upper
         ON question_count >= lower 
        AND question_count < upper
 -- Group by lower and upper to count values in each bin
 GROUP BY lower, upper
 -- Order by lower to put bins in order
 ORDER BY lower;


-- What groups are you computing statistics by?
SELECT sector,
       -- Select the mean of assets with the avg function
       avg(assets) AS mean,
       -- Select the median
       percentile_disc(0.5) WITHIN GROUP (ORDER BY assets) AS median
  FROM fortune500
 -- Computing statistics for each what?
 GROUP BY sector
 -- Order results by a value of interest
 ORDER BY mean;


-- To clear table if it already exists;
-- fill in name of temp table
DROP TABLE IF EXISTS profit80;

-- Create the temporary table
CREATE TEMP TABLE profit80 AS 
  -- Select the two columns you need; alias as needed
  SELECT sector, 
         percentile_disc(0.8) WITHIN GROUP (ORDER BY profits) AS pct80
    -- What table are you getting the data from?
    FROM fortune500
   -- What do you need to group by?
   GROUP BY sector;
-- See what you created: select all columns and rows 
-- from the table you created
SELECT * 
  FROM profit80;



-- Code from previous step
DROP TABLE IF EXISTS profit80;
CREATE TEMP TABLE profit80 AS
  SELECT sector, 
         percentile_disc(0.8) WITHIN GROUP (ORDER BY profits) AS pct80
    FROM fortune500 
   GROUP BY sector;
-- Select columns, aliasing as needed
SELECT title, fortune500.sector, 
       profits, profits/pct80 AS ratio
-- What tables do you need to join?  
  FROM fortune500 
       LEFT JOIN profit80
-- How are the tables joined?
       ON fortune500.sector=profit80.sector
-- What rows do you want to select?
 WHERE profits > pct80;


-- To clear table if it already exists
DROP TABLE IF EXISTS startdates;
-- Create temp table syntax
CREATE TEMP TABLE startdates AS
-- Compute the minimum date for each what?
SELECT tag,
       min(date) AS mindate
  FROM stackoverflow
 -- What do you need to compute the min date for each tag?
 GROUP BY tag;
 -- Look at the table you created
 SELECT * 
   FROM startdates;


-- To clear table if it already exists
DROP TABLE IF EXISTS startdates;

CREATE TEMP TABLE startdates AS
SELECT tag, min(date) AS mindate
  FROM stackoverflow
 GROUP BY tag;
 
-- Select tag (Remember the table name!) and mindate
SELECT startdates.tag, 
       mindate, 
       -- Select question count on the min and max days
	   so_min.question_count AS min_date_question_count,
       so_max.question_count AS max_date_question_count,
       -- Compute the change in question_count (max- min)
       so_max.question_count - so_min.question_count AS change
  FROM startdates
       -- Join startdates to stackoverflow with alias so_min
       INNER JOIN stackoverflow AS so_min
          -- What needs to match between tables?
          ON startdates.tag = so_min.tag
         AND startdates.mindate = so_min.date
       -- Join to stackoverflow again with alias so_max
       INNER JOIN stackoverflow AS so_max
       	  -- Again, what needs to match between tables?
          ON startdates.tag = so_max.tag
         AND so_max.date = '2018-09-25';


DROP TABLE IF EXISTS correlations;
-- Create temp table 
CREATE TEMP TABLE correlations AS
-- Select each correlation
SELECT 'profits'::varchar AS measure,
       -- Compute correlations
       corr(profits, profits) AS profits,
       corr(profits, profits_change) AS profits_change,
       corr(profits, revenues_change) AS revenues_change
  FROM fortune500;

DROP TABLE IF EXISTS correlations;

CREATE TEMP TABLE correlations AS
SELECT 'profits'::varchar AS measure,
       corr(profits, profits) AS profits,
       corr(profits, profits_change) AS profits_change,
       corr(profits, revenues_change) AS revenues_change
  FROM fortune500;
-- Add a row for profits_change
-- Insert into what table?
INSERT INTO correlations
-- Follow the pattern of the select statement above
-- Using profits_change instead of profits
SELECT 'profits_change'::varchar AS measure,
       corr(profits_change, profits) AS profits,
       corr(profits_change, profits_change) AS profits_change,
       corr(profits_change, revenues_change) AS revenues_change
  FROM fortune500;

-- Repeat the above, but for revenues_change
INSERT INTO correlations
SELECT 'revenues_change'::varchar AS measure,
       corr(revenues_change, profits) AS profits,
       corr(revenues_change, profits_change) AS profits_change,
       corr(revenues_change, revenues_change) AS revenues_change
  FROM fortune500;
-- Select each column, rounding the correlations
SELECT measure, 
       round(profits::numeric, 2) AS profits,
       round(profits_change::numeric, 2) AS profits_change,
       round(revenues_change::numeric, 2) AS revenues_change
  FROM correlations;


