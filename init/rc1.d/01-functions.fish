#!/usr/bin/fish
define_command tm "fishdots plugin for using tmux"

define_subcommand_nonevented tm set tm_set "set current TMUX session"
define_subcommand_nonevented tm new tm_new "<session_name> create a new TMUX session"
define_subcommand_nonevented tm detach tm_detach "disconnect from the current session"
define_subcommand_nonevented tm goto tm_goto "<name> change tmux sessions"
define_subcommand_nonevented tm home tm_home "got to the current home tmux session"
define_subcommand_nonevented tm ls tm_list "list all available tmuxers"
define_subcommand_nonevented tm open tm_open "open from list dialog"
define_subcommand_nonevented tm session tm_session "display the current session name"

function tm_new -a session_name -d "create a new session if it does not already exist"
  # create the session detached, then switch to it
  tmux -2 new -d -s $session_name
  tm goto $session_name
end

function tm_session
    tmux display-message -p '#S'
end

function tm_list -d "list tmuxers with descriptions"
  tmux ls | cut -d':' -f1 |sort
end

function tm_home -d "goto home dir of current tmuxer"
  set -l NUM_TMUX_ENV_VARS (env | grep -i TMUX | wc -l)
  echo "vars: $NUM_TMUX_ENV_VARS"
  if test $NUM_TMUX_ENV_VARS -eq 0
    echo "attaching"
    tmux -2 attach -t $CURRENT_TMUX_SESSION
  else
    echo "switching"
    tmux switch -t $CURRENT_TMUX_SESSION
  end
end

function tm_goto -a name -d "switch tmuxers"
  ok "Switching to $name"
  tm set $name
  tm home
end

function tm_set -a name
    set -U CURRENT_TMUX_SESSION $name
end

function tm_detach
    tmux detach 
end

function tm_open -d "select from existing tmuxers"
  set matches (tm ls)
  if test 1 -eq (count $matches) and test -d $matches
    set -U CURRENT_TMUX_SESSION $matches[1]
    echo "chose option 1"
    return
  end
  set -g dcmd "dialog --stdout --no-tags --menu 'select the tmuxer' 20 60 20 " 
  set c 1
  for option in $matches
    set -g dcmd "$dcmd $option '$c $option'"
    set c (math $c + 1)
  end
  set choice (eval "$dcmd")
  clear
  if test $status -eq 0
    echo "choice was $choice"
    tm goto $choice
  end
end

