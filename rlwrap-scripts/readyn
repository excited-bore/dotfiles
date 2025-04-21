#!/bin/bash

if test -n "$BASH_VERSION"; then
    SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
    #SCRIPT_DIR=$(dirname "$0")
fi

if test -n "$ZSH_VERSION"; then
    SCRIPT_DIR="${0:A:h}"
fi

! test -f $SCRIPT_DIR/reade && ! test -f $SCRIPT_DIR/01-reade.sh &&
printf "'reade' needs to be in the same folder as 'readyn' for it to work\n" ||
test -f $SCRIPT_DIR/reade && source $SCRIPT_DIR/reade || 
test -f $SCRIPT_DIR/01-reade.sh && source $SCRIPT_DIR/01-reade.sh &> /dev/null

function readyn(){
    
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

    while :; do
        case $1 in
            -h|-\?|--help|'')
                printf "     ${bold}readyn${normal} [ -h/--help ] [ -v/--version ]  [ -y/--yes [ PREFILL ] ]  [ -n/--no [ CONDITION ] ] [ -p/--prompt PROMPTSTRING ] [ -Q/--colour COLOURSTRING ]  [ -b/--break-chars BREAK-CHARS ] [ returnvar ]\n
         Simplifies yes/no prompt for ${bold}reade${normal}. 
         Takes at least one argument, otherwise will prompt help page.
         
         Like 'read' and 'reade', supply at a variable as the last argument for the return value. 
         Otherwise the value will be in the '\$REPLY' and '\$READE_VALUE'.    
         '${GREEN} [${underline_on}Y${underline_off}es/${underline_on}n${underline_off}o]: ${normal}' : 'y' as pre-given, 'n' as other option. Colour for the prompt is ${GREEN}GREEN (Default)${normal} 
         '${YELLOW} [${underline_on}N${underline_off}o/${underline_on}y${underline_off}es]: ${normal}' : 'n' as pre-given, 'y' as other option. Colour for the prompt is ${YELLOW}YELLOW${normal}
         For both an empty answer will return the default answer. 

        -h, --help  
            
            Print this text and exit
         
        -p, --prompt ${underline_on}PROMPTSTRING${underline_off} 

            Prompt to supply. At the end of the prompt '[${underline_on}Y${underline_off}es/${underline_on}n${underline_off}o]: ' or '[${underline_on}N${underline_off}o/${underline_on}y${underline_off}es]: ' will appear.  

        -y, --yes [ ${underline_on}prefill${underline_off} ], [[ ${underline_on}prefill-prompt${underline_off} ]] 
            Set to 'Yes' prompt with 2 optional, comma-separated arguments 
            Pregiven is 'y' without argument, otherwise first becomes pregiven. 
            Second optional is the prefill word in coloured prompt ([Word]), otherwise defaults to '[${underline_on}Y${underline_off}es/${underline_on}n${underline_off}o]: ' 

        -n, --no [ ${underline_on}prefill${underline_off} ], [[ ${underline_on}prefill-prompt${underline_off} ]] 
            Same as for --yes but 'no' variant
            Default pregiven is 'n', prompt word in prompt defaults to '[${underline_on}N${underline_off}o/${underline_on}y${underline_off}es]: ' when only '--no' is supplied
            
            If neither '--no' or '--yes' are active => yes-prompt 

        -c, --condition ${underline_on}CONDITION${underline_off} 

            At default will prefer to prompt the '--no' flag over the '--yes' flag. 
            If you only want the '--no' prompt to be applicable when a given condition is active then give it up as an argument in a string. 

        -Y, --yes-colour ${underline_on}COLOUR${underline_off}
            Default: ${GREEN}GREEN${normal} 

        -N, --no-colour ${underline_on}COLOUR${underline_off}
            Default: ${YELLOW}YELLOW${normal} 

            Only active if --yes(Default)/--no applicable. 
            Use  one  of  the  colour names black, red, green, yellow, blue, cyan, purple (=magenta) or white, or an ANSI-conformant <colour_spec> to colour any prompt displayed  by  command.\n\tAn uppercase colour name (Yellow or YELLOW ) gives a bold prompt.\n Prompts that already contain (colour) escape sequences or one of the readline \"ignore markers\" (ASCII 0x01 and 0x02) are not coloured.

        -a, --auto 
            
            Fill in with the pregiven immediately

        -b ${underline_on}list_of_characters${underline_off} 

            (Applicable when ${bold}rlwrap${normal} installed - from manual):
            Consider  the specified characters word-breaking (whitespace is always word-breaking). 
            This determines what is considered a \"word\", both when completing and when building a completion word list from files specified by -f options following (not preceding!) it.
            Default list (){}[],'+-=&^%%\$#@\";|\  
            Unless -c is specified, / and . (period) are included in the default list\n\n"
            return 0
          ;;
          -v|--version) 
             printf "${bold}Version${normal} : $VERSION\n"
             return 0
          ;; 

          # Otherwise 
          *) break 
          ;;
       esac
    done && OPTIND=1;


    #https://stackoverflow.com/questions/12022592/how-can-i-use-long-options-with-the-bash-getopts-builtin

    for arg in "$@"; do
      shift
      case "$arg" in
        '--yes')               set -- "$@" '-y'   ;;
        '--no')                set -- "$@" '-n'   ;;
        '--yes-colour')        set -- "$@" '-Y'   ;;
        '--auto')              set -- "$@" '-a'   ;;
        '--no-colour')         set -- "$@" '-N'   ;;
        '--prompt')            set -- "$@" '-p'   ;;
        '--condition')         set -- "$@" '-c'   ;;
        '--break-chars')       set -- "$@" '-b'   ;;
        *)                     set -- "$@" "$arg" ;;
      esac
    done 
   
    local breaklines=''
    local condition='' 
    local args=''
    local pre='y'
    local preff=''
    local pre_y='y'
    local pre_n='n' 
    local othr='n' 
    local prmpty="${underline_on}Y${underline_off}es"
    local prmptn="${underline_on}n${underline_off}o"
    local ycolor='GREEN' 
    local ncolor='YELLOW' 
    local color="$ycolor" 
    local ygivn=0, ngivn=0 
    local auto=''

    OPTIND=1
    while getopts 'anyb:Y:N:c:p:y:n:' flag; do
        case "${flag}" in
             a)  auto='y' 
                 ;;
             b) if [[ "${OPTARG}" ]] && ! [[ "${OPTARG}" == '--' ]] && ! [[ ${OPTARG} =~ ^-.* ]]; then 
                    breaklines="-b \"${OPTARG}\"";
                fi 
                if [[ ${OPTARG} =~ ^-.* ]]; then
                    OPTIND=$(($OPTIND - 1)) 
                fi
             ;;    
             Y) if [[ "${OPTARG}" ]] && ! [[ "${OPTARG}" == '--' ]] && ! [[ ${OPTARG} =~ ^-.* ]]; then 
                    ycolor="${OPTARG}";
                fi
                if [[ ${OPTARG} =~ ^-.* ]]; then
                    OPTIND=$(($OPTIND - 1)) 
                fi
             ;;    
             N) if [[ "${OPTARG}" ]] && ! [[ "${OPTARG}" == '--' ]] && ! [[ ${OPTARG} =~ ^-.* ]]; then
                    ncolor="${OPTARG}";
                fi
                if [[ ${OPTARG} =~ ^-.* ]]; then
                    OPTIND=$(($OPTIND - 1)) 
                fi 
             ;;    
             p) if [[ "${OPTARG}" ]] && ! [[ "${OPTARG}" == '--' ]] && ! [[ ${OPTARG} =~ ^-.* ]]; then
                    prmpt="${OPTARG}";
                fi
                if [[ ${OPTARG} =~ ^-.* ]]; then
                    OPTIND=$(($OPTIND - 1)) 
                fi 
             ;;
             y)  preff='y'
                 args='' 
                 if [[ "${OPTARG}" ]] && ! [[ "${OPTARG}" == '--' ]] && ! [[ ${OPTARG} =~ ^-.* ]]; then

                    # disable glob 
                    set -f 

                    # split on space characters 
                    IFS=',' 

                    args=($OPTARG);
                    pre_y="${args[0]}" 
                    ! test -z "${args[1]}" && prmpty="${args[1]}" 
                else
                    pre='y' 
                    prmpty="${underline_on}Y${underline_off}es"
                    prmptn="${underline_on}n${underline_off}o" 
                    if [[ ${OPTARG} =~ -.* ]]; then
                        OPTIND=$(($OPTIND - 1)) 
                    fi
                fi
                ;;

            n)  preff='n'
                args='' 
                if [[ "${OPTARG}" ]] && ! [[ "${OPTARG}" == '--' ]] && ! [[ ${OPTARG} =~ ^-.* ]]; then
                    set -f 
                    IFS=',' 
                    args=($OPTARG);
                    pre_n="${args[0]}"
                    ! test -z "${args[1]}" && prmptn="${args[1]}"  
                else
                    pre='n'
                    prmptn="${underline_on}N${underline_off}o"
                    prmpty="${underline_on}y${underline_off}es" 
                    if [[ ${OPTARG} =~ ^-.* ]]; then
                        OPTIND=$(($OPTIND - 1)) 
                    fi
                fi
                ;; 

              c) if [[ "${OPTARG}" ]] && ! [[ "${OPTARG}" == '--' ]] && ! [[ ${OPTARG} =~ ^-.* ]]; then
                    condition="${OPTARG}"
                fi 
                if [[ ${OPTARG} =~ ^-.* ]]; then
                    OPTIND=$(($OPTIND - 1)) 
                fi 
                ;;
        esac
    done 

    shift $((OPTIND-1)) 

    if test -z "$preff" || [[ "$preff" == 'y' ]]; then
        prmpt1=" [$prmpty/$prmptn]: "
        color="$ycolor"
        pre=$pre_y 
        othr=$pre_n 
    else
        prmpt1=" [$prmptn/$prmpty]: "
        color="$ncolor"
        pre=$pre_n 
        othr=$pre_y 
    fi

    if ! test -z "$condition" && eval "${condition}"; then
        [[ "$prmptn" == "${underline_on}n${underline_off}o" ]] && prmptn="${underline_on}N${underline_off}o"  
        [[ "$prmpty" == "${underline_on}Y${underline_off}es" ]] && prmpty="${underline_on}y${underline_off}es"  
        prmpt1=" [$prmptn/$prmpty]: "
        color="$ncolor"
        pre=$pre_n 
        othr=$pre_y 
    fi

    if ! test -z "$auto"; then
        if test -z "$prmpt"; then
            test -z $ZSH_VERSION &&
                printf "${!color}$prmpt1$pre${normal}\n" ||
                printf "${(P)color}$prmpt1$pre${normal}\n";   
        else
            test -z $ZSH_VERSION &&
                printf "${!color}$prmpt$prmpt1$pre${normal}\n" || 
                printf "${(P)color}$prmpt$prmpt1$pre${normal}\n";   

        fi
        vvvvvvvvvv=$pre 
    else
        if test -z "$prmpt"; then
            reade -Q "$color" $breaklines -i "$pre $othr" -p "$prmpt1" vvvvvvvvvv;   
        else
            reade -Q "$color" $breaklines -i "$pre $othr" -p "$prmpt$prmpt1" vvvvvvvvvv;    
        fi
         
    fi 

    export READE_VALUE="$vvvvvvvvvv" 
    export REPLY="$vvvvvvvvvv" 

    if ! test $# -eq 0; then
        eval "${@:$#:1}=$vvvvvvvvvv" 
    fi
}
