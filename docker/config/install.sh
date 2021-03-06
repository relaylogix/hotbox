#!/bin/sh
SV="0.1.0"
WV="0.0.6"

# see if smoked exists
if [ ! -f "$HOME"/.smoke/smoked ]; then 
	cd "$HOME"/.smoke || exit 1

	printf "What do you wish to run?\n"
	printf "Please enter witness, rpc, or seed. (no capital letters)\n"
	read -r nodeType

	while true
	do
		case "$nodeType" in
			"rpc") printf "Installing RPC node... \n"
				wget https://github.com/smokenetwork/smoked/releases/download/v${SV}/smoked-${SV}-x86_64-linux.tar.gz
				tar -xzf smoked-${SV}-x86_64-linux.tar.gz
				rm smoked-${SV}-x86_64-linux.tar.gz
				break;;

			"seed") printf "Installing Seed node... \n"
				wget https://github.com/smokenetwork/smoked/releases/download/v${SV}/smoked_lm-${SV}-x86_64-linux.tar.gz
				tar -xzf smoked_lm-${SV}-x86_64-linux.tar.gz
				rm smoked_lm-${SV}-x86_64-linux.tar.gz
				break;;

			"witness") printf "Installing Witness... \n"
				wget https://github.com/smokenetwork/smoked/releases/download/v${SV}/smoked_lm-${SV}-x86_64-linux.tar.gz
				tar -xzf smoked_lm-${SV}-x86_64-linux.tar.gz
				rm smoked_lm-${SV}-x86_64-linux.tar.gz
				break;;

			* ) printf "Please enter witness, rpc, or seed. (no capital letters)\n"
				read -r nodeType
		esac
	done

	# download and extract wallet
	wget https://github.com/smokenetwork/smoked/releases/download/v${WV}/cli_wallet-${WV}-x86_64-linux.tar.gz
	tar -xzf cli_wallet-${WV}-x86_64-linux.tar.gz
	rm cli_wallet-${WV}-x86_64-linux.tar.gz
	
	# wait two seconds
	printf "Starting Smoked to build directories...\n"
	sleep 2

	# Launch script in background
	"$HOME"/.smoke/smoked &
	# Get its PID
	smokePID=$!
	# Wait for 2 seconds
	sleep 2
	# Kill it
	kill -INT $smokePID
	sleep 4

	# move preset configs
	case "$nodeType" in
		"rpc")
			cp "$HOME"/.config/rpc-config.ini witness_node_data_dir/config.ini
			;;
		"seed")
			cp "$HOME"/.config/seed-config.ini witness_node_data_dir/config.ini
			;;
		"witness")
			cp "$HOME"/.config/witness-config.ini witness_node_data_dir/config.ini
			;;
	esac

	# move to home dir
	cd || exit 1
fi

# run tmux with multiple window created.
session="Hotbox | ctrl+h to leave | ctrl+b then a number to swich windows"

# set up tmux
tmux start-server

# create a new tmux session, starting vim from a saved session in the new window
tmux new-session -d -s "$session" -n smoke

# create a new window called scratch
tmux new-window -t "$session":1 -n wallet

# create a new window called scratch
tmux new-window -t "$session":2 -n kief

# return to main vim window
tmux select-window -t "$session":0

# Finished setup, attach to the tmux session!
tmux attach-session -t "$session"

exit
