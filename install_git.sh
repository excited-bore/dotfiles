#/bin/bash

echo "$(tput setaf 6)This script uses $(tput setaf 2)rlwrap$(tput setaf 6) and $(tput setaf 2)fzf$(tput sgr0)."

if ! test -f checks/check_all.sh; then
    if type curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        printf "If not downloading/git cloning the scriptfolder, you should at least install 'curl' beforehand when expecting any sort of succesfull result...\n"
        return 1 || exit 1
    fi
else
    . ./checks/check_all.sh
fi

SCRIPT_DIR=$(pwd)


if ! test -f checks/check_envvar.sh; then
    eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_envvar.sh)"
else
    . ./checks/check_envvar.sh
fi

#if ! type fzf &> /dev/null ; then
#   if ! test -f ./install_fzf.sh; then
#        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/install_fzf.sh)"
#    else
#        ./install_fzf.sh
#    fi
#fi

test -z $TMPDIR && TMPDIR=$(mktemp -d)

echo "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Malesuada fames ac turpis egestas sed tempus urna. Maecenas volutpat blandit aliquam etiam erat velit scelerisque in. Cras fermentum odio eu feugiat pretium nibh ipsum consequat. Nam aliquam sem et tortor consequat id. Habitasse platea dictumst vestibulum rhoncus est pellentesque. Pellentesque habitant morbi tristique senectus et netus et malesuada fames. Mattis molestie a iaculis at erat pellentesque adipiscing. Condimentum lacinia quis vel eros donec ac odio. Vitae congue eu consequat ac. Netus et malesuada fames ac. Sed euismod nisi porta lorem mollis aliquam. Rhoncus est pellentesque elit ullamcorper dignissim cras. Aliquet nibh praesent tristique magna sit amet purus. Odio ut sem nulla pharetra diam sit amet nisl. Bibendum est ultricies integer quis auctor elit sed vulputate mi. Viverra ipsum nunc aliquet bibendum enim facilisis gravida neque convallis.

Sociis natoque penatibus et magnis dis parturient montes. Ornare suspendisse sed nisi lacus sed viverra tellus. Eu augue ut lectus arcu bibendum at varius vel. Morbi leo urna molestie at elementum eu facilisis sed. Integer quis auctor elit sed vulputate mi. At varius vel pharetra vel. Ut consequat semper viverra nam libero. Metus vulputate eu scelerisque felis. In hendrerit gravida rutrum quisque non tellus orci. Eget gravida cum sociis natoque penatibus et magnis. Nec tincidunt praesent semper feugiat nibh sed. Id velit ut tortor pretium. Nibh cras pulvinar mattis nunc sed blandit. Augue neque gravida in fermentum et sollicitudin ac orci phasellus. Ut porttitor leo a diam sollicitudin tempor id. Nec feugiat nisl pretium fusce id velit. Amet purus gravida quis blandit turpis cursus in. Blandit libero volutpat sed cras ornare.

Vestibulum sed arcu non odio euismod lacinia. Cursus in hac habitasse platea dictumst quisque sagittis. Augue eget arcu dictum varius duis at consectetur. Eget egestas purus viverra accumsan in nisl nisi scelerisque eu. Turpis tincidunt id aliquet risus feugiat. Ultrices gravida dictum fusce ut placerat orci. Ullamcorper a lacus vestibulum sed arcu non odio euismod. Dictum fusce ut placerat orci nulla pellentesque dignissim enim. Arcu cursus vitae congue mauris rhoncus aenean vel elit scelerisque. Ornare quam viverra orci sagittis. Tincidunt nunc pulvinar sapien et ligula. Malesuada pellentesque elit eget gravida cum sociis. Non nisi est sit amet facilisis magna etiam. Mauris cursus mattis molestie a iaculis at erat. Praesent tristique magna sit amet. Blandit aliquam etiam erat velit scelerisque in. Urna et pharetra pharetra massa massa ultricies mi. Ultricies leo integer malesuada nunc vel risus commodo. Pellentesque adipiscing commodo elit at imperdiet dui accumsan sit amet.

Tortor aliquam nulla facilisi cras fermentum. A arcu cursus vitae congue mauris rhoncus. Ac orci phasellus egestas tellus rutrum tellus. Eget sit amet tellus cras. Ornare lectus sit amet est placerat in egestas erat. Dis parturient montes nascetur ridiculus. Ut eu sem integer vitae. Viverra orci sagittis eu volutpat odio facilisis mauris sit amet. Enim eu turpis egestas pretium aenean pharetra magna ac. Molestie nunc non blandit massa enim. Felis imperdiet proin fermentum leo vel orci porta non. Nibh mauris cursus mattis molestie a iaculis at erat. Elementum nibh tellus molestie nunc non blandit massa enim nec. Fringilla est ullamcorper eget nulla facilisi etiam dignissim diam quis. Lectus magna fringilla urna porttitor. Dictum fusce ut placerat orci nulla pellentesque dignissim enim. Sed id semper risus in. Nascetur ridiculus mus mauris vitae ultricies.

Vitae suscipit tellus mauris a. Sed elementum tempus egestas sed sed. Est placerat in egestas erat imperdiet sed euismod nisi porta. Nulla aliquet porttitor lacus luctus accumsan. Consequat semper viverra nam libero justo laoreet. Ut diam quam nulla porttitor massa id neque aliquam vestibulum. Cursus metus aliquam eleifend mi. Viverra nam libero justo laoreet sit amet. Malesuada fames ac turpis egestas maecenas pharetra convallis posuere morbi. Orci ac auctor augue mauris augue neque gravida. Sed libero enim sed faucibus turpis in eu mi bibendum. Tellus pellentesque eu tincidunt tortor aliquam nulla facilisi cras fermentum. Scelerisque purus semper eget duis at tellus at urna. Pellentesque habitant morbi tristique senectus. In metus vulputate eu scelerisque felis imperdiet proin fermentum leo. Vulputate mi sit amet mauris commodo quis imperdiet massa tincidunt." > $TMPDIR/test1

echo "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce gravida, neque id eleifend hendrerit, ex arcu tincidunt nunc, at ullamcorper turpis arcu at erat. Maecenas dapibus nisi nibh, nec semper lacus luctus ut. Pellentesque nisi sem, malesuada hendrerit fermentum non, fermentum vitae eros. Pellentesque sodales felis massa, sit amet lobortis tellus ultrices in. Curabitur ornare est vel dui maximus fringilla. Vestibulum mattis elit mauris, ac scelerisque velit tincidunt sed. Quisque non ligula quis purus feugiat tempor vitae in risus. Vestibulum fermentum dolor lacus, non porta enim rhoncus feugiat. Fusce et ullamcorper tellus. Duis volutpat, turpis sit amet blandit sollicitudin, erat augue iaculis nisl, at porta nibh mauris eu ex. In ac sem id augue feugiat imperdiet at sit amet magna. Vestibulum fringilla, ante in posuere blandit, mauris quam blandit dui, ut tristique metus ex et nulla. Fusce a mattis est. Vestibulum facilisis nec lacus ornare faucibus. Nunc rhoncus tempor nibh sit amet porta. In hac habitasse platea dictumst.

Ut sollicitudin nulla fringilla libero vulputate, in facilisis risus posuere. Proin fermentum lacinia est sed tempor. Sed convallis nibh sapien, in posuere quam rhoncus in. Etiam aliquet blandit est, a maximus ex. Donec congue lacus in justo luctus euismod. Duis in nunc ac massa gravida efficitur. Mauris gravida quis massa quis gravida. Curabitur suscipit ultricies mi ut posuere. Ut cursus augue tellus, vitae porttitor libero sollicitudin at. Pellentesque malesuada mi non sem ultrices, a malesuada sapien efficitur. Nam euismod, turpis quis eleifend fermentum, felis arcu varius massa, vitae cursus erat tellus ut arcu.



        readyn -Y "CYAN" -p "You selected $diff. Configure?" -c "test -z $(git config --list | grep 'delta')" conf
Donec pharetra vitae nibh ac suscipit. Donec vel lorem augue. Ut vitae leo risus. Suspendisse potenti. Ut eget diam sit amet lacus molestie blandit ut sodales justo. Donec vehicula hendrerit eros. Maecenas a cursus est, quis dictum augue. Proin malesuada lacus in scelerisque convallis. Phasellus non ornare augue, sit amet mollis ex. Etiam eu eros felis. Donec porttitor nulla velit, et egestas odio vehicula et. Sed interdum imperdiet urna, et lobortis sapien finibus ac. Curabitur vitae ipsum vitae nulla imperdiet venenatis. Donec maximus laoreet commodo. Nunc efficitur, eros eu lacinia porta, odio tortor mollis diam, at volutpat ligula augue eu nulla.

Nullam aliquam, lorem eget vehicula congue, lorem tellus commodo justo, vitae vehicula diam sapien in est. Nullam sit amet ligula tempus, pulvinar diam eget, blandit dui. Sed nec euismod tellus, ac laoreet magna. Praesent facilisis dapibus massa sit amet aliquam. Aliquam luctus id erat a convallis. Donec vel quam cursus sem auctor tempus vitae vitae est. Praesent blandit semper lectus, in condimentum eros varius nec. Maecenas scelerisque non magna et commodo. Quisque congue venenatis est. Duis porttitor ornare aliquam. Integer vel auctor tortor. Donec purus quam, molestie et fringilla eu, volutpat sit amet tortor. Nam faucibus, risus vitae dapibus iaculis, nulla leo sollicitudin sem, nec aliquam diam mauris at turpis. Duis iaculis ac turpis et maximus. Sed at quam mauris. " > $TMPDIR/test2

loremIpsum1=$TMPDIR/test1
loremIpsum2=$TMPDIR/test2

