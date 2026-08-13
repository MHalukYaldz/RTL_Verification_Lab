# FIFO Fill and Drain Verification

This study verifies a complete FIFO fill-and-drain sequence.

A fixed sequence of write operations is used to fill the FIFO, followed by read operations that drain the stored data. The scoreboard checks that the FIFO preserves the expected data order.

## Verification Scope

* Complete FIFO fill sequence
* Complete FIFO drain sequence
* Write and read transaction execution
* FIFO `full` and `empty` flag observation
* FIFO data ordering verification
* Scoreboard-based data comparison
* Driver and scoreboard synchronization

## Testbench Structure

The verification environment includes:

* **Transaction** — Stores FIFO transaction data
* **Driver** — Applies the fill and drain sequences to the DUT
* **Monitor** — Captures FIFO output data
* **Scoreboard** — Compares the received data with the expected sequence
* **Environment** — Connects and coordinates the verification components

SystemVerilog events are used to synchronize the driver and scoreboard during the verification sequence.

## Simulation Waveform

The waveform below shows a complete FIFO fill-and-drain sequence. The FIFO is filled with write operations and then emptied with read operations while preserving data order.

<img width="1837" height="180" alt="03_Fill_Drain_Verification_fifo_fill_drain_verification_waveform" src="https://github.com/user-attachments/assets/afb55aaa-61bf-4aff-a7ea-c65f505aa12e" />
