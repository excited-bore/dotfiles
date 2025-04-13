### GIT ###                           
if ! type reade &> /dev/null && test -f ~/.bash_aliases.d/00-rlwrap_scripts.sh; then
    source ~/.bash_aliases.d/00-rlwrap_scripts.sh
fi

if type wget &> /dev/null && type jq &> /dev/null; then
    function get-latest-releases-github(){
        if test -z "$@"; then
            reade -Q 'GREEN' -p 'Github link: ' gtb_link
        else
            gtb_link="$@"
        fi
        if ! [[ "$gtb_link" =~ 'https://github.com' ]]; then
            echo "Not a valid github link"
            return 1
        fi
         
        new_url="$(echo "$(echo "$gtb_link" | sed 's|https://github.com|https://api.github.com/repos|g')/releases/latest")" 
        ltstv=$(curl -sL "$new_url" | jq -r ".assets" | grep --color=never "name" | sed 's/"name"://g' | tr '"' ' ' | tr ',' ' ' | sed 's/[[:space:]]//g')
        versn=$(curl -sL "$new_url" | jq -r '.tag_name')
        link="$gtb_link/releases/download/$versn/" 

        if test -z $ltstv; then
            printf "${red}No releases found.${normal}\n"
            return 1 
        fi

        if type fzf &> /dev/null; then
            res="$(echo "$ltstv" | fzf --multi --reverse --height 50%)"
        else
           printf "Files: \n${cyan}$ltstv${normal}\n"
           #frst="$(echo $ltstv | awk '{print $1}')"  
           #ltstv="$(echo $ltstv | sed "s/\<$frst\> //g")" 
           reade -Q 'CYAN' -i "$ltstv" -p "Which one?: " res 
        fi
        
        if ! test -z $res; then
            reade -Q 'GREEN' -i "$HOME/Downloads" -p "Download Folder?: " -e dir
            wget -P $dir "$link$res"
        fi
    }
fi

alias columns="git column --mode=column"

alias git-list-config="git config --list"

alias git-config-pull-rebase-false="git config pull.rebase false"
alias git-config-global-pull-rebase-false="git config --global pull.rebase false"

alias git-config-pull-rebase-true="git config pull.rebase true"
alias git-config-global-pull-rebase-true="git config --global pull.rebase true"

alias git-config-global-pull-fastforward-only="git config pull.ff only"
alias git-config-pull-fastforward-only="git config --global pull.ff only"

alias git-safe-force-push="git push --force-with-lease"


