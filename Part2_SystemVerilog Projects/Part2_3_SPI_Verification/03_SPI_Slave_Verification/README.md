# SPI Slave Verification

This study verifies data transfer from an SPI master to an SPI slave using a class-based SystemVerilog verification environment.

Randomized 12-bit input values are transmitted by the SPI master and reconstructed by the slave. The received data is monitored and compared with the original transmitted value using a scoreboard.

## Verification Scope

* Randomized 12-bit input data
* SPI master-to-slave transmission
* Serial data reception
* Slave output reconstruction
* Transfer completion using the `done` signal
* Transmitted and received data comparison

## Testbench Structure

The verification environment includes:

* **Transaction** — Stores transmitted and received data
* **Generator** — Generates randomized input transactions
* **Driver** — Applies transactions to the SPI system
* **Monitor** — Captures the completed slave output
* **Scoreboard** — Compares transmitted and received data
* **Environment** — Connects and coordinates the verification components

## Testbench Architecture

The diagram below shows the communication and synchronization flow between the verification components, interface, and DUT.

<img width="1151" height="783" alt="spi_slave_testbench_diagram" src="https://github.com/user-attachments/assets/9f49d555-a6f3-492b-a282-e79d23a5caad" />


## Simulation Waveform

The waveform below shows multiple SPI master-to-slave transfers. The slave reconstructs each 12-bit value, while the `done` signal indicates the completion of each reception.

<img width="1837" height="160" alt="spi_slave_verification_waveform" src="https://github.com/user-attachments/assets/eb10e8aa-e8ba-41c5-83bb-1580d191e928" />

