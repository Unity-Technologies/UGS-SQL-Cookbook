# Data Access Queries

This directory contains sample queries which can be used with the UGS Analytics Data Access tool out of the box or can be customized to suit your particular needs.

## Table of Contents

- [Data Access Tables](#data-access-tables)
  - [account_games](#account_games)
  - [account_users](#account_users)
  - [account_events](#account_events)
  - [account_event_json_keys](#account_event_json_keys)
  - [account_fact_event_type_users_day](#account_fact_event_type_users_day)
  - [account_fact_mission_users_day](#account_fact_mission_users_day)
  - [account_fact_product_users_day](#account_fact_product_users_day)
  - [account_fact_user_sessions_day](#account_fact_user_sessions_day)
  - [account_fact_wau_users](#account_fact_wau_users)
  - [account_fact_mau_users](#account_fact_mau_users)
- [Queries](#queries)

## Data Access Tables

Within the data share provided through Data Access, you have access to a number of tables.

### account_games

This table lists all of the projects in your organisation with UGS Analytics enabled. There is a record for each environment in each project. From this table you can retrieve the environment_id or game_id which you can then use to query in other tables.

### account_users 

This table lists all the users from your applications. For each user, it contains a variety of dimensions. Under the `metrics` column, a number of user metrics can be found in a JSON formant. The metrics include: when the user first recorded an event, when the user last recorded an event, the total time a user has spent in the application, the total number of events recorded by a user, etc...

### account_events 

This table contains all the events received from your applications. Event specific parameters can be found in the `EVENT_JSON` column as a JSON object. As the parameters are stored as a JSON object, you will need to parse the content in order to query it. Examples of how to parse the content can be found in the sample queries included in this repository.

### account_event_json_keys 

This table contains all of the parameters in your projects and when they were originally created.

### account_fact_event_type_users_day 

This table lists all of the events a user has sent in one day and how many times each of those events have been sent in. If any user details change (such as the client version or user country) during that day, a new record will be created for each event even if it has been already recorded once before the change.

### account_fact_mission_users_day 

This table lists how many times a user has started, completed, failed and abandoned missions in a day. If any user details change (such as the client version or user country) during that day, a new record will be created for each mission event even if it has been already recorded once before the change. This table will be empty if you do not have at least one of the following events implemented:

- missionStarted
- missionCompleted
- missionFailed
- missionAbandoned

> Note: To use this table, the above events should contain a missionName parameter

### account_fact_product_users_day

This table lists the number of times a user has purchased a product in a day. If any user details change (such as the client version or user country) during that day, a new record will be created for each product even if it has been already recorded once before the change. This table will be empty if you do not have the standard transaction event implemented. The data is retrieved from the "productsReceived" parameter in that event.

### account_fact_user_sessions_day

This table lists the revenue in the smallest unit of the default currency, the number of events, missions activity, and the transactions split out per session. If something about the session changes, such as clientVersion or userCountry changes, then a new row will be created.

### account_fact_wau_users

This table lists all of the users who have played in the last 7 days and their relevant dimensions.

### account_fact_mau_users

This table lists all of the users who have played in the last 31 days and their relevant dimensions.


## Queries
