# Configuration
COMPOSE = docker compose -f srcs/docker-compose.yml
VOLUME = /home/squinn/data

all : up

up :
	@mkdir -p $(VOLUME)/mariadb
	@mkdir -p $(VOLUME)/wordpress
	@chmod 755 $(VOLUME)
	@chmod 755 $(VOLUME)/wordpress
	@chmod 755 $(VOLUME)/mariadb
	@$(COMPOSE) build --no-cache
	@$(COMPOSE) up -d --build

down :
	@rm -rf $(VOLUME)
	@$(COMPOSE) down

stop :
	@$(COMPOSE) stop

start :
	@$(COMPOSE) start

logs:
	@$(COMPOSE) logs -f

status :
	@docker ps

clean:
	@docker stop $$(docker ps -qa) 2>/dev/null || true
	@docker rm $$(docker ps -qa) 2>/dev/null || true
	@docker rmi $$(docker images -qa) 2>/dev/null || true
	@docker volume rm $$(docker volume ls -q) 2>/dev/null || true
	@docker network rm $$(docker network ls -q) 2>/dev/null || true
	@rm -rf $(VOLUME)

fclean: clean
	@rm -rf $(VOLUME)

re: fclean up
