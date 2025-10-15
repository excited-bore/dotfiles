_commands() {
  local -a cmd_list
  # Get all available commands in PATH
  cmd_list=(${(f)"$(compgen -c 2>/dev/null)"})
  _describe 'command' cmd_list
} 

_groups() {
  local -a group_list
  # Extract all group names
  group_list=(${(f)"$(cut -d: -f1 /etc/group)"})
  _describe 'group' group_list
}

_trash() {
  # Get current word being completed
  local curcontext="$curcontext" state line
  local -a trash_items

  # Get the list of trashed items (URIs)
  trash_items=(${(f)"$(gio trash --list | awk '{print $1}' | sed 's|trash:///|trash\\:///|g')"})

  _describe 'trash items' trash_items
}

_vlc() {
  _arguments '*:media file:_files -g "*.(mp4|m4a|mkv|mp3|ogg)(-.)"'
}

compdef _cd cp-all-to

if type _fzf_dir_completion &> /dev/null; then
    compdef _fzf_dir_completion cd 
    compdef _fzf_dir_completion cp-all-to 
fi

compdef _groups add-to-group

compdef _commands refresh refresh-diff

hash viddy &> /dev/null &&
    compdef _commands viddy

compdef _commands edit-whereis

compdef _trash trash-list
compdef _trash trash-restore

compdef _vlc vlc
