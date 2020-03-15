# Regular Expression

## Replace

### Replace to upper case

Find:

    ([a-z]+)

Replace:

    \U\1\E

The `\U` will cause all following chars to be upper

The `\E` will turn off the `\U`
