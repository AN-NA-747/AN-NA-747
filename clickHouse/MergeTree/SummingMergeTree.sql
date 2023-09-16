CREATE TABLE summing_table
(
    id          String,
    city        String,
    v1          UInt32,
    v2          Float64,
    create_time DateTime
) ENGINE = SummingMergeTree()
      PARTITION BY toYYYYMM(create_time)
      ORDER BY (id, city)
      PRIMARY KEY id;

insert into summing_table
select '1', '上海', 1, 1.0, '2021-05-01'
from
    numbers(100);
insert into summing_table
select '2', '广州', 1, 1.0, '2021-05-01'
from
    numbers(100);
insert into summing_table
select '3', '武汉', 1, 1.0, '2021-05-01'
from
    numbers(100);
insert into summing_table
select '1', '上海', 1, 1.0, '2021-05-01'
from
    numbers(100);

optimize table summing_table final;

select *
from summing_table;