run:
	docker run -ti --rm --name redpanda -p 9092:9092 -p 9644:9644 vectorized/redpanda:v20.12.9

create_topic:
	docker exec -it redpanda rpk api topic create test

list_topics:
	docker exec -it redpanda rpk api topic list

list_topics_kafkacat:
	docker run -it --link redpanda edenhill/kafkacat:1.6.0 kafkacat -b redpanda:9092 -L
