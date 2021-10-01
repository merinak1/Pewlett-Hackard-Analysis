
---DELIVERABLE #1
--- Retrive employees born between 1952 to 1955 by their current titles 
SELECT e.emp_no, e.first_name, e.last_name , t.title, t.from_date, t.to_date 
INTO retirement_titles 
FROM employees e
INNER JOIN titles as t
	ON (t.emp_no = e.emp_no)
WHERE (e.birth_date >= '1952-01-01' and e.birth_date <= '1955-12-31')
ORDER BY e.emp_no ;

--CHECK retirement_titles table is created
SELECT * FROM retirement_titles;

--  Most recent job title of employees who are about to retire
SELECT DISTINCT ON (emp_no) emp_no, first_name, last_name , title   
INTO unique_titles
FROM retirement_titles
ORDER BY emp_no,to_date desc;
 
--CHECK unique_titles table is created
SELECT * FROM unique_titles;

-- retrieve the number of employees by their most recent job title who are about to retire.
SELECT DISTINCT COUNT(emp_no), title 
INTO retiring_titles
FROM unique_titles 
GROUP BY title 
ORDER BY COUNT(emp_no) DESC;

SELECT COUNT(DISTINCT TITLE) FROM unique_titles

--CHECK retiring_titles table is created
SELECT * FROM retiring_titles;

-- DELIVERABLE #2
---Employees eligible to participate in a mentorship program.
SELECT DISTINCT ON (e.emp_no)e.emp_no
	, e.first_name, e.last_name, e.birth_date
	, de.from_date, de.to_date
	,t.title
INTO mentorship_eligibilty  
FROM employees as e
INNER JOIN dept_emp de
	ON (e.emp_no = de.emp_no)
INNER JOIN titles as t
	ON (t.emp_no = e.emp_no)
WHERE (e.birth_date >= '1965-01-01' and e.birth_date <= '1965-12-31')
AND de.to_date  ='9999-01-01' 
ORDER BY e.emp_no asc;

--CHECK mentorship_eligibilty table is created
SELECT  * FROM mentorship_eligibilty;


-- Deliverable #3
-- Total current roles/employees
SELECT COUNT(*) FROM titles WHERE to_date = '9999-01-01'
-- 240124 roles
-- How many roles will need to be filled as the "silver tsunami" begins to make an impact?
SELECT SUM(COUNT) FROM retiring_titles;
-- 90398 roles

-- Total current roles
SELECT COUNT(*) FROM titles WHERE to_date = '9999-01-01'
--240124 roles 

-- Are there enough qualified, retirement-ready employees in the departments to mentor the next generation of Pewlett Hackard employees?
;WITH ME_TOT AS
	(SELECT  title, COUNT (distinct EMP_NO) roles
	FROM mentorship_eligibilty me
	GROUP BY title order by 2
	 )
SELECT COALESCE(rt.title, me.title) as titles,
	 rt.count as retirees,  COALESCE(me.roles,0) as mentors
	 , (rt.count/me.roles) as Mentees_Per_Mentor
FROM  ME_TOT me
FULL JOIN retiring_titles rt
	on rt.title=me.title;
	
--What happens when you change the mentorship_eligibilty criteria to employees born in 1964 and 1965
SELECT DISTINCT ON (e.emp_no)e.emp_no
	, e.first_name, e.last_name, e.birth_date
	, de.from_date, de.to_date
	,t.title
INTO mentorship_eligibilty_updated 
FROM employees as e
INNER JOIN dept_emp de
	ON (e.emp_no = de.emp_no)
INNER JOIN titles as t
	ON (t.emp_no = e.emp_no)
WHERE (e.birth_date >= '1964-01-01' and e.birth_date <= '1965-12-31')
AND de.to_date  ='9999-01-01' 
ORDER BY e.emp_no asc;

;WITH ME_TOT AS
	(SELECT  title, COUNT (distinct EMP_NO) roles
	FROM mentorship_eligibilty_updated me
	GROUP BY title order by 2
	 )
SELECT COALESCE(rt.title, me.title) as titles,
	 rt.count as retirees,  COALESCE(me.roles,0) as mentors
	 , (rt.count/me.roles) as Mentees_Per_Mentor
FROM  ME_TOT me
FULL JOIN retiring_titles rt
	on rt.title=me.title;

	