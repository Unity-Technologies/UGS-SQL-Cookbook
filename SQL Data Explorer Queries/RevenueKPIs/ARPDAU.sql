SELECT EVENT_DATE,
    ROUND(SUM(REVENUE)/100/COUNT(DISTINCT USER_ID), 4)::FLOAT AS ARPDAU
FROM FACT_USER_SESSIONS_DAY
WHERE EVENT_DATE BETWEEN CURRENT_DATE - 30 AND CURRENT_DATE
GROUP BY EVENT_DATE
ORDER BY EVENT_DATE DESC