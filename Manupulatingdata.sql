-- 1. Create a copy of EMP table as EMPTEST.
CREATE TABLE EmpTest AS
SELECT * FROM Emp;

-- 2. Insert a new employee record into EMPTEST.
INSERT INTO EmpTest (Eid, Ename, Salary)
VALUES (1234, 'Sowmya', 5000);

-- 3. Increase the salary of TURNER by 15%.
UPDATE EmpTest
SET Salary = Salary * 1.15
WHERE Ename = 'TURNER';

SELECT *
FROM EmpTest
WHERE Ename = 'TURNER';

-- 4. Update SMITH's salary equal to SCOTT's salary.
UPDATE EmpTest
SET Salary = (
    SELECT Salary
    FROM EmpTest
    WHERE Ename = 'SCOTT'
)
WHERE Ename = 'SMITH';

-- 5. Increase the salary by 10% for employees working in NEW YORK.
UPDATE EmpTest
SET Salary = Salary * 1.10
WHERE Deptno IN (
    SELECT Deptno
    FROM Dept
    WHERE Loc = 'NEW YORK'
);

-- 6. Set commission of all employees to NULL.
UPDATE EmpTest
SET Comm = NULL;

-- 7. Delete employees belonging to SALES department.
DELETE FROM EmpTest
WHERE Deptno = (
    SELECT Deptno
    FROM Dept
    WHERE Dname = 'SALES'
);

-- 8. Delete all employees working in the same department as the given employee except that employee.
DELETE FROM EmpTest
WHERE Deptno = (
    SELECT Deptno
    FROM EmpTest
    WHERE Ename = '&ENAME'
)
AND Ename <> '&ENAME';

-- 9. Create EMP2 table with Empno, Ename and Sal structure only.
CREATE TABLE Emp2 AS
SELECT Empno, Ename, Sal
FROM Emp
WHERE 1 = 2;

-- 10. Create EMP3 table with Empno and Job structure only.
CREATE TABLE Emp3 AS
SELECT Empno, Job
FROM Emp
WHERE 1 = 2;

-- 11. Insert data into EMP2 and EMP3 using INSERT ALL.
INSERT ALL
INTO Emp2 (Empno, Ename, Sal)
VALUES (Empno, Ename, Sal)
INTO Emp3 (Empno, Job)
VALUES (Empno, Job)
SELECT Empno, Ename, Sal, Job
FROM Emp;

-- 12. Truncate EMP2 table and insert new records.
TRUNCATE TABLE Emp2;

INSERT INTO Emp2
VALUES (7788, 'SMITH', 4500);

INSERT INTO Emp2
VALUES (7654, 'JACK', 3500);

-- 13. Commit the transaction.
COMMIT;

-- 14. Merge EMP table data into EMP2.
MERGE INTO Emp2 E2
USING Emp E
ON (E2.Empno = E.Empno)
WHEN MATCHED THEN
UPDATE
SET E2.Ename = E.Ename,
    E2.Sal = E.Sal
WHEN NOT MATCHED THEN
INSERT (Empno, Ename, Sal)
VALUES (E.Empno, E.Ename, E.Sal);

-- 15. Display the contents of EMP2.
SELECT *
FROM Emp2;

-- 16. Rollback the transaction.
ROLLBACK;

-- 17. Merge employees having salary greater than 3000 into EMP2.
MERGE INTO Emp2 E2
USING (
    SELECT *
    FROM Emp
    WHERE Sal > 3000
) E
ON (E2.Empno = E.Empno)
WHEN MATCHED THEN
UPDATE
SET E2.Ename = E.Ename,
    E2.Sal = E.Sal
WHERE E.Empno = 7788
WHEN NOT MATCHED THEN
INSERT (Empno, Ename, Sal)
VALUES (E.Empno, E.Ename, E.Sal);

-- 18. Display the contents of EMP2.
SELECT *
FROM Emp2;

-- 19. Create a new user WIPRO and grant CONNECT and RESOURCE privileges.
CREATE USER WIPRO IDENTIFIED BY wipro;

GRANT CONNECT, RESOURCE TO WIPRO;

-- 20. Grant all privileges on EMP table to WIPRO.
GRANT ALL
ON Emp
TO WIPRO;

-- 21. Delete employees from EMP where department number is 10.
DELETE FROM Emp
WHERE Deptno = 10;

-- 22. Delete employees from SCOTT.EMP where department number is 10.
DELETE FROM Scott.Emp
WHERE Deptno = 10;

-- 23. Rollback the transaction.
ROLLBACK;

-- 24. Display employees from SCOTT.EMP where department number is 10.
SELECT *
FROM Scott.Emp
WHERE Deptno = 10;

-- 25. Lock EMP table rows for update with a wait time of 20 seconds.
SELECT *
FROM Emp
FOR UPDATE WAIT 20;

-- 26. Rollback the transaction.
ROLLBACK;