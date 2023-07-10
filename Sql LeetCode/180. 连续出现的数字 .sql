
/**
  表：Logs

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| num         | varchar |
+-------------+---------+
id 是这个表的主键。


编写一个 SQL 查询，查找所有至少连续出现三次的数字。

返回的结果表中的数据可以按 任意顺序 排列。


  思路
  连续几次，几表相连
 */
SELECT
  DISTINCT a.num as ConsecutiveNums
FROM Logs A,Logs B,Logs C
Where
  A.id = B.id+1 AND B.id = C.id+1
  AND A.num = B.num AND B.num = C.num;