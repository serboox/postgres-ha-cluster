### Postgres High Availability Cluster
This project need for creates you own PostgreSQL cluster

> Selectel modules for terraform took from
https://github.com/selectel/terraform-examples

### Guide
> Что нужно заполнить перед началом работы?

##### Environments

Для работы с terraform и ansible необходимо определить переменные среды. Для этого в корне проекта необходимо создать файл **os-credentials.sh** и заполнить его по аналогии с файлом **os-credentials.sh.example**
``` bash
#!/bin/sh
export OS_AUTH_URL="https://api.selvpc.ru/identity/v3"
export OS_X_TOKEN=<YourSelectelToken> - токен созданный в панели my.selectel
export OS_PROJECT_NAME=<YourProjectName> - имя создаваемого проекта
export OS_USER_DOMAIN_NAME=<YourUserDomainName> - ваш логин в my.selectel
export OS_USERNAME=<YourUserName> - имя пользователя который будет создан в проекте
export OS_PASSWORD=<YourPassword> - пароль этого пользователя
export OS_REGION =<YourRegion> - регион в котором будут созданы инстансы
export OS_AVAILABILITY_ZONE =<YourAvailabilityZone> - зона для инстансов

export RESELL_API_URL='https://api.selectel.ru/vpc/resell/v2'

export TF_VAR_OS_AUTH_URL=$OS_AUTH_URL
export TF_VAR_OS_X_TOKEN=$OS_X_TOKEN
export TF_VAR_OS_PROJECT_NAME=$OS_PROJECT_NAME
export TF_VAR_OS_USER_DOMAIN_NAME=$OS_USER_DOMAIN_NAME
export TF_VAR_OS_USERNAME=$OS_USERNAME
export TF_VAR_OS_PASSWORD=$OS_PASSWORD
export TF_VAR_OS_REGION=$OS_REGION
export TF_VAR_OS_AVAILABILITY_ZONE=$OS_AVAILABILITY_ZONE
```

после чего выполнить команду
``` bash
source os-credentials.sh
```

##### Terraform

Для работы с terraform необходимо определить переменные. Для этого в директории **terraform/selectel-vpc** необходимо создать файл **terraform.tfvars** и заполнить его по аналогии с файлом **terraform.tfvars.example**
``` bash
# OpenStack instances vars

# Имя обязательно должно содержать подстроку 'srv' для корректной работы dynamic inventory
srv_instance_prefix_name = "srv"

# Пока Ansible работает корректно только с 1-м мастером
master_instance_count = 1

# Имя обязательно должно содержать подстроку 'master' для корректной работы dynamic inventory
master_instance_prefix_name = "master"

slave_instance_count = 2

# Имя обязательно должно содержать подстроку 'slave' для корректной работы dynamic inventory
slave_instance_prefix_name = "slave"

instance_vcpus = 1

instance_ram_mb = 1024

instance_root_disk_gb = 10

instance_image_name = "Ubuntu 18.04 LTS 64-bit"

public_key_path = "~/.ssh/id_rsa.pub"
```

после чего можно поднимать кластер, для этого в корне проекта необходимо выполнить
``` bash
make tf-init
make tf-apply
```
> P.S. для разрушения кластера в корне можно выполнить команду *make tf-destroy*

##### Ansible

Для работы с Ansible необходимо задать пользовательские креды. Для этого в директории **ansible/environments/stage** необходимо создать файл **credentials.yml** и заполнить его по аналогии с файлом **credentials.yml.example**

``` yaml
---
credentials:
  users:
    postgres: - имя пользователя Linux и базы данных
      password: "<YouPass>"
    foo: - имя пользователя Linux и базы данных
      password: "<YouPass>"
      groups: sudo
    bar: - имя пользователя Linux и базы данных
      password: "<YouPass>"
```
На основании этих данных Ansible на каждом инстансе создаст Linux и Postgres пользователей имеющих по одной таблице на которую они имеют 'GRANT ALL' привилегии. Имя пользователя соответствует имени базы данных.

Прежде чем приступить к запуску Ansible нужно создать файл **vault.key** в директории **./ansible**, его содержимое может быть абсолютно произвольным, например:
``` text
aijdajhsdh84385709834jusdhfiu473thyhdofhouyvrbvouybhouojjxp8uuhsuibsdfp
```
он нужен для шифрования файла **credentials.yml**. В папке **./ansible** можно выполнять комманды
``` bash
make encrypt - для шифрования файла credentials.yml
make decrypt - для расшифровки файла credentials.yml
make edit - для редактирования файла credentials.yml в консоли без предварительной расшифровки

```
> P.S. перед запуском Ansible credentials.yml должен быть в зашифрованном виде

После того как все готово можно запустить Ansible, выполнив команду в директории **./ansible**
``` bash
make
```
В результате должен быть получен кластер.
