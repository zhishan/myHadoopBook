1. There are two ways to generate the User class according to the user.avsc.
  1st way,  by using the maven plugin
          <plugin>
                <groupId>org.apache.avro</groupId>
                <artifactId>avro-maven-plugin</artifactId>
                <version>1.7.6</version>
                <executions>
                    <execution>
                        <phase>generate-sources</phase>
                        <goals>
                            <goal>schema</goal>
                        </goals>
                        <configuration>
                            <sourceDirectory>${project.basedir}/src/main/resources</sourceDirectory>
                            <outputDirectory>${project.basedir}/src/main/java/</outputDirectory>
                        </configuration>
                    </execution>
                </executions>
            </plugin>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-compiler-plugin</artifactId>
                <configuration>
                    <source>1.6</source>
                    <target>1.6</target>
                </configuration>
            </plugin>
 $ mvn generate-sources
  2nd way, useing Avro tool, refer the "Hadoop Definitive Guide Edition2" p 108

How to use it? refer to UserTest.java and PairAvroTest.java

2. $ mvn assembly:single
https://maven.apache.org/plugins/maven-assembly-plugin/index.html
https://maven.apache.org/plugins/maven-assembly-plugin/descriptor-refs.html#jar-with-dependencies
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-assembly-plugin</artifactId>
                <version>2.4</version>
                <configuration>
                <descriptorRefs>
                    <descriptorRef>jar-with-dependencies</descriptorRef>
                </descriptorRefs>
            </configuration>
            </plugin>

3. https://github.com/phunt/avro-rpc-quickstart/blob/master/src/main/java/example/Main.java

4. Avro API

4.1 DatumReader: interface,Determines the in-memory data representation
    D read(D reuse,Decoder in) throws IOException
        Read a datum. Traverse the schema, depth-first, reading all leaf values in the schema into a datum that is returned. If the provided datum is non-null it may be reused and returned.
4.2 Decoder: class, Low-level support for de-serializing Avro values.
  This class has two types of methods. One type of methods support the reading of leaf values (for example, readLong() and readString(org.apache.avro.util.Utf8)).

 The other type of methods support the reading of maps and arrays. These methods are readArrayStart(), arrayNext(), and similar methods for maps). See readArrayStart() for details on these methods.)

 DecoderFactory contains Decoder construction and configuration facilities.


5. avro tool
============
Download from: http://mvnrepository.com/artifact/org.apache.avro/avro-tools

It is an open source tools provided for avro project. The followings are the sample usage.

1. avro-tools usage:

1.1 Convert the avro format file to json file:
	$ java -jar avro-tools-1.7.6.jar tojson --pretty  yourAvro.avro

1.2 get the schema 
	$ java -jar avro-tools-1.7.6.jar getschema yourAvro.avro

1.3 Convert a json file to Avro file by its schema file required
	$ java -jar avro-tools-1.7.6.jar fromjson --schema-file yourschema-file yourJoson.json

