--- 1.
SELECT CONCAT(EmpFname,' ',EmpLname) as FullName
FROM EmployeeInfo
WHERE EmpFname LIKE 'S%'
AND  DOB  BETWEEN '1970-05-02' AND '1975-12-31';

--- 2.
SELECT Department, COUNT(EmpID) as DeptEmpCount
FROM EmployeeInfo
GROUP BY Department
HAVING COUNT(EmpID)<2
ORDER BY DeptEmpCount DESC;

-- 3
SELECT CONCAT(EmpFname,' ',EmpLname) as FullName
FROM EmployeeInfo e INNER JOIN EmployeePosition p
ON e.EmpID = p.EmpID
WHERE p.EmpPosition LIKE 'Manager%';