function git_hl() {
    if ! test -z "$1"; then
        cmd="$1"
    #else
    #    cmd="git config $global interactive.difffilter"
    fi
    local diffs=""
    if type delta &>/dev/null; then
        diffs=$diffs" delta"
    fi
    if type diff-so-fancy &>/dev/null; then
        diffs=$diffs" diff-so-fancy"
    fi
    if type difft &>/dev/null; then
        diffs=$diffs" difft"
    fi
    if type ydiff &>/dev/null; then
        diffs=$diffs" ydiff"
    fi
    if type riff &>/dev/null; then
        diffs=$diffs" riff"
    fi
    if type diffr &>/dev/null; then
        diffs=$diffs" diffr"
    fi
    if type batdiff &>/dev/null; then
        diffs=$diffs" batdiff"
    fi

    diffp="$(echo $diffs | sed 's/ /\n\t- /g')"  

    printf "${GREEN}Diff highlighting tools:${CYAN}\n\t- $diffp${normal}\n" 

    reade -Q "GREEN" -i "$diffs" -p "Diff filter: " diff
    if test -n "$diff"; then
        local opts=''
        local colorArg='always'
        local side='n'
        local extrn='n'
        if [[ "$diff" == "delta" ]]; then
            opts=' --paging=never'
            readyn -Y "CYAN" -p "You selected $diff. Configure?" conf
            if [[ "y" == "$conf" ]]; then
                local opt1s='' 
                while test -z "$opt1s"; do
                    side='n' 
                    readyn -Y "CYAN" -p "Set syntax theme for delta?" delta1
                    if [[ "$delta1" == 'y' ]]; then
                        theme=$(printf "$(delta --list-syntax-themes | tail -n +1 | awk '{$1="";print;}' | sed 's/ //')" | fzf --reverse --border --border-label="Syntax theme" --preview="delta --syntax-theme={} $TMPDIR/test1 $TMPDIR/test2")
                        opt1s=" --syntax-theme='$theme'"
                    fi

                    readyn -Y "CYAN" -p "Set linenumbers?" delta3
                    if [[ "y" == $delta3 ]]; then
                        git config $global delta.linenumbers true
                        opt1s="$opt1s --line-numbers" 
                    elif [[ "n" == $delta3 ]]; then
                        git config $global delta.linenumbers false
                    fi

                    readyn -Y "CYAN" -p "Set to dark?" delta2
                    if [[ "y" == $delta2 ]]; then
                        git config $global delta.dark true
                        opt1s="$opt1s --dark" 
                    elif [[ "n" == $delta2 ]]; then
                        git config $global delta.dark false
                    fi

                    readyn -n -N 'BLUE' -p "Side-by-side view?" delta3
                    if [[ "y" == $delta3 ]]; then
                        git config $global delta.side-by-side true
                        opt1s="$opt1s --side-by-side" 
                        side='y' 
                    elif [[ "n" == $delta3 ]]; then
                        git config $global delta.side-by-side false
                    fi

                    if ! [[ "$cmd" =~ 'lazygit' ]]; then 
                        readyn -Y "CYAN" -p "Set to navigate? (Move between diff sections using n and N)" delta1
                        if [[ "y" == $delta1 ]]; then
                            git config $global delta.navigate true
                        elif [[ "n" == $delta1 ]]; then
                            git config $global delta.navigate false
                        fi
                    fi

                    readyn -Y "CYAN" -p "Set hyperlinks?" delta1
                    if [[ "y" == $delta1 ]]; then
                        git config $global delta.hyperlinks true
                        opt1s="$opt1s --hyperlinks" 
                    elif [[ "y" == $delta1 ]]; then
                        git config $global delta.hyperlinks false
                    fi
                    eval "delta $opt1s -- $TMPDIR/test1 $TMPDIR/test2"
                    readyn -N "MAGENTA" -n -p "Is this ok? (will retry if no)" dltthme
                    if [[ "$dltthme" == "n" ]]; then
                        opt1s=''
                    fi
                done
                opts="$opts$opt1s" 
                [[ $cmd =~ 'difffilter' ]] && opts=' --paging=never' 
                git config $global --replace-all delta.syntax-theme "$theme"
            fi
        elif [[ "$diff" == "diff-so-fancy" ]]; then
            local diff="diff-so-fancy"
            if [[ "$cmd" =~ 'difffilter' ]]; then
                opts=' --patch'
                readyn -p "You selected $diff. Configure?" difffancy
                if [[ "$difffancy" == "y" ]]; then
                    readyn -p "Should the first block of an empty line be colored. (Default: true)?" diffancy
                    if [[ "y" == $diffancy ]]; then
                        git config --bool $global diff-so-fancy.markEmptyLines true
                    else
                        git config --bool $global diff-so-fancy.markEmptyLines false
                    fi
                    readyn -Y "CYAN" -p "Simplify git header chunks to a more human readable format. (Default: true)" diffancy
                    if [[ "y" == $diffancy ]]; then
                        git config --bool $global diff-so-fancy.changeHunkIndicators true
                    else
                        git config --bool $global diff-so-fancy.changeHunkIndicators false
                    fi
                    readyn -Y "CYAN" -p "Should the pesky + or - at line-start be removed. (Default: true)" diffancy
                    if [[ "y" == $diffancy ]]; then
                        git config --bool $global diff-so-fancy.stripLeadingSymbols true
                    else
                        git config --bool $global diff-so-fancy.stripLeadingSymbols false
                    fi
                    readyn -Y "CYAN" -p "By default, the separator for the file header uses Unicode line-drawing characters. If this is causing output errors on your terminal, set this to false to use ASCII characters instead. (Default: true)" diffancy
                    if [[ "y" == $diffancy ]]; then
                        git config --bool $global diff-so-fancy.useUnicodeRuler true
                    else
                        git config --bool $global diff-so-fancy.useUnicodeRuler false
                    fi
                    reade -Q "CYAN" -i "47 $(seq 1 100)" -p "By default, the separator for the file header spans the full width of the terminal. Use this setting to set the width of the file header manually. (Default: 47): " diffancy
                    # git log's commit header width
                    re='^[0-9]+$'
                    if [[ $diffancy =~ $re ]] ; then
                        git config --global diff-so-fancy.rulerWidth $diffancy
                    fi
                fi
            fi
        elif [[ "$diff" == "riff" ]]; then
            opts=' --no-pager --color=auto' 
            
            reade -Q 'CYAN' -i 'n m a' -p "Ignore changes in amount of whitespace / ignore all whitespace? (Default: none) [N(o)/(a)m(ount)/a(ll)]: " riff1
            if [[ "$riff1" == 'm' ]]; then
                opts=$opts" --ignore-space-change"
            elif [[ "$riff1" == 'a' ]]; then 
                opts=$opts" --ignore-all-space"
            fi

            reade -Q "CYAN" -i 'y n e' -p "How will unchanged line parts be styled? (Default: none) [Y(ellow)/n(one)/e(xperimental)]: " riff1
            if [[ "$riff1" == 'y' ]]; then
                opts=$opts" --unchanged-style=yellow"
            elif [[ "$riff1" == 'e' ]]; then
                opts=$opts" --unchanged-style=experimental"
            fi
        elif [[ "$diff" == "ydiff" ]]; then
            opts=' --color=auto --width={{columnWidth}}'
            colorArg='never' 
            [[ "$cmd" =~ 'lazygit' ]] && opts=$opts" -p cat"  
            readyn -Y 'CYAN' -p "You selected $diff. Configure?" conf
            if [[ "y" == "$conf" ]]; then
                readyn -Y 'CYAN' -p "Enable side-by-side mode?" diffr1
                if [[ "$diffr1" == 'y' ]]; then
                    opts=$opts" --side-by-side"
                    side='y' 
                    readyn -Y "CYAN" -p "Wrap long lines in side-by-side view?" diffr1
                    if [[ "$diffr1" == 'y' ]]; then
                        opts=$opts" --wrap"
                    fi
                fi
            fi
        elif [ "$diff" == "diffr" ]; then
            readyn -Y "CYAN" -p "You selected $diff. Configure?" conf
            if [[ "y" == "$conf" ]]; then
                readyn -Y "CYAN" -p "Set linenumber?" diffr1
                if [[ "$diffr1" == 'y' ]]; then
                    diff="diffr --line-numbers"
                    reade -Q "CYAN" -i 'c a n' -p "Set linenumber style? [C(ompact)/a(ligned)/n]: " diffr1
                    if [[ "$diffr1" == 'compact' ]] || [[ "$diffr1" == 'aligned' ]]; then
                        diff="diffr --line-numbers $diffr1"
                    fi
                fi
            fi
        elif [[ "$diff" == "difft" ]]; then
            readyn -Y "CYAN" -p "You selected $diff(astic). Configure?" conf
            extrn='y' 
            opts=' --color=always'
            if [[ "y" == "$conf" ]]; then
                readyn -Y 'CYAN' -p "Set side-by-side mode? (Default: side-by-side)" diffr1
                if [[ "$diffr1" == 'y' ]]; then
                    printf "${GREEN}\t - ${CYAN}Side-by-side${green}: Display the before file and the after file in two separate columns, with line numbers aligned according to unchanged content. If a change is exclusively additions or exclusively removals, use a single column.
\t - ${CYAN}Side-by-side-show-both${green}: The same as side-by-side, but always uses two columns.
\t - ${CYAN}Inline${green}: A single column display, closer to traditional diff display.\n${normal}"
                    reade -Q 'GREEN' -i 's b i' -p 'Display [S(ide-by-side)/(side-by-side-)b(oth)/i(nline)]: ' disp
                    if [[ $disp == 's' ]]; then
                        opts=$opts" --display=side-by-side"
                        side='y' 
                    elif [[ $disp == 'b' ]]; then
                        opts=$opts" --display=side-by-side-show-both" 
                        side='y' 
                    elif [[ $disp == 'i' ]]; then
                        opts=$opts" --display=inline" 
                    fi
                fi
                readyn -Y 'CYAN' -p "Set context? (Lines before and after changed lines - Default: 3)" diffr1
                if [[ $diffr1 == 'y' ]]; then
                    reade -Q 'GREEN' -i '3 2 1 4 5 6 7 8' -p 'Context: ' cntxt
                    re='^[0-9]+$'
                    if [[ $cntxt =~ $re ]]; then
                        opts="$opts --context=$cntxt" 
                    fi
                fi
                
                readyn -Y 'CYAN' -p "Skip unchanged files when diffing?" diffr3
                if [[ $diffr3 == 'y' ]]; then
                    opts="$opts --skip-unchanged" 
                fi

                readyn -Y 'CYAN' -p "Ignore changed comments when diffing?" diffr2
                if [[ $diffr2 == 'y' ]]; then
                    opts="$opts --ignore-comments" 
                fi

                readyn -n -N 'BLUE' -p "Set background? (Default: dark)" diffr4
                if [[ $diffr4 == 'y' ]]; then
                    reade -Q 'GREEN' -i 'd l' -p 'Background [D(ark)/l(ight)]: ' bac
                    if [[ $bac == 'd' ]]; then
                        opts="$opts --background=dark"
                    elif [[ $bac == 'l' ]]; then 
                        opts="$opts --background=light"
                    fi
                fi

                readyn -n -N 'BLUE' -p "Disable carriage return - '\\\n\\\r' - stripping when diffing files in windows?" diffr6
                if [[ $diffr6 == 'y' ]]; then
                    opts="$opts --strip-cr=off" 
                fi

                readyn -n -N 'BLUE' -p "Disable syntax highlighting?" diffr5
                if [[ $diffr5 == 'y' ]]; then
                    opts="$opts --syntax-highlight=off" 
                fi

            fi
        elif [[ "$diff" == "batdiff" ]]; then
            readyn -Y "CYAN" -p "You selected $diff. Configure?" conf
            opts=" --paging=never"
            if [[ "y" == "$conf" ]]; then
                readyn -n -N "BLUE" -p "Set amount of extra lines above and under changes in codeblocks (Default: 2)?" batdiff1
                if [[ "$batdiff1" == 'y' ]]; then
                    reade -Q 'GREEN' -i "$(seq 2 10)" -p 'Context: ' cntxt 
                    re='^[0-9]+$'
                    if [[ $cntxt =~ $re ]]; then
                        opts=$opts" --diff-context $cntxt" 
                    fi
                fi
                readyn -Y "BLUE" -p "Use ${GREEN}delta${BLUE} config?" diffr1
                if [[ "$diffr1" == 'y' ]]; then
                    diff=$diff" --delta"
                fi
            fi
        fi
    fi

    local sidpanelw='0.333' 
    if [[ $cmd =~ 'lazygit' ]] && [[ "$side" == 'y' ]]; then
        printf "${GREEN}Side-by-side selected. This might take up a bit more space in the diff panel for lazygit.\n${normal}" 
        readyn -p "Set side panel width (left side panels - Default 0.333)" sidepn
        if [[ $sidepn == 'y' ]]; then
            reade -Q 'GREEN' -i "$(echo "$(seq .01 .01 .33)" | tac)" -p 'Side pane width: ' sidepnw 
            re='^[+-]?[0-9]*\.?[0-9]+$'
            if [[ $sidepnw =~ $re ]] ; then
                sidepanelw=$sidepnw
            fi 
        fi
    
    fi

    if ! test -z "$cmd"; then
        if [[ "$cmd" =~ 'difffilter' ]]; then
            diff="$(echo $diff | awk '{print $1;}')" 
            eval "$cmd $diff$opts"
        elif [[ "$cmd" =~ 'lazygit' ]]; then
            if ! test -f ~/.config/lazygit/config.yml; then
                touch ~/.config/lazygit/config.yml 
            fi
            if test -n "$sidepanelw"; then
                if ! grep -q 'sidePanelWidth:'  ~/.config/lazygit/config.yml; then
                    printf "gui:\n sidePanelWidth: $sidepanelw\n" >> ~/.config/lazygit/config.yml 
                else
                    sed -i 's/^[ \t]*sidePanelWidth:*.*/ sidePanelWidth: '"$sidepanelw"'/g' ~/.config/lazygit/config.yml
                fi
            fi

            if ! grep -q 'git:' ~/.config/lazygit/config.yml; then
                #sed -i '1s/^/git:\n paging:\n   colorArg: always\n   pager: '$diff'\n/' ~/.config/lazygit/config.yml 
                if [[ "$extrn" == 'n' ]]; then
                    printf "git:\n paging:\n   useConfig: false\n   colorArg: $colorArg\n   pager: $diff$opts\n" >> ~/.config/lazygit/config.yml 
                else 
                    printf "git:\n paging:\n   externalDiffCommand: $diff$opts\n" >> ~/.config/lazygit/config.yml 
                fi
            elif ! grep -q 'paging:' ~/.config/lazygit/config.yml; then
                if [[ "$extrn" == 'n' ]]; then
                    sed -i 's/\(git:\)/\1\n paging:\n   useConfig: false\n   colorArg: '$colorArg'\n   pager: '"$diff$opts"'\n /g' ~/.config/lazygit/config.yml
                else
                    sed -i 's/\(git:\)/\1\n paging:\n   externalDiffCommand: '$colorArg'\n/g' ~/.config/lazygit/config.yml

                fi
            else
                if [[ "$extrn" == 'n' ]]; then
                    if ! grep -q 'pager:' ~/.config/lazygit/config.yml; then
                        sed -i 's/\(paging:\)/\1\n   useConfig: false\n   colorArg: '$colorArg'\n   pager: '$diff$opts'\n /g' ~/.config/lazygit/config.yml
                    else 
                        sed -i 's/^[ \t]*colorArg:*.*/   colorArg: '"$colorArg"'/g' ~/.config/lazygit/config.yml
                        sed -i 's/^[ \t]*pager:*.*/   pager: '"$diff$opts"'/g' ~/.config/lazygit/config.yml
                    fi
                elif [[ $extrn == 'y' ]]; then
                    if ! grep -q 'externalDiffCommand:'  ~/.config/lazygit/config.yml; then
                        sed -i 's/\(paging:\)/\1\n   externalDiffCommand: '"$diff$opts"'\n/g' ~/.config/lazygit/config.yml
                    else
                        sed -i 's/^[ \t]*externalDiffCommand:*.*/   externalDiffCommand: '"$diff$opts"'\n/g' ~/.config/lazygit/config.yml
                    fi
                fi
            fi
           
            printf "${GREEN}'$HOME/.config/lazygit/config.yml'${normal}\n" 
            cat -b ~/.config/lazygit/config.yml 
            #sed -i 's|pager:.*|pager: '"$diff"'|g' ~/.config/lazygit/config.yml
            #    printf 'paging:\n    pager: '"$diff\n" >> 
                #sed -i 's|#pager|  pager: '"$diff"'|g' ~/.config/lazygit/config.yml
        fi
    fi
    
}

