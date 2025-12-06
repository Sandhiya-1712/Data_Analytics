--- 1. Display Current Date & Time
SELECT NOW() AS current_date_time;

--- 2. Display Current Date
SELECT CURDATE() AS today_date;

--- 3. Display Current Time
SELECT CURTIME() AS today_time;

--- 4. Display System Date (not cached like NOW)
SELECT SYSDATE() AS system_time;

--- 5. Time Difference Between Two Times
SELECT TIMEDIFF('15:30:00', '09:00:00') AS hours_worked;

--- 6. Date Difference in Days
SELECT DATEDIFF('2025-01-20', '2025-01-01') AS date_difference;

--- 7. Difference in Hours Between Two DateTimes
SELECT TIMESTAMPDIFF(HOUR, '2025-01-02 10:00:00', '2025-01-02 17:30:00') AS hours_used;

--- 8. Add Days to a Date
SELECT DATE_ADD('2025-01-10', INTERVAL 10 DAY) AS new_date;

--- 9. Subtract Days
SELECT DATE_SUB('2025-01-10', INTERVAL 5 DAY) AS previous_date;

--- 10. Add Hours
SELECT TIMESTAMPADD(HOUR, 5, '2025-01-03 10:00:00') AS new_time;

--- 11. Extract Year, Month, Day
SELECT YEAR(NOW()) as 'Year', MONTH(NOW()) as 'Month', DAY(NOW()) as 'Day';

--- 12. Extract Hour, Minute, Second
SELECT HOUR(NOW()) as 'Hour', MINUTE(NOW()) as 'Minute', SECOND(NOW()) as 'seconds';

--- 13. Records from Last 7 Days
SELECT * FROM data_analytics.orders WHERE order_date >= NOW() - INTERVAL 7 DAY;
SELECT * FROM data_analytics.orders WHERE order_date >= 2025-09-22 - INTERVAL 7 DAY;

--- 14. Records from Last 24 Hours
SELECT * FROM logins WHERE login_time >= NOW() - INTERVAL 1 DAY;

--- 15. Format Date Output
SELECT DATE_FORMAT(NOW(), '%d-%m-%Y %H:%i:%s') AS formatted_datetime;

--- 16. Convert String to Date
SELECT STR_TO_DATE('25-01-2025', '%d-%m-%Y') AS converted_date;

--- 17. First Day of Current Month
SELECT DATE_FORMAT(NOW(), '%Y-%m-01') AS first_day;

--- 18. Last Day of Current Month
SELECT LAST_DAY(NOW()) AS last_day;

--- 19. Get Current Week Number
SELECT WEEK(CURDATE()) AS week_number;

--- 20. Check if Year is Leap Year
SELECT IF(DAYOFYEAR(CONCAT(YEAR(CURDATE()),'-12-31')) = 366, 'Yes', 'No') AS leap_year;

--- 21. Age Calculation
SELECT TIMESTAMPDIFF(YEAR, '1995-01-10', CURDATE()) AS age_in_years;

--- 22. Convert to UNIX Timestamp
SELECT UNIX_TIMESTAMP(NOW()) AS unix_time;

--- 23. Convert UNIX Timestamp to Datetime
SELECT FROM_UNIXTIME(1706000000) AS datetime_value;

--- 24. Day Name
SELECT DAYNAME(NOW()) AS day_name;

--- 25. Month Name
SELECT MONTHNAME(NOW()) AS month_name;

--- 26. Time to Seconds Conversion
SELECT TIME_TO_SEC('02:30:10') AS total_seconds;

--- 27. Seconds to Time Format
SELECT SEC_TO_TIME(8000) AS time_format;

--- 28. Create Table with Auto Timestamp
CREATE TABLE audit_logs (
 id INT AUTO_INCREMENT PRIMARY KEY,
 activity VARCHAR(50),
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

--- 29. Auto Update Timestamp
CREATE TABLE products (
 id INT PRIMARY KEY,
 updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


