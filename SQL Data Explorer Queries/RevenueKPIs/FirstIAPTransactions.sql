WITH transactions AS (
    SELECT USER_ID,
        EVENT_TIMESTAMP,
        EVENT_JSON:transactionName::STRING,
        EVENT_JSON:convertedProductAmount::INTEGER,
        EVENT_JSON:revenueValidated::INTEGER, 
	    RANK() OVER (PARTITION BY USER_ID ORDER BY EVENT_TIMESTAMP) AS transactionNumber
    FROM EVENTS 
    WHERE EVENT_JSON:convertedProductAmount::INTEGER > 0 AND EVENT_JSON:revenueValidated::INTEGER IN (0, 1)
)

SELECT transactionName,
	COUNT(*) as "IAP count",
	SUM(convertedproductAmount)/100::FLOAT AS revenue
FROM transactions
WHERE transactionNumber = 1
GROUP BY transactionName
ORDER BY 2 DESC