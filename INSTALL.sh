#!/bin/bash

# download iTerm2 theme files
[[ -d "${HOME}/Downloads/" ]] || mkdir "${HOME}/Downloads/"
themeweb='https://raw.githubusercontent.com/altercation/solarized/master/iterm2-colors-solarized/${theme}.itermcolors'
for theme in "Solarized Light" "Solarized Dark"
do
    if [[ ! -f "${HOME}/Downloads/${theme}.itermcolors" ]]; then
        curl  `eval "echo $themeweb | sed 's/ /%20/g'"`\
             > "${HOME}/Downloads/${theme}.itermcolors"
    fi
done

echo '#################################################'
echo '# Installing prerequisites'
echo '#################################################'
source ~/.zsh.my.sh
source ./.zshenv
source ./init.rc.sh

if [[ `basename "$SHELL"` != `basename $(which zsh)` ]]; then
    echo '#################################################'
    echo "# Now change zsh as your default shell ..."
    echo '#################################################'
    export SHELL=`which zsh`
    chsh -s `which zsh`
fi

echo -n "Check oh-my-zsh ... "
if [[ -d "${HOME}/.oh-my-zsh/" ]]; then
    echo "Found."
else
    echo "Not Found."
    echo '#################################################'
    echo "# Installing on-my-zsh"
    echo '#################################################'
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    echo "Done."
    echo
fi

echo '#################################################'
echo "# Installing oh-my-zsh plugins"
echo '#################################################'
[[ -d "~/.oh-my-zsh/custom/plugins/zsh-completions" ]] \
    || git clone https://github.com/zsh-users/zsh-completions ~/.oh-my-zsh/custom/plugins/zsh-completions

[[ -d ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]] \
    || git clone git://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

echo '#################################################'
echo "# Linking files"
echo '#################################################'
for link in .zshrc .percol.d .gitconfig .zshenv
do
    echo "Now install my $link"
    differ=`diff "${PWD}/$link" "${HOME}/$link" 2>/dev/null`
    if [[ "$?" != "0" || -n "$differ" ]]; then
        [[ -f "${HOME}/$link" || -d "${HOME}/$link" ]] && mv "${HOME}/$link" "${HOME}/${link}.bk"
        echo "Creating link from ${PWD}/$link to ${HOME}/$link"
        echo
        ln -s "${PWD}/$link" "${HOME}/$link"
    else
        echo "$link is already up-to-date."
    fi
done
