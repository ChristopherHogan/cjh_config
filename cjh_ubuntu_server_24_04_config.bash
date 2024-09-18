#!/bin/bash

set -xe
cd ~
CJH_CONFIG=~/dev/cjh_config

sudo apt update -y
sudo apt install -y                     \
  build-essential                       \
  gdb                                   \
  curl                                  \
  wget                                  \
  git                                   \
  vim                                   \
  cmake                                 \
  cmake-curses-gui                      \
  tmux                                  \
  exuberant-ctags                       \
  python3-pygments                      \
  global                                \
  silversearcher-ag                     \
  valgrind                              \
  sloccount                             \
  autoconf                              \
  automake                              \
  libtool                               \
  libtool-bin                           \
  xclip                                 \
  xterm

git config --global user.name "Chris Hogan"
git config --global user.email "c096h800@gmail.com"
git config --global core.editor "vim"
# Set default push behavior to only push to a branch of the same name as the active branch
git config --global push.default "current"
# Global gitignore file
cat <<- EOF > ~/.gitignore_global
GPATH
GRTAGS
GTAGS
.dir-locals.el
EOF
git config --global core.excludesfile ~/.gitignore_global
# Generate an ssh key, automatically accepting all defaults
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_ch -N ''

cat << EOF > ~/.ssh/config
Host github.com
    HostName github.com
    ForwardAgent yes
    ForwardX11 yes
    ServerAliveInterval 60
    IdentityFile ~/.ssh/id_ed25519_ch
    IdentitiesOnly yes
EOF
chmod 600 ~/.ssh/config

mkdir dev sw .local

pushd dev
git clone https://github.com/ChristopherHogan/cjh_config
popd

# .bashrc
rm -f ~/.bashrc
ln -s ${CJH_CONFIG}/cjh_bashrc ~/.bashrc

# .inputrc
rm -f ~/.inputrc
ln -s ${CJH_CONFIG}/cjh_inputrc ~/.inputrc

# tmux bash completion
curl https://raw.githubusercontent.com/imomaliev/tmux-bash-completion/master/completions/tmux > ~/.bash_completion

# tmux config
rm -f ~/.tmux.conf
ln -s ${CJH_CONFIG}/cjh_tmux.conf ~/.tmux.conf

# Install git-aware-prompt
pushd ~/sw
git clone http://github.com/jimeh/git-aware-prompt.git
popd

sudo apt install -y emacs
git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
ln -s ${CJH_CONFIG}/cjh_spacemacs_develop ~/.spacemacs

# Source code pro

# Get path to latest OTF release at https://github.com/adobe-fonts/source-code-pro
# wget the path
# mkdir -p ~/.local/share/fonts
# unzip OTF fonts in fonts dir
# fc-cache -f -v

wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh
bash ~/miniconda.sh -b -p ~/sw/miniconda
rm -f ~/miniconda.sh

git clone https://github.com/cyrus-and/gdb-dashboard ~/sw/gdb-dashboard
ln -s ~/sw/gdb-dashboard/.gdbinit ~/.gdbinit

# Additional dashboard customization
cat <<- "EOF" >> ~/.gdbinit
set disassembly-flavor intel

# Don't step into STL
define hookpost-run
  skip file basic_string.h
  skip file shared_ptr_base.h
  skip file shared_ptr.h
  skip file stl_vector.h
  skip file functional.h
end

define mpi_break
  up
  up
  set var gdb_iii = 7
  b $arg0
  c
end

define tlock
  set scheduler-lock step
end

# Temp commands

define go
  b main
  r
end

EOF

mkdir ~/.gdbinit.d
# Create file for default options
cat << EOF > ~/.gdbinit.d/auto
dashboard -layout source stack !assembly !expressions !history !memory !registers !threads !breakpoints !variables
dashboard -style prompt '(gdb)'
dashboard source -style height 0
dashboard stack -style compact True
EOF

# tmpi
# pushd ${SW}
# git clone https://github.com/Azrael3000/tmpi
# ln -s ${SW}/tmpi/tmpi ~/local/bin/tmpi
# popd

# TODO fzf
