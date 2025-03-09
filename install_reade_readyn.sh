file=rlwrap-scripts/reade
file1=rlwrap-scripts/readyn
file2=rlwrap-scripts/yes-no-edit
if ! test -f $file; then
    tmp=$(mktemp) && curl -o $tmp https://raw.githubusercontent.com/excited-bore/dotfiles/main/rlwrap-scripts/reade
    tmp1=$(mktemp) && curl -o $tmp1 https://raw.githubusercontent.com/excited-bore/dotfiles/main/rlwrap-scripts/readyn
    tmp2=$(mktemp) && curl -o $tmp2 https://raw.githubusercontent.com/excited-bore/dotfiles/main/rlwrap-scripts/yes-no-edit
    file=$tmp
    file1=$tmp1
    file2=$tmp2
fi


echo "Next operation will install $(tput setaf 2)reade$(tput sgr0),$(tput setaf 2) readyn$(tput sgr0) and $(tput setaf 2)yes-no-edit$(tput sgr0) inside $(tput bold)$HOME/.bash_aliases.d/$(tput sgr0)"

cp -t ~/.bash_aliases.d/ $file $file1 $file2 
