default_target: run

run: lint
	@echo "+"
	ansible-playbook ./run.yml

check:
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
