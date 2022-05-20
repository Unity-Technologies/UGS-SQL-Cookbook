WITH items as (
    SELECT EVENT_JSON:productAmount::INTEGER AS productAmount, 
        EVENT_JSON:itemName::STRING AS itemName, 
        EVENT_JSON:mainEventId::INTEGER AS mainEventId
    FROM account_events
    WHERE EVENT_NAME = 'transaction'
        AND EVENT_JSON:productCategory::STRING = 'ITEM'
        AND EVENT_JSON:transationVector::STRING = 'RECEIVED'
        AND ENVIRONMENT_ID = [YOUR TARGET ENVIRONMENT]
),

spendings AS (
    SELECT EVENT_JSON:virtualCurrencyName::STRING AS virtualCurrencyName,
        EVENT_JSON:virtualCurrencyAmount::INTEGER AS virtualCurrencyAmount,
        EVENT_JSON:mainEventId::INTEGER AS mainEventId
    FROM account_events
    WHERE EVENT_JSON:productCategory::STRING = 'VIRTUAL_CURRENCY'
        AND EVENT_JSON:transationVector::STRING = 'SPENT'
        AND ENVIRONMENT_ID = [YOUR TARGET ENVIRONMENT]
),
      
spendings_to_items AS (
SELECT i.itemName,
    i.productAmount,
    i.mainEventId,
    s.virtualCurrencyName,
    s.virtualCurrencyAmount
   FROM spending AS s
   INNER JOIN items AS i 
    ON s.mainEventId = i.mainEventId
   ORDER BY i.itemName
)

SELECT itemName,
       virtualCurrencyName,
       SUM(virtualCurrencyAmount)
FROM spendings
GROUP BY itemName, virtualCurrencyName