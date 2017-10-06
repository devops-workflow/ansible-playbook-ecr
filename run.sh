
# TODO: read args for more ansible vars

export ANSIBLE_ROLES_PATH=$(pwd)/roles:/etc/ansible/roles
export python=$(which python)

#env | sort | grep -v ^LESS_TERMCAP

echo "Install: pip modules..."
pip install -r requirements.txt
ansible --version

echo "Install: Ansible roles..."
ansible-galaxy install -f -r requirements.yml

echo "Test: syntax"
ansible-playbook -i inventory playbook.yml --syntax-check --list-tasks
echo "Test: Lint"
ansible-lint -x ANSIBLE0012,ANSIBLE0013 playbook.yml

echo "Run test playbook"
ansible-playbook -i inventory playbook.yml --extra-vars ansible_python_interpreter=${python} --extra-vars aws_region=us-west-2 -vvvv
