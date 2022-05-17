WITH data AS (
    SELECT USER_ID, 
        FIRST_VALUE(EVENT_TIMESTAMP) OVER (PARTITION BY USER_ID ORDER BY EVENT_TIMESTAMP) AS "firstEventTimestamp",
        ROUND(DATEDIFF(hour, FIRST_VALUE(EVENT_TIMESTAMP) OVER (PARTITION BY USER_ID ORDER BY EVENT_TIMESTAMP), EVENT_TIMESTAMP) / 24 + 1, 2.0) :: INTEGER AS dayNumber, 
        EVENT_TIMESTAMP, 
        EVENT_NAME, 
        PLATFORM, 
        EVENT_JSON:convertedProductAmount::INTEGER AS convertedProductAmount, 
        EVENT_JSON:revenueValidated::INTEGER AS revenueValidated
    FROM account_events
    WHERE EVENT_NAME IN ( 'newPlayer', 'gameStarted', 'transaction') 
    AND PLAYER_START_DATE > CURRENT_DATE - 31
    AND ENVIRONMENT_ID = [YOUR TARGET ENVIRONMENT]
)

SELECT dayNumber, 
   COUNT(DISTINCT(CASE WHEN PLATFORM LIKE 'IOS%' THEN USER_ID END)) AS "iOS Users", 
   COUNT(DISTINCT(CASE WHEN PLATFORM LIKE 'IOS%' 
                        AND EVENT_NAME = 'transaction' 
                        AND revenueValidated IN (0, 1) 
                        AND convertedProductAmount > 0 THEN USER_ID END)) AS "iOS Spenders", 
   COUNT(CASE WHEN PLATFORM LIKE 'IOS%' 
                AND EVENT_NAME = 'transaction' 
                AND revenueValidated IN (0, 1) 
                AND convertedProductAmount > 0 THEN convertedProductAmount END) AS "iOS Purchases", 
   SUM(CASE WHEN PLATFORM LIKE 'IOS%' 
              AND EVENT_NAME = 'transaction' 
              AND revenueValidated IN (0, 1) 
              AND convertedProductAmount > 0 THEN convertedProductAmount END) AS "iOS Revenue", 
   COUNT(DISTINCT(CASE WHEN PLATFORM LIKE 'ANDROID%' THEN USER_ID END)) AS "Android Users", 
   COUNT(DISTINCT(CASE WHEN PLATFORM LIKE 'ANDROID%' 
                        AND EVENT_NAME = 'transaction' 
                        AND revenueValidated IN (0, 1) 
                        AND convertedProductAmount > 0 THEN USER_ID END)) AS "Android Spenders", 
   COUNT(CASE WHEN PLATFORM LIKE 'ANDROID%' 
                AND EVENT_NAME = 'transaction' 
                AND revenueValidated IN (0, 1) 
                AND convertedProductAmount > 0 THEN convertedProductAmount END) AS "Android Purchases", 
   SUM(CASE WHEN PLATFORM LIKE 'ANDROID%' 
            AND EVENT_NAME = 'transaction' 
            AND revenueValidated IN (0, 1) 
            AND convertedProductAmount > 0 THEN convertedProductAmount END) AS "Android Revenue" 
FROM data 
GROUP BY dayNumber 
ORDER BY dayNumber