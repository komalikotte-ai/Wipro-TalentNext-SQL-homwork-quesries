-- 1. Insert if EMPNO does not exist, otherwise Update

SET SERVEROUTPUT ON;

DECLARE
    V_EMPNO EMP.EMPNO%TYPE := &EMPNO;
    V_ENAME EMP.ENAME%TYPE := '&ENAME';
    V_SAL   EMP.SAL%TYPE := &SAL;
    CNT NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO CNT
    FROM EMP
    WHERE EMPNO = V_EMPNO;

    IF CNT = 0 THEN
        INSERT INTO EMP(EMPNO, ENAME, SAL)
        VALUES(V_EMPNO, V_ENAME, V_SAL);
        DBMS_OUTPUT.PUT_LINE('Employee Inserted');
    ELSE
        UPDATE EMP
        SET ENAME = V_ENAME,
            SAL = V_SAL
        WHERE EMPNO = V_EMPNO;
        DBMS_OUTPUT.PUT_LINE('Employee Updated');
    END IF;

    COMMIT;
END;
/

-- 2. Check whether a Number is ODD or EVEN

SET SERVEROUTPUT ON;

DECLARE
    NUM NUMBER := &NUM;
BEGIN
    IF MOD(NUM,2)=0 THEN
        DBMS_OUTPUT.PUT_LINE(NUM || ' IS EVEN');
    ELSE
        DBMS_OUTPUT.PUT_LINE(NUM || ' IS ODD');
    END IF;
END;
/

-- 3. Update Salary based on Department

SET SERVEROUTPUT ON;

DECLARE
    V_EMPNO EMP.EMPNO%TYPE := &EMPNO;
    V_DEPTNO EMP.DEPTNO%TYPE;
BEGIN
    SELECT DEPTNO
    INTO V_DEPTNO
    FROM EMP
    WHERE EMPNO = V_EMPNO;

    IF V_DEPTNO = 10 THEN
        UPDATE EMP
        SET SAL = SAL + (SAL*0.10)
        WHERE EMPNO = V_EMPNO;

        DBMS_OUTPUT.PUT_LINE('Salary Updated by 10%');

    ELSIF V_DEPTNO = 20 THEN
        UPDATE EMP
        SET SAL = SAL + (SAL*0.15)
        WHERE EMPNO = V_EMPNO;

        DBMS_OUTPUT.PUT_LINE('Salary Updated by 15%');

    ELSE
        UPDATE EMP
        SET SAL = SAL + NVL(COMM,0)
        WHERE EMPNO = V_EMPNO;

        DBMS_OUTPUT.PUT_LINE('Salary Updated with COMM');
    END IF;

    COMMIT;
END;
/

-- 4. Create MYTABLE1 and Insert Numbers from 1 to 10 (Skip 6 and 8)

CREATE TABLE MYTABLE1
(
    RESULT NUMBER
);

SET SERVEROUTPUT ON;

DECLARE
    I NUMBER := 1;
BEGIN
    WHILE I <= 10 LOOP
        IF I <> 6 AND I <> 8 THEN
            INSERT INTO MYTABLE1
            VALUES(I);
        END IF;
        I := I + 1;
    END LOOP;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Records Inserted Successfully');
END;
/

SELECT * FROM MYTABLE1;

-- 5. Display Employee Details and Calculate Net Salary

SET SERVEROUTPUT ON;

DECLARE
    V_EMPNO EMP.EMPNO%TYPE := &EMPNO;
    V_ENAME EMP.ENAME%TYPE;
    V_SAL EMP.SAL%TYPE;
    V_COMM EMP.COMM%TYPE;
    V_NETSAL NUMBER;
BEGIN
    SELECT ENAME, SAL, NVL(COMM,0)
    INTO V_ENAME, V_SAL, V_COMM
    FROM EMP
    WHERE EMPNO = V_EMPNO;

    V_NETSAL := V_SAL + V_COMM;

    DBMS_OUTPUT.PUT_LINE('Employee Number : ' || V_EMPNO);
    DBMS_OUTPUT.PUT_LINE('Employee Name   : ' || V_ENAME);
    DBMS_OUTPUT.PUT_LINE('Salary          : ' || V_SAL);
    DBMS_OUTPUT.PUT_LINE('Commission      : ' || V_COMM);
    DBMS_OUTPUT.PUT_LINE('Net Salary      : ' || V_NETSAL);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Employee does not exist.');
END;
/

-- 6. Display Complete Employee Details Using %ROWTYPE

SET SERVEROUTPUT ON;

DECLARE
    V_EMPNO EMP.EMPNO%TYPE := &EMPNO;
    EMP_REC EMP%ROWTYPE;
BEGIN
    SELECT *
    INTO EMP_REC
    FROM EMP
    WHERE EMPNO = V_EMPNO;

    DBMS_OUTPUT.PUT_LINE('Employee Number : ' || EMP_REC.EMPNO);
    DBMS_OUTPUT.PUT_LINE('Employee Name   : ' || EMP_REC.ENAME);
    DBMS_OUTPUT.PUT_LINE('Job             : ' || EMP_REC.JOB);
    DBMS_OUTPUT.PUT_LINE('Manager         : ' || EMP_REC.MGR);
    DBMS_OUTPUT.PUT_LINE('Hire Date       : ' || EMP_REC.HIREDATE);
    DBMS_OUTPUT.PUT_LINE('Salary          : ' || EMP_REC.SAL);
    DBMS_OUTPUT.PUT_LINE('Commission      : ' || NVL(EMP_REC.COMM,0));
    DBMS_OUTPUT.PUT_LINE('Department No   : ' || EMP_REC.DEPTNO);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Employee Not Found.');
