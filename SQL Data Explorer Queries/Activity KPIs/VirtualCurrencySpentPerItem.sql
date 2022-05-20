WITH items as (
    SELECT EVENT_JSON:productAmount::INTEGER AS productAmount, 
        EVENT_JSON:itemName::STRING AS itemName, 
        MAIN_EVENT_ID
    FROM EVENTS
    WHERE EVENT_NAME = 'transaction'
        AND EVENT_JSON:productCategory::STRING = 'ITEM'
        AND EVENT_JSON:transationVector::STRING = 'RECEIVED'
),

spendings AS (
    SELECT EVENT_JSON:virtualCurrencyName::STRING AS virtualCurrencyName,
        EVENT_JSON:virtualCurrencyAmount::INTEGER AS virtualCurrencyAmount,
        MAIN_EVENT_ID
    FROM EVENTS
    WHERE EVENT_JSON:productCategory::STRING = 'VIRTUAL_CURRENCY'
        AND EVENT_JSON:transationVector::STRING = 'SPENT'
),
      
spendings_to_items AS (
SELECT i.itemName,
    i.productAmount,
    i.MAIN_EVENT_ID,
    s.virtualCurrencyName,
    s.virtualCurrencyAmount
   FROM spending AS s
   INNER JOIN items AS i 
    ON s.MAIN_EVENT_ID = i.MAIN_EVENT_ID
   ORDER BY i.itemName
)

SELECT itemName,
       virtualCurrencyName,
       SUM(virtualCurrencyAmount)
FROM spendings
GROUP BY itemName, virtualCurrencyName