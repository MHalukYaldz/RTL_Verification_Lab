# SPI Master MOSI Verification

This study verifies serial MOSI data transmission from an SPI master.

A randomized 12-bit input value is transmitted through the MOSI line. The transmitted bits are sampled and reconstructed in the testbench, and the resulting value is compared with the original input data.

## Verification Scope

* Random 12-bit input generation
* SPI transaction start using chip select
* LSB-first MOSI transmission
* Serial data sampling
* Bit-by-bit data reconstruction
* Transmitted and reconstructed data comparison

## Simulation Waveform

The waveform below shows a 12-bit input value being transmitted serially through MOSI and reconstructed as `mosi_out`.

<img width="1837" height="181" alt="spi_master_mosi_verification_waveform" src="https://github.com/user-attachments/assets/89193ae7-d786-45ee-a1a8-13d82b2ddaf6" />

