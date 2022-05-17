WITH transactions AS (
    SELECT USER_ID,
        EVENT_TIMESTAMP,
        EVENT_JSON:transactionName::STRING AS transactionName,
        EVENT_JSON:convertedProductAmount::INTEGER AS convertedProductAmount,
        EVENT_JSON:revenueValidated::INTEGER AS revenueValidated, 
	    RANK() OVER (PARTITION BY USER_ID ORDER BY EVENT_TIMESTAMP) AS transactionNumber
    FROM account_events 
    WHERE convertedProductAmount > 0 AND revenueValidated IN (0, 1)
        AND ENVIRONMENT_ID = [YOUR TARGET ENVIRONMENT]
)

SELECT transactionName,
	COUNT(*) as "IAP count",
	SUM(convertedProductAmount)/100::FLOAT AS revenue
FROM transactions
WHERE transactionNumber = 1
GROUP BY transactionName
ORDER BY 2 DESC