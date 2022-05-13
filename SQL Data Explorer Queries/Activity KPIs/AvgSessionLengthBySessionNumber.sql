-- Gets session data
-- Conditional change event pulls out the sessionID only when it has changed from the last occurance 
WITH sessions AS (
    SELECT USER_ID, 
        EVENT_JSON:sessionID::STRING as sessionID, 
        EVENT_TIMESTAMP,
        EVENT_NAME, 
        EVENT_JSON:msSinceLastEvent::INTEGER as msSinceLastEvent,
        CONDITIONAL_CHANGE_EVENT(EVENT_JSON:sessionID) OVER (PARTITION BY USER_ID ORDER BY EVENT_ID) + 1 AS sessionCounter 
    FROM EVENTS
    WHERE EVENT_JSON:sessionID IS NOT NULL 
    AND EVENT_JSON:msSinceLastEvent IS NOT NULL
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
    sessionCounter as sessionNumber, 
    COUNT(*) AS sessionsCounted, 
    ROUND(AVG(msSessionLength) / 60000, 2.0) :: FLOAT AS avgSessionLengthMinutes
FROM session_aggregates 
GROUP BY sessionCounter 
ORDER BY sessionCounter; 