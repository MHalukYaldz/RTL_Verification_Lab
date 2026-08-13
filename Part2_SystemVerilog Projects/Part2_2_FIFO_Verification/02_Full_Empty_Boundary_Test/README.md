# FIFO Full/Empty Boundary Test

This study focuses on verifying FIFO behavior at its full and empty boundaries.

The FIFO is first written until the `full` flag is asserted. The stored data is then read until the `empty` flag is asserted.

## Verification Scope

* Sequential write operations until FIFO full condition
* Detection of the `full` flag
* Sequential read operations until FIFO empty condition
* Detection of the `empty` flag
* FIFO data ordering verification
* Boundary behavior observation

## Testbench Structure

The verification environment includes:

* **Transaction** — Stores FIFO data and operation information
* **Generator** — Provides transaction objects used by the verification environment
* **Driver** — Performs write-until-full and read-until-empty sequences
* **Monitor** — Observes FIFO output and status signals
* **Scoreboard** — Checks the received data against the expected FIFO sequence
* **Environment** — Coordinates the verification components

The driver contains separate sequences for exercising the full and empty boundary conditions.

## Simulation Waveform

The waveform below shows FIFO boundary behavior. Data is written until the FIFO becomes full, and then read until the FIFO becomes empty.

<img width="1836" height="179" alt="02_Full_Empty_Boundary_Test_fifo_full_empty_boundary_test_waveform" src="https://github.com/user-attachments/assets/609be1a3-c267-49bb-9c4a-2760252ac5ba" />
