start:
	docker run --name=redpanda-1 --rm \
		-p 9092:9092 \
		-p 9644:9644 \
		-p 29092:29092 \
		-v `pwd`/redpanda.yaml:/tmp/redpanda.yaml \
		docker.vectorized.io/vectorized/redpanda:latest \
		redpanda start \
		--overprovisioned \
		--smp 1  \
		--memory 1G \
		--reserve-memory 0M \
		--node-id 0 \
		--kafka-addr PLAINTEXT://0.0.0.0:29092,OUTSIDE://0.0.0.0:9092 \
		--advertise-kafka-addr PLAINTEXT://redpanda-1:29092,OUTSIDE://localhost:9092 \
		--check=false \
		--config /tmp/redpanda.yaml

create_topic:
	docker exec -it redpanda-1 rpk topic create prices --brokers 127.0.0.1:9092

list_topics:
	docker exec -it redpanda-1 rpk topic list --brokers 127.0.0.1:9092

list_topics_kafkacat:
	docker run -it --link redpanda-1 edenhill/kcat:1.7.1 kafkacat -b redpanda-1:9092 -L

consume:
	docker run -it --link redpanda-1 edenhill/kcat:1.7.1 kafkacat -b redpanda-1:29092 -t prices -o 0 -e

transactional_producer:
	seq 100 | docker run -i --link redpanda-1 edenhill/kcat:1.7.1 kafkacat -b redpanda-1:29092 -P -t prices -X transactional.id=myproducer

start_ensemble:
	docker-compose up -d

stop_ensemble:
	docker-compose stop	
