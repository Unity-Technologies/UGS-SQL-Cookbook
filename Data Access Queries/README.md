# Data Access Queries

This directory contains sample queries which can be used with the UGS Analytics Data Access tool out of the box or can be customized to suit your particular needs.

## Table of Contents

- [Data Access Tables](#data-access-tables)
  - [account_games](#account_games)
  - [account_events](#account_events)
  - [account_users](#account_users)
  - [account_fact_user_sessions_day](#account_fact_user_sessions_day)
  - [account_event_json_keys](#account_event_json_keys)
  - [account_fact_event_type_users_day](#account_fact_event_type_users_day)
  - [account_fact_mission_users_day](#account_fact_mission_users_day)
  - [account_fact_product_users_day](#account_fact_product_users_day)
  - [account_fact_wau_users](#account_fact_wau_users)
  - [account_fact_mau_users](#account_fact_mau_users)
- [Queries](#queries)

## Data Access Tables

Within the data share provided through Data Access, you have access to a number of tables.

### account_games

This table lists all of the projects in your organisation with UGS Analytics enabled. There is a record for each environment in each project. From this table you can retrieve the environment_id or game_id which you can then use to query in other tables.

### account_events 

This table lists all of the events that have been sent in from your application. Event specific parameters can be found in the `EVENT_JSON` column as a JSON object. As the parameters are stored as a JSON object, you will need to parse the content in order to query it. Examples for parsing your parameters can be seen in the samples included in this repository.

### account_users 

This table lists all the users who have sent in an event in the past. For each user, the columns contain a variety of useful metrics. Under the `metrics` column, specifically, there are metrics which are calculated using SQL analytics functions.

### account_fact_user_sessions_day

This table has a record for each user session. Each record contains a variety of user level aggregate KPIs for that session. If any of the dimensions, excluding aggregate dimensions, recorded in this table change during a session (for example, AGE_GROUP or GENDER), a new record will be created for that session.

### account_event_json_keys 

This table contains all of the parameters in your projects and when they were originally created.

### account_fact_event_type_users_day 

This table list all of the events a user has recorded in one day and how many times they have sent in each of those events.

### account_fact_mission_users_day 

This table lists how many times a user has started, completed, failed and abandoned missions in a day. This table will be empty if you do not have at least one of the following events implemented:

- missionStarted
- missionCompleted
- missionFailed
- missionAbandoned

To use this table, the above events should contain a missionName parameter.

### account_fact_product_users_day

This table lists the number of times a user has purchased a product in a day. This table will be empty if you do not have the standard transaction event implemented. The data is retrieved from the "productsReceived" parameter in that event.

### account_fact_wau_users

This table lists all of the users that have sent in an event in the last 7 days. 

### account_fact_mau_users

This table lists all of the users that have sent in an event in the last 30 days. 

## Queries

For each query, remember to substitute in the relevant environment id for your application. This can be found by querying the `account_games` table.

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