END;
/

-- 7. Delete Employees by JOB Using Implicit Cursor

SET SERVEROUTPUT ON;

DECLARE
    V_JOB EMP.JOB%TYPE := UPPER('&JOB');
    V_COUNT NUMBER;
BEGIN
    DELETE FROM EMP
    WHERE JOB = V_JOB;

    V_COUNT := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(V_COUNT || ' Record(s) Deleted.');

    COMMIT;
END;
/

-- 8. Rollback the Previous DELETE Statement

BEGIN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Rollback Successful');
END;
/

-- 9. Display Top N Salaries Using Explicit Cursor

SET SERVEROUTPUT ON;

DECLARE
    V_N NUMBER := &N;
    V_COUNT NUMBER := 0;

    CURSOR C1 IS
    SELECT EMPNO, ENAME, SAL
    FROM EMP
    ORDER BY SAL DESC;

BEGIN
    FOR REC IN C1 LOOP
        EXIT WHEN V_COUNT = V_N;

        DBMS_OUTPUT.PUT_LINE(
            REC.EMPNO || ' ' ||
            REC.ENAME || ' ' ||
            REC.SAL);

        V_COUNT := V_COUNT + 1;
    END LOOP;
END;
/

-- 10. Display Employees Earning More Than Average Salary Using Explicit Cursor

SET SERVEROUTPUT ON;

DECLARE
    V_AVG EMP.SAL%TYPE;
    V_EMPNO EMP.EMPNO%TYPE;
    V_ENAME EMP.ENAME%TYPE;
    V_SAL EMP.SAL%TYPE;

    CURSOR C1 IS
    SELECT EMPNO, ENAME, SAL
    FROM EMP
    WHERE SAL > V_AVG;

BEGIN
    SELECT AVG(SAL)
    INTO V_AVG
    FROM EMP;

    DBMS_OUTPUT.PUT_LINE('Average Salary = ' || ROUND(V_AVG,2));

    OPEN C1;

    LOOP
        FETCH C1 INTO V_EMPNO, V_ENAME, V_SAL;
        EXIT WHEN C1%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(
            V_EMPNO || ' ' ||
            V_ENAME || ' ' ||
            V_SAL);
    END LOOP;

    CLOSE C1;
END;
/

-- 11. Display Employees Earning More Than 2000 and Joined After 15-JUN-1981

SET SERVEROUTPUT ON;

DECLARE
    CURSOR C1 IS
    SELECT ENAME, SAL, HIREDATE
    FROM EMP
    WHERE SAL > 2000
      AND HIREDATE > TO_DATE('15-JUN-1981','DD-MON-YYYY');

    V_ENAME EMP.ENAME%TYPE;
    V_SAL EMP.SAL%TYPE;
    V_HIREDATE EMP.HIREDATE%TYPE;

BEGIN
    OPEN C1;

    LOOP
        FETCH C1 INTO V_ENAME, V_SAL, V_HIREDATE;
        EXIT WHEN C1%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(
            V_ENAME || ' earns ' || V_SAL ||
            ' and joined the organization on ' ||
            TO_CHAR(V_HIREDATE,'DD-MON-YYYY'));
    END LOOP;

    CLOSE C1;
END;
/

-- 12. Display Hire Date in DD-MM-RRRR and Day Format (Sorted from Saturday)

SET SERVEROUTPUT ON;

DECLARE
    CURSOR C1 IS
    SELECT ENAME,
           TO_CHAR(HIREDATE,'DD-MM-RRRR') HDATE,
           TO_CHAR(HIREDATE,'DAY') DAYNAME
    FROM EMP
    ORDER BY TO_CHAR(HIREDATE,'D');

    V_ENAME EMP.ENAME%TYPE;
    V_HDATE VARCHAR2(20);
    V_DAY VARCHAR2(20);

BEGIN
    OPEN C1;

    LOOP
        FETCH C1 INTO V_ENAME, V_HDATE, V_DAY;
        EXIT WHEN C1%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(
            RPAD(V_ENAME,10) || ' ' ||
            V_HDATE || ' ' ||
            RTRIM(V_DAY));
    END LOOP;

    CLOSE C1;
END;
/

-- 13. Display Employee Names and Commission (Show "No Commission")

SET SERVEROUTPUT ON;

DECLARE
    CURSOR C1 IS
    SELECT ENAME,
           NVL(TO_CHAR(COMM),'No Commission') COMM
    FROM EMP;

    V_ENAME EMP.ENAME%TYPE;
    V_COMM VARCHAR2(30);

BEGIN
    OPEN C1;

    LOOP
        FETCH C1 INTO V_ENAME, V_COMM;
        EXIT WHEN C1%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(
            RPAD(V_ENAME,10) || ' COMM : ' || V_COMM);
    END LOOP;

    CLOSE C1;
END;
/
