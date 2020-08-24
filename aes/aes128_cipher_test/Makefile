CC=gcc
CFLAGS=-Wall -pg
LDFLAGS=-pg
EXEC=aes128_cipher_test
SRC= $(wildcard *.c)
OBJ= $(SRC:.c=.o)

all: $(EXEC)

aes128_cipher_test: $(OBJ)
	$(CC) -o $@ $^ $(LDFLAGS)

main.o: aes_lib.h

%.o: %.c
	$(CC) -o $@ -c $< $(CFLAGS)

.PHONY: clean mrproper

clean:
	rm -rf *.o

mrproper: clean
	rm -rf $(EXEC)
