# SymPy

- [SymPy](#sympy)
  - [SymPy Tutorial](#sympy-tutorial)
  - [Practice](#practice)

## [SymPy Tutorial](https://docs.sympy.org/latest/tutorial/index.html)





## Practice

    from sympy import *

    r, s, d = symbols('r s d')

    d = r - cos(s/r)*r

    d.subs(r, 10).subs(s, 1).evalf()

    solve(d.subs(r, 50) - 0.1)

    nsolve(d.subs(s, 10) - 0.1, r, 10)


