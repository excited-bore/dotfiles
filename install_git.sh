echo "$(tput setaf 6)This script uses $(tput setaf 2)rlwrap$(tput setaf 6) and $(tput setaf 2)fzf$(tput sgr0).";

if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi

if ! type update-system &> /dev/null; then
    if ! test -f aliases/.bash_aliases.d/update-system.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/update-system.sh)" 
    else
        . ./aliases/.bash_aliases.d/update-system.sh
    fi
fi

if test -z $SYSTEM_UPDATED; then
    reade -Q "CYAN" -i "n" -p "Update system? [Y/n]: " "y" updatesysm
    if test $updatesysm == "y"; then
        update-system                     
    fi
fi

if ! test -f aliases/.bash_aliases.d/00-rlwrap_scripts.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/00-rlwrap_scripts.sh)" 
else
    . ./aliases/.bash_aliases.d/00-rlwrap_scripts.sh
fi

if ! test -f checks/check_pathvar.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_pathvar.sh)" 
else
    . ./checks/check_pathvar.sh
fi

#if ! type fzf &> /dev/null ; then
#   if ! test -f ./install_fzf.sh; then
#        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/install_fzf.sh)" 
#    else
#        ./install_fzf.sh
#    fi 
#fi

git_hl(){
    if ! test -z "$1"; then
        cmd="$1"
    else
        cmd="git config --global interactive.difffilter"
    fi

    local diffs=""
    local diff=""
    if type delta &> /dev/null ; then
        diffs=$diffs" delta"
        diff="delta"
    fi
    if type ydiff &> /dev/null ; then
        diffs=$diffs" ydiff"
        diff="delta"
    fi
    if type riff &> /dev/null ; then
        diffs=$diffs" riff"
        diff="riff"
    fi
    if type diffr &> /dev/null ; then
        diffs=$diffs" diffr"
        diff="diffr"
    fi
    if type diff-so-fancy &> /dev/null ; then
        diffs=$diffs" diff-so-fancy"
        diff="diff-so-fancy"
    fi
    if type batdiff &> /dev/null ; then
        diffs=$diffs" batdiff"
        diff="batdiff"
    fi
    
    reade -Q "GREEN" -i "$diff" -p "Diff filter: " "$diffs" diff
    if ! test -z $diff; then
        reade -Q "CYAN" -i "y" -p "You selected $diff. Configure? [Y/n]: " "n" conf
        if [ "$diff" == "delta" ]; then
            diff="delta --color-only --paging=never"
            
            if test "y" == "$conf"; then
                reade -Q "CYAN" -i "y" -p "Set syntax-theme [Y/n]: " "n" delta1
                if test "$delta1" == 'y'; then
                    echo "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Sollicitudin nibh sit amet commodo nulla facilisi. Sed cras ornare arcu dui vivamus arcu. Non quam lacus suspendisse faucibus interdum posuere lorem. Consequat ac felis donec et odio pellentesque. Elementum tempus egestas sed sed risus pretium quam. Neque viverra justo nec ultrices dui sapien eget mi proin. Varius vel pharetra vel turpis nunc eget lorem dolor sed. Mauris in aliquam sem fringilla ut morbi tincidunt augue. Cursus euismod quis viverra nibh cras. Diam sollicitudin tempor id eu. Lectus arcu bibendum at varius vel. Posuere morbi leo urna molestie at elementum eu facilisis. Condimentum lacinia quis vel eros. Dolor magna eget est lorem ipsum dolor sit amet consectetur. Ultrices dui sapien eget mi. A arcu cursus vitae congue mauris.

In pellentesque massa placerat duis ultricies lacus sed turpis tincidunt. Dignissim diam quis enim lobortis scelerisque fermentum. Faucibus purus in massa tempor nec. Enim neque volutpat ac tincidunt. Penatibus et magnis dis parturient montes nascetur ridiculus. Ornare aenean euismod elementum nisi quis eleifend quam adipiscing. Elementum pulvinar etiam non quam lacus suspendisse faucibus interdum. Vel eros donec ac odio tempor orci dapibus ultrices. Tempus imperdiet nulla malesuada pellentesque elit eget gravida. In ante metus dictum at tempor commodo ullamcorper.

Feugiat sed lectus vestibulum mattis ullamcorper velit sed ullamcorper. Aliquet nibh praesent tristique magna sit amet purus. Dignissim diam quis enim lobortis scelerisque. Turpis egestas sed tempus urna et. Est sit amet facilisis magna. At tellus at urna condimentum mattis pellentesque. Bibendum ut tristique et egestas quis ipsum suspendisse ultrices. Diam sollicitudin tempor id eu. Vulputate sapien nec sagittis aliquam malesuada bibendum arcu vitae elementum. Aliquet nibh praesent tristique magna sit. Dictum fusce ut placerat orci nulla pellentesque dignissim enim. Laoreet sit amet cursus sit amet dictum. Amet consectetur adipiscing elit duis tristique. Phasellus vestibulum lorem sed risus ultricies tristique nulla aliquet.

Eu augue ut lectus arcu bibendum at varius vel pharetra. Urna nunc id cursus metus. Massa eget egestas purus viverra. Ornare quam viverra orci sagittis eu volutpat odio facilisis. Ornare arcu dui vivamus arcu felis bibendum. Sollicitudin aliquam ultrices sagittis orci a. In eu mi bibendum neque egestas congue quisque egestas diam. Consectetur adipiscing elit duis tristique sollicitudin nibh sit amet commodo. Risus in hendrerit gravida rutrum quisque non. Justo eget magna fermentum iaculis eu. Ut consequat semper viverra nam libero justo laoreet sit. Vel pretium lectus quam id leo in vitae turpis. Praesent semper feugiat nibh sed pulvinar.

Condimentum lacinia quis vel eros donec ac. Nibh sed pulvinar proin gravida hendrerit lectus a. Volutpat consequat mauris nunc congue nisi vitae suscipit tellus. Mi tempus imperdiet nulla malesuada pellentesque elit eget. Scelerisque in dictum non consectetur. Ac ut consequat semper viverra nam libero justo laoreet sit. Lectus magna fringilla urna porttitor rhoncus. Integer vitae justo eget magna fermentum. Nisl pretium fusce id velit ut. In aliquam sem fringilla ut morbi tincidunt augue. Vitae tempus quam pellentesque nec nam aliquam sem et. Eget mauris pharetra et ultrices neque. At augue eget arcu dictum. Eget duis at tellus at. Mauris ultrices eros in cursus turpis massa tincidunt dui. Aliquet nec ullamcorper sit amet. Eu feugiat pretium nibh ipsum consequat nisl vel pretium lectus." > $TMPDIR/dtest1
               echo "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Malesuada fames ac turpis egestas sed tempus urna. Maecenas volutpat blandit aliquam etiam erat velit scelerisque in. Cras fermentum odio eu feugiat pretium nibh ipsum consequat. Nam aliquam sem et tortor consequat id. Habitasse platea dictumst vestibulum rhoncus est pellentesque. Pellentesque habitant morbi tristique senectus et netus et malesuada fames. Mattis molestie a iaculis at erat pellentesque adipiscing. Condimentum lacinia quis vel eros donec ac odio. Vitae congue eu consequat ac. Netus et malesuada fames ac. Sed euismod nisi porta lorem mollis aliquam. Rhoncus est pellentesque elit ullamcorper dignissim cras. Aliquet nibh praesent tristique magna sit amet purus. Odio ut sem nulla pharetra diam sit amet nisl. Bibendum est ultricies integer quis auctor elit sed vulputate mi. Viverra ipsum nunc aliquet bibendum enim facilisis gravida neque convallis.

Sociis natoque penatibus et magnis dis parturient montes. Ornare suspendisse sed nisi lacus sed viverra tellus. Eu augue ut lectus arcu bibendum at varius vel. Morbi leo urna molestie at elementum eu facilisis sed. Integer quis auctor elit sed vulputate mi. At varius vel pharetra vel. Ut consequat semper viverra nam libero. Metus vulputate eu scelerisque felis. In hendrerit gravida rutrum quisque non tellus orci. Eget gravida cum sociis natoque penatibus et magnis. Nec tincidunt praesent semper feugiat nibh sed. Id velit ut tortor pretium. Nibh cras pulvinar mattis nunc sed blandit. Augue neque gravida in fermentum et sollicitudin ac orci phasellus. Ut porttitor leo a diam sollicitudin tempor id. Nec feugiat nisl pretium fusce id velit. Amet purus gravida quis blandit turpis cursus in. Blandit libero volutpat sed cras ornare.

Vestibulum sed arcu non odio euismod lacinia. Cursus in hac habitasse platea dictumst quisque sagittis. Augue eget arcu dictum varius duis at consectetur. Eget egestas purus viverra accumsan in nisl nisi scelerisque eu. Turpis tincidunt id aliquet risus feugiat. Ultrices gravida dictum fusce ut placerat orci. Ullamcorper a lacus vestibulum sed arcu non odio euismod. Dictum fusce ut placerat orci nulla pellentesque dignissim enim. Arcu cursus vitae congue mauris rhoncus aenean vel elit scelerisque. Ornare quam viverra orci sagittis. Tincidunt nunc pulvinar sapien et ligula. Malesuada pellentesque elit eget gravida cum sociis. Non nisi est sit amet facilisis magna etiam. Mauris cursus mattis molestie a iaculis at erat. Praesent tristique magna sit amet. Blandit aliquam etiam erat velit scelerisque in. Urna et pharetra pharetra massa massa ultricies mi. Ultricies leo integer malesuada nunc vel risus commodo. Pellentesque adipiscing commodo elit at imperdiet dui accumsan sit amet.

Tortor aliquam nulla facilisi cras fermentum. A arcu cursus vitae congue mauris rhoncus. Ac orci phasellus egestas tellus rutrum tellus. Eget sit amet tellus cras. Ornare lectus sit amet est placerat in egestas erat. Dis parturient montes nascetur ridiculus. Ut eu sem integer vitae. Viverra orci sagittis eu volutpat odio facilisis mauris sit amet. Enim eu turpis egestas pretium aenean pharetra magna ac. Molestie nunc non blandit massa enim. Felis imperdiet proin fermentum leo vel orci porta non. Nibh mauris cursus mattis molestie a iaculis at erat. Elementum nibh tellus molestie nunc non blandit massa enim nec. Fringilla est ullamcorper eget nulla facilisi etiam dignissim diam quis. Lectus magna fringilla urna porttitor. Dictum fusce ut placerat orci nulla pellentesque dignissim enim. Sed id semper risus in. Nascetur ridiculus mus mauris vitae ultricies.

Vitae suscipit tellus mauris a. Sed elementum tempus egestas sed sed. Est placerat in egestas erat imperdiet sed euismod nisi porta. Nulla aliquet porttitor lacus luctus accumsan. Consequat semper viverra nam libero justo laoreet. Ut diam quam nulla porttitor massa id neque aliquam vestibulum. Cursus metus aliquam eleifend mi. Viverra nam libero justo laoreet sit amet. Malesuada fames ac turpis egestas maecenas pharetra convallis posuere morbi. Orci ac auctor augue mauris augue neque gravida. Sed libero enim sed faucibus turpis in eu mi bibendum. Tellus pellentesque eu tincidunt tortor aliquam nulla facilisi cras fermentum. Scelerisque purus semper eget duis at tellus at urna. Pellentesque habitant morbi tristique senectus. In metus vulputate eu scelerisque felis imperdiet proin fermentum leo. Vulputate mi sit amet mauris commodo quis imperdiet massa tincidunt." > $TMPDIR/dtest2
                local theme=''
                while test -z "$theme"; do
                    theme=$(printf "$(delta --list-syntax-themes | tail -n +1)" | fzf --reverse --border --border-label="Syntax theme")
                    theme=$(echo "$theme" | awk '{$1=""; print $0;}')
                    delta --syntax-theme "${theme:1}" $TMPDIR/dtest1 $TMPDIR/dtest2
                    stty sane && reade -Q "MAGENTA" -i "n" -p "Set as syntax theme? (Will retry if no) [N/y]: " "y" dltthme
                    if test "$dltthme" == "n"; then
                       theme='' 
                    fi
                done
                    pager=$pager" $theme"
                fi
                reade -Q "CYAN" -i "y" -p "Set linenumbers? [Y/n]: " "n" delta3
                if test "y" == $delta3; then
                    git config $global delta.linenumbers true
                fi
                
                reade -Q "CYAN" -i "y" -p "Side-by-side view? [Y/n]: " "n" delta3
                if test "y" == $delta3; then
                    git config $global delta.side-by-side true
                fi

                reade -Q "CYAN" -i "y" -p "Set to navigate? (Move between diff sections using n and N) [Y/n]: " "n" delta1
                if test "y" == $delta1; then
                    git config $global delta.navigate true
                fi 

                reade -Q "CYAN" -i "y" -p "Set to dark? [Y/n]: " "n" delta2
                if test "y" == $delta2; then
                    git config $global delta.dark true
                fi

                reade -Q "CYAN" -i "y" -p "Set hyperlinks? [Y/n]: " "n" delta1
                if test "y" == $delta1; then
                    git config $global delta.hyperlinks true
                fi
            fi

        elif [ "$diff" == "diff-so-fancy" ]; then
            diff="diff-so-fancy --patch"
            reade -Q "CYAN" -i "y" -p "You selected $diff. Configure? [Y/n]: " "n" difffancy
            if test "$difffancy" == "y"; then
                reade -Q "CYAN" -i "y" -p "Should the first block of an empty line be colored. (Default: true)? [Y/n]: " "n" diffancy
                if test "y" == $diffancy; then
                    git config --bool $global diff-so-fancy.markEmptyLines true                    
                else
                    git config --bool $global diff-so-fancy.markEmptyLines false                    
                fi
                reade -Q "CYAN" -i "y" -p "Simplify git header chunks to a more human readable format. (Default: true) [Y/n]: " "n" diffancy
                if test "y" == $diffancy; then
                    git config --bool $global diff-so-fancy.changeHunkIndicators true
                else
                    git config --bool $global diff-so-fancy.changeHunkIndicators false
                fi
                reade -Q "CYAN" -i "y" -p "Should the pesky + or - at line-start be removed. (Default: true) [Y/n]: " "n" diffancy
                if test "y" == $diffancy; then
                    git config --bool $global diff-so-fancy.stripLeadingSymbols true
                else
                    git config --bool $global diff-so-fancy.stripLeadingSymbols false
                fi
                reade -Q "CYAN" -i "y" -p "By default, the separator for the file header uses Unicode line-drawing characters. If this is causing output errors on your terminal, set this to false to use ASCII characters instead. (Default: true) [Y/n]: " "n" diffancy
                if test "y" == $diffancy; then
                    git config --bool $global diff-so-fancy.useUnicodeRuler true
                else
                    git config --bool $global diff-so-fancy.useUnicodeRuler false
                fi
                reade -Q "CYAN" -i "47" -p "By default, the separator for the file header spans the full width of the terminal. Use this setting to set the width of the file header manually. (Default: 47): " "$(seq 1 100)" diffancy
                 # git log's commit header width
                git config --global diff-so-fancy.rulerWidth $diffancy    
            elif [ "$diff" == "riff" ]; then
                diff="riff --no-pager"
                reade -Q "CYAN" -i "y" -p "Ignore changes in amount of whitespace? [Y/n]: " riff1
                if test "$riff1" == 'y'; then
                    diff=$diff" -b"
                fi
                reade -Q "CYAN" -i "y" -p "No special highlighting for lines that only add content? [Y/n]: " riff1
                if test "$riff1" == 'y'; then
                    diff=$diff" --no-adds-only-special"
                fi
            fi
        elif [ "$diff" == "ydiff" ]; then
            diff=$diff" --color=auto"
            reade -Q "CYAN" -i "y" -p "You selected $diff. Configure? [Y/n]: " "n" conf
            if test "y" == "$conf"; then
                reade -Q "CYAN" -i "y" -p "Enable side-by-side mode? [Y/n]: " 'n' diffr1
                if test "$diffr1" == 'y'; then
                    diff=$diff" --side-by-side"
                    reade -Q "CYAN" -i "y" -p "Wrap long lines in side-by-side view? [Y/n]: " 'n' diffr1
                    if test "$diffr1" == 'y'; then
                        diff=$diff" --wrap"
                    fi        
                fi
            fi
        elif [ "$diff" == "diffr" ]; then
            reade -Q "CYAN" -i "y" -p "You selected $diff. Configure? [Y/n]: " "n" conf
            if test "y" == "$conf"; then
                reade -Q "CYAN" -i "y" -p "Set linenumber? [Y/n]: " diffr1
                if test "$diffr1" == 'y'; then
                    diff="diffr --line-numbers"
                    reade -Q "CYAN" -i "n" -p "Set linenumber style? [compact/aligned/n]: " diffr1
                    if test "$diffr1" == 'compact' || test "$diffr1" == 'aligned'; then
                        diff="diffr --line-numbers $diffr1"
                    fi
                fi
            fi
        elif [ "$diff" == "batdiff" ]; then
              reade -Q "CYAN" -i "y" -p "You selected $diff. Configure? [Y/n]: " "n" conf
              if test "y" == "$conf"; then 
                  diff="batdiff --staged --paging=never"
                  reade -Q "CYAN" -i "n" -p "Use delta config? [Y/n]: " diffr1
                  if test "$diffr1" == 'y'; then
                        diff=$diff" --delta"
                  fi
            fi
        fi
    fi

    if [[ "$cmd" =~ 'difffilter' ]] ; then
        eval "$cmd $diff"
    elif [[ "$cmd" =~ 'lazygit' ]]; then
        sed -i 's|useConfig:|#useConfig:|g' ~/.config/lazygit/config.yml 
        if ! grep -q "pager" ~/.config/lazygit/config.yml; then
            sed -i 's|\(paging:\)|\1\n    pager: '"$diff"'|g' ~/.config/lazygit/config.yml 
        else               
            sed -i 's|pager:.*|pager: '"$diff"'|g' ~/.config/lazygit/config.yml; 
        fi
    fi
}

