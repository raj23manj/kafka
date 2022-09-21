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
