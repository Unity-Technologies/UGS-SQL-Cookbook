# SQL Data Explorer Queries

This directory contains sample queries which can be used with the UGS Analytics SQL Data Explorer tool out of the box or can be customized to suit your particular needs.

## Table of Contents

- [SQL Data Explorer Tables](#sql-data-explorer-tables)
  - [EVENTS](#events)
  - [USERS](#users)
  - [FACT_USER_SESSION_DAY](#fact_user_session_day)
  - [FACT_EVENT_TYPE_USER_DAY](#fact_event_type_user_day)
  - [FACT_WAU_USERS](#fact_wau_users)
  - [FACT_MAU_USERS](#fact_mau_users)
- [Queries](#queries)

## SQL Data Explorer Tables

Through the SQL Data Explorer you have access to a number of tables.

### EVENTS

This table lists all of the events that have been sent in from your application. Event specific parameters can be found in the `EVENT_JSON` column as a JSON object. As the parameters are stored as a JSON object, you will need to parse the content in order to query it. Examples for parsing your parameters can be seen in the samples included in this repository. You can also retrieve the syntax to parse the parameters by typing in the parameter name and pressing `TAB` to auto-complete the syntax. This table is updated every 1-2 hours.

### USERS

This table lists all the users who have sent in an event in the past. For each user, the columns contain a variety of useful metrics. Under the `metrics` column, specifically, there are metrics which are calculated using SQL Analytics Functions. This table is updated every 3-4 hours.

### FACT_USER_SESSION_DAY

This table has a record for each user session. Each record contains a variety of user level aggregate KPIs for that session. If any of the dimensions, excluding aggregate dimensions, recorded in this table change during a session (for example, AGE_GROUP or GENDER), a new record will be created for that session. This table is updated every 1-2 hours.

### FACT_EVENT_TYPE_USER_DAY

This table list all of the events a user has recorded in one day and how many times they have sent in each of those events. This table is updated every 1-2 hours.

### FACT_WAU_USERS

This table lists all of the users that have sent in an event in the last 7 days. This table is updated every 1-2 hours.

### FACT_MAU_USERS

This table lists all of the users that have sent in an event in the last 30 days. This table is updated every 1-2 hours.

## Queries

### Activity KPIs

The queries under this category measure how active user have been across a variety of timespans and sessions.

|Query|Description|
|---|---|
|[Avg Session Length By Session Number](Activity%20KPIs/AvgSessionLengthBySessionNumber.sql)|Returns the average session length in minutes, grouped by session number|
|[D28 Churn Vs D28 Rolling Retention](Activity%20KPIs/D28ChurnVsD28RollingRetention.sql)|Returns the percentage of players that have churned before Day 28 and the percentage that have been retained until Day 28 per start date|
|[Median and Average Session Lengths](Activity%20KPIs/MedianAndAverageSessionLengths.sql)|Returns the median and average session length per day|
|[New Player Retention Matrix](Activity%20KPIs/NewPlayerRetentionMatrix.sql)|Returns a matrix which displays how many players who started on a specific date have returned after a certain number of days since they first launched the application|
|[New Players Start Time in UTC Timezone](Activity%20KPIs/NewPlayerStartTimeInUTCTimezone.sql)|Returns the event timestamp for when the player was first seen in the UTC timezone|
|[Players Per Hour In Local Timezone](Activity%20KPIs/PlayersPerHourInLocalTimezone.sql)|Returns how many players have played at a certain time in their local timezone|
|[Retention by User Country](Activity%20KPIs/RetentionByUserCountry.sql)|Returns D7 retentions for each country that your users come from|
|[Retention Using Min Event Date](Activity%20KPIs/RetentionUsingMinEventDate.sql)|Returns D1, D7, D14 and D30 retention using the minimum event date. This prevents sessions which cross into a second day from counting towards D1 retention|

### Revenue KPIs

The queries under this category measure revenue related statistics, including both IAP Revenue and Ad Revenue.

|Query|Description|
|---|---|
|[ARPDAU](RevenueKPIs/ARPDAU.sql)|Returns the average revenue per user active on that particular day|
|[First IAP Transactions](RevenueKPIs/FirstIAPTransactions.sql)|Returns the transactions users make when they first purchase an item in game and how much revenue has been generated from each action|
|[IAPs per Platform per Day](RevenueKPIs/IAPsPerPlatformPerDay.sql)|Returns the number of transactions and revenue for iOS and Android|

### Mission Statistics

The queries under this category measure statistics related to mission starts, completion, failiure and abandonment.

|Query|Description|
|---|---|
|[Mission Completion Statistics](MissionStatistics/MissionCompletionStatistics.sql)|Returns how many player have started, successfully completed, failed or abandoned each mission|
|[Mission Started to Completed Ratio](MissionStatistics/MissionStartedToCompletedRatio.sql)|Returns the ratio of how many players have started a mission versus how many player have actually completed that mission|

### Advanced Queries

The queries under this category use more advanced SQL techniques and follow a more generic format for you to customize for your own projects and analytics needs.

|Query|Description|
|---|---|
|[Concurrent Sessions in Time Slice](AdvancedQueries/ConcurrentSessionsInTimeSlice.sql)|Returns the number of active sessions which occur within a certain timeslot|
|[Top 1% Spenders Spend](AdvancedQueries/Top1%25SpendersSpend.sql)|Returns the number of spenders, the number of spenders in the top 1% of spenders, the minimum amount spent to be considered as part of the top 1% and the maximum amount spent|
|[Weekly Retention](AdvancedQueries/WeeklyRetention.sql)|Returns number of players, retained from the previous week, churned from previous week, new this week and returning after at least a one week break per week|
