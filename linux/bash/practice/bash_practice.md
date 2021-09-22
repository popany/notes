# bash practice

- [bash practice](#bash-practice)
  - [rename file](#rename-file)

## rename file

    d=`date +%Y%m%d`
    for f in *; do
        name=`echo $f| sed -r 's/2021[0-9]{4}/'"$d"'/'`;
        if [ $f != $name ]; then
            mv $f $name;
        fi
    done
