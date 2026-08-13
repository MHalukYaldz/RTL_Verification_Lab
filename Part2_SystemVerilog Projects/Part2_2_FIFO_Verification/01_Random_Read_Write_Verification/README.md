# Random Read/Write FIFO Verification

This study verifies the basic read and write behavior of a FIFO using randomized operation selection.

A SystemVerilog verification environment is used to generate FIFO transactions, drive the DUT inputs, monitor the output, and compare the received data with reference data stored in a queue.

## Verification Scope

* Random read and write operation selection
* Random input data generation
* FIFO `empty` and `full` flag observation
* FIFO data ordering verification
* Queue-based reference data handling
* Data comparison using a scoreboard

## Testbench Structure

The verification environment includes:

* **Transaction** — Stores FIFO operation and data information
* **Generator** — Generates randomized transactions
* **Driver** — Applies read/write operations and input data to the DUT
* **Monitor** — Observes FIFO output and status signals
* **Scoreboard** — Compares FIFO output against the expected data
* **Environment** — Connects and controls the verification components

Communication between components is implemented using SystemVerilog mailboxes and events.

## Simulation Waveform

The waveform below shows randomized FIFO read and write activity. The simulation demonstrates data transfer through the FIFO and basic `empty` flag behavior.

<img width="1837" height="179" alt="01_Random_Read_Write_Verification_fifo_random_read_write_verification_waveform" src="https://github.com/user-attachments/assets/f3ae6ed3-e3d6-4f76-84a9-5e73b0ebcf0e" />
