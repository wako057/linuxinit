# aliases cross shell
alias l='ls -lh --color=auto'
alias la='ls -lha --color=auto'
alias vi='vim'

alias grep='grep --color=auto'

alias dockup='docker-compose up'
alias gitlog='git log --pretty=oneline -n 54'
alias dockerdeldead='docker rm `docker ps -aqf  status=exited`'
alias dockerdelete='docker stop `docker ps -aq` && docker rm `docker ps -aq`'
alias dockerstop='docker stop `docker ps -aqf status=running`'
alias dockerdelimage='docker rmi -f $(docker images -q)'
alias dockerfclean='docker stop `docker ps -aqf status=running` && docker volume rm `docker volume ls -q` && docker rm `docker ps -aq` && docker rmi -f $(docker images -q)'

alias sshdocker='docker exec -i -t '
