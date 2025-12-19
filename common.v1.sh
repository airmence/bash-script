#!/usr/bin/sh

# Inform the user of teh output they can expect.
echo "common commands :"

#show the most commonly used commands.
tail ~/.bash_history -n 10000 \
	| sort \
	| uniq \
	| sed 's/^ *//' \
	| sort -n -r \
	| head -n 10
