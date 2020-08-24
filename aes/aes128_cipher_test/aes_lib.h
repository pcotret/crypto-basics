/* File:        aes_lib.h
 * Author:      Pascal Cotret <pascal.cotret@ensta-bretagne.fr>
 * Description: Function prototypes for AES encryption
 */

// Libraries
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

// Constants
#define Nk 4
#define Nb 4
#define Nr 10

// Functions prototypes
void RotLine(uint8_t msg[4]);
void KeyExpansion(uint8_t cipher_key[4*Nk],uint8_t round_key[Nr+1][4*Nb]);
void AddRoundKey(uint8_t input_msg[4*Nb],uint8_t key[4*Nb]);
int SubBytes(uint8_t input_msg[4*Nb]);
void RotMatrix(int lineNumber,uint8_t msg[4*Nb]);
void ShiftRows(uint8_t input_msg[4*Nb]);
uint8_t gmult(uint8_t a, uint8_t b);
void MixColumns(uint8_t input_msg[4*Nb]);
void Cipher(uint8_t input_msg[4*Nb],uint8_t cipher_key[4*Nb]);
