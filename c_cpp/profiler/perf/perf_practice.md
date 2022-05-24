# perf practice

- [perf practice](#perf-practice)
  - [install perf in docker](#install-perf-in-docker)
  - [perf top](#perf-top)
  - [perf report -g](#perf-report--g)
  - [火焰图带符号](#火焰图带符号)

## [install perf in docker](https://stackoverflow.com/a/48672750)

just do

    apt-get install linux-tools-generic

and make a symbolic link to /usr/bin/perf. (in my case):

    ln -s /usr/lib/linux-tools/3.13.0-141-generic/perf /usr/bin/perf

## perf top

    perf top -g -p <pid>

## perf report -g

参考: [CppCon 2015: Chandler Carruth "Tuning C++: Benchmarks, and CPUs, and Compilers! Oh My!"](https://www.youtube.com/watch?v=nXaxk27zwlk)

    perf record -g <executalbe-file>
    perf report -g
    perf report -g 'graph,0.5,caller'

## 火焰图带符号

编译选项

    -fno-omit-frame-pointer

[Profiling Software Using perf and Flame Graphs](https://www.percona.com/blog/2019/11/20/profiling-software-using-perf-and-flame-graphs/)

    git clone https://github.com/brendangregg/FlameGraph

    perf record -a -F 99 -g --call-graph dwarf -p <pid> -- sleep 120

    perf script > perf.script

    ./FlameGraph/stackcollapse-perf.pl perf.script | ./FlameGraph/flamegraph.pl > flamegraph.svg

