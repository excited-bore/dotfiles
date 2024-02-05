### GIT ###                           
. ~/.bash_aliases.d/rlwrap_scripts.sh

alias git_config_pull_rebase_false="git config pull.rebase false"
alias git_config_global_pull_rebase_false="git config --global pull.rebase false"

alias git_config_pull_rebase_true="git config pull.rebase true"
alias git_config_global_pull_rebase_true="git config --global pull.rebase true"

alias git_config_global_pull_fastforward_only="git config pull.ff only"
alias git_config_pull_fastforward_only="git config --global pull.ff only"

function git_ssh_key_and_add_to_agent() { 
    if [ ! -f ~/.ssh/config ]; then
        mkdir ~/.ssh;
        touch ~/.ssh/config;
    fi
    read -p "Give up name (Default:'id_keytype'): " name
    reade -p "Give up keytype \(dsa \| ecdsa \| ecdsa-sk \| ed25519 (Default) \| ed25519-sk \| rsa\): " "dsa ecdsa ecdsa-sk ed25519 ed25519-sk rsa" keytype
    if [ -z $keytype ]; then
        keytype="ed25519"
    fi
    if [ -z $name ]; then
        name="id_$keytype"   
    fi
    ssh-keygen -t $keytype -f ~/.ssh/$name
    eval $(ssh-agent -s) 
    ssh-add -v ~/.ssh/$name
    echo ""
    cat ~/.ssh/$name.pub
    echo "Host github.com" >> ~/.ssh/config
    echo "  IdentityFile ~/.ssh/$name" >> ~/.ssh/config 
    echo "  User git" >> ~/.ssh/config  
}

git_https_to_ssh(){
    if [ -z $1 ]; then
        echo "You should give up the name of a remote";
        read -p "Do you want me to look for 'origin'? [Y/n]" resp
        if [ -z $resp ]; then
            gitRm=$(git remote get-url origin | sed 's,.*.com/,git@github.com:,g'); git remote -v set-url origin $gitRm;
            git remote get-url origin;
        fi        
    else
            gitRm=$(git remote get-url $1 | sed 's,.*.com/,git@github.com:,g'); git remote -v set-url origin $gitRm;
            git remote get-url $1;
    fi
}

git_ssh_to_https(){
    if [ -z $1 ]; then
        echo "You should give up the name of a remote";
        read -p "Do you want me to look for 'origin'? [Y/n]:" resp
        if [[ -z $resp  ||  "y" == $resp ]] ; then
            gitRm=$(git remote get-url origin | sed 's,.*.com:,https://github.com/,g'); git remote -v set-url origin $gitRm;
            git remote get-url origin;
        fi        
    else
        gitRm=$(git remote get-url $1 | sed 's,.*.com:,https://github.com/,g'); git remote -v set-url origin $gitRm;
        git remote get-url $1;
    fi
}

alias git_list_remotes="git remote -v"

git_test_conn_github() { ssh -vT git@github.com; }
git_status() { git status; }
#git_config_using_vars() { git config --global user.email \"$EMAIL\" && git config --global user.name \"$GITNAME\"; }
git_add_remote_url() { git remote -v add "$1" "$2"; }
git_add_remote_ssh() { git remote -v add "$1" git@github.com:$GITNAME/"$2.git"; }

alias git_reset_to_last_HEAD="git reset --hard"
alias git_add_all="git add -A"
#alias git_commit_all="git commit -a";
    
alias git_log_pretty_graph="git log --graph --all --pretty=format:\"%x1b[33m%h%x09%x1b[32m%d%x1b[0m%x20%s\""


function git_commit() {
    if git status; then
        local amnd msg
        reade -Q "CYAN" -i "n" -p "Add to previous commit? [y/N]: " "y n" amnd
        if [ "$amnd" == "y" ]; then
            git commit --amend
        fi
        
        reade -Q "CYAN" -p "Give up a commit message: " " " msg
        if ! [[ -z "$msg" ]]; then
            git commit -am "$msg";
        else
            git commit -a;
        fi
        unset msg amnd
        return 0
    else
        return 1
    fi
}
 
function git_commit_push_all() {
    if [ ! -z "$1" ]; then
        git add -A && git commit -m "$1" && git push;
    else
        git add -A && git commit && git push; 
    fi
} 

alias git_commit_amend="git commit --amend"
alias git_list_branches="git branch --list -vv"
alias git_delete_branch="git branch -d - "
alias git_switch_branch="git checkout - "
alias git_switch_branch_and_track_remote="git checkout -t - "
alias git_create_and_switch_branch="git checkout -b - "
alias git_push_to_branch="git push -u origin "

git_switch_commit() {
    commit=$(git log --oneline --color=always | nl | fzf --ansi --track --no-sort --layout=reverse-list | awk '{print $2}');
    git checkout "$commit";
}

git_add_worktree_and_ignore(){
    reade -Q "CYAN" -p "Give up a (new) worktree path: " -e path
    if [ ! -z "$path" ]; then
        git worktree add "$path"
        if [ "${path: -1}" != "/" ]; then
            path="$path/"
        fi
        if [ ! -f ./.gitignore ]; then
            touch .gitignore
        fi
        echo "$path" >> .gitignore
    fi
}

git_add_worktree_and_ignore(){
    reade -Q "CYAN" -p "Give up a (new) worktree path: " -e path
    if [ ! -z "$path" ]; then
        git worktree add "$path"
        if [ "${path: -1}" != "/" ]; then
            path="$path/"
        fi
        if [ ! -f ./.gitignore ]; then
            touch .gitignore
        fi
        echo "$path" >> .gitignore
    fi
}

git_remove_worktree_and_ignore(){
    wrktree=$(git worktree list -v | tail -n +2 | nl | fzf --ansi --track --no-sort --layout=reverse-list | awk '{print $2}');
    if [ ! -z "$wrktree" ]; then
        git worktree remove "$wrktree"
        top=$(git rev-parse --show-toplevel)
        path=$(echo $wrktree | sed "s|$top/||" )
        if [ "${path: -1}" != "/" ]; then
            path="$path/"
        fi
        if [ ! -f ./.gitignore ]; then
            touch .gitignore
        fi
        sed -i "s|.*$path.*||" .gitignore
        sed -i -r '/^\s*$/d' .gitignore
        echo "${cyan}Worktree "$path" removed!${normal}"
    fi
}

git_add_branch() {
    reade -Q "GREEN" -p "Give up a new branch name: " branch
    commit=$(git log --oneline --color=always | nl | fzf --ansi --track --no-sort --layout=reverse-list | awk '{print $2}');
    if [ ! -z "$branch" ]; then
        git checkout -b "$branch" "$commit";
    fi
}

#https://stackoverflow.com/questions/1125968/how-do-i-force-git-pull-to-overwrite-local-files
git_backup_branch_and_reset_to_remote() {
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
alias git_remote_rename="git remote -v rename"
alias git_remote_remove="git remote -v rm"
alias git_remote_set_url="git remote -v set-url"

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


