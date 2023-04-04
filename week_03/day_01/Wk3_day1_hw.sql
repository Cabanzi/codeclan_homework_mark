-- Question 1
SELECT	*
FROM employees 
WHERE department = 'Human Resources'

-- Question 2
SELECT 
	first_name, last_name, country  
FROM employees 
WHERE department = 'Legal'

-- Question 3
SELECT count(*) AS Total_Employees
FROM employees
WHERE country = 'Portugal'
-- 29 employees
​
--Question 4
SELECT count(*) AS Total_Employees
FROM employees
WHERE country = 'Portugal' 
OR country = 'Spain'
​
SELECT count(*) AS Total_Employees
FROM employees
WHERE country IN ('Spain', 'Portugal')
--35 employees
​
--Question 5
SELECT count(*) AS Pay_Details
FROM pay_details 
WHERE local_account_no IS NULL 
​
--Question 6
SELECT count(*) AS Pay_Details
FROM pay_details 
WHERE local_account_no IS NULL
AND iban IS NULL-- no
​
--Question 7
SELECT 
	first_name, last_name
FROM employees 
ORDER BY last_name NULLS LAST;
​
--Question 8
SELECT 
	first_name, 
	last_name, 
	country
FROM employees 
ORDER BY 
	country ASC NULLS LAST, 
	last_name ASC NULLS LAST ;
​
--Question 9
SELECT *
FROM employees 
ORDER BY salary DESC NULLS LAST 
LIMIT 10;
​
-- Question 10
SELECT 
	first_name,
	last_name,
	salary
FROM employees 
WHERE country = 'Hungary'
ORDER BY salary ASC
LIMIT 1;
​
--Question 11
SELECT count(*) 
FROM employees 
WHERE first_name LIKE 'F%';
--30
​
--Question 12
SELECT *
FROM employees 
WHERE email LIKE '%yahoo%'
​
--Question 13
SELECT count(*)
FROM employees 
WHERE country NOT IN ('France', 'Germany')
AND pension_enrol = TRUE;
​
--Question 14
SELECT 
	max(salary) AS maximum_salary
FROM employees 
WHERE department = 'Engineering'
AND fte_hours = 1;
​
--Question 15
SELECT 
	first_name,
	last_name,
	fte_hours,
	salary,
	fte_hours * salary AS effective_yearly_salary
FROM employees; 
	
--Extension
​
--Question 16
SELECT 
	first_name,
	last_name,
	department,
	concat(first_name, ' ', last_name, ' - ', department)
FROM employees 
WHERE (first_name, last_name, department) IS NOT NULL 
​
--Question 17
SELECT 
	first_name,
	last_name,
	department,
	concat(first_name, ' ', last_name, ' - ', department, ' (joined ', EXTRACT(YEAR FROM start_date), ')')
FROM employees 
WHERE (first_name, last_name, department, start_date) IS NOT NULL 
​
--Question 18
​
SELECT 
	first_name,
	last_name,
	salary,
CASE
	WHEN salary >= 40000 THEN 'high'
	WHEN salary < 40000 THEN 'low'
	ELSE 'unknown'
END AS salary_class
FROM employees;