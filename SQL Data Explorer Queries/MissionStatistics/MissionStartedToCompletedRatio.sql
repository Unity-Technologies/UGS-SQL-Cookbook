WITH data AS (
    SELECT USER_ID,
          EVENT_JSON:missionName::STRING AS missionName,
          EVENT_NAME,
          MAX(CASE WHEN EVENT_NAME = 'missionStarted' THEN 1 ELSE NULL END) OVER (PARTITION BY USER_ID, EVENT_JSON:missionName::STRING) AS missionStartedFlag,
          MAX(CASE WHEN EVENT_NAME = 'missionCompleted' THEN 1 ELSE NULL END) OVER (PARTITION BY USER_ID, EVENT_JSON:missionName::STRING) AS missionCompletedFlag
   FROM EVENTS
   WHERE EVENT_JSON:missionName::STRING IS NOT NULL
), 
   
nonCompletionData AS(
    SELECT missionName,
        COUNT(DISTINCT CASE WHEN missionStartedFlag IS NOT NULL THEN USER_ID ELSE NULL END) AS players,
        COUNT(DISTINCT CASE WHEN missionStartedFlag = 1
                AND missionCompletedFlag = 1 THEN USER_ID ELSE NULL END) AS completedPlayers,
        COUNT(DISTINCT CASE WHEN missionStartedFlag = 1
                AND missionCompletedFlag IS NULL THEN USER_ID ELSE NULL END) AS incompletePlayers
   FROM DATA
   GROUP BY missionName
)

SELECT missionName AS "Mission Name",
       players AS "Num players started mission",
       completedPlayers AS "Num players completed mission",
       incompletePlayers AS "Num players started but not completed mission",
       incompletePlayers/nullif(players, 0) AS Ratio --NullIF since players could theoretically be 0 and we rather divide by null
FROM nonCompletionData
ORDER BY missionName