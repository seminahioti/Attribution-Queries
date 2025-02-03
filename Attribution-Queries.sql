/*
Here's the first-touch query, in case you need it
*/

/* WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) as first_touch_at
    FROM page_visits
    GROUP BY user_id)
SELECT ft.user_id,
    ft.first_touch_at,
    pv.utm_source,
		pv.utm_campaign
FROM first_touch ft
JOIN page_visits pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp; */

-- Step 1: How many campaigns and sources does CoolTShirts use? Which source is used for each campaign? Use three queries: one for the number of distinct campaigns, one for the number of distinct sources, one to find how they are related. 
SELECT COUNT(DISTINCT utm_campaign)
FROM page_visits;

SELECT COUNT(DISTINCT utm_source)
FROM page_visits;

SELECT DISTINCT utm_campaign, utm_source -- to see how they relate
FROM page_visits;

-- Step 2: What pages are on the CoolTShirts website? Find the distinct values of the page_name column.
SELECT DISTINCT page_name
FROM page_visits;

-- Step 3: What is the user journey? How many FIRST touches is each campaign responsible for? You’ll need to use a first-touch query. Group by campaign and count the number of first touches for each.
-- We're taking that first touch query that we wrote in the first part of this. 
WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) as first_touch_at
    FROM page_visits
    GROUP BY user_id)
SELECT -- 4 things but i add the COUNT command
    ft.user_id,
    ft.first_touch_at,
    pv.utm_source,
    pv.utm_campaign,
    COUNT(utm_campaign) 
FROM first_touch ft
JOIN page_visits pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp
GROUP BY utm_campaign -- my code here
ORDER BY 5 DESC; -- sorts the result by the 5th column 

-- Step 4: How many LAST touches is each campaign responsible for? Starting with the last-touch query from the lesson, group by campaign and count the number of last touches for each.
WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) as last_touch_at -- we're changing the min to max from step 3 because now we want the last timestamp
    FROM page_visits
    GROUP BY user_id)
SELECT 
    lt.user_id,
    lt.last_touch_at,
    pv.utm_source,
    pv.utm_campaign,
    COUNT(utm_campaign)
FROM last_touch lt
JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
GROUP BY utm_campaign -- my code here
ORDER BY 5 DESC; -- sorts the result by the 5th column 

-- Step 5: How many visitors make a purchase? Count the distinct users who visited the page named 4 - purchase.
SELECT COUNT(DISTINCT user_id) 
FROM page_visits
WHERE page_name = '4 - purchase';

-- Step 6: How many last touches on the purchase page is each campaign responsible for? This query will look similar to your last-touch query, but with an additional WHERE clause.
SELECT utm_campaign,
  COUNT(DISTINCT user_id) as num_page_4
FROM page_visits
WHERE page_name = '4 - purchase'
GROUP BY 1;
