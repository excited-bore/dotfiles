hash docfd &> /dev/null && SYSTEM_UPDATED='TRUE'

if ! test -f ../checks/check_all.sh; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . ../checks/check_all.sh
fi

SCRIPT_DIR=$(get-script-dir)

if ! test -f ../../checks/check_AUR.sh; then
     source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_AUR.sh)
else
    . ../../checks/check_AUR.sh
fi


if ! hash docfd &> /dev/null; then 
    if [[ "$distro_base" == 'Arch' ]]; then
        eval "$AUR_ins_y docfd-bin"  
    fi
fi

# Fzf
if ! hash fzf &> /dev/null; then
    printf "Fzf for docfd file selection menu (and for fuzzy finding)\n"
    readyn -p "Install fzf? (Fuzzy file/folder finder - keybinding yes for upgraded Ctrl-R/reverse-search, fzf filenames on Ctrl+T and fzf-version of 'cd' on Alt-C + Custom script: Ctrl-f becomes system-wide file opener)" findr
    if [[ "y" == "$findr" ]]; then
        if ! test -f install_fzf.sh; then
            source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/install_fzf.sh) 
        else
            . ./install_fzf.sh
        fi
    fi
fi
unset findr


# pdf2txt
if ! hash pdftotext &> /dev/null; then
    readyn -p "Also install pdftotext for pdf support?" pft2txt
    if [[ $pdf2txt == 'y' ]]; then
        if [[ $distro_base == 'Arch' ]]; then
            eval "$pac_ins_y python-pdftotext"
        fi
    fi
fi
unset pdf2txt 


# pandoc
if ! type pandoc &> /dev/null; then
    readyn -p "Also install pandoc for .epub, .odt, .docx, .fb2, .ipynb, .html, and .htm files?"  pndc
    if [[ $pndc == 'y' ]]; then
        if [[ $distro_base == 'Arch' ]]; then
            eval "$pac_ins_y python-pdftotext"
        fi
    fi
fi
unset pndc
