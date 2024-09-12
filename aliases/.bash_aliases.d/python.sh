#python_install_user(){
#    python $@ install --user;
#}

#build='python -m build'
#if type python-build &> /dev/null; then
#    build='python-build'
#fi

#alias python-twine-install="if ! type twine &> /dev/null; then pipx install twine; fi; if type build &> /dev/null; then pipx install build; fi"
alias python-twine-upload-test="if type deactivate &> /dev/null; then deactivate; fi; eval $build && twine check dist/* && twine upload --repository testpypi dist/* && echo ''; rm dist/*"
alias python-twine-upload="if type deactivate &> /dev/null; then deactivate; fi; eval $build && twine check dist/* && twine upload dist/* && echo ''; rm dist/*"
alias python-venv="python3 -m venv venv; source venv/bin/activate"
alias python-activate-venv="source venv/bin/activate"
alias python-deactivate-venv="deactivate"

alias pip-install-project="pip install ."
alias pip-clear-cache-all="pip cache purge"
alias pip-install-test="pip install -i https://test.pypi.org/simple/ "
alias pip-freeze-version="pip freeze"


alias python-pip-install-project="pip install ."
alias python-pip-clear-cache-all="pip cache purge"
alias python-pip-install-test="pip install -i https://test.pypi.org/simple/ "

