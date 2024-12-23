# Default make target specified here
.DEFAULT_GOAL := setup

# Command Varaibles
docker_run_cmd = docker run
dockerfile = Dockerfile
docker_flags := -d 
compose_flags := 

# Cleanup all images on the system
cleanup:
	@docker stop $(shell docker ps -a -q)
	@docker remove $(shell docker ps -a -q)

######################################
### Define Image Make Targets Here ###
######################################

###---------------###
### Build and Run ###
###---------------###
{image_name}: export name={image_name}_local
{image_name}: export local_port={image_port_external}
{image_name}: export app_port={image_port_internal}
{image_name}: export docker_flags= -d -p $(local_port):$(app_port) \
  -v "${PWD}/assets:/var/lib/assets" \
	--env VAR1=VAL1
### Optionals
# Set the `image_name` if you want to run a container from a dockerhub public image.
# {image_name}: export image_name=b4bz/homer
# Set this if you want to override the Dockerfile defined above as default (useful for running a dev version of the image)
# {image_name}: export dockerfile=Dockerfile.new
# Pass build flags
# {image_name}-no-cache: export docker_build_flags= --no-cache 
### Build and Run the image
{image_name}: setup env-setup docker-build-{image_name} docker-run-{image_name} what-is-url

###------------------------###
### Build and Run No-Cache ###
###------------------------###
{image_name}-no-cache: export name={image_name}_local
{image_name}-no-cache: export local_port={image_port_external}
{image_name}-no-cache: export app_port={image_port_internal}
{image_name}-no-cache: export docker_flags= -d -p $(local_port):$(app_port) \
  -v "${PWD}/assets:/var/lib/assets" \
	--env VAR1=VAL1
### Optionals
# Set the `image_name` if you want to run a container from a dockerhub public image.
# {image_name}-no-cache: export image_name=b4bz/homer
# Set this if you want to override the Dockerfile defined above as default (useful for running a dev version of the image)
# {image_name}-no-cache: export dockerfile=Dockerfile.new
# Pass build flags
# {image_name}-no-cache: export docker_build_flags= --no-cache 
### Build and Run the image
{image_name}-no-cache: setup env-setup docker-build-no-cache-{image_name} docker-run-{image_name} what-is-url

###--------------------------###
### Build and Run Dev Target ###
###--------------------------###
{image_name}-dev: export name={image_name}_local
{image_name}-dev: export local_port={image_port_external}
{image_name}-dev: export app_port={image_port_internal}
{image_name}-dev: export docker_flags= -d -p $(local_port):$(app_port) \
  -v "${PWD}/assets:/var/lib/assets" \
	--env VAR1=VAL1
### Optionals
# Set the `image_name` if you want to run a container from a dockerhub public image.
# {image_name}-dev: export image_name=b4bz/homer
# Set this if you want to override the Dockerfile defined above as default (useful for running a dev version of the image)
# {image_name}-dev: export dockerfile=Dockerfile.new
# Pass build flags
# {image_name}-dev: export docker_build_flags= --no-cache 
### Build and Run the image
{image_name}-dev: setup env-setup docker-build-dev-{image_name} docker-run-{image_name} what-is-url

###---------------------------###
### Build and Run Prod Target ###
###---------------------------###
{image_name}-prod: export name={image_name}_local
{image_name}-prod: export local_port={image_port_external}
{image_name}-prod: export app_port={image_port_internal}
{image_name}-prod: export docker_flags= -d -p $(local_port):$(app_port) \
  -v "${PWD}/assets:/var/lib/assets" \
	--env VAR1=VAL1
### Optionals
# Set the `image_name` if you want to run a container from a dockerhub public image.
# {image_name}-prod: export image_name=b4bz/homer
# Set this if you want to override the Dockerfile defined above as default (useful for running a dev version of the image)
# {image_name}-prod: export dockerfile=Dockerfile.new
# Pass build flags
# {image_name}-prod: export docker_build_flags= --no-cache 
### Build and Run the image
{image_name}-prod: setup env-setup docker-build-prod-{image_name} docker-run-{image_name} what-is-url

