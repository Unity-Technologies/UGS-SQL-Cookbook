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