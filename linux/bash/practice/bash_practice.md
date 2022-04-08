# bash practice

- [bash practice](#bash-practice)
  - [rename file](#rename-file)
  - [script path](#script-path)
  - [check arugument supplied](#check-arugument-supplied)
  - [realpath](#realpath)

## rename file

    d=`date +%Y%m%d`
    for f in *; do
        name=`echo $f| sed -r 's/2021[0-9]{4}/'"$d"'/'`;
        if [ $f != $name ]; then
            mv $f $name;
        fi
    done

## script path

    script_path=`realpath "${BASH_SOURCE:-$0}"`
    echo ${script_path}
    script_dir=`dirname ${script_path}`
    echo ${script_dir}

## check arugument supplied

    if [ -z "$1" ]; then
        echo "No argument supplied"
        exit 1
    fi

## realpath

    absolute_path=`realpath $1`
    echo ${absolute_path}

