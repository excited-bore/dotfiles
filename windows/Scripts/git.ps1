### GIT ####

if ((Get-Command wget -errorAction SilentlyContinue) -and (Get-Command jq -errorAction SilentlyContinue)){
        function Get-Latest-Releases-Github(){
        if (0 -eq $args.count){
            $gtb_link = Read-Host 'What is your username?' 
        }else{
            $gtb_link = $args[0]
        }
        
        if ( -not ($gtb_link -cmatch 'https://github.com')){
            Write-Host "Not a valid github link"
            return 
        }
         
        $new_url = $gtb_link -replace 'https://github.com', 'https://api.github.com/repos'
        $new_url = $new_url + "/releases/latest"
        
        $ltstv = $(curl -sL "$new_url" | jq -r ".assets" | findstr -i 'name' )
        $ltstv = ($ltstv -split ':')[1].Trim().Trim('"', ',')
        
        $versn = $(curl -sL "$new_url" | jq -r '.tag_name')
        $link = "$gtb_link/releases/download/$versn/" 

        if ($null -eq $ltstv){
            Write-Host -ForegroundColor Red "No releases found."
            return  
        }

        if (Get-Command fzf -errorAction SilentlyContinue){
            $res = "$(echo "$ltstv" | fzf --multi --reverse --height 50%)"
        }else{
           Write-Host "Files: "
           Write-Host -ForegroundColor Cyan "$ltstv"
           #$frst = $ltstv.split()[0]  
           #ltstv="$(echo $ltstv | sed "s/\<$frst\> //g")" 
           $res = Read-Host "Which one?" 
        }
        if ( -not ($null -eq $res)){
            if (!($dir = Read-Host "Value [$env:USERPROFILE\Downloads]")) { $dir = "$env:USERPROFILE\Downloads" }
            Invoke-WebRequest "$link$res" -OutFile $dir
        }
    }

}

function columns(){ git column --mode=column }

function git-list-config(){ git config --list }

function git-config-pull-rebase-false(){ git config pull.rebase false }
function git-config-global-pull-rebase-false(){ git config --global pull.rebase false }

function git-config-pull-rebase-true(){ git config pull.rebase true }
function git-config-global-pull-rebase-true(){ git config --global pull.rebase true }

function git-config-global-pull-fastforward-only(){ git config pull.ff only }
function git-config-pull-fastforward-only=(){ git config --global pull.ff only }

function git-safe-force-push(){ git push --force-with-lease }

function git-add-ssh-key() { 
    if ( -not (Test-Path $env:USERPROFILE\.ssh\config -PathType Leaf)){
        mkdir $env:USERPROFILE\.ssh
        touch $env:USERPROFILE\.ssh\config
    }
    $name = Read-Host "Give up name (Default:'id_keytype')"
    $keytype = Read-Host "Give up keytype \(dsa \| ecdsa \| ecdsa-sk \| ed25519 (Default) \| ed25519-sk \| rsa\)" 
    
    if (! $null -eq $keytype){
        $keytype = "ed25519"
    }
    if(! $null -eq $name){
        $name = "id_$keytype"   
    }
    ssh-keygen -t $keytype -f $env:USERPROFILE\.ssh\$name
    Invoke-Expression "ssh-agent -s" 
    ssh-add -v $env:USERPROFILE\.ssh\$name
    echo ""
    cat $env:USERPROFILE\.ssh\$name.pub
    echo "Host github.com" >> $env:USERPROFILE\.ssh\config
    echo "  IdentityFile ~/.ssh/$name" >> $env:USERPROFILE\.ssh\config 
    echo "  User git" >> $env:USERPROFILE\.ssh\config  
}

function git-https-to-ssh(){
    if ($args.count -eq 0){
        Write-Host "You should give up the name of a remote";
        $resp = Read-Host "Do you want me to look for 'origin'? [Y/n]"
        if ((!$resp) -or ($resp == 'y')){
            $gitRm = $(git remote get-url origin)
            $gitRm = $gitRm -replace '.*.com/', 'git@github.com:'
            git remote -v set-url origin $gitRm
            git remote get-url origin        
        }
    }else{
        $gitRm = $(git remote get-url $args[0]) 
        $gitRm = $gitRm -replace '.*.com/', 'git@github.com:'
        git remote -v set-url $args[0] $gitRm
        git remote get-url $args[0]
    }
}

