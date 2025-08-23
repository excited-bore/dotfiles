# EEEEEUUUUUUH BASH REGEX?????
# https://unix.stackexchange.com/questions/421460/bash-regex-and-https-regex101-com

# This explains a ton
# https://unix.stackexchange.com/questions/251013/bash-regex-capture-group


global_rematch() { 
    local s=$1 regex=$2 

    # https://stackoverflow.com/questions/10582763/how-to-return-an-array-in-bash-without-using-globals
    local -n array=$3
    array=()
    
    while [[ $s =~ $regex ]]; do 
        array+=("${BASH_REMATCH[0]}")
        s=${s#*"${BASH_REMATCH[0]}"}
    done
}

unset_array(){
    local -n array=$1
    local indx
    if test -z $2; then
        indx=0
    else
        indx=$2
    fi
    local new_array
    for i in "${!array[@]}"; do
        if ! [[ $i == $indx ]]; then
            new_array+=( "${array[$i]}" )
        fi
    done
    array=("${new_array[@]}")
    unset new_array
}

TRANSPOSE_QUOTED=1

transpose_words() {
    local wordsorspace='space' 
    if test -n "$1" && ! [[ "$1" == 'space' ]]; then
        wordsorspace='words' 
    fi
    
    local directn='left'
    if test -n "$2" && ! [[ "$2" == 'left' ]]; then
        directn='right' 
    fi

    local only_exclude_spaces='[^[:space:]]+'
    local include_only_alphanums='[A-Za-z0-9]+' 

    local notquotedspace_exclude_space='("[^"]*")+|('\''[^'\'']*'\'')+|[^[:space:]]+' 
   
    local words 
    if [[ "$wordsorspace" == 'space' ]]; then 
        [[ $TRANSPOSE_QUOTED ]] && 
            words=$notquotedspace_exclude_space || 
            words=$only_exclude_spaces
    else
        words=$include_only_alphanums
    fi

    local only_include_spaces='[[:space:]]+'  
    local exclude_only_aphanums='[^A-Za-z0-9]+' 
   
    local non_words
    if [[ "$wordsorspace" == 'space' ]]; then
        non_words=$only_include_spaces
    else
        non_words=$exclude_only_aphanums   
    fi 

    local firstnonspaceword='^([^[:space:]]+)' 
    local firstalphanumericword='^([A-Za-z0-9]+)'

    local quotedfirstnonspaceword='^(("[^"]*"+|'\''[^'\'']*'\''+)*[^[:space:]]+)' 

    local firstwordpattrn
    if [[ "$wordsorspace" == 'space' ]]; then
        [[ $TRANSPOSE_QUOTED ]] && 
            firstwordpattrn=$quotedfirstnonspaceword || 
            firstwordpattrn=$firstnonspaceword
    else
        firstwordpattrn=$firstalphanumericword   
    fi


    local tolastnonspaceword='[[:space:]]+[^[:space:]]+$'

    local tolastalphanumericword='[^A-Za-z0-9]+[A-Za-z0-9]+$' 

    local tolastwordpattrn
    if [[ "$wordsorspace" == 'space' ]]; then
        tolastwordpattrn=$tolastnonspaceword  
    else
        tolastwordpattrn=$tolastalphanumericword   
    fi    
    
    local arr arrr line
   
    # Checks leading and trailing spaces, for escaped spaced words which it quotes using '', then exit
    local re='(([^[:space:]'\'']*\\ )+[^[:space:]'\'']*)'
    if [[ "${READLINE_LINE}" =~ $re ]] || [[ "${READLINE_LINE: -1}" == ' ' ]] || [[ ${READLINE_LINE:0:1} == ' ' ]]; then
         
        local quoteds
        global_rematch "${READLINE_LINE}" "$re" quoteds 

        while [[ "${READLINE_LINE}" =~ $re ]] || [[ "${READLINE_LINE: -1}" == ' ' ]] || [[ ${READLINE_LINE:0:1} == ' ' ]]; do

            # Remove leading whitespace
            if [[ "${READLINE_LINE:0:1}" == ' ' ]]; then
                READLINE_LINE="${READLINE_LINE:1}" 
            fi

            # Remove trailing whitespace
            if [[ "${READLINE_LINE: -1}" == ' ' ]]; then
                READLINE_LINE="${READLINE_LINE::-1}" 
            fi
            
            # Quoted escaped spaced words
            if [[ "${READLINE_LINE}" =~ $re ]]; then
                local i=${BASH_REMATCH[0]}
                #echo "'$i'" 
                local j="'$(eval "echo $i")'"
                local ree='.*'$(printf %q "$i")''
                
                if [[ $READLINE_LINE =~ $ree ]]; then
                    local suffxcount=$(($(echo "${BASH_REMATCH[0]}" | wc --chars)))
                    local preffxcount=$(($suffxcount - $(echo $i | wc --chars)))
                    #echo "'${BASH_REMATCH[0]}'"
                    #echo "Suffix: '${READLINE_LINE:$suffxcount}'" 
                    #echo "Suffix - 1: '${READLINE_LINE:$((suffxcount - 1))}'" 
                    #echo "Prefix: '${READLINE_LINE:0:$preffxcount}'" 
                    
                    # Idk but if it loops over multiple (similar??) words that need quoting, it miscounts and IDK ive gone over it multiple times im doing this terribleness  
                    if [[ ${#quoteds} -gt 1 ]]; then
                        READLINE_LINE="${READLINE_LINE:0:$preffxcount}$j${READLINE_LINE:$((suffxcount - 1))}" 
                    else
                        READLINE_LINE="${READLINE_LINE:0:$preffxcount}$j${READLINE_LINE:$suffxcount}" 
                    fi
                    #echo $READLINE_LINE 
                fi
            
            fi
        done 
        return 0 
    fi

    global_rematch "${READLINE_LINE}" "$words" arr
    
    local args=${#arr[@]} 
    if [[ $args -gt 1 ]]; then 

        # Chatgpt helped me with this one
        # Use a rare control char as placeholder,
        # then replace double-quoted and single-quoted strings with said placeholder
        
        if [[ "$wordsorspace" == 'space' ]] && [[ $TRANSPOSE_QUOTED ]]; then
            local placeholder=$'\x01'  
            line=$(echo "${READLINE_LINE}" | sed -E 's/"[^"]*"|'\''[^'\'']*'\''/'"$placeholder"'/g') 
        else
            line="${READLINE_LINE}"
        fi

        global_rematch "$line" $non_words arrr
        
        local index=0
        local olderprefix='' oldprefix='' prefix='' olderword='' olderspcl='' lastword=${arr[0]} lastspcl=${arrr[0]} newword=${arr[1]}  
        while ([[ ${#arr[@]} -ge 1 ]] || [[ ${#arrr[@]} -ge 1 ]]); do 
           
            local linechar=${READLINE_LINE:$index:1}

            local charcount=$(($(echo "${arr[0]}" | wc --chars) - 1)) 
            index=$(($index + $charcount)) 
            
            # get the firstword count and the count of the string up to the last alphanumerical 
            local firstword lasttword cntuptolastword

            if [[ $READLINE_LINE =~ $firstwordpattrn ]]; then
                firstword=$(($(echo "${BASH_REMATCH[0]}" | wc --chars) - 1)) 
            fi

            if [[ $READLINE_LINE =~ $tolastwordpattrn ]]; then
                lasttword=$(($(echo "${BASH_REMATCH[0]}" | wc --chars) - 1)) 
                cntuptolastword=$(($(echo "$READLINE_LINE" | wc --chars) - 1 - $lasttword)) 
            fi 

            if [[ "$lastword" =~ "$linechar" ]]; then

                local prfxcnt=$(($(echo "$prefix" | wc --chars) - 1))
                local oldprfxcnt line
                if [[ $index -eq $(($READLINE_POINT - 1)) ]] && [[ $READLINE_POINT == $cntuptolastword ]] && [[ "$directn" == 'right' ]]; then
                    line="$READLINE_LINE"
                    oldprfxcnt=${#READLINE_LINE}
                elif [[ $index -ge $READLINE_POINT ]]; then
                    if test -n "$olderprefix"; then
                        oldprfxcnt=$(($(echo "$olderprefix" | wc --chars) - 1))
                        if [[ "${#arr[@]}" == 1 ]] && [[ "$directn" == 'left' ]]; then
                            line="$olderprefix$newword$olderspcl$lastword" 
                        else 
                            if [[ "$directn" == 'left' ]]; then
                                local lntcnt=$(($(echo "$oldprefix$lastword" | wc --chars) - 1))
                                local suffix=${READLINE_LINE:$lntcnt}
                                line="$olderprefix$lastword$olderspcl$olderword$suffix" 
                            elif [[ $READLINE_POINT -lt $cntuptolastword ]]; then
                                oldprfxcnt=$(($(echo "$oldprefix$newword$lastspcl" | wc --chars) - 1)) 
                                local lntcnt=$(($(echo "$oldprefix$lastword$lastspcl$newword" | wc --chars) - 1))
                                local suffix=${READLINE_LINE:$lntcnt}
                                line="$oldprefix$newword$lastspcl$lastword$suffix" 
                            else
                                [[ "$directn" == 'right' ]] && ! [[ $READLINE_POINT = ${#READLINE_LINE} ]] &&
                                    READLINE_POINT=${#READLINE_LINE}
                                break
                            fi
                        fi
                    else
                        oldprfxcnt=0
                        if test -n "$oldprefix"; then
                            test -z "$olderspcl" && olderspcl="$lastspcl" && lastspcl=${arrr[1]}
                            if [[ "$directn" == 'left' ]]; then
                                local lntcnt=$(($(echo "$lastword$olderspcl$olderword" | wc --chars) - 1))
                                local suffix=${READLINE_LINE:$lntcnt}
                                line="$lastword$olderspcl$olderword$suffix" 
                            else
                                test -z "$prefix" && 
                                    prfxcnt=$(($(echo "${arr[0]}" | wc --chars) - 1))
                                oldprfxcnt=$(($(echo "$olderword$olderspcl$newword$lastspcl" | wc --chars) - 1))
                                local lntcnt=$(($(echo "$olderword$olderspcl$newword$lastspcl$lastword" | wc --chars) - 1))
                                local suffix=${READLINE_LINE:$lntcnt}
                                line="$olderword$olderspcl$newword$lastspcl$lastword$suffix" 
                            fi
                        elif ([[ "$directn" == 'left' ]] && [[ $READLINE_POINT -gt $firstword ]]) || [[ "$directn" == 'right' ]]; then
                            [[ "$directn" == 'right' ]] && 
                                oldprfxcnt=$(($(echo "$lastword$lastspcl$newword" | wc --chars) - 1)) 
                            test -z "$prefix" && prfxcnt=$(($(echo "$lastword" | wc --chars) - 1))
                            local wordcnt=$(($(echo "$lastword$lastspcl$newword" | wc --chars) - 1)) 
                            local suffix=${READLINE_LINE:$(($wordcnt))}
                            #    line="${READLINE_LINE $lastword$lastspcl$newword$suffix" ||
                            line="$newword$lastspcl$lastword$suffix" 
                        else
                            if [[ "$directn" == 'left' ]]; then
                                local firstwordcnt=$(($(echo "$firstword" | wc --chars)))
                                if [[ $READLINE_POINT == $firstwordcnt ]]; then
                                    local wordcnt=$(($(echo "$lastword$lastspcl$newword" | wc --chars) - 1)) 
                                    local suffix=${READLINE_LINE:$(($wordcnt))} 
                                    line="$newword$lastspcl$lastword$suffix" 
                                fi
                                READLINE_POINT=0
                            fi
                            break
                        fi
                    fi
                    local relpoint=$(($READLINE_POINT - $prfxcnt + $oldprfxcnt))
                    READLINE_LINE=$line
                    READLINE_POINT=$relpoint
                    break
                fi

                test -n "$oldprefix" && olderprefix=$oldprefix
                oldprefix=$prefix
                prefix="$prefix${arr[0]}"
                test -z "$oldprefix" && oldprefix=$prefix 
                unset_array arr 0; 
                olderword=$lastword 
                test -n "${arr[1]}" && 
                    lastword=$newword && newword=${arr[1]} ||
                    newword=${arr[0]}
            fi

            
            linechar=${READLINE_LINE:$index:1}
            charcount=$(($(echo "${arrr[0]}" | wc --chars) - 1)) 
            index=$(($index + $charcount))

            if [[ "$lastspcl" =~ "$linechar" ]]; then
                
                if [[ $index -ge $READLINE_POINT ]]; then
                    local oldprfxcnt line prfxcnt=0 relpoint
                    if test -n "$olderprefix"; then
                        prfxcnt=$(($(echo "$olderprefix" | wc --chars) - 1))
                        if [[ "$directn" == 'left' ]] && ([[ "${#arr[@]}" == 1 ]] || [[ $READLINE_POINT == ${#READLINE_LINE} ]] || [[ $READLINE_POINT == ${#arrr[-1]} ]]); then
                            relpoint=$(($(echo "$olderprefix" | wc --chars) - 1)) 
                            local lntcnt=$(($(echo "$olderprefix$lastword$lastspcl$olderword" | wc --chars) - 1))
                            local suffix=${READLINE_LINE:$lntcnt}
                            line="$olderprefix$newword$olderspcl$olderword" 
                        else 
                            if [[ "$directn" == 'left' ]]; then
                                relpoint=$(($(echo "$olderprefix" | wc --chars) - 1)) 

                                local lntcnt=$(($(echo "$olderprefix$lastword$lastspcl$olderword" | wc --chars) - 1))
                                local suffix=${READLINE_LINE:$lntcnt}
                                line="$olderprefix$lastword$lastspcl$olderword$suffix" 
                            elif [[ $READLINE_POINT -lt $cntuptolastword ]]; then 
                                relpoint=$(($(echo "$oldprefix$olderword$lastspcl$newword${arrr[1]}" | wc --chars) - 1)) 
                                local wordcnt=$(($(echo "$oldprefix$olderword$lastspcl$newword${arrr[1]}$lastword" | wc --chars) - 1)) 
                                local suffix=${READLINE_LINE:$wordcnt}
                                line="$oldprefix$olderword$lastspcl$newword${arrr[1]}$lastword$suffix" 
                            else
                                [[ "$directn" == 'right' ]] && ! [[ $READLINE_POINT = ${#READLINE_LINE} ]] &&
                                    READLINE_POINT=${#READLINE_LINE}
                                break
                            fi
                        fi
                    else
                       oldprfxcnt=0
                       if test -n "$oldprefix"; then
                            test -z "$olderspcl" && olderspcl="$lastspcl" && lastspcl="${arrr[1]}"

                            if [[ $READLINE_POINT -ge $cntuptolastword ]] && [[ "$directn" == 'right' ]]; then 
                                line="$READLINE_LINE"
                                relpoint=${#READLINE_LINE}
                            else
                                if [[ "$directn" == 'left' ]]; then
                                    
                                    if [[ ${#arr[@]} == '1' ]]; then
                                        relpoint=0 
                                        local lntcnt=$(($(echo "$olderword" | wc --chars) - 1))
                                        local suffix=${READLINE_LINE:$lntcnt}
                                        line="$lastword$suffix" 
                                    else
                                        relpoint=$(($(echo "$oldprefix" | wc --chars) - 1)) 
                                        local lntcnt=$(($(echo "$olderword$olderspcl$lastword" | wc --chars) - 1))
                                        local suffix=${READLINE_LINE:$lntcnt}
                                        line="$olderword$olderspcl$lastword$suffix" 
                                    fi
                                else
                                    relpoint=${#READLINE_LINE}
                                    line="$READLINE_LINE" 
                                fi
                            fi
                        elif [[ "$directn" == 'right' ]] || ([[ "$directn" == 'left' ]] && [[ $READLINE_POINT -gt $firstword ]]); then
                            oldprfxcnt=$(($(echo "$lastword" | wc --chars) - 1)) &&
                            prfxcnt=$(($(echo "$prefix$lastspcl" | wc --chars) - 1))
                            local wordcnt=$(($(echo "$lastword$lastspcl$newword" | wc --chars) - 1)) 
                            local suffix=${READLINE_LINE:$(($wordcnt))}
                            line="$newword$lastspcl$lastword$suffix" 
                        else
                            [[ "$directn" == 'left' ]] && ! [[ $READLINE_POINT = 0 ]] &&
                                READLINE_POINT=0
                            break
                        fi

                    fi
                    ! [[ $relpoint ]] && relpoint=$(($READLINE_POINT - $prfxcnt))
                    READLINE_LINE=$line
                    READLINE_POINT=$relpoint
                    break
                fi
                olderspcl="$lastspcl" 
                prefix="$prefix$lastspcl"
                oldprefix=$prefix
                unset_array arrr 0; 
                test -n "${arrr[0]}" && lastspcl="${arrr[0]}"; 
            fi
        done
    fi
    unset arr arrr
}

