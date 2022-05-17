-- Defines slots for each slice of time we wish to look at
WITH timeslots AS (
    SELECT DISTINCT TIME_SLICE(EVENT_TIMESTAMP, 10, 'MINUTE') AS slice_time -- Currently slices are set to 10 minute slots
    FROM account_events
    WHERE EVENT_TIMESTAMP BETWEEN CURRENT_TIMESTAMP - INTERVAL '7 day' AND CURRENT_TIMESTAMP -- Slots are split across the last 10 days
    AND ENVIRONMENT_ID = [YOUR TARGET ENVIRONMENT]
),

--Retrieves session details
sessions AS (
    SELECT USER_ID, 
        EVENT_JSON:sessionID::STRING as sessionID, 
        MIN(EVENT_TIMESTAMP) AS sessionStart, 
        MAX(EVENT_TIMESTAMP) as sessionEnd
	FROM account_events
	WHERE EVENT_TIMESTAMP BETWEEN CURRENT_TIMESTAMP - INTERVAL '7 day' AND CURRENT_TIMESTAMP
	AND sessionID IS NOT NULL
    AND ENVIRONMENT_ID = [YOUR TARGET ENVIRONMENT]
	GROUP BY USER_ID, sessionID	
)

-- Sorts sessions into time slots
SELECT ts.slice_time AS time, 
    COUNT(s.sessionID) AS activeSessions
FROM timeslots AS ts
LEFT JOIN sessions s
    ON ts.slice_time > s.sessionStart AND ts.slice_time < s.sessionEnd
GROUP BY ts.slice_time
ORDER BY ts.slice_time DESC