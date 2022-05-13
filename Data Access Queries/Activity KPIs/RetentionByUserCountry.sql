-- Gets retention data and user country
WITH retention_data AS (
	SELECT user_country, 
		COUNT(DISTINCT USER_ID) AS installs, 
		COUNT(DISTINCT CASE WHEN EVENT_DATE - PLAYER_START_DATE = 7 THEN USER_ID END) AS retainedD7 
	FROM account_fact_user_sessions_day
	WHERE USER_COUNTRY IS NOT NULL
	AND PLAYER_START_DATE < CURRENT_DATE - 7
    AND ENVIRONMENT_ID = [YOUR TARGET ENVIRONMENT]
	GROUP BY USER_COUNTRY
)

-- Further aggregates retention data
SELECT *, 
    retainedD7/installs AS d7Retention
FROM retention_data
ORDER BY d7Retention DESC