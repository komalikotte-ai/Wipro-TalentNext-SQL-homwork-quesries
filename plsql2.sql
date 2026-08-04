-- 14. Update STAR Column Using Parameter Cursor

ALTER TABLE EMP
ADD STAR VARCHAR2(20);

SET SERVEROUTPUT ON;

DECLARE
    V_DEPTNO NUMBER := &DEPTNO;

    CURSOR C1(P_DNO NUMBER) IS
        SELECT SAL, STAR
        FROM EMP
        WHERE DEPTNO = P_DNO
        FOR UPDATE OF STAR;

BEGIN
    FOR REC IN C1(V_DEPTNO) LOOP
        UPDATE EMP
        SET STAR = RPAD('*', TRUNC(REC.SAL/1000), '*')
        WHERE CURRENT OF C1;
    END LOOP;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('STAR column updated successfully.');
END;
/

-- 15. Promote CLERK Employees to SR CLERK and Increase Salary by 10%

SET SERVEROUTPUT ON;

DECLARE
    CURSOR C1(P_JOB VARCHAR2) IS
        SELECT JOB, SAL
        FROM EMP
        WHERE JOB = P_JOB
          AND SAL > 1000
        FOR UPDATE OF JOB, SAL;

BEGIN
    FOR REC IN C1('CLERK') LOOP
        UPDATE EMP
        SET JOB = 'SR CLERK',
            SAL = SAL * 1.10
        WHERE CURRENT OF C1;
    END LOOP;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Employees Promoted Successfully.');
END;
/

-- 16. Display Department Record and Update Employee Salaries

SET SERVEROUTPUT ON;

DECLARE
    V_DEPTNO NUMBER := &DEPTNO;
    V_DNAME DEPT.DNAME%TYPE;
    V_LOC DEPT.LOC%TYPE;

    CURSOR C1(P_DNO NUMBER) IS
        SELECT EMPNO, ENAME, SAL, DEPTNO
        FROM EMP
        WHERE DEPTNO = P_DNO
        FOR UPDATE OF SAL;

BEGIN
    SELECT DNAME, LOC
    INTO V_DNAME, V_LOC
    FROM DEPT
    WHERE DEPTNO = V_DEPTNO;

    DBMS_OUTPUT.PUT_LINE('Department No : ' || V_DEPTNO);
    DBMS_OUTPUT.PUT_LINE('Department    : ' || V_DNAME);
    DBMS_OUTPUT.PUT_LINE('Location      : ' || V_LOC);
    DBMS_OUTPUT.PUT_LINE('-----------------------------');

    FOR REC IN C1(V_DEPTNO) LOOP
        IF REC.DEPTNO = 10 THEN
            UPDATE EMP
            SET SAL = SAL * 1.15
            WHERE CURRENT OF C1;

        ELSIF REC.DEPTNO = 20 THEN
            UPDATE EMP
            SET SAL = SAL * 1.15
            WHERE CURRENT OF C1;

        ELSE
            UPDATE EMP
            SET SAL = SAL * 1.05
            WHERE CURRENT OF C1;
        END IF;

        DBMS_OUTPUT.PUT_LINE(
            REC.EMPNO || ' ' ||
            REC.ENAME || ' Salary Updated');
    END LOOP;

    COMMIT;
END;
/

-- 17. Display Employees Using REF CURSOR Based on User Choice

SET SERVEROUTPUT ON;

DECLARE
    CHOICE NUMBER := &CHOICE;

    TYPE EMP_CUR IS REF CURSOR;
    C1 EMP_CUR;

    V_EMPNO EMP.EMPNO%TYPE;
    V_ENAME EMP.ENAME%TYPE;
    V_SAL EMP.SAL%TYPE;

BEGIN
    IF CHOICE = 1 THEN
        OPEN C1 FOR
            SELECT EMPNO, ENAME, SAL
            FROM EMP
            WHERE SAL > 2000;
    ELSE
        OPEN C1 FOR
            SELECT EMPNO, ENAME, SAL
            FROM EMP
            WHERE SAL < 2000;
    END IF;

    LOOP
        FETCH C1 INTO V_EMPNO, V_ENAME, V_SAL;
        EXIT WHEN C1%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(
            'Emp No : ' || V_EMPNO ||
            '  Name : ' || V_ENAME ||
            '  Salary : ' || V_SAL
        );
    END LOOP;

    CLOSE C1;
END;
/