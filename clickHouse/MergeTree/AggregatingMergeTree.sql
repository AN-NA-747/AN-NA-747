CREATE TABLE agg_table_basic
(
    id    String,
    city  String,
    code  String,
    value UInt32
) ENGINE = MergeTree()
      PARTITION BY city
      ORDER BY (id, city);

CREATE MATERIALIZED VIEW agg_view
            ENGINE = AggregatingMergeTree()
                PARTITION BY city
                ORDER BY (id, city)
AS
SELECT id,
       city,
       uniqState(code) AS code,
       sumState(value) AS value
FROM agg_table_basic
GROUP BY id, city;

INSERT INTO TABLE agg_table_basic
VALUES ('A000', 'wuhan', 'code1', 100),
       ('A000', 'wuhan', 'code2', 200),
       ('A000', 'zhuhai', 'code1', 200);

SELECT id, sumMerge(value), uniqMerge(code)
FROM agg_view
GROUP BY id, city;
