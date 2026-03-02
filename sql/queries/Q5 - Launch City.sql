-- Business Question 5

-- Which city should be pilot launch city ?

	WITH customer_spend AS (
    	SELECT
        	customer_id,
        	SUM(spend) AS total_spend
    	FROM fact_spends
    	GROUP BY customer_id
	),
	
	customer_value AS (
    	SELECT
        	c.customer_id,
        	c.city,
        	c.avg_income,
        	s.total_spend,
        	(s.total_spend / c.avg_income) AS spend_to_income_ratio
    	FROM dim_customers c
    	INNER JOIN customer_spend s
        	ON c.customer_id = s.customer_id
	),
	
	high_value_customers AS (
    	SELECT *
    	FROM customer_value
    	WHERE spend_to_income_ratio >= 0.3
	)
	
	SELECT
    	city,
    	COUNT(DISTINCT customer_id) AS high_value_customer_count,
    	ROUND(AVG(total_spend), 2) AS avg_customer_spend,
    	ROUND(AVG(spend_to_income_ratio) * 100, 2) AS avg_income_utilisation_pct
	FROM high_value_customers
	GROUP BY city
	ORDER BY high_value_customer_count DESC, avg_income_utilisation_pct DESC ;
