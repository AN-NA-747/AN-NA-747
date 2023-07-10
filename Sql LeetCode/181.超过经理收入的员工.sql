
/**
  表：Employee

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| name        | varchar |
| salary      | int     |
| managerId   | int     |
+-------------+---------+
Id是该表的主键。
该表的每一行都表示雇员的ID、姓名、工资和经理的ID。


编写一个SQL查询来查找收入比经理高的员工。

以 任意顺序 返回结果表。
 */
SELECT
    A.name as Employee
FROM
    Employee A , Employee B
WHERE A.managerId = B.id
  AND A.salary > B.salary
