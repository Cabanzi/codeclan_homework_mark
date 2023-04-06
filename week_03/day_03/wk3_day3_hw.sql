
-- Q1
SELECT
	count(id) AS employees_missing_info
FROM employees
WHERE grade IS NULL 
AND salary IS NULL;

--Q2 
SELECT 
	department,
	concat(first_name, ' ', last_name) AS full_name
FROM employees 
ORDER BY department, last_name;

--Q3 
SELECT 
	*
FROM employees 
WHERE last_name LIKE 'A%'
ORDER BY  salary DESC
LIMIT 10;

--Q4 
SELECT 
count(id) AS num_employees,
department
FROM employees
WHERE start_date BETWEEN '2003-01-01' AND '2003-12-31'
GROUP BY department 

--Q5 
SELECT 
department,
fte_hours,
count(id) AS num_employees
FROM employees 
GROUP BY fte_hours, department 
ORDER BY department, fte_hours

--Q6 
SELECT 
count(*) AS employee_num,
pension_enrol
FROM employees
GROUP BY pension_enrol

--Q7 
SELECT 
	*
FROM employees
WHERE department = 'Accounting'
AND pension_enrol IS FALSE
ORDER BY salary DESC NULLS LAST 
LIMIT 1;

--Q8 
SELECT 
	country, 
	count(id) AS num_employees,
	round(avg(salary), 2) AS avg_salary 
FROM employees 
GROUP BY country 
HAVING count(id) > 30
ORDER BY avg_salary

--Q9
SELECT 
	first_name,
	last_name,
	fte_hours,
	salary,
	salary * fte_hours AS effective_yearly_salary
FROM employees 
WHERE salary * fte_hours > 30000

--Q10 
SELECT 
	*
FROM employees INNER JOIN teams
ON employees.team_id = teams.id
WHERE teams.name = 'Data Team 1' OR teams.name = 'Data Team 2'
ORDER BY name 

--Q11
SELECT 
	employees.first_name,
	employees.last_name,
	pay_details.local_tax_code
FROM employees INNER JOIN pay_details
ON employees.pay_detail_id = pay_details.id
WHERE local_tax_code IS NULL 

--Q12
SELECT 
	employees.id, 
(48 * 35 * teams.charge_cost::int - employees.salary) * employees.fte_hours AS expected_profit 
FROM employees INNER JOIN teams 
ON employees.team_id = teams.id 
ORDER BY expected_profit 

--Q13
SELECT 
	first_name,
	last_name,
	salary
FROM employees 
WHERE 
	fte_hours = (SELECT
		fte_hours	
	FROM employees 
	GROUP BY fte_hours
	ORDER BY count(id) 
	LIMIT 1) 
AND country = 'Japan'
ORDER BY salary 
LIMIT 1;

--Q14
SELECT 
	department,
	count(id) AS no_name_employees
FROM employees 
WHERE first_name IS NULL 
GROUP BY department 
HAVING count(id) > 1
ORDER BY no_name_employees DESC, department 

--Q15
SELECT 
	first_name, 
	count(id) AS count
FROM employees
WHERE first_name IS NOT NULL 
GROUP BY first_name 
HAVING count(id) > 1
ORDER BY count DESC, first_name 

--Q16

SELECT department, 
SUM(CAST(grade = 1 AS INTEGER)) / CAST(COUNT(*) AS REAL) as proportion_grade1
FROM employees
GROUP BY department;
FROM employees 