

CD = cd packer/
# pemはあらかじめ用意しておき、awsのキーペアと同じ物を使用する
PACKER_KEY = customKey.pem
REGION = ap-northeast-1

init-vagrant:
	vagrant halt && vagrant destroy -f && vagrant up --provision && vagrant sandbox on

create-ami:
	@${CD} && \
		PACKER_LOG=1 \
		packer build --force \
		-var-file=local-variables.json \
		-var-file=role-base-variables.json \
		-var 'aws_key_file=$(CURDIR)/${PACKER_KEY}' \
		ami-template-local.json

test-local:
	@${CD} && \
		PACKER_LOG=1 \
		packer build -var-file=local-variables.json \
		-var-file=role-base-variables.json \
		-var 'ssh_key=$(CURDIR)/.vagrant/machines/default/virtualbox/private_key' \
		ami-template-local.json && \
		vagrant sandbox rollback
