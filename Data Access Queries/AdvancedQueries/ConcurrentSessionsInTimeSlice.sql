-- Defines slots for each slice of time we wish to look at
WITH time_slots AS (
    SELECT DISTINCT TIME_SLICE(EVENT_TIMESTAMP, 10, 'MINUTE') AS timeSlice -- Currently slices are set to 10 minute slots
    FROM account_events
    WHERE EVENT_TIMESTAMP BETWEEN CURRENT_TIMESTAMP - INTERVAL '7 day' AND CURRENT_TIMESTAMP -- Slots are split across the last 10 days
        AND ENVIRONMENT_ID = [YOUR TARGET ENVIRONMENT]
),

--Retrieves session details
sessions AS (
    SELECT USER_ID, 
        EVENT_JSON:sessionID::STRING as sessionID, 
        MIN(EVENT_TIMESTAMP) AS sessionStart, 
        MAX(EVENT_TIMESTAMP) AS sessionEnd
	FROM account_events
	WHERE EVENT_TIMESTAMP BETWEEN CURRENT_TIMESTAMP - INTERVAL '7 day' AND CURRENT_TIMESTAMP
	    AND sessionID IS NOT NULL
        AND ENVIRONMENT_ID = [YOUR TARGET ENVIRONMENT]
	GROUP BY USER_ID, sessionID	
)

-- Sorts sessions into time slots
SELECT ts.timeSlice AS time, 
    COUNT(s.sessionID) AS activeSessions
FROM time_slots AS ts
LEFT JOIN sessions s
    ON ts.timeSlice > s.sessionStart AND ts.timeSlice < s.sessionEnd
GROUP BY ts.timeSlice
ORDER BY ts.timeSlice DESC