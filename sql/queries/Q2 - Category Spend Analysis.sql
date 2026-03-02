-- Business Question 2

-- Where is money actually being spent ?

	WITH category_spend AS (
    	SELECT
        	category,
        	SUM(spend) AS total_category_spend
    	FROM fact_spends
    	GROUP BY category
	),
	
	overall_spend AS (
    	SELECT 
			SUM(total_category_spend) AS total_spend
    	FROM category_spend
	)
	
	SELECT
    	c.category,
    	c.total_category_spend,
    	ROUND(c.total_category_spend / o.total_spend * 100, 2) AS spend_contribution_pct
	FROM 
		category_spend c
	CROSS JOIN 
		overall_spend o
	ORDER BY 
		spend_contribution_pct DESC;