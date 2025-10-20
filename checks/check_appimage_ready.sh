TOP=$(git rev-parse --show-toplevel)

if ! test -f $TOP/checks/check_all.sh; then
    if hash curl &> /dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . $TOP/checks/check_all.sh
fi

if [[ $distro_base == "Debian" ]]; then
    # Libfuse2 has a lot of CVE errors so not all systems have it installed by default
    if test -z "$(dpkg -l | grep libfuse2)"; then
        printf "A package called 'libfuse2' is necessary for Appimages, but it has been removed from the default installation by Ubuntu because it has been flagged as outdated and vulnerable to a bunch of CVE's\n" 
        readyn -n -p "Still install libfuse2?" inslibfuse
        if [[ "$inslibfuse" == "y" ]]; then
            eval "$pac_ins_y libfuse2t64"
        fi
    fi
fi