git_pager() {
    local gitpgr cpager pager pagers global regpager colors
    cpager="$1"
    if ! test -z "$2"; then
        global="$2"
    else
        global="--global"
    fi

    readyn -p "Turn off $cpager?" -c "[[ $cpager == 'pager.show' ]]" pipepager1
    if [[ "$pipepager1" == 'y' ]]; then
        git config $global "$cpager" false
    else
        #reade -Q "CYAN" -i "n" -p "Set $cpager to prevent paging? [N/y]: " "n" regpager ;
        #regpager="$(printf "yes\nno\n" | fzf --border --border-label="Set pager instead of output only?" --reverse)"
        #if test "$regpager" == "n"; then

        pagers="cat less more"
        pagersf="cat\nless\nmore\n"
        pager="less"

        if type most &>/dev/null; then
            pagers=$pagers" most"
            pagersf=$pagersf"most\n"
        fi
        if type moar &>/dev/null; then
            pagers=$pagers" moar"
            pagersf=$pagersf"moar\n"
            pager="moar"
        fi
        if type bat &>/dev/null; then
            pagers=$pagers" bat"
            pagersf=$pagersf"bat\n"
        fi
        if type batdiff &>/dev/null; then
            pagers=$pagers" batdiff"
            pagersf=$pagersf"batdiff\n"
            pager="batdiff"
        fi
        if type vimpager &>/dev/null; then
            pagers=$pagers" vimpager"
            pagersf=$pagersf"vimpager\n"
            pager="vimpager"
        fi
        if type nvimpager &>/dev/null; then
            pagers=$pagers" nvimpager"
            pagersf=$pagersf"nvimpager\n"
            pager="nvimpager"
        fi
        if type ydiff &>/dev/null; then
            pagers=$pagers" ydiff"
            pagersf=$pagersf"ydiff\n"
            pager="ydiff"
        fi
        if type diffr &>/dev/null; then
            pagers=$pagers" diffr"
            pagersf=$pagersf"diffr\n"
            pager="diffr"
        fi
        if type riff &>/dev/null; then
            pagers=$pagers" riff"
            pagersf=$pagersf"riff\n"
            pager="riff"
        fi
        if type diff-so-fancy &>/dev/null; then
            pagers=$pagers" diff-so-fancy"
            pagersf=$pagersf"diff-so-fancy\n"
            pager="diff-so-fancy"
        fi
        if type delta &>/dev/null; then
            pagers=$pagers" delta"
            pagersf=$pagersf"delta\n"
            pager="delta"
        fi
    
        printf "${GREEN}Installed tools that could serve as pagers${normal}:\n"
        printf "${CYAN}$pagersf${normal}"

        reade -Q "green" -i "$pagers" -p "Which one used for ${GREEN}$cpager?:${normal} " pager

        if [[ $pager == 'less' ]]; then
            local ln="-R"
            readyn -p "You selected $pager. Quit if one screen?" pager1
            if [[ $pager1 == 'y' ]]; then
                ln=$ln"--quit-if-one-screen"
            fi
            readyn -Y "CYAN" -p "Set linenumbers for pager?" lne
            if [[ "$lne" == 'n' ]]; then
                ln=$ln"-n"
            else
                ln=$ln"-N"
            fi
        elif [[ "$pager" == "moar" ]]; then
            readyn -Y "CYAN" -p "You chose $pager. Quit if on one screen?" pager1
            if [[ $pager1 == 'y' ]]; then
                pager=$pager' --quit-if-one-screen'
            fi
            readyn -Y "CYAN" -p "Set moar's theme / style?" pager1
            if [[ $pager1 == 'y' ]]; then
                local theme
                local styles="abap\nalgol\nalgol_nu\napi\narduino\nautumn\naverage\nbase16-snazzy\nborland\nbw\ncatppuccin-frappe\ncatppuccin-latte\ncatppuccin-macchiato\ncatppuccin-mocha\ncolorful\ncompat\ndoom-one\ndoom-one2\ndracula\nemacs\nfriendly\nfruity\ngithub-dark\ngithub\ngruvbox-light\ngruvbox\nhr_high_contrast\nhrdark\nigor\nlovelace\nmanni\nmodus-operandi\nmodus-vivendi\nmonokai\nmonokailight\nmurphy\nnative\nnord\nonedark\nonesenterprise\nparaiso-dark\nparaiso-light\npastie\nperldoc\npygments\nrainbow_dash\nrose-pine-dawn\nrose-pine-moon\nrose-pine\nrrt\nsolarized-dark\nsolarized-dark256\nsolarized-light\nswapoff\ntango\ntrac\nvim\nvs\nvulcan\nwitchhazel\nxcode-dark\nxcode"
                if type moar &>/dev/null; then
                    while test -z "$style"; do
                        style=$(printf "$styles" | fzf --reverse --border --border-label="Moar style")
                        moar --style "$style" $TMPDIR/test1
                        stty sane && readyn -Y "MAGENTA" -p "Set as style? (Will retry if no)" thme
                        if [[ "$thme" == "n" ]]; then
                            style=''
                        fi
                    done
                else
                    style=$(printf "$styles" | fzf --reverse --border --border-label="Moar style")
                fi
                pager=$pager" $style"
            fi
            readyn -Y "CYAN" -p "Show linenumber?" pager1
            if [[ $pager1 == 'n' ]]; then
                pager=$pager' --no-linenumbers'
            fi
            readyn -Y "CYAN" -p "Wrap long lines?" pager1
            if [[ $pager1 == 'y' ]]; then
                pager=$pager' --wrap'
            fi
        elif [[ "$pager" == "nvimpager" ]] || [[ "$pager" == "vimpager" ]]; then
            echo "You selected $pager."
            colors="blue darkblue default delek desert elflord evening gruvbox habamax industry koehler lunaperch morning murphy pablo peachpuff quiet ron shine slate torte zellner"
            if [[ "$pager" == "vimpager" ]]; then
                colors=$colors" retrobox sorbet wildcharm zaibatsu"
            fi
            pager="$pager"
            readyn -Y "CYAN" -p "Set colorscheme?" pager1
            if [[ "$pager1" == "y" ]]; then
                reade -Y "CYAN" -i "default $colors" -p "Colorscheme: " color
                pager="$pager +'colorscheme $color'"
            fi
        elif [[ "$pager" == "riff" ]]; then
            pager="riff"
            readyn -Y "CYAN" -p "Ignore changes in amount of whitespace?" riff1
            if [[ "$riff1" == 'y' ]]; then
                pager=$pager" -b"
            fi
            readyn -Y "CYAN" -p "No special highlighting for lines that only add content?" riff1
            if test "$riff1" == 'y'; then
                pager=$pager" --no-adds-only-special"
            fi
        elif [[ "$pager" == "diff-so-fancy" ]] || [[ "$pager" == "diffr" ]] || [[ "$pager" == "ydiff" ]] || [[ "$pager" == "delta" ]] || [[ "$pager" == "bat" ]] || [[ "$pager" == "batdiff" ]]; then
            local difffancy
            readyn -p "You selected $pager. Configure?" -c "(! [[ $pager == 'delta' ]] && ! [[ $pager == 'diff-so-fancy' ]]) || test -z '$(git config $global --list --show-origin)'" difffancy
            if [[ "y" == "$difffancy" ]]; then
                if [[ "$pager" == "bat" ]] || [[ "$pager" == "batdiff" ]]; then
                    local opts=""
                    readyn -Y "CYAN" -p "Set styles? (line numbers/grid)" delta2
                    local theme='changes'
                    if [[ "y" == "$delta2" ]]; then
                        while :; do
                            local style=''
                            style=$(printf "full\nauto\nplain\nchanges\nheader\nheader-filename\nheader-filesize\ngrid\nrule\nnumbers\nsnip\n" | fzf --border --border-label="Bat styles")
                            stty sane && reade -Q "MAGENTA" -i "a o n" -p "Add to styles/Only use this style/Dont use? (Will retry if add) [A/o/n]: " dltthme
                            if [[ "$dltthme" == "a" ]]; then
                                theme=$theme","$style
                            elif [[ "$dltthme" == "o" ]]; then
                                theme=$theme","$style
                                break
                            else
                                break
                            fi
                        done
                        opts=$opts" --style='$theme'"
                    fi
                    readyn -Y "CYAN" -p "Set syntax-theme?" delta1
                    if [[ "y" == $delta1 ]]; then
                        local theme=''

                        while test -z "$theme"; do
                            theme=$(bat --list-themes | fzf --border --border-label="Bat syntax themes" --preview="bat --theme={} --color=always $TMPDIR/test1")
                            stty sane && readyn -Y "MAGENTA" -p "Set $theme as syntax theme? (Will retry if no)" dltthme
                            if [[ "$dltthme" == "n" ]]; then
                                theme=''
                            fi
                        done
                        opts=$opts" --theme=$theme"
                    fi

                    readyn -n -N "CYAN" -p "Set to specific language? (Useful if you're using an obscure language that bat can't autodetect)" delta2
                    if [[ "y" == "$delta2" ]]; then

                        local theme=''
                        while test -z "$theme"; do
                            theme=$(bat --list-languages | fzf --border --border-label="Bat coding languages")
                            stty sane && reade -Q "MAGENTA" -i "y n s" -p "Set syntax to specifically use $theme as language? (Will retry if no - s to stop) [Y/n/s]: " dltthme
                            if [[ "$dltthme" == "n" ]]; then
                                theme=''
                            fi
                        done
                        opts=$opts" --language=$theme"
                    fi
                    pager=$pager" $opts"
                elif [[ "$pager" == "delta" ]]; then
                    readyn -Y "CYAN" -p "Set side-by-side view?" delta1
                    if [[ "y" == $delta1 ]]; then
                        git config $global delta.side-by-side true
                    fi

                    readyn -Y "CYAN" -p "Set to navigate? (Move between diff sections using n and N)" delta1
                    if [[ "y" == "$delta1" ]]; then
                        git config $global delta.navigate true
                    fi

                    readyn -Y "CYAN" -p "Set syntax-theme?" delta1
                    if [[ "y" == $delta1 ]]; then
                        local theme=''
                        while test -z "$theme"; do
                            theme=$(printf "$(delta --list-syntax-themes | tail -n +1)" | fzf --reverse --border --border-label="Syntax theme" --preview="delta --syntax-theme={} $TMPDIR/test1 $TMPDIR/test2")
                            theme=$(echo "$theme" | awk '{$1=""; print $0;}')
                            delta --syntax-theme "${theme:1}" $TMPDIR/test1 $TMPDIR/test2
                            stty sane && readyn -N "MAGENTA" -n -p "Set as syntax theme? (Will retry if no)" dltthme
                            if [[ "$dltthme" == "n" ]]; then
                                theme=''
                            fi
                        done
                        git config $global delta.syntax-theme "$theme"
                    fi

                    readyn -Y "CYAN" -p "Set to dark?" delta2
                    if [[ "y" == "$delta2" ]]; then
                        git config $global delta.dark true
                    fi

                    readyn -Y "CYAN" -p "Set linenumbers?" delta3
                    if [[ "y" == "$delta3" ]]; then
                        git config $global delta.linenumbers true
                    fi

                    readyn -Y "CYAN" -p "Set hyperlinks?" delta1
                    if [[ "y" == $delta1 ]]; then
                        git config $global delta.hyperlinks true
                    fi

                elif [[ "$pager" == "diff-so-fancy" ]]; then

                    readyn -Y "CYAN" -p "Should the first block of an empty line be colored. (Default: true)?" diffancy
                    if [[ "y" == $diffancy ]]; then
                        git config --bool $global diff-so-fancy.markEmptyLines true
                    else
                        git config --bool $global diff-so-fancy.markEmptyLines false
                    fi
                    readyn -Y "CYAN" -p "Simplify git header chunks to a more human readable format. (Default: true)" diffancy
                    if [[ "y" == $diffancy ]]; then
                        git config --bool $global diff-so-fancy.changeHunkIndicators true
                    else
                        git config --bool $global diff-so-fancy.changeHunkIndicators false
                    fi
                    readyn -Y "CYAN" -p "Should the pesky + or - at line-start be removed. (Default: true)" diffancy
                    if [[ "y" == $diffancy ]]; then
                        git config --bool $global diff-so-fancy.stripLeadingSymbols true
                    else
                        git config --bool $global diff-so-fancy.stripLeadingSymbols false
                    fi
                    readyn -Y "CYAN" -p "By default, the separator for the file header uses Unicode line-drawing characters. If this is causing output errors on your terminal, set this to false to use ASCII characters instead. (Default: true)" diffancy
                    if [[ "y" == $diffancy ]]; then
                        git config --bool $global diff-so-fancy.useUnicodeRuler true
                    else
                        git config --bool $global diff-so-fancy.useUnicodeRuler false
                    fi
                    reade -Q "CYAN" -i "47 $(seq 1 100)" -p "By default, the separator for the file header spans the full width of the terminal. Use this setting to set the width of the file header manually. (Default: 47):" diffancy
                    # git log's commit header width
                    git config --global diff-so-fancy.rulerWidth $diffancy
                elif [[ "$pager" == "ydiff" ]]; then
                    pager=$pager" --color=auto"
                    readyn -Y "CYAN" -p "Enable side-by-side mode?" diffr1
                    if [[ "$diffr1" == 'y' ]]; then
                        pager=$pager" --side-by-side"
                        readyn -Y "CYAN" -p "Wrap long lines in side-by-side view?" diffr1
                        if [[ "$diffr1" == 'y' ]]; then
                            pager=$pager" --wrap"
                        fi
                    fi
                elif [[ "$pager" == "diffr" ]]; then
                    reade -Y "CYAN" -p "Set linenumber?" diffr1
                    if [[ "$diffr1" == 'y' ]]; then
                        pager="diffr --line-numbers"
                        reade -Q "CYAN" -i "compact aligned n" -p "Set linenumber style? [Compact/aligned/n]: " diffr1
                        if [[ "$diffr1" == 'compact' ]] || [[ "$diffr1" == 'aligned' ]]; then
                            pager="diffr --line-numbers $diffr1"
                        fi
                    fi
                fi
                #prompt="$pager can work/works with a pager. Configure? [Y/n]: "
                #if test $pager == "diff-so-fancy"; then
                #    prompt=""
                #fi

                readyn -Y "CYAN" -p "$pager is a diff tool that allows for a configurable pager. Configure?" pipepager
                if [[ "$pipepager" == 'y' ]]; then
                    readyn -n -N "GREEN" -p "Turn off pager?" pipepager
                    if [[ "$pipepager" == 'n' ]]; then
                        pagers="less more"
                        pagersf="less\nmore\n"
                        pager="less"
                        if type most &>/dev/null; then
                            pagers=$pagers" most"
                            pagersf=$pagersf"most\n"
                        fi
                        if type moar &>/dev/null; then
                            pagers=$pagers" moar"
                            pagersf=$pagersf"moar\n"
                            pager="moar"
                        fi
                        if type vimpager &>/dev/null; then
                            pagers=$pagers" vimpager"
                            pagersf=$pagersf"vimpager\n"
                            pager="vimpager"
                        fi
                        if type nvimpager &>/dev/null; then
                            pagers=$pagers" nvimpager"
                            pagersf=$pagersf"nvimpager\n"
                            pager="nvimpager"
                        fi

                        reade -Q "GREEN" -i "$PAGER $pagers" -p "Pager: " diffancy
                        if [[ $diffancy =~ "less" ]]; then
                            local ln=""
                            readyn -Y "CYAN"-p "Quit if one screen?" lne
                            if [[ "$lne" == 'y' ]]; then
                                ln="--quit-if-one-screen"
                            fi
                            reade -n -N "CYAN" -p "Set linenumbers for pager?" lne
                            if [[ "$lne" == 'n' ]]; then
                                ln=$ln"-n"
                            else
                                ln=$ln"-N"
                            fi
                            if [[ "$pager" == "ydiff" ]]; then
                                git config $global "$cpager" "ydiff --pager=less --pager-options=\"-R $ln\""
                            elif [[ "$pager" == "bat" ]] || [[ "$pager" == "batdiff" ]]; then
                                readyn -Y "CYAN" -p "$pager uses an environment variable BAT_PAGER to set it's pager. Configure and put in $ENVVAR?" pager1
                                if [[ $pager1 == 'y' ]]; then
                                    if grep -q 'BAT_PAGER' $ENVVAR; then
                                        sed -i 's|.export BAT_PAGER=|export BAT_PAGER=|g' $ENVVAR
                                        sed -i "s|export BAT_PAGER=.*|export BAT_PAGER='less -R $ln'|g" $ENVVAR
                                    else
                                        printf "# BAT\nexport BAT_PAGER='less -R $ln'\n" >>$ENVVAR
                                    fi
                                    git config $global "$cpager" "$pager"
                                else
                                    git config $global "$cpager" "$pager --pager='less -R $ln'"
                                fi
                            elif [[ "$pager" == "delta" ]]; then
                                reade -Y "CYAN" -p "Delta uses an environment variable DELTA_PAGER to set it's pager. Configure and put in $ENVVAR?" pager1
                                if [[ $pager1 == 'y' ]]; then
                                    if grep -q 'DELTA_PAGER' $ENVVAR; then
                                        sed -i 's|.export DELTA_PAGER=|export DELTA_PAGER=|g' $ENVVAR
                                        sed -i "s|export DELTA_PAGER=.*|export DELTA_PAGER='less -R $ln'|g" $ENVVAR
                                    else
                                        printf "# DELTA\nexport DELTA_PAGER='less -R $ln'\n" >>$ENVVAR
                                    fi
                                    git config $global "$cpager" "delta"
                                else
                                    git config $global "$cpager" "delta --pager=less $ln"
                                fi
                            else
                                git config $global "$cpager" "$pager | less -RF $ln"
                            fi
                        elif [[ $diffancy =~ "moar" ]]; then
                            local ln=""
                            readyn -Y "CYAN" -p "You selected $diffancy. Show linenumber?" pager1
                            if [[ $pager1 == 'n' ]]; then
                                ln=$ln' --no-linenumbers'
                            fi

                            readyn -Y "CYAN" -p "Quit if one screen?" pager1
                            if [[ $pager1 == 'y' ]]; then
                                ln=$ln' --quit-if-one-screen'
                            fi

                            readyn -n -N "CYAN" -p "Wrap long lines?" pager1
                            if [[ $pager1 == 'y' ]]; then
                                ln=$ln' --wrap'
                            fi

                            if [[ "$pager" == "ydiff" ]]; then
                                git config $global "$cpager" "ydiff --pager=moar --pager-options=\"$ln\""
                            elif [[ "$pager" == "delta" ]]; then
                                readyn -Y "CYAN" -p "Delta uses an environment variable DELTA_PAGER to set it's pager. Configure and put in $ENVVAR?" pager1
                                if [[ $pager1 == 'y' ]]; then
                                    if grep -q 'DELTA_PAGER' $ENVVAR; then
                                        sed -i 's|.export DELTA_PAGER=|export DELTA_PAGER=|g' $ENVVAR
                                        sed -i "s|export DELTA_PAGER=.*|export DELTA_PAGER='moar $ln'|g" $ENVVAR
                                    else
                                        printf "# DELTA\nexport DELTA_PAGER='moar $ln'\n" >>$ENVVAR
                                    fi
                                    git config $global "$cpager" "$pager --pager='moar $ln'"
                                fi
                                git config $global "$cpager" "delta"

                            elif [[ "$pager" == "bat" ]] || [[ "$pager" == "batdiff" ]]; then
                                readyn -Y "CYAN" -p "$pager uses an environment variable BAT_PAGER to set it's pager. Configure and put in $ENVVAR?" pager1
                                if [[ "$pager1" == 'y' ]]; then
                                    if grep -q 'BAT_PAGER' $ENVVAR; then
                                        sed -i 's|.export BAT_PAGER=|export BAT_PAGER=|g' $ENVVAR
                                        sed -i "s|export BAT_PAGER=.*|export BAT_PAGER='moar $ln'|g" $ENVVAR
                                    else
                                        printf "# BAT\nexport BAT_PAGER='moar $ln'\n" >>$ENVVAR
                                    fi
                                    git config $global "$cpager" "$pager"
                                else
                                    git config $global "$cpager" "$pager --pager=moar $ln"
                                fi
                                git config $global "$cpager" "$pager --pager='moar $ln'"
                            else
                                git config $global "$cpager" "$pager | moar $ln"
                            fi
                        elif [[ "$diffancy" =~ "nvimpager" ]] || [[ "$diffancy" =~ "vimpager" ]]; then
                            opts=""
                            colors="blue darkblue default delek desert elflord evening gruvbox habamax industry koehler lunaperch morning murphy pablo peachpuff quiet ron shine slate torte zellner"
                            if [[ "$pager" =~ "vimpager" ]]; then
                                colors=$colors" retrobox sorbet wildcharm zaibatsu"
                            fi
                            readyn -Y "CYAN" -p "Set colorscheme?" pager1
                            if [[ "$pager1" == "y" ]]; then
                                reade -Q "CYAN" -i "default $colors" -p "Colorscheme: " color
                                opts="$opts +'colorscheme $color'"
                            fi

                            if [[ "$pager" == "ydiff" ]]; then
                                git config $global "$cpager" "ydiff --pager=nvimpager --pager-options='$opts'"
                            elif [[ "$pager" == "delta" ]]; then
                                readyn -p "Delta uses an environment variable DELTA_PAGER to set it's pager. Configure and put in $ENVVAR?" pager1
                                if [[ $pager1 == 'y' ]]; then
                                    if grep -q 'DELTA_PAGER' $ENVVAR; then
                                        sed -i 's|.export DELTA_PAGER=|export DELTA_PAGER=|g' $ENVVAR
                                        sed -i "s|export DELTA_PAGER=.*|export DELTA_PAGER='nvimpager $opts'|g" $ENVVAR
                                    else
                                        printf "# DELTA\nexport DELTA_PAGER='nvimpager $opts'\n" >>$ENVVAR
                                    fi
                                    git config $global "$cpager" "delta"
                                else
                                    git config $global "$cpager" "delta --pager=\"nvimpager $opts\""
                                fi
                            elif [[ "$pager" == "bat" ]] || [[ "$pager" == "batdiff" ]]; then
                                readyn -Y 'CYAN' -p "$pager uses an environment variable BAT_PAGER to set it's pager. Configure and put in $ENVVAR?" pager1
                                if [[ "$pager1" == 'y' ]]; then
                                    if grep -q 'BAT_PAGER' $ENVVAR; then
                                        sed -i 's|.export BAT_PAGER=|export BAT_PAGER=|g' $ENVVAR
                                        sed -i "s|export BAT_PAGER=.*|export BAT_PAGER='nvimpager $opts'|g" $ENVVAR
                                    else
                                        printf "# BAT\nexport BAT_PAGER='nvimpager $opts'\n" >>$ENVVAR
                                    fi
                                    git config $global "$cpager" "$pager"
                                else
                                    git config $global "$cpager" "$pager --pager=\"nvimpager $opts\""
                                fi
                            else
                                git config $global "$cpager" "$pager | nvimpager $opts"
                            fi
                        else
                            if [[ "$pager" == "ydiff" ]]; then
                                git config $global "$cpager" "ydiff --pager=$diffancy"
                            elif [[ "$pager" == "bat" ]] || [[ "$pager" == "batdiff" ]]; then
                                readyn -Y "CYAN" -p "$pager uses an environment variable BAT_PAGER to set it's pager. Configure and put in $ENVVAR?" pager1
                                if [[ "$pager1" == 'y' ]]; then
                                    if grep -q 'BAT_PAGER' $ENVVAR; then
                                        sed -i 's|.export BAT_PAGER=|export BAT_PAGER=|g' $ENVVAR
                                        sed -i "s|export BAT_PAGER=.*|export BAT_PAGER='$diffancy'|g" $ENVVAR
                                    else
                                        printf "# BAT\nexport BAT_PAGER='$diffancy'\n" >>$ENVVAR
                                    fi
                                    git config $global "$cpager" "batdiff"
                                else
                                    git config $global "$cpager" "batdiff --pager='$diffancy'"
                                fi
                            elif [[ "$pager" == "delta" ]]; then
                                readyn -Y "CYAN" -p "Delta uses an environment variable DELTA_PAGER to set it's pager. Configure and put in $ENVVAR?" pager1
                                if [[ "$pager1" == 'y' ]]; then
                                    if grep -q 'DELTA_PAGER' $ENVVAR; then
                                        sed -i 's|.export DELTA_PAGER=|export DELTA_PAGER=|g' $ENVVAR
                                        sed -i "s|export DELTA_PAGER=.*|export DELTA_PAGER='$diffancy'|g" $ENVVAR
                                    else
                                        printf "# DELTA\nexport DELTA_PAGER='$diffancy'\n" >>$ENVVAR
                                    fi
                                    git config $global "$cpager" "delta"
                                else
                                    git config $global "$cpager" "delta --pager=$diffancy"
                                fi
                            else
                                git config $global "$cpager" "$pager | $diffancy"
                            fi
                        fi
                    elif [[ $pager =~ 'delta' ]] || [[ $pager =~ 'bat' ]] || [[ $pager =~ 'batdiff' ]]; then
                        git config $global "$cpager" "$pager --paging=never"
                    elif [[ $pager =~ 'ydiff' ]]; then
                        git config $global "$cpager" "$pager --pager=cat"
                    else
                        git config $global "$cpager" "$pager"
                    fi
                fi
            fi
        fi
        #reade -Q "GREEN" -i "$pager $pagers" -p "Pager: " pager
        pager=''
        #pager="$(printf "$pagersf" | fzf --border --border-label="Pager" --reverse)"

        if [[ "$pager" == 'less' ]]; then
            local ln="-R"
            readyn -Y "CYAN" -p "You selected $pager. Quit if one screen?" pager1
            if [[ "$pager1" == 'y' ]]; then
                ln=$ln"--quit-if-one-screen"
            fi
            readyn -n -N "CYAN" -p "Set linenumbers for pager?" lne
            if [[ "$lne" == 'n' ]]; then
                ln=$ln"-n"
            else
                ln=$ln"-N"
            fi
            git config $global "$cpager" "$pager"
        elif [[ "$pager" == "moar" ]]; then
            readyn -Y "CYAN" -p "You chose $pager. Quit if on one screen?" pager1
            if [[ $pager1 == 'y' ]]; then
                pager=$pager' --quit-if-one-screen'
            fi
            readyn -Y "CYAN" -p "Set moar's colorscheme / style?" pager1
            if [[ $pager1 == 'y' ]]; then
                local theme
                local styles="abap\nalgol\nalgol_nu\napi\narduino\nautumn\naverage\nbase16-snazzy\nborland\nbw\ncatppuccin-frappe\ncatppuccin-latte\ncatppuccin-macchiato\ncatppuccin-mocha\ncolorful\ncompat\ndoom-one\ndoom-one2\ndracula\nemacs\nfriendly\nfruity\ngithub-dark\ngithub\ngruvbox-light\ngruvbox\nhr_high_contrast\nhrdark\nigor\nlovelace\nmanni\nmodus-operandi\nmodus-vivendi\nmonokai\nmonokailight\nmurphy\nnative\nnord\nonedark\nonesenterprise\nparaiso-dark\nparaiso-light\npastie\nperldoc\npygments\nrainbow_dash\nrose-pine-dawn\nrose-pine-moon\nrose-pine\nrrt\nsolarized-dark\nsolarized-dark256\nsolarized-light\nswapoff\ntango\ntrac\nvim\nvs\nvulcan\nwitchhazel\nxcode-dark\nxcode"
                while test -z "$style"; do
                    style=$(printf "$styles" | fzf --reverse --border --border-label="Moar style")
                    moar --style "$style" $TMPDIR/test1
                    stty sane && readyn -n -p "Set as style? (Will retry if no)" thme
                    if [[ "$thme" == "n" ]]; then
                        style=''
                    fi
                done
                pager=$pager" $style"
            fi
            readyn -Y "CYAN" -p "Show linenumber?" pager1
            if [[ $pager1 == 'n' ]]; then
                pager=$pager' --no-linenumbers'
            fi
            readyn -n -N "CYAN" -p "Wrap long lines?" pager1
            if [[ $pager1 == 'y' ]]; then
                pager=$pager' --wrap'
            fi
            git config $global "$cpager" "$pager"
        elif [[ "$pager" == "nvimpager" ]] || [[ "$pager" == "vimpager" ]]; then
            echo "You selected $pager."
            colors="blue darkblue default delek desert elflord evening gruvbox habamax industry koehler lunaperch morning murphy pablo peachpuff quiet ron shine slate torte zellner"
            if [[ "$pager" == "vimpager" ]]; then
                colors=$colors" retrobox sorbet wildcharm zaibatsu"
            fi
            pager="$pager"
            readyn -y -Y "CYAN" -p "Set colorscheme?" pager1
            if [[ "$pager1" == "y" ]]; then
                readyn -y -Y "CYAN" -i "default $colors" -p "Colorscheme: " color
                pager="$pager +'colorscheme $color'"
            fi
            git config $global "$cpager" "$pager"
        elif [[ "$pager" == "riff" ]]; then
            pager="riff"
            readyn -y -Y "CYAN" -p "Ignore changes in amount of whitespace?" riff1
            if [[ "$riff1" == 'y' ]]; then
                pager=$pager" -b"
            fi
            readyn -y -Y "CYAN" -p "No special highlighting for lines that only add content?" riff1
            if [[ "$riff1" == 'y' ]]; then
                pager=$pager" --no-adds-only-special"
            fi
        elif [[ "$pager" == "diff-so-fancy" ]] || [[ "$pager" == "diffr" ]] || [[ "$pager" == "ydiff" ]] || [[ "$pager" == "delta" ]] || [[ "$pager" == "bat" ]] || [[ "$pager" == "batdiff" ]]; then
            local difffancy
            readyn -p "You selected $pager. Configure?" -c "(! [[ $pager == 'delta' ]] && ! [[ $pager == 'diff-so-fancy' ]]) || test -z \"$(git config $global --list --show-origin)\"" difffancy
            if [[ "y" == "$difffancy" ]]; then
                if [[ "$pager" == "bat" ]] || [[ "$pager" == "batdiff" ]]; then
                    local opts=""
                    readyn -Y "CYAN" -p "Set styles? (line numbers/grid)" delta2
                    local theme='changes'
                    if [[ "y" == $delta2 ]]; then
                        while :; do
                            local style=''
                            style=$(printf "full\nauto\nplain\nchanges\nheader\nheader-filename\nheader-filesize\ngrid\nrule\nnumbers\nsnip\n" | fzf --border --border-label="Bat styles")
                            stty sane &&
                                reade -Q "MAGENTA" -i "a o n" -p "Add to styles/Only use this style/Dont use? (Will retry if add) [A/o/n]: " dltthme
                            if test "$dltthme" == "a"; then
                                theme=$theme","$style
                            elif test "$dltthme" == "o"; then
                                theme=$theme","$style
                                break
                            else
                                break
                            fi
                        done
                        opts=$opts" --style='$theme'"
                    fi
                    readyn -Y "CYAN" -p "Set syntax-theme" delta1
                    if [[ "y" == "$delta1" ]]; then
                        local theme=''

                        while test -z "$theme"; do
                            theme=$(bat --list-themes | fzf --border --border-label="Bat syntax themes" --preview="bat --theme={} --color=always $TMPDIR/test1")
                            stty sane && readyn -n -N "MAGENTA" -p "Set $theme as syntax theme? (Will retry if no)" dltthme
                            if [[ "$dltthme" == "n" ]]; then
                                theme=''
                            fi
                        done
                        opts=$opts" --theme=$theme"
                    fi

                    readyn -n -p "Set to specific language? (Useful if you're using an obscure language that bat can't autodetect)" delta2
                    if [[ "y" == "$delta2" ]]; then
                        local theme=''

                        while test -z "$theme"; do
                            theme=$(bat --list-languages | fzf --border --border-label="Bat coding languages")
                            stty sane && readyn -n -N "MAGENTA" -p "Set syntax to specifically use $theme as language? (Will retry if no)" dltthme
                            if [[ "$dltthme" == "n" ]]; then
                                theme=''
                            fi
                        done
                        opts=$opts" --language=$theme"
                    fi
                    pager=$pager" $opts"
                elif [[ "$pager" == "delta" ]]; then
                    readyn -Y "CYAN" -p "Set side-by-side view?" delta1
                    if [[ "y" == "$delta1" ]]; then
                        git config $global delta.side-by-side true
                    fi

                    readyn -Y "CYAN" -p "Set to navigate? (Move between diff sections using n and N)" delta1
                    if [[ "y" == "$delta1" ]]; then
                        git config $global delta.navigate true
                    fi

                    readyn -Y "CYAN" -p "Set syntax theme?" delta1
                    if [[ "y" == "$delta1" ]]; then
                        local theme=''
                        while test -z "$theme"; do
                            theme=$(printf "$(delta --list-syntax-themes | tail -n +1)" | fzf --reverse --border --border-label="Syntax theme")
                            theme=$(echo "$theme" | awk '{$1=""; print $0;}')
                            delta --syntax-theme "${theme:1}" $TMPDIR/test1 $TMPDIR/test2
                            stty sane && readyn -n -N "MAGENTA" -p "Set as syntax theme? (Will retry if no)" dltthme
                            if [[ "$dltthme" == "n" ]]; then
                                theme=''
                            fi
                        done
                        git config $global delta.syntax-theme $theme
                    fi

                    readyn -Y "CYAN" -p "Set to dark?" delta2
                    if [[ "y" == "$delta2" ]]; then
                        git config $global delta.dark true
                    fi

                    readyn -Y "CYAN" -p "Set linenumbers?" delta3
                    if [[ "y" == "$delta3" ]]; then
                        git config $global delta.linenumbers true
                    fi

                    readyn -Y "CYAN" -p "Set hyperlinks?" delta1
                    if [[ "y" == "$delta1" ]]; then
                        git config $global delta.hyperlinks true
                    fi

                elif [[ "$pager" == "diff-so-fancy" ]]; then

                    readyn -Y "CYAN" -p "Should the first block of an empty line be colored?" diffancy
                    if [[ "y" == "$diffancy" ]]; then
                        git config --bool $global diff-so-fancy.markEmptyLines true
                    else
                        git config --bool $global diff-so-fancy.markEmptyLines false
                    fi
                    readyn -Y "CYAN" -p "Simplify git header chunks to a more human readable format?" diffancy
                    if [[ "y" == $diffancy ]]; then
                        git config --bool $global diff-so-fancy.changeHunkIndicators true
                    else
                        git config --bool $global diff-so-fancy.changeHunkIndicators false
                    fi
                    readyn -Y "CYAN" -p "Should the pesky + or - at line-start be removed?" diffancy
                    if [[ "y" == $diffancy ]]; then
                        git config --bool $global diff-so-fancy.stripLeadingSymbols true
                    else
                        git config --bool $global diff-so-fancy.stripLeadingSymbols false
                    fi
                    readyn -Y "CYAN" -p "By default, the separator for the file header uses Unicode line-drawing characters. If this is causing output errors on your terminal, set this to false to use ASCII characters instead?" diffancy
                    if [[ "y" == "$diffancy" ]]; then
                        git config --bool $global diff-so-fancy.useUnicodeRuler true
                    else
                        git config --bool $global diff-so-fancy.useUnicodeRuler false
                    fi
                    reade -Q "CYAN" -i "47 $(seq 1 100)" -p "By default, the separator for the file header spans the full width of the terminal. Use this setting to set the width of the file header manually (Default: 47)?: " diffancy
                    # git log's commit header width
                    git config $global diff-so-fancy.rulerWidth $diffancy
                elif [[ "$pager" == "ydiff" ]]; then
                    pager=$pager" --color=auto"
                    readyn -Y "CYAN" -p "Enable side-by-side mode?" diffr1
                    if [[ "$diffr1" == 'y' ]]; then
                        pager=$pager" --side-by-side"
                        readyn -Y "CYAN" -p "Wrap long lines in side-by-side view?" diffr1
                        if [[ "$diffr1" == 'y' ]]; then
                            pager=$pager" --wrap"
                        fi
                    fi
                elif [[ "$pager" == "diffr" ]]; then
                    readyn -Y "CYAN" -p "Set linenumber?" diffr1
                    if [[ "$diffr1" == 'y' ]]; then
                        pager="diffr --line-numbers"
                        reade -Q "MAGENTA" -i 'c a n' -p "Set linenumber style? [Compact/aligned/n]: " diffr1
                        if [[ "$diffr1" == 'compact' ]] || [[ "$diffr1" == 'aligned' ]]; then
                            pager="diffr --line-numbers $diffr1"
                        fi
                    fi
                fi

                readyn -n -N "YELLOW" -p "Only use syntax highlighting and turn off pager?" pipepager1
                if [[ "$pipepager1" == 'y' ]]; then
                    if [[ $pager =~ 'delta' ]] || [[ $pager =~ 'bat' ]] || [[ $pager =~ 'batdiff' ]]; then
                        git config $global "$cpager" "$pager --paging=never"
                    elif [[ $pager =~ 'ydiff' ]]; then
                        git config $global "$cpager" "$pager --pager=cat"
                    else
                        git config $global "$cpager" "$pager"
                    fi
                else

                    prompt="Configure $pager's pager settings? [Y/n]: "
                    if [[ "$pager" =~ "diff-so-fancy" ]] || [[ "$pager" =~ "diffr" ]]; then
                        prompt="$pager alone won't page. Pipe to a pager? [Y/n]: "
                    fi

                    readyn -Y "CYAN" -p "$prompt" pipepager
                    if [[ "$pipepager" == 'y' ]]; then
                        pagers="less more"
                        pagersf="less\nmore\n"
                        if type most &>/dev/null; then
                            pagers=$pagers" most"
                            pagersf=$pagersf"most\n"
                        fi
                        if type moar &>/dev/null; then
                            pagers=$pagers" moar"
                            pagersf=$pagersf"moar\n"
                        fi
                        if type vimpager &>/dev/null; then
                            pagers=$pagers" vimpager"
                            pagersf=$pagersf"vimpager\n"
                        fi
                        if type nvimpager &>/dev/null; then
                            pagers=$pagers" nvimpager"
                            pagersf=$pagersf"nvimpager\n"
                        fi

                        reade -Q "GREEN" -i "$PAGER $pagers" -p "Pager: " diffancy

                        if [[ "$diffancy" =~ "less" ]]; then
                            local ln=""
                            readyn -Y "CYAN" -p "Quit if one screen?" lne
                            if [[ "$lne" == 'y' ]]; then
                                ln="--quit-if-one-screen"
                            fi
                            reade -n -N "CYAN" -p "Set linenumbers for pager?" lne
                            if [[ "$lne" == 'n' ]]; then
                                ln=$ln"-n"
                            else
                                ln=$ln"-N"
                            fi
                            if [[ "$pager" =~ "ydiff" ]]; then
                                git config $global "$cpager" "ydiff --pager=less --pager-options=\"-R $ln\""
                            elif [[ "$pager" =~ "bat" ]] || [[ "$pager" =~ "batdiff" ]]; then
                                readyn -Y "CYAN" -p "$pager uses an environment variable BAT_PAGER to set it's pager. Configure and put in $ENVVAR?" pager1
                                if [[ $pager1 == 'y' ]]; then
                                    if grep -q 'BAT_PAGER' $ENVVAR; then
                                        sed -i 's|.export BAT_PAGER=|export BAT_PAGER=|g' $ENVVAR
                                        sed -i "s|export BAT_PAGER=.*|export BAT_PAGER='less -R $ln'|g" $ENVVAR
                                    else
                                        printf "\n# BAT\nexport BAT_PAGER='less -R $ln'\n" >>$ENVVAR
                                    fi
                                    git config $global "$cpager" "$pager"
                                else
                                    git config $global "$cpager" "$pager --pager='less -R $ln'"
                                fi
                            elif [[ "$pager" =~ "delta" ]]; then
                                readyn -Y "CYAN" -p "Delta uses an environment variable DELTA_PAGER to set it's pager. Configure and put in $ENVVAR?" pager1
                                if [[ $pager1 == 'y' ]]; then
                                    if grep -q 'DELTA_PAGER' $ENVVAR; then
                                        sed -i 's|.export DELTA_PAGER=|export DELTA_PAGER=|g' $ENVVAR
                                        sed -i "s|export DELTA_PAGER=.*|export DELTA_PAGER='less -R $ln'|g" $ENVVAR
                                    else
                                        printf "\n# DELTA\nexport DELTA_PAGER='less -R $ln'\n" >>$ENVVAR
                                    fi
                                    git config $global "$cpager" "delta"
                                else
                                    git config $global "$cpager" "delta --pager=less $ln"
                                fi
                            else
                                git config $global "$cpager" "$pager | less -RF $ln"
                            fi
                        elif [[ "$diffancy" =~ "moar" ]]; then
                            local ln=""
                            readyn -Y "CYAN" -p "You selected $diffancy. Show linenumber?" pager1
                            if [[ $pager1 == 'n' ]]; then
                                ln=$ln' --no-linenumbers'
                            fi

                            readyn -Y "CYAN" -p "Quit if one screen?" pager1
                            if [[ $pager1 == 'y' ]]; then
                                ln=$ln' --quit-if-one-screen'
                            fi

                            readyn -n -N "CYAN" -p "Wrap long lines?" pager1
                            if [[ $pager1 == 'y' ]]; then
                                ln=$ln' --wrap'
                            fi

                            if [[ "$pager" =~ "ydiff" ]]; then
                                git config $global "$cpager" "ydiff --pager=moar --pager-options=\"$ln\""
                            elif [[ "$pager" =~ "delta" ]]; then
                                readyn -Y "CYAN" -p "Delta uses an environment variable DELTA_PAGER to set it's pager. Configure and put in $ENVVAR?" pager1
                                if [[ $pager1 == 'y' ]]; then
                                    if grep -q 'DELTA_PAGER' $ENVVAR; then
                                        sed -i 's|.export DELTA_PAGER=|export DELTA_PAGER=|g' $ENVVAR
                                        sed -i "s|export DELTA_PAGER=.*|export DELTA_PAGER='moar $ln'|g" $ENVVAR
                                    else
                                        printf "\n# DELTA\nexport DELTA_PAGER='moar $ln'\n" >>$ENVVAR
                                    fi
                                    git config $global "$cpager" "$pager --pager='moar $ln'"
                                fi
                                git config $global "$cpager" "delta"

                            elif [[ "$pager" =~ "bat" || "$pager" =~ "batdiff" ]]; then
                                readyn -Y "CYAN" -p "$pager uses an environment variable BAT_PAGER to set it's pager. Configure and put in $ENVVAR?" pager1
                                if [[ "$pager1" == 'y' ]]; then
                                    if grep -q 'BAT_PAGER' $ENVVAR; then
                                        sed -i 's|.export BAT_PAGER=|export BAT_PAGER=|g' $ENVVAR
                                        sed -i "s|export BAT_PAGER=.*|export BAT_PAGER='moar $ln'|g" $ENVVAR
                                    else
                                        printf "\n# BAT\nexport BAT_PAGER='moar $ln'\n" >>$ENVVAR
                                    fi
                                    git config $global "$cpager" "$pager"
                                else
                                    git config $global "$cpager" "$pager --pager='moar $ln'"
                                fi
                            else
                                git config $global "$cpager" "$pager | moar $ln"
                            fi
                        elif [[ "$diffancy" =~ "nvimpager" ]] || [[ "$diffancy" =~ "vimpager" ]]; then
                            opts=""
                            colors="blue darkblue default delek desert elflord evening gruvbox habamax industry koehler lunaperch morning murphy pablo peachpuff quiet ron shine slate torte zellner"
                            if [[ "$pager" =~ "vimpager" ]]; then
                                colors=$colors" retrobox sorbet wildcharm zaibatsu"
                            fi
                            readyn -Y "CYAN" -p "Set colorscheme?" pager1
                            if [ "$pager1" == "y" ]; then
                                reade -Q "CYAN" -i "default $colors" -p "Colorscheme: " color
                                opts="$opts +'colorscheme $color'"
                            fi

                            if [[ "$pager" =~ "ydiff" ]]; then
                                git config $global "$cpager" "ydiff --pager=nvimpager --pager-options='$opts'"
                            elif [[ "$pager" =~ "delta" ]]; then
                                readyn -Y "CYAN" -p "Delta uses an environment variable DELTA_PAGER to set it's pager. Configure and put in $ENVVAR?" pager1
                                if [[ $pager1 == 'y' ]]; then
                                    if grep -q 'DELTA_PAGER' $ENVVAR; then
                                        sed -i 's|.export DELTA_PAGER=|export DELTA_PAGER=|g' $ENVVAR
                                        sed -i "s|export DELTA_PAGER=.*|export DELTA_PAGER='nvimpager $opts'|g" $ENVVAR
                                    else
                                        printf "\n# DELTA\nexport DELTA_PAGER='nvimpager $opts'\n" >>$ENVVAR
                                    fi
                                    git config $global "$cpager" "delta"
                                else
                                    git config $global "$cpager" "delta --pager=\"nvimpager $opts\""
                                fi
                            elif [[ "$pager" =~ "bat" ]] || [[ "$pager" =~ "batdiff" ]]; then
                                readyn -Y "CYAN" -p "$pager uses an environment variable BAT_PAGER to set it's pager. Configure and put in $ENVVAR?" pager1
                                if [[ $pager1 == 'y' ]]; then
                                    if grep -q 'BAT_PAGER' $ENVVAR; then
                                        sed -i 's|.export BAT_PAGER=|export BAT_PAGER=|g' $ENVVAR
                                        sed -i "s|export BAT_PAGER=.*|export BAT_PAGER='nvimpager $opts'|g" $ENVVAR
                                    else
                                        printf "\n# BAT\nexport BAT_PAGER='nvimpager $opts'\n" >>$ENVVAR
                                    fi
                                    git config $global "$cpager" "$pager"
                                else
                                    git config $global "$cpager" "$pager --pager='nvimpager $opts'"
                                fi
                            else
                                git config $global "$cpager" "$pager | nvimpager $opts"
                            fi
                        else
                            if [[ "$pager" =~ "ydiff" ]]; then
                                git config $global "$cpager" "ydiff --pager=$diffancy"
                            elif [[ "$pager" =~ "bat" || "$pager" =~ "batdiff" ]]; then
                                readyn -Y "CYAN" -p "$pager uses an environment variable BAT_PAGER to set it's pager. Configure and put in $ENVVAR?" pager1
                                if [[ $pager1 == 'y' ]]; then
                                    if grep -q 'BAT_PAGER' $ENVVAR; then
                                        sed -i 's|.export BAT_PAGER=|export BAT_PAGER=|g' $ENVVAR
                                        sed -i "s|export BAT_PAGER=.*|export BAT_PAGER='$diffancy'|g" $ENVVAR
                                    else
                                        printf "\n# BAT\nexport BAT_PAGER='$diffancy'\n" >>$ENVVAR
                                    fi
                                    git config $global "$cpager" "batdiff"
                                else
                                    git config $global "$cpager" "batdiff --pager='$diffancy'"
                                fi
                            elif [[ "$pager" =~ "delta" ]]; then
                                readyn -Y "CYAN" -p "Delta uses an environment variable DELTA_PAGER to set it's pager. Configure and put in $ENVVAR?" pager1
                                if [[ $pager1 == 'y' ]]; then
                                    if grep -q 'DELTA_PAGER' $ENVVAR; then
                                        sed -i 's|.export DELTA_PAGER=|export DELTA_PAGER=|g' $ENVVAR
                                        sed -i "s|export DELTA_PAGER=.*|export DELTA_PAGER='$diffancy'|g" $ENVVAR
                                    else
                                        printf "\n# DELTA\nexport DELTA_PAGER='$diffancy'\n" >>$ENVVAR
                                    fi
                                    git config $global "$cpager" "delta"
                                else
                                    git config $global "$cpager" "delta --pager=$diffancy"
                                fi
                            else
                                git config $global "$cpager" "$pager | $diffancy"
                            fi
                        fi
                    fi
                fi
            fi

        fi
    fi

    #git config "$global" "$cpager" "$pager" ;
    #elif test "$regpager" == "y"; then
    #    pagers="cat"
    #    pager="cat"
    #    if type bat &> /dev/null; then
    #        pagers=$pagers" bat"
    #    fi
    #    if type batdiff &> /dev/null; then
    #        pagers=$pagers" batdiff"
    #    fi
    #    reade -Q "CYAN" -i "cat" -p "Pager: " "$pagers" pager;
    #    if [ $pager == "bat" ]; then
    #        pager="bat --paging=never"
    #    fi
    #    if [ $pager == "batdiff" ]; then
    #        pager="batdiff --paging=never"
    #    fi
    #    git config "$global" "$cpager" "$pager"
    #fi
}

