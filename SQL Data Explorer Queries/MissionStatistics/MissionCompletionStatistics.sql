WITH starters AS (
    SELECT USER_ID
    FROM EVENTS
    WHERE EVENT_JSON:missionID::INTEGER ='1'-- number of your first mission
    AND EVENT_NAME = 'missionStarted')

SELECT EVENT_JSON:missionID::INTEGER AS missionID,
    EVENT_JSON:missionName::STRING AS missionName,
    COUNT(CASE WHEN EVENT_NAME = 'missionStarted' THEN 1 ELSE NULL END) AS started,
    COUNT(CASE WHEN EVENT_NAME = 'missionFailed' THEN 1 ELSE NULL END) AS failed,
    COUNT(CASE WHEN EVENT_NAME = 'missionCompleted' THEN 1 ELSE NULL END) AS completed,
    COUNT(CASE WHEN EVENT_NAME = 'missionAbandoned' THEN 1 ELSE NULL END) AS abandoned
FROM EVENTS
WHERE USER_ID IN (SELECT USER_ID FROM starters)
AND EVENT_LEVEL = 0
AND EVENT_JSON:missionID::INTEGER IS NOT NULL
GROUP BY missionID, missionName
ORDER BY missionID