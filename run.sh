
# TODO: read args for more ansible vars

export ANSIBLE_ROLES_PATH=$(pwd)/roles:/etc/ansible/roles
export python=$(which python)

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
ansible-playbook -i inventory playbook.yml --extra-vars ansible_python_interpreter=${python} --extra-vars aws_region=us-west-2 -vvvv
