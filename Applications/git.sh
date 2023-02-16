. ~/.bash_aliases.d/bash.sh
#Git stuff

function git_ssh_key_and_add_to_agent() { 
    if [ ! -f ~/.ssh/config ]; then
        touch ~/.ssh/config;
        echo "Host github.com" > ~/.ssh/config;
    elif ! grep -q github.com ~/.ssh/config; then 
        echo "Host github.com" > ~/.ssh/config;
    fi
    (cd ~/.ssh/ && read -p "Give up name: " name &&
    echo ~/.ssh/$name | ssh-keygen -t ed25519 &&
    echo "  IdentityFile ~/.ssh/$name" >> ~/.ssh/config &&
    echo "  User git" >> ~/.ssh/config && eval $(ssh-agent -s) &&
    ssh-add -vH ~/.ssh/known_hosts ~/.ssh/"$name" &&
    cat ~/.ssh/$name.pub); 
}

function git_remote_https_to_ssh(){
    if [ -z $1 ]; then
        echo "You should give up the name of a remote";
        read -p "Do you want me to look for 'origin'? [Y/n]" resp
        if [ -z $resp ]; then
            gitRm=$(git remote get-url origin | sed 's,https://github.com/,git@github.com:,g'); git remote -v set-url origin $gitRm;
            git remote get-url origin;
        fi        
    else
            gitRm=$(git remote get-url $1 | sed 's,https://github.com/,git@github.com:,g'); git remote -v set-url origin $gitRm;
            git remote get-url $1;
    fi
}

function git_remote_ssh_to_https(){
    if [ -z $1 ]; then
        echo "You should give up the name of a remote";
        read -p "Do you want me to look for 'origin'? [Y/n]" resp
        if [ -z $resp ]; then
            gitRm=$(git remote get-url origin | sed 's,git@github.com:,https://github.com/,g'); git remote -v set-url origin $gitRm;
            git remote get-url origin;
        fi        
    else
        gitRm=$(git remote get-url $1 | sed 's,git@github.com:,https://github.com/,g'); git remote -v set-url origin $gitRm;
        git remote get-url $1;
    fi
}

alias git_list_remotes="git remote -v"
git_test_conn_github() { ssh -vT git@github.com; }
git_status() { git status; }
git_config_using_vars() { git config --global user.email $EMAIL && git config --global user.name $NAME; }
git_add_remote_url() { git remote -v add "$1" "$2"; }
git_add_remote_ssh() { git remote -v add "$1" git@github.com:$GITNAME/"$2.git"; }

alias git_add_all="git add -A"

function git_commit_all() { 
    if [ ! -z "$1" ]; then 
        git commit -am "$1"; 
    else
        git commit -a ;
    fi
}

function git_add_commit_all(){
    if [ ! -z "$1" ]; then
        git add -A && git commit -m "$1";
    else
        git add -A && git commit;
    fi
}
 
function git_add_commit_push_all(){
    if [ ! -z "$1" ]; then
        git add -A && git commit -m "$1" && git push;
    else
        git add -A && git commit && git push; 
    fi
} 

alias git_commit_using_last="git commit --amend"
alias git_list_branches="git branch --list"

#https://stackoverflow.com/questions/1125968/how-do-i-force-git-pull-to-overwrite-local-files
function git_backup_branch_and_reset_to_remote() {
    remote=origin;
    branch=master;
    backp_branch=1;
    stash=false;
    
    if [ ! -z "$1" ] && [[ ! $(gitListRemotes | grep -q $1) ]]; then
        echo "Use a legit remote or add it using 'git_add_remote_ssh' or 'git_add_remote_url'";
    elif [ ! -z "$1" ];then
        remote=$1;
    fi
    echo "Using '$1' as remote\n";
    
    if [ ! -z "$2" ] && [[ ! $(gitListBranches | grep -q $2) ]]; then
        echo "Use a legit branch or add it using 'git_add_branch'";
    elif [ ! -z "$2" ];then
        remote=$2;
    fi
    echo "Using '$2' as branch\n";
    
    if [ ! -z "$3" ] && [ ! "$3" = true ]; then
        for cnt in $(git branch --list | grep --regex 'main.' | wc -l) ; do
       $backp_branch+=1;
    done

    elif [ "$3" = true ];then
        stash=true;
    fi

    if [ ! -z "$1" ] && [ ! -z "$2" ]; then
        git checkout "$2";
        git stash ;
        git fetch --all ;
        git branch "$1" ;
        git reset --hard "$2" ;
        if [ "$3" = true ]; then
            git stash pop;
        else
            echo "No uncomitted changes kept. They can be reapplied with 'git stash pop'"; 
        fi
    elif [ ! -z "$1" ] && [ -z "$2"]; then
        git checkout main;
        git stash;
        git branch "$3" ;
        git fetch --all ;
        git reset --hard origin/main ;
        if [ "$4" = true ]; then
            git checkout "$1";
            git stash pop;
        else    
            echo "No uncomitted changes kept. They can be reapplied with 'git checkout $1 ; git stash pop'";
        fi
    else
        echo "First backup branch, then remote. No remote means 'origin/main'" ;
    fi   
}
alias git_rename_remote="git remote -v rename"
alias git_remove_remote="git remote -v rm"
alias git_switch_branch="git checkout"

function git_set_default_remote_branch() { 
    if [ -z "$1" ] && [ -z "$2" ]; then
        git remote set-head origin main;
    elif [ -z "$1" ]; then
        git remote set-head origin "$2";
    else
        git remote set-head "$1" "$2";
    fi
}
function git_remote_get_default_branch() { 
    if [ -z "$1" ]; then
        git remote set-head origin -a;
    else 
        git remote set-head "$1" -a;
    fi
}
