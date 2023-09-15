-- 获取一个UUID
SELECT generateUUIDv4();
-- :b85f71e9-bb96-42bb-8c8a-1a13f6093a47

-- 查看 该字段的方法 toTypeName
SELECT [1,2,null] as a, toTypeName(a);
-- :Array(Nullable(UInt8))
SELECT array(128,256,-127) as a , toTypeName(a);
-- :Array(Int32)
SELECT tuple(1,'a',now()) as x ,toTypeName(x);
-- :Tuple(UInt8, String, DateTime)