NAME := blog
BASE_URL := localhost

.DEFAULT_GOAL := help

.PHONY: all start-server stop-server

all:

%.image:
	@if [ "$*" = "production" ]; then \
		DOCKERFILE=Dockerfile; \
	else \
		DOCKERFILE=Dockerfile.$*; \
	fi; \
	docker image build -t $(NAME):$* -f $$DOCKERFILE .

start-server: stop-server dev.image ## Start server
	docker container run --rm -d \
		-p 1111:1111 -p 1000:1000 \
		-v $(PWD):/var/www \
		-e BASE_URL=$(BASE_URL) \
		--name $(NAME)-dev $(NAME):dev

stop-server: ## Kill server process
	docker container rm -f $(NAME)-dev 2>/dev/null || exit 0

help: ## Self-documented Makefile
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
