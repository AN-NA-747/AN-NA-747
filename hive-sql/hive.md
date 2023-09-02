# Hive
## 生成环境的一些设置
### commit 备注中文设置(修改完成后记得重启)
```mysql
-- 修改hive表中 mysql数据源存储的字符编码
-- （1）修改表字段注解和表注解

alter table COLUMNS_V2 modify column COMMENT varchar(256) character set utf8;
alter table TABLE_PARAMS modify column PARAM_VALUE varchar(4000) character set utf8;

-- （2）修改分区字段注解

alter table PARTITION_PARAMS modify column PARAM_VALUE varchar(4000) character set utf8 ;
alter table PARTITION_KEYS modify column PKEY_COMMENT varchar(4000) character set utf8;

-- （3）修改索引注解

alter table INDEX_PARAMS modify column PARAM_VALUE varchar(4000) character set utf8;
```
```xml
<!-- hive-site.xml配置文件 -->
<property>
    <name>javax.jdo.option.ConnectionURL</name>
    <value>jdbc:mysql://IP:3306/db_name?createDatabaseIfNotExist=true&amp;useUnicode=true&amp;characterEncoding=UTF-8</value>
    <description>JDBC connect string for a JDBC metastore</description>
</property>
```
## 测试环境中hive的查询优化
hadoop/etc/hadoop/capacity-scheduler.xml中yarn.scheduler.capacity.maximum-am-resource-percent参数，application master资源比例，默认为0.1，如果该值设置过大，就会导致mapreduce时内存不足
在学习环境下application master分配内存较少，可能同时只能执行一个job，影响效率。可以尝试调整0.5，我从0.8调至0.5。
```xml
 <!-- yarn容器允许分配的最大最小内存 -->
    <property>
        <name>yarn.scheduler.minimum-allocation-mb</name>
        <value>512</value>
    </property>
    <property>
        <name>yarn.scheduler.maximum-allocation-mb</name>
        <value>4096</value>
    </property>
    
    <!-- yarn容器允许管理的物理内存大小 -->
    <property>
        <name>yarn.nodemanager.resource.memory-mb</name>
        <value>4096</value>
    </property>
    
    <!-- 关闭yarn对物理内存和虚拟内存的限制检查 -->
    <property>
        <name>yarn.nodemanager.pmem-check-enabled</name>
        <value>false</value>
    </property>
    <property>
        <name>yarn.nodemanager.vmem-check-enabled</name>
        <value>false</value>
    </property>
```
```hiveql
SET hive.exec.compress.intermediate=true;
-- 中间结果压缩
SET hive.intermediate.compression.codec=org.apache.hadoop.io.compress.SnappyCodec;
-- 输出结果压缩
SET hive.exec.compress.output=true;
SET mapreduce.output.fileoutputformat.compress.codec=org.apache.hadoop.io.compress.SnappyCodc;
SET mapreduce.job.jvm.numtasks=5;
SET hive.exec.parallel=true; -- 默认false
SET hive.exec.parallel.thread.number=16; -- 默认8
SET hive.auto.convert.join=true; --  hivev0.11.0之后默认true
SET hive.mapjoin.smalltable.filesize=600000000; -- 默认 25m
SET hive.auto.convert.join.noconditionaltask=true; -- 默认true，所以不需要指定map join hint
SET hive.auto.convert.join.noconditionaltask.size=10000000; -- 控制加载到内存的表的大小
SET hive.vectorized.execution.enabled=true; -- 默认 false
SET hive.cbo.enable=true; --从 v0.14.0默认true
SET hive.compute.query.using.stats=true; -- 默认false
SET hive.stats.fetch.column.stats=true; -- 默认false
SET hive.stats.fetch.partition.stats=true; -- 默认true
set hive.execution.engine=spark;
```