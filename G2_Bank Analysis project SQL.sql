create database Project;
use Project;


SHOW VARIABLES LIKE "secure_file_priv";

truncate table project.finance_1;
SELECT * FROM finance_1;

set global local_infile=on;

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Finance_1.csv'
INTO TABLE Finance_1
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;



# Yearwise loan amount stats
Select * from finance_1;
Select SUBSTRING(issue_d, -2) AS a_year, COUNT(*) AS count,sum(loan_amnt) as loan_amnt
from project.finance_1
group by a_year
order by a_year;

# Grade and sub grade wise revol_bal
select * from finance_2;
select finance_1.grade,finance_1.sub_grade,sum(finance_2.revol_bal)
from finance_2
inner join finance_1
on finance_1.id = finance_2.id
group by finance_1.grade, finance_1.sub_grade
order by finance_1.grade, finance_1.sub_grade asc;

# toatl payment for verified status vs non-verified status
SELECT
  project.finance_1.verification_status,
  ROUND(SUM(total_pymnt), 2) AS total_sum,
  ROUND(SUM(total_pymnt) / (SELECT SUM(total_pymnt) FROM project.finance_2) * 100, 2) AS percentage
FROM project.finance_2
INNER JOIN project.finance_1 ON project.finance_1.id = project.finance_2.id
GROUP BY project.finance_1.verification_status;

 
# State wise last_credit_pull_d wise loan status
SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
 select
   finance_1.addr_state,
   count(finance_1.loan_status),
   finance_2.last_credit_pull_d
   from finance_2
     inner join   finance_1 on finance_1.id =finance_2.id
group by finance_1.addr_state 
order by finance_1.addr_state asc;

# Homeownership Vs. last payment date stats

select project.finance_1.home_ownership,project.finance_2.last_pymnt_d,project.finance_2.last_pymnt_amnt ,count(project.finance_2.last_pymnt_d)
from project.finance_2
inner join project.finance_1
on project.finance_1.id=project.finance_2.id
group by project.finance_1.home_ownership;


SELECT
  project.finance_1.verification_status,
  ROUND(SUM(total_pymnt), 2) AS total_sum,
  ROUND(SUM(total_pymnt) / (SELECT SUM(total_pymnt) FROM project.finance_2) * 100, 2) AS percentage
FROM project.finance_2
INNER JOIN project.finance_1 ON project.finance_1.id = project.finance_2.id
GROUP BY project.finance_1.verification_status;
