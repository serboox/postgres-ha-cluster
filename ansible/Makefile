default_target: run

run: ansible-galaxy-install lint
	@echo "+"
	ansible-playbook ./run.yml

check: lint
	@echo "+"
	ansible-playbook ./run.yml --check

lint:
	@echo "+"
	ansible-lint ./run.yml

install:
	ansible-galaxy install -r environments/stage/requirements.yml

encrypt:
	ansible-vault encrypt environments/stage/credentials.yml

decrypt:
	ansible-vault decrypt environments/stage/credentials.yml

edit:
	ansible-vault edit environments/stage/credentials.yml

ansible-galaxy-install:
	ansible-galaxy install -r ./environments/stage/requirements.yml

show-local-ip:
	ansible -m shell -a "ip a | grep inet | grep eth0 | awk '{print \$$2}'" all
