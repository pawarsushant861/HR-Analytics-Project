create database Hr_Analytics;
use Hr_Analytics;
show tables;
select * from hr1;
select * from hr2;
show tables;

# Average Attrition Rate for All Departments

SELECT 
    AVG(dept_attrition_rate) AS average_attrition_rate
FROM
(
    SELECT department,(SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS dept_attrition_rate
    FROM hr1
    GROUP BY department
) AS temp;


#Average Hourly rate of Male Research Scientist


SELECT ROUND(AVG(HourlyRate), 2) AS avg_hourly_rate
FROM hr1
WHERE Gender = 'Male'
AND JobRole = 'Research Scientist';


#Attrition rate Vs Monthly income stats


SELECT 
	CASE 
        WHEN hr2.MonthlyIncome < 3000 THEN 'Low Income'
        WHEN hr2.MonthlyIncome BETWEEN 3000 AND 6000 THEN 'Medium Income'
        ELSE 'High Income'
    END AS Income_Group,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN hr1.Attrition = 'Yes' THEN 1 ELSE 0 END) AS Employees_Left,
    ROUND(
        (SUM(CASE WHEN hr1.Attrition = 'Yes' THEN 1 ELSE 0 END) 
        / COUNT(*)) * 100,
        2
    ) AS Attrition_Rate_Percentage
FROM hr1 JOIN hr2 ON hr1.EmployeeNumber= hr2.`Employee ID`
GROUP BY Income_Group
ORDER BY Attrition_Rate_Percentage DESC;


#Average working years for each Department


SELECT 
    hr1.Department,
    ROUND(AVG(hr2.TotalWorkingYears), 2) AS avg_working_years
FROM hr1 
JOIN hr2 
ON hr1.EmployeeNumber = hr2.`Employee ID`
GROUP BY hr1.Department
ORDER BY avg_working_years DESC;


#Job Role Vs Work life balance


SELECT hr1.JobRole,hr2.WorkLifeBalance,COUNT(*) AS employee_count
FROM hr1
JOIN hr2
ON hr1.EmployeeNumber = hr2.`Employee ID`
GROUP BY hr1.JobRole, hr2.WorkLifeBalance
ORDER BY hr1.JobRole, hr2.WorkLifeBalance;


#Attrition rate Vs Year since last promotion relation


SELECT hr2.YearsSinceLastPromotion, COUNT(*) AS total_employees,
    SUM(CASE WHEN hr1.Attrition = 'Yes' THEN 1 ELSE 0 END) AS attrition_count,
    ROUND(
        SUM(CASE WHEN hr1.Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS attrition_rate_percent
FROM hr1 JOIN hr2 ON hr1.EmployeeNumber = hr2.`Employee ID`
GROUP BY hr2.YearsSinceLastPromotion
ORDER BY hr2.YearsSinceLastPromotion;





#Additional

#Average salary by Department


SELECT hr1.department as Department, round(avg(hr2.monthlyincome),2) as Average_Salary
FROM hr1 
JOIN hr2 
ON hr1.EmployeeNumber = hr2.`Employee ID`
group by hr1.department
order by Average_Salary desc;


#Job Role with highest salary


SELECT hr1.JobRole,ROUND(AVG(hr2.MonthlyIncome), 2) AS avg_salary
FROM  hr1
JOIN  hr2
ON hr1.EmployeeNumber = hr2.`Employee ID`
GROUP BY hr1.JobRole
ORDER BY avg_salary DESC
LIMIT 1;
