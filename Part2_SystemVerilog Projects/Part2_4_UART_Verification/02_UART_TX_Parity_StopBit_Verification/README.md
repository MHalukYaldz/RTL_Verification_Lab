# UART TX Parity and Stop Bit Verification

This project verifies a UART transmitter using both **procedural** and **class-based SystemVerilog verification** approaches.

The UART transmitter accepts 8-bit parallel data and converts it into a serial UART frame containing:

* Start bit
* 8 data bits
* Odd parity bit
* Stop bit

The class-based testbench extends the initial procedural verification into a structured verification environment using Transaction, Generator, Driver, Monitor, Scoreboard, mailboxes, events, and a virtual interface.

---

## UART TX Design

The UART TX module receives transmit data through `tx_data[7:0]`.

When `newd` is asserted, the transmitter starts a UART transmission and serializes the data on the `tx` output.

The `donetx` signal indicates that the transmission has completed.

### UART TX Block Diagram

The following block diagram shows the main input and output signals of the UART transmitter used in this verification study.

<img width="361" height="241" alt="UART_TX_Parity_StopBit_Verification_Block_Diagram" src="https://github.com/user-attachments/assets/0679659c-d660-4ad9-bbb0-51139c3e351c" />


### UART Frame Format

```text
Idle | Start | D0 | D1 | D2 | D3 | D4 | D5 | D6 | D7 | Odd Parity | Stop
  1  |   0   |                8-bit Data             |      P      |  1
```

The data bits are transmitted **LSB first**.

### Configuration

| Parameter    | Value     |
| ------------ | --------- |
| System Clock | 1 MHz     |
| Baud Rate    | 9600      |
| Data Width   | 8 bits    |
| Bit Order    | LSB First |
| Parity       | Odd       |
| Stop Bit     | 1         |

Odd parity is generated in the DUT using:

```systemverilog
parity <= ~^tx_data;
```

---

# Procedural Verification

The first verification approach uses a procedural SystemVerilog testbench.

Randomized 8-bit data is applied to the UART transmitter and the serial `tx` output is monitored according to the UART frame timing.

The procedural verification checks:

* UART transmission behavior
* 8-bit serial data transmission
* Reconstructed transmitted data
* Odd parity bit
* Stop bit
* Transmission completion

The transmitted serial data is reconstructed from the `tx` line and compared with the original transmitted data.

The expected odd parity is calculated from the transmitted data and compared with the parity bit observed on the UART output.

The stop bit is also checked to verify that the UART frame terminates at logic `1`.

---

## Procedural Simulation Output

The simulation console shows the transmitted data and the corresponding verification results.

<img width="203" height="482" alt="Procedural_Console_Output" src="https://github.com/user-attachments/assets/a349d584-cc55-4e73-83b1-f640aab0167d" />


---

## Procedural Simulation Waveform

The waveform shows the UART transmission and related control signals during procedural verification.

<img width="1837" height="221" alt="Procedural_Waveform" src="https://github.com/user-attachments/assets/e2732795-99d2-4e93-96a4-485b832a7a52" />


---

# Class-Based Verification

The UART TX verification was then implemented using a **class-based SystemVerilog testbench**.

The verification environment contains:

* Transaction
* Generator
* Driver
* Monitor
* Scoreboard
* Environment
* Mailboxes
* Event synchronization
* Virtual interface

The class-based structure separates stimulus generation, DUT driving, output monitoring, and result checking into individual verification components.

---

## Verification Flow

```text
Generator
    |
    | Transaction
    v
 Driver -------------------------> Scoreboard
    |                              Reference Data
    v
   DUT
    |
    | Serial TX
    v
 Monitor ------------------------> Scoreboard
                                   Observed Data
```

The Driver sends the generated data to both the DUT and the Scoreboard.

The data sent directly to the Scoreboard is used as the **reference data**.

The Monitor independently reconstructs the serial data produced by the DUT and sends the observed results to the Scoreboard.

---

## Transaction

The Transaction class defines the information used by the verification environment.

The UART transmit data is randomized:

```systemverilog
rand bit [7:0] tx_data;
```

The transaction also stores the values captured by the Monitor:

```systemverilog
bit [7:0] received_data;
bit received_parity;
bit received_stop_bit;
```

A `copy()` function is used to create an independent transaction object before transaction information is transferred between verification components.

---

## Generator

The Generator creates randomized UART transmit data:

```systemverilog
assert(tr.randomize());
```

A copy of the transaction is sent to the Driver through a mailbox:

