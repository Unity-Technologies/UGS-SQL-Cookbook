--Gets minimum event dates for players
WITH data AS ( 
    SELECT MIN(EVENT_DATE) as EVENT_DATE,
        PLAYER_START_DATE,
        USER_ID,
        DATEDIFF(DAY, PLAYER_START_DATE, MIN(EVENT_DATE)) AS n
    FROM FACT_USER_SESSIONS_DAY
    WHERE DATEDIFF(DAY, PLAYER_START_DATE, CURRENT_DATE) < 36
    GROUP BY PLAYER_START_DATE, USER_ID, SESSION_ID
), 

--Counts retention values
retention AS (
    SELECT PLAYER_START_DATE,
        COUNT (DISTINCT CASE WHEN n = 0 THEN USER_ID ELSE NULL END) AS installs,
        COUNT (DISTINCT CASE WHEN n = 1 THEN USER_ID ELSE NULL END) AS d1Retention,
        COUNT (DISTINCT CASE WHEN n = 7 THEN USER_ID ELSE NULL END) AS d7Retention,
        COUNT (DISTINCT CASE WHEN n = 14 THEN USER_ID ELSE NULL END) AS d14Retention,
        COUNT (DISTINCT CASE WHEN n = 30 THEN USER_ID ELSE NULL END) AS d30Retention
    FROM DATA
    GROUP BY PLAYER_START_DATE
)

--Produces retention percentages
SELECT *,
    ROUND(d1Retention/installs * 100, 2.0) AS "D1%",
    ROUND(d7Retention/installs * 100, 2.0) AS "D7%",
    ROUND(d14Retention/installs * 100, 2.0) AS "D14%",
    ROUND(d30Retention/installs * 100, 2.0) AS "D30%"
FROM retention
ORDER BY PLAYER_START_DATE DESC