# SPI Verification

SystemVerilog verification work for SPI communication, progressing from MOSI serial-data checking to class-based SPI Master and Slave verification environments.

## Projects

### 01 – SPI Master MOSI Verification

Verification of serial data transmitted by the SPI Master through the MOSI line.

**Verification scope:**

* Chip Select (`CS`) behavior
* MOSI serial transmission
* SCLK-based data sampling
* Serial data reconstruction
* Parallel input vs. reconstructed serial data comparison

### 02 – SPI Master Verification

Class-based verification environment for the SPI Master.

**Verification scope:**

* Randomized parallel input data
* SPI transaction generation
* MOSI monitoring
* Serial data reconstruction
* Expected vs. monitored data comparison
* Transaction synchronization

**Testbench flow:**

`Generator → Driver → SPI Master → Monitor → Scoreboard`

### 03 – SPI Slave Verification

Class-based verification work for SPI Master/Slave communication.

**Verification scope:**

* SPI serial communication
* Master-to-Slave data transfer
* Received data monitoring
* Transaction synchronization
* Expected vs. received data comparison

## Verification Components

* Transaction
* Generator
* Driver
* Monitor
* Scoreboard
* Environment
* Mailboxes
* Events
* Virtual interface

## Verification Focus

* Randomized transaction generation
* Serial protocol monitoring
* MOSI data reconstruction
* Master/Slave communication
* Self-checking scoreboard
* Class-based testbench architecture

## Testbench Architecture

Architecture diagrams are included for the SPI Master and SPI Slave verification environments.
