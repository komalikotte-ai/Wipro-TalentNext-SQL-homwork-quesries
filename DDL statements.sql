-- Q1: Create d
CREATE TABLE dept1(
    deptno INTEGER PRIMARY KEY,
    dname VARCHAR2(30) NOT NULL,
    loc VARCHAR2(30) NOT NULL
);

-- Q2: Create emp1
CREATE TABLE emp1(
    empno INTEGER PRIMARY KEY,
    ename VARCHAR2(20) NOT NULL,
    sal NUMBER(10,2) CHECK(sal>5000),
    mgr NUMBER,
    deptno INTEGER,
    FOREIGN KEY(deptno) REFERENCES dept1(deptno)
);

-- Q3: Copy tables
CREATE TABLE dept11 AS SELECT * FROM dept1;
CREATE TABLE emp11 AS SELECT * FROM emp1;

-- Q4: Add column
ALTER TABLE emp1 ADD address VARCHAR2(30);

-- Q5: Rename column
ALTER TABLE emp1 RENAME COLUMN sal TO salary;

-- Q7: Increase ename size
ALTER TABLE emp1 MODIFY ename VARCHAR2(40);

-- Q8: Allow NULL
ALTER TABLE emp1 MODIFY ename VARCHAR2(40) NULL;

-- Q9: Comment table
COMMENT ON TABLE dept1 IS 'Depts of WIPRO';

-- Q10: Comment column
COMMENT ON COLUMN dept1.deptno IS 'deptno of WIPRO';

-- Q11: Comment emp1
COMMENT ON TABLE emp1 IS 'Employees of WIPRO';

-- Q12: Comment empno
COMMENT ON COLUMN emp11.empno IS 'empno of WIPRO';

-- Q13: Remove comments
COMMENT ON TABLE emp1 IS ' ';
COMMENT ON COLUMN emp1.empno IS ' ';
COMMENT ON TABLE dept1 IS ' ';
COMMENT ON COLUMN dept1.deptno IS ' ';

-- Q14: Set unused
ALTER TABLE emp1 SET UNUSED (salary, ename);

-- Q15: Drop unused
ALTER TABLE emp1 DROP UNUSED COLUMNS;

-- Q16: Drop tables
DROP TABLE emp1;
DROP TABLE dept1;

-- Q17: Create emp1 from emp
CREATE TABLE emp1 AS SELECT * FROM emp;

-- Q18: Rename table
ALTER TABLE emp1 RENAME TO emp_test;

-- Q20: Create emp2
CREATE TABLE emp2 AS
SELECT empid, ename, sal FROM emp;

-- Q21: Drop emp2
DROP TABLE emp2;

-- Q22: Empty copy
CREATE TABLE emp2 AS
SELECT * FROM emp WHERE 1=0;

DESC emp2;
SELECT * FROM emp2;

-- Q23: Drop emp2
DROP TABLE emp2;

-- Q24: Flashback
FLASHBACK TABLE emp2 TO BEFORE DROP;

-- Q25: Flashback rename
FLASHBACK TABLE emp2 TO BEFORE DROP RENAME TO emp2_1;

-- Q26: List tables
SELECT table_name FROM user_tables;