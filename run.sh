
# TODO: read args for more ansible vars
# Expect env vars: aws_region, aws_RO_accounts, image_name, namespace

export ANSIBLE_ROLES_PATH=$(pwd)/roles:/etc/ansible/roles
export python=$(which python)
if [ -n "${aws_region}" ]; then
  export AWS_DEFAULT_REGION=${aws_region}
  arg_region="--extra-vars aws_region=${aws_region}"
fi
if [ -n "${aws_RO_accounts}" ]; then
  accounts_quoted="\"${aws_RO_accounts//,/\",\"}\""
  arg_accounts="--extra-vars '{\"aws_RO_accounts\":[${accounts_quoted}]}'"
  #arg_accounts="--extra-vars='{\"aws_RO_accounts\":[${aws_RO_accounts}]}'"
fi
if [ -n "${image_name}" ]; then
  arg_image="--extra-vars image_name=${image_name}"
fi
if [ -n "${namespace}" ]; then
  arg_namespace="--extra-vars namespace=${namespace}"
fi
accounts_quoted="\"${aws_RO_accounts//,/\",\"}\""
json="'{\"aws_region\":\"${aws_region}\",\"image_name\":\"${image_name}\",\"namespace\":\"${namespace}\",\"aws_RO_accounts\":[${accounts_quoted}]}'"
env | sort | grep -v ^LESS_TERMCAP

echo -e "\nInstall: pip modules..."
pip install -r requirements.txt

echo -e "\nVersions"
ansible --version
docker --version

echo -e "\nInstall: Ansible roles..."
ansible-galaxy install -f -r requirements.yml

echo -e "\nTest: syntax"
ansible-playbook -i inventory playbook.yml --syntax-check --list-tasks
echo -e "\nTest: Lint"
ansible-lint -x ANSIBLE0012,ANSIBLE0013 playbook.yml

echo -e "\nRun: playbook"
echo "CMD: ansible-playbook -i inventory playbook.yml --extra-vars ansible_python_interpreter=${python} -vvvv \
  --extra-vars ${json}"
#  ${arg_region} ${arg_image} ${arg_namespace} ${arg_accounts}"
ansible-playbook -i inventory playbook.yml --extra-vars ansible_python_interpreter=${python} -vvvv \
  --extra-vars=${json}
#  ${arg_region} ${arg_image} ${arg_namespace} ${arg_accounts}
