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
    
    if (!$keytype){
        $keytype = "ed25519"
    }
    if(!$name){
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
    if ($null -eq $args.count){
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
    if ($null -eq $args.count){
        Write-Host "You should give up the name of a remote";
        $resp = Read-Host "Do you want me to look for 'origin'? [Y/n]"
        if ((!$resp) -or {$resp == 'y'}){
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

