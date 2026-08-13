# SPI Master Verification

This study verifies SPI master serial data transmission using a class-based SystemVerilog verification environment.

Randomized 12-bit transactions are applied to the SPI master. The transmitted MOSI data is monitored and reconstructed, while the scoreboard compares the monitored result with the original input data.

## Verification Scope

* Randomized 12-bit SPI transactions
* SPI master data transmission
* Chip select and serial clock behavior
* MOSI data observation
* Serial data reconstruction
* Scoreboard-based data comparison

## Testbench Structure

The verification environment includes:

* **Transaction** — Stores SPI transaction data
* **Generator** — Generates randomized input transactions
* **Driver** — Applies input data to the SPI master
* **Monitor** — Samples and reconstructs transmitted MOSI data
* **Scoreboard** — Compares reference and monitored data
* **Environment** — Connects and coordinates the verification components

## Testbench Architecture

The diagram below shows the communication flow between the generator, driver, monitor, scoreboard, interface, and DUT.

<img width="1151" height="571" alt="spi_master_testbench_diagram" src="https://github.com/user-attachments/assets/9967bb15-2108-4e0d-b988-ab8111f627c7" />


## Simulation Waveform

The waveform below shows multiple randomized SPI master transactions. The input value changes between transactions while `cs`, `newd`, `sclk`, and `mosi` show the corresponding serial transfer activity.

<img width="1836" height="161" alt="spi_master_verification_waveform" src="https://github.com/user-attachments/assets/6c32d86c-0ac8-4d30-9e26-6869454060ff" />

