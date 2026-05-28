create database SQL_Query_performance_analysis;
use SQL_Query_performance_analysis;

create table users(
user_id int primary key,
username varchar(50),
department varchar(50)
);

create table Logs_(
log_id int primary key,
user_id int,
query_type varchar(20),
execution_time float,
cpu_usage float,
memory_usage float,
execution_date date,
status varchar(50),
foreign key(user_id) references users(user_id)
); 

select * from logs_ l join users u on l.user_id=u.user_id;

-- Total Queries Executed
select count(*) as total_queries from logs_;

-- Total Active Users
select count(distinct user_id) as active_users from logs_;

-- Most Frequently Used Query Type
select query_type,count(*) as total
from logs_
group by query_type
order by total desc;

-- Department-wise Query Count
select department,count(*)as total_queries
from logs_ l join users u 
on l.user_id=u.user_id
group by department
order by total_queries desc;

-- Average Execution Time by Query Type
select query_type,round(avg(execution_time),2)as avg_execution_time
from logs_
group by query_type
order by avg_execution_time desc;

-- Failed Queries Count
select count(*) as failed_queries 
from logs_ where status="FAILED";

-- Success Rate
select 
round(
sum(case when status='SUCCESS' then 1 else 0 end)*100.0/count(*),
2) as success_rate 
from logs_;

-- Top 10 Most Active Users
select username,count(*) as total_queries 
from logs_ l 
join users u 
on l.user_is=u.user_id 
group by username 
order by total_queries desc 
limit 10;

-- Department with Highest CPU Usage
select department,round(avg(cpu_usage),2)as avg_cpu
from logs_ l
join users u 
on l.user_id=u.user_id
group by department
order by avg_cpu desc;

-- Department with Highest Memory Usage
select department,round(avg(memory_usage),2)as avg_memory
from logs_ l 
join users u 
on l.user_id=u.user_id
group by department
order by avg_memory;

-- Monthly Query Trend
select month(execution_date) as months,
count(*) as total_queries
from logs_
group by months
order by months;

-- Query Type with Highest Average CPU usage
select query_type, round(avg(cpu_usage),2) as avg_cpu
from logs_
group by query_type
order by avg_cpu desc;

-- Slowest Queries
select * from logs_
order by execution_time desc
limit 10;

-- Users with Failed Queries
select username,count(*) as failed_count
from logs_ l
join users u
on l.user_id=u.user_id
where status="FAILED"
group by username
order by failed_count desc;

-- Daily Query Activity
select execution_date,count(*) as total_queries 
from logs_
group by execution_date
order by execution_date;

-- Query Performance Classification
select case 
when execution_time < 1 then 'FAST'
when execution_time < 2 then 'MEDIUM'
else 'SLOW'
end as performance_category,
count(*) as total_querie
from logs_
group by performance_category;

-- Departments Generating Most Failed Queries
select department,count(*) as failed_queries
from logs_ l
join users u
on l.user_id=u.user_id
where status="FAILED"
group by department
order by failed_queries desc;

-- Resource Intensive Queries
select query_type,round(avg(cpu_usage),2)as avg_cpu,
round(avg(memory_usage),2)as avg_memory
from logs_ 
group by query_type
order by avg_cpu desc,avg_memory desc;

-- User Activity Ranking
select username,department,count(*) as total_queries,
rank() over (order by count(*) desc)as rnk
from logs_ l 
join users u
on l.user_id=u.user_id 
group by username,department;

-- Peak Query Execution Month
select month(execution_date)as months,count(*)as total_queries
from logs_
group by months
order by total_queries desc
limit 1;