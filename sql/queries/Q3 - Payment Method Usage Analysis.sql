-- Business Question 3

-- Are we losing high-value customers to non-credit payment methods ?

	WITH income_threshold AS (
    	SELECT
        	PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY avg_income) AS income_cutoff
    	FROM dim_customers
	),
	
	high_value_customers AS (
    	SELECT 
			customer_id
    	FROM dim_customers
    	WHERE avg_income >= (SELECT income_cutoff FROM income_threshold)
	),
	
	payment_spend AS (
    	SELECT
        	f.payment_type,
        	SUM(f.spend) AS total_spend
    	FROM fact_spends f
    	INNER JOIN high_value_customers h
        	ON f.customer_id = h.customer_id
    	GROUP BY f.payment_type
	),
	
	total_spend AS (
    	SELECT 
			SUM(total_spend) AS overall_spend
    	FROM payment_spend
	)

	SELECT
    	p.payment_type,
    	p.total_spend,
    	ROUND(p.total_spend / t.overall_spend * 100, 2) AS payment_share_pct
	FROM payment_spend p
	CROSS JOIN total_spend t
	ORDER BY payment_share_pct DESC;
