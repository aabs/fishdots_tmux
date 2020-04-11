#!/usr/bin/env fish

if not test -d $HOME/.tmux/plugins/tpm
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
end

if not test -e $HOME/.tmux.conf
  ln -sf $FISHDOTS_PLUGINS_HOME/fishdots_tmux/tmux.conf.symlink $HOME/.tmux.conf
end


