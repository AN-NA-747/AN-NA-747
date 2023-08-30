----------------------------------------------------------------------------
-- 判断空函数 判断第一个值如果是空 就区第二个
SELECT nvl("1023","4");
-- :1023
SELECT nvl(null,"4");
-- :4
SELECT nvl(null,null);
-- :null

-- 类型转换
SELECT cast("wu" as int);
-- :NULL


---------------------------------------------------------------------------
-- Returns the date that is num_days before start_date.
-- 返回start_date之前的num_days日期。
SELECT date_sub('2023-8-30',1);
-- :2023-08-29
SELECT date_sub('2023-8-30',4);
-- :2023-08-26

-- Returns the last day of the month which the date belongs to.
-- 返回日期所属月份的最后一天
SELECT last_day('2023-8-1');
-- :2023-08-31

-- date/timestamp/string to a value of string in the format specified by the date format fmt.
-- 日期格式 FMT 指定格式的字符串值
SELECT date_format('2021-01-01','yyyy-MM');
-- :2021-01

-- Returns the first date which is later than start_date and named as indicated.
-- 返回第一个日期，该日期晚于start_date并按指示命名
SELECT next_day('2021-01-01','MO');  -- 返回这个日期 下一个时间点的第一个 星期几
-- :2021-01-04
SELECT next_day('2023-08-30','WED');
-- :2023-09-06

-- Returns the date that is num_days after start_date.
-- 返回在start_date之后num_days的日期。
SELECT date_add('2023-08-30',-1);
-- :2023-08-29
SELECT date_add('2023-08-30',2);
-- :2023-09-01