###---------###
### Compose ###
###---------###
### Optional: If you want to pass flags to docker compose
# {image_name}-compose-up: export compose_flags= --env-file .env 
{image_name}-compose-up: setup env-setup compose-up-{image_name}
{image_name}-compose-down: compose-down-{image_name}

###-------###
### Shell ###
###-------###
{image_name}-shell: name={image_name}_local
{image_name}-shell: local_port={image_port_external}
{image_name}-shell: app_port={image_port_internal}
{image_name}-shell: docker_flags= -d -p $(local_port):$(app_port) \
  --user="$(shell id -u):$(shell id -u)" \
	--restart unless-stopped \
  -v "${PWD}/assets:/var/lib/assets" \
	--env-file ${PWD}/.env \
	--env VAR1=VAL1
{image_name}-shell: shell=/bin/bash
{image_name}-shell: docker-run-shell-{image_name}

###-----------------###
### Execute Command ###
###-----------------###
{image_name}-exec: export name={image_name}_local
{image_name}-exec: exec-command-{image_name}

###------------------###
### Delete Container ###
###------------------###
{image_name}-rm: export name={image_name}_local
{image_name}-rm: rm-{image_name}

###--------------###
### Delete Image ###
###--------------###
{image_name}-rm-image:
	rm-image-{image_name}

########################
### Reusable targets ###
########################

docker-run-%:
	${docker_run_cmd} $(docker_flags) --name $(name) $(if $(strip $(image_name)), $(image_name), $(name))

docker-build-%:
	docker build -t $(name) $(docker_build_flags) -f $(dockerfile)

docker-build-dev-%:
	docker build --target=dev -t $(name) $(docker_build_flags) -f $(dockerfile)

docker-build-prod-%:
	docker build --target=prod -t $(name) $(docker_build_flags) -f $(dockerfile)

docker-build-no-cache-%:
	docker build --no-cache -t $(name) $(docker_build_flags) -f $(dockerfile)

what-is-url:
	@echo "!!! Go here dummy --> http://localhost:$(local_port)/ !!!"

exec-command-%: docker-run-%
	@docker exec -it $(name) $(exec_command)

# Make a brand new container from the base image and enter shell (Useful for dev in docker containers)
docker-run-shell-%: docker-build-%
	${docker_run_cmd} $(docker_flags) --rm -it --name $(name) --entrypoint=$(shell) $(if $(strip $(image_name)), $(image_name), $(name))

compose-up-%:
	@docker compose $(compose_flags) -f docker-compose.yml up -d

compose-down-%:
	@docker compose -f docker-compose.yml down

rm-%:
	@docker stop $(name)
	@docker rm $(name)

rm-image-%:
	@docker image rm $(name)

##################################
### Container Specific targets ###
##################################

# host shell setup jobs
setup:
	@sudo apt install -y npm
	@cd app && npm install

env-setup:
	@ENV_FILE="${PWD}/.env";\
	if [ ! -e "$${ENV_FILE}" ]; then\
		touch "$${ENV_FILE}";\
		read -p "Verbose (true/false - leave blank if n/a): " VERBOSE;\
		if ! [ -z "$${VERBOSE}" ]; then\
			echo "Writing VERBOSE...";\
			sed -i '/VERBOSE=/d' $${ENV_FILE};\
			echo "VERBOSE=$${VERBOSE}" >> "$${ENV_FILE}";\
		fi;\
		read -p "PUID (most likely 'id -u' for you - leave blank if n/a): " PUID;\
		if ! [ -z "$${PUID}" ]; then\
			echo "Writing PUID...";\
			sed -i '/PUID=/d' $${ENV_FILE};\
			echo "PUID=$${PUID}" >> "$${ENV_FILE}";\
		fi;\
		read -p "PGID (most likely 'id -g' for you - leave blank if n/a): " PGID;\
		if ! [ -z "$${PGID}" ]; then\
			echo "Writing PGID...";\
			sed -i '/PGID=/d' $${ENV_FILE};\
			echo "PGID=$${PGID}" >> "$${ENV_FILE}";\
		fi;\
	fi;
