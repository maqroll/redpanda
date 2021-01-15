run:
	docker run -ti --rm --name redpanda -p 9092:9092 -p 9644:9644 vectorized/redpanda:v20.12.9
