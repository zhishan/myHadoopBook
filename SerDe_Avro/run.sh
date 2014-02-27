#input=${1:=/user/zhishan/hadoop-book/ch02/input} run.sh: line 1: $1: cannot assign in this way
input=${1:-hdfs://localhost:9000/user/zhishan/ncdc/input}
output=${2:-hdfs://localhost:9000/user/zhishan/ncdc/output}
hadoop fs -rmr -skipTrash $output
#hadoop jar ./target/ch02-1.0-SNAPSHOT.jar com.myhp.ch02.MaxTemperatureMain $input $output 
#hadoop jar SerDe_Avro-1.0.jar -libjar com.myhp.serDe.avro.mapreduce.AvroGenericMaxTemperature $input $output 

java -cp SerDe_Avro-1.0.jar:SerDe_Avro-1.0-jar-with-dependencies.jar com.myhp.serDe.avro.mapreduce.AvroGenericMaxTemperature $input $output

#mapred.output.dir	hdfs://localhost:9000/user/zhishan/hadoop-book/ch02/output
#mapred.input.dir	hdfs://localhost:9000/user/zhishan/hadoop-book/ch02/input
