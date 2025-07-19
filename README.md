# InsightRx : A Prescription for healthcare decisions

## Overview
This project utilizes synthetic Electronic Medical Records (EMR) data to derive actionable insights into patient care, hospital operations, and financial performance. The workflow involves data cleaning and transformation using MS SQL Server, exploratory data analysis (EDA) with Python and the development of interactive dashboards in Power BI to visualize trends . 

The analysis focuses on key areas such as patient outcomes, cost management, readmission rates, and resource allocation, helping hospital administrators make informed, data-driven decisions. Insights and recommendations are provided on the following key areas:

Readmission rates and high-risk patient groups

Departmental performance, patient satisfaction, and operational efficiency

Financial trends, revenue opportunities, and insurance coverage


## Data Structure Overview
To ensure compliance with HIPAA and avoid the use of real patient data, this project uses synthetic EMR records generated via Python’s Faker library.

Key Data Fields:

Vital Signs: Blood pressure(Systolic/Diastolic) , heart rate, glucose levels

Diagnoses: ICD-10 codes

Procedures: CPT codes for surgeries

Patient Demographics: Age, gender, race

Insurance Coverage: Treatment costs, patient satisfaction scores

Readmission Info: Indicators of patient readmissions

This simulated dataset offers a secure, realistic platform for performing deep healthcare analytics without the risks of using real-world clinical data.

## Dashboard Preview
### 📊 Dashboard Preview

![Power BI Dashboard1](https://github.com/TayalKirti701/InsightRx/raw/main/Images/dashboard_prev1.png)
![Power BI Dashboard2](https://github.com/TayalKirti701/InsightRx/raw/main/Images/dashboard_prev2.png)
![Power BI Dashboard3](https://github.com/TayalKirti701/InsightRx/raw/main/Images/dashboard_prev3.png)
![Power BI Dashboard4](https://github.com/TayalKirti701/InsightRx/raw/main/Images/dashboard_prev4.png)
![Power BI Dashboard5](https://github.com/TayalKirti701/InsightRx/raw/main/Images/dashboard_prev5.png)

## Summary of findings

### Trends & Metrics

#### High Diabetes Readmission:
Nearly 1 in 3 adult diabetes patients (ICD-10: E11.9) are readmitted within 60 days,  highlighting a key target group for post-discharge support.

#### Top Revenue Departments:
Orthopedics and the Emergency Room generate the highest per-patient revenue, especially   among senior and adult groups

#### Seasonal Demand Patterns:
Departments such as Cardiology, Oncology, and Pediatrics experience peaks during March, June, July, and February, suggesting strategic resourcing opportunities.
     
## Challenges:

### Satisfaction Decline in Orthopedics:
Patient satisfaction in Orthopedics dropped notably after July 2024, potentially due to overcapacity and operational strain.

### Coverage Gaps:
Over 10% of patients are uninsured, while private insurers cover ~40% — indicating financial accessibility challenges.

## Insights:

### Chronic Care Gaps
High readmission rates for diabetic patients point to a need for better post-discharge education and remote monitoring to prevent avoidable returns.

### Departmental Load Patterns
Monthly spikes in departments like Cardiology and Pediatrics indicate predictable seasonal surges, providing opportunities for proactive staff and resource planning.

### Satisfaction Decline Signals
The drop in satisfaction within Orthopedics aligns with higher visit volumes, suggesting the need for process and service quality improvements.

### Insurance Access Gaps
A considerable portion of patients lack adequate coverage. Expanding financial aid and insurance partnerships could enhance access and improve financial outcomes.