function git-add-ssh-key() { 
    if [ ! -f ~/.ssh/config ]; then
        mkdir ~/.ssh;
        touch ~/.ssh/config;
    fi
    read -p "Give up name (Default:'id_keytype'): " name
    reade -i "dsa ecdsa ecdsa-sk ed25519 ed25519-sk rsa" -p "Give up keytype \(dsa \| ecdsa \| ecdsa-sk \| ed25519 (Default) \| ed25519-sk \| rsa\): " keytype
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

git-https-to-ssh(){
    if [ -z $1 ]; then
        echo "You should give up the name of a remote";
        read -p "Do you want me to look for 'origin'? [Y/n]" resp
        if [ -z $resp ]; then
            gitRm=$(git remote get-url origin | sed 's,.*.com/,git@github.com:,g'); git remote -v set-url origin $gitRm;
            git remote get-url origin;
        fi        
    else
            gitRm=$(git remote get-url $1 | sed 's,.*.com/,git@github.com:,g'); git remote -v set-url $1 $gitRm;
            git remote get-url $1;
    fi
}

git-ssh-to-https(){
    if [ -z $1 ]; then
        echo "You should give up the name of a remote";
        read -p "Do you want me to look for 'origin'? [Y/n]:" resp
        if [[ -z $resp  ||  "y" == $resp ]] ; then
            gitRm=$(git remote get-url origin | sed 's,.*.com:,https://github.com/,g'); git remote -v set-url origin $gitRm;
            git remote get-url origin;
        fi        
    else
        gitRm=$(git remote get-url $1 | sed 's,.*.com:,https://github.com/,g'); git remote -v set-url $1 $gitRm;
        git remote get-url $1;
    fi
}

alias git-list-remotes="git remote -v"

alias git-test-conn-github="ssh -vT git@github.com;"
alias git-status="git status"
#git-config-using-vars() { git config --global user.email \"$EMAIL\" && git config --global user.name \"$GITNAME\"; }
git-add-remote-url() { git remote -v add "$1" "$2"; }
#git-add-remote-ssh() { git remote -v add "$1" git@github.com:$GITNAME/"$2.git"; }

alias git-reset-hard="git reset --hard"
alias git-add-all="git add -A"
#alias git-commit-all="git commit -a";
    
alias git-log-pretty-graph="git log --graph --all --pretty=format:\"%x1b[33m%h%x09%x1b[32m%d%x1b[0m%x20%s\""
alias git-log-linerange="git log -L "
alias git-log-grep="git log -S "


alias git-blame-linerange="git blame -L "
# -w => ignore whitespace
# -C => Detect lines moved or copied in the same commit
# -C -C => Same thing, but specifically the commit when file in question was created
# -C -C -C => All commits
# https://www.youtube.com/watch?v=aolI_Rz0ZqY
alias git-blame-full-branch="git blame -w -C -C -C "


function git-commit() {

    if git status; then

        #if test -f $(git rev-parse --show-toplevel)/.git/hooks/pre-commit; then
        #    sh $(git rev-parse --show-toplevel)/.git/hooks/pre-commit
        #fi

        local untraked amnd msg

        readyn -Y "CYAN" -p "Add all untracked files?" amnd
        if [[ "$amnd" == "y" ]]; then
            git add -A
        fi

        reade -N "CYAN" -n -p "Add to previous commit?" amnd
        if [[ "$amnd" == "y" ]]; then
            git commit --amend
        fi
        
        reade -Q "CYAN" -i '\\\"\\\"' -p "Give up a commit message: " msg
        if ! test -z "${msg}"; then
            git commit -am "${msg}";
        else
            git commit -a;
        fi
        return 0
    else
        return 1
    fi
}
 
function git-commit-push-all() {
    if [ ! -z "$1" ]; then
        git add -A && git commit -m "$1" && git push;
    else
        git add -A && git commit && git push; 
    fi
} 

alias git-commit-amend="git commit --amend"
alias git-list-branches="git branch --list -vv"
alias git-delete-branch="git branch -d - "
alias git-switch-branch="git checkout - "
alias git-switch-branch-and-track-remote="git checkout -t - "
alias git-create-and-switch-branch="git checkout -b - "
alias git-push-to-branch="git push -u origin "

git-switch-commit() {
    commit=$(git --no-pager log --oneline --color=always | nl | fzf --ansi --track --no-sort --layout=reverse-list | awk '{print $2}');
    git checkout "$commit";
}

git-add-worktree-and-ignore(){
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

git-add-worktree-and-ignore(){
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

git-remove-worktree-and-ignore(){
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

git-add-branch() {
    reade -Q "GREEN" -p "Give up a new branch name: " branch
    commit=$(git log --oneline --color=always | nl | fzf --ansi --track --no-sort --layout=reverse-list | awk '{print $2}');
    if [ ! -z "$branch" ]; then
        git checkout -b "$branch" "$commit";
    fi
}

#https://stackoverflow.com/questions/1125968/how-do-i-force-git-pull-to-overwrite-local-files
git-backup-branch-and-reset-to-remote() {
    remote=origin;
    branch=master;
    backp_branch=1;
    stash=false;
    
    if ! test -z "$1" && [[ ! $(git remotes -v | grep -q $1) ]]; then
        echo "Use a legit remote or add it using 'git-add-remote-ssh' or 'git-add-remote-url'";
    elif ! test -z "$1"; then
        remote=$1;
    fi
    echo "Using '$1' as remote\n";
    
    if ! test -z "$2" && [[ ! $(git branch --list | grep -q $2) ]]; then
        echo "Use a legit branch or add it using 'git-add-branch'";
    elif ! test -z "$2"; then
        remote=$2;
    fi
    echo "Using '$2' as branch\n";
    
    if ! test -z "$3" && ! [[ "$3" == true ]]; then
        for cnt in $(git branch --list | grep --regex 'main.' | wc -l) ; do
            $backp_branch+=1;
        done
    elif [[ "$3" == true ]]; then
        stash=true;
    fi

    if ! test -z "$1" && ! test -z "$2"; then
        git checkout "$2";
        git stash ;
        git fetch --all ;
        git branch "$1" ;
        git reset --hard "$2" ;
        if [[ "$3" = true ]]; then
            git stash pop;
        else
            echo "No uncomitted changes kept. They can be reapplied with 'git stash pop'"; 
        fi
    elif ! test -z "$1" && test -z "$2"; then
        git checkout main;
        git stash;
        git branch "$3" ;
        git fetch --all ;
        git reset --hard origin/main ;
        if [[ "$4" == true ]]; then
            git checkout "$1";
            git stash pop;
        else    
            echo "No uncomitted changes kept. They can be reapplied with 'git checkout $1 ; git stash pop'";
        fi
    else
        echo "First backup branch, then remote. No remote means 'origin/main'" ;
    fi   
}
alias git-remote-rename="git remote -v rename"
alias git-remote-remove="git remote -v rm"
alias git-remote-set-url="git remote -v set-url"

function git-set-default-remote-branch() { 
    if test -z "$1"  && test -z "$2"; then
        git remote set-head origin main;
    elif test -z "$1"; then
        git remote set-head origin "$2";
    else
        git remote set-head "$1" "$2";
    fi
}

function git-remote-get-default-branch() { 
    if test -z "$1"; then
        git remote set-head origin -a;
    else 
        git remote set-head "$1" -a;
    fi
}