BTW, show its all usages: 

	$ java -jar avro-tools-1.7.6.jar 
	Version 1.7.6 of Apache Avro
	Copyright 2010 The Apache Software Foundation

	This product includes software developed at
	The Apache Software Foundation (http://www.apache.org/).

	C JSON parsing provided by Jansson and
	written by Petri Lehtinen. The original software is
	available from http://www.digip.org/jansson/.
	----------------
	Available tools:
		  cat  extracts samples from files
	      compile  Generates Java code for the given schema.
	       concat  Concatenates avro files without re-compressing.
	   fragtojson  Renders a binary-encoded Avro datum as JSON.
	     fromjson  Reads JSON records and writes an Avro data file.
	     fromtext  Imports a text file into an avro data file.
	      getmeta  Prints out the metadata of an Avro data file.
	    getschema  Prints out schema of an Avro data file.
		  idl  Generates a JSON schema from an Avro IDL file
	 idl2schemata  Extract JSON schemata of the types from an Avro IDL file
	       induce  Induce schema/protocol from Java class/interface via reflection.
	   jsontofrag  Renders a JSON-encoded Avro datum as binary.
	       random  Creates a file with randomly generated instances of a schema.
	      recodec  Alters the codec of a data file.
	  rpcprotocol  Output the protocol of a RPC service
	   rpcreceive  Opens an RPC Server and listens for one message.
	      rpcsend  Sends a single RPC message.
	       tether  Run a tethered mapreduce job.
	       tojson  Dumps an Avro data file as JSON, record per line or pretty.
	       totext  Converts an Avro data file to a text file.
	     totrevni  Converts an Avro data file to a Trevni file.
	  trevni_meta  Dumps a Trevni file's metadata as JSON.
	trevni_random  Create a Trevni file filled with random instances of a schema.
	trevni_tojson  Dumps a Trevni file as JSON.

6. If the avro mapreduce job is run by Oozie. You also set the schema when the input/output format set.
<property>
	<name>mapred.input.format.class</name>
	<value>org.apache.avro.mapred.AvroInputFormat</value>
</property>
<property>
	<name>avro.input.schema</name>
	<value>{"type":"record","name":"WeatherRecord","fields":[{"name":"year","type":"int"},{"name":"temperature","type":"int","order":"ignore"},{"name":"stationId","type":"string","order":"ignore"}]}</value>
</property>

The above is suitable for "output"
In AvroJob.java
  /** The configuration key for a job's input schema. */
  public static final String INPUT_SCHEMA = "avro.input.schema";
  /** The configuration key for a job's intermediate schema. */
  public static final String MAP_OUTPUT_SCHEMA = "avro.map.output.schema";
  /** The configuration key for a job's output schema. */
  public static final String OUTPUT_SCHEMA = "avro.output.schema";
  /** The configuration key for a job's output compression codec.
   *  This takes one of the strings registered in {@link org.apache.avro.file.CodecFactory} */
  public static final String OUTPUT_CODEC = "avro.output.codec";
  /** The configuration key prefix for a text output metadata. */
  public static final String TEXT_PREFIX = "avro.meta.text.";
  /** The configuration key prefix for a binary output metadata. */
  public static final String BINARY_PREFIX = "avro.meta.binary.";
  /** The configuration key for reflection-based input representation. */
  public static final String INPUT_IS_REFLECT = "avro.input.is.reflect";
  /** The configuration key for reflection-based map output representation. */
  public static final String MAP_OUTPUT_IS_REFLECT = "avro.map.output.is.reflect";
  /** The configuration key for the data model implementation class. */
  private static final String CONF_DATA_MODEL = "avro.serialization.data.model";

Failed error:

Error: java.lang.NullPointerException at java.io.StringReader.<init>(StringReader.java:50) at org.apache.avro.Schema$Parser.parse(Schema.java:921) at org.apache.avro.Schema.parse(Schema.java:970) at org.apache.avro.mapred.AvroJob.getInputSchema(AvroJob.java:64) at org.apache.avro.mapred.AvroRecordReader.<init>(AvroRecordReader.java:43) at org.apache.avro.mapred.AvroInputFormat.getRecordReader(AvroInputFormat.java:52) at org.apache.hadoop.mapred.MapTask$TrackedRecordReader.<init>(MapTask.java:161) at org.apache.hadoop.mapred.MapTask.runOldMapper(MapTask.java:382) at org.apache.hadoop.mapred.MapTask.run(MapTask.java:335) at org.apache.hadoop.mapred.YarnChild$2.run(YarnChild.java:158) at java.security.AccessController.doPrivileged(Native Method) at javax.security.auth.Subject.doAs(Subject.java:415) at org.apache.hadoop.security.UserGroupInformation.doAs(UserGroupInformation.java:1284) at org.apache.hadoop.mapred.YarnChild.main(YarnChild.java:153) 
