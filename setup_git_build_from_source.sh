read -p "This will make a directory specifically for keeping source files if it does not exist yet. Specify a directory with global variable GIT_SOURCE_BUILDS (Default: ~/Applications). OK? [Y/n]: " ok

if ! [[ -z $ok || "y" == $ok ]]; then
    exit 1
fi

if [ -z $GIT_SOURCE_BUILDS ]; then
    dir=~/Applications
else
    dir=$GIT_SOURCE_BUILDS
fi

if [ ! -d $dir ]; then
    mkdir -p $dir
fi

read -p "Give up a name for the github build: " name
if [ -z $name ]; then
    echo "Give up a non empty name"
    exit 1
fi

(cd $dir && mkdir $name)
touch $dir/$name/git_install.sh
    
read -p "Give up a domain reference (Default: https://github.com): " http
if [ -z $http ]; then
    http="https://github.com"
fi

while [ -z $repo ]; do 
    read -p "Give up a repo (For example: neovim/neovim): " repo
done;

while [ -z $tag ]; do 
    read -p "Give up the github build tag (For example: releases/stable): " tag
done;

full_url="$http/$repo/$tag"

curr_commit=$(curl -sL $full_url | grep "/$repo/commit" | perl -pe 's|.*/'$repo'/commit/(.*?)".*|\1|')

file=$dir/$name/git_install.sh

read -p -r "Give up build commands (Default: \"make && sudo make install\"): " bcommands
if [ -z "$bcommands" ]; then
    bcommands="make && sudo make install"
fi

read -p -r "Uninstall command? Called before rebuilding (Default: \"sudo make uninstall\"): " uinstall
if [ -z "$uinstall" ]; then
    uinstall="sudo make uninstall"
fi

echo "remote=$http" > $file
echo "repo=$repo" >> $file
echo "tag=$tag" >> $file
echo "commit=$curr_commit" >> $file
echo "build=$bcommands" >> $file
echo "uninstall=$uinstall" >> $file

