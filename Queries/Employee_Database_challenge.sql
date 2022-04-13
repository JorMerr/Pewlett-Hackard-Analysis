-- Gather all employees still working at P-H who are likely to retire, and determine most recent title

-- Retreive employee number, first and last name from employees table
SELECT emp_no, first_name, last_name
FROM employees

-- Retrieve title, from date and to date from Titles table
SELECT title, from_date, to_date
FROM titles

-- Join both tables into new table on primary key emp_no
SELECT e.emp_no,
	e.first_name,
	e.last_name,
	t.title,
	t.from_date,
	t.to_date
INTO retirement_titles
FROM employees as e
	INNER JOIN titles as t
		ON (e.emp_no = t.emp_no)
-- Filter by birth date between 1952 and 1955, and organize by employee number in ascending order
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY emp_no ASC;

-- Use Dictinct with Orderby to remove duplicate rows, find most recent title for employees retiring who still work at P-H
SELECT DISTINCT ON (emp_no) emp_no,
first_name,
last_name,
title

INTO unique_titles
FROM retirement_titles
WHERE to_date = ('9999-01-01')
ORDER BY emp_no ASC, to_date DESC;


-- Retrieve the number of employees by their most recent job title who are about to retire.
SELECT COUNT(ut.title), title
INTO retiring_titles
FROM unique_titles as ut
GROUP BY ut.title
ORDER BY ut.count DESC;


-- Create a Mentorship Eligibility table to hold employees eligible to participate
SELECT DISTINCT ON (e.emp_no) e.emp_no,
	e.first_name,
	e.last_name,
	e.birth_date,
	de.from_date,
	de.to_date,
	t.title
INTO mentorship_eligibility
FROM employees as e
	INNER JOIN dept_employees as de
		ON (e.emp_no = de.emp_no)
	INNER JOIN titles as t
		ON (e.emp_no = t.emp_no)
-- Filter to_date column for active employees, and by birth date for the year 1965, and organize by employee number in ascending order
WHERE de.to_date = ('9999-01-01')
AND (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY emp_no ASC;

