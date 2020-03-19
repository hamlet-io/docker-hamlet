#!/usr/bin/env bash

# Update the shell prompt to better display long paths and colorize git repos.
promptShellOne='export PS1='\''\033[0;32m\]\[\033[0m\033[0;32m\]\u\[\033[0;36m\] @ \w\[\033[0;32m\]\n$(git branch 2>/dev/null | grep "^*" | cut -d " " -f2)\[\033[0;32m\]└─\[\033[0m\033[0;32m\] \$\[\033[0m\033[0;32m\]\[\033[0m\]'\'''
echo $promptShellOne >> /root/.bashrc
echo $promptShellOne >> /etc/skel/.bashrc