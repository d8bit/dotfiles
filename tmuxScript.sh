#!/bin/sh

session="sessionName"

cd /var/www/html/projectName
# set up tmux
tmux start-server

# create a new tmux session, starting vim from a saved session in the new window
tmux new-session -d -s $session -n vim

# open vim with session
tmux send-keys "vim -S ~/.vim/sessions/sessionName.vim" C-m

session="brokerFront"

cd /var/www/html/projectName

# create a new tmux session, starting vim from a saved session in the new window
tmux new-session -d -s $session -n vim

# create a new window called npm
tmux new-window -t $session:2 -n npm

# Split pane 1 vertical by 65%, start npm
tmux splitw -v -p 35
tmux send-keys "npm run watch" C-m

# create a new window called TOR
tmux new-window -t $session:3 -n TOR
tmux send-keys "cd ~/test/tor/" C-m


# return to main vim window
tmux select-window -t $session:1

# open vim with session
tmux send-keys "vim -S ~/.vim/sessions/sessionName.vim" C-m

# Finished setup, attach to the tmux session!
tmux attach-session -t $session

