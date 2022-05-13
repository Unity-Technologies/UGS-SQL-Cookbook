--Gets active player days
WITH activity_data AS (
	SELECT PLAYER_START_DATE, 
		EVENT_DATE, 
		EVENT_DATE - PLAYER_START_DATE AS n,
		USER_ID
	FROM FACT_USER_SESSIONS_DAY 
	GROUP BY PLAYER_START_DATE, EVENT_DATE, USER_ID
)

--Aggregates activity data
SELECT 
	PLAYER_START_DATE, 
	COUNT(DISTINCT USER_ID) AS installs,
	COUNT(DISTINCT CASE WHEN n >= 28 THEN USER_ID END) AS d28Retained,
	COUNT(DISTINCT CASE WHEN n >= 28 THEN USER_ID END)/COUNT(DISTINCT USER_ID) * 100 AS d28RollingRetention,
	100 - (COUNT(DISTINCT CASE WHEN n >= 28 THEN USER_ID END)/COUNT(DISTINCT USER_ID) * 100) AS d28Churn
FROM activity_data
WHERE PLAYER_START_DATE > CURRENT_DATE - 60 AND EVENT_DATE > CURRENT_DATE - 60
GROUP BY PLAYER_START_DATE
ORDER BY PLAYER_START_DATE