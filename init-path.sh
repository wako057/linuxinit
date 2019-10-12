# setup path env variable
export TERM="xterm-256color"

if [[ -e "/usr/bin/java" ]]; then
  export JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:/bin/java::")
fi

# set PATH so it includes user's private bin if it exists
if [[ -d "$HOME/bin" ]] ; then
    PATH="$HOME/bin:$PATH"
fi

if [[ -d "$HOME/.cargo/bin" ]] ; then
  export PATH="$PATH:$HOME/.cargo/bin"
  export PATH=$PATH:/opt/go/bin:$GOPATH/bin
fi

if [[ -d "/opt/go" ]] ; then
  export GOROOT=/opt/go
fi

if [[ -d "$HOME/work" ]] ; then
  export GOPATH=$HOME/work
fi

# If you come from bash you might have to change your $PATH.
if [[ -d "~/indb-docker" ]] ; then
  export WORKSPACE=~/indb-docker
  export PATH=$PATH:$WORKSPACE
fi

if [ -d "~/projects" ] ; then
  export PROJECTS=~/projects
  export PATH=$PATH:$PROJECTS
fi

if [ -d "~/projects" ] ; then
  export PATH=$HOME/bin:/usr/local/bin:$PATH
fi

if [[ -d "~/.local/bin" ]] ; then
  export PATH=$PATH:~/.local/bin
fi

test_npm_exist=$(npm  2>/dev/null 1>/dev/null; echo $?)
if [[ $test_npm_exist -eq 1 ]] ; then
  export PATH=$PATH:$(npm bin)
fi

