# Instruction set

This `shitty_cpu` supports four types of instructions:
* register to register
* memory to register
* register to memory
* conditional

## register to register

The instruction byte is of the format:

```
TT XDD SSS
```
here:
* T - type bits, always "00"
* X - Don't care
* D - destination bits
    * "00" - register a
    * "01" - register b
    * "10" - perform ALU operation
    * "11" - program counter

* S - source bits
    * "000" - register a
    * "001" - register b
    * "010" - alu out
    * "011" - operand byte
    * "100" - program counter
    * "101" - reserved
    * "110" - reserved
    * "111" - alu output

### Examples
```
MOV A, B         00000001
MOV B, A         00001000
JMP <op>         00011011
JMP A            00011000
```



## memory to register

The instruction byte is of the format:

```
TT XDD SSS
```

Here:
* T - type bits, always "01"
* X - Don't care
* D - destination bits, same as register to register
* S - source of the address. These bits values has the same meaning as register to register

### Examples
```
MOV A, [<op>]    01000011
MOV B, [A]       01001000
JMP [<op>]       01011011
JMP [A]          01011000
```

## register to memory

The instruction byte is of the format:

```
TT AAA SSS
```

Here:
* T - type bits, always "10"
* A - source of the address value. These bits values has the same meaning as register to register S bits values
* S - source of the data value. These bits values has the same meaning as register to register S bits values

### Examples
```
MOV [<op>], A  10011000
MOV [A], B     10000001
MOV [ACC], B   10010001
```

## Conditional type:

The instruction byte is of the format:

```
TT XXXXXX
```
Here:
* T - type bits, always "11"
* X - Dont care

### Examples
```
JZ <op>          11000000
```
