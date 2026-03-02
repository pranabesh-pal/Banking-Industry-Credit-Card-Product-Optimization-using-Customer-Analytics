-- Business Question 4

-- Which segments already behave like credit card users ?

	WITH customer_payment_spend AS (
    	SELECT
        	customer_id,
        	SUM(spend) AS total_spend,
        	SUM(CASE WHEN payment_type = 'Credit Card' THEN spend ELSE 0 END) AS credit_card_spend
    	FROM fact_spends
    	GROUP BY customer_id
	),
	
	customer_segment AS (
    	SELECT
        	c.age_group,
        	c.occupation,
        	c.city,
        	cps.total_spend,
        	cps.credit_card_spend
    	FROM dim_customers c
    	INNER JOIN customer_payment_spend cps
        	ON c.customer_id = cps.customer_id
	)
	
	SELECT
    	age_group,
    	occupation,
    	city,
    	ROUND(SUM(credit_card_spend) / SUM(total_spend) * 100, 2) AS credit_card_spend_pct
	FROM customer_segment
	GROUP BY age_group, occupation, city
	HAVING SUM(total_spend) > 0
	ORDER BY credit_card_spend_pct DESC ;
