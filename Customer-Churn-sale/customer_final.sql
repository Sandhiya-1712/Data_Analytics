CREATE TABLE Customer_Details (
    customerID VARCHAR(50),
    gender VARCHAR(10),
    SeniorCitizen INT,
    Partner VARCHAR(10),
    Dependents VARCHAR(10),
    tenure INT,
    PhoneService VARCHAR(10),
    MultipleLines VARCHAR(20),
    InternetService VARCHAR(50),
    OnlineSecurity VARCHAR(20),
    OnlineBackup VARCHAR(20),
    DeviceProtection VARCHAR(20),
    TechSupport VARCHAR(20),
    StreamingTV VARCHAR(20),
    StreamingMovies VARCHAR(20),
    Contract VARCHAR(50),
    PaperlessBilling VARCHAR(10),
    PaymentMethod VARCHAR(50),
    MonthlyCharges VARCHAR(20),
    TotalCharges VARCHAR(20),  -- IMPORTANT: keep as VARCHAR
    Churn VARCHAR(10)
);

-- checking total number of rows
select count(*) from customer_details;

-- copying table to alter data from orginal table
CREATE TABLE Customers_Clean AS
SELECT 
    customerID,
    gender,
    SeniorCitizen,
    Partner,
    Dependents,
    tenure,
    PhoneService,
    MultipleLines,
    InternetService,
    OnlineSecurity,
    OnlineBackup,
    DeviceProtection,
    TechSupport,
    StreamingTV,
    StreamingMovies,
    Contract,
    PaperlessBilling,
    PaymentMethod,

    CAST(MonthlyCharges AS DECIMAL(10,2)) AS MonthlyCharges,

    CAST(NULLIF(TRIM(TotalCharges), '') AS DECIMAL(10,2)) AS TotalCharges,

    Churn
FROM customer_details;

-- verifying the data in copied table
SELECT COUNT(*) FROM Customers_Clean;

-- check for null values
SELECT COUNT(*) 
FROM Customers_Clean
WHERE TotalCharges IS NULL;


SELECT 
    COUNT(*) AS total_rows,
    COUNT(CASE WHEN TotalCharges IS NULL THEN 1 END) AS nulls_remaining
FROM Customers_Clean;

UPDATE Customers_Clean
SET TotalCharges = 0
WHERE TotalCharges IS NULL;

CREATE TABLE Customers_Final AS
SELECT *,
    
-- creating tenure_grooup coulumn
    CASE 
        WHEN tenure <= 12 THEN '0-1 Year'
        WHEN tenure <= 24 THEN '1-2 Years'
        WHEN tenure <= 60 THEN '2-5 Years'
        ELSE '5+ Years'
    END AS tenure_group,

-- creating charge_segment column
    CASE 
        WHEN MonthlyCharges < 35 THEN 'Low'
        WHEN MonthlyCharges < 70 THEN 'Medium'
        ELSE 'High'
    END AS charge_segment,

-- creating revenue loss column
    CASE 
        WHEN Churn = 'Yes' THEN MonthlyCharges
        ELSE 0
    END AS revenue_loss

FROM Customers_Clean;

-- checking for duplicate values
SELECT customerID, COUNT(*)
FROM customers_final
GROUP BY customerID
HAVING COUNT(*) > 1;

SELECT 
    MIN(tenure), MAX(tenure),
    MIN(MonthlyCharges), MAX(MonthlyCharges)
FROM customers_final;

select * from customers_final;

-- overall churn rate
SELECT 
    COUNT(CASE WHEN Churn = 'Yes' THEN 1 END) * 100.0 / COUNT(*) AS churn_rate
FROM Customers_Final;

-- churn by contract type
SELECT 
    Contract,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),2) AS churn_rate
FROM Customers_Final
GROUP BY Contract;

-- churn by tenure group
SELECT 
    tenure_group,
    COUNT(*) AS total,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned
FROM Customers_Final
GROUP BY tenure_group;

-- revenue loss due to churn(FP&A)
SELECT 
    SUM(revenue_loss) AS total_revenue_lost
FROM Customers_Final;

-- High values customer churning
SELECT 
    charge_segment,
    SUM(revenue_loss) AS revenue_lost
FROM Customers_Final
GROUP BY charge_segment;

-- services impact on churn
SELECT 
    InternetService,
    COUNT(*) AS total,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned
FROM Customers_Final
GROUP BY InternetService;