gitt() {
    if ! type git &>/dev/null; then
        readyn -p "Install git?" nstll
        if [[ "$nstll" == "y" ]]; then
            if [[ $distro_base == "Arch" ]]; then
                eval "$pac_ins git"
            elif [[ "$distro_base" == "Debian" ]]; then
                eval "$pac_ins git"
            fi
        fi
    fi

    local global=""
    if ! test -z "$1"; then
        global="--$1"
    else
        readyn -p "Set to configure git globally? (for the entire system)" gitglobal
        if [[ "y" == "$gitglobal" ]]; then
            global="--global"
        fi
        unset gitglobal
    fi

    if [[ $global == '--global' ]] && ! test -f ~/.gitconfig; then
        touch ~/.gitconfig
    elif ! test -f .gitconfig; then
        touch .gitconfig
    fi

    readyn -p "Configure git name?" -c "test -z $(git config $global --list | grep 'user.name' | awk 'BEGIN { FS = "=" }; {print $2;}')" gitname
    if [[ "y" == $gitname ]]; then
        reade -Q "CYAN" -p "Name: " name
        if [ ! -z $name ]; then
            git config "$global" user.name "$name"
        fi
    fi

    readyn -p "Configure git email?" -c "test -z $(git config $global --list | grep 'user.email' | awk 'BEGIN { FS = "=" } ;{print $2;}')" gitmail
    if [[ "y" == $gitmail ]]; then
        reade -Q "CYAN" -p "Email: " mail
        if [ ! -z $mail ]; then
            git config "$global" user.email "$mail"
        fi
    fi

    readyn -p 'Configure git to look for ssh:// instead of https:// when f.ex. cloning/pulling/pushing?' -c "! [[ $global =~ 'global' ]] && test -z $(git config $global --list | grep 'url.ssh://git@github.com/.insteadof=' | awk 'BEGIN { FS = "=" }; {print $2;}')" githttpee
    if [[ "y" == $githttpee ]]; then
        git config $global url.ssh://git@github.com/.insteadOf https://github.com/
    fi
    unset gihttpee

    # https://www.youtube.com/watch?v=aolI_Rz0ZqY

    readyn -p "Configure git to remember resolved mergeconflicts for reuse?" -c "test -z $(git config $global --list | grep 'rerere.enabled' | awk 'BEGIN { FS = "=" } ;{print $2;}')" gitrerere
    if [[ "y" == $gitrerere ]]; then
        git config "$global" rerere.enabled true
    fi

    local gitpgr pager wpager
    readyn -Y "CYAN" -p "Configure pager for git core, diff, show and log?" wpager
    if [[ "$wpager" == "y" ]]; then
        readyn -n -p "Install custom diff syntax highlighter?" gitpgr
        if [[ "$gitpgr" == "y" ]]; then
            if ! test -f install_differ_pager.sh; then
                source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_differ_pager.sh)
            else
                . ./install_differ_pager.sh
            fi
        fi
        
        readyn -p "Set core.pager?" -c "test -z \"$(git config $global --list | grep 'core.pager' | awk 'BEGIN { FS = "=" }; {print $2;}')\"" pager
        if [[ $pager == 'y' ]]; then
            git_pager "core.pager" "$global"
        fi
        readyn -p "Set pager.diff?" -c "test -z \"$(git config $global --list | grep 'pager.diff' | awk 'BEGIN { FS = "=" }; {print $2;}')\"" pager
        if [[ $pager == 'y' ]]; then

            pager "pager.diff" "$global"
        fi
        readyn -p "Set pager.difftool?" -c "test -z \"$(git config $global --list | grep 'pager.difftool' | awk 'BEGIN { FS = "=" }; {print $2;}')\"" pager
        if [[ $pager == 'y' ]]; then
            git_pager "pager.difftool" "$global"
        fi
        readyn -p "Set pager.show?" -c "test -z \"$(git config $global --list | grep 'pager.show' | awk 'BEGIN { FS = "=" }; {print $2;}')\"" pager
        if [[ $pager == 'y' ]]; then
            git_pager "pager.show" "$global"
        fi
        readyn -p "Set pager.log?" -c "test -z \"$(git config $global --list | grep 'pager.log' | awk 'BEGIN { FS = "=" } ;{print $2;}')\"" pager
        if [[ $pager == 'y' ]]; then
            git_pager "pager.log" "$global"
        fi
    fi
    #confs="$(cur="pager." && compgen -F _git_config 2> /dev/null)"

    local diffs=""
    local diff=""
    if type delta &>/dev/null; then
        diffs=$diffs" delta"
        diff="delta"
    fi
    if type ydiff &>/dev/null; then
        diffs=$diffs" ydiff"
        diff="delta"
    fi
    if type riff &>/dev/null; then
        diffs=$diffs" riff"
        diff="riff"
    fi
    if type diffr &>/dev/null; then
        diffs=$diffs" diffr"
        diff="diffr"
    fi
    if type diff-so-fancy &>/dev/null; then
        diffs=$diffs" diff-so-fancy"
        diff="diff-so-fancy"
    fi
    if type batdiff &>/dev/null; then
        diffs=$diffs" batdiff"
        diff="batdiff"
    fi

    if ! test -z "$diffs"; then
        readyn -p "Configure custom interactive diff filter?" -c "test -z \"$(git config $global --list | grep 'interactive.difffilter' | awk 'BEGIN { FS = "=" } ;{print $2;}')\"" gitdiff1
        if [[ "y" == "$gitdiff1" ]]; then
            git_hl "git config $global interactive.difffilter"
        fi
    fi

    local editor editors diffs diff difftool mergetool cstyle prompt
    editors="nano vi"
    if type vim &>/dev/null; then
        editors=$editors" vim"
        editor='vim'
    fi
    if type gvim &>/dev/null; then
        editors=$editors" gvim"
        editor='gvim'
    fi
    if type nvim &>/dev/null; then
        editors=$editors" nvim"
        editor='nvim'
    fi
    if type emacs &>/dev/null; then
        editors=$editors" emacs"
        editor='emacs'
    fi
    if type code &>/dev/null; then
        editors=$editors" vscode"
        editor='vscode'
    fi
    diffs="$editors"
    diff="$editor"
    if type difft &>/dev/null; then
        diffs=$diffs" difftastic"
        diff="difftastic"
    fi

    readyn -Y "CYAN" -p "Set color.ui? (Git color behaviour)" -c "test -z $(git config $global --list | grep 'color.ui' | awk 'BEGIN { FS = "=" }; {print $2;}')" editor
    if [[ "y" == "$editor" ]]; then
        reade -Q "CYAN" -i "true false auto always" -p "Color.ui (Default: auto): " editor
        if [[ "$editor" == "auto" ]] || [[ "$editor" == "false" ]] || [[ "$editor" == "true" ]] || [[ "$editor" == "always" ]]; then
            git config "$global" color.ui "$editor"
        fi
    fi
    unset editor

    readyn -Y "CYAN" -p "Set default editor?: " -c "test -z $(git config $global --list | grep 'core.editor' | awk 'BEGIN { FS = "=" }; {print $2;}')" editor
    if [[ "y" == "$editor" ]]; then
        unset editor
        reade -Q "CYAN" -i "$editor $editors" -p "Editor: " editor
        if ! test -z "$editor"; then
            if [[ "$editor" == "vscode" ]]; then
                editor="code"
            fi
            git config "$global" core.editor "$editor"
        fi
    fi

    readyn -Y "CYAN" -p "Set difftool?" -c "test -z $(git config $global --list | grep 'diff.tool' | awk 'BEGIN { FS = "=" } ;{print $2;}')" difftool
    if [[ "$difftool" == "y" ]]; then
        reade -Q "CYAN" -i "$diff $diffs" -p "Tool: " editor
        if ! test -z "$editor"; then
            local diff merge
            if [[ "$editor" == "vim" ]]; then
                git config "$global" diff.tool vimdiff
            elif [[ "$editor" == "gvim" ]]; then
                git config "$global" diff.tool gvimdiff
            elif [[ "$editor" == "nvim" ]]; then
                git config "$global" diff.tool nvimdiff
            elif [[ "$editor" == "emacs" ]]; then
                git config "$global" diff.tool emerge
            elif [[ "$editor" == "vscode" ]]; then
                git config "$global" difftool.vscode.cmd 'code --wait --diff $LOCAL $REMOTE'
                git config "$global" diff.tool vscode
            elif [[ "$editor" == "difftastic" ]]; then
                git config "$global" diff.tool difftastic
                git config "$global" difftool.pager true
                git config "$global" difftool.prompt false
                git config "$global" difftool.difftastic.cmd 'difft $LOCAL $REMOTE'
            fi
        fi
    fi

    readyn -Y "CYAN" -p "Set diff guitool?" -c "test -z $(git config $global --list | grep 'diff.guitool' | awk 'BEGIN { FS = "=" } ;{print $2;}')" difftool
    if [[ $difftool == "y" ]]; then
        reade -Q "CYAN" -i "$diff $diffs" -p "Guitool: " editor
        if ! test -z "$editor"; then
            local diff merge
            if [[ "$editor" == "vim" ]]; then
                git config "$global" diff.guitool vimdiff
            elif [[ "$editor" == "gvim" ]]; then
                git config "$global" diff.guitool gvimdiff
            elif [[ "$editor" == "nvim" ]]; then
                git config "$global" diff.guitool nvimdiff
            elif [[ "$editor" == "emacs" ]]; then
                git config "$global" diff.guitool emerge
            elif [[ "$editor" == "vscode" ]]; then
                git config "$global" difftool.vscode.cmd 'code --wait --diff $LOCAL $REMOTE'
                git config "$global" diff.guitool vscode
            elif [[ "$editor" == "difftastic" ]]; then
                git config "$global" diff.guitool difftastic
                git config "$global" diffguitool.pager true
                git config "$global" difftool.prompt false
                git config "$global" difftool.difftastic.cmd 'difft "$LOCAL" "$REMOTE"'
            fi
        fi
    fi

    readyn -Y "CYAN" -p "Set difftool prompt?" -c "test -z $(git config $global --list | grep 'difftool.prompt' | awk 'BEGIN { FS = "=" } ;{print $2;}')" conflict
    if [[ $conflict == "y" ]]; then
        reade -Q "GREEN" -i "false true" -p "Prompt?: " prompt
        if ! test -z "$cstyle"; then
            git config difftool.prompt "$prompt"
        fi
    fi

    readyn -Y "CYAN" -p "Set mergetool?" -c "test -z $(git config $global --list | grep 'merge.tool' | awk 'BEGIN { FS = "=" } ;{print $2;}')" difftool
    if [[ $difftool == "y" ]]; then
        reade -Q "CYAN" -i "$editor $editors" -p "Tool (editor): " editor
        if ! test -z "$editor"; then
            local diff merge
            if [[ "$editor" == "vim" ]]; then
                git config "$global" merge.tool vimdiff
            elif [[ "$editor" == "gvim" ]]; then
                git config "$global" merge.tool gvimdiff
            elif [[ "$editor" == "nvim" ]]; then
                git config "$global" merge.tool nvimdiff
            elif [[ "$editor" == "emacs" ]]; then
                git config "$global" merge.tool emerge
            elif [[ "$editor" == "vscode" ]]; then
                git config "$global" mergetool.vscode.cmd 'code --wait $MERGED'
                git config "$global" merge.tool vscode
            fi
        fi
    fi

    readyn -Y "CYAN" -p "Set merge guitool?" -c "test -z $(git config $global --list | grep 'merge.guitool' | awk 'BEGIN { FS = "=" } ;{print $2;}')" difftool
    if [[ $difftool == "y" ]]; then
        reade -Q "CYAN" -i "$editor $editors" -p "Guitool (editor): " editor
        if ! test -z "$editor"; then
            local diff merge
            if [[ "$editor" == "vim" ]]; then
                git config "$global" merge.guitool vimdiff
            elif [[ "$editor" == "gvim" ]]; then
                git config "$global" merge.guitool gvimdiff
            elif [[ "$editor" == "nvim" ]]; then
                git config "$global" merge.guitool nvimdiff
            elif [[ "$editor" == "emacs" ]]; then
                git config "$global" merge.guitool emerge
            elif [[ "$editor" == "vscode" ]]; then
                git config "$global" mergetool.vscode.cmd 'code --wait $MERGED'
                git config "$global" merge.guitool vscode
            fi
        fi
    fi

    readyn -Y "CYAN" -p "Set mergetool prompt?" -c "test -z $(git config $global --list | grep 'mergetool.prompt' | awk 'BEGIN { FS = "=" } ;{print $2;}')" Configure    
    if [[ $conflict == "y" ]]; then
        reade -Q "GREEN" -i "false true" -p "Prompt?: " prompt
        if ! test -z "$cstyle"; then
            git config mergetool.prompt "$prompt"
        fi
    fi

    readyn -Y "CYAN" -p "Set merge conflictsstyle?" -c "test -z $(git config $global --list | grep 'merge.conflictsstyle' | awk 'BEGIN { FS = "=" } ;{print $2;}')" conflict
    if [[ $conflict == "y" ]]; then
        reade -Q "GREEN" -i "diff3 diff diff1 diff2" -p "Conflictsstyle: " cstyle
        if ! test -z "$cstyle"; then
            git config "$global" merge.conflictsstyle "$cstyle"
        fi
    fi

    readyn -p "Check git config?" gitcnf
    if [[ "y" == "$gitcnf" ]]; then
        git config $global -e
    fi

    readyn -p "Check and create global gitignore? (~/.config/git/ignore)" gitign
    if [[ "y" == "$gitign" ]]; then
        if ! test -f install_gitignore.sh; then
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_gitignore.sh)"
        else
            . ./install_gitignore.sh
        fi
    fi

    if ! type lazygit &>/dev/null; then
        readyn -p "Install lazygit? (git TUI - terminal user interface)" gitlaz
        if [[ "y" == "$gitlaz" ]]; then
            if ! test -f install_lazygit.sh; then
                eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_lazygit.sh)"
            else
                . ./install_lazygit.sh
            fi
        fi 
    fi

    #local diffpre="n"
    #if ! grep -q 'pager:' ~/.config/lazygit/config.yml ; then
    #    diffpre="y"
    #fi

    #if ! type lazygit &>/dev/null || ! grep -q 'pager:' ~/.config/lazygit/config.yml; then
    #    readyn -Y "CYAN" -p "Configure custom interactive diff filter for Lazygit?" gitdiff1
    #    if [[ "y" == "$gitdiff1" ]]; then
    #        readyn -n -p "Install custom diff syntax highlighter?" gitpgr
    #        if [[ "$gitpgr" == "y" ]]; then
    #            if ! test -f install_differ_pager.sh; then
    #                source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_differ_pager.sh)
    #            else
    #                . ./install_differ_pager.sh
    #            fi
    #        fi
    #         
    #        git_hl "lazygit"
    #    fi
    #fi

    # FZF is cool but ripgrep-dir is cooler

    #if ! test -f ~/.bash_aliases.d/fzf-git.sh; then
    #    readyn -p "Install fzf-git? (Extra fzf stuff on leader-key C-g): "" gitfzf
    #    if [ "$fzfgit" == "y" ]; then
    #        if ! test -f checks/check_aliases_dir.sh; then
    #            eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_aliases_dir.sh)"
    #        else
    #           . ./checks/check_aliases_dir.sh
    #        fi
    #        curl -o ~/.bash_aliases.d/fzf-git.sh https://raw.githubusercontent.com/junegunn/fzf-git.sh/main/fzf-git.sh
    #    fi
    #fi

    local gitals
    readyn -p "Install git.sh? (Git aliases)" gitals
    if [[ "$gitals" == "y" ]]; then
        if ! test -f checks/check_aliases_dir.sh; then
            eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_aliases_dir.sh)"
        else
            . ./checks/check_aliases_dir.sh
        fi
        if ! test -f aliases/.bash_aliases.d/git.sh; then
            curl -o ~/.bash_aliases.d/git.sh https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/git.sh
        else
            cp -f aliases/.bash_aliases.d/git.sh ~/.bash_aliases.d/
        fi
    fi

    unset gitdiff diff gitmerge merge amt rslt gitcnf gitign
}

test -e "$1" && gitt "$1"
