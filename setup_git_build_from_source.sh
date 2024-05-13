. ./checks/check_system.sh 
ok=$1
name=$2
http=$3
repo=$4
tag=$5
preqs=$6
bcommands=$7
uinstall=$8
clean=$9
install="$10"

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
        tag=""
        tg=""
        httprepo=$http/$repo
        echo "Give up a identifiable release version (For example: v0.8.3, stable)"
        echo "You can make sure that it's valid if you see an associated commit hash"
        echo "Giving up something like 'v0.8' would also work"
        echo "Only last entered tag will get saved. 'q' and Enter to quit. An empty Enter will default to topresult (usually latest, works dynamically): "
        echo "All tags: (-> indicates default)"
        echo -n "-> "
        curl -sL "$httprepo/tags" |  grep "/$repo/releases/tag" | perl -pe 's|.*/'$repo'/releases/tag/(.*?)".*|\1|' | uniq | awk 'NR==1{max=$1;print $0; exit;}' | while read -r i; do echo -n "$i  "; curl -sL "$http/$repo/releases/tag/$i" |  grep "/$repo/commit" | perl -pe 's|.*/'$repo'/commit/(.*?)".*|\1|' | awk 'NR==1{max=$1;print $0; exit;}';  done
        curl -sL "$httprepo/tags" |  grep "/$repo/releases/tag" | perl -pe 's|.*/'$repo'/releases/tag/(.*?)".*|\1|' | uniq |  while read -r i; do echo -n "$i  "; curl -sL "$http/$repo/releases/tag/$i" |  grep "/$repo/commit" | perl -pe 's|.*/'$repo'/commit/(.*?)".*|\1|' | awk 'NR==1{max=$1;print $0; exit;}';  done
     while ! [ "$tg" == "q" ]; do 
        read tg
        if ! [ "$tg" == "q" ]; then
            if ! [ -z "$tg" ]; then
                echo -n "-> "
                curl -sL "$httprepo/tags" |  grep "/$repo/releases/tag/$tg" | perl -pe 's|.*/'$repo'/releases/tag/'$tg'(.*?)".*|'$tg'\1|' | uniq | awk 'NR==1{max=$1;print $0; exit;}' | while read -r i; do echo -n "$i  "; curl -sL "$http/$repo/releases/tag/$i" |  grep "/$repo/commit" | perl -pe 's|.*/'$repo'/commit/(.*?)".*|\1|' |  awk 'NR==1{max=$1;print $0; exit;}';  done
                curl -sL "$httprepo/tags" |  grep "/$repo/releases/tag/$tg" | perl -pe 's|.*/'$repo'/releases/tag/'$tg'(.*?)".*|'$tg'\1|' | uniq | while read -r i; do echo -n "$i  "; curl -sL "$http/$repo/releases/tag/$i" |  grep "/$repo/commit" | perl -pe 's|.*/'$repo'/commit/(.*?)".*|\1|' | awk 'NR==1{max=$1;print $0; exit;}';  done
                tag=$tg
            else
                echo -n "-> "
                curl -sL "$httprepo/tags" |  grep "/$repo/releases/tag" | perl -pe 's|.*/'$repo'/releases/tag/(.*?)".*|\1|' | uniq | sort | while read -r i; do echo -n "$i  "; curl -sL "$http/$repo/releases/tag/$i" |  grep "/$repo/commit" | perl -pe 's|.*/'$repo'/commit/(.*?)".*|\1|' | awk 'NR==1{max=$1;print $0; exit;}';  done
            fi
        fi
    done;
fi

if [ ! -z $tag ]; then
    echo "Will use $tag"
    commit=$(curl -sL "$httprepo/tags" |  grep "/$repo/releases/tag/$tag" | perl -pe 's|.*/'$repo'/releases/tag/'$tag'(.*?)".*|'$tag'\1|' | uniq | awk 'NR==1{max=$1;print $0; exit;}' | while read -r i; do curl -sL "$http/$repo/releases/tag/$i" |  grep "/$repo/commit" | perl -pe 's|.*/'$repo'/commit/(.*?)".*|\1|' | awk 'NR==1{max=$1;print $0; exit;}'; done)
else
    echo "Will look for top of /tags"
    commit=$(curl -sL "$httprepo/tags" |  grep "/$repo/releases/tag" | perl -pe 's|.*/'$repo'/releases/tag/(.*?)".*|\1|' | uniq | awk 'NR==1{max=$1;print $0; exit;}' | while read -r i; do curl -sL "$http/$repo/releases/tag/$i" |  grep "/$repo/commit" | perl -pe 's|.*/'$repo'/commit/(.*?)".*|\1|' | awk 'NR==1{max=$1;print $0; exit;}';  done)
fi

echo $commit

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
    echo  "Clean command? Called from source folder (Default: \"make distclean\"): " 
    echo "'q' and Enter to quit: "
    while ! [ "$cln" == "q" ]; do
    read -e cln
        if ! [ "$cln" == "q" ]; then
            clean+="$cln;"
        fi
    done;
fi
if [ -z "$clean" ]; then
    clean="make distclean"
fi


if [ ! -d $dir ]; then
    mkdir -p $dir
fi
(cd $dir && mkdir $name)
touch $dir/$name/git_install.sh



file=$dir/$name/git_install.sh

echo "name=$name" > $file
echo "domain=$http" >> $file
echo "repo=$repo" >> $file
echo "tag=$tag" >> $file
echo "commit=$commit" >> $file
echo "prereqs=\"$prereqs\"" >> $file 
echo "build=\"$bcommands\"" >> $file
echo "uninstall=\"$uinstall\"" >> $file
echo "clean=\"$clean\"" >> $file

cat $file

if [ ! "$#" -gt 9 ]; then
    read -p "Run now? [Y/n]: " install
fi
if [[ -z $install || "y" == $install || ! -z $10 ]]; then
    (
    cd $dir/$name
    . ./git_install.sh
    eval "$prereqs"
    git clone $domain/$repo.git ./build
    cd ./build
    git checkout $commit
    eval "$clean"
    eval "$build"
    echo "Done!"
    )
fi
