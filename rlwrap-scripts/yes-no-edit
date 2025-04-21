#!/bin/bash

# Get script dir when sourced

if test -z $ZSH_VERSION; then
    #[[ $0 != $BASH_SOURCE ]] && SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")" || SCRIPT_DIR="$(cd "$(dirname "$-1")" && pwd)"
    SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
else
    SCRIPT_DIR="${0:A:h}"
fi

! test -f $SCRIPT_DIR/reade && ! test -f $SCRIPT_DIR/01-reade.sh &&
    printf "'reade' needs to be in the same folder as 'yes-no-edit' for it to work\n" ||
    test -f $SCRIPT_DIR/reade && source $SCRIPT_DIR/reade ||
    test -f $SCRIPT_DIR/01-reade.sh && source $SCRIPT_DIR/01-reade.sh &>/dev/null

! test -f $SCRIPT_DIR/readyn && ! test -f $SCRIPT_DIR/02-readyn.sh &&
    printf "'readyn' needs to be in the same folder as 'yes-no-edit' for it to work\n" ||
    test -f $SCRIPT_DIR/readyn && source $SCRIPT_DIR/readyn ||
    test -f $SCRIPT_DIR/02-readyn.sh && source $SCRIPT_DIR/02-readyn.sh &>/dev/null

