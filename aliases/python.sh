# python virtual env
#python3 -m venv python3
#source venv/bin/activate

python_install_user(){
    python $@ install --user;
}
alias python-twine-install="if type twine &> /dev/null; then pipx install twine; fi"
alias python-twine-upload_test="pipx install build && python3 -m build && twine check dist/* && twine upload --repository testpypi dist/* && rm dist/* && echo 'Uploaded to https://test.pypi.org/'"
alias python-twine-upload="pipx install build && python3 -m build && twine check dist/* && twine upload dist/* && rm dist/* && echo 'Uploaded to https://pypi.org/' "
