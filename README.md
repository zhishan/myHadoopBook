
Hadoop: The Definitive Guide, Edition 2

1. basicUtil
	To record java basic knowledge got from learning hadoop.
 
2. ch02 -- About the MapReduce

http://sujee.net/tech/articles/hadoop/hbase-map-reduce-freq-counter/
http://diveintodata.org/2011/03/15/an-example-of-hadoop-mapreduce-counter/
http://gbif.blogspot.com/2011/01/setting-up-hadoop-cluster-part-1-manual.html
http://grepalex.com/2012/10/20/hadoop-unit-testing-with-minimrcluster/

To test wheter "System.out.println" and "LogFactory" work in Hadoop,it also show how to add DEBUG INFO/Logging into the MR process. 
In pom.xml
        <dependency>
            <groupId>commons-logging</groupId>
            <artifactId>commons-logging</artifactId>
            <version>1.1.1</version>
        </dependency>
http://commons.apache.org/proper/commons-logging/, The Logging package is an ultra-thin bridge between different logging implementations. A library that uses the commons-logging API can be used with any logging implementation at runtime. Commons-logging comes with support for a number of popular logging implementations, and writing adapters for others is a reasonably simple task.
2.1 Mapper Class
public class MaxTemperatureMapper extends MapReduceBase
    implements Mapper<LongWritable, Text, Text, IntWritable>{

    private static final int MISSING = 9999;
    public static final Log log = LogFactory.getLog(MaxTemperatureDriver.class);

    public void map(LongWritable key, Text value,
                    OutputCollector<Text, IntWritable> output, Reporter reporter) throws IOException{ 
...
        System.out.println("*** System.out.println: " + value.toString()); // getMapperClass

        log.info(log.isInfoEnabled() ? "[Info Enabled] " + value.toString() : "[Info Not Enabled]");
	}

From the Mapper jobs' log, we get below:

stdout logs
*** System.out.println: 0035029070999991902010106004+64333+023450FM-12+000599999V0201401N011819999999N0000001N9-00941+99999100551ADDGF104991999999999999999999MW1381
*** System.out.println: 0035029070999991902010113004+64333+023450FM-12+000599999V0201401N011819999999N0000001N9-01001+99999100311ADDGF104991999999999999999999MW1381
syslog logs
2014-02-23 10:39:12,877 INFO com.myhp.ch02.MaxTemperatureDriver: [Info Enabled] 0035029070999991902010106004+64333+023450FM-12+000599999V0201401N011819999999N0000001N9-00941+99999100551ADDGF104991999999999999999999MW1381

2.2 Reducer class
public class MaxTemperatureReducer extends MapReduceBase
    implements Reducer<Text, IntWritable, Text, IntWritable>  {
    public static final Log log = LogFactory.getLog(MaxTemperatureReducer.class);

    public void reduce(Text key, Iterator<IntWritable> values,
                       OutputCollector<Text, IntWritable> output, Reporter reporter) throws IOException {
    // input (Text, IntWritable) = (1901, 317)
        System.out.println("*** System.out.println: " + values.toString()); // getMapperClass

        log.info(log.isInfoEnabled() ? "[Info Enabled] " + values.toString() : "[Info Not Enabled]");

...}

Log for Reducer job's:
stdout logs
*** System.out.println: org.apache.hadoop.mapred.ReduceTask$ReduceValuesIterator@15f1201

syslog logs
2014-02-23 10:39:21,728 INFO com.myhp.ch02.MaxTemperatureReducer: [Info Enabled] org.apache.hadoop.mapred.ReduceTask$ReduceValuesIterator@15f1201


2.3 Main/Driver's log from client's console:

Deleted hdfs://localhost:9000/user/zhishan/hadoop-book/ch02/output
*** System.out.println: user.home not found as a setting
*** System.out.println: JVM property - user.home : null
*** System.out.println: com.myhp.ch02.MaxTemperatureMapper
*** System.out.println: /home/zhishan/hadoop-tmp.DO_NOT_DELETE/dfs/name
14/02/23 10:39:07 INFO ch02.MaxTemperatureDriver: [Info Enabled] dfs.name.dir: /home/zhishan/hadoop-tmp.DO_NOT_DELETE/dfs/name
14/02/23 10:39:07 INFO ch02.MaxTemperatureDriver: [Info Enabled] user.home: not found as a setting
14/02/23 10:39:08 INFO ch02.MaxTemperatureDriver: [Info Enabled] Mapper Class: class com.myhp.ch02.MaxTemperatureMapper

*/
3. ch03 -- About the Common component
Sevaral part as below in Hadoop Common component
 \_ Configuartion -- System Configuration Tool: org.apache.hadoop.conf.Configuration.
	How to get the Job's Configuration and JVM properties of Hadoop? 
	As we can know from the ch02, the property: user.home could not get from MapReduce's job, but it is expanded correctly. The best way to get the hadoop JVM property is by using "System.getProperty(key)" Along with "Configuration" class.
	Try to override a "final" property, just a "WARN" with "ignoring" is issued, not an error. see MultipleResourceConfigurationTest

 \
 \_ SerDe -- Hadoop SerDe: Serialization/Deserialization in J2SE and Hadoop system.
	headFirstJava: p439
	对象有状态和行为两种属性。行为存在与类中， 而状态存在于个别的对象中。
    An object containning two kind info: Attributes and Behaviours. "Behaviours" info exist in the class definition, but "Attributes" info exist in the class's instance - object.
	GameCharacter.java -- Serializable class (WriteObject, and ReadObject can be overrided in your class, refer to URI.java)
	GameCharacterTest.java -- Tester include serializable and deserializable cases.

3.1 SerialVersionID
http://javapapers.com/core-java/serialversionuid-in-java-serialization/
How serialVersionUID works?
When an object is serialized, the serialVersionUID is serialized along with the other contents.
Later when that is deserialized, the serialVersionUID from the deserialized object is extracted and compared with the serialVersionUID of the loaded class.
If the numbers do not match then, InvalidClassException is thrown.
If the loaded class is not having a serialVersionUID declared, then it is automatically generated using the same algorithm as before.

“the default serialVersionUID computation is highly sensitive to class details that may vary depending on compiler implementations, and can thus result in unexpected InvalidClassExceptions during deserialization"
Not only declaring a serialVersionUID is sufficient. You must do the following two things carefully. Otherwise it defeats the purpose of having the serialVersionUID.
serialVersionUID should be maintained. As and when you change anything in the class, you should upgrade the serailVersionUID.
Try your best to declare a unique serialVersionUID. 

http://www.jusfortechies.com/java/core-java/serialVersionUID.php
	more detail infor can be find in ch03/README.md
 \
 \_ FileSystem


4. SerDe_Avro
To build a jar with dependencies.

 $ mvn assembly:single
https://maven.apache.org/plugins/maven-assembly-plugin/index.html
https://maven.apache.org/plugins/maven-assembly-plugin/descriptor-refs.html#jar-with-dependencies

5. Jasper is an open source platform for developing always-on, voice-controlled applications.
http://jasperproject.github.io/
5.1 fdisk tool, dd

6. JasperReport, an Java Opensoure Report tool
http://www.ppurl.com/?s=jasperReport
http://baike.baidu.com/link?url=lhVfSRms77elAK9raOYPt9yzePc34ksVjST8s41hg-MIFnG2fmq_ktRICPK0QEwD

Split the override code into there discreet segments there, and embeded them in the drone's thrasponder signal. Almost impossbile to spot, unless you're me.

