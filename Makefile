.DEFAULT_GOAL := all
.PHONY: clean up-detach init show-members ui token

export VAULT_ADDR := http://localhost:8200
export VAULT_TOKEN := $(shell cat docker-compose/scripts/vault.json | jq -r '.root_token')

all: clean up-detach init

up-detach:
	cd docker-compose \
	  && docker-compose up --detach --remove-orphans

init:
	cd docker-compose/scripts \
	  && ./init.sh

clean:
	cd docker-compose \
	&& docker-compose down --volumes \
	&& rm -f ./scripts/vault.json

show-members:
	vault operator raft list-peers

logs:
	cd docker-compose \
    && docker-compose logs -f

ui:
	open http://localhost:8200

ldap-ui:
	open http://localhost:8081

restart-agent:
	docker restart vault-agent

.PHONY: tf-fmt
tf-fmt:
	terraform -chdir=./terraform fmt

.PHONY: tf-plan
tf-plan:
	terraform -chdir=./terraform init -upgrade
	terraform -chdir=./terraform plan

.PHONY: tf-apply
tf-apply:
	terraform -chdir=./terraform fmt
	terraform -chdir=./terraform init -upgrade
	terraform -chdir=./terraform apply --auto-approve

.PHONY: tf-output
tf-output:
	terraform -chdir=./terraform output

.PHONY: tf-destroy
tf-destroy:
	terraform -chdir=./terraform init -upgrade
	terraform -chdir=./terraform destroy --auto-approve