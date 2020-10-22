DIR=$(echo $0 | sed -E "s/\/[A-Za-z]+.sh$//g")
CONF=$(pwd)
USER=$(echo $(pwd)/user.cnf)
for book_id in $@
do
    printf "\e[1;33mDownloading book \e[1;34m$book_id\n\e[0m";
    if [ -f $USER ]
    then
        printf "\e[1;32mConfiguration file exists\n\e[0m";
        USERDATA="$(cat $USER | sed -E '1 s/$/:/')"
        USERDATA="$(echo $USERDATA | sed -E 's/ //')"
        if [ -z $USERDATA ]
        then
            printf "\e[1;31mExpected user.cnf to have a username and password\n\e[0m";
            printf "Expected user.cnf file with orly username on first line and password on second line\n"
        else
            cd $DIR/safaribooks;
            $(echo python3 safaribooks.py --cred $USERDATA $book_id)
            if [ -d "Books" ]
            then
                FILES=$(find Books -maxdepth 1 | sed -E 's/ /\:space:/g')
                FILESI=$(ls Books)
                if [ ! -d "$CONF/Books" ]
                then
                    mkdir -p $CONF/Books;
                fi
                for file in $FILES;
                do
                    if [ ! $file = "Books" ]
                    then
                        NAME=$(echo "$file" | sed -E "s/:space:/ /g")
                        NAME2=$(echo "$file" | rev | sed -E "s/\)[0-9]+\(:ecaps://" | rev | sed -E "s/:space:/_/g")
                        FEXIST=$(echo find $CONF -name $NAME2)
                        if [ -d $CONF/$NAME2 ]
                        then
                            i=1
                            while [ -d $CONF/$NAME2$i ]
                            do
                                i=$((i+1))
                            done
                            $(mv "$NAME" $CONF/$NAME2$i)
                            printf "\e[1;32mBook downloaded on $CONF/$NAME2$i\n\e[0m"
                        else
                            $(mv "$NAME" $CONF/$NAME2)
                            printf "\e[1;32mBook downloaded on $CONF/$NAME2\n\e[0m"
                        fi
                    fi
                done
                $(rm -rf Books)
            fi
            cd $CONF
        fi
    else
        printf "\e[1;31mConfiguration file does not exist\n\e[0m";
        printf "Expected user.cnf file with orly username on first line and password on second line\n"
    fi
    $(sleep 2s);
done