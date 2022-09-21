# https://www.conduktor.io/kafka
# Theory
* Topics, Partitions and offsets
  * Topics
    - a particular stream of data
    - like a table in databse (without all the constraints)
    - you can have as many topics as you want in a cluster
    - A topic is identified by its name
    - Supports any kind of messgae formats(json, avro, text file etc)
    - the sequence of messages is called a data stream
    - you cannot query topics, instead, use kafka producers to send data and kafka Consumers to read the data
  * Partitions and offsets
    - Topics are split in partitions. Ex Partition 0, Partition 1, Partition 2 etc
      - Messages sent to kafka topic end up in partitions
      - Messages within each partitions are ordered
      - Each Message within partition gets an incremental id, called offset
      - Kafka topics are immutable: once data is written to a partition, it cannot be changed
    - Important notes
      - once the data is written to a partition, it cannot be changed(immutability)
      - Data is kept only for a limited time(default is one week - configurable)
      - Offset only have a meanning for a specific partition
        - Ex offset 3 in partition 0 dosen't represent the same data as offset 3 in partiotion 1
        - Offsets are not re-used even if the previous messages have been deleted
      - Order is guaranteed only within a partitoin(not across partitions)
      - Data is assigned randomly to a partition unless a key is provided
      - You can have as many partitions per topic as you want

* Producers and Message Keys
  * Producers
    - Producers write data to topics(which are made of partitions)
    - Producers Know to which topic partition to write to and which kafka broker hast it
    - in case of kafka broker failures, Producers will automatically recover
    - Load balancing in this case, producers will send data across all partitions based on some mechanism and this is why kafka scales. Because we have many partitions within a topic and each partitoin is going to recieve a message from one or more producers
    - Message Keys
      - The message produced by the producer contains data itself and we can send a key in the data.
      - Producsrs can choose to send a key with the message(string, number, binary, ...etc)
      - Two cases
        - If the key=null, data is sent round robin(Partition0, Partition1 ...)(load balancing is achieved)
        - if the key!=null, then all messages for that key will always go to same partition(hashing)
        - A key are typically sent if you need message ordering for a  specific field(ex: truck_id) 3:24
    - Anatomy => anatomy image in images
    - Kafka Message Serializer
      - Messages get created by Kafka Message Serializer
      - Kafka only accepts bytes as an input from producers and sends bytes out as an output to consumers
      - Message Serialization means transforming objects/data into bytes
      - They are used on the value and the key
      - Kafka producers come with common serializers
        - string, int, float, json, Avro, protobuf
      - Kafka Message Key Hashing
        -

* Consumers & Deserialization
  * Consumers
    - Consumers read data from a topic(identified by a name) - pull model
    - Consumers automatically know which broker to read from
    - in case of broker failures, consumers know how to recover
    - Data is read in order from low to high offset within each partitions
  * Consumer Deserializer
    - The consure must know in advance the format of key and the value
    - Deserializer indicates how to transfor bytes into objects/data
    - They are used on the value and the key of the message
    - Common Deserializers
      - string, json, Avro, float, protobuf
    - The serialization/deserialization type must not change durin a topic lifecycle(create a new topic instead)

* Consumer Groups & Consumer Offsets
  * Consumer Groups
    - All the consumers in an application read data as a consumer groups
    - Each Consumer within a group reads from exclusive partitions
    - This way a group is reading kafka topic as a whole
    - what if too many consumers in a consumer group more than partitions?
      - if you have more consumers than partitions, some consumers will be inactive
    - Multiple Consumers on one topic
      - in kafka it is acceptable to have multiple consumer groups on the same topic
      - To create distinct consumer groups, use the consumer property group.id
    - Consumer Ofssets
      - kafka stores the offsets at which a consumer group has been reading
      - The offsets committed are in kafka topic named `__consumer_offsets`
      - when a consumer in a group has processed data received from kafka, it should be periodically commiting the offsets(the kafka broker will write to `__consumer_offsets`, not the group itself)
      - if a consumer dies, it will be able to read back from where it left off thanks to the committed consumer offsets!
    - Delivery Semantics for consumers
      - atleast once
      - atmost once
      - excatly once
      - Delivery Semantics for consumers.png

* Broker and Topics
  * Brokers
    - A broker is just a server
    - A kafka Cluster is composed of multiple brokers(servers)
    - Each broker is identified with its ID(integer) in a cluster
    - Each broker contains certain topic partiotions, data will be distributed across all brokers
    - After connecting to any broker(called a bootstrap broker), you will be connected to the entire cluster and know how to do it aswell(Kafkas clients have smart mechanics for that)
    - So we dont need to know in advance all the brokers in the cluster, we need to know how to connect to one broker in the cluster then the clients will automatically connect to the rest.
    - A Good number to get started is 3 brokers, but some big clusters have over 100 brokers.
  * How brokers, topics & partitions are releated
    - broker,topic,partions related.png
    - See the image, this is called horizontal scaling. There more brokers and partitions we add the more the data is going to be spread out across the cluster.
    - The broker don't have all the data, but have data they should only have
  * Broker Discovery Mechanism
    - kafka broker discovery.png

* Topic Replication
  * Topic Replication factor
    - Topics should have a replication factor > 1(usually between 2 & 3), but mostly 3
    - topic-replication-factor.png
  * Concept of leader for a partition
    - if data is replicated fast enough, each replica is going to be called `ISR(in-sync replica)`
    - in the image starred are leader replicas
    - leader-for-a-partition.png
  * Default Producer & consumer behavior with leaders
    - kafka producers can only write to the leader broker for a partition
    - kafka Consumers by default will read from leader broker for a partition
  * Kafka Consumer Replica Fetching
    - since kafka 2.4, it is possible to configure consumers to read from the closest replica
    - This may help improve latency, and also decrease network costs if using cloud
    - kafka-consumers-replica-fetching.png
