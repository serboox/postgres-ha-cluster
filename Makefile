
run: tf-apply sleep ansible-up

sleep:
	sleep 10

destroy: tf-destroy

# Terraform commands
tf-init:
	@echo "+ $@"
	cd ./terraform/selectel-vpc &&\
	terraform init

tf-plan:
	@echo "+ $@"
	cd ./terraform/selectel-vpc &&\
	terraform plan

tf-apply: tf-fmt tf-validate
	@echo "+ $@"
	cd ./terraform/selectel-vpc &&\
	terraform apply -target=module.project_with_user --auto-approve=true
	cd ./terraform/selectel-vpc &&\
	terraform apply --auto-approve=true

tf-destroy:
	@echo "+ $@"
	for name in pg-cluster; do \
		cd ./terraform/selectel-vpc; \
		terraform destroy -target=module.$$name --auto-approve=true; \
		cd -; \
	done
	cd ./terraform/selectel-vpc &&\
	terraform destroy -target=module.project_with_user --auto-approve=true

tf-output:
	@echo "+ $@"
	cd ./terraform/selectel-vpc && \
	terraform output

tf-fmt:
	@echo "+ $@"
	cd ./terraform/selectel-vpc && \
	terraform fmt ./..

tf-validate:
	@echo "+ $@"
	cd ./terraform/selectel-vpc && \
	terraform validate .

# Ansible commands
ansible-up:
	@echo "+ $@"
	cd ./ansible && make run
