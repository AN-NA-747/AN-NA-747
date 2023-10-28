DROP TABLE IF EXISTS test.user_consume_details;
CREATE TABLE test.user_consume_details
(
    `user_id`  varchar(32),
    `buy_date` date,
    `sum`      int
) COMMENT '用户消费明细表'
    ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' NULL DEFINED AS ''
    LOCATION '/warehouse/sdc/rds/user_consume_details';

INSERT INTO test.user_consume_details
VALUES ('1', '2022-04-26', 3000),
       ('1', '2022-04-27', 5000),
       ('1', '2022-04-29', 1000),
       ('1', '2022-04-30', 2000),
       ('2', '2022-04-27', 9000),
       ('2', '2022-04-29', 6000),
       ('3', '2022-04-22', 5000);

SELECT * from test.user_consume_details;