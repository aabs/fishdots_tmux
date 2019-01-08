#!/usr/bin/fish

function tm
  if test 0 -eq (count $argv)
    tmuxer_help
    return
  end
  switch $argv[1]
    case set
        tmuxer_set $argv[2]
    case n
        tmuxer_new $argv[2]
    case new
        tmuxer_new $argv[2]
    case create
        tmuxer_new $argv[2]
    case d
        tmuxer_detach
    case detach
        tmuxer_detach
    case goto
        tmuxer_goto $argv[2]
    case help
        tmuxer_help
    case h
        tmuxer_home
    case home
        tmuxer_home
    case l
        tmuxer_list
    case ls
        tmuxer_list
    case o
        tmuxer_open
    case open
        tmuxer_open
    case '*'
      tmuxer_help
  end
end

function tmuxer_help -d "display usage info"
  
  echo "USAGE:"
  echo ""
  echo "tm <command> [options] [args]"
  echo ""
  
  echo "tm new <name>"
  echo "  create a new TMUX session"
  echo ""

  echo "tm goto <name>"
  echo "  change tmux sessions"
  echo ""

  echo "tm help"
  echo "  this..."
  echo ""

  echo "tm home"
  echo "  got to the current home tmux session"
  echo ""

  echo "tm ls"
  echo "  list all available tmuxers"
  echo ""

  echo "tm open"
  echo "  open from list dialog"
  echo ""

end

function tmuxer_new -a session_name -d "create a new session if it does not already exist"
  tmux -2 new -s $session_name
end

function tmuxer_list -d "list tmuxers with descriptions"
  tmux ls | cut -d':' -f1 |sort
end

function tmuxer_home -d "goto home dir of current tmuxer"
  project set $CURRENT_TMUX_SESSION
  # project home
  tmux -2 attach-session -t $CURRENT_TMUX_SESSION
end

function tmuxer_goto -a tmuxer_name -d "switch tmuxers"
  ok "Switching to $tmuxer_name"
  tm set $tmuxer_name
  tm home
end

function tmuxer_set -a tmuxer_name
    set -U CURRENT_TMUX_SESSION $tmuxer_name
end

function tmuxer_detach
    tmux detach 
end

function tmuxer_open -d "select from existing tmuxers"
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

