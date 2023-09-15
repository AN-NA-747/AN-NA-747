----------------------------------------------------------------------------
-- 判断空函数 判断第一个值如果是空 就区第二个
SELECT nvl("1023","4");
-- :1023
SELECT nvl(null,"4");
-- :4
SELECT nvl(null,null);
-- :null

-- 保留几位小数
SELECT round(2,3);
--: 2.000

-- 类型转换
SELECT cast("wu" as int);
-- :NULL

-- URL 解析
SELECT PARSE_URL_TUPLE("https://cn.bing.com/search?q=%E6%9C%89%E9%81%93&PC=U316&FORM=CHROMN", 'PROTOCOL', 'HOST', 'PATH', 'QUERY');
-- | https | cn.bing.com | /search | q=%E6%9C%89%E9%81%93&PC=U316&FORM=CHROMN |


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

-----------------------------------------------------------------------------------------------------------
--  开窗函数
--      聚合开窗函数
SELECT sum(),count(),avg(),max(),min();

--      分析型窗口函数
SELECT RANK(),          -- 间断，相同值同序号，例如    1、2、2、2、5。
       DENSE_RANK(),    -- 不间断，相同值同序号，例如    1、2、2、2、3。
       ROW_NUMBER()     -- 间断，序号不重复，例如 1、2、3、4、5（2、3 可能是相同的值）。
;
--      取值型窗口函数
SELECT
    LAG(COL, N, DEFAULT_VAL),   --往前第    N 行数据，没有数据的话用    DEFAULT_VAL 代替。
    LEAD(COL, N, DEFAULT_VAL),  --往后第    N 行数据，没有数据的话用    DEFAULT_VAL 代替。
    FIRST_VALUE(EXPR),          --分组内第一个值，但是不是真正意义上的第一个或最后一个，而是截至到当前行的 第一个或 最后一个。
    LAST_VALUE(EXPR),           --分组内最后一个值，但是不是真正意义上的第一个或最后一个，而是截至到当前行的 第一个 或最后一个。
    PERCENT_RANK(),             --计算小于当前行的值在所有行中的占比，类似百分比排名。可以用来计算超过了百分之 多少的 人。计算某个窗口或分区中某个值的累积分布。
                                -- 假定升序排序，则使用以下公式确定累积分布：
                                --  小于 x 的行 数  / 窗口
                                --  或 PARTITION 分区内的总行数。
                                --  其中 x 等于 ORDER BY 子句中指定的列的当前行中的值。
    CUME_DIST(),                -- 计算小于等于当前行的值在所有行中的占比。
    NTILE(N)                    -- 如果把数据按行数分为 N 份，那么该行所属的份数是第几份。注意：N 必须为 INT 类型。
;





