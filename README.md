# UGS SQL Cookbook

A collection of sample SQL queries with best practice guidance for use with Unity Gaming Services Analytics.

## Table of Contents

- [Overview](#overview)
- [Usage Guide](#usage-guide)
  - [Prerequisites](#prerequisites)
  - [Getting Started](#getting-started)
  - [SQL Data Explorer vs. Data Access](#sql-data-explorer-vs-data-access)
  - [Snowflake SQL](#snowflake-sql)
- [Best Practices For Writing Queries](#best-practices-for-writing-queries)


## Overview

This repository contains a variety of sample SQL queries which span across a number of possible use cases for queries in Unity Gaming Services (UGS) Analytics' [SQL Data Explorer](https://docs.unity.com/analytics/SQLDataExplorer.html) and [Data Access](https://docs.unity.com/analytics/DataAccess.html) tools. The samples in this repository aim to provide ideas for queries that can extract useful and interesting information from your analytics events and provide guidance on best practices when writing SQL queries when using these tools.

As the SQL Data Explorer and Data Access tools have access to slightly different tables, each of the use cases will have a version in the `SQL Data Explorer Queries` and `Data Access Queries` sub-directories in this repository.

UGS Analytics uses a Snowflake Data Warehouse, so all queries are written in Snowflake SQL. See the Snowflake SQL section of this README for more information about writing queries using this version of SQL.

## Usage Guide

### Prerequisites

This cookbook assumes a basic understanding of SQL `SELECT` statements and a concrete knowledge of what data you are sending in to UGS Analytics through events. Note, many of the sample queries in this cookbook do make use of `WHERE` clauses, also known as Common Table Expressions (CTEs). More context regarding CTEs can be found under the [Best Practices section](#using-common-table-expressions).

Naturally, to use these queries, you should have some data already populating in the for your game. If you intend to use the Data Access queries, you should have the feature enabled and a data share set up for your account.

### Getting Started

To use these queries, first of all decide which tool you will use and navigate to its respective subdirectory in this repository.

You can explore the different use case samples in the README file in the subdirectory. Select the use case you wish to run and paste it into the query editor for your selected tool.

You can then further customize these queries to suit your needs. You may wish to change the event that the query is searching for or change the date range across which you wish to receive results for.

Finally, run the query and see your results.

### SQL Data Explorer vs. Data Access

To query your UGS Analytics data using SQL, you have a choice of two tools: SQL Data Explorer and Data Access. 

SQL Data Explorer allows you to write SQL queries directly in the Unity Dashboard, execute them and create visualisations from the data. The queries can then be saved and executed again at a later time. Currently, SQL Data Explorer supports the creation of bar charts, line graphs and area graphs. Additionally, you can view the results in table form below the visualisation creation tool.

Data Access allows you to connect your pre-existing Snowflake account with your analytics data through a Secure Data Share. From here, you can connect your Snowflake account with other 3rd party tools, such as Tableau and PowerBI, and access all of your analytics data outside of the platform. Your analytics data is stored in raw form in the data share allowing you to perform more complicated and powerful queries which may not be currently possible with the SQL Data Explorer feature set. Additionally, unlike in the SQL Data Explorer, Data Access is able to query across games and environments.

Both options provide a different experience and picking which tool to use will depend on the data you collect and your required use cases.

### Snowflake SQL

Queries written for both the SQL Data Explorer and Data Access tools should be in Snowflake SQL. The following Snowflake documentation pages are useful for reference:

- [Query Syntax Reference](https://docs.snowflake.com/en/sql-reference/constructs.html) - this page provides links to the syntax commands which can be used to construct your `SELECT` statements.
- [Query Operator Reference](https://docs.snowflake.com/en/sql-reference/operators.html) - this page provides information about the syntax of specific operators in Snowflake which can be used in your queries
- [Snowflake Function Reference](https://docs.snowflake.com/en/sql-reference/functions-all.html) - this page provides a list off all of the functions available in Snowflake

> **Note:** While the vast majority of the functions listed in the Function Reference documentation can be used, there are a small handful of functions which are restricted due to the Snowflake role permissions granted in the SQL Data Explorer. Additionally, only `SELECT` statements and `WITH` clauses can be used in the SQL Data Explorer.

## Best Practices For Writing Queries

There are a number of methods and good practices to writing SQL queries which will help you get the most out of your analytics data and optimize the performance of your queries. 

### Using Common Table Expressions

A Common Table Expression (CTE) is a temporary result set which can be referred to later on in your query. CTEs are principally used to perform more complex aggregation calculations on your data and are incredibly useful for improving the readability of your query. A CTE is also known as a `WITH` clause as the syntax begins with the keyword `WITH`. 

In your query, a CTE will appear before your main `SELECT` statement and have the following format:

``` sql
WITH cteName AS (
  SELECT ...
  FROM table
)
```

You can then retrieve data and perform further aggregation on it in your main `SELECT` statement:

``` sql
SELECT ...
FROM cteName
```

You can even have multiple CTEs in a single query which each refer to each other.

The samples within this Cookbook will provide examples of how you can use CTEs on your data.

### Query only the information you are interested in

When writing queries in SQL, you should only select the columns you are interested in and wish to retrieve information from. For the SQL Data Explorer and Data Access tools, there are two principal reasons for this. Firstly, only retrieving the information that you require will vastly improve query performance as less data will need retrieved from the database. 

Instead of:

``` sql
SELECT * FROM EVENTS
```

Try:

``` sql
SELECT EVENT_DATE, EVENT_NAME, USER_ID
FROM EVENTS
```

Secondly, the majority of parameters and information in the tables available in the SQL Data Explorer and Data Access tools are stored in JSON format in a column which uses the VARIANT data type. When selecting this column without parsing the data, it is not possible to use specific parameters in visualisations and the results of the query will not be particularly useful to understanding your data and player activity.

Parse some event specific parameters from the `EVENTS` table in SQL Data Explorer:

```sql
SELECT EVENT_JSON:missionName::VARCHAR, EVENT_JSON:score::INTEGER
FROM EVENTS
```

### Filter your results

Most of the time, you will not need the details from every single event. By adding filtering options to your query using `WHERE` and `HAVING` clauses, you can improve the results retrieved by reducing the number of events you retrieve from the database. Additionally, this will allow you to refine your results and perform more specific queries.

Some of the ways you can filter your queries include:

By Date:

``` sql
SELECT EVENT_DATE, EVENT_NAME, USER_ID
FROM EVENTS
WHERE EVENT_DATE > CURRENT_DATE - 7
```

By Event:

``` sql
SELECT EVENT_DATE, EVENT_NAME, USER_ID
FROM EVENTS
WHERE EVENT_NAME = "gameStarted"
```

For queries with aggregate values, you can filter by result using a `HAVING` clause:

``` sql
SELECT EVENT_JSON:missionName::VARCHAR, COUNT(DISTINCT USER_ID)
FROM EVENTS
GROUP BY EVENT_JSON:missionName::VARCHAR
HAVING COUNT(DISTINCT USER_ID) > 10
```

> Many of the sample queries in this cookbook will limit the results to only include the events from either the last 7 days or last 30 days.

### Filter your queries early

When using subqueries and `WITH` clauses, filter out the uneccessary data as soon as you can so that subsequent steps in the query have less data to search through.

Instead of:

``` sql
WITH data AS (
    SELECT EVENT_NAME, USER_ID, PLATFORM 
    FROM EVENTS
    )

SELECT * 
FROM data
WHERE EVENT_NAME = 'gameStarted'
```

Try:

```sql
WITH data AS (
    SELECT EVENT_NAME, USER_ID, PLATFORM 
    FROM EVENTS
    WHERE EVENT_NAME = 'gameStarted'
)

SELECT * 
FROM data
```