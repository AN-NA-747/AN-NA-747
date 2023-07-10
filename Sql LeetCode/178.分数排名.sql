/**
    表: Scores

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| score       | decimal |
+-------------+---------+
Id是该表的主键。
该表的每一行都包含了一场比赛的分数。Score是一个有两位小数点的浮点值。


编写 SQL 查询对分数进行排序。排名按以下规则计算:

分数应按从高到低排列。
如果两个分数相等，那么两个分数的排名应该相同。
在排名相同的分数后，排名数应该是下一个连续的整数。换句话说，排名之间不应该有空缺的数字。
按 score 降序返回结果表。

    思路对分数进行排序，
    再写一条sql 对取当前比当前分数大的值，count统计后获得排名
 */
select a.Score as Score,
       (select count(distinct b.Score)
        from Scores b
        where b.Score >= a.Score) as `Rank`
from Scores a
order by a.Score DESC;