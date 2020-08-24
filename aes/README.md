# AES implementations
## `aes128_cipher_test`

* Just a C implementation of the NIST standard without countermeasures.
* It takes a "hardcoded" input message and key and print the output message.

### Profiling

| time | seconds | seconds | calls | Ts/call | Ts/call | name           |
| ---- | ------- | ------- | ----- | ------- | ------- | -------------- |
| 0.00 | 0.00    | 0.00    | 576   | 0.00    | 0.00    | `gmult`        |
| 0.00 | 0.00    | 0.00    | 30    | 0.00    | 0.00    | `RotMatrix`    |
| 0.00 | 0.00    | 0.00    | 11    | 0.00    | 0.00    | `AddRoundKey`  |
| 0.00 | 0.00    | 0.00    | 10    | 0.00    | 0.00    | `RotLine`      |
| 0.00 | 0.00    | 0.00    | 10    | 0.00    | 0.00    | `ShiftRows`    |
| 0.00 | 0.00    | 0.00    | 10    | 0.00    | 0.00    | `SubBytes`     |
| 0.00 | 0.00    | 0.00    | 9     | 0.00    | 0.00    | `MixColumns`   |
| 0.00 | 0.00    | 0.00    | 1     | 0.00    | 0.00    | `Cipher`       |
| 0.00 | 0.00    | 0.00    | 1     | 0.00    | 0.00    | `KeyExpansion` |

- 10 calls for `RotLine`, `ShiftRows`, `SubBytes`: one for each round.
- No `MixColumns` in the last round. 
- `AddRoundKey` called before the first round.

## References

- [Rijndael inspector](http://www.formaestudio.com/rijndaelinspector/): Flash animation, always usefule for a step-by-step approach.
- [FIPS 197](https://nvlpubs.nist.gov/nistpubs/FIPS/NIST.FIPS.197.pdf): the official NIST document. Includes test vectors.