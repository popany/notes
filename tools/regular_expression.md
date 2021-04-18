# Regular Expression

- [Regular Expression](#regular-expression)
  - [Replace](#replace)
    - [Replace to upper case](#replace-to-upper-case)
      - [To lower case](#to-lower-case)
    - [remove duplicate lines](#remove-duplicate-lines)
      - [Match All Lines That Are Not Repeated](#match-all-lines-that-are-not-repeated)
      - [Replace All Repeated Lines](#replace-all-repeated-lines)

## Replace

### Replace to upper case

Find:

    ([a-z]+)

Replace:

    \U\1\E

The `\U` will cause all following chars to be upper

The `\E` will turn off the `\U`

#### To lower case

    \L\1\E

### [remove duplicate lines](https://stackoverflow.com/questions/24734796/extract-all-unique-lines)

Two nearly identical options:

#### Match All Lines That Are Not Repeated

    (?sm)(^[^\r\n]+$)(?!.*^\1$)

The lines will be matched, but to extract them, you really want to replace the other ones.

#### Replace All Repeated Lines

This will work better in Notepad++:

Search:

    (?sm)(^[^\r\n]*)[\r\n](?=.*^\1)

Replace: empty string

- `(?s)` activates `DOTALL` mode, allowing the dot to match across lines

- `(?m)` turns on multi-line mode, allowing `^` and `$` to match on each line

- `(^[^\r\n]*)` captures a line to Group 1, i.e.

- The `^` anchor asserts that we are at the beginning of the string

- `[^\r\n]*` matches any chars that are not newline chars

- `[\r\n]` matches the newline chars

- The lookahead `(?!.*^\1$)` asserts that we can match any number of characters `.*`, then...

- `^\1$` the same line as Group 1