```systemverilog
mbx.put(tr.copy());
```

After sending each transaction, the Generator waits until the Scoreboard completes verification of the current UART frame before producing the next transaction.

---

## Driver

The Driver receives transactions from the Generator and applies them to the DUT through the virtual interface.

The Driver:

* Applies randomized `tx_data`
* Generates the `newd` control pulse
* Synchronizes stimulus with `uclk`
* Sends `tx_data` to the Scoreboard as reference data
* Waits for transmission completion using `donetx`

The DUT inputs are driven away from the DUT sampling edge to avoid race conditions.

```text
Driver -> DUT        : Stimulus
Driver -> Scoreboard : Reference Data
```

---

## Monitor

The Monitor passively observes the serial `tx` output.

The falling edge of `tx` is used to detect the beginning of a UART frame.

After detecting the start of the frame, the Monitor captures:

1. Eight data bits
2. Odd parity bit
3. Stop bit

The transmitted data is reconstructed LSB first:

```systemverilog
tr.received_data[i] = uif.tx;
```

The parity bit is stored in:

```systemverilog
tr.received_parity
```

The stop bit is stored in:

```systemverilog
tr.received_stop_bit
```

After the UART frame has been captured, the Monitor sends a copy of the transaction to the Scoreboard through a mailbox.

---

## Scoreboard

The Scoreboard receives information from two different sources:

```text
Driver  -> Reference / Expected Data
Monitor -> Actual / Observed UART Data
```

It then performs self-checking verification of the UART transmission.

### Data Check

The data reconstructed by the Monitor is compared with the reference data sent by the Driver:

```systemverilog
tr_mon.received_data == ds
```

### Odd Parity Check

The expected odd parity is calculated from the reference data:

```systemverilog
~^ds
```

and compared with the parity bit captured by the Monitor:

```systemverilog
(~^ds) == tr_mon.received_parity
```

### Stop Bit Check

The UART stop bit must be logic `1`:

```systemverilog
tr_mon.received_stop_bit == 1'b1
```

After the data, parity, and stop-bit checks are completed, the Scoreboard signals the Generator to continue with the next transaction.

---

## Class-Based Simulation Result

Five randomized UART TX transactions were executed.

For every transaction:

* Driver reference data matched the data reconstructed by the Monitor
* Odd parity verification passed
* Stop bit verification passed

The simulation completed without data, parity, or stop-bit mismatches.

---

## Class-Based Console Output

The console output shows the verification flow through the Generator, Driver, Monitor, and Scoreboard together with the data, parity, and stop-bit results.

<img width="308" height="707" alt="UART_TX_Class_Based_Console" src="https://github.com/user-attachments/assets/cca1e9ee-8442-44a4-8b9b-ef3a3661d7d0" />


---

## Class-Based Simulation Waveform

The waveform shows the UART TX activity during randomized class-based verification.

The relevant signals include:

* `clk`
* `uclk`
* `rst`
* `newd`
* `tx_data`
* `tx`
* `donetx`

<img width="1838" height="160" alt="UART_TX_Class_Based_Waveform" src="https://github.com/user-attachments/assets/ea2d0ad0-3a52-47c6-b0bf-2b264fffd3d1" />


---

# Verification Comparison

| Feature                         | Procedural | Class-Based |
| ------------------------------- | ---------: | ----------: |
| Randomized TX Data              |          ✓ |           ✓ |
| UART Data Verification          |          ✓ |           ✓ |
| Odd Parity Verification         |          ✓ |           ✓ |
| Stop Bit Verification           |          ✓ |           ✓ |
| Transaction Object              |          — |           ✓ |
| Generator                       |          — |           ✓ |
| Driver                          |          — |           ✓ |
| Monitor                         |          — |           ✓ |
| Scoreboard                      |          — |           ✓ |
| Mailbox Communication           |          — |           ✓ |
| Event Synchronization           |          — |           ✓ |
| Virtual Interface               |          — |           ✓ |
| Reusable Verification Structure |    Limited |           ✓ |

---

# Result

The UART transmitter was successfully verified using both procedural and class-based SystemVerilog testbenches.

The procedural testbench verifies the UART transmission directly, while the class-based testbench separates the verification process into reusable components.

The class-based environment performs self-checking verification of:

* Randomized 8-bit UART transmit data
* Odd parity
* Stop bit

The Driver provides the expected reference data, the Monitor independently reconstructs the serial UART output, and the Scoreboard compares the expected and observed results.
