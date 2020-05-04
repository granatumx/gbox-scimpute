VER = 1.0.0
GBOX = granatumx/gbox-scimpute:$(VER)

docker:
	docker build --build-arg VER=$(VER) --build-arg GBOX=$(GBOX) -t $(GBOX) .

docker-push:
	docker push $(GBOX)

shell:
	docker run -it $(GBOX) /bin/bash

test:
	cat input.json | docker run -it $(GBOX) python3 ./main.py

doc:
	./gendoc.sh
