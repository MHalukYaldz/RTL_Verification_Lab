# UART TX Parity and Stop Bit Verification

This project implements and verifies a UART transmitter using SystemVerilog.

The UART TX design converts 8-bit parallel data into a serial UART frame consisting of a start bit, eight data bits, an odd parity bit, and a stop bit. The testbench applies randomized input data and checks each part of the transmitted frame.

## UART TX RTL Design

The transmitter uses the following inputs and outputs:

* `clk` – System clock
* `rst` – Reset
* `newd` – Starts a new transmission
* `tx_data[7:0]` – Parallel data input
* `tx` – Serial UART output
* `donetx` – Transmission completion indication

The UART frame format used in this design is:

```text
Idle | Start | D0 | D1 | D2 | D3 | D4 | D5 | D6 | D7 | Odd Parity | Stop
  1  |   0   |                8-bit Data                |     P      |  1
```

Data bits are transmitted **LSB first**.

<img width="361" height="241" alt="UART_TX_Parity_StopBit_Verification_Block_Diagram" src="https://github.com/user-attachments/assets/3434d0a4-1c06-46b8-84ee-48c740f34f5c" />


## Configuration

```text
System Clock : 1 MHz
Baud Rate    : 9600
Data Width   : 8 bits
Parity       : Odd
Stop Bit     : 1
```

Odd parity is generated using:

```systemverilog
parity <= ~^tx_data;
```

## Verification

The testbench generates randomized 8-bit data and verifies the UART frame at the transmitter output.

For each transaction, the following conditions are checked:

* Start bit is `0`
* Eight transmitted data bits match `tx_data`
* Data is transmitted LSB first
* Odd parity bit matches the expected parity
* Stop bit is `1`
* `donetx` indicates transmission completion

Five randomized UART transmissions are tested.

## Simulation Waveform

The waveform shows the randomized parallel input data, UART serial output, parity values, reconstructed testbench data, and transmission completion signal.

<img width="1837" height="221" alt="UART_TX_Parity_StopBit_Verification_Waveform" src="https://github.com/user-attachments/assets/65937309-ff25-4e95-9105-860afd9ffbb5" />


## Simulation Results

All five randomized transactions successfully passed the start bit, data, parity, stop bit, and transmission completion checks.

Example verification output:

```text
Start Bit Pass
Data Match!!!!!!!
Parity Pass
Stop Bit Pass
Transmission Complete
```

<img width="203" height="482" alt="UART_TX_Parity_StopBit_Verification_Console" src="https://github.com/user-attachments/assets/e356b3e6-bd0b-471c-a5ce-8f43f1863ba0" />


## Result

The simulation verifies that the UART transmitter correctly generates:

* Start bit
* 8-bit LSB-first serial data
* Odd parity
* Stop bit
* Transmission completion indication

All tested randomized data frames completed successfully.
