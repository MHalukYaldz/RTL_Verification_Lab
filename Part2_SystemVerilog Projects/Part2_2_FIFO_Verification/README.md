# FIFO Verification

SystemVerilog verification work for a FIFO design, covering randomized traffic, boundary conditions, and complete fill/drain operation.

## Projects

### 01 – Random Read/Write Verification

Class-based verification using randomized FIFO read and write operations.

**Verification scope:**

* Random write requests
* Random read requests
* Input/output data monitoring
* FIFO data ordering
* Expected vs. actual data comparison

### 02 – Full / Empty Boundary Test

Verification of FIFO boundary conditions.

**Verification scope:**

* Full flag behavior
* Empty flag behavior
* Write behavior near the full condition
* Read behavior near the empty condition
* Boundary-state monitoring

### 03 – Fill / Drain Verification

Verification of complete FIFO fill and drain sequences.

**Verification scope:**

* Write until FIFO becomes full
* Read until FIFO becomes empty
* Full-to-empty state transition
* Stored data ordering
* Output data comparison

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

* Random stimulus
* FIFO status flags
* Data integrity and ordering
* Boundary-condition testing
* Self-checking scoreboard
* Fill/drain sequences

## Simulation

Simulation waveforms are included to observe FIFO data flow and `full` / `empty` behavior.
