# awk

- [awk](#awk)
  - [practice](#practice)

## practice

[How to print lines between two patterns, inclusive or exclusive (in sed, AWK or Perl)?](https://stackoverflow.com/questions/38972736/how-to-print-lines-between-two-patterns-inclusive-or-exclusive-in-sed-awk-or)

    awk '/PAT1/{flag=1; next} /PAT2/{flag=0} flag' file


