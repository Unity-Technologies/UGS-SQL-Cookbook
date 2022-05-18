-- Gets all weeks that a player has played and the first week they have played
WITH user_dates AS (
    SELECT USER_ID,
        TRUNC(EVENT_DATE, 'week')::DATE AS weekCommencing,
        MIN(TRUNC(PLAYER_START_DATE, 'week')) AS firstWeek
    FROM account_fact_user_sessions_day
    WHERE EVENT_DATE > CURRENT_DATE - 90
        AND ENVIRONMENT_ID = [YOUR TARGET ENVIRONMENT]
    GROUP BY USER_ID, weekCommencing
    ORDER BY weekCommencing 
),

-- Calculates how many weeks since the last week with activity and how many weeks to the following week with activity
user_windows AS (
    SELECT USER_ID, 
        weekCommencing, 
        DATEDIFF(day, weekCommencing, 
            LEAD(weekCommencing, 1) OVER (PARTITION BY USER_ID ORDER BY weekCommencing)) AS nextWeek, 
        DATEDIFF(day, weekCommencing, 
            LAG(weekCommencing, 1) OVER (PARTITION BY USER_ID ORDER BY weekCommencing)) AS lastWeek, 
        firstWeek
    FROM user_dates
    ORDER BY weekCommencing
),

-- Calculates churned players for the following week
churned_players AS (
    SELECT (weekCommencing + 7) AS weekCommencing, 
        COUNT(DISTINCT USER_ID) AS churnedPlayers
    FROM user_windows
    WHERE COALESCE(nextWeek, 0) != 7
        AND weekCommencing <= TRUNC(CURRENT_DATE, 'week')::DATE - 14 
    GROUP BY weekCommencing
    ORDER BY weekCommencing
),

-- Combines the user_window table and churned_players table for later aggregation
combined_results AS (
    SELECT USER_ID, 
        weekCommencing, 
        NULL AS churnedPlayers, 
        nextWeek, 
        lastWeek, 
        firstWeek
    FROM user_windows
    UNION ALL
    SELECT NULL AS USER_ID, 
        weekCommencing, 
        churnedPlayers, 
        NULL AS nextWeek, 
        NULL AS lastWeek, 
        NULL AS firstWeek
    FROM churned_players
)

-- Aggregates values in combined results
SELECT 
    weekCommencing AS week, 
    SUM(CASE WHEN lastWeek = -7 THEN 1 ELSE 0 END) AS retainedPlayers,
    SUM(CASE WHEN churnedPlayers is not null THEN churnedPlayers ELSE 0 END) AS churnedPlayers, 
    SUM(CASE WHEN firstWeek = weekCommencing THEN 1 ELSE 0 END) AS newPlayers, 
    SUM(CASE WHEN lastWeek <= -14 THEN 1 ELSE 0 END) AS returningPlayers
FROM combined_results
WHERE weekCommencing <= TRUNC(CURRENT_DATE, 'week') - 7
GROUP BY week
ORDER BY week