function yes-no-edit() {

    ! test -z $ZSH_VERSION &&
        #emulate sh &&
        #setopt KSH_ARRAYS
        setopt err_return extended_glob local_options local_traps

    local red=$(tput setaf 1)
    local red1=$(tput setaf 9)
    local green=$(tput setaf 2)
    local green1=$(tput setaf 10)
    local yellow=$(tput setaf 3)
    local yellow1=$(tput setaf 11)
    local blue=$(tput setaf 4)
    local blue1=$(tput setaf 12)
    local magenta=$(tput setaf 5)
    local magenta1=$(tput setaf 13)
    local cyan=$(tput setaf 6)
    local cyan1=$(tput setaf 14)
    local white=$(tput setaf 7)
    local white1=$(tput setaf 15)
    local black=$(tput setaf 16)
    local grey=$(tput setaf 8)

    local RED=$(tput setaf 1 && tput bold)
    local RED1=$(tput setaf 9 && tput bold)
    local GREEN=$(tput setaf 2 && tput bold)
    local GREEN1=$(tput setaf 10 && tput bold)
    local YELLOW=$(tput setaf 3 && tput bold)
    local YELLOW1=$(tput setaf 11 && tput bold)
    local BLUE=$(tput setaf 4 && tput bold)
    local BLUE1=$(tput setaf 12 && tput bold)
    local MAGENTA=$(tput setaf 5 && tput bold)
    local MAGENTA1=$(tput setaf 13 && tput bold)
    local CYAN=$(tput setaf 6 && tput bold)
    local CYAN1=$(tput setaf 14 && tput bold)
    local WHITE=$(tput setaf 7 && tput bold)
    local WHITE1=$(tput setaf 15 && tput bold)
    local BLACK=$(tput setaf 16 && tput bold)
    local GREY=$(tput setaf 8 && tput bold)

    local bold=$(tput bold)
    local underline_on=$(tput smul)
    local underline_off=$(tput rmul)
    local bold_on=$(tput smso)
    local bold_off=$(tput rmso)
    local half_bright=$(tput dim)
    local reverse_color=$(tput rev)

    # Reset
    local normal=$(tput sgr0)

    # Broken !! (Or im dumb?)
    local blink=$(tput blink)
    local underline=$(tput ul)
    local italic=$(tput it)

    local VERSION='1.0'

    local hlpstr="${bold}YES-NO-EDIT${normal} [ -h/--help ] [ -v/--version] [ -d/--dont-add-prompt ] [ -o/--other COMMAND, PROMPTDESCRIPTION [, REPLACEEDIT (Y/n)]] [ -n/--no-askagain [ Y(Default)/N ] ] [ -e/--editor EDITOR ]  [ -g/--files-to-edit SPACESEPERATED-FILESTRING ] [ -i/--default-inserted YES(Default)/EDIT/NO(/OTHERDESCRIPTION) ] [ -p/--prompt PROMPTSTRING ] [ -Q/--colour COLOURSTRING ] [ -b/--break-chars BREAKCHARS-STRING ] [ -f/--function FUNCTION ] [ ${bold}SPACESEPARATED FILE(S)STRING${normal} ] [ ${bold}RETURNVAR${normal} ] 

        Simplifies prompt for ${bold}read/rlwrap${normal} specifically for when file(s) need to be reviewed before installation 
        - repeats prompt as long neither 'yes' nor 'no' is chosen 
        - Relies on 'reade' and 'readyn' (and preferably rlwrap) being installed

        Needs at least 2 parameters.
        1) File(s) to edit/use commands on (if -g/--files-to-edit is not used yet)
        2) Returnvar (only necessary if -f/--function is not used), will contain at default (if -o/--other is not supplied) 'yes' or 'no' ('edit' also if -n/--no-askagain is supplied) 
        
        Adding prompt using -p/--prompt is heavily recommended. Adds '[Y(es)/n(o)/e(dit)[/o(ther)]]: ' afterward) 
       
        -h, --help  
            
            Print this text and exit

        -v, --version  
            
            Print version and exit

        -d, --dont-add-prompt

            At default something along the lines of '[${bold}Y(es)${normal}/n(o)/e(dit)]: ' will be added at the end of the prompt. With this option, that won't be the case.

        -o, --other COMMAND, PROMPTDESCRIPTION [, REPLACEEDIT (Y/n)]
            
            Supply another kind of command other then 'edit' to perform together with the description of what's supposed to be done in string format as to be added to the prompt as long as -d/--dont-add-prompt is not supplied. There's a last option not to replace edit with this new command 

            For example: 'yes-no-edit --other=less,\"pager\",n' would add '[${bold}Y(es)${normal}/n(o)/e(dit)/p(ager)]: ' to the prompt and use less if 'p' was given'

        -n, --no-askagain [ Y/N STRING ] 

            Normally after prompted once and edit/other is chosen, it will repeat the prompt (while showing the diffs if edited). With -n, --noaskagain it will ask one last yes/no question and then quit (and if -f/--function is not empty, it will execute said function if yes is answered)
            It takes the optional string argument of what is pregiven with this second question: (y)es (default) or (n)o.
            f.ex. yes-no-edit --no-askagain='n'
        
       -e, --editor EDITOR 
         
            What editor to use. Looks at \$EDITOR if not given, otherwise will look whether nvim, vim, nano or vi exists. Not applicable if 'edit' option is replaced by another command with -o/--other.        

       -g, --files-to-edit SPACESEPERATED-FILESTRING 
         
            String with space separated filenames (if not given, expected as in spaceseparated stringform before RETURNVAR)
       
       -f, --function FUNCTION
            
           If supplied, no returnvar will be given but instead the supplied function will be executed when 'yes' is prompted.   

       -p, --prompt PROMPTSTRING 
             
       String to be given as prompt. At default something along the lines of '[${bold}Y(es)${normal}/n(o)/e(dit)]: ' will be added at the end of the prompt if -d/--dont-add-prompt is not supplied. 
            This last part will also be shown in the colour/style supplied by -Q/--colour.

       -i, --default-inserted YES(Default)/EDIT/NO(/OTHERDESCRIPTION)
        
       What's the first prefilled and first in the string that's highlighted in bold at the end of the prompt? (this would be nullified if -d,--dont-ask-prompt is supplied) 

            At default this is '[${bold}Y(es)${normal}/n(o)/e(dit)]: ' 
            If --default-inserted='no' is given, it would become '[${bold}N(o)${normal}/(y)es/e(dit)]: '  
            If --default-inserted='edit' is given, it would become '[${bold}E(dit)${normal}/(y)es/n(o)]: '
            If \"yes-no-edit --other=less,'pager' --default-inserted=pager \" is given without adding -d/--dont-add-prompt, it would become ''[${bold}P(ager)${normal}/(y)es/n(o)]: '   

       -Q, --colour COLOURSTRING

            Use  one  of  the  colour names black, red, green, yellow, blue, cyan, purple (=magenta) or white, or an ANSI-conformant <colour_spec> to colour any prompt displayed  by  command.\n An uppercase colour name (Yellow or YELLOW ) gives a bold prompt.\n Prompts that already contain (colour) escape sequences or one of the readline \"ignore markers\" (ASCII 0x01 and 0x02) are not coloured.

       -b ${underline_on}LIST_OF_CHARACTERS${underline_off} 

           (From rlwrap manual) Consider  the specified characters word-breaking (whitespace is always word-breaking). This determines what is considered a \"word\", both when completing and when building a completion word list from files specified by -f options following (not preceding!) it.\n Default list (){}[],'+-=&^%%\$#@\";|\ \n Unless -c is specified, / and . (period) are included in the default list\n\n"

    while :; do
        case $1 in
        '' | -h | -\? | --help)
            printf "$hlpstr"
            return 0
            ;;
        -v | --version)
            printf "${bold}Version${normal} : $VERSION\n"
            return 0
            ;;
        # Otherwise
        *)
            break
            ;;
        esac
    done && OPTIND=1

    #https://stackoverflow.com/questions/12022592/how-can-i-use-long-options-with-the-bash-getopts-builtin

    for arg in "$@"; do
        shift
        case "$arg" in
        '--break-chars') set -- "$@" '-b' ;;
        '--dont-add-prompt') set -- "$@" '-d' ;;
        '--editor') set -- "$@" '-e' ;;
        '--function') set -- "$@" '-f' ;;
        '--files-to-edit') set -- "$@" '-g' ;;
        '--default-inserted') set -- "$@" '-i' ;;
        '--no-askagain') set -- "$@" '-n' ;;
        '--other') set -- "$@" '-o' ;;
        '--prompt') set -- "$@" '-p' ;;
        '--colour') set -- "$@" '-Q' ;;
        *) set -- "$@" "$arg" ;;
        esac
    done

    if [[ -z "$1" ]] || [[ -z "$2" ]]; then
        printf "yes-no-edit needs at least 2 parameters.
        1) String with seperated file(s) to edit/use commands on (if -g/--files-to-edit is not used yet)
        2) Returnvar (if 'yes/no' is passed - only necessary if -f/--function is not used)\n"
        return 0
    else
        local pre="y"
        local choices=("y" "n" "e")
        local choicesp=("y(es)" "n(o)" "e(dit)")
        local prmpt=''
        local prmpt1=''
        local color=""
        local YES_NO_EDITOR="$EDITOR"
        local othercmd=''
        local other=''
        local first=''
        local editreplaced='n'
        local noprompt=''
        local norepeat=''
        local functn=""
        local files=""

        while getopts 'db:n:o:Q:i:e:g:f:p:' flag; do
            case "${flag}" in
            b) ;;
            d) noprompt='y'
                ;;
            o)
                local j=0
                for i in $(echo ${OPTARG} | sed "s/,/ /g"); do
                    if [[ $j == 0 ]]; then
                        othercmd="$i"
                    elif [[ $j == 1 ]] && test -z "$noprompt"; then
                        test -z $i &&
                            printf "'-o/--other' takes 2 positional arguments: 
                                        1) the name of the command
                                        2) the action performed to portray in the prompt (like 'pager')\n" &&
                            return 0
                        other="$i"
                        first=$(echo $other | cut -c1-1)

                        choices+=("$first")
                        # Bless this post, how did I not know about `` in bash beforehand ???
                        # https://stackoverflow.com/questions/27791251/get-first-character-of-a-string-shell
                        choicesp+=("$first("$(cut -d "$first" -f2- <<<$other)")")
                    elif [[ $j == 2 ]] && ! test -z "$i"; then
                        YES_NO_EDITOR="$othercmd"
                        editreplaced='y'
                        [[ " ${choices[*]} " =~ " e " ]] && unset $choices[2]
                        [[ " ${choicesp[*]} " =~ " e(dit) " ]] && unset $choicesp[2]
                    fi
                    j=$((j + 1))
                done
                unset j i
                [[ ${OPTARG} =~ ^-.* ]] && OPTIND=$(($OPTIND - 1))
                ;;
            e)
                test -z "${OPTARG}" &&
                    printf "The flag -e/--editor requires an argument, namely an editor name\n" &&
                    return 0 ||
                    YES_NO_EDITOR="${OPTARG}"
                ;;
            Q)
                color="${OPTARG}"
                ;;
            i)
                local found='n'
                local i=0
                
                test -n "$BASH_VERSION" && 
                
                # Bash variant - list arrays
                for i in "${!choices[@]}"; do
                    if [[ "${choices[$i]}" == "${OPTARG}" ]]; then
                        found='y'
                        unset choices[$i];
                        choices=("${OPTARG}" ${choices[@]})
                        pre=${OPTARG}
                        break
                    fi
                done  
                
                # Zsh variant -- associative arrays
                test -n "$ZSH_VERSION" && 

                local indice=0  &&
                for i in "${choices[@]}"; do
                    if [[ "$i" == "${OPTARG}" ]]; then
                        found='y'
                        indice=${choices[(i)$i]}
                        choices[$indice]=() 
                        choices=("${OPTARG}" ${choices[@]})
                        pre=${OPTARG}
                        break
                    fi
                done
                
                [[ "$found" == 'n' ]] &&
                    printf "${OPTARG} is not a choice between '${choices[*]}'\n" &&
                    return 0

                if test -z "$noprompt"; then

                    test -n "$BASH_VERSION" && 
                    
                    # Bash variant - list arrays
                    prmpt1=" [${bold}${choicesp[$i]^}" && 
                    unset choicesp[$i] &&
                    for i in "${!choicesp[@]}"; do                          
                        prmpt1="$prmpt1/${choicesp[$i]}" 
                        unset $choicesp[$i]; 
                    done && i=0

                    # ZSH can't do ${string^} text substition like bash
                    # (capitalize the first letter in a string)
                    test -n "$ZSH_VERSION" && 
                    
                    local fst="$(tr '[:lower:]' '[:upper:]' <<<${choicesp[$indice]:0:1})${choicesp[$indice]:1}" &&
                    prmpt1=" [${bold}$fst" && 
                    choicesp[$indice]=() && 
                    for i in "${choicesp[@]}"; do
                        prmpt1="$prmpt1/$i" 
                        choicesp[${choicesp[(i)$i]}]=() 
                    done && i=0

                    prmpt1="$prmpt1]:${normal} "
                fi
                ;;
            f)
                test -z "${OPTARG}" &&
                    printf "This flag requires a function to call back to if 'yes' is given at a certain point\n" &&
                    return 0 ||
                    functn="${OPTARG}"
                ;;
            p)
                prmpt="${OPTARG}"
                ;;
            g)
                test -z "${OPTARG}" &&
                    printf "This flag requires a string with files to edit/review\n" &&
                    return 0 ||
                    files="${OPTARG[@]}"
                ;;
            n)
                if ! test -z ${OPTARG} && [[ ${OPTARG} == 'n' || ${OPTARG} == 'y' ]]; then
                    norepeat=${OPTARG}
                else
                    norepeat='y'
                fi
                [[ ${OPTARG} =~ ^-.* ]] && OPTIND=$(($OPTIND - 1))
                ;;
            esac
        done

        shift $((OPTIND - 1))

        if test -z "$files"; then
            if [[ $# -eq 1 ]] || [[ $# -gt 1 ]]; then
                ! test -z "$functn" && test $# -gt 1 && files="${@:$#:2}" ||
                    test $# -eq 1 && files="${@:$#:1}"
            else
                printf "String with seperated file(s) to edit/use commands on (if -g/--files-to-edit has not been given\n Exiting\n"
                return 0
            fi
        fi

        if test -z "$YES_NO_EDITOR"; then
            if type nvim &>/dev/null; then
                YES_NO_EDITOR='nvim'
            elif type vim &>/dev/null; then
                YES_NO_EDITOR='vim'
            elif type nano &>/dev/null; then
                YES_NO_EDITOR='nano'
            elif type vi &>/dev/null; then
                YES_NO_EDITOR='vi'
            fi
        fi

        test -z "$noprompt" && prmpt2="$prmpt$prmpt1" || prmpt2="$prmpt"

        test -z $color && reade -i "${choices[*]}" -p "$prmpt2" vvvvvvvvvv ||
            reade -Q $color -i "${choices[*]}" -p "$prmpt2" vvvvvvvvvv

        #Undercase only
        vvvvvvvvvv=$(echo "$vvvvvvvvvv" | tr '[:upper:]' '[:lower:]')

        if [[ "$vvvvvvvvvv" == 'e' ]]; then
            ${YES_NO_EDITOR} ${files[*]}
        elif ! test -z "$first" && [[ "$vvvvvvvvvv" == "$first" ]]; then
            ${othercmd} ${files[*]}
        fi

        if ! test -z "$norepeat"; then
            if ! [[ "$vvvvvvvvvv" == 'n' ]] && ! [[ "$vvvvvvvvvv" == 'y' ]]; then
                if [[ "$norepeat" == 'n' ]]; then
                    test -z $color && readyn --no "$prmpt" vvvvvvvvvv ||
                        readyn --no -N $color -p "$prmpt" vvvvvvvvvv
                else
                    test -z $color && readyn "$prmpt" vvvvvvvvvv ||
                        readyn -Y $color -p "$prmpt" vvvvvvvvvv
                fi
            fi
        else
            while :; do
                [[ "$vvvvvvvvvv" == 'y' ]] || [[ "$vvvvvvvvvv" == 'n' ]] && break

                if test -z $color; then 
                    reade -i "${choices[*]}" -p "$prmpt2" vvvvvvvvvv || break
                else
                    reade -Q "$color" -i "${choices[*]}" -p "$prmpt2" vvvvvvvvvv || break
                fi
                
                # For whatever reason,  ' || break' doesnt work so this check here is being put here if something like an interrupt occured
                test -z $vvvvvvvvvv && break
                
                # Undercase only
                vvvvvvvvvv=$(echo "$vvvvvvvvvv" | tr '[:upper:]' '[:lower:]')

                [[ "$vvvvvvvvvv" == 'y' ]] || [[ "$vvvvvvvvvv" == 'n' ]] && break

                if [[ "$vvvvvvvvvv" == 'e' ]]; then
                    ${YES_NO_EDITOR} ${files[*]}
                elif test -n "$first" && [[ "$vvvvvvvvvv" == "$first" ]]; then
                    ${othercmd} ${files[*]}
                fi
            done
        fi

        test -n "$functn" && [[ "$vvvvvvvvvv" == 'y' ]] && 
            ${functn} && return 0 ||
        test $# -gt 0 && 
            eval "${@:$#:1}=$vvvvvvvvvv"

    fi
}
