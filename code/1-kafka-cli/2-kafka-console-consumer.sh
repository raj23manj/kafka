# Replace "kafka-console-consumer.sh"
# by "kafka-console-consumer" or "kafka-console-consumer.bat" based on your system # (or bin/kafka-console-consumer.sh or bin\windows\kafka-console-consumer.bat if you didn't setup PATH / Environment variables)

kafka-console-consumer.sh

# consuming, it will read from the end of the topic
kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic first_topic

# other terminal, produce messages
kafka-console-producer.sh --bootstrap-server localhost:9092 --topic first_topic

# consuming from beginning, but data will be out of order on the o/p but the withi in each partion messages are ordered 3:20
kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic first_topic --from-beginning

# display key, values and timestamp in consumer
kafka-console-consumer --bootstrap-server localhost:9092 --topic first_topic --formatter kafka.tools.DefaultMessageFormatter --property print.timestamp=true --property print.key=true --property print.value=true --from-beginning