function git-https-to-ssh(){
    if ( $args.count -eq 0 ){
        Write-Host "You should give up the name of a remote";
        $resp = Read-Host "Do you want me to look for 'origin'? [Y/n]"
        if ((! $null -eq $resp) -or ( $resp == 'y' )){
            $gitRm = $(git remote get-url origin)
            $gitRm = $gitRm -replace '.*.com:', 'https://github.com/'
            git remote -v set-url origin $gitRm
            git remote get-url origin        
        }
    }else{
            $gitRm = $(git remote get-url $args[0]) 
            $gitRm = $gitRm -replace '.*.com:', 'https://github.com/'
            git remote -v set-url $args[0] $gitRm
            git remote get-url $args[0]
    }
}

function git-list-remotes(){ git remote -v }

function git-test-conn-github(){ ssh -vT git@github.com }
function git-status(){ git status }
#git-config-using-vars() { git config --global user.email \"$EMAIL\" && git config --global user.name \"$GITNAME\"; }
function git-add-remote-url() { git remote -v add "$args[0]" "$args[1]"; }
#git-add-remote-ssh() { git remote -v add "$1" git@github.com:$GITNAME/"$2.git"; }

function git-reset-hard(){ git reset --hard }
function git-add-all(){ git add -A }
#alias git-commit-all="git commit -a";
    
