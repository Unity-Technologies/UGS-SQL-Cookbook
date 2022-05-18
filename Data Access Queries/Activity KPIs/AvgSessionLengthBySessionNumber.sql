-- Gets session data 
WITH sessions AS (
    SELECT USER_ID, 
        EVENT_JSON:sessionID::STRING AS sessionID, 
        EVENT_TIMESTAMP,
        EVENT_NAME, 
        EVENT_JSON:msSinceLastEvent::INTEGER AS msSinceLastEvent,
        -- Conditional change event pulls out the sessionID only when it has changed from the last occurance
        CONDITIONAL_CHANGE_EVENT(EVENT_JSON:sessionID) OVER (PARTITION BY USER_ID ORDER BY EVENT_ID) + 1 AS sessionCounter 
    FROM account_events
    WHERE sessionID IS NOT NULL 
        AND msSinceLastEvent IS NOT NULL
        AND ENVIRONMENT_ID = [YOUR TARGET ENVIRONMENT]
), 

-- Aggregates session data
session_aggregates AS (
    SELECT MAX(USER_ID) AS userID, 
        MIN(EVENT_TIMESTAMP), 
        sessionID, 
        sessionCounter, 
        SUM(msSinceLastEvent) AS msSessionLength,
        COUNT(*) AS eventCount 
        FROM sessions 
        GROUP BY sessionID, 
                sessionCounter
)

-- Further aggregates data 
SELECT 
    sessionCounter AS sessionNumber, 
    COUNT(*) AS sessionsCounted, 
    ROUND(AVG(msSessionLength) / 60000, 2.0) :: FLOAT AS avgSessionLengthMinutes
FROM session_aggregates 
GROUP BY sessionCounter 
ORDER BY sessionCounter