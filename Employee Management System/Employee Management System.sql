CREATE TABLE departments (
  department_id   NUMBER(4) PRIMARY KEY,
  department_name VARCHAR2(30) NOT NULL
);

CREATE TABLE employees (
  employee_id    NUMBER(6) PRIMARY KEY,
  employee_name  VARCHAR2(50) NOT NULL,
  department_id  NUMBER(4),
  hire_date      DATE,
  salary         NUMBER(10,2),
  CONSTRAINT fk_dept FOREIGN KEY (department_id) REFERENCES departments (department_id)
);


INSERT INTO departments (department_id, department_name)
VALUES (10, 'IT');

INSERT INTO departments (department_id, department_name)
VALUES (20, 'Finance');

INSERT INTO employees (employee_id, employee_name, department_id, hire_date, salary)
VALUES (1001, 'John Doe', 10, TO_DATE('2023-01-01', 'YYYY-MM-DD'), 5000);

INSERT INTO employees (employee_id, employee_name, department_id, hire_date, salary)
VALUES (1002, 'Jane Smith', 10, TO_DATE('2022-08-15', 'YYYY-MM-DD'), 6000);

INSERT INTO employees (employee_id, employee_name, department_id, hire_date, salary)
VALUES (1003, 'Mike Johnson', 20, TO_DATE('2021-06-01', 'YYYY-MM-DD'), 7000);

select * from departments;
select * from employees;

-----------------------------------------------------------------------------
-- Procedure to insert a new employee
CREATE OR REPLACE PROCEDURE insert_employee(
  emp_id    IN employees.employee_id%TYPE,
  emp_name  IN employees.employee_name%TYPE,
  dept_id   IN employees.department_id%TYPE,
  hire_dt   IN employees.hire_date%TYPE,
  emp_salary IN employees.salary%TYPE
)
IS
BEGIN
  INSERT INTO employees(employee_id, employee_name, department_id, hire_date, salary)
  VALUES(emp_id, emp_name, dept_id, hire_dt, emp_salary);
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('Employee inserted successfully.');
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Error occurred while inserting employee.');
END;
/

-- Procedure to update an employee's salary
CREATE OR REPLACE PROCEDURE update_employee_salary(
  emp_id       IN employees.employee_id%TYPE,
  new_salary   IN employees.salary%TYPE
)
IS
BEGIN
  UPDATE employees
  SET salary = new_salary
  WHERE employee_id = emp_id;
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('Employee salary updated successfully.');
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Error occurred while updating employee salary.');
END;
/

-- Procedure to delete an employee
CREATE OR REPLACE PROCEDURE delete_employee(
  emp_id  IN employees.employee_id%TYPE
)
IS
BEGIN
  DELETE FROM employees
  WHERE employee_id = emp_id;
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('Employee deleted successfully.');
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Error occurred while deleting employee.');
END;
/

-- Procedure to retrieve employee details
CREATE OR REPLACE PROCEDURE get_employee_details(
  emp_id IN employees.employee_id%TYPE
)
IS
  emp_name employees.employee_name%TYPE;
  dept_name departments.department_name%TYPE;
  hire_date employees.hire_date%TYPE;
  salary employees.salary%TYPE;
BEGIN
  SELECT e.employee_name, d.department_name, e.hire_date, e.salary
  INTO emp_name, dept_name, hire_date, salary
  FROM employees e
  JOIN departments d ON e.department_id = d.department_id
  WHERE e.employee_id = emp_id;

  DBMS_OUTPUT.PUT_LINE('Employee Name: ' || emp_name);
  DBMS_OUTPUT.PUT_LINE('Department Name: ' || dept_name);
  DBMS_OUTPUT.PUT_LINE('Hire Date: ' || hire_date);
  DBMS_OUTPUT.PUT_LINE('Salary: ' || salary);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Employee not found.');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error occurred while retrieving employee details.');
END;
/

-- Procedure to calculate salary increments for an employee
CREATE OR REPLACE PROCEDURE calculate_salary_increment(
  emp_id IN employees.employee_id%TYPE,
  increment_percentage IN NUMBER
)
IS
  old_salary employees.salary%TYPE;
  new_salary employees.salary%TYPE;
BEGIN
  SELECT salary INTO old_salary
  FROM employees
  WHERE employee_id = emp_id;

  new_salary := old_salary + (old_salary * increment_percentage / 100);

  UPDATE employees
  SET salary = new_salary
  WHERE employee_id = emp_id;

  COMMIT;
  DBMS_OUTPUT.PUT_LINE('Salary increment applied successfully.');
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Employee not found.');
  WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Error occurred while calculating salary increment.');
END;
/

-- Procedure to calculate average salary for a department
CREATE OR REPLACE PROCEDURE calculate_average_salary(
  dept_id IN departments.department_id%TYPE
)
IS
  avg_salary NUMBER;
BEGIN
  SELECT AVG(salary)
  INTO avg_salary
  FROM employees
  WHERE department_id = dept_id;

  DBMS_OUTPUT.PUT_LINE('Average Salary for Department ' || dept_id || ': ' || avg_salary);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Department not found.');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error occurred while calculating average salary.');
END;
/

-- Procedure to update salary increment by 20% for all employees
CREATE OR REPLACE PROCEDURE update_salary_increment_by_20_percent
IS
BEGIN
  UPDATE employees
  SET salary = salary + (salary * 0.2); -- Increase salary by 20%
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('Salary increment of 20% applied to all employees successfully.');
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Error occurred while updating salary increment.');
END;
/

-------------------------------------------------------------

DECLARE
  emp_id    employees.employee_id%TYPE;
  emp_name  employees.employee_name%TYPE;
  dept_name departments.department_name%TYPE;
BEGIN
  SELECT e.employee_id, e.employee_name, d.department_name
  INTO emp_id, emp_name, dept_name
  FROM employees e
  JOIN departments d ON e.department_id = d.department_id
  WHERE e.employee_id = 1001; -- Change employee ID as needed

  DBMS_OUTPUT.PUT_LINE('Employee ID: ' || emp_id);
  DBMS_OUTPUT.PUT_LINE('Employee Name: ' || emp_name);
  DBMS_OUTPUT.PUT_LINE('Department Name: ' || dept_name);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Employee not found.');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error occurred while querying employee data.');
END;
/


DECLARE
  emp_id    employees.employee_id%TYPE;
  emp_name  employees.employee_name%TYPE;
  dept_name departments.department_name%TYPE;
BEGIN
  -- Retrieve employee details
  get_employee_details(1001); -- Change employee ID as needed

  -- Calculate salary increment for an employee
  calculate_salary_increment(1002, 10); -- Change employee ID and increment percentage as needed

  -- Calculate average salary for a department
  calculate_average_salary(10); -- Change department ID as needed
END;
/

DECLARE
  emp_id    employees.employee_id%TYPE;
  emp_name  employees.employee_name%TYPE;
  dept_name departments.department_name%TYPE;
  avg_salary NUMBER;
BEGIN
  -- Retrieve employee details
  get_employee_details(1001); -- Change employee ID as needed

  -- Calculate salary increment for an employee
  calculate_salary_increment(1002, 10); -- Change employee ID and increment percentage as needed

  -- Calculate average salary for a department
  calculate_average_salary(10); -- Change department ID as needed

  -- Update salary increment by 20% for all employees
  update_salary_increment_by_20_percent;

  -- Query updated employee details
  get_employee_details(1001); -- Change employee ID as needed

  -- Calculate average salary for a department after increment
  calculate_average_salary(10); -- Change department ID as needed
END;
/

