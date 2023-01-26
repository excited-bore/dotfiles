#Git stuff
alias git_list_remotes="git remote -v"

function git_config() { git config --global user.email $EMAIL && git config --global user.name $NAME; }
function git_test_conn_github() { ssh -vT git@github.com; }
function git_add_remote_url() { git remote -v add "$1" "$2"; }
function git_add_remote_ssh() { git remote -v add "$1" git@github.com:$GITNAME/"$2.git"; }

function git_status() { git status; }
function git_commit_all() { 
    if [ ! -z "$1" ]; then 
        git commit -am "$1"; 
    else
        git commit -a ;
    fi; }

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
