#!/bin/bash
cd .smoke || exit

./cli_wallet -s ws://pubrpc.smoke.io:8090
