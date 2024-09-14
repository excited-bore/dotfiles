if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi
if ! test -f aliases/.bash_aliases.d/00-rlwrap_scripts.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/00-rlwrap_scripts.sh)" 
else
    . ./aliases/.bash_aliases.d/00-rlwrap_scripts.sh
fi

if ! type update-system &> /dev/null; then
    if ! test -f aliases/.bash_aliases.d/update-system.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/update-system.sh)" 
    else
        . ./aliases/.bash_aliases.d/update-system.sh
    fi
fi

if test -z $SYSTEM_UPDATED; then
    reade -Q "CYAN" -i "n" -p "Update system? [Y/n]: " "n" updatesysm
    if test $updatesysm == "y"; then
        update-system                     
    fi
fi

if ! type docfd &> /dev/null; then 
    if ! test -z $AUR_ins; then
        eval "$AUR_ins" docfd-bin  
    fi
fi

# Fzf
if ! type fzf &> /dev/null; then
    printf "Fzf for docfd file selection menu (and for fuzzy finding)\n"
    reade -Q "GREEN" -i "y" -p "Install fzf? (Fuzzy file/folder finder - keybinding yes for upgraded Ctrl-R/reverse-search, fzf filenames on Ctrl+T and fzf-version of 'cd' on Alt-C + Custom script: Ctrl-f becomes system-wide file opener) [Y/n]: " "n" findr
    if [ "y" == "$findr" ]; then
        if ! test -f install_fzf.sh; then
            eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_fzf.sh)" 
        else
            ./install_fzf.sh
        fi
    fi
    unset findr
fi

# pdf2txt
if ! type pdftotext &> /dev/null; then
    reade -Q 'GREEN' -i 'y' -p "Also install pdftotext for pdf support? [Y/n]: " 'n' pft2txt
    if test $pdf2txt == 'y'; then
        if test $distro_base == 'Arch'; then
            eval "$pac_ins python-pdftotext  "
        fi
    fi
fi

# pandoc
if ! type pandoc &> /dev/null; then
    reade -Q 'GREEN' -i 'y' -p "Also install pandoc for .epub, .odt, .docx, .fb2, .ipynb, .html, and .htm files? [Y/n]: " 'n' pndc
    if test $pndc == 'y'; then
        if test $distro_base == 'Arch'; then
            eval "$pac_ins python-pdftotext  "
        fi
    fi
fi

unset pdf2txt pndc
