WITH spenders AS (
  SELECT USER_ID,
    metrics:totalRealCurrencySpent::INTEGER AS totalRealCurrencySpent,
    PERCENTILE_CONT(.01) WITHIN GROUP(ORDER BY totalRealCurrencySpent DESC) OVER (PARTITION BY 1) AS top1Percent
  FROM account_users
  WHERE totalRealCurrencySpent > 0 --only select spenders
    AND ENVIRONMENT_ID = [YOUR TARGET ENVIRONMENT]
)

SELECT COUNT(*) AS spenders,
  COUNT(CASE WHEN totalRealCurrencySpent >= top1Percent THEN 1 ELSE NULL END) AS top1PercentSpenders,
  MIN(top1Percent) AS spendThreshold,
  MAX(totalRealCurrencySpent) AS maxSpend
FROM spenders