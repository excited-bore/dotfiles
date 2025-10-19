TOP=$(git rev-parse --show-toplevel)

file=$TOP/rlwrap-scripts/reade
file1=$TOP/rlwrap-scripts/readyn
file2=$TOP/rlwrap-scripts/yes-edit-no
if ! test -f $file; then
    tmp=$(mktemp) && wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/rlwrap-scripts/reade > $tmp
    tmp1=$(mktemp) && wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/rlwrap-scripts/readyn > $tmp1
    tmp2=$(mktemp) && wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/rlwrap-scripts/yes-edit-no > $tmp2
    file=$tmp
    file1=$tmp1
    file2=$tmp2
fi


echo "Next operation will install $(tput setaf 2)reade$(tput sgr0),$(tput setaf 2) readyn$(tput sgr0) and $(tput setaf 2)yes-edit-no$(tput sgr0) inside $(tput bold)$HOME/.aliases.d/$(tput sgr0)"

cp -t ~/.aliases.d/ $file $file1 $file2 
