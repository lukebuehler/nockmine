# TMUX commands

tmux new -s nock
tmux ls
tmux attach -t 0


Ctrl+B D — Detach from the current session.
Ctrl+B % — Split the window into two panes horizontally.
Ctrl+B " — Split the window into two panes vertically.
Ctrl+B Arrow Key (Left, Right, Up, Down) — Move between panes.
Ctrl+B X — Close pane.
Ctrl+B C — Create a new window.
Ctrl+B N or P — Move to the next or previous window.
Ctrl+B 0 (1,2...) — Move to a specific window by number.
Ctrl+B : — Enter the command line to type commands. Tab completion is available.
Ctrl+B ? — View all keybindings. Press Q to exit.
Ctrl+B W — Open a panel to navigate across windows in multiple sessions.


## enable mouse
^b + :
then:
setw -g mouse on

copy/paste with shift and right click


kill
tmux attach -t miners        # see everything
tmux kill-session -t miners  # wipe them all