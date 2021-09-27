run:
	docker run -ti --rm --name redpanda -v `pwd`/redpanda.yaml:/etc/redpanda/redpanda.yaml -p 9092:9092 -p 9644:9644 vectorized/redpanda:v21.6.2

run_test:
	docker run -ti --rm --name redpanda -p 9092:9092 -p 9644:9644 vectorized/redpanda:v21.6.2

create_topic:
	docker exec -it redpanda rpk topic create prices --brokers 127.0.0.1:9092

list_topics:
	docker exec -it redpanda rpk topic list --brokers 127.0.0.1:9092

list_topics_kafkacat:
	docker run -it --link redpanda edenhill/kafkacat:1.6.0 kafkacat -b redpanda:9092 -L

consume:
	docker run -it edenhill/kafkacat:1.5.0 kafkacat -b 127.0.0.1:9092 -t prices -o 0 -e

transactional_producer:
	seq 100 | docker run -i --link redpanda edenhill/kafkacat:1.6.0 kafkacat -b redpanda:9092 -P -t prices -X transactional.id=myproducer

start_ensemble:
	docker-compose up -d

stop_ensemble:
	docker-compose stop	
