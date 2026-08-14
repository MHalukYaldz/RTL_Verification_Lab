# D Flip-Flop Verification

SystemVerilog verification work for a D Flip-Flop, progressing from randomized functional verification to unknown (`X`) input behavior and handling.

## Projects

### 01 – Random Verification

Class-based verification of basic D Flip-Flop functionality.

**Verification scope:**

* Random input stimulus
* Reset behavior
* Input/output data transfer
* DUT output monitoring
* Expected vs. actual output comparison

### 02 – X Input Test

Verification of DUT behavior when an unknown (`X`) value is applied to the data input.

**Verification scope:**

* `X` input stimulus
* DUT response monitoring
* Unknown-value behavior
* Scoreboard comparison

### 03 – X Input Handling

Verification of the modified D Flip-Flop behavior for handling unknown input values.

**Verification scope:**

* Controlled `X` stimulus
* Defined output behavior for unknown input
* Expected vs. monitored result comparison
* Self-checking verification

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

* Randomized stimulus generation
* Class-based testbench architecture
* Reset verification
* Unknown-value testing
* Self-checking comparisons
