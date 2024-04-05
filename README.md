# adc124s021-spin 
--------------

This is a P8X32A/Propeller, P2X8C4M64P/Propeller 2 driver object for the TI ADC124S021.

**IMPORTANT**: This software is meant to be used with the [spin-standard-library](https://github.com/avsa242/spin-standard-library) (P8X32A) or [p2-spin-standard-library](https://github.com/avsa242/p2-spin-standard-library) (P2X8C4M64P). Please install the applicable library first before attempting to use this code, otherwise you will be missing several files required to build the project.


## Salient Features

* SPI connection

| Processor | Fsys      | FlexSpin backend | Effective bus speed |
|-----------|-----------|------------------|---------------------|
| P1        | 80MHz     | bytecode         | 14.6kHz             |
| P1        | 80MHz     | PASM             | 1.42MHz             |
| P2        | 180MHz    | bytecode         | 78kHz               |
| P2        | 180MHz    | PASM2            | 775kHz              |


## Requirements

P1/SPIN1:
* spin-standard-library
* signal.adc.common.spinh (provided by the spin-standard-library)

P2/SPIN2:
* p2-spin-standard-library


## Compiler Compatibility

| Processor | Language | Compiler               | Backend      | Status                |
|-----------|----------|------------------------|--------------|-----------------------|
| P1        | SPIN1    | FlexSpin (6.9.1)       | Bytecode     | OK                    |
| P1        | SPIN1    | FlexSpin (6.9.1)       | Native/PASM  | OK                    |
| P2        | SPIN2    | FlexSpin (6.9.1)       | NuCode       | OK (Untested)         |
| P2        | SPIN2    | FlexSpin (6.9.1)       | Native/PASM2 | OK (Untested)         |

(other versions or toolchains not listed are __not supported__, and _may or may not_ work)


## Hardware compatibility

* Tested with the Parallax Activity board (WX), #32912


## Limitations

* Very early in development - may malfunction, or outright fail to build
* Not optimized

