WITH spenders AS (
  SELECT USER_ID,
    metrics:totalRealCurrencySpent::INTEGER as totalRealCurrencySpent,
    PERCENTILE_CONT(.01) WITHIN GROUP(ORDER BY metrics:totalRealCurrencySpent::INTEGER DESC) OVER (PARTITION BY 1) AS top1Percent
  FROM USERS
  WHERE totalRealCurrencySpent > 0 --only select spenders
)



SELECT COUNT(*) AS spenders,
  COUNT(CASE WHEN totalRealCurrencySpent >= top1Percent THEN 1 ELSE NULL END) AS top1PercentSpenders,
  MIN(top1Percent) AS spendThreshold,
  MAX(totalRealCurrencySpent) AS maxSpend
FROM spenders