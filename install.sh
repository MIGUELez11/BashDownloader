OS=$(echo $OSTYPE | sed -E "s/[0-9]{0,}//g")

if [ "$OS" = "darwin" ]
then
    if [ -z $ZDOTDIR ]
    then
        FILE="$HOME/.zshrc"
    else
        FILE=$(echo "$ZDOTDIR/.zshrc")
    fi
else
    FILE="$HOME/.bashrc"
fi
    echo alias orly="$(pwd)/download.sh" >> $FILE

$(echo git clone https://github.com/lorenzodifuccia/safaribooks)
$(echo pip3 install -r safaribooks/requirements.txt --user)
