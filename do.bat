@echo off
call "%PROGRAMFILES%\Git\git-cmd" --no-cd --command=usr/bin/bash.exe -l -i -c "./do.sh %*"
