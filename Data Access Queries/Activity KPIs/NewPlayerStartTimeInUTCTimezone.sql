-- Gets the first timestamp we have see for a user and the timezone offset on the day they were first seen.
WITH firstValues AS (
    SELECT USER_ID,
        MIN(EVENT_TIMESTAMP) AS startTs,
        MIN(EVENT_JSON:timezoneOffset::STRING) AS tzo
    FROM account_events
    WHERE EVENT_JSON:EVENT_DATE::DATE = PLAYER_START_DATE
    AND EVENT_JSON:EVENT_DATE::DATE > CURRENT_DATE - 30
    AND ENVIRONMENT_ID = [YOUR TARGET ENVIRONMENT]
    GROUP BY USER_ID
),

-- Adds a the number of minutes extracted from the timezone definition, e.g. adds the value -90 when converting '-0130'.
results AS (
    SELECT tzo,
        startTs,
        TIMEADD(minute, 
            CASE 
                WHEN LEN(tzo) = 5 THEN 
                    (CAST(SUBSTR(tzo, 1, 1)||'1' AS INTEGER) * -1) * -- get positive vs negative tzoffset
                    (CAST(SUBSTR(tzo, 2, 2) AS INTEGER) * 60 + CAST(SUBSTR(tzo, 4, 2) AS INTEGER)) 
                ELSE NULL
            END, startTs) AS UTCTimestamp,
            CASE 
                WHEN LEN(TZO) = 5 THEN 
                    CAST(SUBSTR(tzo, 1, 1)||'1' AS INTEGER) * -- get positive vs negative tzoffset
                    (CAST(SUBSTR(tzo, 2, 2) AS INTEGER) * 60 + CAST(SUBSTR(tzo, 4, 2) AS INTEGER)) -- get tzoffset in minutes
                ELSE NULL
            END AS minutes
   FROM firstValues
)

-- Returns a row per install containing the timestamp the user is first seen on (UTCTimestamp) and the timezoneoffset in minutes.
SELECT *
FROM results