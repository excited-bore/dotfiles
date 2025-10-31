! type _man &> /dev/null &&
    . /usr/share/bash-completion/completions/man

# https://vim.fandom.com/wiki/Using_bash_completion_with_ctags_and_Vim

excludelist='*.@(o|O|so|SO|so.!(conf)|SO.!(CONF)|a|A|rpm|RPM|deb|DEB|gif|GIF|jp?(e)g|JP?(E)G|mp3|MP3|mp?(e)g|MP?(E)G|avi|AVI|asf|ASF|ogg|OGG|class|CLASS)'

_vim_ctags() {
  local -a tags
  local cur prev

  cur=${words[CURRENT]}
  prev=${words[CURRENT-1]}

  case $prev in
    -t)
      [[ -r ./tags ]] || return
      local esc_cur=${cur//\//\\/}
      tags=(${(f)"$(awk -v ORS=' ' "/^${esc_cur}/ { print \$1 }" tags 2>/dev/null)"})
      compadd -a tags
      ;;
    *)
      _files -g "*(${~excludelist})"
      ;;
  esac
}

compdef _vim_ctags vi vim gvim rvim view rview rgvim rgview gview

compdef _files vim-fzf 

compdef _man man-all-nvim                                                       