git_pager(){
local gitpgr cpager pager pagers global regpager colors 
cpager="$1"
if ! test -z "$2"; then
    global="$2"
else
    global="--global"
fi

reade -Q "YELLOW" -i "n" -p "Turn off pager? [N/y]: " "y" pipepager1
if test "$pipepager1" == 'y'; then 
     git config $global "$cpager" false  
else
#reade -Q "CYAN" -i "n" -p "Set $cpager to prevent paging? [N/y]: " "n" regpager ;
#regpager="$(printf "yes\nno\n" | fzf --border --border-label="Set pager instead of output only?" --reverse)"
#if test "$regpager" == "n"; then
        
    pagers="cat less more"
    pagersf="cat\nless\nmore\n"
    pager="less"
    
    if type most &> /dev/null ; then
        pagers=$pagers" most"
        pagersf=$pagersf"most\n"
    fi
    if type moar &> /dev/null ; then
        pagers=$pagers" moar"
        pagersf=$pagersf"moar\n"
        pager="moar"
    fi
    if type bat &> /dev/null ; then
        pagers=$pagers" bat"
        pagersf=$pagersf"bat\n"
    fi
    if type batdiff &> /dev/null ; then
        pagers=$pagers" batdiff"
        pagersf=$pagersf"batdiff\n"
        pager="batdiff"
    fi
    if type vimpager &> /dev/null; then
        pagers=$pagers" vimpager"
        pagersf=$pagersf"vimpager\n"
        pager="vimpager"
    fi
    if type nvimpager &> /dev/null; then
        pagers=$pagers" nvimpager"
        pagersf=$pagersf"nvimpager\n"
        pager="nvimpager"
    fi
    if type ydiff &> /dev/null; then
        pagers=$pagers" ydiff"
        pagersf=$pagersf"ydiff\n"
        pager="ydiff"
    fi
    if type diffr &> /dev/null; then
        pagers=$pagers" diffr"
        pagersf=$pagersf"diffr\n"
        pager="diffr"
    fi
    if type riff &> /dev/null; then
        pagers=$pagers" riff"
        pagersf=$pagersf"riff\n"
        pager="riff"
    fi
    if type diff-so-fancy &> /dev/null; then
        pagers=$pagers" diff-so-fancy"
        pagersf=$pagersf"diff-so-fancy\n"
        pager="diff-so-fancy"
    fi
    if type delta &> /dev/null; then
        pagers=$pagers" delta"
        pagersf=$pagersf"delta\n"
        pager="delta"
    fi
    
    
    if test $pager == 'less'; then
        local ln="-R"
        reade -Q "CYAN" -i "y" -p "You selected $pager. Quit if one screen? [Y/n]: " "n" pager1
        if test $pager1 == 'y'; then
            ln=$ln"--quit-if-one-screen"
        fi
        reade -Q "CYAN" -i "n" -p "Set linenumbers for pager? [N/y]: " "n" lne 
        if test "$lne" == 'n'; then
           ln=$ln"-n"
        else
           ln=$ln"-N"
        fi
    elif [ "$pager" == "moar" ]; then
        reade -Q "CYAN" -i "y" -p "You chose $pager. Quit if on one screen? [Y/n]: " "n" pager1
        if test $pager1 == 'y'; then
            pager=$pager' --quit-if-one-screen'
        fi
        reade -Q "CYAN" -i "y" -p "You selected $pager. Set style? [Y/n]: " "n" pager1
        if test $pager1 == 'y'; then
            local theme
            local styles="abap\nalgol\nalgol_nu\napi\narduino\nautumn\naverage\nbase16-snazzy\nborland\nbw\ncatppuccin-frappe\ncatppuccin-latte\ncatppuccin-macchiato\ncatppuccin-mocha\ncolorful\ncompat\ndoom-one\ndoom-one2\ndracula\nemacs\nfriendly\nfruity\ngithub-dark\ngithub\ngruvbox-light\ngruvbox\nhr_high_contrast\nhrdark\nigor\nlovelace\nmanni\nmodus-operandi\nmodus-vivendi\nmonokai\nmonokailight\nmurphy\nnative\nnord\nonedark\nonesenterprise\nparaiso-dark\nparaiso-light\npastie\nperldoc\npygments\nrainbow_dash\nrose-pine-dawn\nrose-pine-moon\nrose-pine\nrrt\nsolarized-dark\nsolarized-dark256\nsolarized-light\nswapoff\ntango\ntrac\nvim\nvs\nvulcan\nwitchhazel\nxcode-dark\nxcode"
            echo "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Sollicitudin nibh sit amet commodo nulla facilisi. Sed cras ornare arcu dui vivamus arcu. Non quam lacus suspendisse faucibus interdum posuere lorem. Consequat ac felis donec et odio pellentesque. Elementum tempus egestas sed sed risus pretium quam. Neque viverra justo nec ultrices dui sapien eget mi proin. Varius vel pharetra vel turpis nunc eget lorem dolor sed. Mauris in aliquam sem fringilla ut morbi tincidunt augue. Cursus euismod quis viverra nibh cras. Diam sollicitudin tempor id eu. Lectus arcu bibendum at varius vel. Posuere morbi leo urna molestie at elementum eu facilisis. Condimentum lacinia quis vel eros. Dolor magna eget est lorem ipsum dolor sit amet consectetur. Ultrices dui sapien eget mi. A arcu cursus vitae congue mauris.

In pellentesque massa placerat duis ultricies lacus sed turpis tincidunt. Dignissim diam quis enim lobortis scelerisque fermentum. Faucibus purus in massa tempor nec. Enim neque volutpat ac tincidunt. Penatibus et magnis dis parturient montes nascetur ridiculus. Ornare aenean euismod elementum nisi quis eleifend quam adipiscing. Elementum pulvinar etiam non quam lacus suspendisse faucibus interdum. Vel eros donec ac odio tempor orci dapibus ultrices. Tempus imperdiet nulla malesuada pellentesque elit eget gravida. In ante metus dictum at tempor commodo ullamcorper.

Feugiat sed lectus vestibulum mattis ullamcorper velit sed ullamcorper. Aliquet nibh praesent tristique magna sit amet purus. Dignissim diam quis enim lobortis scelerisque. Turpis egestas sed tempus urna et. Est sit amet facilisis magna. At tellus at urna condimentum mattis pellentesque. Bibendum ut tristique et egestas quis ipsum suspendisse ultrices. Diam sollicitudin tempor id eu. Vulputate sapien nec sagittis aliquam malesuada bibendum arcu vitae elementum. Aliquet nibh praesent tristique magna sit. Dictum fusce ut placerat orci nulla pellentesque dignissim enim. Laoreet sit amet cursus sit amet dictum. Amet consectetur adipiscing elit duis tristique. Phasellus vestibulum lorem sed risus ultricies tristique nulla aliquet.

Eu augue ut lectus arcu bibendum at varius vel pharetra. Urna nunc id cursus metus. Massa eget egestas purus viverra. Ornare quam viverra orci sagittis eu volutpat odio facilisis. Ornare arcu dui vivamus arcu felis bibendum. Sollicitudin aliquam ultrices sagittis orci a. In eu mi bibendum neque egestas congue quisque egestas diam. Consectetur adipiscing elit duis tristique sollicitudin nibh sit amet commodo. Risus in hendrerit gravida rutrum quisque non. Justo eget magna fermentum iaculis eu. Ut consequat semper viverra nam libero justo laoreet sit. Vel pretium lectus quam id leo in vitae turpis. Praesent semper feugiat nibh sed pulvinar.

Condimentum lacinia quis vel eros donec ac. Nibh sed pulvinar proin gravida hendrerit lectus a. Volutpat consequat mauris nunc congue nisi vitae suscipit tellus. Mi tempus imperdiet nulla malesuada pellentesque elit eget. Scelerisque in dictum non consectetur. Ac ut consequat semper viverra nam libero justo laoreet sit. Lectus magna fringilla urna porttitor rhoncus. Integer vitae justo eget magna fermentum. Nisl pretium fusce id velit ut. In aliquam sem fringilla ut morbi tincidunt augue. Vitae tempus quam pellentesque nec nam aliquam sem et. Eget mauris pharetra et ultrices neque. At augue eget arcu dictum. Eget duis at tellus at. Mauris ultrices eros in cursus turpis massa tincidunt dui. Aliquet nec ullamcorper sit amet. Eu feugiat pretium nibh ipsum consequat nisl vel pretium lectus." > $TMPDIR/dtest1
            while test -z "$style"; do
                style=$(printf "$styles" | fzf --reverse --border --border-label="Moar style")
                moar --style "$style" $TMPDIR/dtest1
                stty sane && reade -Q "CYAN" -i "n" -p "Set as style? (Will retry if no) [N/y]: " 'y' thme
                if test "$thme" == "n"; then
                   style='' 
                fi
            done
            pager=$pager" $style"
        fi 
        reade -Q "CYAN" -i "y" -p "Show linenumber? [Y/n]: " "n" pager1
        if test $pager1 == 'n'; then
            pager=$pager' --no-linenumbers'
        fi
        reade -Q "CYAN" -i "n" -p "Wrap long lines? [N/y]: " "y" pager1
        if test $pager1 == 'y'; then
            pager=$pager' --wrap'
        fi
    elif [ "$pager" == "nvimpager" ] || [ "$pager" == "vimpager" ] ; then
        echo "You selected $pager."
        colors="blue darkblue default delek desert elflord evening gruvbox habamax industry koehler lunaperch morning murphy pablo peachpuff quiet ron shine slate torte zellner"
        if test "$pager" == "vimpager"; then
           colors=$colors" retrobox sorbet wildcharm zaibatsu" 
        fi
        pager="$pager"
        reade -Q "CYAN" -i "y" -p "Set colorscheme? [Y/n]: " "n" pager1
        if [ "$pager1" == "y" ]; then
            reade -Q "CYAN" -i "default" -p "Colorscheme: " "$colors" color
            pager="$pager +'colorscheme $color'"
        fi
    elif [ "$pager" == "riff" ]; then
            pager="riff"
            reade -Q "CYAN" -i "y" -p "Ignore changes in amount of whitespace? [Y/n]: " riff1
            if test "$riff1" == 'y'; then
                pager=$pager" -b"
            fi
            reade -Q "CYAN" -i "y" -p "No special highlighting for lines that only add content? [Y/n]: " riff1
            if test "$riff1" == 'y'; then
                pager=$pager" --no-adds-only-special"
            fi
    elif [ "$pager" == "diff-so-fancy" ] || [ "$pager" == "diffr" ] || [ "$pager" == "ydiff" ] || [ "$pager" == "delta" ] || [ "$pager" == "bat" ] || [ "$pager" == "batdiff" ] ; then
        local difffancy
        local pre='y'
        local prmpt='[Y/n]: ' 
        local othr='n' 
        if (test $pager == 'delta' || test $pager == 'diff-so-fancy') && echo $(git config $global --list --show-origin) | grep -q $pager; then
            pre='n'
            prmpt='[N/y]: ' 
            othr='y' 
        fi
        reade -Q "CYAN" -i "$pre" -p "You selected $pager. Configure? $prmpt" "$othr" difffancy
        if test "y" == "$difffancy"; then
            if [ "$pager" == "bat" ] || [ "$pager" == "batdiff" ]; then 
                local opts=""
                reade -Q "CYAN" -i "y" -p "Set styles? (line numbers/grid) [Y/n]: " "n" delta2
                local theme='changes'
                if test "y" == $delta2; then
                    while : ; do
                        local style=''
                        style=$(printf "full\nauto\nplain\nchanges\nheader\nheader-filename\nheader-filesize\ngrid\nrule\nnumbers\nsnip\n" | fzf --border --border-label="Bat styles")
                        stty sane && reade -Q "MAGENTA" -i "o" -p "Add to styles/Only use this style/Dont use? (Will retry if add) [A/o/n]: " "a o n" dltthme
                        if test "$dltthme" == "a" ; then
                            theme=$theme","$style
                        elif test "$dltthme" == "o" ; then
                            theme=$theme","$style
                            break;
                        else
                           break;
                        fi
                    done
                    opts=$opts" --style='$theme'"
                fi 
                reade -Q "CYAN" -i "y" -p "Set syntax-theme [Y/n]: " "n" delta1
                if test "y" == $delta1; then
                    echo "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Sollicitudin nibh sit amet commodo nulla facilisi. Sed cras ornare arcu dui vivamus arcu. Non quam lacus suspendisse faucibus interdum posuere lorem. Consequat ac felis donec et odio pellentesque. Elementum tempus egestas sed sed risus pretium quam. Neque viverra justo nec ultrices dui sapien eget mi proin. Varius vel pharetra vel turpis nunc eget lorem dolor sed. Mauris in aliquam sem fringilla ut morbi tincidunt augue. Cursus euismod quis viverra nibh cras. Diam sollicitudin tempor id eu. Lectus arcu bibendum at varius vel. Posuere morbi leo urna molestie at elementum eu facilisis. Condimentum lacinia quis vel eros. Dolor magna eget est lorem ipsum dolor sit amet consectetur. Ultrices dui sapien eget mi. A arcu cursus vitae congue mauris.

In pellentesque massa placerat duis ultricies lacus sed turpis tincidunt. Dignissim diam quis enim lobortis scelerisque fermentum. Faucibus purus in massa tempor nec. Enim neque volutpat ac tincidunt. Penatibus et magnis dis parturient montes nascetur ridiculus. Ornare aenean euismod elementum nisi quis eleifend quam adipiscing. Elementum pulvinar etiam non quam lacus suspendisse faucibus interdum. Vel eros donec ac odio tempor orci dapibus ultrices. Tempus imperdiet nulla malesuada pellentesque elit eget gravida. In ante metus dictum at tempor commodo ullamcorper.

Feugiat sed lectus vestibulum mattis ullamcorper velit sed ullamcorper. Aliquet nibh praesent tristique magna sit amet purus. Dignissim diam quis enim lobortis scelerisque. Turpis egestas sed tempus urna et. Est sit amet facilisis magna. At tellus at urna condimentum mattis pellentesque. Bibendum ut tristique et egestas quis ipsum suspendisse ultrices. Diam sollicitudin tempor id eu. Vulputate sapien nec sagittis aliquam malesuada bibendum arcu vitae elementum. Aliquet nibh praesent tristique magna sit. Dictum fusce ut placerat orci nulla pellentesque dignissim enim. Laoreet sit amet cursus sit amet dictum. Amet consectetur adipiscing elit duis tristique. Phasellus vestibulum lorem sed risus ultricies tristique nulla aliquet.

Eu augue ut lectus arcu bibendum at varius vel pharetra. Urna nunc id cursus metus. Massa eget egestas purus viverra. Ornare quam viverra orci sagittis eu volutpat odio facilisis. Ornare arcu dui vivamus arcu felis bibendum. Sollicitudin aliquam ultrices sagittis orci a. In eu mi bibendum neque egestas congue quisque egestas diam. Consectetur adipiscing elit duis tristique sollicitudin nibh sit amet commodo. Risus in hendrerit gravida rutrum quisque non. Justo eget magna fermentum iaculis eu. Ut consequat semper viverra nam libero justo laoreet sit. Vel pretium lectus quam id leo in vitae turpis. Praesent semper feugiat nibh sed pulvinar.

Condimentum lacinia quis vel eros donec ac. Nibh sed pulvinar proin gravida hendrerit lectus a. Volutpat consequat mauris nunc congue nisi vitae suscipit tellus. Mi tempus imperdiet nulla malesuada pellentesque elit eget. Scelerisque in dictum non consectetur. Ac ut consequat semper viverra nam libero justo laoreet sit. Lectus magna fringilla urna porttitor rhoncus. Integer vitae justo eget magna fermentum. Nisl pretium fusce id velit ut. In aliquam sem fringilla ut morbi tincidunt augue. Vitae tempus quam pellentesque nec nam aliquam sem et. Eget mauris pharetra et ultrices neque. At augue eget arcu dictum. Eget duis at tellus at. Mauris ultrices eros in cursus turpis massa tincidunt dui. Aliquet nec ullamcorper sit amet. Eu feugiat pretium nibh ipsum consequat nisl vel pretium lectus." > $TMPDIR/dtest1
                    local theme=''
                    
                    while test -z "$theme"; do
                        theme=$(bat --list-themes | fzf --border --border-label="Bat syntax themes" --preview="bat --theme={} --color=always $TMPDIR/dtest1")
                        stty sane && reade -Q "MAGENTA" -i "n" -p "Set $theme as syntax theme? (Will retry if no) [Y/n]: " "n" dltthme
                        if test "$dltthme" == "n"; then
                           theme='' 
                        fi
                    done
                    opts=$opts" --theme=$theme"
                fi

                reade -Q "CYAN" -i "n" -p "Set to specific language? (Useful if you're using an obscure language that bat can't autodetect) [Y/n]: " "n" delta2
                if test "y" == $delta2; then
                    local theme=''
                    
                    while test -z "$theme"; do
                        theme=$(bat --list-languages | fzf --border --border-label="Bat coding languages")
                        stty sane && reade -Q "MAGENTA" -i "n" -p "Set syntax to specifically use $theme as language? (Will retry if no) [Y/n]: " "n" dltthme
                        if test "$dltthme" == "n"; then
                           theme='' 
                        fi
                    done
                    opts=$opts" --language=$theme"
                fi
                pager=$pager" $opts"
            elif [ "$pager" == "delta" ]; then
                reade -Q "CYAN" -i "y" -p "Set side-by-side view? [Y/n]: " "n" delta1
                if test "y" == $delta1; then
                    git config $global delta.side-by-side true
                fi

                reade -Q "CYAN" -i "y" -p "Set to navigate? (Move between diff sections using n and N) [Y/n]: " "n" delta1
                if test "y" == $delta1; then
                    git config $global delta.navigate true
                fi 

                reade -Q "CYAN" -i "y" -p "Set syntax-theme [Y/n]: " "n" delta1
                if test "y" == $delta1; then
                    echo "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Sollicitudin nibh sit amet commodo nulla facilisi. Sed cras ornare arcu dui vivamus arcu. Non quam lacus suspendisse faucibus interdum posuere lorem. Consequat ac felis donec et odio pellentesque. Elementum tempus egestas sed sed risus pretium quam. Neque viverra justo nec ultrices dui sapien eget mi proin. Varius vel pharetra vel turpis nunc eget lorem dolor sed. Mauris in aliquam sem fringilla ut morbi tincidunt augue. Cursus euismod quis viverra nibh cras. Diam sollicitudin tempor id eu. Lectus arcu bibendum at varius vel. Posuere morbi leo urna molestie at elementum eu facilisis. Condimentum lacinia quis vel eros. Dolor magna eget est lorem ipsum dolor sit amet consectetur. Ultrices dui sapien eget mi. A arcu cursus vitae congue mauris.

In pellentesque massa placerat duis ultricies lacus sed turpis tincidunt. Dignissim diam quis enim lobortis scelerisque fermentum. Faucibus purus in massa tempor nec. Enim neque volutpat ac tincidunt. Penatibus et magnis dis parturient montes nascetur ridiculus. Ornare aenean euismod elementum nisi quis eleifend quam adipiscing. Elementum pulvinar etiam non quam lacus suspendisse faucibus interdum. Vel eros donec ac odio tempor orci dapibus ultrices. Tempus imperdiet nulla malesuada pellentesque elit eget gravida. In ante metus dictum at tempor commodo ullamcorper.

Feugiat sed lectus vestibulum mattis ullamcorper velit sed ullamcorper. Aliquet nibh praesent tristique magna sit amet purus. Dignissim diam quis enim lobortis scelerisque. Turpis egestas sed tempus urna et. Est sit amet facilisis magna. At tellus at urna condimentum mattis pellentesque. Bibendum ut tristique et egestas quis ipsum suspendisse ultrices. Diam sollicitudin tempor id eu. Vulputate sapien nec sagittis aliquam malesuada bibendum arcu vitae elementum. Aliquet nibh praesent tristique magna sit. Dictum fusce ut placerat orci nulla pellentesque dignissim enim. Laoreet sit amet cursus sit amet dictum. Amet consectetur adipiscing elit duis tristique. Phasellus vestibulum lorem sed risus ultricies tristique nulla aliquet.

Eu augue ut lectus arcu bibendum at varius vel pharetra. Urna nunc id cursus metus. Massa eget egestas purus viverra. Ornare quam viverra orci sagittis eu volutpat odio facilisis. Ornare arcu dui vivamus arcu felis bibendum. Sollicitudin aliquam ultrices sagittis orci a. In eu mi bibendum neque egestas congue quisque egestas diam. Consectetur adipiscing elit duis tristique sollicitudin nibh sit amet commodo. Risus in hendrerit gravida rutrum quisque non. Justo eget magna fermentum iaculis eu. Ut consequat semper viverra nam libero justo laoreet sit. Vel pretium lectus quam id leo in vitae turpis. Praesent semper feugiat nibh sed pulvinar.

Condimentum lacinia quis vel eros donec ac. Nibh sed pulvinar proin gravida hendrerit lectus a. Volutpat consequat mauris nunc congue nisi vitae suscipit tellus. Mi tempus imperdiet nulla malesuada pellentesque elit eget. Scelerisque in dictum non consectetur. Ac ut consequat semper viverra nam libero justo laoreet sit. Lectus magna fringilla urna porttitor rhoncus. Integer vitae justo eget magna fermentum. Nisl pretium fusce id velit ut. In aliquam sem fringilla ut morbi tincidunt augue. Vitae tempus quam pellentesque nec nam aliquam sem et. Eget mauris pharetra et ultrices neque. At augue eget arcu dictum. Eget duis at tellus at. Mauris ultrices eros in cursus turpis massa tincidunt dui. Aliquet nec ullamcorper sit amet. Eu feugiat pretium nibh ipsum consequat nisl vel pretium lectus." > $TMPDIR/dtest1
                   echo "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Malesuada fames ac turpis egestas sed tempus urna. Maecenas volutpat blandit aliquam etiam erat velit scelerisque in. Cras fermentum odio eu feugiat pretium nibh ipsum consequat. Nam aliquam sem et tortor consequat id. Habitasse platea dictumst vestibulum rhoncus est pellentesque. Pellentesque habitant morbi tristique senectus et netus et malesuada fames. Mattis molestie a iaculis at erat pellentesque adipiscing. Condimentum lacinia quis vel eros donec ac odio. Vitae congue eu consequat ac. Netus et malesuada fames ac. Sed euismod nisi porta lorem mollis aliquam. Rhoncus est pellentesque elit ullamcorper dignissim cras. Aliquet nibh praesent tristique magna sit amet purus. Odio ut sem nulla pharetra diam sit amet nisl. Bibendum est ultricies integer quis auctor elit sed vulputate mi. Viverra ipsum nunc aliquet bibendum enim facilisis gravida neque convallis.

Sociis natoque penatibus et magnis dis parturient montes. Ornare suspendisse sed nisi lacus sed viverra tellus. Eu augue ut lectus arcu bibendum at varius vel. Morbi leo urna molestie at elementum eu facilisis sed. Integer quis auctor elit sed vulputate mi. At varius vel pharetra vel. Ut consequat semper viverra nam libero. Metus vulputate eu scelerisque felis. In hendrerit gravida rutrum quisque non tellus orci. Eget gravida cum sociis natoque penatibus et magnis. Nec tincidunt praesent semper feugiat nibh sed. Id velit ut tortor pretium. Nibh cras pulvinar mattis nunc sed blandit. Augue neque gravida in fermentum et sollicitudin ac orci phasellus. Ut porttitor leo a diam sollicitudin tempor id. Nec feugiat nisl pretium fusce id velit. Amet purus gravida quis blandit turpis cursus in. Blandit libero volutpat sed cras ornare.

Vestibulum sed arcu non odio euismod lacinia. Cursus in hac habitasse platea dictumst quisque sagittis. Augue eget arcu dictum varius duis at consectetur. Eget egestas purus viverra accumsan in nisl nisi scelerisque eu. Turpis tincidunt id aliquet risus feugiat. Ultrices gravida dictum fusce ut placerat orci. Ullamcorper a lacus vestibulum sed arcu non odio euismod. Dictum fusce ut placerat orci nulla pellentesque dignissim enim. Arcu cursus vitae congue mauris rhoncus aenean vel elit scelerisque. Ornare quam viverra orci sagittis. Tincidunt nunc pulvinar sapien et ligula. Malesuada pellentesque elit eget gravida cum sociis. Non nisi est sit amet facilisis magna etiam. Mauris cursus mattis molestie a iaculis at erat. Praesent tristique magna sit amet. Blandit aliquam etiam erat velit scelerisque in. Urna et pharetra pharetra massa massa ultricies mi. Ultricies leo integer malesuada nunc vel risus commodo. Pellentesque adipiscing commodo elit at imperdiet dui accumsan sit amet.

Tortor aliquam nulla facilisi cras fermentum. A arcu cursus vitae congue mauris rhoncus. Ac orci phasellus egestas tellus rutrum tellus. Eget sit amet tellus cras. Ornare lectus sit amet est placerat in egestas erat. Dis parturient montes nascetur ridiculus. Ut eu sem integer vitae. Viverra orci sagittis eu volutpat odio facilisis mauris sit amet. Enim eu turpis egestas pretium aenean pharetra magna ac. Molestie nunc non blandit massa enim. Felis imperdiet proin fermentum leo vel orci porta non. Nibh mauris cursus mattis molestie a iaculis at erat. Elementum nibh tellus molestie nunc non blandit massa enim nec. Fringilla est ullamcorper eget nulla facilisi etiam dignissim diam quis. Lectus magna fringilla urna porttitor. Dictum fusce ut placerat orci nulla pellentesque dignissim enim. Sed id semper risus in. Nascetur ridiculus mus mauris vitae ultricies.

Vitae suscipit tellus mauris a. Sed elementum tempus egestas sed sed. Est placerat in egestas erat imperdiet sed euismod nisi porta. Nulla aliquet porttitor lacus luctus accumsan. Consequat semper viverra nam libero justo laoreet. Ut diam quam nulla porttitor massa id neque aliquam vestibulum. Cursus metus aliquam eleifend mi. Viverra nam libero justo laoreet sit amet. Malesuada fames ac turpis egestas maecenas pharetra convallis posuere morbi. Orci ac auctor augue mauris augue neque gravida. Sed libero enim sed faucibus turpis in eu mi bibendum. Tellus pellentesque eu tincidunt tortor aliquam nulla facilisi cras fermentum. Scelerisque purus semper eget duis at tellus at urna. Pellentesque habitant morbi tristique senectus. In metus vulputate eu scelerisque felis imperdiet proin fermentum leo. Vulputate mi sit amet mauris commodo quis imperdiet massa tincidunt." > $TMPDIR/dtest2
                    local theme=''
                    while test -z "$theme"; do
                        theme=$(printf "$(delta --list-syntax-themes | tail -n +1)" | fzf --reverse --border --border-label="Syntax theme")
                        theme=$(echo "$theme" | awk '{$1=""; print $0;}')
                        delta --syntax-theme "${theme:1}" $TMPDIR/dtest1 $TMPDIR/dtest2
                        stty sane && reade -Q "MAGENTA" -i "n" -p "Set as syntax theme? (Will retry if no) [N/y]: " "y" dltthme
                        if test "$dltthme" == "n"; then
                           theme='' 
                        fi
                    done
                    git config $global delta.syntax-theme "$theme"
                fi

                reade -Q "CYAN" -i "y" -p "Set to dark? [Y/n]: " "n" delta2
                if test "y" == $delta2; then
                    git config $global delta.dark true
                fi

                reade -Q "CYAN" -i "y" -p "Set linenumbers? [Y/n]: " "n" delta3
                if test "y" == $delta3; then
                    git config $global delta.linenumbers true
                fi

                reade -Q "CYAN" -i "y" -p "Set hyperlinks? [Y/n]: " "n" delta1
                if test "y" == $delta1; then
                    git config $global delta.hyperlinks true
                fi
                
            elif [ "$pager" == "diff-so-fancy" ]; then

                reade -Q "CYAN" -i "y" -p "Should the first block of an empty line be colored. (Default: true)? [Y/n]: " "n" diffancy
                if test "y" == $diffancy; then
                    git config --bool $global diff-so-fancy.markEmptyLines true                    
                else
                    git config --bool $global diff-so-fancy.markEmptyLines false                    
                fi
                reade -Q "CYAN" -i "y" -p "Simplify git header chunks to a more human readable format. (Default: true) [Y/n]: " "n" diffancy
                if test "y" == $diffancy; then
                    git config --bool $global diff-so-fancy.changeHunkIndicators true
                else
                    git config --bool $global diff-so-fancy.changeHunkIndicators false
                fi
                reade -Q "CYAN" -i "y" -p "Should the pesky + or - at line-start be removed. (Default: true) [Y/n]: " "n" diffancy
                if test "y" == $diffancy; then
                    git config --bool $global diff-so-fancy.stripLeadingSymbols true
                else
                    git config --bool $global diff-so-fancy.stripLeadingSymbols false
                fi
                reade -Q "CYAN" -i "y" -p "By default, the separator for the file header uses Unicode line-drawing characters. If this is causing output errors on your terminal, set this to false to use ASCII characters instead. (Default: true) [Y/n]: " "n" diffancy
                if test "y" == $diffancy; then
                    git config --bool $global diff-so-fancy.useUnicodeRuler true
                else
                    git config --bool $global diff-so-fancy.useUnicodeRuler false
                fi
                reade -Q "CYAN" -i "47" -p "By default, the separator for the file header spans the full width of the terminal. Use this setting to set the width of the file header manually. (Default: 47): " "$(seq 1 100)" diffancy
                 # git log's commit header width
                git config --global diff-so-fancy.rulerWidth $diffancy    
            elif [ "$pager" == "ydiff" ]; then
                pager=$pager" --color=auto"
                reade -Q "CYAN" -i "y" -p "Enable side-by-side mode? [Y/n]: " "n" diffr1
                if test "$diffr1" == 'y'; then
                    pager=$pager" --side-by-side"
                    reade -Q "CYAN" -i "y" -p "Wrap long lines in side-by-side view? [Y/n]: " 'n' diffr1
                    if test "$diffr1" == 'y'; then
                        pager=$pager" --wrap"
                    fi        
                fi
            elif [ "$pager" == "diffr" ]; then
                reade -Q "CYAN" -i "y" -p "Set linenumber? [Y/n]: " 'n' diffr1
                if test "$diffr1" == 'y'; then
                    pager="diffr --line-numbers"
                    reade -Q "CYAN" -i "n" -p "Set linenumber style? [compact/aligned/n]: " diffr1
                    if test "$diffr1" == 'compact' || test "$diffr1" == 'aligned'; then
                        pager="diffr --line-numbers $diffr1"
                    fi
                fi
            fi
            #prompt="$pager can work/works with a pager. Configure? [Y/n]: "
            #if test $pager == "diff-so-fancy"; then
            #    prompt=""
            #fi

            reade -Q "CYAN" -i "y" -p "$pager can work/works with a pager. Configure? [Y/n]: " "n" pipepager
            if test "$pipepager" == 'y'; then
                reade -Q "GREEN" -i "n" -p "Turn off pager? [N/y]: " "y" pipepager
                if test "$pipepager" == 'n'; then
                    pagers="less more"
                    pagersf="less\nmore\n"
                    pager="less"
                    if type most &> /dev/null ; then
                        pagers=$pagers" most"
                        pagersf=$pagersf"most\n"
                    fi
                    if type moar &> /dev/null ; then
                        pagers=$pagers" moar"
                        pagersf=$pagersf"moar\n"
                        pager="moar"
                    fi
                    if type vimpager &> /dev/null; then
                        pagers=$pagers" vimpager"
                        pagersf=$pagersf"vimpager\n"
                        pager="vimpager"
                    fi
                    if type nvimpager &> /dev/null; then
                        pagers=$pagers" nvimpager"
                        pagersf=$pagersf"nvimpager\n"
                        pager="nvimpager"
                    fi

                    reade -Q "GREEN" -i "$PAGER" -p "Pager: " "$pagers" diffancy
                    if [[ $diffancy =~ "less" ]]; then
                        local ln=""
                        reade -Q "CYAN" -i "y" -p "Quit if one screen? [Y/n]: " "n" lne 
                        if test "$lne" == 'y'; then
                           ln="--quit-if-one-screen"
                        fi
                        reade -Q "CYAN" -i "n" -p "Set linenumbers for pager? [Y/n]: " "n" lne 
                        if test "$lne" == 'n'; then
                           ln=$ln"-n"
                        else
                           ln=$ln"-N"
                        fi
                        if test "$pager" == "ydiff"; then
                            git config $global "$cpager" "ydiff --pager=less --pager-options=\"-R $ln\""         
                        elif test "$pager" == "bat" || test "$pager" == "batdiff"; then
                            reade -Q "CYAN" -i "y" -p "$pager uses an environment variable BAT_PAGER to set it's pager. Configure and put in $PATHVAR? [Y/n]: " "n" pager1
                            if test $pager1 == 'y'; then
                                if grep -q 'BAT_PAGER' $PATHVAR; then
                                    sed -i 's|.export BAT_PAGER=|export BAT_PAGER=|g' $PATHVAR
                                    sed -i "s|export BAT_PAGER=.*|export BAT_PAGER='less -R $ln'|g" $PATHVAR                       
                                else
                                    printf "# BAT\nexport BAT_PAGER='less -R $ln'\n" >> $PATHVAR
                                fi
                                git config $global "$cpager" "$pager"
                            else
                                git config $global "$cpager" "$pager --pager='less -R $ln'"
                            fi
                        elif test "$pager" == "delta"; then
                            reade -Q "CYAN" -i "y" -p "Delta uses an environment variable DELTA_PAGER to set it's pager. Configure and put in $PATHVAR? [Y/n]: " "n" pager1
                            if test $pager1 == 'y'; then
                                if grep -q 'DELTA_PAGER' $PATHVAR; then
                                    sed -i 's|.export DELTA_PAGER=|export DELTA_PAGER=|g' $PATHVAR
                                    sed -i "s|export DELTA_PAGER=.*|export DELTA_PAGER='less -R $ln'|g" $PATHVAR                      
                                else
                                    printf "# DELTA\nexport DELTA_PAGER='less -R $ln'\n" >> $PATHVAR
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
                        reade -Q "CYAN" -i "y" -p "You selected $diffancy. Show linenumber? [Y/n]: " "n" pager1
                        if test $pager1 == 'n'; then
                            ln=$ln' --no-linenumbers'
                        fi

                        reade -Q "CYAN" -i "y" -p "Quit if one screen? [Y/n]: " "n" pager1
                        if test $pager1 == 'y'; then
                            ln=$ln' --quit-if-one-screen'
                        fi

                        reade -Q "CYAN" -i "n" -p "Wrap long lines? [N/y]: " "y" pager1
                        if test $pager1 == 'y'; then
                            ln=$ln' --wrap'
                        fi

                        if test "$pager" == "ydiff"; then
                            git config $global "$cpager" "ydiff --pager=moar --pager-options=\"$ln\""
                        elif test "$pager" == "delta"; then
                            reade -Q "CYAN" -i "y" -p "Delta uses an environment variable DELTA_PAGER to set it's pager. Configure and put in $PATHVAR? [Y/n]: " "n" pager1
                            if test $pager1 == 'y'; then
                                if grep -q 'DELTA_PAGER' $PATHVAR; then
                                    sed -i 's|.export DELTA_PAGER=|export DELTA_PAGER=|g' $PATHVAR
                                    sed -i "s|export DELTA_PAGER=.*|export DELTA_PAGER='moar $ln'|g" $PATHVAR                       
                                else
                                    printf "# DELTA\nexport DELTA_PAGER='moar $ln'\n" >> $PATHVAR
                                fi
                                git config $global "$cpager" "$pager --pager='moar $ln'"
                            fi
                            git config $global "$cpager" "delta"
                            
                        elif test "$pager" == "bat" || test "$pager" == "batdiff"; then
                            reade -Q "CYAN" -i "y" -p "$pager uses an environment variable BAT_PAGER to set it's pager. Configure and put in $PATHVAR? [Y/n]: " "n" pager1
                            if test $pager1 == 'y'; then
                                if grep -q 'BAT_PAGER' $PATHVAR; then
                                    sed -i 's|.export BAT_PAGER=|export BAT_PAGER=|g' $PATHVAR
                                    sed -i "s|export BAT_PAGER=.*|export BAT_PAGER='moar $ln'|g" $PATHVAR                       
                                else
                                    printf "# BAT\nexport BAT_PAGER='moar $ln'\n" >> $PATHVAR
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
                        reade -Q "CYAN" -i "y" -p "Set colorscheme? [Y/n]: " "n" pager1
                        if [ "$pager1" == "y" ]; then
                            reade -Q "CYAN" -i "default" -p "Colorscheme: " "$colors" color
                            opts="$opts +'colorscheme $color'"
                        fi

                        if test "$pager" == "ydiff"; then
                            git config $global "$cpager" "ydiff --pager=nvimpager --pager-options='$opts'"
                        elif test "$pager" == "delta"; then
                            reade -Q "CYAN" -i "y" -p "Delta uses an environment variable DELTA_PAGER to set it's pager. Configure and put in $PATHVAR? [Y/n]: " "n" pager1
                            if test $pager1 == 'y'; then
                                if grep -q 'DELTA_PAGER' $PATHVAR; then
                                    sed -i 's|.export DELTA_PAGER=|export DELTA_PAGER=|g' $PATHVAR
                                    sed -i "s|export DELTA_PAGER=.*|export DELTA_PAGER='nvimpager $opts'|g" $PATHVAR                      
                                else
                                    printf "# DELTA\nexport DELTA_PAGER='nvimpager $opts'\n" >> $PATHVAR
                                fi
                                git config $global "$cpager" "delta"
                            else
                                git config $global "$cpager" "delta --pager=\"nvimpager $opts\""
                            fi
                        elif test "$pager" == "bat" || test "$pager" == "batdiff"; then
                            reade -Q "CYAN" -i "y" -p "$pager uses an environment variable BAT_PAGER to set it's pager. Configure and put in $PATHVAR? [Y/n]: " "n" pager1
                            if test $pager1 == 'y'; then
                                if grep -q 'BAT_PAGER' $PATHVAR; then
                                    sed -i 's|.export BAT_PAGER=|export BAT_PAGER=|g' $PATHVAR
                                    sed -i "s|export BAT_PAGER=.*|export BAT_PAGER='nvimpager $opts'|g" $PATHVAR                       
                                else
                                    printf "# BAT\nexport BAT_PAGER='nvimpager $opts'\n" >> $PATHVAR
                                fi
                                git config $global "$cpager" "$pager"
                            else
                                git config $global "$cpager" "$pager --pager=\"nvimpager $opts\""
                            fi
                        else
                            git config $global "$cpager" "$pager | nvimpager $opts"
                        fi
                    else
                        if test "$pager" == "ydiff"; then
                            git config $global "$cpager" "ydiff --pager=$diffancy"
                        elif test "$pager" == "bat" || test "$pager" == "batdiff"; then
                            reade -Q "CYAN" -i "y" -p "$pager uses an environment variable BAT_PAGER to set it's pager. Configure and put in $PATHVAR? [Y/n]: " "n" pager1
                            if test $pager1 == 'y'; then
                                if grep -q 'BAT_PAGER' $PATHVAR; then
                                    sed -i 's|.export BAT_PAGER=|export BAT_PAGER=|g' $PATHVAR
                                    sed -i "s|export BAT_PAGER=.*|export BAT_PAGER='$diffancy'|g" $PATHVAR                       
                                else
                                    printf "# BAT\nexport BAT_PAGER='$diffancy'\n" >> $PATHVAR
                                fi
                                git config $global "$cpager" "batdiff"
                            else
                                git config $global "$cpager" "batdiff --pager='$diffancy'"
                            fi
                        elif test "$pager" == "delta"; then
                            reade -Q "CYAN" -i "y" -p "Delta uses an environment variable DELTA_PAGER to set it's pager. Configure and put in $PATHVAR? [Y/n]: " "n" pager1
                            if test $pager1 == 'y'; then
                                if grep -q 'DELTA_PAGER' $PATHVAR; then
                                    sed -i 's|.export DELTA_PAGER=|export DELTA_PAGER=|g' $PATHVAR
                                    sed -i "s|export DELTA_PAGER=.*|export DELTA_PAGER='$diffancy'|g" $PATHVAR                       
                                else
                                    printf "# DELTA\nexport DELTA_PAGER='$diffancy'\n" >> $PATHVAR
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
        reade -Q "GREEN" -i "$pager" -p "Pager: " "$pagers" pager;
        #pager="$(printf "$pagersf" | fzf --border --border-label="Pager" --reverse)"
        
        if test $pager == 'less'; then
            local ln="-R"
            reade -Q "CYAN" -i "y" -p "You selected $pager. Quit if one screen? [Y/n]: " "n" pager1
            if test $pager1 == 'y'; then
                ln=$ln"--quit-if-one-screen"
            fi
            reade -Q "CYAN" -i "n" -p "Set linenumbers for pager? [N/y]: " "y" lne 
            if test "$lne" == 'n'; then
               ln=$ln"-n"
            else
               ln=$ln"-N"
            fi
            git config $global "$cpager" "$pager"  
        elif [ "$pager" == "moar" ]; then
            reade -Q "CYAN" -i "y" -p "You chose $pager. Quit if on one screen? [Y/n]: " "n" pager1
            if test $pager1 == 'y'; then
                pager=$pager' --quit-if-one-screen'
            fi
            reade -Q "CYAN" -i "y" -p "You selected $pager. Set style? [Y/n]: " "n" pager1
            if test $pager1 == 'y'; then
                local theme
                local styles="abap\nalgol\nalgol_nu\napi\narduino\nautumn\naverage\nbase16-snazzy\nborland\nbw\ncatppuccin-frappe\ncatppuccin-latte\ncatppuccin-macchiato\ncatppuccin-mocha\ncolorful\ncompat\ndoom-one\ndoom-one2\ndracula\nemacs\nfriendly\nfruity\ngithub-dark\ngithub\ngruvbox-light\ngruvbox\nhr_high_contrast\nhrdark\nigor\nlovelace\nmanni\nmodus-operandi\nmodus-vivendi\nmonokai\nmonokailight\nmurphy\nnative\nnord\nonedark\nonesenterprise\nparaiso-dark\nparaiso-light\npastie\nperldoc\npygments\nrainbow_dash\nrose-pine-dawn\nrose-pine-moon\nrose-pine\nrrt\nsolarized-dark\nsolarized-dark256\nsolarized-light\nswapoff\ntango\ntrac\nvim\nvs\nvulcan\nwitchhazel\nxcode-dark\nxcode"
                echo "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Sollicitudin nibh sit amet commodo nulla facilisi. Sed cras ornare arcu dui vivamus arcu. Non quam lacus suspendisse faucibus interdum posuere lorem. Consequat ac felis donec et odio pellentesque. Elementum tempus egestas sed sed risus pretium quam. Neque viverra justo nec ultrices dui sapien eget mi proin. Varius vel pharetra vel turpis nunc eget lorem dolor sed. Mauris in aliquam sem fringilla ut morbi tincidunt augue. Cursus euismod quis viverra nibh cras. Diam sollicitudin tempor id eu. Lectus arcu bibendum at varius vel. Posuere morbi leo urna molestie at elementum eu facilisis. Condimentum lacinia quis vel eros. Dolor magna eget est lorem ipsum dolor sit amet consectetur. Ultrices dui sapien eget mi. A arcu cursus vitae congue mauris.

    In pellentesque massa placerat duis ultricies lacus sed turpis tincidunt. Dignissim diam quis enim lobortis scelerisque fermentum. Faucibus purus in massa tempor nec. Enim neque volutpat ac tincidunt. Penatibus et magnis dis parturient montes nascetur ridiculus. Ornare aenean euismod elementum nisi quis eleifend quam adipiscing. Elementum pulvinar etiam non quam lacus suspendisse faucibus interdum. Vel eros donec ac odio tempor orci dapibus ultrices. Tempus imperdiet nulla malesuada pellentesque elit eget gravida. In ante metus dictum at tempor commodo ullamcorper.

    Feugiat sed lectus vestibulum mattis ullamcorper velit sed ullamcorper. Aliquet nibh praesent tristique magna sit amet purus. Dignissim diam quis enim lobortis scelerisque. Turpis egestas sed tempus urna et. Est sit amet facilisis magna. At tellus at urna condimentum mattis pellentesque. Bibendum ut tristique et egestas quis ipsum suspendisse ultrices. Diam sollicitudin tempor id eu. Vulputate sapien nec sagittis aliquam malesuada bibendum arcu vitae elementum. Aliquet nibh praesent tristique magna sit. Dictum fusce ut placerat orci nulla pellentesque dignissim enim. Laoreet sit amet cursus sit amet dictum. Amet consectetur adipiscing elit duis tristique. Phasellus vestibulum lorem sed risus ultricies tristique nulla aliquet.

    Eu augue ut lectus arcu bibendum at varius vel pharetra. Urna nunc id cursus metus. Massa eget egestas purus viverra. Ornare quam viverra orci sagittis eu volutpat odio facilisis. Ornare arcu dui vivamus arcu felis bibendum. Sollicitudin aliquam ultrices sagittis orci a. In eu mi bibendum neque egestas congue quisque egestas diam. Consectetur adipiscing elit duis tristique sollicitudin nibh sit amet commodo. Risus in hendrerit gravida rutrum quisque non. Justo eget magna fermentum iaculis eu. Ut consequat semper viverra nam libero justo laoreet sit. Vel pretium lectus quam id leo in vitae turpis. Praesent semper feugiat nibh sed pulvinar.

    Condimentum lacinia quis vel eros donec ac. Nibh sed pulvinar proin gravida hendrerit lectus a. Volutpat consequat mauris nunc congue nisi vitae suscipit tellus. Mi tempus imperdiet nulla malesuada pellentesque elit eget. Scelerisque in dictum non consectetur. Ac ut consequat semper viverra nam libero justo laoreet sit. Lectus magna fringilla urna porttitor rhoncus. Integer vitae justo eget magna fermentum. Nisl pretium fusce id velit ut. In aliquam sem fringilla ut morbi tincidunt augue. Vitae tempus quam pellentesque nec nam aliquam sem et. Eget mauris pharetra et ultrices neque. At augue eget arcu dictum. Eget duis at tellus at. Mauris ultrices eros in cursus turpis massa tincidunt dui. Aliquet nec ullamcorper sit amet. Eu feugiat pretium nibh ipsum consequat nisl vel pretium lectus." > $TMPDIR/dtest1
                while test -z "$style"; do
                    style=$(printf "$styles" | fzf --reverse --border --border-label="Moar style")
                    moar --style "$style" $TMPDIR/dtest1
                    stty sane && reade -Q "CYAN" -i "n" -p "Set as style? (Will retry if no) [N/y]: " 'y' thme
                    if test "$thme" == "n"; then
                       style='' 
                    fi
                done
                pager=$pager" $style"
            fi 
            reade -Q "CYAN" -i "n" -p "Show linenumber? [Y/n]: " "y" pager1
            if test $pager1 == 'n'; then
                pager=$pager' --no-linenumbers'
            fi
            reade -Q "CYAN" -i "n" -p "Wrap long lines? [Y/n]: " "n" pager1
            if test $pager1 == 'y'; then
                pager=$pager' --wrap'
            fi
            git config $global "$cpager" "$pager"  
        elif [ "$pager" == "nvimpager" ] || [ "$pager" == "vimpager" ] ; then
            echo "You selected $pager."
            colors="blue darkblue default delek desert elflord evening gruvbox habamax industry koehler lunaperch morning murphy pablo peachpuff quiet ron shine slate torte zellner"
            if test "$pager" == "vimpager"; then
               colors=$colors" retrobox sorbet wildcharm zaibatsu" 
            fi
            pager="$pager"
            reade -Q "CYAN" -i "y" -p "Set colorscheme? [Y/n]: " "n" pager1
            if [ "$pager1" == "y" ]; then
                reade -Q "CYAN" -i "default" -p "Colorscheme: " "$colors" color
                pager="$pager +'colorscheme $color'"
            fi
            git config $global "$cpager" "$pager"  
        elif [ "$pager" == "riff" ]; then
                pager="riff"
                reade -Q "CYAN" -i "y" -p "Ignore changes in amount of whitespace? [Y/n]: " riff1
                if test "$riff1" == 'y'; then
                    pager=$pager" -b"
                fi
                reade -Q "CYAN" -i "y" -p "No special highlighting for lines that only add content? [Y/n]: " riff1
                if test "$riff1" == 'y'; then
                    pager=$pager" --no-adds-only-special"
                fi
        elif [ "$pager" == "diff-so-fancy" ] || [ "$pager" == "diffr" ] || [ "$pager" == "ydiff" ] || [ "$pager" == "delta" ] || [ "$pager" == "bat" ] || [ "$pager" == "batdiff" ] ; then
            local difffancy
            local pre='y'
            othr='n'
            prmpt='[Y/n]: '
            color='CYAN' 
            if (test $pager == 'delta' || test $pager == 'diff-so-fancy') && echo $(git config $global --list --show-origin) | grep -q $pager; then
                pre='n'
                othr='y'
                prmpt='[N/y]: '
                color='YELLOW' 
            fi
            reade -Q "$color" -i "$pre" -p "You selected $pager. Configure? $prmpt" "$othr" difffancy
            if test "y" == "$difffancy"; then
                if [ "$pager" == "bat" ] || [ "$pager" == "batdiff" ]; then 
                    local opts=""
                    reade -Q "CYAN" -i "y" -p "Set styles? (line numbers/grid) [Y/n]: " "n" delta2
                    local theme='changes'
                    if test "y" == $delta2; then
                        while : ; do
                            local style=''
                            style=$(printf "full\nauto\nplain\nchanges\nheader\nheader-filename\nheader-filesize\ngrid\nrule\nnumbers\nsnip\n" | fzf --border --border-label="Bat styles")
                            stty sane && reade -Q "MAGENTA" -i "o" -p "Add to styles/Only use this style/Dont use? (Will retry if add) [A/o/n]: " "a o n" dltthme
                            if test "$dltthme" == "a" ; then
                                theme=$theme","$style
                            elif test "$dltthme" == "o" ; then
                                theme=$theme","$style
                                break;
                            else
                               break;
                            fi
                        done
                        opts=$opts" --style='$theme'"
                    fi 
                    reade -Q "CYAN" -i "y" -p "Set syntax-theme [Y/n]: " "n" delta1
                    if test "y" == $delta1; then
                        echo "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Sollicitudin nibh sit amet commodo nulla facilisi. Sed cras ornare arcu dui vivamus arcu. Non quam lacus suspendisse faucibus interdum posuere lorem. Consequat ac felis donec et odio pellentesque. Elementum tempus egestas sed sed risus pretium quam. Neque viverra justo nec ultrices dui sapien eget mi proin. Varius vel pharetra vel turpis nunc eget lorem dolor sed. Mauris in aliquam sem fringilla ut morbi tincidunt augue. Cursus euismod quis viverra nibh cras. Diam sollicitudin tempor id eu. Lectus arcu bibendum at varius vel. Posuere morbi leo urna molestie at elementum eu facilisis. Condimentum lacinia quis vel eros. Dolor magna eget est lorem ipsum dolor sit amet consectetur. Ultrices dui sapien eget mi. A arcu cursus vitae congue mauris.

    In pellentesque massa placerat duis ultricies lacus sed turpis tincidunt. Dignissim diam quis enim lobortis scelerisque fermentum. Faucibus purus in massa tempor nec. Enim neque volutpat ac tincidunt. Penatibus et magnis dis parturient montes nascetur ridiculus. Ornare aenean euismod elementum nisi quis eleifend quam adipiscing. Elementum pulvinar etiam non quam lacus suspendisse faucibus interdum. Vel eros donec ac odio tempor orci dapibus ultrices. Tempus imperdiet nulla malesuada pellentesque elit eget gravida. In ante metus dictum at tempor commodo ullamcorper.

    Feugiat sed lectus vestibulum mattis ullamcorper velit sed ullamcorper. Aliquet nibh praesent tristique magna sit amet purus. Dignissim diam quis enim lobortis scelerisque. Turpis egestas sed tempus urna et. Est sit amet facilisis magna. At tellus at urna condimentum mattis pellentesque. Bibendum ut tristique et egestas quis ipsum suspendisse ultrices. Diam sollicitudin tempor id eu. Vulputate sapien nec sagittis aliquam malesuada bibendum arcu vitae elementum. Aliquet nibh praesent tristique magna sit. Dictum fusce ut placerat orci nulla pellentesque dignissim enim. Laoreet sit amet cursus sit amet dictum. Amet consectetur adipiscing elit duis tristique. Phasellus vestibulum lorem sed risus ultricies tristique nulla aliquet.

    Eu augue ut lectus arcu bibendum at varius vel pharetra. Urna nunc id cursus metus. Massa eget egestas purus viverra. Ornare quam viverra orci sagittis eu volutpat odio facilisis. Ornare arcu dui vivamus arcu felis bibendum. Sollicitudin aliquam ultrices sagittis orci a. In eu mi bibendum neque egestas congue quisque egestas diam. Consectetur adipiscing elit duis tristique sollicitudin nibh sit amet commodo. Risus in hendrerit gravida rutrum quisque non. Justo eget magna fermentum iaculis eu. Ut consequat semper viverra nam libero justo laoreet sit. Vel pretium lectus quam id leo in vitae turpis. Praesent semper feugiat nibh sed pulvinar.

    Condimentum lacinia quis vel eros donec ac. Nibh sed pulvinar proin gravida hendrerit lectus a. Volutpat consequat mauris nunc congue nisi vitae suscipit tellus. Mi tempus imperdiet nulla malesuada pellentesque elit eget. Scelerisque in dictum non consectetur. Ac ut consequat semper viverra nam libero justo laoreet sit. Lectus magna fringilla urna porttitor rhoncus. Integer vitae justo eget magna fermentum. Nisl pretium fusce id velit ut. In aliquam sem fringilla ut morbi tincidunt augue. Vitae tempus quam pellentesque nec nam aliquam sem et. Eget mauris pharetra et ultrices neque. At augue eget arcu dictum. Eget duis at tellus at. Mauris ultrices eros in cursus turpis massa tincidunt dui. Aliquet nec ullamcorper sit amet. Eu feugiat pretium nibh ipsum consequat nisl vel pretium lectus." > $TMPDIR/dtest1
                        local theme=''
                        
                        while test -z "$theme"; do
                            theme=$(bat --list-themes | fzf --border --border-label="Bat syntax themes" --preview="bat --theme={} --color=always $TMPDIR/dtest1")
                            stty sane && reade -Q "MAGENTA" -i "n" -p "Set $theme as syntax theme? (Will retry if no) [Y/n]: " "n" dltthme
                            if test "$dltthme" == "n"; then
                               theme='' 
                            fi
                        done
                        opts=$opts" --theme=$theme"
                    fi

                    reade -Q "CYAN" -i "n" -p "Set to specific language? (Useful if you're using an obscure language that bat can't autodetect) [Y/n]: " "n" delta2
                    if test "y" == $delta2; then
                        local theme=''
                        
                        while test -z "$theme"; do
                            theme=$(bat --list-languages | fzf --border --border-label="Bat coding languages")
                            stty sane && reade -Q "MAGENTA" -i "n" -p "Set syntax to specifically use $theme as language? (Will retry if no) [Y/n]: " "n" dltthme
                            if test "$dltthme" == "n"; then
                               theme='' 
                            fi
                        done
                        opts=$opts" --language=$theme"
                    fi
                    pager=$pager" $opts"
                elif [ "$pager" == "delta" ]; then
                    reade -Q "CYAN" -i "y" -p "Set side-by-side view? [Y/n]: " "n" delta1
                    if test "y" == $delta1; then
                        git config $global delta.side-by-side true
                    fi

                    reade -Q "CYAN" -i "y" -p "Set to navigate? (Move between diff sections using n and N) [Y/n]: " "n" delta1
                    if test "y" == $delta1; then
                        git config $global delta.navigate true
                    fi 

                    reade -Q "CYAN" -i "y" -p "Set syntax-theme [Y/n]: " "n" delta1
                    if test "y" == $delta1; then
                        echo "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Sollicitudin nibh sit amet commodo nulla facilisi. Sed cras ornare arcu dui vivamus arcu. Non quam lacus suspendisse faucibus interdum posuere lorem. Consequat ac felis donec et odio pellentesque. Elementum tempus egestas sed sed risus pretium quam. Neque viverra justo nec ultrices dui sapien eget mi proin. Varius vel pharetra vel turpis nunc eget lorem dolor sed. Mauris in aliquam sem fringilla ut morbi tincidunt augue. Cursus euismod quis viverra nibh cras. Diam sollicitudin tempor id eu. Lectus arcu bibendum at varius vel. Posuere morbi leo urna molestie at elementum eu facilisis. Condimentum lacinia quis vel eros. Dolor magna eget est lorem ipsum dolor sit amet consectetur. Ultrices dui sapien eget mi. A arcu cursus vitae congue mauris.

    In pellentesque massa placerat duis ultricies lacus sed turpis tincidunt. Dignissim diam quis enim lobortis scelerisque fermentum. Faucibus purus in massa tempor nec. Enim neque volutpat ac tincidunt. Penatibus et magnis dis parturient montes nascetur ridiculus. Ornare aenean euismod elementum nisi quis eleifend quam adipiscing. Elementum pulvinar etiam non quam lacus suspendisse faucibus interdum. Vel eros donec ac odio tempor orci dapibus ultrices. Tempus imperdiet nulla malesuada pellentesque elit eget gravida. In ante metus dictum at tempor commodo ullamcorper.

    Feugiat sed lectus vestibulum mattis ullamcorper velit sed ullamcorper. Aliquet nibh praesent tristique magna sit amet purus. Dignissim diam quis enim lobortis scelerisque. Turpis egestas sed tempus urna et. Est sit amet facilisis magna. At tellus at urna condimentum mattis pellentesque. Bibendum ut tristique et egestas quis ipsum suspendisse ultrices. Diam sollicitudin tempor id eu. Vulputate sapien nec sagittis aliquam malesuada bibendum arcu vitae elementum. Aliquet nibh praesent tristique magna sit. Dictum fusce ut placerat orci nulla pellentesque dignissim enim. Laoreet sit amet cursus sit amet dictum. Amet consectetur adipiscing elit duis tristique. Phasellus vestibulum lorem sed risus ultricies tristique nulla aliquet.

    Eu augue ut lectus arcu bibendum at varius vel pharetra. Urna nunc id cursus metus. Massa eget egestas purus viverra. Ornare quam viverra orci sagittis eu volutpat odio facilisis. Ornare arcu dui vivamus arcu felis bibendum. Sollicitudin aliquam ultrices sagittis orci a. In eu mi bibendum neque egestas congue quisque egestas diam. Consectetur adipiscing elit duis tristique sollicitudin nibh sit amet commodo. Risus in hendrerit gravida rutrum quisque non. Justo eget magna fermentum iaculis eu. Ut consequat semper viverra nam libero justo laoreet sit. Vel pretium lectus quam id leo in vitae turpis. Praesent semper feugiat nibh sed pulvinar.

    Condimentum lacinia quis vel eros donec ac. Nibh sed pulvinar proin gravida hendrerit lectus a. Volutpat consequat mauris nunc congue nisi vitae suscipit tellus. Mi tempus imperdiet nulla malesuada pellentesque elit eget. Scelerisque in dictum non consectetur. Ac ut consequat semper viverra nam libero justo laoreet sit. Lectus magna fringilla urna porttitor rhoncus. Integer vitae justo eget magna fermentum. Nisl pretium fusce id velit ut. In aliquam sem fringilla ut morbi tincidunt augue. Vitae tempus quam pellentesque nec nam aliquam sem et. Eget mauris pharetra et ultrices neque. At augue eget arcu dictum. Eget duis at tellus at. Mauris ultrices eros in cursus turpis massa tincidunt dui. Aliquet nec ullamcorper sit amet. Eu feugiat pretium nibh ipsum consequat nisl vel pretium lectus." > $TMPDIR/dtest1
                       echo "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Malesuada fames ac turpis egestas sed tempus urna. Maecenas volutpat blandit aliquam etiam erat velit scelerisque in. Cras fermentum odio eu feugiat pretium nibh ipsum consequat. Nam aliquam sem et tortor consequat id. Habitasse platea dictumst vestibulum rhoncus est pellentesque. Pellentesque habitant morbi tristique senectus et netus et malesuada fames. Mattis molestie a iaculis at erat pellentesque adipiscing. Condimentum lacinia quis vel eros donec ac odio. Vitae congue eu consequat ac. Netus et malesuada fames ac. Sed euismod nisi porta lorem mollis aliquam. Rhoncus est pellentesque elit ullamcorper dignissim cras. Aliquet nibh praesent tristique magna sit amet purus. Odio ut sem nulla pharetra diam sit amet nisl. Bibendum est ultricies integer quis auctor elit sed vulputate mi. Viverra ipsum nunc aliquet bibendum enim facilisis gravida neque convallis.

    Sociis natoque penatibus et magnis dis parturient montes. Ornare suspendisse sed nisi lacus sed viverra tellus. Eu augue ut lectus arcu bibendum at varius vel. Morbi leo urna molestie at elementum eu facilisis sed. Integer quis auctor elit sed vulputate mi. At varius vel pharetra vel. Ut consequat semper viverra nam libero. Metus vulputate eu scelerisque felis. In hendrerit gravida rutrum quisque non tellus orci. Eget gravida cum sociis natoque penatibus et magnis. Nec tincidunt praesent semper feugiat nibh sed. Id velit ut tortor pretium. Nibh cras pulvinar mattis nunc sed blandit. Augue neque gravida in fermentum et sollicitudin ac orci phasellus. Ut porttitor leo a diam sollicitudin tempor id. Nec feugiat nisl pretium fusce id velit. Amet purus gravida quis blandit turpis cursus in. Blandit libero volutpat sed cras ornare.

    Vestibulum sed arcu non odio euismod lacinia. Cursus in hac habitasse platea dictumst quisque sagittis. Augue eget arcu dictum varius duis at consectetur. Eget egestas purus viverra accumsan in nisl nisi scelerisque eu. Turpis tincidunt id aliquet risus feugiat. Ultrices gravida dictum fusce ut placerat orci. Ullamcorper a lacus vestibulum sed arcu non odio euismod. Dictum fusce ut placerat orci nulla pellentesque dignissim enim. Arcu cursus vitae congue mauris rhoncus aenean vel elit scelerisque. Ornare quam viverra orci sagittis. Tincidunt nunc pulvinar sapien et ligula. Malesuada pellentesque elit eget gravida cum sociis. Non nisi est sit amet facilisis magna etiam. Mauris cursus mattis molestie a iaculis at erat. Praesent tristique magna sit amet. Blandit aliquam etiam erat velit scelerisque in. Urna et pharetra pharetra massa massa ultricies mi. Ultricies leo integer malesuada nunc vel risus commodo. Pellentesque adipiscing commodo elit at imperdiet dui accumsan sit amet.

    Tortor aliquam nulla facilisi cras fermentum. A arcu cursus vitae congue mauris rhoncus. Ac orci phasellus egestas tellus rutrum tellus. Eget sit amet tellus cras. Ornare lectus sit amet est placerat in egestas erat. Dis parturient montes nascetur ridiculus. Ut eu sem integer vitae. Viverra orci sagittis eu volutpat odio facilisis mauris sit amet. Enim eu turpis egestas pretium aenean pharetra magna ac. Molestie nunc non blandit massa enim. Felis imperdiet proin fermentum leo vel orci porta non. Nibh mauris cursus mattis molestie a iaculis at erat. Elementum nibh tellus molestie nunc non blandit massa enim nec. Fringilla est ullamcorper eget nulla facilisi etiam dignissim diam quis. Lectus magna fringilla urna porttitor. Dictum fusce ut placerat orci nulla pellentesque dignissim enim. Sed id semper risus in. Nascetur ridiculus mus mauris vitae ultricies.

    Vitae suscipit tellus mauris a. Sed elementum tempus egestas sed sed. Est placerat in egestas erat imperdiet sed euismod nisi porta. Nulla aliquet porttitor lacus luctus accumsan. Consequat semper viverra nam libero justo laoreet. Ut diam quam nulla porttitor massa id neque aliquam vestibulum. Cursus metus aliquam eleifend mi. Viverra nam libero justo laoreet sit amet. Malesuada fames ac turpis egestas maecenas pharetra convallis posuere morbi. Orci ac auctor augue mauris augue neque gravida. Sed libero enim sed faucibus turpis in eu mi bibendum. Tellus pellentesque eu tincidunt tortor aliquam nulla facilisi cras fermentum. Scelerisque purus semper eget duis at tellus at urna. Pellentesque habitant morbi tristique senectus. In metus vulputate eu scelerisque felis imperdiet proin fermentum leo. Vulputate mi sit amet mauris commodo quis imperdiet massa tincidunt." > $TMPDIR/dtest2
                        local theme=''
                        while test -z "$theme"; do
                            theme=$(printf "$(delta --list-syntax-themes | tail -n +1)" | fzf --reverse --border --border-label="Syntax theme")
                            theme=$(echo "$theme" | awk '{$1=""; print $0;}')
                            delta --syntax-theme "${theme:1}" $TMPDIR/dtest1 $TMPDIR/dtest2
                            stty sane && reade -Q "MAGENTA" -i "n" -p "Set as syntax theme? (Will retry if no) [N/y]: " "y" dltthme
                            if test "$dltthme" == "n"; then
                               theme='' 
                            fi
                        done
                        git config $global delta.syntax-theme "$theme"
                    fi

                    reade -Q "CYAN" -i "y" -p "Set to dark? [Y/n]: " "n" delta2
                    if test "y" == $delta2; then
                        git config $global delta.dark true
                    fi

                    reade -Q "CYAN" -i "y" -p "Set linenumbers? [Y/n]: " "n" delta3
                    if test "y" == $delta3; then
                        git config $global delta.linenumbers true
                    fi

                    reade -Q "CYAN" -i "y" -p "Set hyperlinks? [Y/n]: " "n" delta1
                    if test "y" == $delta1; then
                        git config $global delta.hyperlinks true
                    fi
                    
                elif [ "$pager" == "diff-so-fancy" ]; then

                    reade -Q "CYAN" -i "y" -p "Should the first block of an empty line be colored. (Default: true)? [Y/n]: " "n" diffancy
                    if test "y" == $diffancy; then
                        git config --bool $global diff-so-fancy.markEmptyLines true                    
                    else
                        git config --bool $global diff-so-fancy.markEmptyLines false                    
                    fi
                    reade -Q "CYAN" -i "y" -p "Simplify git header chunks to a more human readable format. (Default: true) [Y/n]: " "n" diffancy
                    if test "y" == $diffancy; then
                        git config --bool $global diff-so-fancy.changeHunkIndicators true
                    else
                        git config --bool $global diff-so-fancy.changeHunkIndicators false
                    fi
                    reade -Q "CYAN" -i "y" -p "Should the pesky + or - at line-start be removed. (Default: true) [Y/n]: " "n" diffancy
                    if test "y" == $diffancy; then
                        git config --bool $global diff-so-fancy.stripLeadingSymbols true
                    else
                        git config --bool $global diff-so-fancy.stripLeadingSymbols false
                    fi
                    reade -Q "CYAN" -i "y" -p "By default, the separator for the file header uses Unicode line-drawing characters. If this is causing output errors on your terminal, set this to false to use ASCII characters instead. (Default: true) [Y/n]: " "n" diffancy
                    if test "y" == $diffancy; then
                        git config --bool $global diff-so-fancy.useUnicodeRuler true
                    else
                        git config --bool $global diff-so-fancy.useUnicodeRuler false
                    fi
                    reade -Q "CYAN" -i "47" -p "By default, the separator for the file header spans the full width of the terminal. Use this setting to set the width of the file header manually. (Default: 47): " "$(seq 1 100)" diffancy
                     # git log's commit header width
                    git config $global diff-so-fancy.rulerWidth $diffancy    
                elif [ "$pager" == "ydiff" ]; then
                    pager=$pager" --color=auto"
                    reade -Q "CYAN" -i "y" -p "Enable side-by-side mode? [Y/n]: " 'n'  diffr1
                    if test "$diffr1" == 'y'; then
                        pager=$pager" --side-by-side"
                        reade -Q "CYAN" -i "y" -p "Wrap long lines in side-by-side view? [Y/n]: " 'n' diffr1
                        if test "$diffr1" == 'y'; then
                            pager=$pager" --wrap"
                        fi        
                    fi
                elif [ "$pager" == "diffr" ]; then
                    reade -Q "CYAN" -i "y" -p "Set linenumber? [Y/n]: " 'n' diffr1
                    if test "$diffr1" == 'y'; then
                        pager="diffr --line-numbers"
                        reade -Q "CYAN" -i "n" -p "Set linenumber style? [compact/aligned/n]: " diffr1
                        if test "$diffr1" == 'compact' || test "$diffr1" == 'aligned'; then
                            pager="diffr --line-numbers $diffr1"
                        fi
                    fi
                fi


            
                reade -Q "YELLOW" -i "n" -p "Only use syntax highlighting and turn off pager? [Y/n]: " "n" pipepager1
                if test "$pipepager1" == 'y'; then 
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

                    reade -Q "CYAN" -i "y" -p "$prompt" "n" pipepager
                    if test "$pipepager" == 'y'; then
                    
                        pagers="less more"
                        pagersf="less\nmore\n"
                        if type most &> /dev/null ; then
                            pagers=$pagers" most"
                            pagersf=$pagersf"most\n"
                        fi
                        if type moar &> /dev/null ; then
                            pagers=$pagers" moar"
                            pagersf=$pagersf"moar\n"
                        fi
                        if type vimpager &> /dev/null; then
                            pagers=$pagers" vimpager"
                            pagersf=$pagersf"vimpager\n"
                        fi
                        if type nvimpager &> /dev/null; then
                            pagers=$pagers" nvimpager"
                            pagersf=$pagersf"nvimpager\n"
                        fi

                        reade -Q "GREEN" -i "$PAGER" -p "Pager: " "$pagers" diffancy
                        
                        if [[ "$diffancy" =~ "less" ]]; then
                            local ln=""
                            reade -Q "CYAN" -i "y" -p "Quit if one screen? [Y/n]: " "n" lne 
                            if test "$lne" == 'y'; then
                               ln="--quit-if-one-screen"
                            fi
                            reade -Q "CYAN" -i "n" -p "Set linenumbers for pager? [Y/n]: " "n" lne 
                            if test "$lne" == 'n'; then
                               ln=$ln"-n"
                            else
                               ln=$ln"-N"
                            fi
                            if [[ "$pager" =~ "ydiff" ]]; then
                                git config $global "$cpager" "ydiff --pager=less --pager-options=\"-R $ln\""         
                            elif [[ "$pager" =~ "bat" || "$pager" =~ "batdiff" ]]; then
                                reade -Q "CYAN" -i "y" -p "$pager uses an environment variable BAT_PAGER to set it's pager. Configure and put in $PATHVAR? [Y/n]: " "n" pager1
                                if test $pager1 == 'y'; then
                                    if grep -q 'BAT_PAGER' $PATHVAR; then
                                        sed -i 's|.export BAT_PAGER=|export BAT_PAGER=|g' $PATHVAR
                                        sed -i "s|export BAT_PAGER=.*|export BAT_PAGER='less -R $ln'|g" $PATHVAR                       
                                    else
                                        printf "\n# BAT\nexport BAT_PAGER='less -R $ln'\n" >> $PATHVAR
                                    fi
                                    git config $global "$cpager" "$pager"
                                else
                                    git config $global "$cpager" "$pager --pager='less -R $ln'"
                                fi
                            elif [[ "$pager" =~ "delta" ]]; then
                                reade -Q "CYAN" -i "y" -p "Delta uses an environment variable DELTA_PAGER to set it's pager. Configure and put in $PATHVAR? [Y/n]: " "n" pager1
                                if test $pager1 == 'y'; then
                                    if grep -q 'DELTA_PAGER' $PATHVAR; then
                                        sed -i 's|.export DELTA_PAGER=|export DELTA_PAGER=|g' $PATHVAR
                                        sed -i "s|export DELTA_PAGER=.*|export DELTA_PAGER='less -R $ln'|g" $PATHVAR                      
                                    else
                                        printf "\n# DELTA\nexport DELTA_PAGER='less -R $ln'\n" >> $PATHVAR
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
                            reade -Q "CYAN" -i "y" -p "You selected $diffancy. Show linenumber? [Y/n]: " "n" pager1
                            if test $pager1 == 'n'; then
                                ln=$ln' --no-linenumbers'
                            fi

                            reade -Q "CYAN" -i "y" -p "Quit if one screen? [Y/n]: " "n" pager1
                            if test $pager1 == 'y'; then
                                ln=$ln' --quit-if-one-screen'
                            fi

                            reade -Q "CYAN" -i "n" -p "Wrap long lines? [Y/n]: " "n" pager1
                            if test $pager1 == 'y'; then
                                ln=$ln' --wrap'
                            fi

                            if [[ "$pager" =~ "ydiff" ]]; then
                                git config $global "$cpager" "ydiff --pager=moar --pager-options=\"$ln\""
                            elif [[ "$pager" =~ "delta" ]]; then
                                reade -Q "CYAN" -i "y" -p "Delta uses an environment variable DELTA_PAGER to set it's pager. Configure and put in $PATHVAR? [Y/n]: " "n" pager1
                                if test $pager1 == 'y'; then
                                    if grep -q 'DELTA_PAGER' $PATHVAR; then
                                        sed -i 's|.export DELTA_PAGER=|export DELTA_PAGER=|g' $PATHVAR
                                        sed -i "s|export DELTA_PAGER=.*|export DELTA_PAGER='moar $ln'|g" $PATHVAR                       
                                    else
                                        printf "\n# DELTA\nexport DELTA_PAGER='moar $ln'\n" >> $PATHVAR
                                    fi
                                    git config $global "$cpager" "$pager --pager='moar $ln'"
                                fi
                                git config $global "$cpager" "delta"
                                
                            elif [[ "$pager" =~ "bat" || "$pager" =~ "batdiff" ]]; then
                                reade -Q "CYAN" -i "y" -p "$pager uses an environment variable BAT_PAGER to set it's pager. Configure and put in $PATHVAR? [Y/n]: " "n" pager1
                                if test $pager1 == 'y'; then
                                    if grep -q 'BAT_PAGER' $PATHVAR; then
                                        sed -i 's|.export BAT_PAGER=|export BAT_PAGER=|g' $PATHVAR
                                        sed -i "s|export BAT_PAGER=.*|export BAT_PAGER='moar $ln'|g" $PATHVAR                       
                                    else
                                        printf "\n# BAT\nexport BAT_PAGER='moar $ln'\n" >> $PATHVAR
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
                            reade -Q "CYAN" -i "y" -p "Set colorscheme? [Y/n]: " "n" pager1
                            if [ "$pager1" == "y" ]; then
                                reade -Q "CYAN" -i "default" -p "Colorscheme: " "$colors" color
                                opts="$opts +'colorscheme $color'"
                            fi

                            if [[ "$pager" =~ "ydiff" ]]; then
                                git config $global "$cpager" "ydiff --pager=nvimpager --pager-options='$opts'"
                            elif [[ "$pager" =~ "delta" ]]; then
                                reade -Q "CYAN" -i "y" -p "Delta uses an environment variable DELTA_PAGER to set it's pager. Configure and put in $PATHVAR? [Y/n]: " "n" pager1
                                if test $pager1 == 'y'; then
                                    if grep -q 'DELTA_PAGER' $PATHVAR; then
                                        sed -i 's|.export DELTA_PAGER=|export DELTA_PAGER=|g' $PATHVAR
                                        sed -i "s|export DELTA_PAGER=.*|export DELTA_PAGER='nvimpager $opts'|g" $PATHVAR                      
                                    else
                                        printf "\n# DELTA\nexport DELTA_PAGER='nvimpager $opts'\n" >> $PATHVAR
                                    fi
                                    git config $global "$cpager" "delta"
                                else
                                    git config $global "$cpager" "delta --pager=\"nvimpager $opts\""
                                fi
                            elif [[ "$pager" =~ "bat" || "$pager" =~ "batdiff" ]]; then
                                reade -Q "CYAN" -i "y" -p "$pager uses an environment variable BAT_PAGER to set it's pager. Configure and put in $PATHVAR? [Y/n]: " "n" pager1
                                if test $pager1 == 'y'; then
                                    if grep -q 'BAT_PAGER' $PATHVAR; then
                                        sed -i 's|.export BAT_PAGER=|export BAT_PAGER=|g' $PATHVAR
                                        sed -i "s|export BAT_PAGER=.*|export BAT_PAGER='nvimpager $opts'|g" $PATHVAR                       
                                    else
                                        printf "\n# BAT\nexport BAT_PAGER='nvimpager $opts'\n" >> $PATHVAR
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
                                reade -Q "CYAN" -i "y" -p "$pager uses an environment variable BAT_PAGER to set it's pager. Configure and put in $PATHVAR? [Y/n]: " "n" pager1
                                if test $pager1 == 'y'; then
                                    if grep -q 'BAT_PAGER' $PATHVAR; then
                                        sed -i 's|.export BAT_PAGER=|export BAT_PAGER=|g' $PATHVAR
                                        sed -i "s|export BAT_PAGER=.*|export BAT_PAGER='$diffancy'|g" $PATHVAR                       
                                    else
                                        printf "\n# BAT\nexport BAT_PAGER='$diffancy'\n" >> $PATHVAR
                                    fi
                                    git config $global "$cpager" "batdiff"
                                else
                                    git config $global "$cpager" "batdiff --pager='$diffancy'"
                                fi
                            elif [[ "$pager" =~ "delta" ]]; then
                                reade -Q "CYAN" -i "y" -p "Delta uses an environment variable DELTA_PAGER to set it's pager. Configure and put in $PATHVAR? [Y/n]: " "n" pager1
                                if test $pager1 == 'y'; then
                                    if grep -q 'DELTA_PAGER' $PATHVAR; then
                                        sed -i 's|.export DELTA_PAGER=|export DELTA_PAGER=|g' $PATHVAR
                                        sed -i "s|export DELTA_PAGER=.*|export DELTA_PAGER='$diffancy'|g" $PATHVAR                       
                                    else
                                        printf "\n# DELTA\nexport DELTA_PAGER='$diffancy'\n" >> $PATHVAR
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

 gitt(){
   if ! [ -x "$(command -v git)" ]; then
        reade -Q "GREEN" -i "y" -p "Install git? [Y/n]:" "n" nstll
        if [ "$nstll" == "y" ]; then
            if test $distro == "Arch" || "$distro" == "Manjaro"; then
                sudo pacman -S git
            elif test "$distro_base" == "Debian"; then
                sudo apt install git
            fi
        fi
    fi

    local global=""
    if ! test -z "$1"; then
        global="--$1"
    else
        reade -Q "CYAN" -i "y" -p "Set to configure git globally? [Y/n]: " "n" gitglobal
        if [ "y" == "$gitglobal" ]; then
            global="--global"
        fi
        unset gitglobal
    fi
    
    local name gitname
    local prename='n'
    color="YELLOW" 
    othr='y'
    prmpt='[N/y]: '
    if test "$(git config $global --list | grep 'user.name' | awk 'BEGIN { FS = "=" } ;{print $2;}')" == '' ; then
        prename='y'
        color="CYAN" 
        othr='n'
        prmpt='[Y/n]: '
    fi
    reade -Q "$color" -i "$prename" -p "Configure git name? $prmpt" "$othr" gitname
    if [ "y" == $gitname ]; then
        reade -Q "CYAN" -p "Name: " name
        if [ ! -z $name ]; then
            git config "$global" user.name "$name"
        fi
    fi

    local gitmail mail
    local premail='n'
    color="YELLOW" 
    othr='y'
    prmpt='[N/y]: '
    if test "$(git config $global --list | grep 'user.email' | awk 'BEGIN { FS = "=" } ;{print $2;}')" == '' ; then
        premail='y'
        color="CYAN" 
        othr='n'
        prmpt='[Y/n]: '
    fi
    reade -Q "$color" -i "$premail" -p "Configure git email? $prmpt" "$othr" gitmail ;
    if [ "y" == $gitmail ]; then
        reade -Q "CYAN" -p "Email: " mail ;
        if [ ! -z $mail ]; then
            git config "$global" user.email "$mail" ;
        fi
    fi

    # https://www.youtube.com/watch?v=aolI_Rz0ZqY
    local gitrerere rerere
    local prererere='n'
    color="YELLOW" 
    othr='y'
    prmpt='[Y/n]: ' 
    if test "$(git config $global --list | grep 'rerere.enabled' | awk 'BEGIN { FS = "=" } ;{print $2;}')" == '' ; then
        prererere='y'
        color="CYAN" 
        othr='n'
        prmpt='[N/y]: ' 
    fi
    reade -Q "$color" -i "$prererere" -p "Configure git to remember resolved mergeconflicts for reuse? $prmpt" "$othr" gitrerere ;
    if [ "y" == $gitrerere ]; then
        git config "$global" rerere.enabled true;
    fi

    local gitpgr pager wpager
    reade -Q "CYAN" -i "y" -p "Configure pager for git core, diff, show and log? [Y/n]: " "n" wpager ;
    if test "$wpager" == "y"; then
        reade -Q "YELLOW" -i "n" -p "Install custom diff syntax highlighter? [N/y]: " "y" gitpgr ;
        if test "$gitpgr" == "y"; then
            reade -Q "GREEN" -i "delta" -p "Which to install? [Delta/diff-so-fancy/riff/ydiff/difftastic/diffr]: " "diff-so-fancy riff ydiff diffr difftastic" pager 
            if test $pager == "bat"; then
                if ! test -f install_bat.sh; then
                    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_bat.sh)"
                else
                   ./install_bat.sh
                fi
                
            elif test $pager == "moar"; then
                if ! test -f install_moar.sh; then
                    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_moar.sh)"
                else
                   ./install_moar.sh
                fi
            elif test $pager == "most"; then
                if ! test -f install_most.sh; then
                    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_most.sh)"
                else
                   ./install_most.sh
                fi
            elif test $pager == "riff"; then
               if ! test -f install_cargo.sh; then
                    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_cargo.sh)"
                else
                   ./install_cargo.sh
                fi
                cargo install --locked riffdiff
            elif test $pager == "difftastic"; then
               if ! test -f install_cargo.sh; then
                    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_cargo.sh)"
                else
                   ./install_cargo.sh
                fi
                cargo install --locked difftastic
            elif test $pager == "diffr"; then
               if ! test -f install_cargo.sh; then
                    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_cargo.sh)"
                else
                   ./install_cargo.sh
                fi
                cargo install --locked diffr
            elif test $pager == "nvimpager"; then
               if ! test -f install_nvimpager.sh; then
                    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_nvimpager.sh)"
                else
                   ./install_nvimpager.sh
                fi
            fi
            if test "$distro" == "Arch" || test "$distro" == "Manjaro"; then
                if test $pager == "diff-so-fancy"; then
                    sudo pacman -S diff-so-fancy
                elif test $pager == "delta"; then
                    sudo pacman -S git-delta
                elif test $pager == "ydiff"; then
                    sudo pacman -S pipx
                    pipx install --upgrade ydiff
                fi
            elif test "$distro_base" == "Debian"; then
                if test $pager == "diff-so-fancy"; then
                    sudo apt install npm
                    sudo npm -g install diff-so-fancy 
                elif test $pager == "delta"; then
                    sudo apt install debdelta
                elif test $pager == "ydiff"; then
                    sudo apt install pipx
                    pipx install --upgrade ydiff
                fi
            fi
        fi
        unset gitdiff gitdiff1 difftool pager           
        local pgpre="n"
        if test "$(git config $global --list | grep 'core.pager' | awk 'BEGIN { FS = "=" } ;{print $2;}')" == '' ; then
            pgpre="y"
        fi
        reade -Q "GREEN" -i "$pgpre" -p "Set core.pager? [Y/n]: " "n" pager ;
        if test $pager == 'y'; then    
            git_pager "core.pager" "$global"
        fi
        local pgpre="n"
        if test "$(git config $global --list | grep 'pager.diff' | awk 'BEGIN { FS = "=" } ;{print $2;}')" == '' ; then
            pgpre="y"
        fi
        reade -Q "GREEN" -i "$pgpre" -p "Set pager.diff? [Y/n]: " "n" pager ;
        if test $pager == 'y'; then
            git_pager "pager.diff" "$global"
        fi
        local pgpre="n"
        if test "$(git config $global --list | grep 'pager.difftool' | awk 'BEGIN { FS = "=" } ;{print $2;}')" == '' ; then
            pgpre="y"
        fi
        reade -Q "GREEN" -i "$pgpre" -p "Set pager.difftool? [Y/n]: " "n" pager ;
        if test $pager == 'y'; then
            git_pager "pager.difftool" "$global"
        fi
        local pgpre="n"
        if test "$(git config $global --list | grep 'pager.show' | awk 'BEGIN { FS = "=" } ;{print $2;}')" == '' ; then
            pgpre="y"
        fi
        reade -Q "GREEN" -i "$pgpre" -p "Set pager.show? [Y/n]: " "n" pager 
        if test $pager == 'y'; then
            git_pager "pager.show" "$global"
        fi
        local pgpre="n"
        if test "$(git config $global --list | grep 'pager.log' | awk 'BEGIN { FS = "=" } ;{print $2;}')" == '' ; then
            pgpre="y"
        fi
        reade -Q "GREEN" -i "$pgpre" -p "Set pager.log? [Y/n]: " "n" pager 
        if test $pager == 'y'; then
            git_pager "pager.log" "$global"
        fi
    fi
    #confs="$(cur="pager." && compgen -F _git_config 2> /dev/null)"

    local diffs=""
    local diff=""
    if type delta &> /dev/null ; then
        diffs=$diffs" delta"
        diff="delta"
    fi
    if type ydiff &> /dev/null ; then
        diffs=$diffs" ydiff"
        diff="delta"
    fi
    if type riff &> /dev/null ; then
        diffs=$diffs" riff"
        diff="riff"
    fi
    if type diffr &> /dev/null ; then
        diffs=$diffs" diffr"
        diff="diffr"
    fi
    if type diff-so-fancy &> /dev/null ; then
        diffs=$diffs" diff-so-fancy"
        diff="diff-so-fancy"
    fi
    if type batdiff &> /dev/null ; then
        diffs=$diffs" batdiff"
        diff="batdiff"
    fi

    local prediff='n'
    if test "$(git config $global --list | grep 'interactive.difffilter' | awk 'BEGIN { FS = "=" } ;{print $2;}')" == '' ; then
        prediff='y'
    fi
    if [ "$diffs" != '' ]; then
        reade -Q "CYAN" -i "$prediff" -p "Configure custom interactive diff filter? [Y/n]: " "n" gitdiff1 ;     
        if [ "y" == "$gitdiff1" ]; then
            git_hl "git config $global interactive.difffilter"
        fi
    fi 

    

    local editor editors diffs diff difftool mergetool cstyle prompt
    editors="nano vi"
    if type vim &> /dev/null; then
        editors=$editors" vim"
        editor='vim'
    fi
    if type gvim &> /dev/null ; then
        editors=$editors" gvim"
        editor='gvim'
    fi
    if type nvim &> /dev/null ; then
        editors=$editors" nvim"
        editor='nvim'
    fi 
    if type emacs &> /dev/null ; then
        editors=$editors" emacs"
        editor='emacs'
    fi
    if type code &> /dev/null ; then
        editors=$editors" vscode"
        editor='vscode'
    fi
    diffs="$editors"
    diff="$editor"
    if type difft &> /dev/null; then
        diffs=$diffs" difftastic"
        diff="difftastic" 
    fi

    local edpre="n"
    if test "$(git config $global --list | grep 'color.ui' | awk 'BEGIN { FS = "=" } ;{print $2;}')" == '' ; then
        edpre="y"
    fi
    reade -Q "CYAN" -i "$edpre" -p "Set color.ui? (Git color behaviour) [Y/n]: " "n" editor ;
    if test "y" == "$editor"; then
        reade -Q "CYAN" -i "true" -p "Color.ui (Default: auto): " "true false auto always" editor;
        if test "$editor" == "auto" || test "$editor" == "false" || test "$editor" == "true" || test "$editor" == "always"; then
            git config "$global" color.ui "$editor"
        fi
    fi 
    unset editor

    local edpre="n"
    if test "$(git config $global --list | grep 'core.editor' | awk 'BEGIN { FS = "=" } ;{print $2;}')" == '' ; then
        edpre="y"
    fi
    reade -Q "CYAN" -i "$edpre" -p "Set default editor?: " "n" editor ;
    if test "y" == "$editor"; then
        unset editor
        reade -Q "CYAN" -i "$editor" -p "Editor: " "$editors" editor;
        if ! test -z "$editor"; then
            if test "$editor" == "vscode"; then
                editor="code"
            fi
            git config "$global" core.editor "$editor"
        fi
    fi
    #fi

    

    local diffpre="n"
    if test "$(git config $global --list | grep 'diff.tool' | awk 'BEGIN { FS = "=" } ;{print $2;}')" == '' ; then
        diffpre="y"
    fi
    reade -Q "CYAN" -i "$diffpre" -p "Set difftool? [Y/n]: " "n" difftool;
    if test $difftool == "y"; then
        reade -Q "CYAN" -i "$diff" -p "Tool: " "$diffs" editor;
        if ! test -z "$editor"; then
            local diff merge
            if test "$editor" == "vim"; then 
                git config "$global" diff.tool vimdiff
            elif test "$editor" == "gvim"; then 
                git config "$global" diff.tool gvimdiff
            elif test "$editor" == "nvim"; then 
                git config "$global" diff.tool nvimdiff
            elif test "$editor" == "emacs"; then 
                git config "$global" diff.tool emerge
            elif test "$editor" == "vscode"; then 
                git config "$global" difftool.vscode.cmd 'code --wait --diff $LOCAL $REMOTE'
                git config "$global" diff.tool vscode
            elif test "$editor" == "difftastic"; then 
                git config "$global" diff.tool difftastic
                git config "$global" difftool.pager true
                git config "$global" difftool.prompt false
                git config "$global" difftool.difftastic.cmd 'difft $LOCAL $REMOTE'
            fi
        fi
    fi

    local diffguipre="n"
    if test "$(git config $global --list | grep 'diff.guitool' | awk 'BEGIN { FS = "=" } ;{print $2;}')" == '' ; then
        diffguipre="y"
    fi
    reade -Q "CYAN" -i "$diffguipre" -p "Set diff guitool? [Y/n]: " "n" difftool;
    if test $difftool == "y"; then
        reade -Q "CYAN" -i "$diff" -p "Guitool: " "$diffs" editor;
        if ! test -z "$editor"; then
            local diff merge
            if test "$editor" == "vim"; then
                git config "$global" diff.guitool vimdiff
            elif test "$editor" == "gvim"; then 
                git config "$global" diff.guitool gvimdiff
            elif test "$editor" == "nvim"; then 
                git config "$global" diff.guitool nvimdiff
            elif test "$editor" == "emacs"; then 
                git config "$global" diff.guitool emerge
            elif test "$editor" == "vscode"; then 
                git config "$global" difftool.vscode.cmd 'code --wait --diff $LOCAL $REMOTE'
                git config "$global" diff.guitool vscode
            elif test "$editor" == "difftastic"; then 
                git config "$global" diff.guitool difftastic
                git config "$global" diffguitool.pager true
                git config "$global" difftool.prompt false
                git config "$global" difftool.difftastic.cmd 'difft "$LOCAL" "$REMOTE"'
            fi
        fi
    fi

    local diffguipre="n"
    if test "$(git config $global --list | grep 'difftool.prompt' | awk 'BEGIN { FS = "=" } ;{print $2;}')" == '' ; then
        diffguipre="y"
    fi
    reade -Q "CYAN" -i "$diffguipre" -p "Set difftool prompt? [Y/n]: " "n" conflict;
    if test $conflict == "y"; then
        reade -Q "GREEN" -i "false" -p "Prompt?: " "true false" prompt;
        if ! test -z "$cstyle"; then
            git config difftool.prompt "$prompt"
        fi
    fi

    local diffpre="n"
    if test "$(git config $global --list | grep 'merge.tool' | awk 'BEGIN { FS = "=" } ;{print $2;}')" == '' ; then
        diffpre="y"
    fi
    reade -Q "CYAN" -i "$diffpre" -p "Set mergetool? [Y/n]: " "n" difftool;
    if test $difftool == "y"; then
        reade -Q "CYAN" -i "$editor" -p "Tool (editor): " "$editors" editor;
        if ! test -z "$editor"; then
            local diff merge
            if test "$editor" == "vim"; then 
                git config "$global" merge.tool vimdiff
            elif test "$editor" == "gvim"; then 
                git config "$global" merge.tool gvimdiff
            elif test "$editor" == "nvim"; then 
                git config "$global" merge.tool nvimdiff
            elif test "$editor" == "emacs"; then 
                git config "$global" merge.tool emerge
            elif test "$editor" == "vscode"; then 
                git config "$global" mergetool.vscode.cmd 'code --wait $MERGED'
                git config "$global" merge.tool vscode
            fi
        fi
    fi
    
    local b="$(git config $global --list | grep 'merge.guitool' | awk 'BEGIN { FS = "=" } ;{print $2;}')"

    local diffguipre="n"
    if test "$b" == '' && ! test "$b" == false ; then
        diffguipre="y"
    fi
    reade -Q "CYAN" -i "$diffguipre" -p "Set merge guitool?: " "n" difftool;
    if test $difftool == "y"; then
        reade -Q "CYAN" -i "$editor" -p "Guitool (editor) [Y/n]: " "$editors" editor;
        if ! test -z "$editor"; then
            local diff merge
            if test "$editor" == "vim"; then
                git config "$global" merge.guitool vimdiff
            elif test "$editor" == "gvim"; then 
                git config "$global" merge.guitool gvimdiff
            elif test "$editor" == "nvim"; then 
                git config "$global" merge.guitool nvimdiff
            elif test "$editor" == "emacs"; then 
                git config "$global" merge.guitool emerge
            elif test "$editor" == "vscode"; then 
                git config "$global" mergetool.vscode.cmd 'code --wait $MERGED'
                git config "$global" merge.guitool vscode
            fi
        fi
    fi 

    local diffguipre="n"
    if test "$(git config $global --list | grep 'mergetool.prompt' | awk 'BEGIN { FS = "=" } ;{print $2;}')" == '' ; then
        diffguipre="y"
    fi
    reade -Q "CYAN" -i "$diffguipre" -p "Set mergetool prompt? [Y/n]: " "n" conflict;
    if test $conflict == "y"; then
        reade -Q "GREEN" -i "false" -p "Prompt?: " "true false" prompt;
        if ! test -z "$cstyle"; then
            git config mergetool.prompt "$prompt"
        fi
    fi

    local diffguipre="n"
    if test "$(git config $global --list | grep 'merge.conflictsstyle' | awk 'BEGIN { FS = "=" } ;{print $2;}')" == '' ; then
        diffguipre="y"
    fi
    reade -Q "CYAN" -i "$diffguipre" -p "Set merge conflictsstyle? [Y/n]: " "n" conflict;
    if test $conflict == "y"; then
        reade -Q "GREEN" -i "diff3" -p "Conflictsstyle: " "diff diff1 diff2 diff3" cstyle;
        if ! test -z "$cstyle"; then
            git config "$global" merge.conflictsstyle "$cstyle" 
        fi
    fi

    reade -Q "GREEN" -i "y" -p "Check git config? [Y/n]: " "n" gitcnf ;
    if [ "y" == "$gitcnf" ]; then
        git config $global -e
    fi

    reade -Q "GREEN" -i "y" -p "Check and create global gitignore? (~/.config/git/ignore) [Y/n]: " "n" gitign
    if [ "y" == "$gitign" ]; then
        if ! test -f install_gitignore.sh; then
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_gitignore.sh)"
        else
           ./install_gitignore.sh
        fi 
    fi

    if ! type lazygit &> /dev/null; then
        if ! test -f install_lazygit.sh; then
            eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_lazygit.sh)" 
        else
           ./install_lazygit.sh
        fi 
    fi
    
    local diffpre="n"
    if ! grep -q 'pager:' ~/.config/lazygit/config.yml ; then
        diffpre="y"
    fi 
    if type lazygit &> /dev/null; then
        reade -Q "CYAN" -i "$diffpre" -p "Configure custom interactive diff filter for Lazygit? [Y/n]: " "n" gitdiff1 ;     
        if [ "y" == "$gitdiff1" ]; then
            git_hl "lazygit"
        fi 
    fi
    
    
    if ! test -f ~/.bash_aliases.d/fzf-git.sh; then
        reade -Q "GREEN" -i "y" -p "Install fzf-git? (Extra fzf stuff on leader-key C-g): [Y/n]: " "n" gitfzf
        if [ "$fzfgit" == "y" ]; then
            if ! test -f checks/check_aliases_dir.sh; then
                eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_aliases_dir.sh)" 
            else
               . ./checks/check_aliases_dir.sh
            fi
            wget -O ~/.bash_aliases.d/fzf-git.sh https://raw.githubusercontent.com/junegunn/fzf-git.sh/main/fzf-git.sh 
        fi
    fi

    local gitals
    reade -Q "GREEN" -i "y" -p "Install git.sh? (Git aliases) [Y/n]: " "n" gitals
    if [ "$gitals" == "y" ]; then
        if ! test -f checks/check_aliases_dir.sh; then
            eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_aliases_dir.sh)" 
        else
           . ./checks/check_aliases_dir.sh
        fi
        if ! test -f aliases/.bash_aliases.d/git.sh; then
            wget -O ~/.bash_aliases.d/git.sh https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/git.sh  
        else
            cp -fv aliases/.bash_aliases.d/git.sh ~/.bash_aliases.d/
        fi
    fi

    unset gitdiff diff gitmerge merge amt rslt gitcnf gitign
}
gitt "$@"
