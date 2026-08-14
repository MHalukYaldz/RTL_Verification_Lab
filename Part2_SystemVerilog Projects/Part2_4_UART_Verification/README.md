# UART Verification

SystemVerilog verification work for UART transmitter and receiver designs.

This section contains UART verification implementations ranging from class-based TX/RX verification to UART frame-level checks including parity and stop-bit verification.

## Projects

### 01 – Class-Based UART Verification

Class-based verification environment for UART TX and RX.

**Verification components:**

* Transaction
* Generator
* Driver
* Monitor
* Scoreboard
* Environment
* Mailboxes
* Events
* Virtual interface

**Verification scope:**

* Randomized TX and RX transactions
* UART transmitter verification
* UART receiver verification
* Serial/parallel data handling
* Expected vs. monitored data comparison
* Self-checking scoreboard

TX and RX paths are verified independently.

---

### 02 – UART TX Parity and Stop Bit Verification

UART transmitter verification including complete frame-level checks.

**UART frame:**

`Start Bit → 8-bit Data → Odd Parity → Stop Bit`

**Verification scope:**

* Randomized 8-bit transmit data
* Start bit verification
* LSB-first data transmission
* Transmitted data reconstruction
* Odd parity verification
* Stop bit verification
* Transmission completion check

### Class-Based Verification – In Progress

The parity and stop-bit verification is currently being extended into a class-based verification environment using:

* Transaction
* Generator
* Driver
* Monitor
* Scoreboard
* Environment
* Mailbox communication
* Event synchronization
* Virtual interface

The goal is to verify the UART TX frame using reusable verification components and self-checking comparisons.

## Configuration

| Parameter    | Value  |
| ------------ | ------ |
| System Clock | 1 MHz  |
| Baud Rate    | 9600   |
| Data Width   | 8 bits |
| Parity       | Odd    |
| Stop Bit     | 1      |

## Verification Focus

* Randomized stimulus generation
* Class-based testbench architecture
* Serial protocol monitoring
* Frame reconstruction
* Expected vs. actual data comparison
* Self-checking verification
