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
        if [ ! -z $tag ]; then
            echo "Will use $tag"
            commit=$(curl -sL "$httprepo/tags" |  grep "/$repo/releases/tag/$tag" | perl -pe 's|.*/'$repo'/releases/tag/'$tag'(.*?)".*|'$tag'\1|' | uniq | awk 'NR==1{max=$1;print $0; exit;}' | while read -r i; do curl -sL "$http/$repo/releases/tag/$i" |  grep "/$repo/commit" | perl -pe 's|.*/'$repo'/commit/(.*?)".*|\1|' | awk 'NR==1{max=$1;print $0; exit;}'; done)
        else
            commit=$(curl -sL "$httprepo/tags" |  grep "/$repo/releases/tag/$tg" | perl -pe 's|.*/'$repo'/releases/tag/'$tg'(.*?)".*|'$tg'\1|' | uniq | awk 'NR==1{max=$1;print $0; exit;}' | while read -r i; do echo -n "$i  "; curl -sL "$http/$repo/releases/tag/$i" |  grep "/$repo/commit" | perl -pe 's|.*/'$repo'/commit/(.*?)".*|\1|' | awk 'NR==1{max=$1;print $0; exit;}';  done)
        fi
        if [ ! $commit == $curr_commit ]; then
            echo "$name needs updating. Will be rebuild"
            eval "$prereqs"
            perl -i -pe '5,s|commit=.*|commit='$curr_commit'|' ./git_install.sh
            cd ./build
            eval "$uninstall"
            git pull $domain/$repo.git HEAD
            git checkout $commit
            eval "$build"
            eval "$clean"
            cd ..
        else
            echo "$name is up-to-date"
        fi
        )                           
    fi
done
