#!/bin/bash

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

SCRIPT_DIR=$(get-script-dir)

if ! command -v docfd &> /dev/null; then 
    if ! test -z $AUR_ins; then
        eval "$AUR_ins" docfd-bin  
    fi
fi

# Fzf
local findr
if ! command -v fzf &> /dev/null; then
    printf "Fzf for docfd file selection menu (and for fuzzy finding)\n"
    readyn -p "Install fzf? (Fuzzy file/folder finder - keybinding yes for upgraded Ctrl-R/reverse-search, fzf filenames on Ctrl+T and fzf-version of 'cd' on Alt-C + Custom script: Ctrl-f becomes system-wide file opener)" findr
    if [[ "y" == "$findr" ]]; then
        if ! test -f install_fzf.sh; then
            source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_fzf.sh) 
        else
            ./install_fzf.sh
        fi
    fi
fi

local pdf2txt pndc

# pdf2txt
if ! command -v pdftotext &> /dev/null; then
    readyn -p "Also install pdftotext for pdf support?" pft2txt
    if [[ $pdf2txt == 'y' ]]; then
        if [[ $distro_base == 'Arch' ]]; then
            eval "$pac_ins python-pdftotext"
        fi
    fi
fi

# pandoc
if ! type pandoc &> /dev/null; then
    readyn -p "Also install pandoc for .epub, .odt, .docx, .fb2, .ipynb, .html, and .htm files?"  pndc
    if [[ $pndc == 'y' ]]; then
        if [[ $distro_base == 'Arch' ]]; then
            eval "$pac_ins python-pdftotext"
        fi
    fi
fi
