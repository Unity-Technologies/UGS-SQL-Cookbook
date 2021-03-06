SELECT EVENT_DATE,
    ROUND(SUM(REVENUE)/100/COUNT(DISTINCT USER_ID), 4)::FLOAT AS ARPDAU
FROM account_fact_user_sessions_day
WHERE EVENT_DATE BETWEEN CURRENT_DATE - 30 AND CURRENT_DATE
    AND ENVIRONMENT_ID = [YOUR TARGET ENVIRONMENT]
GROUP BY EVENT_DATE
ORDER BY EVENT_DATE DESC