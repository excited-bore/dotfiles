#! /bin/bash

# Stolen from:
# https://codereview.stackexchange.com/questions/45445/script-for-handling-ppas-on-ubuntu

check-ppa(){
    SCRIPT="check-ppa"
    VERSION="1.1"
    DATE="2024-09-02"
    RELEASE="$(lsb_release -si) $(lsb_release -sr)"
    
    helpsection() 
    { 
        echo "Usage : $SCRIPT [OPTION]... [PPA]... 
    -h, --help     shows this help
    -c, --check    check if [PPA] is available for your release

    Version $VERSION - $DATE"
    }

    ppa_verification()
    { 
        local ppa="${1#ppa:}"

        local codename="$(lsb_release -sc)"
        local url="http://ppa.launchpad.net/$ppa/ubuntu/dists/$codename/"

        curl "$url" -s &> /dev/null
        ######################################################################
        # Exit Status
        #
        # Wget may return one of several error codes if it encounters problems.
        # 0 No problems occurred.
        # 1 Generic error code.
        # 2 Parse error--for instance, when parsing command-line options, the `.wgetrc' or `.netrc'...
        # 3 File I/O error.
        # 4 Network failure.
        # 5 SSL verification failure.
        # 6 Username/password authentication failure.
        # 7 Protocol errors.
        # 8 Server issued an error response.
        ######################################################################
        case $? in
          0) # Success
            echo "$SCRIPT : '$ppa' is available for $RELEASE"
            ;;
          8) # HTTP 404 (Not Found) would result in wget returning 8
            echo "$SCRIPT : '$ppa' is NOT available for $RELEASE"
            return 1
            ;;
          *)
            echo "$SCRIPT : Error fetching $url" >&2
            return 3
        esac
    }

    PPA=
    while [ -n "$*" ] ; do
        case "$1" in
          -h|--help)
            helpsection
            return 0
            ;;
          --check=*)
            PPA="${1#*=}"
            ;;
          -c|--check|check)
            PPA="$2"
            shift
            ;;
          *)
            helpsection >&2
            return 2
            ;;
        esac
        shift
    done

    if [ -z "$PPA" ]; then
        helpsection >&2
        return 2
    fi

    ppa_verification "$PPA"
}

complete -W "-h --help -c --check" check-ppa


