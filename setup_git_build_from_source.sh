. ./check_distro.sh 
ok=$1
name=$2
http=$3
repo=$4
tag=$5
preqs=$6
bcommands=$7
uinstall=$8
clean=$9
install=$10

if [ -z $1 ]; then
    read -p "This will make a directory specifically for keeping source files if it does not exist yet. Specify a directory with global variable GIT_SOURCE_BUILDS (Default: ~/Applications). OK? [Y/n]: " ok
fi

if ! [[ -z $ok || "y" == $ok ]]; then
    return
fi

if [ -z $GIT_SOURCE_BUILDS ]; then
    dir=~/Applications
else
    dir=$GIT_SOURCE_BUILDS
fi
if [ -z $2 ]; then
    while [ -z $name ]; do
        read -p "Give up a name for the github build: " name
    done;
fi

if [ -z $3 ]; then   
    read -p "Give up a domain reference (Default: https://github.com): " http
fi
if [ -z $http ]; then
    http="https://github.com"
fi
if [ -z $4 ]; then
    while [ -z $repo ]; do 
        read -p "Give up a repo (For example: neovim/neovim): " repo
    done;
fi

if [ -z $5 ]; then
    while [ -z $tag ]; do 
        read -p "Give up the github build tag (For example: releases/stable): " tag
    done;
fi

if [ -z "$6" ]; then
    prereqs=""
    echo "Give up the installation preqs (For example: sudo apt install make cmake)"
    echo "'q' and Enter to quit: "
    while ! [ "$preqs" == "q" ]; do 
        read -e preqs
        if ! [ "$preqs" == "q" ]; then
            prereqs+="$preqs;"
        fi
    done;
fi

if [ -z "$7" ]; then
    bcommands=""
    echo "Give up build commands (Default: \"make && sudo make install\"): " 
    echo "'q' and Enter to quit: "
    while ! [ "$bcmd" == "q" ]; do
    read -e bcmd
        if ! [ "$bcmd" == "q" ]; then
            bcommands+="$bcmd;"
        fi
    done;
fi
if [ -z "$bcommands" ]; then
    bcommands="make && sudo make install"
fi

if [ -z "$8" ]; then
    uinstall=""
    echo  "Uninstall command? Called from source folder before rebuilding (Default: \"sudo make uninstall\"): " 
    echo "'q' and Enter to quit: "
    while ! [ "$unstll" == "q" ]; do
    read -e unstll
        if ! [ "$unstll" == "q" ]; then
            uinstall+="$unstll;"
        fi
    done;
fi
if [ -z "$uinstall" ]; then
    uinstall="sudo make uninstall"
fi

if [ -z "$9" ]; then
    clean=""
    echo  "Clean command? Called from source folder (Default: \"sudo rm -rf build/\"): " 
    echo "'q' and Enter to quit: "
    while ! [ "$cln" == "q" ]; do
    read -e cln
        if ! [ "$cln" == "q" ]; then
            clean+="$cln;"
        fi
    done;
fi
if [ -z "$clean" ]; then
    clean="sudo rm -rf build/"
fi

if [ ! -d $dir ]; then
    mkdir -p $dir
fi
(cd $dir && mkdir $name)
touch $dir/$name/git_install.sh

full_url="$http/$repo/$tag"

curr_commit=$(curl -sL $full_url | grep "/$repo/commit" | perl -pe 's|.*/'$repo'/commit/(.*?)".*|\1|')

file=$dir/$name/git_install.sh

echo "domain=$http" > $file
echo "repo=$repo" >> $file
echo "tag=$tag" >> $file
echo "commit=$curr_commit" >> $file
echo "prereqs=\"$preqs\"" >> $file 
echo "build=\"$bcommands\"" >> $file
echo "uninstall=\"$uinstall\"" >> $file
echo "clean=\"$clean\"" >> $file

if [ -z "$10" ]; then
    read -p "Run now? [Y/n]: " install
fi
if [[ -z $install || "y" == $install ]]; then
    (
    cd $dir/$name
    . ./git_install.sh
    eval "$prereqs"
    git clone $domain/$repo.git ./build
    cd ./build
    git checkout $commit
    eval "$build"
    eval "$clean"
    echo "Done!"
    )
fi
