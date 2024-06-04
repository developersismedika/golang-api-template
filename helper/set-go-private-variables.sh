#!/bin/bash

# run:
#  . set-go-private-variables.sh
# FYI: please use dot (.) instead of `bash ./set-go-private-variables.sh` or `./set-go-private-variables.sh`
# this way, it will run the shell script on this current shell
# ref: https://askubuntu.com/questions/1095779/how-to-reload-bashrc-in-the-shell-calling-a-script

# do not forget to:
#   sudo chmod +x ./set-go-private-variables.sh
#   sudo chmod +x ./helper_bashrc.sh
eval ./helper_bashrc.sh insert GO111MODULE "on"
eval ./helper_bashrc.sh insert GOPATH "$HOME/go"
eval ./helper_bashrc.sh insert GOPRIVATE "gitlab.sismedika.online/sismedika/*"
eval ./helper_bashrc.sh insert GONOPROSXY "gitlab.sismedika.online/sismedika/*"
eval ./helper_bashrc.sh insert GONOSUMDB "gitlab.sismedika.online/sismedika/*"
eval source ~/.bashrc

# in case no changes happen, run this command manually:
#   source ~/.bashrc

# Sample to verify changes:
#   echo $GO111MODULE
