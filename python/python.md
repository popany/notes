# Python

- [Python](#python)
  - [Basic](#basic)
    - [Iterate over files](#iterate-over-files)
      - [`glob`](#glob)
    - [format print list](#format-print-list)
    - [get/set environment virable](#getset-environment-virable)
  - [regular expression](#regular-expression)
    - [replace](#replace)
  - [HTTP](#http)
  - [JSON](#json)
  - [matplotlib](#matplotlib)
  - [`datetime`](#datetime)
  - [HowTo](#howto)
    - [Access Hive](#access-hive)

## Basic

[How to read a file line-by-line into a list?](https://stackoverflow.com/questions/3277503/how-to-read-a-file-line-by-line-into-a-list)

[Argparse Tutorial](https://docs.python.org/3/howto/argparse.html)

[Manually raising (throwing) an exception in Python](https://stackoverflow.com/questions/2052390/manually-raising-throwing-an-exception-in-python)

[Accessing the index in 'for' loops?](https://stackoverflow.com/questions/522563/accessing-the-index-in-for-loops)

### Iterate over files

[How can I iterate over files in a given directory?](https://stackoverflow.com/questions/10377998/how-can-i-iterate-over-files-in-a-given-directory)

#### [`glob`](https://docs.python.org/3/library/glob.html)

    import glob
    glob.glob('*.gif')

### format print list

    a = [1, 2, 3, 4, 5]
    print(*a, sep = "\n")

### get/set environment virable

    import os
    path = os.getenv("PATH")
    os.environ['path'] = 'C:\\tmp;' + os.environ['path']

## regular expression

[tutorialspoint Python 3 - Regular Expressions](https://www.tutorialspoint.com/python3/python_reg_expressions.htm)

[Regular Expression HOWTO](https://docs.python.org/3/howto/regex.html)

### replace

    re.sub(pattern, repl, string, count=0, flags=0)

## HTTP

[How to send POST request?](https://stackoverflow.com/questions/11322430/how-to-send-post-request)

[Request Authentication](https://2.python-requests.org/en/master/user/authentication/)

## JSON

[How to parse JSON in Python?](https://stackoverflow.com/questions/7771011/how-to-parse-json-in-python)

## matplotlib

show version

    print('matplotlib: {}'.format(matplotlib.__version__))

[Major and minor ticks](https://matplotlib.org/3.1.0/gallery/ticks_and_spines/major_minor_demo.html)

[Date tick labels](https://matplotlib.org/3.1.0/gallery/text_labels_and_annotations/date.html)

[Custom tick formatter for time series](https://matplotlib.org/3.1.0/gallery/text_labels_and_annotations/date_index_formatter.html)

[Date Index Formattercbook](https://matplotlib.org/3.1.0/gallery/ticks_and_spines/date_index_formatter2.html)

[Date Demo Convert](https://matplotlib.org/3.1.0/gallery/ticks_and_spines/date_demo_convert.html)

[Date Demo Rrule](https://matplotlib.org/gallery/ticks_and_spines/date_demo_rrule.html)

[Gallery](https://matplotlib.org/gallery/index.html)

[Writing numerical values on the plot with Matplotlib](https://stackoverflow.com/questions/6282058/writing-numerical-values-on-the-plot-with-matplotlib)

## `datetime`

[Python strftime - date without leading 0?](https://stackoverflow.com/questions/904928/python-strftime-date-without-leading-0)

## HowTo

### Access Hive

[How to Access Hive via Python?](https://stackoverflow.com/questions/21370431/how-to-access-hive-via-python)

[Kerberos (hive/presto) access documentation](https://github.com/dropbox/PyHive/issues/174)
