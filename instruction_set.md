# Instruction set

This `shitty_cpu` supports four types of instructions:
* register to register
* memory to register
* register to memory
* conditional

## register to register

The instruction byte is of the format:

```
TT DDD SSS
```
here:
* T - type bits, always "00"
* D - destination bits
    * "001" - register a
    * "010" - register b
    * "100" - program counter

* S - source bits
    * "000" - register a
    * "001" - register b
    * "010" - alu out
    * "011" - operand byte
    * "100" - program counter
    * "101" - program counter + 1
    * "110" - program counter + 2
    * "111" - const zero


* `LOAD_A` Immediate8
* `LOAD_B` Immediate8
* `ADD_TO_A`
* `ADD_TO_B`
* `JUMP` <Addr8>

## memory to register

The instruction byte is of the format:

```
TT DDD SSS
```

Here:
* T - type bits, always "01"
* D - destination bits, same as register to register
* S - source of the address, meaning is the same as register to register instructions

* `LOAD_A` Addr8
* `LOAD_B` Addr8

## register to memory

The instruction byte is of the format:

```
TT AAA SSS
```

Here:
* T - type bits, always "10"
* A - source of the address value, meaning is the same as register to register source value
* S - source of the data value, meaning is the same as register to register source value

* `STORE_A` Addr8
* `STORE_B` Addr8

## Conditional type:

The instruction byte is of the format:

```
TT XXXXXX
```
Here:
* T - type bits, always "10"
* X - Dont care

* `JUMP` IF ZERO <Addr8>
