# `sed` Practice

- [`sed` Practice](#sed-practice)

## [bash / sh script to replace text between some tags/strings in a text file](https://unix.stackexchange.com/questions/272061/bash-sh-script-to-replace-text-between-some-tags-strings-in-a-text-file)

relace text between `#start` and `#end` tag in file myconfig

    ...

    #start
    FirewallRuleSet global {
        FirewallRule allow tcp to google.com
        FirewallRule allow tcp to facebook.com

    #more rules
    }
    #end

    FirewallRuleSet known-users {
        FirewallRule allow to 0.0.0.0/0
    }

    ...

### replace "allow" with "deny"

    sed -i '/#start/,/#end/s/allow/deny/' myconfig

### replace whole text

    sed -i '/#start/,/#end/c\
    #start\
    FirewallRuleSet global {\
        FirewallRule allow tcp to google.com\
        FirewallRule deny tcp to facebook.com\
                          ︙                 \
    \
    #more rules\
    }\
    #end' myconfig

## [Replace a string including a slash "/" using sed command](https://unix.stackexchange.com/questions/382077/replace-a-string-including-a-slash-using-sed-command/382079)

- escape `/` symbol:

      sed -i 's/I1Rov4Rvh\/GtjpuuYttr==/mytest/g'

- use another separator:

      sed -i 's|I1Rov4Rvh/GtjpuuYttr==|mytest|g'
      sed -i 's:I1Rov4Rvh/GtjpuuYttr==:mytest:g'

## [Use sed on a string variable rather than a file](https://askubuntu.com/a/595277)

    ~$ x="$PATH"
    ~$ x="$(echo $x | sed 's/:/ /g')"
    ~$ echo "$x"
    /usr/local/bin /usr/bin /bin /usr/local/games /usr/games
