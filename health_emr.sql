SELECT * FROM Emr

EXEC sp_rename 'dbo.Emr.[Patient ID]' , 'PatientID' , 'COLUMN';
EXEC sp_rename 'dbo.Emr.[Primary Diagnosis]' , 'Primary_Diagnosis' , 'COLUMN';
EXEC sp_rename 'dbo.Emr.[Secondary Diagnosis 1]' , 'Secondary_Diagnosis_1' , 'COLUMN';
EXEC sp_rename 'dbo.Emr.[Secondary Diagnosis 2]' , 'Secondary_Diagnosis_2' , 'COLUMN';
EXEC sp_rename 'dbo.Emr.[Procedure Code]' , 'Procedure_Code' , 'COLUMN';
EXEC sp_rename 'dbo.Emr.[Visit Date]' , 'Visit_Date' , 'COLUMN';
EXEC sp_rename 'dbo.Emr.[ Discharge_Date]' , 'Discharge_Date' , 'COLUMN';
EXEC sp_rename 'dbo.Emr.[Blood Pressure]' , 'Blood_Pressure' , 'COLUMN';
EXEC sp_rename 'dbo.Emr.[Source System]' , 'Source_System' , 'COLUMN';
EXEC sp_rename 'dbo.Emr.[Hospital Department]' , 'Hospital_Department' , 'COLUMN';
EXEC sp_rename 'dbo.Emr.[Physician ID]' , 'Physician_ID' , 'COLUMN';
EXEC sp_rename 'dbo.Emr.[Insurance Type]' , 'Insurance_Type' , 'COLUMN';
EXEC sp_rename 'dbo.Emr.[Length of Stay]' , 'Length_Of_Stay' , 'COLUMN';
EXEC sp_rename 'dbo.Emr.[Heart Rate]' , 'Heart_Rate' , 'COLUMN';
EXEC sp_rename 'dbo.Emr.[Blood Glucose]' , 'Blood_Glucose' , 'COLUMN';

ALTER TABLE Emr
ALTER COLUMN Age INT;



WITH CTE AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY
                PatientID, Age, Gender, Race, Primary_Diagnosis,
                Secondary_Diagnosis_1, Secondary_Diagnosis_2, Medication, Procedure_Code,
                Visit_Date, Discharge_Date, Length_Of_Stay, Insurance_Type, Physician_ID,
                Hospital_Department, Source_System, Blood_Pressure, Heart_Rate,
                Temperature, Blood_Glucose, Cholesterol
                ORDER BY (SELECT NULL)) AS rn
    FROM Emr
)
DELETE FROM CTE WHERE rn > 1;


UPDATE Emr
SET Age = (
    SELECT TOP 1 P50_Age
    FROM (
        SELECT 
            PERCENTILE_CONT(0.5) 
            WITHIN GROUP (ORDER BY Age) 
            OVER () AS P50_Age
        FROM Emr
        WHERE Age IS NOT NULL AND Age != 0
    ) AS T
)
WHERE Age = 0;

UPDATE Emr
SET Gender = (SELECT TOP 1 Gender FROM Emr WHERE Gender IS NOT NULL GROUP BY Gender ORDER BY COUNT(*) DESC)
WHERE Gender IS NULL;

UPDATE Emr
SET Insurance_Type = (SELECT TOP 1 Insurance_Type FROM Emr WHERE Insurance_Type IS NOT NULL GROUP BY Insurance_Type ORDER BY COUNT(*) DESC)
WHERE Insurance_Type IS NULL;


-- WHERE Blood Pressure entries are not given
UPDATE Emr
SET Blood_Pressure = 'Unknown' 
WHERE Blood_Pressure IS NULL OR Blood_Pressure NOT LIKE '%/%';


-- Split blood pressure into systolic and diastolic

ALTER TABLE Emr ADD Systolic INT, Diastolic INT;

UPDATE Emr
SET Systolic = TRY_CAST(SUBSTRING(Blood_Pressure, 1, CHARINDEX('/', Blood_Pressure) - 1) AS INT),
    Diastolic = TRY_CAST(SUBSTRING(Blood_Pressure, CHARINDEX('/', Blood_Pressure) + 1, LEN(Blood_Pressure)) AS INT)
WHERE Blood_Pressure LIKE '%/%';


-- Drop Original Blood Pressure

ALTER TABLE Emr DROP COLUMN Blood_Pressure;



-- Check for any remaining nulls
SELECT * FROM Emr WHERE Age IS NULL OR Gender IS NULL OR Blood_Glucose IS NULL;

-- Validate that there are no duplicates
SELECT PatientID, COUNT(*)
FROM Emr
GROUP BY PatientID
HAVING COUNT(*) > 1;





SELECT Visit_Date
FROM Emr
WHERE TRY_CONVERT(DATE, Visit_Date) IS NULL AND Visit_Date IS NOT NULL;

SELECT Discharge_Date
FROM Emr
WHERE TRY_CONVERT(DATE, Discharge_Date) IS NULL AND Discharge_Date IS NOT NULL;

UPDATE Emr
SET Visit_Date = NULL
WHERE TRY_CONVERT(DATE, Visit_Date) IS NULL;

UPDATE Emr
SET Visit_Date = TRY_CONVERT(DATE, Visit_Date, 105)
WHERE ISDATE(Visit_Date) = 0;

UPDATE Emr
SET Discharge_Date = NULL
WHERE TRY_CONVERT(DATE, Discharge_Date) IS NULL;

UPDATE Emr
SET Discharge_Date = TRY_CONVERT(DATE, Discharge_Date, 105)
WHERE ISDATE(Discharge_Date) = 0;

ALTER TABLE Emr
ALTER COLUMN Visit_Date DATE;

ALTER TABLE Emr
ALTER COLUMN Discharge_Date DATE;


--   Detection of Readmission Risk 

WITH VisitDuration AS(
   SELECT PatientID , Visit_Date , Discharge_Date ,
   LEAD(Visit_Date) OVER (PARTITION BY PatientID ORDER BY Visit_Date) AS Next_Visit , 
   DATEDIFF(DAY , Discharge_Date , LEAD(Visit_Date) OVER (PARTITION BY PatientID  ORDER BY Visit_Date)) AS Days_Duration
   FROM Emr
   WHERE Visit_Date IS NOT NULL AND Discharge_Date IS NOT NULL
)
SELECT * FROM VisitDuration
WHERE Days_Duration BETWEEN 1 AND 30;

-- Add Age Group column

ALTER TABLE Emr ADD Age_Group VARCHAR(20);

UPDATE Emr
SET Age_Group = 
    CASE 
        WHEN Age < 18 THEN 'Child'
        WHEN Age BETWEEN 18 AND 35 THEN 'Young Adult'
        WHEN Age BETWEEN 36 AND 60 THEN 'Adult'
        ELSE 'Senior'
    END;


-- patients with abnormal heart rate
SELECT *
FROM Emr
WHERE Heart_Rate < 50 OR Heart_Rate > 100;

-- Weekly trends
SELECT 
    DATEPART(WEEK, Visit_Date) AS Week_Num,
    COUNT(*) AS Admission_Count
FROM Emr
GROUP BY DATEPART(WEEK, Visit_Date)
ORDER BY Week_Num;

