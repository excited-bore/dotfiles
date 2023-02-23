if [ -z $GIT_SOURCE_BUILDS ]; then
    dir=~/Applications
else
    dir=$GIT_SOURCE_BUILDS
fi

if [ ! -d $dir ]; then
    printf "Make sure to run setup_git_build_from_source.sh first"
    return
fi 

for d in $dir/*; do
    if [ -d $d ] && [ -f $d/git_install.sh ]; then
        (
        cd $d;
        . ./git_install.sh
        curr_commit=$(curl -sL $domain/$repo/$tag | grep "/$repo/commit" | perl -pe 's|.*/'$repo'/commit/(.*?)".*|\1|')
        if [ ! $commit == $curr_commit ]; then
            echo "$d needs updating. Will be rebuild"
            perl -i -pe '4,s|commit=.*|commit='$curr_commit'|' ./git_install.sh
            cd $name/build
            eval "$uninstall"
            git pull $domain/$repo.git HEAD
            git checkout $commit
            eval "$build"
            eval "$clean"
            cd ..
        else
            echo "$d is up-to-date"
        fi
        )                           
    fi
done
