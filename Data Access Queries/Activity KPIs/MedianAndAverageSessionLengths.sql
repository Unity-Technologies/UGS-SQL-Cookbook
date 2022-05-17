--Gets session data
WITH data AS (
    SELECT MIN(EVENT_DATE) AS eventDate,
        EVENT_JSON:sessionID::STRING AS sessionID,
        USER_ID,
        SUM(EVENT_JSON:msSinceLastEvent::INTEGER) AS sessionDurationMs,
        COUNT(*) AS eventCount
   FROM account_events
   WHERE ENVIRONMENT_ID = [YOUR TARGET ENVIRONMENT]
   GROUP BY sessionID, USER_ID
),

--Aggregates for median value
medianValues AS (
    SELECT *, 
        MEDIAN(sessionDurationMs) OVER (PARTITION BY eventDate) AS medianSessionTime
    FROM data
    WHERE eventCount > 1
)

--Further aggregates data
SELECT eventDate,
    ROUND(AVG(sessionDurationMs)/1000, 2.0) AS "Mean session time in seconds",
    ROUND(medianSessionTime/1000, 2.0) AS "Median session time in seconds",
    COUNT(DISTINCT USER_ID) AS "Sample size users",
    COUNT(DISTINCT sessionID) AS "Sample size sessions"
FROM medianValues
GROUP BY eventDate, medianSessionTime
ORDER BY eventDate DESC