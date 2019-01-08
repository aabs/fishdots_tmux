# this could have been set via the localrc file (as in my work machine)
if not set -q $CURRENT_TMUX_SESSION
set -U CURRENT_TMUX_SESSION "$CURRENT_PROJECT_SN"
end
