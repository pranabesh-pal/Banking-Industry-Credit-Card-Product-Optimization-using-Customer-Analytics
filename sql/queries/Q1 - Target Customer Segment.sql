-- Business Question 1

-- Who should we target first ?

	WITH customer_avg_monthly_spend AS (
		SELECT
			customer_id,
			ROUND(SUM(spend) / COUNT(DISTINCT month), 2) AS avg_monthly_spend
		FROM fact_spends
		GROUP BY customer_id
	),

	customer_profile AS (
		SELECT
			d.customer_id,
			d.age_group,
			d.occupation,
			d.city,
			d.avg_income,
			cams.avg_monthly_spend
		FROM dim_customers d
		INNER JOIN customer_avg_monthly_spend cams
			ON d.customer_id = cams.customer_id
	),

	segment_utilisation AS (
		SELECT
			age_group,
			occupation,
			city,
			AVG(avg_monthly_spend) AS avg_spend,
			AVG(avg_income) AS avg_income,
			AVG(avg_monthly_spend / avg_income) AS income_utilisation_pct
		FROM customer_profile
		GROUP BY
			age_group, 
			occupation,
			city
	)

	SELECT
		age_group,
		occupation,
		city,
		ROUND(income_utilisation_pct * 100, 2) AS income_utilisation_pct
	FROM segment_utilisation
	ORDER BY income_utilisation_pct DESC ;

	