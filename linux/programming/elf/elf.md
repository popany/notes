# ELF

- [ELF](#elf)
  - [check symbols](#check-symbols)
  - [strip symbols](#strip-symbols)

## check symbols

- `nm -gDC <file>`

  - `-C` option demangle the symbols

- `objdump -TC <file>`

  `objdump -tC <file>`

  - `-t, --syms`
    
    Display the contents of the symbol table(s)

  - `-T, --dynamic-syms`

    Display the contents of the dynamic symbol table

- `readelf -Ws <file>`

  - `-W --wide`

    Allow output width to exceed 80 characters

  - `-s --syms`

    Display the symbol table

- `readelf -Ws --dyn-syms <file>`

  - `--dyn-syms`

    Displays the entries in dynamic symbol table section of the file, if it has one. The output format is the same as the format used by the `--syms` option

## strip symbols

- `strip -s <file>`
