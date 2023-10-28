-- 查询用户活跃记录表中连续登录大于等于三天的用户。

-- MYSQL
DROP TABLE IF EXISTS user_active;
CREATE TABLE user_active
(
    `user_id`     varchar(3),
    `active_date` date,
    `test_case`   int
);

INSERT INTO user_active
VALUES ('1', '2022-04-25', NULL),
       ('1', '2022-04-26', NULL),
       ('1', '2022-04-27', NULL),
       ('1', '2022-04-28', NULL),
       ('1', '2022-04-29', NULL),
       ('2', '2022-04-12', NULL),
       ('2', '2022-04-13', NULL),
       ('3', '2022-04-05', NULL),
       ('3', '2022-04-06', NULL),
       ('3', '2022-04-08', NULL),
       ('4', '2022-04-04', NULL),
       ('4', '2022-04-05', NULL),
       ('4', '2022-04-06', NULL),
       ('4', '2022-04-06', NULL),
       ('4', '2022-04-06', NULL),
       ('5', '2022-04-12', NULL),
       ('5', '2022-04-08', NULL),
       ('5', '2022-04-26', NULL),
       ('5', '2022-04-26', NULL),
       ('5', '2022-04-27', NULL),
       ('5', '2022-04-28', NULL);

-- mysql
WITH temp as (SELECT
    user_id,active_date
FROM
    user_active
GROUP BY
    user_id,active_date)
, temp2 as (SELECT
    user_id,active_date
    , LAG(active_date,2,NULL) over (PARTITION BY user_id order by active_date) as day3
FROM temp)
SELECT user_id FROM temp2
WHERE IF(day3 is not null,
--          (active_date - day3),
        (unix_timestamp(active_date) - unix_timestamp(day3))/(3600*24),
         0) = 2
GROUP BY user_id
;
select abs((unix_timestamp('2021-01-28 00:00:00') - unix_timestamp('2021-01-29 12:00:00'))/(3600*24));

WITH temp as (SELECT
    user_id,active_date
FROM
    user_active
GROUP BY
    user_id,active_date)
, temp2 as (SELECT
    user_id,active_date
    , LAG(active_date,2,NULL) over (PARTITION BY user_id order by active_date) as day3
FROM temp)
SELECT
    user_id
    , (unix_timestamp(active_date) - unix_timestamp(day3))/(3600*24) as a
    , active_date , day3
FROM temp2;

-- HIVE

DROP TABLE IF EXISTS test.user_active;
CREATE TABLE test.user_active (
`user_id` varchar(33) COMMENT '用户  id',
`active_date` date COMMENT '用户登录日期时间',
`test_case` varchar(33)
) COMMENT '用户活跃表'
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' NULL DEFINED AS ''
LOCATION '/warehouse/sdc/rds/user_active';



INSERT INTO test.user_active
VALUES ('1', '2022-04-25', NULL),
       ('1', '2022-04-26', NULL),
       ('1', '2022-04-27', NULL),
       ('1', '2022-04-28', NULL),
       ('1', '2022-04-29', NULL),
       ('2', '2022-04-12', NULL),
       ('2', '2022-04-13', NULL),
       ('3', '2022-04-05', NULL),
       ('3', '2022-04-06', NULL),
       ('3', '2022-04-08', NULL),
       ('4', '2022-04-04', NULL),
       ('4', '2022-04-05', NULL),
       ('4', '2022-04-06', NULL),
       ('4', '2022-04-06', NULL),
       ('4', '2022-04-06', NULL),
       ('5', '2022-04-12', NULL),
       ('5', '2022-04-08', NULL),
       ('5', '2022-04-26', NULL),
       ('5', '2022-04-26', NULL),
       ('5', '2022-04-27', NULL),
       ('5', '2022-04-28', NULL);

-- 思路
--  先Group by 把每个用户，每一天给去重，
--      对去重的数据 进行 `开窗` 用lag向上取值 partition by 用户 对日期排序，这个值和当前日期 datediff 函数`日期 差值`，
--          得到的新取差的数据 用 if 取出 差值为 1 的进行 sum 得到每个用户 每次登录天数
--              用 max 函数得到 最大连续登录天数
--                  hiving 去 过滤
WITH ranked_user_active AS (
    SELECT
        user_id,
        active_date,
        DATEDIFF(
            active_date,
            LAG(active_date) OVER (PARTITION BY user_id ORDER BY active_date)
        ) AS days_diff
        ,LAG(active_date) OVER (PARTITION BY user_id ORDER BY active_date)
    FROM (SELECT user_id,active_date FROM test.user_active GROUP BY user_id, active_date)
)
, consecutive_login_counts AS (
    SELECT
        user_id,
        active_date,
        days_diff,
        SUM(IF(days_diff = 1, 1, 0)) OVER (PARTITION BY user_id ORDER BY active_date) AS consecutive_days
    FROM ranked_user_active
)
SELECT
    user_id,
    MAX(consecutive_days)+1 AS max_consecutive_login_days
FROM consecutive_login_counts
GROUP BY user_id
having MAX(consecutive_days)+1 >= 3;