function git-log-pretty-graph(){ git log --graph --all --pretty=format:\"%x1b[33m%h%x09%x1b[32m%d%x1b[0m%x20%s\" }
function git-log-linerange(){ git log -L }
function git-log-grep(){ git log -S }


function git-blame-linerange(){ git blame -L }
# -w => ignore whitespace
# -C => Detect lines moved or copied in the same commit
# -C -C => Same thing, but specifically the commit when file in question was created
# -C -C -C => All commits
# https://www.youtube.com/watch?v=aolI_Rz0ZqY
function git-blame-full-branch() { git blame -w -C -C -C }


function git-commit() {

    if (git status){

        #if test -f $(git rev-parse --show-toplevel)/.git/hooks/pre-commit; then
        #    sh $(git rev-parse --show-toplevel)/.git/hooks/pre-commit
        #fi

        #local $untraked $amnd $msg

        $amnd = Read-Host "Add all untracked files? [Y/n]"
        if ( $amnd -eq "y" ){
            git add -A
        }

        $amnd = Read-Host "Add to previous commit? [y/N]"
        if ( $amnd -eq "y" ){ 
            git commit --amend
        }
        
        $msg = Read-Host "Give up a commit message"
        if ( ! $null -eq $msg){ 
            git commit -am $msg
        }else{
            git commit -a
        }
        return 
    }else{
        return 
    }
}
 
function git-commit-push-all() {
    if ( ! $null -eq $args[0] ){
        git add -A && git commit -m $args[0] && git push;
    }else{
        git add -A && git commit && git push; 
    }
} 

function git-commit-amend(){ git commit --amend }
function git-list-branches(){ git branch --list -vv }
function git-delete-branch(){ git branch -d - }
function git-switch-branch(){ git checkout - }
function git-switch-branch-and-track-remote(){ git checkout -t - }
function git-create-and-switch-branch(){ git checkout -b - }
function git-push-to-branch(){ git push -u origin }

if (Get-Command fzf.exe -errorAction SilentlyContinue){
    function git-switch-commit(){
        $commit = $(git --no-pager log --oneline --color=always | fzf --ansi --track --no-sort --layout=reverse-list )
        $cleanLine = $commit -replace "`e\[[\d;]*m", ''
        $commitMessage = $cleanLine -split ' ', 2 
        git checkout $commitMessage[1]
    }
}

function git-add-worktree-and-ignore(){
    $path = Read-Host "Give up a (new) worktree path" 
    if ( ! $null -eq $path ){ 
        git worktree add "$path"
        if (! $path[-1] -eq '/'){
            $path = $path + "/"
        }
        if (! (Test-Path -Path ./.gitignore -PathType Leaf)){
            touch .gitignore
        }
        echo "$path" >> .gitignore
    }
}

function git-add-worktree-and-ignore(){
    $path = Read-Host "Give up a (new) worktree path"
    if ( ! $null -eq $path ){
        git worktree add "$path"
    }
        if ( ! $path[-1] -eq "/" ){
            $path = $path + "/"
        }
        if ( ! ( Test-Path -Path ./.gitignore -PathType Leaf)) {
            touch .gitignore
        }
        echo "$path" >> .gitignore
    fi
}

function git-remove-worktree-and-ignore(){
    $wrktree = $(git worktree list -v | Select-Object -Skip 1 | fzf --ansi --track --no-sort --layout=reverse-list)
    $cleanLine = $commit -replace "`e\[[\d;]*m", ''
    $commitMessage = $cleanLine -split ' ', 2 
    $wrktree = "$commitMessage[1]"
    if ( ! ($null -eq "$wrktree")){
        git worktree remove "$wrktree"
        $top = $(git rev-parse --show-toplevel)
        $path =  $wrktree -replace "$top/", ''

        if ( ! ( $path[-1] -eq "/" )){
            $path = $path + "/"
        }
        if ( ! (Test-Path -Path ./.gitignore -errorContinue SilentlyContinue)){
            touch .gitignore
        }
        
        # 1. Remove line containing $path
        $content = Get-Content .gitignore | Where-Object { $_ -notmatch [regex]::Escape($path) }
        
        # 2. Remove empty or whitespace-only lines
        $content = $content | Where-Object { $_.Trim() -ne "" }
       
        # 3. Save updated content
        $content | Set-Content .gitignore
        echo "Worktree "$path" removed!"
    }
}

function git-add-branch() {
    $branch = Read-Host "Give up a new branch name"
    $commit = $(git --no-pager log --oneline --color=always | fzf --ansi --track --no-sort --layout=reverse-list );
    $cleanLine = $commit -replace "`e\[[\d;]*m", ''
    $commitMessage = $cleanLine -split ' ', 2 
    $commit = "$commitMessage[1]"
    
    if ( $branch -and $commit ){
        git checkout -b "$branch" "$commit";
    }
}

function git-backup-branch-and-reset-to-remote() {
    $remote = 'origin'
    $branch = 'master'
    $backp_branch = 1
    $stash = false
    
    if ( $args.Count -gt 0 -and -not (git remote -v | Select-String $args[0])){
        echo "Use a legit remote or add it using 'git-add-remote-ssh' or 'git-add-remote-url'";
    }elseif ( $args.Count -gt 0 ){
        $remote = $args[0]
    }
    echo "Using '"+ $args[0] + "' as remote\n";
    
    if (( $args.Count -gt 1 ) -and ( ! $(git branches --list | Select-String $args[1]))){
        echo "Use a legit branch or add it using 'git-add-branch'";
    }elseif ( $args.Count -gt 1 ){
        $remote = $args[1]
    }
    echo "Using '" + $args[1] + "' as branch\n";
    
    if (( $args.Count -gt 2 ) -and ( ! $args[2] -eq 'true')) {
        $branches = git branch --list | Where-Object { $_ -match '^main.' }
        $branchCount = $branches.Count
        for ($cnt = 0; $cnt -lt $branchCount; $cnt++) {
            $backp_branch += 1;
        }
    }elseif ( $args[2] -eq 'true' ){
        $stash = 'true'
    }

    if (( ! $null -eq $args[0] ) -and ( ! $null -eq $args[1])){
        git checkout $args[1]
        git stash
        git fetch --all
        git branch $args[0]
        git reset --hard $args[1]
        if ( $args[2] -eq 'true' ){
            git stash pop
        }else{
            echo "No uncomitted changes kept. They can be reapplied with 'git stash pop'"; 
        }
    }elseif (( ! $null -eq $args[0] ) -and ($null -eq $args[1])){
        git checkout main;
        git stash;
        git branch $args[2]
        git fetch --all ;
        git reset --hard origin/main ;
        if ( $args[3] -eq 'true' ) {
            git checkout $args[0]
            git stash pop
        }else{    
            echo "No uncomitted changes kept. They can be reapplied with 'git checkout " + $args[0] + "; git stash pop'";
        }
    }else{
        echo "First backup branch, then remote. No remote means 'origin/main'" ; 
    }
}

function git-remote-rename(){ git remote -v rename }
function git-remote-remove(){ git remote -v rm }
function git-remote-set-url(){ git remote -v set-url }

function git-set-default-remote-branch() { 
    if (($null -eq $args[0] ) -and ($null -eq $args[1])){
        git remote set-head origin main;
    }elseif ($null -eq $args[0]){ 
        git remote set-head origin $args[1]
    }else{
        git remote set-head $args[0] $args[1]
    }
}

function git-remote-get-default-branch() { 
    if ($null -eq $args[0] ){ 
        git remote set-head origin -a;
    }else{ 
        git remote set-head $args[0] -a;
    }
}
