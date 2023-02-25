if [ -z $GIT_SOURCE_BUILDS ]; then
    dir=~/Applications
else
    dir=$GIT_SOURCE_BUILDS
fi

if [ $# -eq 0 ]; then
    while [ -z $dirss ]; do
        read -p "Give up configuration to rebuild (by giving buildname): " dirss
    done;
    for i in $dir/*; do
        if [ -d $i ] && [ -f $i/git_install.sh ]; then
            . $i/git_install.sh
            if [ "$name" == "$dirss" ]; then
                cd $i/build
                eval "$prereqs"
                eval "$uninstall"
                git pull $domain/$repo.git HEAD
                git checkout $commit
                eval "$clean"
                eval "$build"
                cd .. 
            fi
        fi
    done
fi
