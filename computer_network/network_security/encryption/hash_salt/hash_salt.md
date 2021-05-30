# Hash Salt

- [Hash Salt](#hash-salt)

## [Adding Salt to Hashing: A Better Way to Store Passwords](https://auth0.com/blog/adding-salt-to-hashing-a-better-way-to-store-passwords/)

According to [OWASP Guidelines](https://owasp.org/www-project-cheat-sheets/cheatsheets/Password_Storage_Cheat_Sheet.html#salting), a salt is a value generated by a [cryptographically secure function](https://cheatsheetseries.owasp.org/cheatsheets/Cryptographic_Storage_Cheat_Sheet.html) that is added to the input of hash functions to create unique hashes for every input, regardless of the input not being unique.

...

In practice, we store the salt in cleartext along with the hash in our database. We would store the salt `f1nd1ngn3m0`, the hash `07dbb6e6832da0841dd79701200e4b179f1a94a7b3dd26f612817f3c03117434`, and the username together so that when the user logs in, we can lookup the username, append the salt to the provided password, hash it, and then verify if the stored hash matches the computed hash.

Now we can see why it is very important that each input is salted with unique random data. When the salt is unique for each hash, we inconvenience the attacker by now having to compute a hash table for each user hash. This creates a big bottleneck for the attacker. Ideally, we want the salt to be truly random and unpredictable to bring the attacker to a halt.

While the attacker may be able to crack one password, cracking all passwords will be unfeasible. Regardless, when a company experiences a data breach, it is impossible to determine which passwords could have been cracked and therefore all passwords must be considered compromised. A request to all users to change their passwords should be issued by the company right away. Upon password change, a new salt should be generated for each user as well.

"If someone breaches into a company database, the company must react as if all passwords were cracked, even if hashing the passwords involved using a salt."