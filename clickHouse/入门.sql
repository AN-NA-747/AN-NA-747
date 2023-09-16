-- 创建表
CREATE TABLE UUID_TEST
(
    c1 UUID,
    c2 String
) ENGINE = Memory;
-- 通过查询 插入一个表
--     特殊方法 generateUUIDv4()
INSERT INTO UUID_TEST
SELECT generateUUIDv4(),'t1';
--第二行UUID没有值;
-- 插入一个字段
INSERT
INTO UUID_TEST(c2)
VALUES ('t2');

SELECT *
FROM UUID_TEST;

-- 创建枚举类型 Enum8/16
CREATE TABLE Enum_TEST
(
    c1 Enum8('ready' = 1, 'start' = 2, 'success' = 3, 'error' = 4)
) ENGINE = Memory;
--正确语句
INSERT INTO Enum_TEST
VALUES ('ready');
INSERT INTO Enum_TEST
VALUES ('start');
--错误语句
INSERT INTO Enum_TEST
VALUES ('stop');
-- 查看插入
SELECT *
FROM Enum_TEST;


--嵌套类型
CREATE TABLE nested_test
(
    name String,
    age  UInt8,
    dept Nested(
        id UInt8,
        name String
        )
) ENGINE = Memory;
--行与行之间,数组长度无须对齐
INSERT INTO nested_test
VALUES ('bruce', 30, [10000,10001,10002], ['研发部','技术支持中心','测试部']);
INSERT INTO nested_test
VALUES ('bruce', 30, [10000,10001], ['研发部','技术支持中心']);
-- 查看
SELECT *
FROM nested_test;

-- 其他类型
/**
  Nullable（TypeName）
  注意：
不能与复合类型数据一起使用、
不能作为索引字段
尽量避免使用，字段被Nullable修饰后会额外生成[Column].null.bin 文件保存Null值， 增加开销
 */
CREATE TABLE Null_TEST
(
    c1 String,
    c2 Nullable(UInt8)
) ENGINE = TinyLog;
--通过Nullable修饰后c2字段可以被写入Null值：
INSERT INTO Null_TEST VALUES ('nauu',null) ;
INSERT INTO Null_TEST VALUES ('bruce',20);
SELECT c1, c2, toTypeName(c2)
FROM Null_TEST;

/**
  Domain
Pv4 使用 UInt32 存储。如 116.253.40.133
IPv6 使用 FixedString(16) 存储。如 2a02:aa08:e000:3100::2
 */
 CREATE TABLE IP4_TEST (
url String,
ip IPv4
) ENGINE = Memory;
INSERT INTO IP4_TEST VALUES ('www.nauu.com','192.0.0.0');
SELECT url , ip ,toTypeName(ip) FROM IP4_TEST;

SHOW CREATE DATABASE default;
SHOW CREATE TABLE default.nested_test;

CREATE TABLE partition_v1 (
ID String,
URL String,
EventTime Date
) ENGINE = MergeTree()
PARTITION BY toYYYYMM(EventTime)
ORDER BY ID ;
INSERT INTO partition_v1 VALUES
('A000','www.nauu.com', '2019-05-01'),
('A001','www.brunce.com', '2019-06-02') ;
SELECT table,partition,path from system.parts WHERE table = 'partition_v1'