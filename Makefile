
run: tf-apply ansible-up

destroy: tf-destroy

# Terraform commands
tf-init:
	@echo "+ $@"
	cd ./terraform/selectel-vpc &&\
	terraform init

tf-apply: tf-fmt tf-validate
	@echo "+ $@"
	cd ./terraform/selectel-vpc &&\
	terraform apply -target=module.project_with_user --auto-approve=true
	cd ./terraform/selectel-vpc &&\
	terraform apply --auto-approve=true --parallelism=1

tf-destroy:
	@echo "+ $@"
	for name in server-master-1 server-slave-1 server-slave-2 server-srv-1; do \
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
ansible-up: ansible-update-ip-in-stage
	@echo "+ $@"
	cd ./ansible && make run

ansible-update-ip-in-stage:
	@echo "+ $@"
	cd ./terraform/stage && \
	terraform output | grep app_external_ip | awk '{print $$3}' | \
	xargs -I {} echo 'appserver ansible_host={}' | \
	xargs -I {} sed -i 's/appserver ansible_host=.*/{}/g' \
	./../../ansible/environments/stage/inventory

	cd ./terraform/stage && \
	terraform output | grep app_internal_ip | awk '{print $$3}' | \
	xargs -I {} echo 'App internal IP {} not be used'

	cd ./terraform/stage && \
	terraform output | grep db_external_ip | awk '{print $$3}' | \
	xargs -I {} echo 'dbserver ansible_host={}' | \
	xargs -I {} sed -i 's/dbserver ansible_host=.*/{}/g' \
	./../../ansible/environments/stage/inventory

	cd ./terraform/stage && \
	terraform output | grep db_internal_ip | awk '{print $$3}' | \
	xargs -I {} echo 'db_host: {}' | \
	xargs -I {} sed -i 's/db_host: .*/{}/g' \
	./../../ansible/environments/stage/group_vars/app
