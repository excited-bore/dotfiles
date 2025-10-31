# https://stackoverflow.com/questions/5412761/using-colors-with-printf
# Execute (during printf) for colored prompt
# printf  "${blue}This text is blue${white}\n"

red=$(tput sgr0 && tput setaf 1)
red1=$(tput sgr0 && tput setaf 9)
orange=$(tput sgr0 && tput setaf 166)
green=$(tput sgr0 && tput setaf 2)
green1=$(tput sgr0 && tput setaf 10)
yellow=$(tput sgr0 && tput setaf 3)
yellow1=$(tput sgr0 && tput setaf 11)
blue=$(tput sgr0 && tput setaf 4)
blue1=$(tput sgr0 && tput setaf 12)
magenta=$(tput sgr0 && tput setaf 5)
magenta1=$(tput sgr0 && tput setaf 13)
cyan=$(tput sgr0 && tput setaf 6)
cyan1=$(tput sgr0 && tput setaf 14)
white=$(tput sgr0 && tput setaf 7)
white1=$(tput sgr0 && tput setaf 15)
black=$(tput sgr0 && tput setaf 16)
grey=$(tput sgr0 && tput setaf 8)

RED=$(tput setaf 1 && tput bold)
RED1=$(tput setaf 9 && tput bold)
ORANGE=$(tput setaf 9 && tput setaf 166)
GREEN=$(tput setaf 2 && tput bold)
GREEN1=$(tput setaf 10 && tput bold)
YELLOW=$(tput setaf 3 && tput bold)
YELLOW1=$(tput setaf 11 && tput bold)
BLUE=$(tput setaf 4 && tput bold)
BLUE1=$(tput setaf 12 && tput bold)
MAGENTA=$(tput setaf 5 && tput bold)
MAGENTA1=$(tput setaf 13 && tput bold)
CYAN=$(tput setaf 6 && tput bold)
CYAN1=$(tput setaf 14 && tput bold)
WHITE=$(tput setaf 7 && tput bold)
WHITE1=$(tput setaf 15 && tput bold)
BLACK=$(tput setaf 16 && tput bold)
GREY=$(tput setaf 8 && tput bold)

bold=$(tput bold)
underline_on=$(tput smul)
underline_off=$(tput rmul)
standout_on=$(tput smso)
standout_off=$(tput rmso)

half_bright=$(tput dim)
reverse_color=$(tput rev)

# Reset
normal=$(tput sgr0)

# Broken !! (Or im dumb?)
blink=$(tput blink)
underline=$(tput ul)
italic=$(tput it)

