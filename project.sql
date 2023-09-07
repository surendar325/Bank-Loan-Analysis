use Project;

/*1.Year wise loan amount Stats*/
alter table bank
modify issue_d varchar(200);
set Sql_safe_updates=0;
update bank 
set issue_d=str_to_date(issue_d,"%d-%m-%y");
select distinct(issue_d),sum(loan_amnt)
from bank
group by issue_d;


/*2. Grade and sub grade wise revol_bal */
select bank.grade,bank.sub_grade,sum(info.revol_bal) as total_revol_bal 
from bank
left join info on bank.id=info.id 
group by bank.grade,bank.sub_grade
order by bank.grade;



/*2.Total Payment for Verified Status Vs Total Payment for Non Verified Status*/
select verification_status,round(sum(info.total_pymnt),2)
from bank
inner join info on bank.id=info.id
group by verification_status;

/*3.State wise and last_credit_pull_d wise loan status*/
select bank.addr_state,info.last_credit_pull_d,bank.loan_status
from bank inner join info on bank.id=info.id 
order by last_credit_pull_d;


/*4.Home ownership Vs last payment date stats*/
select distinct bank.home_ownership,info.last_pymnt_d,round(sum(info.last_pymnt_amnt),2)
from bank inner join info on bank.id=info.id
group by bank.home_ownership,info.last_pymnt_d
order by bank.home_ownership;
SELECT
  bank.home_ownership,
  info.last_pymnt_d,
  round(SUM(info.last_pymnt_amnt),2) AS total_amount,
  round(AVG(info.last_pymnt_amnt),2) AS avg_amount,
  COUNT(*) AS total_records
FROM  bank inner join info on bank.id=info.id
GROUP BY home_ownership, info.last_pymnt_d
ORDER BY home_ownership, info.last_pymnt_d;


select * from bank;
select * from info;


/*6.Top 10 Employees category who issued loan*/
select count(id),emp_title,
rank() over(order by count(id) desc) as Ranking 
from bank
group by emp_title
limit 10;


/*7.3rd highest loan consuming state*/
select drn.* from (
select id,Addr_state,loan_amnt,
dense_rank() over(order by loan_amnt desc) as Dense_rank_num
from bank) as Drn
where dense_rank_num=3;

/*8.Highest salary in Each Department*/
select  grade,sum(loan_amnt), 
dense_rank() over(partition by grade order by loan_amnt) as dense_rank_num
from bank
group by grade,loan_amnt;

/*9.5th highest loan distributed in each grade*/
select drn.* from 
( 
select grade,loan_amnt,
dense_rank() over(partition by grade order by loan_amnt) as dense_rank_num
from bank) as drn 
where dense_rank_num=5;

/*Minimum And Maximum intrest year wise*/
select * from bank;
select addr_state,min(int_rate),max(int_rate)
from bank
group by addr_state;
