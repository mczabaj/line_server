NAME = line_server
VERSION ?= latest
DOCKERFILE = .
GIT_COMMIT_TAG ?= none
IMAGE_NAME = "mczabaj/$(NAME)"
INSTANCE = build
CONTAINER_NAME = "$(NAME).$(INSTANCE)"
BUILD_IMAGE_NAME = "$(IMAGE_NAME):build"
TEST_CONTAINER_NAME = "$(NAME).$(INSTANCE).test"
APP_PATH = /usr/src/app
TEST_RESULTS_DIR = "/results/"
ERROR_COLOR = \033[1;31m
WARN_COLOR = \033[1;33m
NO_COLOR = \033[0m

DOCKER_USER = ""
DOCKER_PASSWORD = ""

.PHONY: build push pull shell run start stop rm release test verify-auth

default: build

guard-%:	# Add an implicit guard for parameter input validation
	@if [ "${${*}}" = "" ]; then \
		printf \
			"$(ERROR_COLOR)Error: Variable [$*] not set.$(NO_COLOR)\n"; \
		exit 1; \
	fi

help:		## Prints the names and descriptions of available targets
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

verify-auth: # Verifies caller has authenticated with DockerHub (target not shown on help menu to avoid confusion)
	@if [ ! -f ~/.docker/config.json ]; then \
		printf \
	"$(WARN_COLOR)Docker config file was not found, if you encounter issues \
	verify you are logged into Docker Hub using the 'docker login' command.$(NO_COLOR)\n"; \
	else \
		printf "verified \n"; \
	fi

login: guard-DOCKER_USER guard-DOCKER_PASSWORD 	## Authenticate with remote Docker repository
	@docker login \
		--username $(DOCKER_USER) \
		--password $(DOCKER_PASSWORD)

logout:
	@docker logout

##
### Docker targets
##
build: verify-auth	## Build the docker image

# The following code will build the image once but then tag the image multiple times. This avoids needing to rebuild
# the binary when no changes have occurred.
#
# The multi-line loop is needed below so "make" will execute everything in a single sub-shell. If these commands are
# separated into separate commands BASH variable assignment will be lost.

	@docker build -t $(BUILD_IMAGE_NAME) $(DOCKERFILE); \
	for v in $(VERSION); \
	do \
		docker tag $(BUILD_IMAGE_NAME) "$(IMAGE_NAME):$$v"; \
	done;

pull: verify-auth	## Pull Docker image from remote repository
	@for v in $(VERSION); do docker pull $(IMAGE_NAME):$$v; done

push: verify-auth	## Push the docker image to its remote repository (always performed by automated build)
	@for v in $(VERSION); do docker push $(IMAGE_NAME):$$v; done

shell: build		## Executes a shell command in a new container using this repo's main docker image
	@docker run --rm \
		--name $(CONTAINER_NAME) \
		--publish 3000:3000 \
		--interactive \
		--volume `pwd`:$(APP_PATH) \
		--tty \
		--entrypoint sh \
		$(IMAGE_NAME):$(VERSION)

start: build verify-auth ## Start docker container in isolation (without docker-compose multi-container configuration)
	@docker run --rm \
		--net="host" \
		--name $(CONTAINER_NAME) \
		--publish 3000:3000 \
		--interactive \
		--tty \
		--entrypoint sh  \
		$(IMAGE_NAME):$(VERSION)

dev: build
	@docker run -d \
		--name $(CONTAINER_NAME) \
		-p 3000:3000 \
		--volume `pwd`:$(APP_PATH) \
		--interactive \
		--tty \
		--entrypoint lein  \
		$(IMAGE_NAME):$(VERSION) run


stop:	## Stop docker container
	@docker stop $(CONTAINER_NAME)

rm:		## Remove docker container
	@docker rm -f $(CONTAINER_NAME)

unit-test:
	@lein test

##
### Environment targets
##

uberjar: ## compile application to uberjar
	@lein uberjar

run: ## clean, build, and run the jar directly
	@java -jar -Dconf=/usr/src/app/config.edn /usr/src/app/target/uberjar/line_server.jar

env-stop:	## Stop docker container
	@docker-compose -f docker-compose.yml -f docker-compose-test.yml stop

env-rm:		## Remove docker container
	@docker-compose -f docker-compose.yml -f docker-compose-test.yml kill
	@docker-compose -f docker-compose.yml -f docker-compose-test.yml rm --force

env-start: verify-auth env-rm build	## Launch docker environment using configuration specified within docker-compose.yml
	@docker-compose -f docker-compose.yml -f docker-compose-dev.yml up

env-start-d: verify-auth env-rm build	## Launch docker environment in background
	@docker-compose -f docker-compose.yml -f docker-compose-dev.yml up -d

test-env-start-d: verify-auth env-rm build	## Launch docker environment in background
	@docker-compose -f docker-compose.yml -f docker-compose-test.yml up -d
