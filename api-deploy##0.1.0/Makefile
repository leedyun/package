.PHONY: all
all: shell

setup:
dockerTag := "localtest-$(shell date +%s)"

shell: build
	@docker run --rm -it ${dockerTag} /bin/sh

build:
	@docker build -f Dockerfile --build-arg VP=${VP} -t ${dockerTag} .

run: build
	@docker run -e VP=${VP} --rm --name ${dockerTag} -t ${dockerTag} ./bin/${command}

run_interactive: build
	@docker run -e VP=${VP} --rm --name ${dockerTag} -it ${dockerTag} ./bin/${command}

test: build
	docker run --rm --name ${dockerTag} -t ${dockerTag} rake

apply_restrictions:
	make run command=apply_restrictions

ruby:
	make run_interactive command=api_deploy

ldap:
	make run_interactive command=ldap

bb:
	make run_interactive command=bitbucket

get_all_repo_sizes:
	make run_interactive command=get_all_repo_sizes

edit_config_vault:
	ansible-vault edit --vault-password-file=.vault_pass.py config/vault
