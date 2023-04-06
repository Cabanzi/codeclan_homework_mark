-- Question 1
--(a)
SELECT 
	e.first_name,
	e.last_name,
	t.name AS team_name
FROM employees AS e INNER JOIN teams AS t
ON e.team_id = t.id

-- (b)
SELECT 
	e. id,
	e.first_name,
	e.last_name,
	e.pension_enrol,
	t.name AS team_name
FROM employees AS e LEFT JOIN teams AS t
ON e.team_id = t.id
WHERE pension_enrol IS TRUE 
AND e.first_name IS NOT NULL; 

-- (c)
SELECT 
	e. id,
	e.first_name,
	e.last_name,
	t.name AS team_name,
	t.charge_cost
FROM employees AS e LEFT JOIN teams AS t
ON e.team_id = t.id
WHERE CAST(t.charge_cost AS numeric) > 80;

-- Question 2
-- (a) 
SELECT 
	e. id,
	e.first_name,
	e.last_name,
	pd.local_account_no,
	pd.local_sort_code
FROM employees AS e INNER join pay_details AS pd
ON e.pay_detail_id = pd.id
WHERE (local_account_no, pd.local_sort_code ) IS NOT NULL; 

-- (b)
SELECT 
	e. id,
	e.first_name,
	e.last_name,
	pd.local_account_no,
	pd.local_sort_code,
	t.name AS team_name
FROM 
(employees AS e INNER join pay_details AS pd
ON e.pay_detail_id = pd.id)
INNER JOIN teams AS t
ON e.team_id = t.id
WHERE (local_account_no, pd.local_sort_code ) IS NOT NULL;

-- 3 
--(a)
SELECT 
	e. id,
	t.name AS team_name
FROM employees AS e LEFT JOIN teams AS t
ON e.team_id = t.id;

-- (b) 
SELECT 
	t.name AS team_name,
	count(e.id) AS no_employees
FROM employees AS e LEFT JOIN teams AS t
ON e.team_id = t.id
GROUP BY team_name

-- (c)
SELECT 
	t.name AS team_name,
	count(e.id) AS no_employees
FROM employees AS e LEFT JOIN teams AS t
ON e.team_id = t.id
GROUP BY team_name
ORDER BY no_employees 

-- 4
--(a) SELECT 
SELECT 
    e.team_id,
    COUNT(e.id) AS no_employees,
    t.name AS team_name
FROM 
    employees AS e 
    LEFT JOIN teams AS t ON e.team_id = t.id
GROUP BY 
    e.team_id,
    team_name
ORDER BY no_employees ;

--(b)
SELECT 
    e.team_id,
    COUNT(e.id) AS no_employees,
    t.name AS team_name,
    t.charge_cost,
  CAST(t.charge_cost AS numeric) * count(e.id) AS total_day_charge
FROM 
    employees AS e 
    LEFT JOIN teams AS t ON e.team_id = t.id
GROUP BY 
    e.team_id,
    t.name,
    t.charge_cost
    ORDER BY total_day_charge;
    
   -- (c)
SELECT 
    	e.team_id,
   	 	COUNT(e.id) AS no_employees,
    	t.name AS team_name,
    	t.charge_cost
  		CAST(t.charge_cost AS numeric) * count(e.id) AS total_day_charge
FROM 
    employees AS e 
    LEFT JOIN teams AS t ON e.team_id = t.id
GROUP BY 
    e.team_id,
    t.name,
    t.charge_cost
HAVING CAST(t.charge_cost AS numeric) * count(e.id) > 5000


    ORDER BY total_day_charge;
    
-- 5
   SELECT count(DISTINCT employee_id) AS no_employees_multiple_committees
   FROM employees_committees;
   
 -- 6
SELECT COUNT(*) AS no_committee_employees
FROM employees
LEFT JOIN employees_committees
ON employees.id = employees_committees.employee_id
WHERE employees_committees.employee_id IS NULL;
  