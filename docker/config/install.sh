#!/bin/sh
SV="0.1.0"
WV="0.0.6"

# see if smoked exists
if [ ! -f ~/.smoke/smoked ]; then 
	cd ~/.smoke || exit

	# download smoked and wallet
	wget https://github.com/smokenetwork/smoked/releases/download/v${SV}/smoked-${SV}-x86_64-linux.tar.gz
	wget https://github.com/smokenetwork/smoked/releases/download/v${WV}/cli_wallet-${WV}-x86_64-linux.tar.gz
	
	# extract smoked and wallet
	tar -xzf smoked-${SV}-x86_64-linux.tar.gz
	tar -xzf cli_wallet-${WV}-x86_64-linux.tar.gz
	
	# remove tar files
	rm smoked-${SV}-x86_64-linux.tar.gz
	rm cli_wallet-${WV}-x86_64-linux.tar.gz
	
	# wait two seconds
	echo "Starting Smoked to build directories..."
	sleep 2

	# Launch script in background
	~/.smoke/smoked &
	# Get its PID
	smokePID=$!
	# Wait for 2 seconds
	sleep 2
	# Kill it
	kill -INT $smokePID
	sleep 4
	# move preset config
	cp ~/.config/config.ini.example witness_node_data_dir/config.ini
	# move to home dir
	cd || exit
fi

# run tmux with multiple window created.
session="hotbox"

# set up tmux
tmux start-server

# create a new tmux session, starting vim from a saved session in the new window
tmux new-session -d -s "$session"

# create a new window called scratch
tmux new-window -t "$session":1 -n wallet

# return to main vim window
tmux select-window -t "$session":0

# Finished setup, attach to the tmux session!
tmux attach-session -t "$session"

exit
