# This tmux statusbar config was created by tmuxline.vim
# on 金, 31  7月 2015

set -g status-bg "colour233"
set -g status-justify "left"
set -g status-left-length "100"
set -g status "on"
set -g status-right-length "100"
setw -g window-status-separator ""
set -g status-left "#[fg=colour22,bg=colour148] #S #[fg=colour148,bg=colour233,nobold,nounderscore,noitalics]"
set -g status-right "#[fg=colour236,bg=colour233,nobold,nounderscore,noitalics]#[fg=colour247,bg=colour236] %Y-%m-%d  %H:%M #[fg=colour148,bg=colour236,nobold,nounderscore,noitalics]#[fg=colour22,bg=colour148] #h "
setw -g window-status-format "#[fg=colour231,bg=colour233] #I #[fg=colour231,bg=colour233] #W "
setw -g window-status-current-format "#[fg=colour233,bg=colour236,nobold,nounderscore,noitalics]#[fg=colour247,bg=colour236] #I #[fg=colour247,bg=colour236] #W #[fg=colour236,bg=colour233,nobold,nounderscore,noitalics]"
